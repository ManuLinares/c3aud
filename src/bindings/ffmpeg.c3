module avutil @link("avutil");

constdef AVMediaType : int
{
	AVMEDIA_TYPE_UNKNOWN    = -1,
	AVMEDIA_TYPE_VIDEO      = 0,
	AVMEDIA_TYPE_AUDIO      = 1,
	AVMEDIA_TYPE_DATA       = 2,
	AVMEDIA_TYPE_SUBTITLE   = 3,
	AVMEDIA_TYPE_ATTACHMENT = 4,
	AVMEDIA_TYPE_NB         = 5
}

constdef AVSampleFormat : int
{
	AV_SAMPLE_FMT_NONE = -1,
	AV_SAMPLE_FMT_U8   = 0,
	AV_SAMPLE_FMT_S16  = 1,
	AV_SAMPLE_FMT_S32  = 2,
	AV_SAMPLE_FMT_FLT  = 3,
	AV_SAMPLE_FMT_DBL  = 4,
	AV_SAMPLE_FMT_U8P  = 5,
	AV_SAMPLE_FMT_S16P = 6,
	AV_SAMPLE_FMT_S32P = 7,
	AV_SAMPLE_FMT_FLTP = 8,
	AV_SAMPLE_FMT_DBLP = 9,
	AV_SAMPLE_FMT_S64  = 10,
	AV_SAMPLE_FMT_S64P = 11,
	AV_SAMPLE_FMT_NB   = 12
}

enum AVChannelOrder
{
	AV_CHANNEL_ORDER_UNSPEC,
	AV_CHANNEL_ORDER_NATIVE,
	AV_CHANNEL_ORDER_CUSTOM,
	AV_CHANNEL_ORDER_AMBISONIC,
	FF_CHANNEL_ORDER_NB
}

struct AVChannelLayout
{
	AVChannelOrder order;
	int nb_channels;
	void* u;
	void* opaque;
}

struct AVRational
{
	int num;
	int den;
}

struct AVBufferRef
{
	void* buffer;
	char* data;
	usz size;
}

struct AVDictionary { void* _unused; }
struct AVDictionaryEntry
{
	char* key;
	char* value;
}

const int AV_DICT_MATCH_CASE    = 1;
const int AV_DICT_IGNORE_SUFFIX = 2;

extern fn AVDictionaryEntry* av_dict_get(AVDictionary* m, ZString key, AVDictionaryEntry* prev, int flags) @cname("av_dict_get");

struct AVClass { void* _unused; }
struct AVFrameSideData { void* _unused; }

struct AVFrame
{
	char*[8] data;
	int[8] linesize;
	char** extended_data;
	int width;
	int height;
	int nb_samples;
	int format;
	int pict_type;
	AVRational sample_aspect_ratio;
	long pts;
	long pkt_dts;
	AVRational time_base;
	int quality;
	void* opaque;
	int repeat_pict;
	int sample_rate;
	AVBufferRef*[8] buf;
	AVBufferRef** extended_buf;
	int nb_extended_buf;
	AVFrameSideData** side_data;
	int nb_side_data;
	int flags;
	int color_range;
	int color_primaries;
	int color_trc;
	int colorspace;
	int chroma_location;
	long best_effort_timestamp;
	AVDictionary* metadata;
	int decode_error_flags;
	AVBufferRef* hw_frames_ctx;
	AVBufferRef* opaque_ref;
	usz crop_top;
	usz crop_bottom;
	usz crop_left;
	usz crop_right;
	void* private_ref;
	AVChannelLayout ch_layout;
	long duration;
	int alpha_mode;
}

struct AVPacket
{
	AVBufferRef* buf;
	long pts;
	long dts;
	char* data;
	int size;
	int stream_index;
	int flags;
	void* side_data;
	int side_data_elems;
	long duration;
	long pos;
	void* opaque;
	AVBufferRef* opaque_ref;
	AVRational time_base;
}

constset AvLog : int
{
    <* Print no output. *>
    QUIET = -8,
    <* Something went really wrong and we will crash now. *>
    PANIC = 0,
    <* Something went wrong and recovery is not possible. *>
    FATAL = 8,
    <* Something went wrong and cannot losslessly be recovered. *>
    ERROR = 16,
    <* Something somehow does not look correct. *>
    WARNING = 24,
    <* Standard information. *>
    INFO = 32,
    <* Detailed information. *>
    VERBOSE = 40,
    <* Stuff which is only useful for libav* developers. *>
    DEBUG = 48,
    MAX_OFFSET = DEBUG - QUIET,
}

extern fn AVFrame* av_frame_alloc() @cname("av_frame_alloc");
extern fn void av_frame_free(AVFrame** frame) @cname("av_frame_free");
extern fn void av_frame_unref(AVFrame* frame) @cname("av_frame_unref");
extern fn void av_channel_layout_default(AVChannelLayout* ch_layout, int nb_channels) @cname("av_channel_layout_default");
extern fn void av_channel_layout_uninit(AVChannelLayout* channel_layout) @cname("av_channel_layout_uninit");
alias AvLogCallback = fn void(void* avcl, int level, ZString fmt, CVaList args);

extern fn int av_strerror(int errnum, char* errbuf, usz errbuf_size) @cname("av_strerror");
extern fn void av_log_set_level(AvLog level) @cname("av_log_set_level");
extern fn int av_log_get_level() @cname("av_log_get_level");
extern fn void av_log_set_callback(AvLogCallback callback) @cname("av_log_set_callback");
extern fn int av_log_format_line2(void* ptr, int level, ZString fmt, CVaList vl, char* line, int line_size, int* print_prefix) @cname("av_log_format_line2");

// ─────────────────────────────────────────────────────────────────────────────
module swresample @link("swresample");
import avutil;

struct SwrContext { void* _unused; }

extern fn SwrContext* swr_alloc() @cname("swr_alloc");
extern fn int swr_alloc_set_opts2(SwrContext** ps, AVChannelLayout* out_ch_layout, AVSampleFormat out_sample_fmt, int out_sample_rate, AVChannelLayout* in_ch_layout, AVSampleFormat in_sample_fmt, int in_sample_rate, int log_offset, void* log_ctx) @cname("swr_alloc_set_opts2");
extern fn int swr_init(SwrContext* s) @cname("swr_init");
extern fn void swr_free(SwrContext** s) @cname("swr_free");
extern fn int swr_convert(SwrContext* s, char** out, int out_count, char** in, int in_count) @cname("swr_convert");

// ─────────────────────────────────────────────────────────────────────────────
module avcodec @link("avcodec");
import avutil;

alias AVCodecID = int;

struct AVCodec { void* _unused; }

struct AVCodecParameters
{
	AVMediaType codec_type;
	AVCodecID codec_id;
	uint codec_tag;
	char* extradata;
	int extradata_size;
	void* coded_side_data;
	int nb_coded_side_data;
	int format;
	long bit_rate;
	int bits_per_coded_sample;
	int bits_per_raw_sample;
	int profile;
	int level;
	int width;
	int height;
	AVRational sample_aspect_ratio;
	AVRational framerate;
	int field_order;
	int color_range;
	int color_primaries;
	int color_trc;
	int color_space;
	int chroma_location;
	int video_delay;
	AVChannelLayout ch_layout;
	int sample_rate;
	int block_align;
	int frame_size;
	int initial_padding;
	int trailing_padding;
	int seek_preroll;
	int alpha_mode;
}

struct AVCodecContext
{
	AVClass* av_class;
	int log_level_offset;
	AVMediaType codec_type;
	AVCodec* codec;
	AVCodecID codec_id;
	uint codec_tag;
	void* priv_data;
	void* internal;
	void* opaque;
	long bit_rate;
	int flags;
	int flags2;
	char* extradata;
	int extradata_size;
	AVRational time_base;
	AVRational pkt_timebase;
	AVRational framerate;
	int delay;
	int width;
	int height;
	int coded_width;
	int coded_height;
	AVRational sample_aspect_ratio;
	int pix_fmt;
	int sw_pix_fmt;
	int color_primaries;
	int color_trc;
	int colorspace;
	int color_range;
	int chroma_sample_location;
	int field_order;
	int refs;
	int has_b_frames;
	int slice_flags;
	void* draw_horiz_band;
	void* get_format;
	int max_b_frames;
	float b_quant_factor;
	float b_quant_offset;
	float i_quant_factor;
	float i_quant_offset;
	float lumi_masking;
	float temporal_cplx_masking;
	float spatial_cplx_masking;
	float p_masking;
	float dark_masking;
	int nsse_weight;
	int me_cmp;
	int me_sub_cmp;
	int mb_cmp;
	int ildct_cmp;
	int dia_size;
	int last_predictor_count;
	int me_pre_cmp;
	int pre_dia_size;
	int me_subpel_quality;
	int me_range;
	int mb_decision;
	ushort* intra_matrix;
	ushort* inter_matrix;
	ushort* chroma_intra_matrix;
	int intra_dc_precision;
	int mb_lmin;
	int mb_lmax;
	int bidir_refine;
	int keyint_min;
	int gop_size;
	int mv0_threshold;
	int slices;
	int sample_rate;
	AVSampleFormat sample_fmt;
	AVChannelLayout ch_layout;
	int frame_size;
	int block_align;
	int cutoff;
	int audio_service_type;
	AVSampleFormat request_sample_fmt;
	int initial_padding;
	int trailing_padding;
	int seek_preroll;
}

extern fn AVCodec* find_decoder(AVCodecID id) @cname("avcodec_find_decoder");
extern fn AVCodecContext* alloc_context3(AVCodec* codec) @cname("avcodec_alloc_context3");
extern fn void free_context(AVCodecContext** avctx) @cname("avcodec_free_context");
extern fn int parameters_to_context(AVCodecContext* codec, AVCodecParameters* par) @cname("avcodec_parameters_to_context");
extern fn int open2(AVCodecContext* avctx, AVCodec* codec, AVDictionary** options) @cname("avcodec_open2");
extern fn int send_packet(AVCodecContext* avctx, AVPacket* avpkt) @cname("avcodec_send_packet");
extern fn int receive_frame(AVCodecContext* avctx, AVFrame* frame) @cname("avcodec_receive_frame");
extern fn void flush_buffers(AVCodecContext* avctx) @cname("avcodec_flush_buffers");
extern fn AVPacket* av_packet_alloc() @cname("av_packet_alloc");
extern fn void av_packet_free(AVPacket** pkt) @cname("av_packet_free");
extern fn void av_packet_unref(AVPacket* pkt) @cname("av_packet_unref");

// ─────────────────────────────────────────────────────────────────────────────
module avformat @link("avformat");
import avutil, avcodec;

struct AVStream
{
	AVClass* av_class;
	int index;
	int id;
	AVCodecParameters* codecpar;
	void* priv_data;
	AVRational time_base;
	long start_time;
	long duration;
	long nb_frames;
	int disposition;
	int discard;
	AVRational sample_aspect_ratio;
	AVDictionary* metadata;
}

struct AVFormatContext
{
	AVClass* av_class;
	void* iformat;
	void* oformat;
	void* priv_data;
	void* pb;
	int ctx_flags;
	uint nb_streams;
	AVStream** streams;
	uint nb_stream_groups;
	void* stream_groups;
	uint nb_chapters;
	void* chapters;
	char* url;
	long start_time;
	long duration;
	long bit_rate;
	uint packet_size;
	int max_delay;
	int flags;
	long probesize;
	long max_analyze_duration;
	char* key;
	int keylen;
	uint nb_programs;
	void* programs;
	int video_codec_id;
	int audio_codec_id;
	int subtitle_codec_id;
	int data_codec_id;
	AVDictionary* metadata;
}

extern fn void* av_find_input_format(ZString short_name) @cname("av_find_input_format");
extern fn int open_input(AVFormatContext** ps, ZString url, void* fmt, AVDictionary** options) @cname("avformat_open_input");
extern fn int find_stream_info(AVFormatContext* ic, AVDictionary** options) @cname("avformat_find_stream_info");
extern fn void close_input(AVFormatContext** s) @cname("avformat_close_input");
extern fn int av_find_best_stream(AVFormatContext* ic, AVMediaType type, int wanted_stream_nb, int related_stream, AVCodec** decoder_ret, int flags) @cname("av_find_best_stream");
extern fn int av_read_frame(AVFormatContext* s, AVPacket* pkt) @cname("av_read_frame");
extern fn int av_seek_frame(AVFormatContext* s, int stream_index, long timestamp, int flags) @cname("av_seek_frame");
extern fn int seek_file(AVFormatContext* s, int stream_index, long min_ts, long ts, long max_ts, int flags) @cname("avformat_seek_file");