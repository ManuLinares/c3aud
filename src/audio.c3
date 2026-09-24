module c3aud;
import std, miniaudio::ma;
import avutil, swresample, avcodec, avformat;
import tsf, tml;

String active_soundfont_path = "";

fn String? resolve_soundfont_path() => @pool()
{
	if (state.soundfont_cli_path.len > 0 && file::exists(state.soundfont_cli_path))
	{
		return state.soundfont_cli_path.copy(mem);
	}

	String[*] defaults = {
		"/usr/share/soundfonts/OPL-3_FM_128M.sf2.sf2",
		"/usr/share/soundfonts/FluidR3_GM.sf2"
	};
	foreach (p : defaults)
	{
		if (file::exists(p)) return p.copy(mem);
	}

	Path? dir_path = path::tnew("/usr/share/soundfonts");
	if (try dir_path && path::is_dir(dir_path))
	{
		PathList? list = path::ls(tmem, dir_path, no_dirs: true, recursive: true, relative: false);
		if (try list)
		{
			foreach (entry : list)
			{
				String s = (String)entry;
				if (s.ends_with(".sf2")) return s.copy(mem);
			}
		}
	}
	return NOT_FOUND~;
}

fn String? get_soundfont()
{
	if (active_soundfont_path.len > 0) return active_soundfont_path;
	String? found = resolve_soundfont_path();
	if (catch found) return NOT_FOUND~;
	active_soundfont_path = found;
	log::info("Selected SoundFont: '%s'", active_soundfont_path, category: log::CATEGORY_AUDIO);
	return active_soundfont_path;
}

const int AV_LOG_QUIET = -8;
const uint SCOPE_SIZE  = 1024;
const int AVSEEK_FLAG_BACKWARD = 1;

struct FfmpegDecoder
{
	AVFormatContext* fmt_ctx;
	AVCodecContext* codec_ctx;
	SwrContext* swr_ctx;
	AVPacket* pkt;
	AVFrame* frame;
	int stream_idx;
	ulong total_frames;
	bool eof_reached;
}

tlocal int log_print_prefix = 1;
tlocal ZString active_ffmpeg_path = null;

fn void custom_av_log_callback(void* avcl, int level, ZString fmt, CVaList vl)
{
	if (level > avutil::av_log_get_level()) return;

	char[1024] line;
	int print_prefix = log_print_prefix;
	int ret = avutil::av_log_format_line2(avcl, level, fmt, vl, &line[0], (int)line.len, &print_prefix);
	log_print_prefix = print_prefix;

	if (ret > 0)
	{
		String msg = ((ZString)&line[0]).str_view().trim_right();
		if (msg.len == 0) return;

		if (active_ffmpeg_path != null)
		{
			log::warn("[%s] %s", active_ffmpeg_path, msg, category: log::CATEGORY_AUDIO);
		}
		else
		{
			log::warn("%s", msg, category: log::CATEGORY_AUDIO);
		}
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// Format Helpers
// ─────────────────────────────────────────────────────────────────────────────

fn String? path_get_extension(String path)
{
	sz? dot = path.rindex_of_char('.');
	if (catch dot) return NOT_FOUND~;
	return path[dot + 1..];
}

fn bool is_midi_path(String path)
{
	if (try ext = path_get_extension(path))
	{
		return ext.compare_to_ignore_case("mid") == 0 || ext.compare_to_ignore_case("midi") == 0;
	}
	return false;
}

// ─────────────────────────────────────────────────────────────────────────────
// MIDI Backend
// ─────────────────────────────────────────────────────────────────────────────

fn ulong midi_calculate_frames(TmlMessage* msgs)
{
	uint time_len_ms = 0;
	tml::get_info(msgs, null, null, null, null, &time_len_ms);
	return (ulong)((double)time_len_ms * 48.0);
}

fn void midi_dispatch(Tsf* synth, TmlMessage* msg, bool play_notes)
{
	switch ((TMLMessageType)msg.type)
	{
		case NOTE_ON:
			if (play_notes) tsf::channel_note_on(synth, msg.channel, msg.key, (float)msg.velocity / 127.0f);
		case NOTE_OFF:
			if (play_notes) tsf::channel_note_off(synth, msg.channel, msg.key);
		case PROGRAM_CHANGE:
			tsf::channel_set_presetnumber(synth, msg.channel, msg.program(), msg.channel == 9 ? 1 : 0);
		case CONTROL_CHANGE:
			tsf::channel_midi_control(synth, msg.channel, msg.control(), msg.control_value());
		case PITCH_BEND:
			tsf::channel_set_pitchwheel(synth, msg.channel, msg.pitch_bend);
		default:
			break;
	}
}

fn MidiDecoder*? midi_decoder_open(String path) => @pool()
{
	TmlMessage* msgs = tml::load_filename(path.zstr_tcopy());
	if (msgs == null) return null;

	String? sf = get_soundfont();
	if (catch sf)
	{
		tml::free(msgs);
		log::error("No valid .sf2 SoundFont found", category: log::CATEGORY_AUDIO);
		return null;
	}

	Tsf* synth = tsf::load_filename(sf.zstr_tcopy());
	if (synth == null)
	{
		tml::free(msgs);
		log::error("Failed to load SoundFont '%s'", sf, category: log::CATEGORY_AUDIO);
		return null;
	}

	tsf::set_output(synth, STEREO_INTERLEAVED, 48000, 0.0f);

	ulong total_frames = midi_calculate_frames(msgs);
	uint time_len_ms = (uint)((double)total_frames / 48.0);
	int total_notes = 0;
	tml::get_info(msgs, null, null, &total_notes, null, null);
	log::info("Loaded MIDI '%s' (len: %d ms, notes: %d)", path, time_len_ms, total_notes, category: log::CATEGORY_AUDIO);

	MidiDecoder* dec = mem::new(MidiDecoder);
	dec.synth = synth;
	dec.messages = msgs;
	dec.current_msg = msgs;
	dec.total_frames = total_frames;
	dec.current_frame = 0;
	dec.eof_reached = false;
	return dec;
}

fn void midi_decoder_close(MidiDecoder* dec)
{
	if (dec == null) return;
	if (dec.synth != null) tsf::close(dec.synth);
	if (dec.messages != null) tml::free(dec.messages);
	mem::free(dec);
}

fn void midi_decoder_seek(MidiDecoder* dec, ulong frame_target)
{
	if (dec == null || dec.synth == null) return;
	tsf::reset(dec.synth);

	dec.current_frame = frame_target;
	uint target_ms = (uint)((double)frame_target / 48.0);
	dec.current_msg = dec.messages;

	while (dec.current_msg != null && dec.current_msg.time <= target_ms)
	{
		midi_dispatch(dec.synth, dec.current_msg, false);
		dec.current_msg = dec.current_msg.next;
	}
	dec.eof_reached = false;
}

fn ulong midi_decoder_read(MidiDecoder* dec, void* p_buf, ulong frames_to_read)
{
	if (dec == null || dec.synth == null || dec.eof_reached) return 0;

	float* out = (float*)p_buf;
	ulong frames_rendered = 0;
	const uint BLOCK_SIZE = 64;

	while (frames_rendered < frames_to_read)
	{
		ulong block = math::min(frames_to_read - frames_rendered, (ulong)BLOCK_SIZE);
		uint cur_ms = (uint)((double)dec.current_frame / 48.0);

		while (dec.current_msg != null && dec.current_msg.time <= cur_ms)
		{
			midi_dispatch(dec.synth, dec.current_msg, true);
			dec.current_msg = dec.current_msg.next;
		}

		tsf::render_float(dec.synth, out + frames_rendered * 2, (int)block, 0);

		frames_rendered += block;
		dec.current_frame += block;

		if (dec.current_msg == null && dec.current_frame >= dec.total_frames && tsf::active_voice_count(dec.synth) == 0)
		{
			dec.eof_reached = true;
			break;
		}
	}
	return frames_rendered;
}

// ─────────────────────────────────────────────────────────────────────────────
// FFmpeg Backend
// ─────────────────────────────────────────────────────────────────────────────

fn AVFormatContext*? ffmpeg_open_context(String path) => @pool()
{
	active_ffmpeg_path = path.zstr_tcopy();
	defer active_ffmpeg_path = null;

	AVFormatContext* fmt = null;
	int ret = avformat::open_input(&fmt, path.zstr_tcopy(), null, null);
	if (ret < 0)
	{
		String? ext = path_get_extension(path);
		if (try ext)
		{
			void* ifmt = avformat::av_find_input_format(ext.to_lower_tcopy().zstr_tcopy());
			if (ifmt != null)
			{
				ret = avformat::open_input(&fmt, path.zstr_tcopy(), ifmt, null);
			}
		}
		if (ret < 0) return null;
	}
	return fmt;
}

fn ulong ffmpeg_stream_frames(AVFormatContext* fmt, AVStream* stream)
{
	if (stream != null && stream.duration > 0 && stream.time_base.den > 0)
	{
		double sec = (double)stream.duration * (double)stream.time_base.num / (double)stream.time_base.den;
		return (ulong)(sec * 48000.0);
	}
	if (fmt != null && fmt.duration > 0)
	{
		double sec = (double)fmt.duration / 1000000.0;
		return (ulong)(sec * 48000.0);
	}
	return 0;
}

fn FfmpegDecoder*? ffmpeg_decoder_open(String path) => @pool()
{
	AVFormatContext* fmt = ffmpeg_open_context(path) ?? null;
	if (fmt == null) return null;

	if (avformat::find_stream_info(fmt, null) < 0)
	{
		avformat::close_input(&fmt);
		return null;
	}

	AVCodec* codec = null;
	int stream_idx = avformat::av_find_best_stream(fmt, AVMEDIA_TYPE_AUDIO, -1, -1, &codec, 0);
	if (stream_idx < 0 || codec == null)
	{
		avformat::close_input(&fmt);
		return null;
	}

	AVStream* stream = fmt.streams[stream_idx];
	AVCodecContext* codec_ctx = avcodec::alloc_context3(codec);
	if (codec_ctx == null)
	{
		avformat::close_input(&fmt);
		return null;
	}

	if (avcodec::parameters_to_context(codec_ctx, stream.codecpar) < 0 ||
		avcodec::open2(codec_ctx, codec, null) < 0)
	{
		avcodec::free_context(&codec_ctx);
		avformat::close_input(&fmt);
		return null;
	}

	AVChannelLayout out_layout;
	avutil::av_channel_layout_default(&out_layout, 2);

	SwrContext* swr = null;
	int ret = swresample::swr_alloc_set_opts2(
		&swr,
		&out_layout,
		AV_SAMPLE_FMT_FLT,
		48000,
		&codec_ctx.ch_layout,
		codec_ctx.sample_fmt,
		codec_ctx.sample_rate,
		0,
		null
	);

	if (ret < 0 || swresample::swr_init(swr) < 0)
	{
		if (swr != null) swresample::swr_free(&swr);
		avcodec::free_context(&codec_ctx);
		avformat::close_input(&fmt);
		return null;
	}

	ulong total_frames = ffmpeg_stream_frames(fmt, stream);
	log::info("Opened FFmpeg stream '%s' (rate: %d, ch: %d, frames: %d)", path, codec_ctx.sample_rate, codec_ctx.ch_layout.nb_channels, total_frames, category: log::CATEGORY_AUDIO);

	FfmpegDecoder* dec = mem::new(FfmpegDecoder);
	dec.fmt_ctx = fmt;
	dec.codec_ctx = codec_ctx;
	dec.swr_ctx = swr;
	dec.pkt = avcodec::av_packet_alloc();
	dec.frame = avutil::av_frame_alloc();
	dec.stream_idx = stream_idx;
	dec.total_frames = total_frames;
	dec.eof_reached = false;
	return dec;
}

fn void ffmpeg_decoder_close(FfmpegDecoder* dec)
{
	if (dec == null) return;
	if (dec.frame != null) avutil::av_frame_free(&dec.frame);
	if (dec.pkt != null) avcodec::av_packet_free(&dec.pkt);
	if (dec.swr_ctx != null) swresample::swr_free(&dec.swr_ctx);
	if (dec.codec_ctx != null) avcodec::free_context(&dec.codec_ctx);
	if (dec.fmt_ctx != null) avformat::close_input(&dec.fmt_ctx);
	mem::free(dec);
}

fn void ffmpeg_decoder_seek(FfmpegDecoder* dec, ulong frame_target)
{
	if (dec == null || dec.fmt_ctx == null) return;
	AVStream* stream = dec.fmt_ctx.streams[dec.stream_idx];
	double sec = (double)frame_target / 48000.0;
	long ts = (long)(sec * (double)stream.time_base.den / (double)stream.time_base.num);
	avformat::av_seek_frame(dec.fmt_ctx, dec.stream_idx, ts, AVSEEK_FLAG_BACKWARD);
	avcodec::flush_buffers(dec.codec_ctx);
	swresample::swr_init(dec.swr_ctx);
	dec.eof_reached = false;
}

fn ulong ffmpeg_decoder_read(FfmpegDecoder* dec, void* p_buf, ulong frames_to_read)
{
	if (dec == null || dec.fmt_ctx == null) return 0;
	ulong total_read = 0;

	while (total_read < frames_to_read)
	{
		char* out_ptr = (char*)p_buf + total_read * 8;
		int converted = swresample::swr_convert(dec.swr_ctx, &out_ptr, (int)(frames_to_read - total_read), null, 0);
		if (converted > 0)
		{
			total_read += (ulong)converted;
			if (total_read >= frames_to_read) break;
		}

		int ret = avcodec::receive_frame(dec.codec_ctx, dec.frame);
		if (ret == 0)
		{
			out_ptr = (char*)p_buf + total_read * 8;
			converted = swresample::swr_convert(dec.swr_ctx, &out_ptr, (int)(frames_to_read - total_read), (char**)dec.frame.extended_data, dec.frame.nb_samples);
			avutil::av_frame_unref(dec.frame);
			if (converted > 0)
			{
				total_read += (ulong)converted;
			}
			continue;
		}

		if (dec.eof_reached) break;

		int read_ret = avformat::av_read_frame(dec.fmt_ctx, dec.pkt);
		if (read_ret < 0)
		{
			dec.eof_reached = true;
			avcodec::send_packet(dec.codec_ctx, null);
			continue;
		}

		if (dec.pkt.stream_index == dec.stream_idx)
		{
			avcodec::send_packet(dec.codec_ctx, dec.pkt);
		}
		avcodec::av_packet_unref(dec.pkt);
	}

	return total_read;
}

// ─────────────────────────────────────────────────────────────────────────────
// Unified Audio Decoder & Prober
// ─────────────────────────────────────────────────────────────────────────────

enum DecoderType : char
{
	FFMPEG,
	MIDI
}

struct MidiDecoder
{
	Tsf* synth;
	TmlMessage* messages;
	TmlMessage* current_msg;
	ulong total_frames;
	ulong current_frame;
	bool eof_reached;
}

struct AudioDecoder
{
	DecoderType type;
	ulong total_frames;
	bool eof_reached;
	union
	{
		FfmpegDecoder* ffmpeg;
		MidiDecoder* midi;
	}
}

struct AudioProbeInfo
{
	ulong total_frames;
	char[128] display_name;
}

fn String? ffmpeg_get_tag(AVFormatContext* fmt, AVStream* stream, ZString key)
{
	if (fmt != null && fmt.metadata != null)
	{
		avutil::AVDictionaryEntry* entry = avutil::av_dict_get(fmt.metadata, key, null, 0);
		if (entry != null && entry.value != null)
		{
			String val = ((ZString)entry.value).str_view().trim();
			if (val.len > 0) return val;
		}
	}
	if (stream != null && stream.metadata != null)
	{
		avutil::AVDictionaryEntry* entry = avutil::av_dict_get(stream.metadata, key, null, 0);
		if (entry != null && entry.value != null)
		{
			String val = ((ZString)entry.value).str_view().trim();
			if (val.len > 0) return val;
		}
	}
	return NOT_FOUND~;
}

fn void ffmpeg_log_metadata(String path, AVFormatContext* fmt, AVStream* stream)
{
	if (fmt != null && fmt.metadata != null)
	{
		avutil::AVDictionaryEntry* entry = null;
		while ((entry = avutil::av_dict_get(fmt.metadata, "", entry, avutil::AV_DICT_IGNORE_SUFFIX)) != null)
		{
			if (entry.key != null && entry.value != null)
			{
				log::info("[%s] fmt tag: '%s' = '%s'", path, (ZString)entry.key, (ZString)entry.value, category: log::CATEGORY_AUDIO);
			}
		}
	}
	if (stream != null && stream.metadata != null)
	{
		avutil::AVDictionaryEntry* entry = null;
		while ((entry = avutil::av_dict_get(stream.metadata, "", entry, avutil::AV_DICT_IGNORE_SUFFIX)) != null)
		{
			if (entry.key != null && entry.value != null)
			{
				log::info("[%s] stream tag: '%s' = '%s'", path, (ZString)entry.key, (ZString)entry.value, category: log::CATEGORY_AUDIO);
			}
		}
	}
}

fn String? ffmpeg_format_tags(AVFormatContext* fmt, AVStream* stream)
{
	String? artist = ffmpeg_get_tag(fmt, stream, "artist") ?? ffmpeg_get_tag(fmt, stream, "album_artist");
	String? album  = ffmpeg_get_tag(fmt, stream, "album");
	String? title  = ffmpeg_get_tag(fmt, stream, "title");

	if (try t = title)
	{
		if (try ar = artist)
		{
			if (try al = album) return string::tformat("%s - %s - %s", ar, al, t);
			return string::tformat("%s - %s", ar, t);
		}
		if (try al = album) return string::tformat("%s - %s", al, t);
		return t;
	}
	if (try ar = artist)
	{
		if (try al = album) return string::tformat("%s - %s", ar, al);
		return ar;
	}
	return NOT_FOUND~;
}

fn AudioProbeInfo? midi_probe(String path) => @pool()
{
	TmlMessage* msgs = tml::load_filename(path.zstr_tcopy());
	if (msgs == null) return NOT_FOUND~;
	defer tml::free(msgs);

	AudioProbeInfo info;
	info.total_frames = midi_calculate_frames(msgs);
	if (info.total_frames == 0) return NOT_FOUND~;
	return info;
}

fn AudioProbeInfo? ffmpeg_probe(String path) => @pool()
{
	AVFormatContext* fmt = ffmpeg_open_context(path) ?? null;
	if (fmt == null) return NOT_FOUND~;
	defer avformat::close_input(&fmt);

	(void)avformat::find_stream_info(fmt, null);

	int stream_idx = avformat::av_find_best_stream(fmt, AVMEDIA_TYPE_AUDIO, -1, -1, null, 0);
	AVStream* stream = (stream_idx >= 0) ? fmt.streams[stream_idx] : null;

	ulong total_frames = ffmpeg_stream_frames(fmt, stream);
	if (total_frames == 0)
	{
		total_frames = ffmpeg_stream_frames(fmt, null);
	}
	if (total_frames == 0) return NOT_FOUND~;

	AudioProbeInfo info;
	info.total_frames = total_frames;

	ffmpeg_log_metadata(path, fmt, stream);

	String? tags = ffmpeg_format_tags(fmt, stream);
	if (try name = tags)
	{
		sz copy_len = math::min(name.len, (sz)127);
		info.display_name[:copy_len] = name[:copy_len];
		info.display_name[copy_len] = 0;
		log::info("[%s] Parsed display name: '%s'", path, (ZString)&info.display_name[0], category: log::CATEGORY_AUDIO);
	}
	else
	{
		log::info("[%s] No display tags found", path, category: log::CATEGORY_AUDIO);
	}

	return info;
}

fn AudioProbeInfo? audio_probe_file(String path) => @pool()
{
	if (is_midi_path(path)) return midi_probe(path);
	return ffmpeg_probe(path);
}

fn AudioDecoder*? audio_decoder_open(String path) => @pool()
{
	if (is_midi_path(path))
	{
		MidiDecoder* midi = midi_decoder_open(path) ?? null;
		if (midi == null) return null;

		AudioDecoder* dec = mem::new(AudioDecoder);
		dec.type = MIDI;
		dec.midi = midi;
		dec.total_frames = midi.total_frames;
		dec.eof_reached = false;
		return dec;
	}

	FfmpegDecoder* ffmpeg = ffmpeg_decoder_open(path) ?? null;
	if (ffmpeg == null) return null;

	AudioDecoder* dec = mem::new(AudioDecoder);
	dec.type = FFMPEG;
	dec.ffmpeg = ffmpeg;
	dec.total_frames = ffmpeg.total_frames;
	dec.eof_reached = false;
	return dec;
}

fn void audio_decoder_close(AudioDecoder* dec)
{
	if (dec == null) return;
	switch (dec.type)
	{
		case MIDI:   midi_decoder_close(dec.midi);
		case FFMPEG: ffmpeg_decoder_close(dec.ffmpeg);
	}
	mem::free(dec);
}

fn void audio_decoder_seek(AudioDecoder* dec, ulong frame_target)
{
	if (dec == null) return;
	switch (dec.type)
	{
		case MIDI:   midi_decoder_seek(dec.midi, frame_target);
		case FFMPEG: ffmpeg_decoder_seek(dec.ffmpeg, frame_target);
	}
	dec.eof_reached = false;
}

fn ulong audio_decoder_read(AudioDecoder* dec, void* p_buf, ulong frames_to_read)
{
	if (dec == null) return 0;
	ulong read = 0;
	switch (dec.type)
	{
		case MIDI:
			read = midi_decoder_read(dec.midi, p_buf, frames_to_read);
			dec.eof_reached = dec.midi.eof_reached;
		case FFMPEG:
			read = ffmpeg_decoder_read(dec.ffmpeg, p_buf, frames_to_read);
			dec.eof_reached = dec.ffmpeg.eof_reached;
	}
	return read;
}

// ─────────────────────────────────────────────────────────────────────────────
// Audio Engine & Playback State
// ─────────────────────────────────────────────────────────────────────────────

struct AudioEngine
{
	uint loaded_token;
	float volume;
	bool is_playing;

	AudioDecoder* decoder;
	MaAudioRingBuffer rb;
	bool rb_initialized;
	Thread disk_thread;
	Mutex stream_lock;
	ConditionVariable buffer_needed;
	bool disk_thread_running;

	long requested_seek;

	ulong track_frames;
	ulong track_cursor;
	bool is_track_loaded;
	bool track_eof;

	float[SCOPE_SIZE] scope_buffer;
	uint scope_write_idx;
}

fn void AudioEngine.reset_rb(&self)
{
	if (self.rb_initialized)
	{
		self.rb.rb.head = 0;
		self.rb.rb.tail = 0;
	}
}

fn void AudioEngine.pause_and_lock(&self)
{
	ma::device_stop(state.device);
	self.stream_lock.lock();
}

fn void AudioEngine.unlock_and_resume(&self)
{
	self.stream_lock.unlock();
	ma::device_start(state.device);
}

fn void AudioEngine.close_decoder(&self)
{
	if (self.decoder != null)
	{
		audio_decoder_close(self.decoder);
		self.decoder = null;
	}
}

fn void audio_callback(MaDevice* p_device, void* p_output, void* p_input, uint frame_count)
{
	(void)p_input;
	AudioEngine* audio = (AudioEngine*)p_device.p_user_data;
	float* out = (float*)p_output;

	if (audio == null || !audio.is_playing || !audio.is_track_loaded || !audio.rb_initialized)
	{
		for (uint i = 0; i < frame_count * 2; i++)
		{
			out[i] = 0.0f;
		}
		for (uint i = 0; i < frame_count; i++)
		{
			uint idx = (audio.scope_write_idx++) % SCOPE_SIZE;
			audio.scope_buffer[idx] = 0.0f;
		}
		return;
	}

	uint total_read = 0;
	while (total_read < frame_count)
	{
		uint frames_to_read = frame_count - total_read;
		void* p_buf = null;
		uint mapped = ma::audio_ring_buffer_map_consume(&audio.rb, frames_to_read, &p_buf);
		if (mapped == 0) break;

		mem::copy((char*)out + total_read * 8, p_buf, (sz)(mapped * 8));
		ma::audio_ring_buffer_unmap_consume(&audio.rb, mapped);
		total_read += mapped;
	}

	if (!audio.track_eof)
	{
		(void)audio.buffer_needed.signal();
	}

	if (audio.volume != 1.0f)
	{
		for (uint i = 0; i < total_read * 2; i++)
		{
			out[i] *= audio.volume;
		}
	}

	for (uint i = total_read * 2; i < frame_count * 2; i++)
	{
		out[i] = 0.0f;
	}

	audio.track_cursor += total_read;

	for (uint i = 0; i < frame_count; i++)
	{
		float l = out[i * 2 + 0];
		float r = out[i * 2 + 1];
		uint idx = (audio.scope_write_idx++) % SCOPE_SIZE;
		audio.scope_buffer[idx] = (l + r) * 0.5f;
	}
}

fn int disk_stream_worker(void* arg) => @pool_init(mem, 64 * 1024)
{
	AudioEngine* audio = (AudioEngine*)arg;

	audio.stream_lock.lock();
	while (audio.disk_thread_running)
	{
		if (audio.requested_seek >= 0 && audio.decoder != null)
		{
			ulong target = (ulong)audio.requested_seek;
			audio.requested_seek = -1;
			audio_decoder_seek(audio.decoder, target);
			audio.reset_rb();
			audio.track_cursor = target;
			audio.track_eof = false;
		}

		if (!audio.is_track_loaded || audio.decoder == null || !audio.rb_initialized)
		{
			audio.buffer_needed.wait(&audio.stream_lock);
			continue;
		}

		uint avail = ma::ring_buffer_capacity(&audio.rb.rb) - ma::ring_buffer_length(&audio.rb.rb);
		if (avail < 2048 && !audio.track_eof)
		{
			audio.buffer_needed.wait(&audio.stream_lock);
			continue;
		}

		uint to_write = math::min(avail, (uint)4096);
		void* p_buf = null;
		uint mapped = ma::audio_ring_buffer_map_produce(&audio.rb, to_write, &p_buf);
		if (mapped == 0)
		{
			audio.buffer_needed.wait(&audio.stream_lock);
			continue;
		}

		ulong frames_read = audio_decoder_read(audio.decoder, p_buf, (ulong)mapped);

		if (frames_read > 0)
		{
			ma::audio_ring_buffer_unmap_produce(&audio.rb, (uint)frames_read);
		}

		if (frames_read < (ulong)mapped)
		{
			audio.track_eof = true;
			audio.buffer_needed.wait(&audio.stream_lock);
		}
	}
	audio.stream_lock.unlock();

	return 0;
}

fn bool audio_play_file(uint token, String path) => @pool()
{
	AudioDecoder* new_decoder = audio_decoder_open(path) ?? null;
	if (new_decoder == null) return false;

	state.audio.pause_and_lock();

	state.audio.close_decoder();

	if (!state.audio.rb_initialized)
	{
		MaAudioRingBufferConfig rb_cfg = ma::audio_ring_buffer_config_init(MA_FORMAT_F32, 2, 48000, 96000);
		ma::audio_ring_buffer_init(&rb_cfg, &state.audio.rb);
		state.audio.rb_initialized = true;
	}
	else
	{
		state.audio.reset_rb();
	}

	state.audio.loaded_token    = token;
	state.audio.decoder         = new_decoder;
	state.audio.track_frames    = new_decoder.total_frames;
	state.audio.track_cursor    = 0;
	state.audio.track_eof       = false;
	state.audio.is_track_loaded = true;
	state.audio.is_playing      = true;

	log::info("Play [%d] '%s' (%s, frames: %d)", token, path, new_decoder.type == MIDI ? "MIDI" : "FFMPEG", new_decoder.total_frames, category: log::CATEGORY_AUDIO);

	(void)state.audio.buffer_needed.signal();
	state.audio.unlock_and_resume();
	gfx::wake();
	return true;
}

fn void audio_unload()
{
	state.audio.pause_and_lock();

	state.audio.close_decoder();
	state.audio.reset_rb();
	state.audio.loaded_token    = 0;
	state.audio.track_cursor    = 0;
	state.audio.track_frames    = 0;
	state.audio.track_eof       = false;
	state.audio.is_playing      = false;
	state.audio.is_track_loaded = false;

	log::info("Unloaded audio", category: log::CATEGORY_AUDIO);

	state.audio.unlock_and_resume();
}

fn void audio_stop()
{
	if (!state.audio.is_track_loaded) return;

	state.audio.pause_and_lock();

	if (state.audio.decoder != null)
	{
		audio_decoder_seek(state.audio.decoder, 0);
	}
	state.audio.reset_rb();
	state.audio.track_cursor = 0;
	state.audio.track_eof = false;
	state.audio.is_playing = false;

	log::info("Stopped playback (rewound to 0)", category: log::CATEGORY_AUDIO);

	state.audio.unlock_and_resume();
}

fn void audio_toggle()
{
	state.audio.is_playing = !state.audio.is_playing;
	log::info("Playback toggled: is_playing=%s", state.audio.is_playing, category: log::CATEGORY_AUDIO);
	if (state.audio.is_playing)
	{
		state.audio.stream_lock.lock();
		(void)state.audio.buffer_needed.signal();
		state.audio.stream_lock.unlock();
	}
}

fn void audio_seek_absolute(ulong frame_target)
{
	if (!state.audio.is_track_loaded) return;
	ulong target = math::clamp(frame_target, (ulong)0, state.audio.track_frames);

	state.audio.stream_lock.lock();
	state.audio.requested_seek = (long)target;
	(void)state.audio.buffer_needed.signal();
	state.audio.stream_lock.unlock();

	gfx::wake();
}

fn void audio_seek_relative(float seconds)
{
	if (!state.audio.is_track_loaded) return;
	log::debug("seek sec=%f cursor=%d req=%d frames=%d", seconds, (long)state.audio.track_cursor, state.audio.requested_seek, (long)state.audio.track_frames, category: log::CATEGORY_AUDIO);
	long delta = (long)(seconds * 48000.0f);
	long target = (long)state.audio.track_cursor + delta;
	if (target < 0) target = 0;
	audio_seek_absolute((ulong)target);
}