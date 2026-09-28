module c3aud;
import std;

struct PlaylistItem
{
	uint token;
	String path;
	char[128] name;
	ulong total_frames;
	char[8] dur_str;
	bool selected;
}

fn void set_playlist_item_frames(PlaylistItem* item, ulong frames)
{
	item.total_frames = frames > 0 ? frames : 1;
	if (frames > 1)
	{
		float dur_s = (float)frames / AUDIO_SAMPLE_RATE;
		io::bprintf(&item.dur_str, "%02d:%02d", (int)dur_s / 60, (int)dur_s % 60);
	}
	else
	{
		item.dur_str = "--:--\0\0";
	}
}

fn int playlist_find_index_by_token(uint token)
{
	if (token == 0) return -1;
	for (int i = 0; i < (int)state.playlist.len(); i++)
	{
		if (state.playlist[i].token == token) return i;
	}
	return -1;
}

fn int playlist_get_current_index()
{
	return playlist_find_index_by_token(state.audio.loaded_token);
}

fn int playlist_view_count()
{
	if (state.filter_active) return (int)state.filtered_indices.len();
	return (int)state.playlist.len();
}

fn int playlist_view_to_real_index(int view_idx)
{
	if (state.filter_active)
	{
		if (view_idx >= 0 && view_idx < (int)state.filtered_indices.len())
		{
			return state.filtered_indices[view_idx];
		}
		return -1;
	}
	if (view_idx >= 0 && view_idx < (int)state.playlist.len())
	{
		return view_idx;
	}
	return -1;
}

fn int playlist_real_to_view_index(int real_idx)
{
	if (real_idx < 0) return -1;
	if (!state.filter_active) return real_idx;
	return (int)(state.filtered_indices.index_of(real_idx) ?? -1);
}

fn char fold_char(Char32 cp)
{
	switch (cp)
	{
		case 'A'..'Z':                 return (char)(cp + 32);
		case 192..197: case 224..227: return 'a';
		case 200..203: case 232..235: return 'e';
		case 204..207: case 236..239: return 'i';
		case 209:      case 241:      return 'n';
		case 210..214: case 242..246: return 'o';
		case 217..220: case 249..252: return 'u';
		default:
			return (cp <= 255) ? (char)cp : 0;
	}
}

fn sz fold_string(char[] out, String in)
{
	sz out_len = 0;
	sz i = 0;
	while (i < in.len && out_len < out.len)
	{
		sz width = in.len - i;
		Char32 cp = in[i];
		if (try decoded = conv::utf8_to_char32(&in[i], &width))
		{
			cp = decoded;
		}
		else
		{
			width = 1;
		}
		i += width;

		char fc = fold_char(cp);
		if (fc != 0) out[out_len++] = fc;
	}
	return out_len;
}

fn bool filter_match_name(String text, String pattern)
{
	if (pattern.len == 0) return true;

	char[128] f_text;
	sz t_len = fold_string(&f_text, text);

	char[64] f_pat;
	sz p_len = fold_string(&f_pat, pattern);

	if (p_len == 0) return true;
	return ((String)f_text[:t_len]).contains((String)f_pat[:p_len]);
}

fn void filter_apply()
{
	state.filtered_indices.clear();
	String pattern = ((ZString)&state.filter_text[0]).str_view();

	for (int i = 0; i < (int)state.playlist.len(); i++)
	{
		String name = ((ZString)&state.playlist[i].name[0]).str_view();
		if (filter_match_name(name, pattern))
		{
			state.filtered_indices.push(i);
		}
	}

	state.scroll_row = 0;
	if (state.filtered_indices.len() > 0)
	{
		playlist_select_single(state.filtered_indices[0]);
	}
	else
	{
		state.selected_track_idx = -1;
		state.selection_anchor_idx = -1;
	}
	gfx::wake();
}

fn void filter_deactivate()
{
	state.filter_active = false;
	state.filter_len = 0;
	state.filter_text = {};
	state.filtered_indices.clear();
	ensure_track_visible(state.selected_track_idx);
	gfx::wake();
}

fn void filter_append_codepoint(Char32 cp)
{
	sz rem = state.filter_text.len - 1 - state.filter_len;
	if (try n = conv::char32_to_utf8(cp, state.filter_text[state.filter_len : rem]))
	{
		state.filter_active = true;
		state.filter_len += n;
		state.filter_text[state.filter_len] = 0;
		filter_apply();
	}
}

fn void filter_backspace()
{
	if (!state.filter_active) return;
	if (state.filter_len > 0)
	{
		state.filter_len--;
		while (state.filter_len > 0 && (state.filter_text[state.filter_len] & 0xC0) == 0x80)
		{
			state.filter_len--;
		}
		state.filter_text[state.filter_len] = 0;
		filter_apply();
	}
}

fn void ensure_track_visible(int idx)
{
	int view_idx = playlist_real_to_view_index(idx);
	if (view_idx < 0) return;

	GfxSize win_sz = state.win.get_size();
	UiLayout layout = compute_layout(win_sz);
	int max_s = layout.max_scroll(playlist_view_count());

	if (view_idx < state.scroll_row)
	{
		state.scroll_row = math::clamp(view_idx, 0, max_s);
	}
	else if (view_idx >= state.scroll_row + layout.visible_rows)
	{
		state.scroll_row = math::clamp(view_idx - layout.visible_rows + 1, 0, max_s);
	}
}

fn int playlist_drop_target_index(GfxPoint m)
{
	GfxSize win_sz = state.win.get_size();
	UiLayout layout = compute_layout(win_sz);
	int count = playlist_view_count();

	if (count > 0 && layout.playlist_area.contains_point(m))
	{
		int view_idx = layout.track_index_at(m, state.scroll_row, count);
		int real_idx = playlist_view_to_real_index(view_idx);
		if (real_idx >= 0) return real_idx;
		if (state.filter_active)
		{
			return state.filtered_indices[(sz)(count - 1)] + 1;
		}
	}
	return (int)state.playlist.len();
}

fn void rebuild_shuffle_order()
{
	state.shuffle_order.clear();
	int count = (int)state.playlist.len();
	if (count == 0)
	{
		state.shuffle_pos = 0;
		return;
	}

	for (int i = 0; i < count; i++)
	{
		state.shuffle_order.push(i);
	}

	for (int i = count - 1; i > 0; i--)
	{
		int j = random::next(&state.rng, i + 1);
		int tmp = state.shuffle_order[i];
		state.shuffle_order[i] = state.shuffle_order[j];
		state.shuffle_order[j] = tmp;
	}

	state.shuffle_pos = 0;
	int cur = playlist_get_current_index();
	if (cur >= 0)
	{
		if (try pos = state.shuffle_order.index_of(cur))
		{
			state.shuffle_pos = (int)pos;
		}
	}
}

fn bool is_supported_audio_extension(String path) => @pool()
{
	String? ext = ((Path)path).extension();
	if (catch ext) return false;
	if (ext.len == 0 || ext.len > 8) return false;

	switch (ext.to_lower_tcopy())
	{
		case "3ga":
		case "3gp":
		case "aac":
		case "ac3":
		case "aif":
		case "aifc":
		case "aiff":
		case "alac":
		case "amr":
		case "ape":
		case "asf":
		case "au":
		case "avi":
		case "dts":
		case "flac":
		case "flv":
		case "m2ts":
		case "m4a":
		case "m4b":
		case "m4p":
		case "m4r":
		case "m4v":
		case "mid":
		case "midi":
		case "mka":
		case "mkv":
		case "mov":
		case "mp2":
		case "mp3":
		case "mp4":
		case "mpc":
		case "mpeg":
		case "mpg":
		case "oga":
		case "ogg":
		case "ogv":
		case "opus":
		case "ra":
		case "ram":
		case "rm":
		case "rmvb":
		case "spx":
		case "tak":
		case "ts":
		case "tta":
		case "vob":
		case "voc":
		case "wav":
		case "webm":
		case "wma":
		case "wmv":
		case "wv":
			return true;
		default:
			return false;
	}
}

fn void probe_next_track_metadata(Time deadline) => @pool()
{
	int count = (int)state.playlist.len();
	if (count == 0 || state.unprobed_count <= 0) return;

	const Duration SAFETY_MARGIN = 4 * time::MS;
	int inspected = 0;

	while (inspected < count && state.unprobed_count > 0)
	{
		if (time::now() + SAFETY_MARGIN >= deadline) break;

		int idx = state.probe_cursor % count;
		state.probe_cursor = (idx + 1) % count;
		inspected++;

		if (state.playlist[idx].total_frames > 0) continue;

		AudioProbeInfo? info = audio_probe_file(state.playlist[idx].path);
		if (try inf = info)
		{
			set_playlist_item_frames(&state.playlist[idx], inf.total_frames);
			if (inf.display_name[0] != 0)
			{
				state.playlist[idx].name = inf.display_name;
			}
			log::info("Probed [%d] '%s' -> '%s' (%d frames)", state.playlist[idx].token, state.playlist[idx].path, (ZString)&state.playlist[idx].name[0], state.playlist[idx].total_frames, category: log::CATEGORY_APPLICATION);
		}
		else
		{
			set_playlist_item_frames(&state.playlist[idx], 1);
			log::warn("Probe failed for [%d] '%s'", state.playlist[idx].token, state.playlist[idx].path, category: log::CATEGORY_APPLICATION);
		}
		state.unprobed_count--;
	}
}

fn bool add_folder_to_playlist(String folder_path, int* insert_idx)
{
	Path? norm_opt = path::tnew(folder_path);
	if (catch norm_opt) return false;

	PathList? list_opt = path::ls(tmem, norm_opt, no_dirs: true, recursive: true, relative: false);
	if (catch list_opt) return false;

	bool added_any = false;
	foreach (f : list_opt)
	{
		if (add_file_to_playlist((String)f, *insert_idx))
		{
			(*insert_idx)++;
			added_any = true;
		}
	}
	return added_any;
}

fn bool add_path_to_playlist(String path, int* insert_idx)
{
	log::debug("add_path: '%s'", path, category: log::CATEGORY_APPLICATION);
	if (path::is_dir((Path)path))
	{
		return add_folder_to_playlist(path, insert_idx);
	}
	if (add_file_to_playlist(path, *insert_idx))
	{
		(*insert_idx)++;
		return true;
	}
	return false;
}

fn bool add_file_to_playlist(String raw_path, int insert_idx) => @pool()
{
	String path = url::tdecode(raw_path, PATH) ?? raw_path;

	if (!is_supported_audio_extension(path)) return false;

	String? name_view = path.file_tbasename();
	if (catch name_view) return false;

	if (state.next_token == 0) state.next_token = 1;

	PlaylistItem item;
	item.token = state.next_token++;
	item.path = path.copy(mem);
	item.total_frames = 0;
	item.dur_str = "--:--\0\0";
	item.selected = false;

	sz copy_len = math::min(name_view.len, (sz)127);
	item.name[:copy_len] = name_view[:copy_len];

	sz pos = math::clamp(insert_idx, 0, (int)state.playlist.len());
	state.playlist.insert_at(pos, item);
	state.unprobed_count++;
	log::info("Added item: '%s' (token: %d, index: %d)", (ZString)&item.name[0], item.token, (int)pos, category: log::CATEGORY_APPLICATION);

	if (state.probe_cursor > (int)pos)
	{
		state.probe_cursor = (int)pos;
	}

	if (state.shuffle_mode)
	{
		rebuild_shuffle_order();
	}
	return true;
}

fn void play_track_index(int idx)
{
	if (idx < 0 || idx >= state.playlist.len()) return;

	PlaylistItem item = state.playlist[idx];
	if (!audio_play_file(item.token, item.path)) return;

	if (state.playlist[idx].total_frames == 0)
	{
		state.unprobed_count--;
		if (try inf = audio_probe_file(state.playlist[idx].path))
		{
			if (inf.display_name[0] != 0) state.playlist[idx].name = inf.display_name;
		}
	}
	set_playlist_item_frames(&state.playlist[idx], state.audio.track_frames);

	state.probe_cursor = (idx + 1) % (int)state.playlist.len();
	state.selected_track_idx = idx;

	if (state.shuffle_mode)
	{
		if (try pos = state.shuffle_order.index_of(idx))
		{
			state.shuffle_pos = (int)pos;
		}
	}
	ensure_track_visible(idx);
}

fn void play_next_track()
{
	int count = (int)state.playlist.len();
	if (count == 0) return;

	if (state.shuffle_mode)
	{
		if (state.shuffle_order.len() != (sz)count)
		{
			rebuild_shuffle_order();
		}
		state.shuffle_pos = (state.shuffle_pos + 1) % count;
		play_track_index(state.shuffle_order[state.shuffle_pos]);
		return;
	}

	int cur = playlist_get_current_index();
	int next_idx = (cur + 1) % count;
	play_track_index(next_idx);
}

fn void playlist_select_single(int idx)
{
	int count = (int)state.playlist.len();
	if (count == 0) return;
	idx = math::clamp(idx, 0, count - 1);

	for (int i = 0; i < count; i++)
	{
		state.playlist[i].selected = (i == idx);
	}
	state.selected_track_idx = idx;
	state.selection_anchor_idx = idx;
	ensure_track_visible(idx);
}

fn void playlist_move_selection(int delta, bool shift)
{
	int count = playlist_view_count();
	if (count == 0) return;

	int cur_view = playlist_real_to_view_index(state.selected_track_idx);
	if (cur_view < 0) cur_view = playlist_real_to_view_index(playlist_get_current_index());
	if (cur_view < 0) cur_view = 0;

	int next_view = math::clamp(cur_view + delta, 0, count - 1);
	int next_real = playlist_view_to_real_index(next_view);
	if (next_real < 0) return;

	if (shift && !state.filter_active)
	{
		if (state.selection_anchor_idx < 0 || state.selection_anchor_idx >= (int)state.playlist.len())
		{
			state.selection_anchor_idx = next_real;
		}
		int start_sel = math::min(state.selection_anchor_idx, next_real);
		int end_sel   = math::max(state.selection_anchor_idx, next_real);
		for (int i = 0; i < (int)state.playlist.len(); i++)
		{
			state.playlist[i].selected = (i >= start_sel && i <= end_sel);
		}
		state.selected_track_idx = next_real;
		ensure_track_visible(next_real);
	}
	else
	{
		playlist_select_single(next_real);
	}
}

fn void play_selected_or_first()
{
	int count = playlist_view_count();
	if (count == 0) return;

	if (state.selected_track_idx >= 0)
	{
		play_track_index(state.selected_track_idx);
		return;
	}

	int first_real = playlist_view_to_real_index(0);
	if (first_real >= 0)
	{
		play_track_index(first_real);
	}
}

fn void play_prev_track()
{
	int count = (int)state.playlist.len();
	if (count == 0) return;

	if (state.audio.is_track_loaded && state.audio.track_cursor > PREV_TRACK_REWIND_THRESHOLD_FRAMES)
	{
		audio_seek_absolute(0);
		return;
	}

	if (state.shuffle_mode)
	{
		if (state.shuffle_order.len() != (sz)count)
		{
			rebuild_shuffle_order();
		}
		state.shuffle_pos = (state.shuffle_pos - 1 + count) % count;
		play_track_index(state.shuffle_order[state.shuffle_pos]);
		return;
	}

	int cur = playlist_get_current_index();
	int prev_idx = cur <= 0 ? count - 1 : cur - 1;
	play_track_index(prev_idx);
}

fn void remove_track(int idx)
{
	if (idx < 0 || idx >= state.playlist.len()) return;

	PlaylistItem item = state.playlist[idx];
	if (item.token == state.audio.loaded_token)
	{
		audio_unload();
	}
	if (item.total_frames == 0)
	{
		state.unprobed_count--;
	}
	mem::free(item.path.ptr);
	state.playlist.remove_at((sz)idx);

	int remaining = (int)state.playlist.len();
	if (remaining == 0)
	{
		audio_unload();
		state.selected_track_idx = -1;
		state.selection_anchor_idx = -1;
		state.scroll_row = 0;
		if (state.shuffle_mode) rebuild_shuffle_order();
		return;
	}

	int cur = playlist_get_current_index();
	state.selected_track_idx = (cur >= 0) ? cur : math::clamp(idx, 0, remaining - 1);
	state.selection_anchor_idx = state.selected_track_idx;

	GfxSize win_sz = state.win.get_size();
	UiLayout layout = compute_layout(win_sz);
	state.scroll_row = math::clamp(state.scroll_row, 0, layout.max_scroll(remaining));
	if (state.shuffle_mode) rebuild_shuffle_order();
	if (state.filter_active) filter_apply();
}

fn void remove_selected_tracks()
{
	int count = (int)state.playlist.len();
	if (count == 0) return;

	bool any_selected = array::@any(state.playlist.array_view(), fn bool (PlaylistItem item, sz i) => item.selected);

	if (!any_selected)
	{
		if (state.selected_track_idx >= 0 && state.selected_track_idx < count)
		{
			remove_track(state.selected_track_idx);
		}
		return;
	}

	int write = 0;
	for (int read = 0; read < count; read++)
	{
		if (state.playlist[read].selected)
		{
			if (state.playlist[read].token == state.audio.loaded_token)
			{
				audio_unload();
			}
			if (state.playlist[read].total_frames == 0)
			{
				state.unprobed_count--;
			}
			mem::free(state.playlist[read].path.ptr);
		}
		else
		{
			if (write != read)
			{
				state.playlist[write] = state.playlist[read];
			}
			write++;
		}
	}

	while (state.playlist.len() > (sz)write)
	{
		(void)state.playlist.pop();
	}

	int remaining = (int)state.playlist.len();
	if (remaining == 0)
	{
		audio_unload();
		state.selected_track_idx = -1;
		state.selection_anchor_idx = -1;
		state.scroll_row = 0;
		if (state.shuffle_mode) rebuild_shuffle_order();
		return;
	}

	int cur = playlist_get_current_index();
	state.selected_track_idx = (cur >= 0) ? cur : math::clamp(state.selected_track_idx, 0, remaining - 1);
	state.selection_anchor_idx = state.selected_track_idx;
	state.probe_cursor = math::clamp(state.probe_cursor, 0, remaining);

	GfxSize win_sz = state.win.get_size();
	UiLayout layout = compute_layout(win_sz);
	state.scroll_row = math::clamp(state.scroll_row, 0, layout.max_scroll(remaining));
	if (state.shuffle_mode) rebuild_shuffle_order();
	if (state.filter_active) filter_apply();
}

fn void reorder_selected_tracks(int target_idx) => @pool()
{
	int count = (int)state.playlist.len();
	if (count == 0) return;
	target_idx = math::clamp(target_idx, 0, count);

	int count_before = 0;
	for (int i = 0; i < target_idx; i++)
	{
		if (state.playlist[i].selected) count_before++;
	}
	int insert_pos = target_idx - count_before;

	List{PlaylistItem} moving;
	moving.init(tmem);
	for (int i = 0; i < count; i++)
	{
		if (state.playlist[i].selected) moving.push(state.playlist[i]);
	}
	if (moving.len() == 0) return;

	state.playlist.remove_if(fn bool (PlaylistItem* item) => item.selected);

	insert_pos = math::clamp(insert_pos, 0, (int)state.playlist.len());
	for (sz i = 0; i < moving.len(); i++)
	{
		state.playlist.insert_at((sz)(insert_pos + (int)i), moving[i]);
	}

	state.selected_track_idx = insert_pos;
	state.selection_anchor_idx = insert_pos;
	if (state.shuffle_mode) rebuild_shuffle_order();
}