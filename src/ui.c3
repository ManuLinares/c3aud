module c3aud;
import std;

const int UI_MARGIN           = 40;
const int UI_MARGIN_TOP       = 20;
const int UI_MARGIN_BOTTOM    = 20;

const int ITEM_HEIGHT         = 24;
const int SCROLLBAR_WIDTH     = 10;
const int SCROLLBAR_HIT_PAD   = 4;

const int ITEM_TEXT_Y         = 4;
const int ITEM_NUM_X          = 8;
const int ITEM_NAME_X         = 40;
const int ITEM_DUR_W          = 38;
const int ITEM_NAME_GAP       = 10;
const int ITEM_NAME_FADE_W    = 40;

const int VOL_SLIDER_W        = 100;
const int VOL_SLIDER_H        = 10;
const int VOL_SLIDER_Y        = UI_MARGIN_TOP + 3;

const int TIMELINE_Y          = 185;
const int STATUS_TEXT_Y       = TIMELINE_Y - 20;
const int PLAYLIST_LABEL_Y    = TIMELINE_Y + 26;
const int LIST_START_Y        = TIMELINE_Y + 46;

const int TIMELINE_H          = 14;
const int TIMELINE_HIT_PAD    = 10;

const float CTRL_Y            = 105.0f;
const int   CTRL_BTN_SIZE     = 36;
const int   PLAY_BTN_SIZE     = 44;
const float PLAY_RADIUS       = 22.0f;
const int   SPACING_PREV_NEXT = 55;
const int   SPACING_SHUF_REP  = 115;
const int   CTRL_BOX_W        = 280;
const int   CTRL_BOX_H        = 52;
const int   DRAG_THRESHOLD    = 4;

struct UiLayout
{
	GfxSize win_sz;
	int content_w;

	IntRect title_text;
	IntRect volume_text;
	IntRect volume_track;
	IntRect volume_hit;

	IntRect waveform;
	IntRect controls_box;
	IntRect btn_shuffle;
	IntRect btn_prev;
	IntRect btn_play;
	IntRect btn_next;
	IntRect btn_repeat;

	IntRect status_text;
	IntRect status_hit;
	IntRect timeline_bar;
	IntRect timeline_hit;

	IntRect playlist_label;
	IntRect playlist_area;
	int visible_rows;
	int row_height;

	IntRect scrollbar_track;
	IntRect scrollbar_hit;
	bool has_scrollbar;
}

fn UiLayout compute_layout(GfxSize win_sz, int playlist_count = -1)
{
	int count = playlist_count >= 0 ? playlist_count : playlist_view_count();
	int content_w = math::max(0, win_sz.x - UI_MARGIN * 2);

	int vol_x = win_sz.x - UI_MARGIN - VOL_SLIDER_W;
	IntRect volume_track = { vol_x, VOL_SLIDER_Y, VOL_SLIDER_W, VOL_SLIDER_H };
	IntRect volume_hit   = { vol_x - 10, VOL_SLIDER_Y - 8, VOL_SLIDER_W + 20, VOL_SLIDER_H + 16 };

	int bottom_reserve = UI_MARGIN_BOTTOM + (state.filter_active ? 26 : 0);
	int list_h = math::max(0, (win_sz.y - bottom_reserve) - LIST_START_Y);
	int visible_rows = math::max(1, list_h / ITEM_HEIGHT);
	int max_s = math::max(0, count - visible_rows);
	bool has_sb = max_s > 0;

	int list_w = content_w - (has_sb ? (SCROLLBAR_WIDTH + 4) : 0);
	IntRect playlist_area = { UI_MARGIN, LIST_START_Y, list_w, visible_rows * ITEM_HEIGHT };

	int cx = win_sz.x / 2;

	IntRect scrollbar_track = { UI_MARGIN + content_w - SCROLLBAR_WIDTH, LIST_START_Y, SCROLLBAR_WIDTH, visible_rows * ITEM_HEIGHT - 2 };
	IntRect scrollbar_hit   = { UI_MARGIN + content_w - SCROLLBAR_WIDTH - SCROLLBAR_HIT_PAD, LIST_START_Y, SCROLLBAR_WIDTH + SCROLLBAR_HIT_PAD * 2, visible_rows * ITEM_HEIGHT - 2 };

	return {
		.win_sz = win_sz,
		.content_w = content_w,
		.title_text = { UI_MARGIN, 20, 200, 16 },
		.volume_text = { vol_x - 60, 24, 80, 14 },
		.volume_track = volume_track,
		.volume_hit = volume_hit,
		.waveform = { UI_MARGIN, (int)(CTRL_Y - 55.0f), content_w, 110 },
		.controls_box = { cx - CTRL_BOX_W / 2, (int)CTRL_Y - CTRL_BOX_H / 2, CTRL_BOX_W, CTRL_BOX_H },
		.btn_shuffle = { cx - SPACING_SHUF_REP - CTRL_BTN_SIZE / 2, (int)CTRL_Y - CTRL_BTN_SIZE / 2, CTRL_BTN_SIZE, CTRL_BTN_SIZE },
		.btn_prev    = { cx - SPACING_PREV_NEXT - CTRL_BTN_SIZE / 2, (int)CTRL_Y - CTRL_BTN_SIZE / 2, CTRL_BTN_SIZE, CTRL_BTN_SIZE },
		.btn_play    = { cx - PLAY_BTN_SIZE / 2, (int)CTRL_Y - PLAY_BTN_SIZE / 2, PLAY_BTN_SIZE, PLAY_BTN_SIZE },
		.btn_next    = { cx + SPACING_PREV_NEXT - CTRL_BTN_SIZE / 2, (int)CTRL_Y - CTRL_BTN_SIZE / 2, CTRL_BTN_SIZE, CTRL_BTN_SIZE },
		.btn_repeat  = { cx + SPACING_SHUF_REP - CTRL_BTN_SIZE / 2, (int)CTRL_Y - CTRL_BTN_SIZE / 2, CTRL_BTN_SIZE, CTRL_BTN_SIZE },
		.status_text = { UI_MARGIN, STATUS_TEXT_Y, content_w, 14 },
		.status_hit = { UI_MARGIN, STATUS_TEXT_Y - 8, content_w, 24 },
		.timeline_bar = { UI_MARGIN, TIMELINE_Y, content_w, TIMELINE_H },
		.timeline_hit = { UI_MARGIN, TIMELINE_Y - 4, content_w, TIMELINE_H + 8 },
		.playlist_label = { UI_MARGIN, PLAYLIST_LABEL_Y, content_w, 14 },
		.playlist_area = playlist_area,
		.visible_rows = visible_rows,
		.row_height = ITEM_HEIGHT,
		.scrollbar_track = scrollbar_track,
		.scrollbar_hit = scrollbar_hit,
		.has_scrollbar = has_sb
	};
}

fn int UiLayout.max_scroll(&self, int count)
{
	return math::max(0, count - self.visible_rows);
}

fn float UiLayout.timeline_frac(&self, int mouse_x)
{
	if (self.content_w <= 0) return 0.0f;
	return math::clamp((float)(mouse_x - self.timeline_bar.x) / (float)self.content_w, 0.0f, 1.0f);
}

fn float UiLayout.volume_frac(&self, int mouse_x)
{
	if (self.volume_track.width <= 0) return 0.0f;
	return math::clamp((float)(mouse_x - self.volume_track.x) / (float)self.volume_track.width, 0.0f, 1.0f);
}

fn IntRect UiLayout.volume_fill_rect(&self, float volume)
{
	float frac = math::clamp(volume, 0.0f, 1.0f);
	int fill_w = (int)(frac * (float)self.volume_track.width);
	return { self.volume_track.x, self.volume_track.y, fill_w, self.volume_track.height };
}

fn IntRect UiLayout.timeline_fill_rect(&self, float progress)
{
	float frac = math::clamp(progress, 0.0f, 1.0f);
	int fill_w = (int)(frac * (float)self.timeline_bar.width);
	return { self.timeline_bar.x, self.timeline_bar.y, fill_w, self.timeline_bar.height };
}

fn IntRect UiLayout.scrollbar_thumb(&self, int scroll_row, int count)
{
	int max_s = self.max_scroll(count);
	if (max_s <= 0 || count <= 0) return {};
	int track_h = self.scrollbar_track.height;
	int thumb_h = math::max(16, (int)((float)self.visible_rows / (float)count * (float)track_h));
	int travel = track_h - thumb_h;
	int thumb_y = self.scrollbar_track.y + (int)((float)scroll_row / (float)max_s * (float)travel);
	return { self.scrollbar_track.x, thumb_y, self.scrollbar_track.width, thumb_h };
}

fn int UiLayout.scrollbar_scroll_row(&self, int mouse_y, int drag_offset, int count)
{
	int max_s = self.max_scroll(count);
	if (max_s <= 0 || count <= 0) return 0;
	int track_h = self.scrollbar_track.height;
	int thumb_h = math::max(16, (int)((float)self.visible_rows / (float)count * (float)track_h));
	int travel = track_h - thumb_h;
	if (travel <= 0) return 0;

	int cur_y = mouse_y - self.scrollbar_track.y - drag_offset;
	float frac = math::clamp((float)cur_y / (float)travel, 0.0f, 1.0f);
	return math::clamp((int)(frac * (float)max_s + 0.5f), 0, max_s);
}

fn int UiLayout.track_index_at(&self, GfxPoint m, int scroll_row, int count)
{
	if (count > 0 && self.playlist_area.contains_point(m))
	{
		int row = (m.y - self.playlist_area.y) / self.row_height;
		return math::clamp(scroll_row + row, 0, count);
	}
	return count;
}

fn int UiLayout.drag_target_index(&self, int mouse_y, int scroll_row, int count)
{
	int row = (mouse_y - self.playlist_area.y + self.row_height / 2) / self.row_height;
	return math::clamp(scroll_row + row, 0, count);
}

fn IntRect UiLayout.item_rect(&self, int index, int scroll_row)
{
	int y = self.playlist_area.y + (index - scroll_row) * self.row_height;
	return { self.playlist_area.x, y, self.playlist_area.width, self.row_height - 2 };
}

fn IntRect UiLayout.insertion_line_rect(&self, int target_idx, int scroll_row)
{
	int target_row = target_idx - scroll_row;
	int line_y = self.playlist_area.y + target_row * self.row_height;
	return { self.playlist_area.x, line_y - 1, self.playlist_area.width, 3 };
}

fn void draw_rect(GfxSize win_sz, IntRect r, Vec4 color) => draw_rect_px(win_sz, r.x, r.y, r.width, r.height, color);

fn void draw_icon_in_rect(GfxSize win_sz, int slot, IntRect r, float size, Vec4 color)
{
	draw_icon(win_sz, slot, (float)(r.x + r.width / 2), (float)(r.y + r.height / 2), size, color);
}

const String SHADER_PREFIX @feat(EMSCRIPTEN | WASM)   = "#version 300 es\nprecision highp float;\n";
const String SHADER_PREFIX @feat(!EMSCRIPTEN & !WASM) = "#version 330 core\n";

const ZString FLAT_VS = SHADER_PREFIX
	+++ `layout(location = 0) in vec2 vertexPosition;
void main() {
    gl_Position = vec4(vertexPosition, 0.0, 1.0);
}
`;

const ZString FLAT_FS = SHADER_PREFIX
	+++ `uniform vec4 color;
out vec4 finalColor;
void main() {
    finalColor = color;
}
`;

const ZString TEXT_VS = SHADER_PREFIX
	+++ `layout(location = 0) in vec2 vertexPosition;
layout(location = 1) in vec2 vertexTexCoord;
layout(location = 2) in vec4 vertexColor;
out vec2 fragTexCoord;
out vec4 fragColor;
void main() {
    fragTexCoord = vertexTexCoord;
    fragColor = vertexColor;
    gl_Position = vec4(vertexPosition, 0.0, 1.0);
}
`;

const ZString TEXT_FS = SHADER_PREFIX
	+++ `in vec2 fragTexCoord;
in vec4 fragColor;
uniform sampler2D fontTex;
out vec4 finalColor;
void main() {
    float a = texture(fontTex, fragTexCoord).a;
    if (a < 0.1) discard;
    finalColor = vec4(fragColor.rgb, fragColor.a * a);
}
`;

fn uint create_shader_prog(ZString vs_src, ZString fs_src)
{
	uint vs = gl_create_shader(GL_VERTEX_SHADER);
	gl_shader_source(vs, 1, (char**)&vs_src, null);
	gl_compile_shader(vs);

	uint fs = gl_create_shader(GL_FRAGMENT_SHADER);
	gl_shader_source(fs, 1, (char**)&fs_src, null);
	gl_compile_shader(fs);

	uint prog = gl_create_program();
	gl_attach_shader(prog, vs);
	gl_attach_shader(prog, fs);
	gl_link_program(prog);

	gl_delete_shader(vs);
	gl_delete_shader(fs);
	return prog;
}

fn void init_font()
{
	char[] atlas = mem::new_array(char, 128 * 128 * 4);
	defer free(atlas);

	for (int i = 32; i < 127; i++)
	{
		FontGlyph? g = FontGlyph::lookup_field(ch, (char)i);
		if (catch g) continue;
		ulong bits = g.bitmap;
		int gx = (i % 16) * 8;
		int gy = (i / 16) * 8;
		for (int r = 0; r < 8; r++)
		{
			for (int c = 0; c < 5; c++)
			{
				if (((bits >> (39 - (r * 5 + c))) & 1) != 0)
				{
					int p = ((gy + r) * 128 + (gx + c)) * 4;
					atlas[p..p + 3] = 255;
				}
			}
		}
	}

	gl_gen_textures(1, &state.font_tex);
	gl_bind_texture(GL_TEXTURE_2D, state.font_tex);
	gl_tex_image_2d(GL_TEXTURE_2D, 0, (int)GL_RGBA, 128, 128, 0, GL_RGBA, GL_UNSIGNED_BYTE, atlas.ptr);
	gl_tex_parameter_i(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, (int)GL_NEAREST);
	gl_tex_parameter_i(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, (int)GL_NEAREST);

	state.text_shader = create_shader_prog(TEXT_VS, TEXT_FS);

	gl_gen_vertex_arrays(1, &state.text_vao);
	gl_gen_buffers(1, &state.text_vbo);
	gl_bind_vertex_array(state.text_vao);
	gl_bind_buffer(GL_ARRAY_BUFFER, state.text_vbo);
	gl_enable_vertex_attrib_array(0);
	gl_vertex_attrib_pointer(0, 2, GL_FLOAT, GL_FALSE, (int)TextVertex::size, null);
	gl_enable_vertex_attrib_array(1);
	gl_vertex_attrib_pointer(1, 2, GL_FLOAT, GL_FALSE, (int)TextVertex::size, (void*)(usz)(2 * float::size));
	gl_enable_vertex_attrib_array(2);
	gl_vertex_attrib_pointer(2, 4, GL_UNSIGNED_BYTE, GL_TRUE, (int)TextVertex::size, (void*)(usz)(4 * float::size));
	gl_bind_vertex_array(0);

	state.text_verts.init(mem, 8192);
}

fn void handle_timeline_drag(GfxPoint m)
{
	if (!state.audio.is_track_loaded) return;
	UiLayout layout = compute_layout(state.win.get_size());
	if (layout.content_w <= 0) return;

	if (m.x != state.last_seek_mouse_x)
	{
		state.last_seek_mouse_x = m.x;
		float frac = layout.timeline_frac(m.x);
		audio_seek_absolute((ulong)(frac * (float)state.audio.track_frames));
	}
}

fn void handle_volume_drag(GfxPoint m)
{
	UiLayout layout = compute_layout(state.win.get_size());
	state.audio.volume = layout.volume_frac(m.x);
}

fn void handle_scrollbar_drag(GfxPoint m)
{
	UiLayout layout = compute_layout(state.win.get_size());
	state.scroll_row = layout.scrollbar_scroll_row(m.y, state.scrollbar_drag_offset, playlist_view_count());
}

fn void handle_item_drag(GfxPoint m)
{
	if (!state.is_dragging_item || state.filter_active) return;
	int dx = m.x - state.drag_start_pos.x;
	int dy = m.y - state.drag_start_pos.y;
	if (!state.drag_active && (dx * dx + dy * dy >= DRAG_THRESHOLD * DRAG_THRESHOLD))
	{
		state.drag_active = true;
	}
	if (state.drag_active)
	{
		UiLayout layout = compute_layout(state.win.get_size());
		state.drag_target_idx = layout.drag_target_index(m.y, state.scroll_row, (int)state.playlist.len());
	}
}

fn void toggle_playback()
{
	if (!state.audio.is_track_loaded)
	{
		int target_idx = playlist_get_current_index();
		if (target_idx < 0) target_idx = state.selected_track_idx;
		if (target_idx < 0 && state.playlist.len() > 0) target_idx = 0;
		if (target_idx >= 0 && target_idx < (int)state.playlist.len())
		{
			play_track_index(target_idx);
		}
		return;
	}
	audio_toggle();
}

fn void handle_mouse_click(GfxPoint m, bool left, bool middle)
{
	GfxSize win_sz = state.win.get_size();
	UiLayout layout = compute_layout(win_sz);
	int count = playlist_view_count();

	int hovered = -1;
	if (layout.playlist_area.contains_point(m))
	{
		int view_idx = layout.track_index_at(m, state.scroll_row, count);
		hovered = playlist_view_to_real_index(view_idx);
	}

	if (middle && hovered >= 0)
	{
		remove_track(hovered);
		return;
	}

	if (left)
	{
		if (layout.volume_hit.contains_point(m))
		{
			state.is_dragging_volume = true;
			handle_volume_drag(m);
			return;
		}

		if (layout.status_hit.contains_point(m))
		{
			int cur = playlist_get_current_index();
			if (cur >= 0)
			{
				if (state.filter_active && playlist_real_to_view_index(cur) < 0)
				{
					filter_deactivate();
				}
				playlist_select_single(cur);
				ensure_track_visible(cur);
			}
			return;
		}

		if (layout.timeline_hit.contains_point(m))
		{
			state.is_dragging_timeline = true;
			state.last_seek_mouse_x = -1;
			handle_timeline_drag(m);
			return;
		}

		if (layout.btn_shuffle.contains_point(m))
		{
			state.shuffle_mode = !state.shuffle_mode;
			if (state.shuffle_mode) rebuild_shuffle_order();
			return;
		}
		if (layout.btn_prev.contains_point(m))
		{
			play_prev_track();
			return;
		}
		if (layout.btn_play.contains_point(m))
		{
			toggle_playback();
			return;
		}
		if (layout.btn_next.contains_point(m))
		{
			play_next_track();
			return;
		}
		if (layout.btn_repeat.contains_point(m))
		{
			state.repeat_mode = !state.repeat_mode;
			return;
		}

		if (layout.has_scrollbar && layout.scrollbar_hit.contains_point(m))
		{
			IntRect thumb = layout.scrollbar_thumb(state.scroll_row, count);
			state.is_dragging_scrollbar = true;
			if (m.y >= thumb.y && m.y <= thumb.y + thumb.height)
			{
				state.scrollbar_drag_offset = m.y - thumb.y;
			}
			else
			{
				state.scrollbar_drag_offset = thumb.height / 2;
				handle_scrollbar_drag(m);
			}
			return;
		}

		if (hovered >= 0)
		{
			bool ctrl = gfx::is_key_down(CONTROL_L) || gfx::is_key_down(CONTROL_R);
			bool shift = gfx::is_key_down(SHIFT_L) || gfx::is_key_down(SHIFT_R);

			if (ctrl)
			{
				state.playlist[hovered].selected = !state.playlist[hovered].selected;
				state.selected_track_idx = hovered;
				state.selection_anchor_idx = hovered;
				state.is_dragging_item = false;
				state.drag_active = false;
			}
			else if (shift)
			{
				if (state.selection_anchor_idx < 0 || state.selection_anchor_idx >= (int)state.playlist.len())
				{
					state.selection_anchor_idx = hovered;
				}
				for (int i = 0; i < (int)state.playlist.len(); i++)
				{
					state.playlist[i].selected = false;
				}
				int start_sel = math::min(state.selection_anchor_idx, hovered);
				int end_sel = math::max(state.selection_anchor_idx, hovered);
				for (int i = start_sel; i <= end_sel; i++)
				{
					state.playlist[i].selected = true;
				}
				state.selected_track_idx = hovered;
				state.is_dragging_item = false;
				state.drag_active = false;
			}
			else
			{
				state.drag_source_idx = hovered;
				state.drag_start_pos = m;
				state.is_dragging_item = true;
				state.drag_active = false;
				state.drag_target_idx = hovered;

				if (!state.playlist[hovered].selected)
				{
					for (int i = 0; i < (int)state.playlist.len(); i++)
					{
						state.playlist[i].selected = false;
					}
					state.playlist[hovered].selected = true;
					state.selected_track_idx = hovered;
					state.selection_anchor_idx = hovered;
				}
			}
		}
		else if (layout.playlist_area.contains_point(m))
		{
			for (int i = 0; i < (int)state.playlist.len(); i++)
			{
				state.playlist[i].selected = false;
			}
			state.selected_track_idx = -1;
			state.selection_anchor_idx = -1;
		}
	}
}

fn void handle_mouse_release(GfxPoint m)
{
	(void)m;
	double now = time::now().to_seconds();
	state.is_dragging_timeline = false;
	state.is_dragging_volume = false;
	state.is_dragging_scrollbar = false;

	if (state.is_dragging_item)
	{
		if (state.drag_active)
		{
			reorder_selected_tracks(state.drag_target_idx);
		}
		else
		{
			int hovered = state.drag_source_idx;
			for (int i = 0; i < (int)state.playlist.len(); i++)
			{
				state.playlist[i].selected = (i == hovered);
			}
			state.selected_track_idx = hovered;
			state.selection_anchor_idx = hovered;

			if (hovered == state.last_clicked_idx && (now - state.last_click_time) < 0.35)
			{
				play_track_index(hovered);
				state.last_click_time = 0.0;
			}
			else
			{
				state.last_click_time = now;
				state.last_clicked_idx = hovered;
			}
		}
		state.is_dragging_item = false;
		state.drag_active = false;
	}
}

fn void draw_oscilloscope(GfxSize win_sz, UiLayout* layout)
{
	float center_y = (float)(layout.controls_box.y + layout.controls_box.height / 2);

	float x_left  = (float)layout.waveform.x / (float)win_sz.x * 2.0f - 1.0f;
	float x_right = (float)(layout.waveform.x + layout.waveform.width) / (float)win_sz.x * 2.0f - 1.0f;
	float y_mid   = 1.0f - center_y / (float)win_sz.y * 2.0f;

	Vec2[2] grid = { { x_left, y_mid }, { x_right, y_mid } };
	draw_lines(grid[..], { 0.2f, 0.25f, 0.3f, 1.0f }, GL_LINES);

	Vec2[SCOPE_SIZE] pts;
	uint start_idx = state.audio.scope_write_idx;
	for (uint i = 0; i < SCOPE_SIZE; i++)
	{
		uint read_idx = (start_idx + i) % SCOPE_SIZE;
		float sample  = state.audio.scope_buffer[read_idx];

		float px = (float)layout.waveform.x + ((float)i / (float)(SCOPE_SIZE - 1)) * (float)layout.waveform.width;
		float py = center_y - math::clamp(sample * 55.0f, -55.0f, 55.0f);

		pts[i] = { px / (float)win_sz.x * 2.0f - 1.0f, 1.0f - py / (float)win_sz.y * 2.0f };
	}

	Vec4 scope_col = state.audio.is_playing ? (Vec4){ 0.2f, 0.85f, 0.55f, 1.0f } : (Vec4){ 0.4f, 0.45f, 0.5f, 1.0f };
	draw_lines(pts[..], scope_col, GL_LINE_STRIP);
}

fn void draw_ui(GfxSize win_sz, GfxPoint cur_m, UiLayout* layout)
{
	int count = playlist_view_count();
	draw_text(win_sz, "C3 AUDIO STATION", layout.title_text.x, layout.title_text.y, 16, { 1.0f, 1.0f, 1.0f, 1.0f });

	draw_text(win_sz, string::tformat("VOL: %3d%%", (int)(state.audio.volume * 100.0f)), layout.volume_text.x, layout.volume_text.y, 14, { 0.85f, 0.85f, 0.85f, 1.0f });
	draw_rect(win_sz, layout.volume_track, { 0.15f, 0.17f, 0.2f, 1.0f });

	IntRect vol_fill = layout.volume_fill_rect(state.audio.volume);
	if (vol_fill.width > 0)
	{
		draw_rect(win_sz, vol_fill, { 0.25f, 0.7f, 0.95f, 1.0f });
	}

	int current_idx = playlist_get_current_index();

	draw_rect(win_sz, layout.timeline_bar, { 0.15f, 0.17f, 0.2f, 1.0f });
	if (current_idx >= 0 && current_idx < count)
	{
		PlaylistItem cur_item = state.playlist[current_idx];
		ulong total_f = state.audio.is_track_loaded ? state.audio.track_frames : cur_item.total_frames;
		float progress = (total_f > 0 && state.audio.is_track_loaded) ? (float)state.audio.track_cursor / (float)total_f : 0.0f;
		IntRect time_fill = layout.timeline_fill_rect(progress);
		if (time_fill.width > 0)
		{
			draw_rect(win_sz, time_fill, { 0.25f, 0.7f, 0.95f, 1.0f });
		}

		float cur_s = state.audio.is_track_loaded ? (float)state.audio.track_cursor / 48000.0f : 0.0f;
		float tot_s = (float)total_f / 48000.0f;
		String time_str = string::tformat("%02d:%02d / %02d:%02d", (int)cur_s / 60, (int)cur_s % 60, (int)tot_s / 60, (int)tot_s % 60);
		draw_text(win_sz, time_str, layout.status_text.x, layout.status_text.y, 14, { 0.8f, 0.8f, 0.8f, 1.0f });

		String prefix = state.audio.is_playing ? "NOW PLAYING: %s" : "TRACK: %s";
		String title_str = string::tformat(prefix, ((ZString)&cur_item.name[0]).str_view());

		int time_end_x = layout.status_text.x + (int)time_str.len * 6 + 16;
		int title_w = (int)title_str.len * 6;
		int centered_x = win_sz.x / 2 - title_w / 2;
		int title_x = math::max(time_end_x, centered_x);

		int title_max_w = math::max(0, (layout.status_text.x + layout.status_text.width) - title_x);
		draw_text(win_sz, title_str, title_x, layout.status_text.y, 14, { 0.95f, 0.85f, 0.4f, 1.0f }, title_max_w, 40);
	}

	draw_rect(win_sz, layout.controls_box, { 0.08f, 0.09f, 0.11f, 0.85f });

	bool shuf_hov = layout.btn_shuffle.contains_point(cur_m);
	bool prev_hov = layout.btn_prev.contains_point(cur_m);
	bool play_hov = layout.btn_play.contains_point(cur_m);
	bool next_hov = layout.btn_next.contains_point(cur_m);
	bool rep_hov  = layout.btn_repeat.contains_point(cur_m);

	// 1. Shuffle
	Vec4 shuf_col = state.shuffle_mode ? (Vec4){ 0.20f, 0.85f, 0.55f, 1.0f } : (shuf_hov ? (Vec4){ 1.0f, 1.0f, 1.0f, 1.0f } : (Vec4){ 0.65f, 0.68f, 0.72f, 1.0f });
	draw_icon_in_rect(win_sz, ICON_SHUF, layout.btn_shuffle, 28.0f, shuf_col);
	if (state.shuffle_mode) draw_rect_px(win_sz, layout.btn_shuffle.x + layout.btn_shuffle.width / 2 - 2, layout.btn_shuffle.y + layout.btn_shuffle.height / 2 + 12, 4, 3, shuf_col);

	// 2. Previous
	Vec4 prev_col = prev_hov ? (Vec4){ 1.0f, 1.0f, 1.0f, 1.0f } : (Vec4){ 0.80f, 0.82f, 0.86f, 1.0f };
	draw_icon_in_rect(win_sz, ICON_PREV, layout.btn_prev, 28.0f, prev_col);

	// 3. Play / Pause
	Vec4 circ_col = play_hov ? (Vec4){ 1.0f, 1.0f, 1.0f, 1.0f } : (Vec4){ 0.92f, 0.93f, 0.95f, 1.0f };
	int play_slot = state.audio.is_playing ? ICON_PAUSE : ICON_PLAY;
	draw_icon_in_rect(win_sz, play_slot, layout.btn_play, PLAY_RADIUS * 2.0f, circ_col);

	// 4. Next
	Vec4 next_col = next_hov ? (Vec4){ 1.0f, 1.0f, 1.0f, 1.0f } : (Vec4){ 0.80f, 0.82f, 0.86f, 1.0f };
	draw_icon_in_rect(win_sz, ICON_NEXT, layout.btn_next, 28.0f, next_col);

	// 5. Repeat
	Vec4 rep_col = state.repeat_mode ? (Vec4){ 0.20f, 0.85f, 0.55f, 1.0f } : (rep_hov ? (Vec4){ 1.0f, 1.0f, 1.0f, 1.0f } : (Vec4){ 0.65f, 0.68f, 0.72f, 1.0f });
	draw_icon_in_rect(win_sz, ICON_REP, layout.btn_repeat, 28.0f, rep_col);
	if (state.repeat_mode) draw_rect_px(win_sz, layout.btn_repeat.x + layout.btn_repeat.width / 2 - 2, layout.btn_repeat.y + layout.btn_repeat.height / 2 + 12, 4, 3, rep_col);

	draw_text(win_sz, "PLAYLIST", layout.playlist_label.x, layout.playlist_label.y, 14, { 0.7f, 0.75f, 0.8f, 1.0f });

	if (count == 0)
	{
		const String EMPTY_MSG = "DROP AUDIO FILES OR FOLDERS ANYWHERE TO ADD TO PLAYLIST";
		const int FONT_SIZE = 14;
		int scale = math::max(1, FONT_SIZE / 8);
		int text_w = (int)EMPTY_MSG.len * 6 * scale;
		int text_h = 8 * scale;

		int list_h = (win_sz.y - UI_MARGIN_BOTTOM) - layout.playlist_area.y;
		int text_x = win_sz.x / 2 - text_w / 2;
		int text_y = layout.playlist_area.y + (list_h - text_h) / 2;

		draw_text(win_sz, EMPTY_MSG, text_x, text_y, FONT_SIZE, { 0.40f, 0.44f, 0.50f, 1.0f });
	}

	int end_idx = math::min(count, state.scroll_row + layout.visible_rows);

	for (int i = state.scroll_row; i < end_idx; i++)
	{
		int real_idx = playlist_view_to_real_index(i);
		if (real_idx < 0) continue;

		PlaylistItem item = state.playlist[real_idx];
		IntRect r = layout.item_rect(i, state.scroll_row);

		bool is_current  = (real_idx == current_idx);
		bool is_selected = item.selected;
		bool is_hovered  = (real_idx == state.hovered_track_idx);

		Vec4 bg_col = { 0.12f, 0.14f, 0.17f, 1.0f };
		if (state.is_dragging_item && state.drag_active && is_selected)
		{
			bg_col = { 0.28f, 0.38f, 0.48f, 0.8f };
		}
		else if (is_current && is_selected)
		{
			bg_col = state.audio.is_playing ? (Vec4){ 0.24f, 0.38f, 0.44f, 1.0f } : (Vec4){ 0.18f, 0.28f, 0.34f, 1.0f };
		}
		else if (is_current)
		{
			bg_col = state.audio.is_playing ? (Vec4){ 0.18f, 0.28f, 0.22f, 1.0f } : (Vec4){ 0.13f, 0.20f, 0.16f, 1.0f };
		}
		else if (is_selected)
		{
			bg_col = { 0.20f, 0.28f, 0.38f, 1.0f };
		}
		else if (is_hovered)
		{
			bg_col = { 0.16f, 0.19f, 0.23f, 1.0f };
		}

		draw_rect(win_sz, r, bg_col);

		Vec4 text_col;
		if (is_current)
		{
			text_col = state.audio.is_playing ? (Vec4){ 0.20f, 0.90f, 0.55f, 1.0f } : (Vec4){ 0.32f, 0.58f, 0.44f, 1.0f };
		}
		else
		{
			text_col = { 0.85f, 0.85f, 0.85f, 1.0f };
		}

		char[16] num_buf;
		String num_str = (String)(io::bprintf(&num_buf, "%d.", real_idx + 1) ?? "");

		int max_name_w = math::max(0, r.width - (ITEM_NAME_X + ITEM_DUR_W + ITEM_NAME_GAP));
		draw_text(win_sz, num_str, r.x + ITEM_NUM_X, r.y + ITEM_TEXT_Y, 14, text_col);
		draw_text(win_sz, ((ZString)&item.name[0]).str_view(), r.x + ITEM_NAME_X, r.y + ITEM_TEXT_Y, 14, text_col, max_name_w, ITEM_NAME_FADE_W);
		draw_text(win_sz, ((ZString)&item.dur_str[0]).str_view(), r.x + r.width - ITEM_DUR_W, r.y + ITEM_TEXT_Y, 14, { 0.6f, 0.65f, 0.7f, 1.0f });
	}

	if (state.is_dragging_item && state.drag_active)
	{
		int target_row = state.drag_target_idx - state.scroll_row;
		if (target_row >= 0 && target_row <= layout.visible_rows)
		{
			IntRect line_r = layout.insertion_line_rect(state.drag_target_idx, state.scroll_row);
			draw_rect(win_sz, line_r, { 0.25f, 0.7f, 0.95f, 1.0f });
			draw_rect_px(win_sz, line_r.x - 3, line_r.y - 2, 6, 7, { 0.95f, 0.85f, 0.4f, 1.0f });
		}
	}

	if (layout.has_scrollbar)
	{
		draw_rect(win_sz, layout.scrollbar_track, { 0.12f, 0.14f, 0.16f, 1.0f });

		IntRect thumb = layout.scrollbar_thumb(state.scroll_row, count);
		Vec4 thumb_col = state.is_dragging_scrollbar ? (Vec4){ 0.38f, 0.45f, 0.52f, 1.0f } : (Vec4){ 0.25f, 0.3f, 0.36f, 1.0f };
		draw_rect(win_sz, thumb, thumb_col);
	}

	if (state.is_dragging_item && state.drag_active)
	{
		int sel_count = 0;
		for (int i = 0; i < count; i++)
		{
			if (state.playlist[i].selected) sel_count++;
		}

		String badge_str;
		if (sel_count > 1)
		{
			badge_str = string::tformat("Moving %d tracks", sel_count);
		}
		else if (state.drag_source_idx >= 0 && state.drag_source_idx < count)
		{
			PlaylistItem src_item = state.playlist[state.drag_source_idx];
			badge_str = string::tformat("Moving: %s", ((ZString)&src_item.name[0]).str_view());
		}
		else
		{
			badge_str = "Moving 1 track";
		}

		int badge_w = 200;
		int badge_h = 22;
		int bx = math::clamp(cur_m.x + 12, 0, win_sz.x - badge_w - 10);
		int by = math::clamp(cur_m.y - 12, 0, win_sz.y - badge_h - 10);

		draw_rect_px(win_sz, bx + 2, by + 2, badge_w, badge_h, { 0.04f, 0.05f, 0.06f, 0.6f });
		draw_rect_px(win_sz, bx, by, badge_w, badge_h, { 0.2f, 0.35f, 0.45f, 0.95f });
		draw_text(win_sz, badge_str, bx + 8, by + 4, 12, { 1.0f, 1.0f, 1.0f, 1.0f });
	}

	if (state.filter_active)
	{
		int bar_y = win_sz.y - UI_MARGIN_BOTTOM - 20;
		int bar_h = 20;
		draw_rect_px(win_sz, UI_MARGIN, bar_y, layout.content_w, bar_h, { 0.12f, 0.14f, 0.18f, 0.95f });
		draw_rect_px(win_sz, UI_MARGIN, bar_y, 3, bar_h, { 0.25f, 0.7f, 0.95f, 1.0f });

		String query = ((ZString)&state.filter_text[0]).str_view();
		String search_label = string::tformat("SEARCH: %s_", query);
		draw_text(win_sz, search_label, UI_MARGIN + 8, bar_y + 3, 14, { 0.95f, 0.85f, 0.4f, 1.0f });

		if (count == 0)
		{
			draw_text(win_sz, "(NO MATCHES)", UI_MARGIN + 8 + (int)search_label.len * 6 + 12, bar_y + 3, 14, { 0.85f, 0.35f, 0.35f, 1.0f });
		}
	}

	flush_text();
}

const int ICON_SHUF  = 0;
const int ICON_PREV  = 1;
const int ICON_PLAY  = 2;
const int ICON_PAUSE = 3;
const int ICON_NEXT  = 4;
const int ICON_REP   = 5;

fn float dist_pt_to_segment(float px, float py, float x0, float y0, float x1, float y1)
{
	float dx = x1 - x0;
	float dy = y1 - y0;
	float l2 = dx * dx + dy * dy;
	if (l2 <= 0.0001f) return math::hypot(px - x0, py - y0);
	float t = math::clamp(((px - x0) * dx + (py - y0) * dy) / l2, 0.0f, 1.0f);
	return math::hypot(px - (x0 + t * dx), py - (y0 + t * dy));
}

fn float dist_pt_to_triangle(float px, float py, float x0, float y0, float x1, float y1, float x2, float y2)
{
	float d0 = (px - x0) * (y1 - y0) - (py - y0) * (x1 - x0);
	float d1 = (px - x1) * (y2 - y1) - (py - y1) * (x2 - x1);
	float d2 = (px - x2) * (y0 - y2) - (py - y2) * (x0 - x2);
	bool has_neg = (d0 < 0.0f) || (d1 < 0.0f) || (d2 < 0.0f);
	bool has_pos = (d0 > 0.0f) || (d1 > 0.0f) || (d2 > 0.0f);
	if (!(has_neg && has_pos)) return 0.0f;

	float e0 = dist_pt_to_segment(px, py, x0, y0, x1, y1);
	float e1 = dist_pt_to_segment(px, py, x1, y1, x2, y2);
	float e2 = dist_pt_to_segment(px, py, x2, y2, x0, y0);
	return math::min(e0, math::min(e1, e2));
}

fn void init_icons()
{
	const int ATLAS_W = 512;
	const int ATLAS_H = 64;
	char[] buf = mem::new_array(char, ATLAS_W * ATLAS_H * 4);
	defer free(buf);

	for (int y = 0; y < 64; y++)
	{
		float fy = (float)y + 0.5f;
		for (int x = 0; x < 512; x++)
		{
			float fx = (float)(x % 64) + 0.5f;
			int slot = x / 64;
			float alpha = 0.0f;

			switch (slot)
			{
				case ICON_SHUF:
					float d1  = dist_pt_to_segment(fx, fy, 14.0f, 46.0f, 24.0f, 46.0f);
					float d2  = dist_pt_to_segment(fx, fy, 24.0f, 46.0f, 38.0f, 18.0f);
					float d3  = dist_pt_to_segment(fx, fy, 38.0f, 18.0f, 46.0f, 18.0f);

					float d4  = dist_pt_to_segment(fx, fy, 14.0f, 18.0f, 24.0f, 18.0f);
					float d5a = dist_pt_to_segment(fx, fy, 24.0f, 18.0f, 27.0f, 24.0f);
					float d5b = dist_pt_to_segment(fx, fy, 35.0f, 40.0f, 38.0f, 46.0f);
					float d6  = dist_pt_to_segment(fx, fy, 38.0f, 46.0f, 46.0f, 46.0f);

					float a1  = dist_pt_to_segment(fx, fy, 41.0f, 11.0f, 48.0f, 18.0f);
					float a2  = dist_pt_to_segment(fx, fy, 41.0f, 25.0f, 48.0f, 18.0f);
					float a3  = dist_pt_to_segment(fx, fy, 41.0f, 39.0f, 48.0f, 46.0f);
					float a4  = dist_pt_to_segment(fx, fy, 41.0f, 53.0f, 48.0f, 46.0f);

					float md = math::min(d1, math::min(d2, math::min(d3, math::min(d4, math::min(d5a, math::min(d5b, d6))))));
					float ma = math::min(a1, math::min(a2, math::min(a3, a4)));
					alpha = math::clamp(0.5f + (2.5f - math::min(md, ma)), 0.0f, 1.0f);

				case ICON_PREV:
					float bar = (fx >= 14.0f && fx <= 20.0f && fy >= 16.0f && fy <= 48.0f) ? 0.0f : 1.0f;
					float tri = dist_pt_to_triangle(fx, fy, 48.0f, 16.0f, 22.0f, 32.0f, 48.0f, 48.0f);
					alpha = (bar == 0.0f) ? 1.0f : math::clamp(0.5f - tri, 0.0f, 1.0f);

				case ICON_PLAY:
					float d_circ = math::hypot(fx - 32.0f, fy - 32.0f);
					float a_circ = math::clamp(0.5f + (30.0f - d_circ), 0.0f, 1.0f);
					float tri_in = dist_pt_to_triangle(fx, fy, 26.0f, 20.0f, 44.0f, 32.0f, 26.0f, 44.0f);
					if (tri_in == 0.0f)
					{
						a_circ = 0.0f;
					}
					else if (tri_in < 1.0f)
					{
						a_circ *= math::clamp(tri_in, 0.0f, 1.0f);
					}
					alpha = a_circ;

				case ICON_PAUSE:
					float d_circ2 = math::hypot(fx - 32.0f, fy - 32.0f);
					float a_circ2 = math::clamp(0.5f + (30.0f - d_circ2), 0.0f, 1.0f);
					bool in_bar1 = (fx >= 23.0f && fx <= 29.0f && fy >= 21.0f && fy <= 43.0f);
					bool in_bar2 = (fx >= 35.0f && fx <= 41.0f && fy >= 21.0f && fy <= 43.0f);
					if (in_bar1 || in_bar2)
					{
						a_circ2 = 0.0f;
					}
					alpha = a_circ2;

				case ICON_NEXT:
					float bar2 = (fx >= 44.0f && fx <= 50.0f && fy >= 16.0f && fy <= 48.0f) ? 0.0f : 1.0f;
					float tri2 = dist_pt_to_triangle(fx, fy, 16.0f, 16.0f, 42.0f, 32.0f, 16.0f, 48.0f);
					alpha = (bar2 == 0.0f) ? 1.0f : math::clamp(0.5f - tri2, 0.0f, 1.0f);

				case ICON_REP:
					float top_d = dist_pt_to_segment(fx, fy, 22.0f, 19.0f, 44.0f, 19.0f);
					float rgt_d = dist_pt_to_segment(fx, fy, 48.0f, 23.0f, 48.0f, 41.0f);
					float bot_d = dist_pt_to_segment(fx, fy, 44.0f, 45.0f, 26.0f, 45.0f);
					float lft_d = dist_pt_to_segment(fx, fy, 16.0f, 23.0f, 16.0f, 41.0f);

					float c_tr = math::abs(math::hypot(fx - 44.0f, fy - 23.0f) - 4.0f);
					float c_tl = math::abs(math::hypot(fx - 20.0f, fy - 23.0f) - 4.0f);
					float c_bl = math::abs(math::hypot(fx - 20.0f, fy - 41.0f) - 4.0f);
					float c_br = math::abs(math::hypot(fx - 44.0f, fy - 41.0f) - 4.0f);

					float min_track = math::min(top_d, math::min(rgt_d, math::min(bot_d, lft_d)));
					if (fx >= 44.0f && fy <= 23.0f) min_track = c_tr;
					if (fx <= 20.0f && fy <= 23.0f) min_track = c_tl;
					if (fx <= 20.0f && fy >= 41.0f) min_track = c_bl;
					if (fx >= 44.0f && fy >= 41.0f) min_track = c_br;

					float ra1 = dist_pt_to_segment(fx, fy, 38.0f, 39.0f, 26.0f, 45.0f);
					float ra2 = dist_pt_to_segment(fx, fy, 38.0f, 51.0f, 26.0f, 45.0f);
					float min_arr = math::min(ra1, ra2);

					alpha = math::clamp(0.5f + (2.5f - math::min(min_track, min_arr)), 0.0f, 1.0f);

				default:
					break;
			}

			int p = (y * ATLAS_W + x) * 4;
			buf[p + 0] = (char)255;
			buf[p + 1] = (char)255;
			buf[p + 2] = (char)255;
			buf[p + 3] = (char)(alpha * 255.0f);
		}
	}

	gl_gen_textures(1, &state.icon_tex);
	gl_bind_texture(GL_TEXTURE_2D, state.icon_tex);
	gl_tex_image_2d(GL_TEXTURE_2D, 0, (int)GL_RGBA, ATLAS_W, ATLAS_H, 0, GL_RGBA, GL_UNSIGNED_BYTE, buf.ptr);
	gl_tex_parameter_i(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, (int)GL_LINEAR);
	gl_tex_parameter_i(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, (int)GL_LINEAR);
}

fn void draw_icon(GfxSize win_sz, int slot, float cx, float cy, float size, Vec4 color) => @pool()
{
	float half_sz = size * 0.5f;
	float x0 = (cx - half_sz) / (float)win_sz.x * 2.0f - 1.0f;
	float y0 = 1.0f - (cy - half_sz) / (float)win_sz.y * 2.0f;
	float x1 = (cx + half_sz) / (float)win_sz.x * 2.0f - 1.0f;
	float y1 = 1.0f - (cy + half_sz) / (float)win_sz.y * 2.0f;

	float u0 = (float)slot / 8.0f;
	float u1 = (float)(slot + 1) / 8.0f;
	float v0 = 0.0f;
	float v1 = 1.0f;

	char[4] col = pack_color(color);

	TextVertex[6] quad = {
		{ { x0, y0 }, { u0, v0 }, col },
		{ { x0, y1 }, { u0, v1 }, col },
		{ { x1, y0 }, { u1, v0 }, col },
		{ { x1, y0 }, { u1, v0 }, col },
		{ { x0, y1 }, { u0, v1 }, col },
		{ { x1, y1 }, { u1, v1 }, col }
	};

	gl_enable(GL_BLEND);
	gl_blend_func(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	gl_use_program(state.text_shader);

	gl_active_texture(GL_TEXTURE0);
	gl_bind_texture(GL_TEXTURE_2D, state.icon_tex);

	gl_bind_vertex_array(state.text_vao);
	gl_bind_buffer(GL_ARRAY_BUFFER, state.text_vbo);
	gl_buffer_data(GL_ARRAY_BUFFER, (usz)(6 * TextVertex::size), quad[..].ptr, GL_DYNAMIC_DRAW);
	gl_draw_arrays(GL_TRIANGLES, 0, 6);
	gl_bind_vertex_array(0);

	gl_disable(GL_BLEND);
}

fn void draw_rect_px(GfxSize win_sz, int x, int y, int w, int h, Vec4 color)
{
	float x0 = (float)x / (float)win_sz.x * 2.0f - 1.0f;
	float y0 = 1.0f - (float)y / (float)win_sz.y * 2.0f;
	float x1 = (float)(x + w) / (float)win_sz.x * 2.0f - 1.0f;
	float y1 = 1.0f - (float)(y + h) / (float)win_sz.y * 2.0f;

	Vec2[6] quad = {
		{ x0, y0 }, { x0, y1 }, { x1, y0 },
		{ x1, y0 }, { x0, y1 }, { x1, y1 }
	};
	draw_lines(quad[..], color, GL_TRIANGLES);
}

fn void draw_lines(Vec2[] pts, Vec4 color, GLenum mode)
{
	if (pts.len == 0) return;

	gl_enable(GL_BLEND);
	gl_blend_func(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	gl_use_program(state.flat_shader);
	gl_uniform_4fv(state.loc_flat_col, 1, (float*)&color);

	gl_bind_vertex_array(state.dyn_vao);
	gl_bind_buffer(GL_ARRAY_BUFFER, state.dyn_vbo);
	gl_buffer_data(GL_ARRAY_BUFFER, (usz)(pts.len * Vec2::size), pts.ptr, GL_DYNAMIC_DRAW);
	gl_draw_arrays(mode, 0, (int)pts.len);
	gl_bind_vertex_array(0);
}