module c3aud;
import std, miniaudio::ma, avutil;

const String WINDOW_TITLE    = "C3 Audio Station";
const int WINDOW_WIDTH       = 760;
const int WINDOW_HEIGHT      = 600;
const int WINDOW_MIN_WIDTH   = 480;
const int WINDOW_MIN_HEIGHT  = 320;

AppState state;
struct AppState
{
	GfxWindow* win;
	AudioEngine audio;
	MaDevice* device;

	List{PlaylistItem} playlist;
	uint next_token;
	List{int} shuffle_order;
	int shuffle_pos;
	int selected_track_idx;
	int selection_anchor_idx;
	int hovered_track_idx;
	int scroll_row;
	int probe_cursor;
	int unprobed_count;
	bool shuffle_mode;
	bool repeat_mode;
	DefaultRandom rng;
	String soundfont_cli_path;

	// Filter State
	bool filter_active;
	char[64] filter_text;
	sz filter_len;
	List{int} filtered_indices;

	// UI Interaction State
	double last_click_time;
	int last_clicked_idx;
	int drag_source_idx;
	bool is_dragging_item;
	bool drag_active;
	GfxPoint drag_start_pos;
	int drag_target_idx;
	bool is_dragging_timeline;
	bool is_dragging_volume;
	bool is_dragging_scrollbar;
	int scrollbar_drag_offset;
	int last_seek_mouse_x;
	int drop_insert_idx;

	uint flat_shader;
	int loc_flat_col;
	uint dyn_vao;
	uint dyn_vbo;

	uint font_tex;
	uint icon_tex;
	uint text_shader;
	uint text_vao;
	uint text_vbo;
	List{TextVertex} text_verts;
}

alias EmCallback @feat(EMSCRIPTEN | WASM) = fn void();
extern fn void emscripten_set_main_loop(
	EmCallback func,
	int fps,
	int simulate_infinite_loop
) @cname("emscripten_set_main_loop") @feat(EMSCRIPTEN | WASM);

fn void on_repaint(GfxWindow* w, GfxRect rect) => @pool()
{
	(void)rect;
	GfxSize win_sz = w.fetch_size();
	GfxSize px_sz  = w.get_size_in_pixels();
	gl_viewport(0, 0, px_sz.x, px_sz.y);

	gl_clear_color(0.08f, 0.09f, 0.11f, 0.996f);
	gl_color_mask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
	gl_clear(GL_COLOR_BUFFER_BIT);
	gl_color_mask(GL_TRUE, GL_TRUE, GL_TRUE, GL_FALSE);

	UiLayout layout = compute_layout(win_sz);
	draw_oscilloscope(win_sz, &layout);
	draw_ui(win_sz, w.get_mouse(), &layout);

	w.swap_opengl_buffers();
}

fn void dispatch_event(GfxEvent* e)
{
	switch (e.type)
	{
		case WINDOW_RESIZED:
		case SCALE_UPDATED:
			GfxSize px_sz = state.win.get_size_in_pixels();
			gl_viewport(0, 0, px_sz.x, px_sz.y);

		case KEY_PRESSED:
			log::debug("key pressed: val=%d rep=%s", (int)e.key.value, e.key.repeat, category: log::CATEGORY_INPUT);
			bool shift = gfx::is_key_down(SHIFT_L) || gfx::is_key_down(SHIFT_R);

			switch (e.key.value)
			{
				case ESCAPE:
					if (state.filter_active)
					{
						filter_deactivate();
					}
				case BACK_SPACE:
					if (state.filter_active)
					{
						filter_backspace();
					}
				case SPACE:
					if (!state.filter_active && !e.key.repeat)
					{
						toggle_playback();
					}
				case ENTER:
					play_selected_or_first();
				case UP:
					playlist_move_selection(-1, shift);
				case DOWN:
					playlist_move_selection(1, shift);
				case PAGE_UP:
					playlist_move_selection(-compute_layout(state.win.get_size()).visible_rows, shift);
				case PAGE_DOWN:
					playlist_move_selection(compute_layout(state.win.get_size()).visible_rows, shift);
				case HOME:
					playlist_move_selection(-(int)state.playlist.len(), shift);
				case END:
					playlist_move_selection((int)state.playlist.len(), shift);
				case LEFT:
					audio_seek_relative(-5.0f);
				case RIGHT:
					audio_seek_relative(5.0f);
				case DELETE:
					remove_selected_tracks();
				case F11:
					state.win.set_fullscreen(!state.win.is_fullscreen());
				default:
					break;
			}

		case KEY_CHAR:
			uint cp = e.key_char.value;
			if (cp > 32 && cp <= 126)
			{
				filter_append_char((char)cp);
			}
			else if (cp == 32 && state.filter_active)
			{
				filter_append_char((char)cp);
			}

		case MOUSE_SCROLL:
			float dir = math::copysign(1.0f, e.delta.vector.y);
			GfxPoint m = state.win.get_mouse();
			GfxSize win_sz = state.win.get_size();
			UiLayout layout = compute_layout(win_sz);

			switch
			{
				case layout.volume_hit.contains_point(m):
					state.audio.volume = math::clamp(state.audio.volume + dir * 0.05f, 0.0f, 1.0f);
				case layout.timeline_hit.contains_point(m):
					audio_seek_relative(dir * 5.0f);
				default:
					int max_s = layout.max_scroll(playlist_view_count());
					state.scroll_row = math::clamp(state.scroll_row - (int)(dir * 3.0f), 0, max_s);
			}

		case MOUSE_MOTION:
			if (state.is_dragging_timeline)  handle_timeline_drag(e.mouse.pos);
			if (state.is_dragging_volume)    handle_volume_drag(e.mouse.pos);
			if (state.is_dragging_scrollbar) handle_scrollbar_drag(e.mouse.pos);
			if (state.is_dragging_item)      handle_item_drag(e.mouse.pos);

		case DATA_DRAG:
			if (e.drag.action == EXIT)
			{
				state.drop_insert_idx = -1;
			}
			else
			{
				UiLayout layout = compute_layout(state.win.get_size());
				state.drop_insert_idx = layout.track_index_at(e.drag.pos, state.scroll_row, (int)state.playlist.len());
			}

		case DATA_DROP:
			if (state.drop_insert_idx < 0)
			{
				UiLayout layout = compute_layout(state.win.get_size());
				state.drop_insert_idx = layout.track_index_at(state.win.get_mouse(), state.scroll_row, (int)state.playlist.len());
			}

			for (GfxDataDropNode* node = e.drop.value; node != null; node = node.next)
			{
				String path_str = ((String)node.data).trim();
				path_str = path_str.strip_prefix("file://localhost").strip_prefix("file://");
				path_str = url::tdecode(path_str, PATH) ?? path_str;

				$if $feat(WIN32):
					if (path_str.len >= 3 && path_str[0] == '/' && path_str[2] == ':')
					{
						path_str = path_str[1..];
					}
				$endif

				path_str = path_str.trim_right("/\\");

				if (path_str.len > 0)
				{
					add_path_to_playlist(path_str, &state.drop_insert_idx);
				}
			}

		case MOUSE_BUTTON_PRESSED:
			handle_mouse_click(state.win.get_mouse(), e.button.value == LEFT, e.button.value == MIDDLE);

		case MOUSE_BUTTON_RELEASED:
			if (e.button.value == LEFT)
			{
				handle_mouse_release(state.win.get_mouse());
			}

		default:
			break;
	}
}

fn void main(String[] args) @winmain
{
	List{String} cli_paths;
	cli_paths.init(mem);
	defer {
		foreach (p : cli_paths) mem::free(p.ptr);
		cli_paths.free();
	}

	if (!parse_cli_args(args, &cli_paths)) return;

	init_app();

	int insert_idx = 0;
	foreach (path : cli_paths)
	{
		add_path_to_playlist(path, &insert_idx);
	}
	if (state.playlist.len() > 0)
	{
		state.selected_track_idx = 0;
		state.selection_anchor_idx = 0;
		ensure_track_visible(0);
	}

	$if $feat(EMSCRIPTEN) || $feat(WASM):
		emscripten_set_main_loop(&step_web, 0, 1);
	$else
		const Duration FRAME_DURATION = time::SEC / 60;
		on_repaint(state.win, state.win.bounds);

		while (!state.win.should_close())
		{
			@pool()
			{
				bool needs_background_work = state.unprobed_count > 0;
				if (state.audio.is_playing || state.is_dragging_item || needs_background_work)
				{
					Time start_time = time::now();
					Time deadline = start_time + FRAME_DURATION;

					while (try ev = gfx::poll(state.win))
					{
						dispatch_event(&ev);
					}
					state.drop_insert_idx = -1;

					if (state.audio.track_eof)
					{
						state.audio.track_eof = false;
						if (state.repeat_mode)
						{
							audio_seek_absolute(0);
							state.audio.is_playing = true;
						}
						else
						{
							play_next_track();
						}
					}

					if (state.is_dragging_timeline)  handle_timeline_drag(state.win.get_mouse());
					if (state.is_dragging_volume)    handle_volume_drag(state.win.get_mouse());
					if (state.is_dragging_scrollbar) handle_scrollbar_drag(state.win.get_mouse());
					if (state.is_dragging_item)      handle_item_drag(state.win.get_mouse());

					probe_next_track_metadata(deadline);
					on_repaint(state.win, state.win.bounds);

					Duration remaining = deadline - time::now();
					if (remaining > (Duration)0)
					{
						if (try ev = gfx::wait(remaining))
						{
							dispatch_event(&ev);
						}
					}
				}
				else
				{
					if (try ev = gfx::wait(gfx::WAIT_FOREVER))
					{
						dispatch_event(&ev);
						while (try queued = gfx::poll(state.win))
						{
							dispatch_event(&queued);
						}
						state.drop_insert_idx = -1;
						on_repaint(state.win, state.win.bounds);
					}
				}
			};
		}
		cleanup_app();
	$endif
}

fn void step_web() => @pool()
{
	// not finished :(

	while (try ev = gfx::poll(state.win))
	{
		dispatch_event(&ev);
	}
	state.drop_insert_idx = -1;
	if (state.audio.track_eof)
	{
		state.audio.track_eof = false;
		play_next_track();
	}
	if (state.is_dragging_timeline)  handle_timeline_drag(state.win.get_mouse());
	if (state.is_dragging_volume)    handle_volume_drag(state.win.get_mouse());
	if (state.is_dragging_scrollbar) handle_scrollbar_drag(state.win.get_mouse());
	if (state.is_dragging_item)      handle_item_drag(state.win.get_mouse());
	on_repaint(state.win, state.win.bounds);
}

fn GfxRect get_active_workarea()
{
	GfxPoint mouse = gfx::get_global_mouse();
	foreach (mon : gfx::get_monitors())
	{
		GfxRect wa = mon.get_workarea();
		if (mouse.x >= wa.x && mouse.x < wa.x + wa.width &&
		    mouse.y >= wa.y && mouse.y < wa.y + wa.height)
		{
			return wa;
		}
	}
	if (try prim = gfx::get_primary_monitor())
	{
		return prim.get_workarea();
	}
	return { 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT };
}

fn bool parse_cli_args(String[] args, List{String}* cli_paths) => @pool()
{
	bool help = false;
	int verbosity = 0;
	String soundfont = "";

	sz? res = argparse::@parse(args,
		"h*", "help*",      "Show this help screen",                 &help,
		"v+", "verbose+",   "Increase verbosity (-v, -vv, -vvv)",    &verbosity,
		"s",  "soundfont",  "Custom SoundFont (.sf2) path",          &soundfont
	);

	if (catch err = res)
	{
		if (err == argparse::HELP_REQUESTED) return false;
		String prog_name = args.len > 0 ? (args[0].file_tbasename() ?? args[0]) : "c3aud";
		io::eprintfn("Option error: %s (near '%s')", err, argparse::last_opt);
		io::eprintfn("Try '%s -h' or '--help' for more information.", prog_name);
		os::exit(1);
	}

	switch (verbosity)
	{
		case 1:
			log::set_priority_all(INFO);
			avutil::av_log_set_level(WARNING);
		case 2:
			log::set_priority_all(DEBUG);
			avutil::av_log_set_level(INFO);
		case 3..int::max:
			log::set_priority_all(VERBOSE);
			avutil::av_log_set_level(VERBOSE);
		default:
			log::set_priority_all(ERROR);
			avutil::av_log_set_level(ERROR);
	}

	if (soundfont.len > 0)
	{
		state.soundfont_cli_path = soundfont.copy(mem);
	}

	sz start_pos = res;
	for (sz i = start_pos; i < args.len; i++)
	{
		cli_paths.push(args[i].copy(mem));
	}
	return true;
}

fn void init_app()
{
	avutil::av_log_set_callback(&custom_av_log_callback);

	state.audio = {
		.loaded_token = 0,
		.volume = 1.0f,
		.is_playing = false,
		.rb_initialized = false,
		.disk_thread_running = true,
		.requested_seek = -1
	};
	state.audio.stream_lock.init()!!;
	state.audio.buffer_needed.init()!!;

	state.playlist.init(mem);
	state.next_token = 1;
	state.shuffle_order.init(mem);
	state.shuffle_pos = 0;
	state.selected_track_idx = -1;
	state.selection_anchor_idx = -1;
	state.hovered_track_idx = -1;
	state.scroll_row = 0;
	state.probe_cursor = 0;
	state.unprobed_count = 0;
	state.shuffle_mode = false;
	state.repeat_mode = false;
	state.filter_active = false;
	state.filter_len = 0;
	state.filter_text = {};
	state.filtered_indices.init(mem);
	random::seed(&state.rng, 1337UL);

	GfxInitOption opts = { .init_opengl, .enable_x11_resize_sync };
	gfx::init(WINDOW_TITLE, opts)!!;

	GfxRect wa = get_active_workarea();

	GfxWindowFlags wflags = { .focus, .open_gl, .allow_dnd, .transparent };
	state.win = gfx::create_window(WINDOW_TITLE, wa.x, wa.y, WINDOW_WIDTH, wa.height, wflags)!!;
	state.win.set_min_size({ WINDOW_MIN_WIDTH, WINDOW_MIN_HEIGHT });
	state.win.set_dnd(true);
	gfx::set_build_dnd(true);
	state.win.set_repaint_callback(&on_repaint);
	gfx::set_current_opengl_window(state.win);
	state.win.set_opengl_swap_interval(1);

	load_gl();

	GfxSize initial_px = state.win.get_size_in_pixels();
	gl_viewport(0, 0, initial_px.x, initial_px.y);

	state.flat_shader = create_shader_prog(FLAT_VS, FLAT_FS);
	state.loc_flat_col = gl_get_uniform_location(state.flat_shader, "color");

	gl_gen_vertex_arrays(1, &state.dyn_vao);
	gl_gen_buffers(1, &state.dyn_vbo);
	gl_bind_vertex_array(state.dyn_vao);
	gl_bind_buffer(GL_ARRAY_BUFFER, state.dyn_vbo);
	gl_enable_vertex_attrib_array(0);
	gl_vertex_attrib_pointer(0, 2, GL_FLOAT, GL_FALSE, (int)(2 * float::size), null);
	gl_bind_vertex_array(0);

	init_font();
	init_icons();

	MaDeviceConfig config = ma::device_config_init(MA_DEVICE_TYPE_PLAYBACK);
	config.playback.format   = MA_FORMAT_F32;
	config.playback.channels = 2;
	config.sample_rate       = 48000;
	config.data_callback     = &audio_callback;
	config.p_user_data       = &state.audio;

	state.device = mem::new(MaDevice);
	MaResult res = ma::device_init(null, &config, state.device);
	assert(res == MA_SUCCESS, "Failed to initialize miniaudio device");
	ma::device_start(state.device);

	$if !$feat(EMSCRIPTEN) && !$feat(WASM):
		state.audio.disk_thread.create(&disk_stream_worker, &state.audio)!!;
	$endif
}

fn void cleanup_app()
{
	state.audio.stream_lock.lock();
	state.audio.disk_thread_running = false;
	(void)state.audio.buffer_needed.broadcast();
	state.audio.stream_lock.unlock();

	$if !$feat(EMSCRIPTEN) && !$feat(WASM):
		state.audio.disk_thread.join()!!;
	$endif
	state.audio.buffer_needed.destroy();

	if (state.device != null)
	{
		ma::device_uninit(state.device);
		mem::free(state.device);
		state.device = null;
	}

	audio_unload();
	if (active_soundfont_path.len > 0)
	{
		mem::free(active_soundfont_path.ptr);
		active_soundfont_path = "";
	}

	if (state.audio.rb_initialized)
	{
		ma::audio_ring_buffer_uninit(&state.audio.rb);
		state.audio.rb_initialized = false;
	}
	state.audio.stream_lock.destroy();

	foreach (item : state.playlist)
	{
		mem::free(item.path.ptr);
	}
	state.playlist.free();
	state.shuffle_order.free();
	state.filtered_indices.free();
	state.text_verts.free();

	gl_delete_program(state.flat_shader);
	gl_delete_program(state.text_shader);
	gl_delete_textures(1, &state.font_tex);
	gl_delete_textures(1, &state.icon_tex);
	gl_delete_vertex_arrays(1, &state.dyn_vao);
	gl_delete_buffers(1, &state.dyn_vbo);
	gl_delete_vertex_arrays(1, &state.text_vao);
	gl_delete_buffers(1, &state.text_vbo);

	state.win.destroy();
	gfx::finalize();
}

// ─────────────────────────────────────────────────────────────────────────────
// Minimal OpenGL Function Pointers
// ─────────────────────────────────────────────────────────────────────────────

alias GLenum     = uint;
alias GLboolean  = char;
alias GLbitfield = uint;

const GLenum GL_COLOR_BUFFER_BIT    = 0x00004000;
const GLboolean GL_FALSE            = 0;
const GLboolean GL_TRUE             = 1;
const GLenum GL_LINES               = 0x0001;
const GLenum GL_LINE_STRIP          = 0x0003;
const GLenum GL_TRIANGLES           = 0x0004;
const GLenum GL_SRC_ALPHA           = 0x0302;
const GLenum GL_ONE_MINUS_SRC_ALPHA = 0x0303;
const GLenum GL_BLEND               = 0x0BE2;
const GLenum GL_TEXTURE_2D          = 0x0DE1;
const GLenum GL_UNSIGNED_BYTE       = 0x1401;
const GLenum GL_FLOAT               = 0x1406;
const GLenum GL_RGBA                = 0x1908;
const GLenum GL_NEAREST             = 0x2600;
const GLenum GL_LINEAR              = 0x2601;
const GLenum GL_TEXTURE_MAG_FILTER  = 0x2800;
const GLenum GL_TEXTURE_MIN_FILTER  = 0x2801;
const GLenum GL_TEXTURE0            = 0x84C0;
const GLenum GL_ARRAY_BUFFER        = 0x8892;
const GLenum GL_DYNAMIC_DRAW        = 0x88E8;
const GLenum GL_FRAGMENT_SHADER     = 0x8B30;
const GLenum GL_VERTEX_SHADER       = 0x8B31;

alias PfnViewport            = fn void(int, int, int, int);
alias PfnEnable              = fn void(GLenum);
alias PfnDisable             = fn void(GLenum);
alias PfnClearColor          = fn void(float, float, float, float);
alias PfnClear               = fn void(GLbitfield);
alias PfnColorMask           = fn void(GLboolean, GLboolean, GLboolean, GLboolean);
alias PfnBlendFunc           = fn void(GLenum, GLenum);
alias PfnGenTextures         = fn void(int, uint*);
alias PfnDeleteTextures      = fn void(int, uint*);
alias PfnBindTexture         = fn void(GLenum, uint);
alias PfnTexImage2D          = fn void(GLenum, int, int, int, int, int, GLenum, GLenum, void*);
alias PfnTexParameteri       = fn void(GLenum, GLenum, int);
alias PfnCreateShader        = fn uint(GLenum);
alias PfnShaderSource        = fn void(uint, int, char**, int*);
alias PfnCompileShader       = fn void(uint);
alias PfnCreateProgram       = fn uint();
alias PfnAttachShader        = fn void(uint, uint);
alias PfnLinkProgram         = fn void(uint);
alias PfnDeleteShader        = fn void(uint);
alias PfnDeleteProgram       = fn void(uint);
alias PfnGetUniformLocation  = fn int(uint, char*);
alias PfnUseProgram          = fn void(uint);
alias PfnUniform4fv          = fn void(int, int, float*);
alias PfnGenVertexArrays     = fn void(int, uint*);
alias PfnDeleteVertexArrays  = fn void(int, uint*);
alias PfnBindVertexArray     = fn void(uint);
alias PfnGenBuffers          = fn void(int, uint*);
alias PfnDeleteBuffers       = fn void(int, uint*);
alias PfnBindBuffer          = fn void(GLenum, uint);
alias PfnBufferData          = fn void(GLenum, sz, void*, GLenum);
alias PfnEnableVertexAttrib  = fn void(uint);
alias PfnVertexAttribPointer = fn void(uint, int, GLenum, GLboolean, int, void*);
alias PfnActiveTexture       = fn void(GLenum);
alias PfnDrawArrays          = fn void(GLenum, int, int);

PfnViewport            gl_viewport;
PfnEnable              gl_enable;
PfnDisable             gl_disable;
PfnClearColor          gl_clear_color;
PfnClear               gl_clear;
PfnColorMask           gl_color_mask;
PfnBlendFunc           gl_blend_func;
PfnGenTextures         gl_gen_textures;
PfnDeleteTextures      gl_delete_textures;
PfnBindTexture         gl_bind_texture;
PfnTexImage2D          gl_tex_image_2d;
PfnTexParameteri       gl_tex_parameter_i;
PfnCreateShader        gl_create_shader;
PfnShaderSource        gl_shader_source;
PfnCompileShader       gl_compile_shader;
PfnCreateProgram       gl_create_program;
PfnAttachShader        gl_attach_shader;
PfnLinkProgram         gl_link_program;
PfnDeleteShader        gl_delete_shader;
PfnDeleteProgram       gl_delete_program;
PfnGetUniformLocation  gl_get_uniform_location;
PfnUseProgram          gl_use_program;
PfnUniform4fv          gl_uniform_4fv;
PfnGenVertexArrays     gl_gen_vertex_arrays;
PfnDeleteVertexArrays  gl_delete_vertex_arrays;
PfnBindVertexArray     gl_bind_vertex_array;
PfnGenBuffers          gl_gen_buffers;
PfnDeleteBuffers       gl_delete_buffers;
PfnBindBuffer          gl_bind_buffer;
PfnBufferData          gl_buffer_data;
PfnEnableVertexAttrib  gl_enable_vertex_attrib_array;
PfnVertexAttribPointer gl_vertex_attrib_pointer;
PfnActiveTexture       gl_active_texture;
PfnDrawArrays          gl_draw_arrays;

fn void load_gl()
{
	gl_viewport                   = (PfnViewport)gfx::get_opengl_proc("glViewport");
	gl_enable                     = (PfnEnable)gfx::get_opengl_proc("glEnable");
	gl_disable                    = (PfnDisable)gfx::get_opengl_proc("glDisable");
	gl_clear_color                = (PfnClearColor)gfx::get_opengl_proc("glClearColor");
	gl_clear                      = (PfnClear)gfx::get_opengl_proc("glClear");
	gl_color_mask                 = (PfnColorMask)gfx::get_opengl_proc("glColorMask");
	gl_blend_func                 = (PfnBlendFunc)gfx::get_opengl_proc("glBlendFunc");
	gl_gen_textures               = (PfnGenTextures)gfx::get_opengl_proc("glGenTextures");
	gl_delete_textures            = (PfnDeleteTextures)gfx::get_opengl_proc("glDeleteTextures");
	gl_bind_texture               = (PfnBindTexture)gfx::get_opengl_proc("glBindTexture");
	gl_tex_image_2d               = (PfnTexImage2D)gfx::get_opengl_proc("glTexImage2D");
	gl_tex_parameter_i            = (PfnTexParameteri)gfx::get_opengl_proc("glTexParameteri");
	gl_create_shader              = (PfnCreateShader)gfx::get_opengl_proc("glCreateShader");
	gl_shader_source              = (PfnShaderSource)gfx::get_opengl_proc("glShaderSource");
	gl_compile_shader             = (PfnCompileShader)gfx::get_opengl_proc("glCompileShader");
	gl_create_program             = (PfnCreateProgram)gfx::get_opengl_proc("glCreateProgram");
	gl_attach_shader              = (PfnAttachShader)gfx::get_opengl_proc("glAttachShader");
	gl_link_program               = (PfnLinkProgram)gfx::get_opengl_proc("glLinkProgram");
	gl_delete_shader              = (PfnDeleteShader)gfx::get_opengl_proc("glDeleteShader");
	gl_delete_program             = (PfnDeleteProgram)gfx::get_opengl_proc("glDeleteProgram");
	gl_get_uniform_location       = (PfnGetUniformLocation)gfx::get_opengl_proc("glGetUniformLocation");
	gl_use_program                = (PfnUseProgram)gfx::get_opengl_proc("glUseProgram");
	gl_uniform_4fv                = (PfnUniform4fv)gfx::get_opengl_proc("glUniform4fv");
	gl_gen_vertex_arrays          = (PfnGenVertexArrays)gfx::get_opengl_proc("glGenVertexArrays");
	gl_delete_vertex_arrays       = (PfnDeleteVertexArrays)gfx::get_opengl_proc("glDeleteVertexArrays");
	gl_bind_vertex_array          = (PfnBindVertexArray)gfx::get_opengl_proc("glBindVertexArray");
	gl_gen_buffers                = (PfnGenBuffers)gfx::get_opengl_proc("glGenBuffers");
	gl_delete_buffers             = (PfnDeleteBuffers)gfx::get_opengl_proc("glDeleteBuffers");
	gl_bind_buffer                = (PfnBindBuffer)gfx::get_opengl_proc("glBindBuffer");
	gl_buffer_data                = (PfnBufferData)gfx::get_opengl_proc("glBufferData");
	gl_enable_vertex_attrib_array = (PfnEnableVertexAttrib)gfx::get_opengl_proc("glEnableVertexAttribArray");
	gl_vertex_attrib_pointer      = (PfnVertexAttribPointer)gfx::get_opengl_proc("glVertexAttribPointer");
	gl_active_texture             = (PfnActiveTexture)gfx::get_opengl_proc("glActiveTexture");
	gl_draw_arrays                = (PfnDrawArrays)gfx::get_opengl_proc("glDrawArrays");
}