module c3aud;
import std, miniaudio::ma, avutil, tray;

const String WINDOW_TITLE    = "C3 Audio Station";
const int WINDOW_WIDTH       = 760;
const int WINDOW_HEIGHT      = 600;
const int WINDOW_MIN_WIDTH   = 480;
const int WINDOW_MIN_HEIGHT  = 320;

const float SEEK_STEP_SEC            = 5.0f;
const double DOUBLE_CLICK_TIMEOUT_SEC = 0.35;

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
	UiLayout layout = compute_layout(state.win.get_size());

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
					playlist_move_selection(-layout.visible_rows, shift);
				case PAGE_DOWN:
					playlist_move_selection(layout.visible_rows, shift);
				case HOME:
					playlist_move_selection(-(int)state.playlist.len(), shift);
				case END:
					playlist_move_selection((int)state.playlist.len(), shift);
				case LEFT:
					state.audio.seek_relative(-SEEK_STEP_SEC);
				case RIGHT:
					state.audio.seek_relative(SEEK_STEP_SEC);
				case DELETE:
					remove_selected_tracks();
				case F11:
					state.win.set_fullscreen(!state.win.is_fullscreen());
				default:
					break;
			}

		case KEY_CHAR:
			uint cp = e.key_char.value;
			if ((cp > 32 && cp <= 126) || (cp >= 160 && cp <= 255))
			{
				filter_append_codepoint(cp);
			}
			else if (cp == 32 && state.filter_active)
			{
				filter_append_codepoint(cp);
			}

		case MOUSE_SCROLL:
			float dir = math::copysign(1.0f, e.delta.vector.y);
			GfxPoint m = state.win.get_mouse();

			switch
			{
				case layout.volume_hit.contains_point(m):
					state.audio.volume = math::clamp(state.audio.volume + dir * 0.05f, 0.0f, 1.0f);
				case layout.timeline_hit.contains_point(m):
					state.audio.seek_relative(dir * SEEK_STEP_SEC);
				default:
					int max_s = layout.max_scroll(playlist_view_count());
					state.scroll_row = math::clamp(state.scroll_row - (int)(dir * 3.0f), 0, max_s);
			}

		case MOUSE_MOTION:
			if (state.is_dragging_timeline)  handle_timeline_drag(e.mouse.pos, &layout);
			if (state.is_dragging_volume)    handle_volume_drag(e.mouse.pos, &layout);
			if (state.is_dragging_scrollbar) handle_scrollbar_drag(e.mouse.pos, &layout);
			if (state.is_dragging_item)      handle_item_drag(e.mouse.pos, &layout);

		case DATA_DRAG:
			if (e.drag.action == EXIT)
			{
				state.drop_insert_idx = -1;
			}
			else
			{
				state.drop_insert_idx = playlist_drop_target_index(e.drag.pos, &layout);
			}

		case DATA_DROP:
			if (state.drop_insert_idx < 0)
			{
				state.drop_insert_idx = playlist_drop_target_index(state.win.get_mouse(), &layout);
			}

			if (state.filter_active)
			{
				filter_deactivate();
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
			handle_mouse_click(state.win.get_mouse(), e.button.value == LEFT, e.button.value == MIDDLE, &layout);

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

	$if $feat(EMSCRIPTEN | WASM):
		emscripten_set_main_loop(&step_web, 0, 1);
	$else
		const Duration FRAME_DURATION    = time::SEC / 60;
		const Duration BG_PROBE_BUDGET   = time::MS * 50;
		const Duration BG_PROBE_INTERVAL = time::MS * 20;
		on_repaint(state.win, state.win.bounds);

		while (!state.win.should_close())
		{
			@pool()
			{
				TrayEvent tev;
				while (tray::poll_event(&tev))
				{
					switch (tev.action)
					{
						case TOGGLE_WINDOW:
							state.win.is_hidden() ? state.win.show() : state.win.hide();
						case TOGGLE_PLAYBACK:
							toggle_playback();
							on_repaint(state.win, state.win.bounds);
						case PREV_TRACK:
							play_prev_track();
						case NEXT_TRACK:
							play_next_track();
						case QUIT:
							state.win.set_should_close(true);
						case VOLUME_CHANGE:
							state.audio.volume = math::clamp(state.audio.volume + (float)tev.scroll_delta * 0.05f, 0.0f, 1.0f);
							on_repaint(state.win, state.win.bounds);
						default:
							break;
					}
				}

				bool visible = !state.win.is_minimized() && !state.win.is_hidden() && state.win.width > 0 && state.win.height > 0;
				bool needs_background_work = state.unprobed_count > 0;

				switch
				{
					case visible && (state.audio.is_playing || state.is_dragging_item || needs_background_work):
						Time start_time = time::now();
						Time deadline = start_time + FRAME_DURATION;

						while (try ev = gfx::poll())
						{
							dispatch_event(&ev);
						}

						on_repaint(state.win, state.win.bounds);

						if (time::now() < deadline)
						{
							probe_next_track_metadata(deadline);
						}

						Duration remaining = deadline - time::now();
						if (remaining > (Duration)0)
						{
							if (try ev = gfx::wait(remaining))
							{
								dispatch_event(&ev);
							}
						}
					case needs_background_work:
						Time start_time = time::now();
						Time deadline = start_time + BG_PROBE_BUDGET;

						while (try ev = gfx::poll())
						{
							dispatch_event(&ev);
						}

						probe_next_track_metadata(deadline);

						if (try ev = gfx::wait(BG_PROBE_INTERVAL))
						{
							dispatch_event(&ev);
						}
					default:
						if (try ev = gfx::wait(gfx::WAIT_FOREVER))
						{
							dispatch_event(&ev);
							while (try queued = gfx::poll())
							{
								dispatch_event(&queued);
							}
							if (!state.win.is_minimized() && !state.win.is_hidden())
							{
								on_repaint(state.win, state.win.bounds);
							}
						}
				}
			};
		}
		cleanup_app();
	$endif
}

fn void step_web() => @pool()
{
	while (try ev = gfx::poll(state.win))
	{
		dispatch_event(&ev);
	}
	if (state.audio.track_eof)
	{
		state.audio.track_eof = false;
		play_next_track();
	}
	UiLayout layout = compute_layout(state.win.get_size());
	if (state.is_dragging_timeline)  handle_timeline_drag(state.win.get_mouse(), &layout);
	if (state.is_dragging_volume)    handle_volume_drag(state.win.get_mouse(), &layout);
	if (state.is_dragging_scrollbar) handle_scrollbar_drag(state.win.get_mouse(), &layout);
	if (state.is_dragging_item)      handle_item_drag(state.win.get_mouse(), &layout);
	on_repaint(state.win, state.win.bounds);
}

struct CGRect @feat(MACOS, DARWIN)
{
	double x;
	double y;
	double w;
	double h;
}

extern fn uint cg_main_display_id() @cname("CGMainDisplayID") @feat(MACOS, DARWIN);
extern fn CGRect cg_display_bounds(uint display) @cname("CGDisplayBounds") @feat(MACOS, DARWIN);

fn GfxRect get_active_workarea()
{
	$if $feat(MACOS, DARWIN):
		uint main_disp = cg_main_display_id();
		CGRect bounds = cg_display_bounds(main_disp);
		int menu_bar_h = 25;
		int h = math::max(WINDOW_HEIGHT, (int)bounds.h - menu_bar_h);
		return { (int)bounds.x, (int)bounds.y + menu_bar_h, (int)bounds.w, h };
	$else
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
	$endif
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
	random::seed_entropy(&state.rng);

	GfxInitOption opts = { .init_opengl, .enable_x11_resize_sync };
	gfx::init(WINDOW_TITLE, opts)!!;

	GfxRect wa = get_active_workarea();

	GfxWindowFlags wflags = { .focus, .open_gl, .allow_dnd};
	state.win = gfx::create_window(WINDOW_TITLE, wa.x, wa.y, WINDOW_WIDTH, wa.height, wflags)!!;
	state.win.set_min_size({ WINDOW_MIN_WIDTH, WINDOW_MIN_HEIGHT });
	state.win.set_repaint_callback(&on_repaint);
	init_app_icon();

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
	config.playback.channels = AUDIO_CHANNELS;
	config.sample_rate       = AUDIO_SAMPLE_RATE;
	config.data_callback     = &audio_callback;
	config.p_user_data       = &state.audio;

	state.device = mem::new(MaDevice);
	MaResult res = ma::device_init(null, &config, state.device);
	assert(res == MA_SUCCESS, "Failed to initialize miniaudio device");
	ma::device_start(state.device);

	$if !$feat(EMSCRIPTEN | WASM):
		state.audio.disk_thread.create(&disk_stream_worker, &state.audio)!!;
	$endif
}

fn void init_app_icon()
{
	const int ICON_SZ = 64;
	char[] buf = mem::new_array(char, ICON_SZ * ICON_SZ * 4);
	defer free(buf);

	float[4] sub_offsets = { 0.25f, 0.75f, 0.25f, 0.75f };

	for (int y = 0; y < ICON_SZ; y++)
	{
		for (int x = 0; x < ICON_SZ; x++)
		{
			float accum_r = 0.0f;
			float accum_g = 0.0f;
			float accum_b = 0.0f;
			float accum_a = 0.0f;

			for (int s = 0; s < 4; s++)
			{
				float fx = (float)x + sub_offsets[s];
				float fy = (float)y + sub_offsets[(s + 1) % 4];

				float d_circ = math::hypot(fx - 32.0f, fy - 32.0f);
				float bg_alpha = math::clamp(0.5f + (30.0f - d_circ), 0.0f, 1.0f);
				if (bg_alpha <= 0.0f) continue;

				float d1 = dist_to_arc(fx, fy, 32.0f, 75.0f, 52.0f, -1.92f, -1.22f);
				float d2 = dist_to_arc(fx, fy, 32.0f, 75.0f, 43.0f, -1.86f, -1.28f);
				float d3 = dist_to_arc(fx, fy, 32.0f, 75.0f, 34.0f, -1.79f, -1.35f);

				float a1 = math::clamp(0.5f + (2.4f - d1), 0.0f, 1.0f);
				float a2 = math::clamp(0.5f + (2.4f - d2), 0.0f, 1.0f);
				float a3 = math::clamp(0.5f + (2.2f - d3), 0.0f, 1.0f);
				float wave_alpha = math::max(a1, math::max(a2, a3));

				float r = lerp(41.0f, 18.0f, wave_alpha);
				float g = lerp(242.0f, 18.0f, wave_alpha);
				float b = lerp(11.0f, 18.0f, wave_alpha);

				accum_r += r * bg_alpha;
				accum_g += g * bg_alpha;
				accum_b += b * bg_alpha;
				accum_a += bg_alpha;
			}

			int p = (y * ICON_SZ + x) * 4;
			buf[p + 0] = (char)(accum_r * 0.25f + 0.5f);
			buf[p + 1] = (char)(accum_g * 0.25f + 0.5f);
			buf[p + 2] = (char)(accum_b * 0.25f + 0.5f);
			buf[p + 3] = (char)(accum_a * 0.25f * 255.0f + 0.5f);
		}
	}

	state.win.set_icon(buf.ptr, ICON_SZ, ICON_SZ, RGBA8);
	tray::init(buf, ICON_SZ, ICON_SZ);
}

macro lerp(x, y, amount) => x + (y - x) * amount;

fn void cleanup_app()
{
	tray::destroy();
	state.audio.stream_lock.lock();
	state.audio.disk_thread_running = false;
	(void)state.audio.buffer_needed.broadcast();
	state.audio.stream_lock.unlock();

	$if !$feat(EMSCRIPTEN | WASM):
		state.audio.disk_thread.join()!!;
	$endif
	state.audio.buffer_needed.destroy();

	if (state.device != null)
	{
		ma::device_uninit(state.device);
		mem::free(state.device);
		state.device = null;
	}

	state.audio.unload();
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

	foreach (&item : state.playlist)
	{
		item.destroy();
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

alias PfnVoid_Int4         = fn void(int, int, int, int);
alias PfnVoid_Enum         = fn void(GLenum);
alias PfnVoid_Float4       = fn void(float, float, float, float);
alias PfnVoid_Bitfield     = fn void(GLbitfield);
alias PfnVoid_Bool4        = fn void(GLboolean, GLboolean, GLboolean, GLboolean);
alias PfnVoid_Enum2        = fn void(GLenum, GLenum);
alias PfnVoid_Int_UintPtr  = fn void(int, uint*);
alias PfnVoid_Enum_Uint    = fn void(GLenum, uint);
alias PfnVoid_TexImage2D   = fn void(GLenum, int, int, int, int, int, GLenum, GLenum, void*);
alias PfnVoid_Enum2_Int    = fn void(GLenum, GLenum, int);
alias PfnUint_Enum         = fn uint(GLenum);
alias PfnVoid_ShaderSource = fn void(uint, int, char**, int*);
alias PfnUint_Void         = fn uint();
alias PfnVoid_Uint2        = fn void(uint, uint);
alias PfnVoid_Uint         = fn void(uint);
alias PfnInt_Uint_CharPtr  = fn int(uint, char*);
alias PfnVoid_Uniform4fv   = fn void(int, int, float*);
alias PfnVoid_BufferData   = fn void(GLenum, sz, void*, GLenum);
alias PfnVoid_VertexAttrib = fn void(uint, int, GLenum, GLboolean, int, void*);
alias PfnVoid_Enum_Int2    = fn void(GLenum, int, int);

PfnVoid_Int4         gl_viewport;
PfnVoid_Enum         gl_enable;
PfnVoid_Enum         gl_disable;
PfnVoid_Float4       gl_clear_color;
PfnVoid_Bitfield     gl_clear;
PfnVoid_Bool4        gl_color_mask;
PfnVoid_Enum2        gl_blend_func;
PfnVoid_Int_UintPtr  gl_gen_textures;
PfnVoid_Int_UintPtr  gl_delete_textures;
PfnVoid_Enum_Uint    gl_bind_texture;
PfnVoid_TexImage2D   gl_tex_image_2d;
PfnVoid_Enum2_Int    gl_tex_parameter_i;
PfnUint_Enum         gl_create_shader;
PfnVoid_ShaderSource gl_shader_source;
PfnVoid_Uint         gl_compile_shader;
PfnUint_Void         gl_create_program;
PfnVoid_Uint2        gl_attach_shader;
PfnVoid_Uint         gl_link_program;
PfnVoid_Uint         gl_delete_shader;
PfnVoid_Uint         gl_delete_program;
PfnInt_Uint_CharPtr  gl_get_uniform_location;
PfnVoid_Uint         gl_use_program;
PfnVoid_Uniform4fv   gl_uniform_4fv;
PfnVoid_Int_UintPtr  gl_gen_vertex_arrays;
PfnVoid_Int_UintPtr  gl_delete_vertex_arrays;
PfnVoid_Uint         gl_bind_vertex_array;
PfnVoid_Int_UintPtr  gl_gen_buffers;
PfnVoid_Int_UintPtr  gl_delete_buffers;
PfnVoid_Enum_Uint    gl_bind_buffer;
PfnVoid_BufferData   gl_buffer_data;
PfnVoid_Uint         gl_enable_vertex_attrib_array;
PfnVoid_VertexAttrib gl_vertex_attrib_pointer;
PfnVoid_Enum         gl_active_texture;
PfnVoid_Enum_Int2    gl_draw_arrays;

macro @gl_load(#fn_var, $name)
{
	#fn_var = ($Typeof(#fn_var))gfx::get_opengl_proc($name);
}

fn void load_gl()
{
	@gl_load(gl_viewport,                   "glViewport");
	@gl_load(gl_enable,                     "glEnable");
	@gl_load(gl_disable,                    "glDisable");
	@gl_load(gl_clear_color,                "glClearColor");
	@gl_load(gl_clear,                      "glClear");
	@gl_load(gl_color_mask,                 "glColorMask");
	@gl_load(gl_blend_func,                 "glBlendFunc");
	@gl_load(gl_gen_textures,               "glGenTextures");
	@gl_load(gl_delete_textures,            "glDeleteTextures");
	@gl_load(gl_bind_texture,               "glBindTexture");
	@gl_load(gl_tex_image_2d,               "glTexImage2D");
	@gl_load(gl_tex_parameter_i,            "glTexParameteri");
	@gl_load(gl_create_shader,              "glCreateShader");
	@gl_load(gl_shader_source,              "glShaderSource");
	@gl_load(gl_compile_shader,             "glCompileShader");
	@gl_load(gl_create_program,             "glCreateProgram");
	@gl_load(gl_attach_shader,              "glAttachShader");
	@gl_load(gl_link_program,               "glLinkProgram");
	@gl_load(gl_delete_shader,              "glDeleteShader");
	@gl_load(gl_delete_program,             "glDeleteProgram");
	@gl_load(gl_get_uniform_location,       "glGetUniformLocation");
	@gl_load(gl_use_program,                "glUseProgram");
	@gl_load(gl_uniform_4fv,                "glUniform4fv");
	@gl_load(gl_gen_vertex_arrays,          "glGenVertexArrays");
	@gl_load(gl_delete_vertex_arrays,       "glDeleteVertexArrays");
	@gl_load(gl_bind_vertex_array,          "glBindVertexArray");
	@gl_load(gl_gen_buffers,                "glGenBuffers");
	@gl_load(gl_delete_buffers,             "glDeleteBuffers");
	@gl_load(gl_bind_buffer,                "glBindBuffer");
	@gl_load(gl_buffer_data,                "glBufferData");
	@gl_load(gl_enable_vertex_attrib_array, "glEnableVertexAttribArray");
	@gl_load(gl_vertex_attrib_pointer,      "glVertexAttribPointer");
	@gl_load(gl_active_texture,             "glActiveTexture");
	@gl_load(gl_draw_arrays,                "glDrawArrays");
}
