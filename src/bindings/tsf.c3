module tsf;

enum TsfOutputMode : int
{
	STEREO_INTERLEAVED,
	STEREO_UNWEAVED,
	MONO
}

struct Tsf { void* _unused; }

alias TsfReadFn = fn int(void* data, void* ptr, uint size);
alias TsfSkipFn = fn int(void* data, uint count);

struct TsfStream
{
	void* data;
	TsfReadFn read;
	TsfSkipFn skip;
}

extern fn Tsf* load_filename(ZString filename) @cname("tsf_load_filename");
extern fn Tsf* load_memory(void* buffer, int size) @cname("tsf_load_memory");
extern fn Tsf* load(TsfStream* stream) @cname("tsf_load");
extern fn Tsf* copy(Tsf* f) @cname("tsf_copy");
extern fn void close(Tsf* f) @cname("tsf_close");
extern fn void reset(Tsf* f) @cname("tsf_reset");
extern fn int get_presetindex(Tsf* f, int bank, int preset_number) @cname("tsf_get_presetindex");
extern fn int get_presetcount(Tsf* f) @cname("tsf_get_presetcount");
extern fn ZString get_presetname(Tsf* f, int preset_index) @cname("tsf_get_presetname");
extern fn ZString bank_get_presetname(Tsf* f, int bank, int preset_number) @cname("tsf_bank_get_presetname");
extern fn void set_output(Tsf* f, TsfOutputMode outputmode, int samplerate, float global_gain_db = 0.0f) @cname("tsf_set_output");
extern fn void set_volume(Tsf* f, float global_gain) @cname("tsf_set_volume");
extern fn int set_max_voices(Tsf* f, int max_voices) @cname("tsf_set_max_voices");
extern fn int note_on(Tsf* f, int preset_index, int key, float vel) @cname("tsf_note_on");
extern fn int bank_note_on(Tsf* f, int bank, int preset_number, int key, float vel) @cname("tsf_bank_note_on");
extern fn void note_off(Tsf* f, int preset_index, int key) @cname("tsf_note_off");
extern fn int bank_note_off(Tsf* f, int bank, int preset_number, int key) @cname("tsf_bank_note_off");
extern fn void note_off_all(Tsf* f) @cname("tsf_note_off_all");
extern fn int active_voice_count(Tsf* f) @cname("tsf_active_voice_count");
extern fn void render_short(Tsf* f, short* buffer, int samples, int flag_mixing = 0) @cname("tsf_render_short");
extern fn void render_float(Tsf* f, float* buffer, int samples, int flag_mixing = 0) @cname("tsf_render_float");
extern fn int channel_set_presetindex(Tsf* f, int channel, int preset_index) @cname("tsf_channel_set_presetindex");
extern fn int channel_set_presetnumber(Tsf* f, int channel, int preset_number, int flag_mididrums = 0) @cname("tsf_channel_set_presetnumber");
extern fn int channel_set_bank(Tsf* f, int channel, int bank) @cname("tsf_channel_set_bank");
extern fn int channel_set_bank_preset(Tsf* f, int channel, int bank, int preset_number) @cname("tsf_channel_set_bank_preset");
extern fn int channel_set_pan(Tsf* f, int channel, float pan) @cname("tsf_channel_set_pan");
extern fn int channel_set_volume(Tsf* f, int channel, float volume) @cname("tsf_channel_set_volume");
extern fn int channel_set_pitchwheel(Tsf* f, int channel, int pitch_wheel) @cname("tsf_channel_set_pitchwheel");
extern fn int channel_set_pitchrange(Tsf* f, int channel, float pitch_range) @cname("tsf_channel_set_pitchrange");
extern fn int channel_set_tuning(Tsf* f, int channel, float tuning) @cname("tsf_channel_set_tuning");
extern fn int channel_set_sustain(Tsf* f, int channel, int flag_sustain) @cname("tsf_channel_set_sustain");
extern fn int channel_note_on(Tsf* f, int channel, int key, float vel) @cname("tsf_channel_note_on");
extern fn void channel_note_off(Tsf* f, int channel, int key) @cname("tsf_channel_note_off");
extern fn void channel_note_off_all(Tsf* f, int channel) @cname("tsf_channel_note_off_all");
extern fn void channel_sounds_off_all(Tsf* f, int channel) @cname("tsf_channel_sounds_off_all");
extern fn int channel_midi_control(Tsf* f, int channel, int controller, int control_value) @cname("tsf_channel_midi_control");
extern fn int channel_get_preset_index(Tsf* f, int channel) @cname("tsf_channel_get_preset_index");
extern fn int channel_get_preset_bank(Tsf* f, int channel) @cname("tsf_channel_get_preset_bank");
extern fn int channel_get_preset_number(Tsf* f, int channel) @cname("tsf_channel_get_preset_number");
extern fn float channel_get_pan(Tsf* f, int channel) @cname("tsf_channel_get_pan");
extern fn float channel_get_volume(Tsf* f, int channel) @cname("tsf_channel_get_volume");
extern fn int channel_get_pitchwheel(Tsf* f, int channel) @cname("tsf_channel_get_pitchwheel");
extern fn float channel_get_pitchrange(Tsf* f, int channel) @cname("tsf_channel_get_pitchrange");
extern fn float channel_get_tuning(Tsf* f, int channel) @cname("tsf_channel_get_tuning");