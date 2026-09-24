module tml;

constdef TMLMessageType : int
{
	NOTE_OFF         = 128,
	NOTE_ON          = 144,
	KEY_PRESSURE     = 160,
	CONTROL_CHANGE   = 176,
	PROGRAM_CHANGE   = 192,
	CHANNEL_PRESSURE = 208,
	PITCH_BEND       = 224,
	SET_TEMPO        = 81
}

constdef TMLController : int
{
	BANK_SELECT_MSB      = 0,
	MODULATIONWHEEL_MSB  = 1,
	BREATH_MSB           = 2,
	FOOT_MSB             = 4,
	PORTAMENTO_TIME_MSB  = 5,
	DATA_ENTRY_MSB       = 6,
	VOLUME_MSB           = 7,
	BALANCE_MSB          = 8,
	PAN_MSB              = 10,
	EXPRESSION_MSB       = 11,
	EFFECTS1_MSB         = 12,
	EFFECTS2_MSB         = 13,
	GPC1_MSB             = 16,
	GPC2_MSB             = 17,
	GPC3_MSB             = 18,
	GPC4_MSB             = 19,
	BANK_SELECT_LSB      = 32,
	MODULATIONWHEEL_LSB  = 33,
	BREATH_LSB           = 34,
	FOOT_LSB             = 36,
	PORTAMENTO_TIME_LSB  = 37,
	DATA_ENTRY_LSB       = 38,
	VOLUME_LSB           = 39,
	BALANCE_LSB          = 40,
	PAN_LSB              = 42,
	EXPRESSION_LSB       = 43,
	EFFECTS1_LSB         = 44,
	EFFECTS2_LSB         = 45,
	GPC1_LSB             = 48,
	GPC2_LSB             = 49,
	GPC3_LSB             = 50,
	GPC4_LSB             = 51,
	SUSTAIN_SWITCH       = 64,
	PORTAMENTO_SWITCH    = 65,
	SOSTENUTO_SWITCH     = 66,
	SOFT_PEDAL_SWITCH    = 67,
	LEGATO_SWITCH        = 68,
	HOLD2_SWITCH         = 69,
	SOUND_CTRL1          = 70,
	SOUND_CTRL2          = 71,
	SOUND_CTRL3          = 72,
	SOUND_CTRL4          = 73,
	SOUND_CTRL5          = 74,
	SOUND_CTRL6          = 75,
	SOUND_CTRL7          = 76,
	SOUND_CTRL8          = 77,
	SOUND_CTRL9          = 78,
	SOUND_CTRL10         = 79,
	GPC5                 = 80,
	GPC6                 = 81,
	GPC7                 = 82,
	GPC8                 = 83,
	PORTAMENTO_CTRL      = 84,
	FX_REVERB            = 91,
	FX_TREMOLO           = 92,
	FX_CHORUS            = 93,
	FX_CELESTE_DETUNE    = 94,
	FX_PHASER            = 95,
	DATA_ENTRY_INCR      = 96,
	DATA_ENTRY_DECR      = 97,
	NRPN_LSB             = 98,
	NRPN_MSB             = 99,
	RPN_LSB              = 100,
	RPN_MSB              = 101,
	ALL_SOUND_OFF        = 120,
	ALL_CTRL_OFF         = 121,
	LOCAL_CONTROL        = 122,
	ALL_NOTES_OFF        = 123,
	OMNI_OFF             = 124,
	OMNI_ON              = 125,
	POLY_OFF             = 126,
	POLY_ON              = 127
}

struct TmlMessage
{
	uint time;
	char type;
	char channel;
	union
	{
		struct
		{
			char key;
			char velocity;
		}
		ushort pitch_bend;
	}
	TmlMessage* next;
}

fn char TmlMessage.control(&self)          => self.key;
fn char TmlMessage.program(&self)          => self.key;
fn char TmlMessage.channel_pressure(&self) => self.key;
fn char TmlMessage.control_value(&self)    => self.velocity;
fn char TmlMessage.key_pressure(&self)     => self.velocity;

alias TmlReadFn = fn int(void* data, void* ptr, uint size);

struct TmlStream
{
	void* data;
	TmlReadFn read;
}

extern fn TmlMessage* load_filename(ZString filename) @cname("tml_load_filename");
extern fn TmlMessage* load_memory(void* buffer, int size) @cname("tml_load_memory");
extern fn int get_info(TmlMessage* first_message, int* used_channels, int* used_programs, int* total_notes, uint* time_first_note, uint* time_length) @cname("tml_get_info");
extern fn int get_tempo_value(TmlMessage* set_tempo_message) @cname("tml_get_tempo_value");
extern fn void free(TmlMessage* f) @cname("tml_free");
extern fn TmlMessage* load(TmlStream* stream) @cname("tml_load");