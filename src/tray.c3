module tray;

enum TrayAction
{
	NONE,
	TOGGLE_WINDOW,
	TOGGLE_PLAYBACK,
	PREV_TRACK,
	NEXT_TRACK,
	QUIT,
	VOLUME_CHANGE
}

struct TrayEvent
{
	TrayAction action;
	int scroll_delta;
}

fn void init(char[] rgba_pixels, int w, int h)
{
	$switch:
		$case $feat(LINUX):
			tray::linux::init(rgba_pixels, w, h);
		$case $feat(WIN32):
			tray::windows::init(rgba_pixels, w, h);
		$case $feat(MACOS) ||| $feat(DARWIN):
			tray::mac::init(rgba_pixels, w, h);
		$default:
			break;
	$endswitch
}

fn void update_tooltip(String title, String desc)
{
	$switch:
		$case $feat(LINUX):
			tray::linux::update_tooltip(title, desc);
		$case $feat(WIN32):
			tray::windows::update_tooltip(title, desc);
		$case $feat(MACOS) ||| $feat(DARWIN):
			tray::mac::update_tooltip(title, desc);
		$default:
			break;
	$endswitch
}

fn bool poll_event(TrayEvent* out)
{
	$switch:
		$case $feat(LINUX):
			return tray::linux::poll_event(out);
		$case $feat(WIN32):
			return tray::windows::poll_event(out);
		$case $feat(MACOS) ||| $feat(DARWIN):
			return tray::mac::poll_event(out);
		$default:
			return false;
	$endswitch
}

fn void destroy()
{
	$switch:
		$case $feat(LINUX):
			tray::linux::destroy();
		$case $feat(WIN32):
			tray::windows::destroy();
		$case $feat(MACOS) ||| $feat(DARWIN):
			tray::mac::destroy();
		$default:
			break;
	$endswitch
}

// ─────────────────────────────────────────────────────────────────────────────
// Windows Backend (Win32)
// ─────────────────────────────────────────────────────────────────────────────

module tray::windows @feat(WIN32);

import std::thread;
import std::gfx;
import std::math;
import std::core::string::conv;

struct Point
{
	int x;
	int y;
}

struct Msg
{
	void* hwnd;
	uint message;
	uptr wparam;
	iptr lparam;
	uint time;
	Point pt;
}

alias WndProcFn = fn iptr(void* hwnd, uint msg, uptr wparam, iptr lparam);

struct WndClassExW
{
	uint cb_size;
	uint style;
	WndProcFn lpfn_wnd_proc;
	int cb_cls_extra;
	int cb_wnd_extra;
	void* h_instance;
	void* h_icon;
	void* h_cursor;
	void* hbr_background;
	Char16* lpsz_menu_name;
	Char16* lpsz_class_name;
	void* h_icon_sm;
}

struct NotifyIconDataW
{
	uint cb_size;
	void* hwnd;
	uint u_id;
	uint u_flags;
	uint u_callback_message;
	void* h_icon;
	Char16[128] sz_tip;
	uint dw_state;
	uint dw_state_mask;
	Char16[256] sz_info;
	uint u_version;
	Char16[64] sz_info_title;
	uint dw_info_flags;
	char[16] guid_item;
	void* h_balloon_icon;
}

struct BitmapInfoHeader
{
	uint bi_size;
	int bi_width;
	int bi_height;
	ushort bi_planes;
	ushort bi_bit_count;
	uint bi_compression;
	uint bi_size_image;
	int bi_x_pels_per_meter;
	int bi_y_pels_per_meter;
	uint bi_clr_used;
	uint bi_clr_important;
}

struct IconInfo
{
	int f_icon;
	uint x_hotspot;
	uint y_hotspot;
	void* hbm_mask;
	void* hbm_color;
}

const uint NIM_ADD        = 0x00000000;
const uint NIM_MODIFY     = 0x00000001;
const uint NIM_DELETE     = 0x00000002;
const uint NIM_SETVERSION = 0x00000004;

const uint NOTIFYICON_VERSION_4 = 4;

const uint NIF_MESSAGE = 0x00000001;
const uint NIF_ICON    = 0x00000002;
const uint NIF_TIP     = 0x00000004;

const uint WM_USER         = 0x0400;
const uint WM_TRAYICON     = WM_USER + 1;
const uint WM_TRAY_UPDATE  = WM_USER + 2;
const uint WM_DESTROY      = 0x0002;
const uint WM_CLOSE        = 0x0010;
const uint WM_NULL         = 0x0000;
const uint WM_LBUTTONUP    = 0x0202;
const uint WM_RBUTTONUP    = 0x0205;
const uint WM_MBUTTONUP    = 0x0208;
const uint WM_CONTEXTMENU  = 0x007B;
const uint WM_MOUSEWHEEL   = 0x020A;
const uint NIN_SELECT      = WM_USER + 0;

const uint MF_STRING       = 0x00000000;
const uint MF_SEPARATOR    = 0x00000800;
const uint TPM_RETURNCMD   = 0x0100;
const uint TPM_RIGHTBUTTON = 0x0002;

const uint DIB_RGB_COLORS  = 0;

const int ID_MENU_TOGGLE_WINDOW = 1001;
const int ID_MENU_PLAY_PAUSE    = 1002;
const int ID_MENU_PREV          = 1003;
const int ID_MENU_NEXT          = 1004;
const int ID_MENU_QUIT          = 1005;

extern fn void* get_module_handle_w(Char16* lp_module_name) @cname("GetModuleHandleW");
extern fn ushort register_class_ex_w(WndClassExW* lp_wnd_class) @cname("RegisterClassExW");
extern fn void* create_window_ex_w(uint dw_ex_style, Char16* lp_class_name, Char16* lp_window_name, uint dw_style, int x, int y, int n_width, int n_height, void* hwnd_parent, void* h_menu, void* h_instance, void* lp_param) @cname("CreateWindowExW");
extern fn int destroy_window(void* hwnd) @cname("DestroyWindow");
extern fn iptr def_window_proc_w(void* hwnd, uint msg, uptr wparam, iptr lparam) @cname("DefWindowProcW");
extern fn int get_message_w(Msg* lp_msg, void* hwnd, uint w_msg_filter_min, uint w_msg_filter_max) @cname("GetMessageW");
extern fn int translate_message(Msg* lp_msg) @cname("TranslateMessage");
extern fn iptr dispatch_message_w(Msg* lp_msg) @cname("DispatchMessageW");
extern fn int post_message_w(void* hwnd, uint msg, uptr wparam, iptr lparam) @cname("PostMessageW");
extern fn void post_quit_message(int n_exit_code) @cname("PostQuitMessage");
extern fn int set_foreground_window(void* hwnd) @cname("SetForegroundWindow");
extern fn int get_cursor_pos(Point* lp_point) @cname("GetCursorPos");

extern fn void* create_popup_menu() @cname("CreatePopupMenu");
extern fn int append_menu_w(void* h_menu, uint u_flags, uptr u_id_new_item, Char16* lp_new_item) @cname("AppendMenuW");
extern fn int track_popup_menu(void* h_menu, uint u_flags, int x, int y, int n_reserved, void* hwnd, void* prc_rect) @cname("TrackPopupMenu");
extern fn int destroy_menu(void* h_menu) @cname("DestroyMenu");

extern fn void* get_dc(void* hwnd) @cname("GetDC");
extern fn int release_dc(void* hwnd, void* hdc) @cname("ReleaseDC");
extern fn void* create_dib_section(void* hdc, void* pbmi, uint usage, void** ppv_bits, void* h_section, uint offset) @cname("CreateDIBSection");
extern fn void* create_bitmap(int n_width, int n_height, uint n_planes, uint n_bit_count, void* lp_bits) @cname("CreateBitmap");
extern fn int delete_object(void* ho) @cname("DeleteObject");
extern fn void* create_icon_indirect(IconInfo* piconinfo) @cname("CreateIconIndirect");
extern fn int destroy_icon(void* h_icon) @cname("DestroyIcon");

extern fn int shell_notify_icon_w(uint dw_message, NotifyIconDataW* lp_data) @cname("Shell_NotifyIconW") @link("shell32");

struct State
{
	void* hwnd;
	void* hicon;
	Thread thread;
	Mutex lock;
	bool running;
	bool initialized;

	TrayEvent[16] events;
	int event_count;

	char[256] tooltip_title_buf;
	char[256] tooltip_desc_buf;
	bool tooltip_changed;
}

State state;

fn void push_event(TrayAction action, int scroll = 0) @local
{
	state.lock.lock();
	if (state.event_count < (int)state.events.len)
	{
		state.events[state.event_count++] = { action, scroll };
	}
	state.lock.unlock();
	gfx::wake();
}

fn void* create_hicon(char[] rgba, int w, int h)
{
	BitmapInfoHeader bi = {
		.bi_size = BitmapInfoHeader::size,
		.bi_width = w,
		.bi_height = -h,
		.bi_planes = 1,
		.bi_bit_count = 32,
		.bi_compression = 0
	};

	void* bits = null;
	void* hdc = get_dc(null);
	void* hbm_color = create_dib_section(hdc, (void*)&bi, DIB_RGB_COLORS, &bits, null, 0);
	release_dc(null, hdc);

	if (hbm_color == null || bits == null) return null;

	char* dst = (char*)bits;
	sz count = (sz)(w * h);
	for (sz i = 0; i < count; i++)
	{
		sz p = i * 4;
		dst[p + 0] = rgba[p + 2];
		dst[p + 1] = rgba[p + 1];
		dst[p + 2] = rgba[p + 0];
		dst[p + 3] = rgba[p + 3];
	}

	void* hbm_mask = create_bitmap(w, h, 1, 1, null);
	IconInfo ii = {
		.f_icon = 1,
		.hbm_mask = hbm_mask,
		.hbm_color = hbm_color
	};

	void* hicon = create_icon_indirect(&ii);
	delete_object(hbm_color);
	delete_object(hbm_mask);
	return hicon;
}

fn void update_tooltip_internal() => @pool()
{
	if (state.hwnd == null) return;

	state.lock.lock();
	String title = ((ZString)&state.tooltip_title_buf[0]).str_view();
	String desc  = ((ZString)&state.tooltip_desc_buf[0]).str_view();
	state.lock.unlock();

	char[256] tip_buf;
	String full_tip;
	if (desc.len > 0)
	{
		full_tip = string::bformat(&tip_buf, "%s - %s", title, desc);
	}
	else
	{
		full_tip = title;
	}

	NotifyIconDataW nid = {
		.cb_size = NotifyIconDataW::size,
		.hwnd = state.hwnd,
		.u_id = 1,
		.u_flags = NIF_TIP
	};

	if (try u16 = full_tip.to_temp_utf16())
	{
		sz copy_len = math::min(u16.len, nid.sz_tip.len - 1);
		mem::copy(&nid.sz_tip[0], u16.ptr, copy_len * Char16::size);
		nid.sz_tip[copy_len] = 0;
	}

	shell_notify_icon_w(NIM_MODIFY, &nid);
}

fn void show_menu(void* hwnd)
{
	Point pt;
	get_cursor_pos(&pt);

	void* hmenu = create_popup_menu();
	append_menu_w(hmenu, MF_STRING,    ID_MENU_TOGGLE_WINDOW, (Char16*)@wstring("Show / Hide"));
	append_menu_w(hmenu, MF_STRING,    ID_MENU_PLAY_PAUSE,    (Char16*)@wstring("Play / Pause"));
	append_menu_w(hmenu, MF_STRING,    ID_MENU_PREV,          (Char16*)@wstring("Previous"));
	append_menu_w(hmenu, MF_STRING,    ID_MENU_NEXT,          (Char16*)@wstring("Next"));
	append_menu_w(hmenu, MF_SEPARATOR, 0,                     null);
	append_menu_w(hmenu, MF_STRING,    ID_MENU_QUIT,          (Char16*)@wstring("Quit"));

	set_foreground_window(hwnd);
	int cmd = track_popup_menu(hmenu, TPM_RETURNCMD | TPM_RIGHTBUTTON, pt.x, pt.y, 0, hwnd, null);
	post_message_w(hwnd, WM_NULL, 0, 0);
	destroy_menu(hmenu);

	switch (cmd)
	{
		case ID_MENU_TOGGLE_WINDOW: push_event(TOGGLE_WINDOW);
		case ID_MENU_PLAY_PAUSE:    push_event(TOGGLE_PLAYBACK);
		case ID_MENU_PREV:          push_event(PREV_TRACK);
		case ID_MENU_NEXT:          push_event(NEXT_TRACK);
		case ID_MENU_QUIT:          push_event(QUIT);
	}
}

fn iptr wnd_proc(void* hwnd, uint msg, uptr wparam, iptr lparam)
{
	switch (msg)
	{
		case WM_TRAY_UPDATE:
			update_tooltip_internal();
			return 0;

		case WM_TRAYICON:
			uint event = (uint)(lparam & 0xFFFF);
			switch (event)
			{
				case NIN_SELECT:
					push_event(TOGGLE_WINDOW);
					return 0;

				case WM_MBUTTONUP:
					push_event(TOGGLE_PLAYBACK);
					return 0;

				case WM_CONTEXTMENU:
					show_menu(hwnd);
					return 0;

				case WM_MOUSEWHEEL:
					short delta = (short)(wparam >> 16);
					push_event(VOLUME_CHANGE, delta > 0 ? 1 : -1);
					return 0;
			}
			return 0;

		case WM_CLOSE:
			NotifyIconDataW nid = {
				.cb_size = NotifyIconDataW::size,
				.hwnd = hwnd,
				.u_id = 1
			};
			shell_notify_icon_w(NIM_DELETE, &nid);

			if (state.hicon != null)
			{
				destroy_icon(state.hicon);
				state.hicon = null;
			}
			destroy_window(hwnd);
			post_quit_message(0);
			return 0;
	}
	return def_window_proc_w(hwnd, msg, wparam, lparam);
}

fn int worker(void* arg @unused) => @pool_init(mem, 32 * 1024)
{
	WndClassExW wc = {
		.cb_size = WndClassExW::size,
		.lpfn_wnd_proc = (WndProcFn)&wnd_proc,
		.h_instance = get_module_handle_w(null),
		.lpsz_class_name = (Char16*)@wstring("c3aud_tray_class")
	};
	register_class_ex_w(&wc);

	void* hwnd = create_window_ex_w(
		0,
		(Char16*)@wstring("c3aud_tray_class"),
		(Char16*)@wstring("c3aud_tray"),
		0,
		0, 0, 0, 0,
		null, null,
		wc.h_instance,
		null
	);

	if (hwnd == null) return 1;

	state.hwnd = hwnd;

	NotifyIconDataW nid = {
		.cb_size = NotifyIconDataW::size,
		.hwnd = hwnd,
		.u_id = 1,
		.u_flags = NIF_MESSAGE | NIF_ICON | NIF_TIP,
		.u_callback_message = WM_TRAYICON,
		.h_icon = state.hicon
	};

	String default_title = "c3aud";
	if (try u16 = default_title.to_temp_utf16())
	{
		sz copy_len = math::min(u16.len, nid.sz_tip.len - 1);
		mem::copy(&nid.sz_tip[0], u16.ptr, copy_len * Char16::size);
		nid.sz_tip[copy_len] = 0;
	}

	shell_notify_icon_w(NIM_ADD, &nid);

	nid.u_version = NOTIFYICON_VERSION_4;
	shell_notify_icon_w(NIM_SETVERSION, &nid);

	state.initialized = true;

	Msg msg;
	while (get_message_w(&msg, null, 0, 0) > 0)
	{
		translate_message(&msg);
		dispatch_message_w(&msg);
	}
	return 0;
}

fn void init(char[] rgba_pixels, int w, int h)
{
	if (state.initialized) return;

	state.lock.init()!!;

	state.hicon = create_hicon(rgba_pixels, w, h);
	if (state.hicon == null) return;

	String default_title = "c3aud";
	mem::copy(&state.tooltip_title_buf, default_title, default_title.len);
	state.tooltip_title_buf[default_title.len] = 0;
	state.tooltip_desc_buf[0] = 0;

	state.running = true;
	state.thread.create(&worker, null)!!;

	while (!state.initialized && state.running)
	{
		thread::sleep_ms(1);
	}
}

fn void update_tooltip(String title, String desc)
{
	if (!state.initialized) return;

	state.lock.lock();
	sz tlen = math::min(title.len, (sz)255);
	mem::copy(&state.tooltip_title_buf, title, tlen);
	state.tooltip_title_buf[tlen] = 0;

	sz dlen = math::min(desc.len, (sz)255);
	mem::copy(&state.tooltip_desc_buf, desc, dlen);
	state.tooltip_desc_buf[dlen] = 0;
	state.lock.unlock();

	if (state.hwnd != null)
	{
		post_message_w(state.hwnd, WM_TRAY_UPDATE, 0, 0);
	}
}

fn bool poll_event(TrayEvent* out)
{
	if (!state.initialized) return false;
	state.lock.lock();
	defer state.lock.unlock();
	if (state.event_count == 0) return false;
	*out = state.events[0];
	for (int i = 0; i < state.event_count - 1; i++)
	{
		state.events[i] = state.events[i + 1];
	}
	state.event_count--;
	return true;
}

fn void destroy()
{
	if (!state.initialized) return;
	state.running = false;
	if (state.hwnd != null)
	{
		post_message_w(state.hwnd, WM_CLOSE, 0, 0);
	}
	state.thread.join()!!;
	state.lock.destroy();
	state.initialized = false;
}

// ─────────────────────────────────────────────────────────────────────────────
// macOS Backend (AppKit)
// ─────────────────────────────────────────────────────────────────────────────

module tray::mac @feat(MACOS, DARWIN);

import std::thread;
import std::gfx;
import std::math;

extern fn void* objc_getClass(char* name) @cname("objc_getClass");
extern fn void* sel_registerName(char* name) @cname("sel_registerName");
extern fn void* objc_msgSend(void* self, void* op, ...) @cname("objc_msgSend");
extern fn void* objc_allocateClassPair(void* superclass, char* name, usz extra_bytes) @cname("objc_allocateClassPair");
extern fn bool class_addMethod(void* cls, void* name, void* imp, char* types) @cname("class_addMethod");
extern fn void objc_registerClassPair(void* cls) @cname("objc_registerClassPair");

alias MsgSend        = fn void*(void* self, void* op);
alias MsgSendId      = fn void*(void* self, void* op, void* a);
alias MsgSendDouble  = fn void*(void* self, void* op, double a);
alias MsgSendVoid    = fn void(void* self, void* op);
alias MsgSendVoidId  = fn void(void* self, void* op, void* a);
alias MsgSendVoidBool = fn void(void* self, void* op, bool a);

struct NsSize
{
	double width;
	double height;
}

alias MsgSendVoidSize = fn void(void* self, void* op, NsSize size);
alias MsgSendInitBitmap = fn void*(void* self, void* op, void* planes, long w, long h, long bps, long spp, bool has_alpha, bool is_planar, void* color_space, ulong bitmap_format, long bytes_per_row, long bits_per_pixel);
alias MsgSendInitMenuItem = fn void*(void* self, void* op, void* title, void* action, void* key_equivalent);

struct State
{
	void* status_item;
	void* target;
	Mutex lock;
	bool initialized;

	TrayEvent[16] events;
	int event_count;

	char[256] tooltip_title_buf;
	char[256] tooltip_desc_buf;
	bool tooltip_changed;
}

State state;

fn void push_event(TrayAction action, int scroll = 0) @local
{
	state.lock.lock();
	if (state.event_count < (int)state.events.len)
	{
		state.events[state.event_count++] = { action, scroll };
	}
	state.lock.unlock();
	gfx::wake();
}

fn void* ns_string(String s) => @pool()
{
	return ((MsgSendId)&objc_msgSend)(objc_getClass("NSString"), sel_registerName("stringWithUTF8String:"), (void*)s.zstr_tcopy());
}

fn void on_toggle_window(void* self, void* op, void* sender)
{
	(void)self; (void)op; (void)sender;
	push_event(TOGGLE_WINDOW);
}

fn void on_toggle_playback(void* self, void* op, void* sender)
{
	(void)self; (void)op; (void)sender;
	push_event(TOGGLE_PLAYBACK);
}

fn void on_prev_track(void* self, void* op, void* sender)
{
	(void)self; (void)op; (void)sender;
	push_event(PREV_TRACK);
}

fn void on_next_track(void* self, void* op, void* sender)
{
	(void)self; (void)op; (void)sender;
	push_event(NEXT_TRACK);
}

fn void on_quit(void* self, void* op, void* sender)
{
	(void)self; (void)op; (void)sender;
	push_event(QUIT);
}

fn void* make_menu_item(String title, void* action_sel, void* target) => @pool()
{
	void* cls_item = objc_getClass("NSMenuItem");
	void* item_alloc = ((MsgSend)&objc_msgSend)(cls_item, sel_registerName("alloc"));
	void* empty_str = ns_string("");
	void* title_str = ns_string(title);

	void* item = ((MsgSendInitMenuItem)&objc_msgSend)(
		item_alloc,
		sel_registerName("initWithTitle:action:keyEquivalent:"),
		title_str,
		action_sel,
		empty_str
	);
	((MsgSendVoidId)&objc_msgSend)(item, sel_registerName("setTarget:"), target);
	return item;
}

fn void apply_tooltip() => @pool()
{
	if (state.status_item == null) return;

	state.lock.lock();
	String title = ((ZString)&state.tooltip_title_buf[0]).str_view();
	String desc  = ((ZString)&state.tooltip_desc_buf[0]).str_view();
	state.lock.unlock();

	char[512] buf;
	String tip;
	if (desc.len > 0)
	{
		tip = string::bformat(&buf, "%s - %s", title, desc);
	}
	else
	{
		tip = title;
	}

	void* ns_tip = ns_string(tip);
	void* btn = ((MsgSend)&objc_msgSend)(state.status_item, sel_registerName("button"));
	if (btn != null)
	{
		((MsgSendVoidId)&objc_msgSend)(btn, sel_registerName("setToolTip:"), ns_tip);
	}
	else
	{
		((MsgSendVoidId)&objc_msgSend)(state.status_item, sel_registerName("setToolTip:"), ns_tip);
	}
}

fn void init(char[] rgba_pixels, int w, int h) => @pool()
{
	if (state.initialized) return;
	state.lock.init()!!;

	void* cls_ns_status_bar = objc_getClass("NSStatusBar");
	if (cls_ns_status_bar == null) return;

	void* status_bar = ((MsgSend)&objc_msgSend)(cls_ns_status_bar, sel_registerName("systemStatusBar"));
	if (status_bar == null) return;

	void* status_item = ((MsgSendDouble)&objc_msgSend)(status_bar, sel_registerName("statusItemWithLength:"), -1.0);
	if (status_item == null) return;
	((MsgSend)&objc_msgSend)(status_item, sel_registerName("retain"));
	state.status_item = status_item;

	void* cls_ns_string = objc_getClass("NSString");
	void* cs_name = ((MsgSendId)&objc_msgSend)(cls_ns_string, sel_registerName("stringWithUTF8String:"), (void*)"NSCalibratedRGBColorSpace");

	void* rep_alloc = ((MsgSend)&objc_msgSend)(objc_getClass("NSBitmapImageRep"), sel_registerName("alloc"));
	void* rep = ((MsgSendInitBitmap)&objc_msgSend)(
		rep_alloc,
		sel_registerName("initWithBitmapDataPlanes:pixelsWide:pixelsHigh:bitsPerSample:samplesPerPixel:hasAlpha:isPlanar:colorSpaceName:bitmapFormat:bytesPerRow:bitsPerPixel:"),
		null,
		(long)w,
		(long)h,
		8,
		4,
		true,
		false,
		cs_name,
		2UL,
		(long)(w * 4),
		32
	);

	if (rep != null)
	{
		char* pixels = (char*)((MsgSend)&objc_msgSend)(rep, sel_registerName("bitmapData"));
		if (pixels != null)
		{
			mem::copy(pixels, rgba_pixels.ptr, (sz)(w * h * 4));
		}
	}

	void* img_alloc = ((MsgSend)&objc_msgSend)(objc_getClass("NSImage"), sel_registerName("alloc"));
	void* img = ((MsgSend)&objc_msgSend)(img_alloc, sel_registerName("init"));
	((MsgSendVoidId)&objc_msgSend)(img, sel_registerName("addRepresentation:"), rep);
	((MsgSendVoidSize)&objc_msgSend)(img, sel_registerName("setSize:"), (NsSize){ 18.0, 18.0 });
	((MsgSendVoidBool)&objc_msgSend)(img, sel_registerName("setTemplate:"), false);

	void* btn = ((MsgSend)&objc_msgSend)(status_item, sel_registerName("button"));
	if (btn != null)
	{
		((MsgSendVoidId)&objc_msgSend)(btn, sel_registerName("setImage:"), img);
	}
	else
	{
		((MsgSendVoidId)&objc_msgSend)(status_item, sel_registerName("setImage:"), img);
	}

	void* superclass = objc_getClass("NSObject");
	void* target_class = objc_allocateClassPair(superclass, "C3AudTrayTarget", 0);
	if (target_class != null)
	{
		class_addMethod(target_class, sel_registerName("onToggleWindow:"),   (void*)&on_toggle_window,   "v@:@");
		class_addMethod(target_class, sel_registerName("onTogglePlayback:"), (void*)&on_toggle_playback, "v@:@");
		class_addMethod(target_class, sel_registerName("onPrevTrack:"),      (void*)&on_prev_track,      "v@:@");
		class_addMethod(target_class, sel_registerName("onNextTrack:"),      (void*)&on_next_track,      "v@:@");
		class_addMethod(target_class, sel_registerName("onQuit:"),           (void*)&on_quit,           "v@:@");
		objc_registerClassPair(target_class);
	}
	else
	{
		target_class = objc_getClass("C3AudTrayTarget");
	}

	void* target_alloc = ((MsgSend)&objc_msgSend)(target_class, sel_registerName("alloc"));
	void* target = ((MsgSend)&objc_msgSend)(target_alloc, sel_registerName("init"));
	state.target = target;

	void* cls_ns_menu = objc_getClass("NSMenu");
	void* cls_ns_menu_item = objc_getClass("NSMenuItem");
	void* menu_alloc = ((MsgSend)&objc_msgSend)(cls_ns_menu, sel_registerName("alloc"));
	void* menu = ((MsgSend)&objc_msgSend)(menu_alloc, sel_registerName("init"));

	void* item_win  = make_menu_item("Show / Hide",    sel_registerName("onToggleWindow:"),   target);
	void* item_play = make_menu_item("Play / Pause",   sel_registerName("onTogglePlayback:"), target);
	void* item_prev = make_menu_item("Previous Track", sel_registerName("onPrevTrack:"),      target);
	void* item_next = make_menu_item("Next Track",     sel_registerName("onNextTrack:"),      target);
	void* sep       = ((MsgSend)&objc_msgSend)(cls_ns_menu_item, sel_registerName("separatorItem"));
	void* item_quit = make_menu_item("Quit",           sel_registerName("onQuit:"),           target);

	((MsgSendVoidId)&objc_msgSend)(menu, sel_registerName("addItem:"), item_win);
	((MsgSendVoidId)&objc_msgSend)(menu, sel_registerName("addItem:"), item_play);
	((MsgSendVoidId)&objc_msgSend)(menu, sel_registerName("addItem:"), item_prev);
	((MsgSendVoidId)&objc_msgSend)(menu, sel_registerName("addItem:"), item_next);
	((MsgSendVoidId)&objc_msgSend)(menu, sel_registerName("addItem:"), sep);
	((MsgSendVoidId)&objc_msgSend)(menu, sel_registerName("addItem:"), item_quit);

	((MsgSendVoidId)&objc_msgSend)(status_item, sel_registerName("setMenu:"), menu);

	String default_title = "c3aud";
	mem::copy(&state.tooltip_title_buf, default_title, default_title.len);
	state.tooltip_title_buf[default_title.len] = 0;
	state.tooltip_desc_buf[0] = 0;

	apply_tooltip();
	state.initialized = true;
}

fn void update_tooltip(String title, String desc)
{
	if (!state.initialized) return;

	state.lock.lock();
	sz tlen = math::min(title.len, (sz)255);
	mem::copy(&state.tooltip_title_buf, title, tlen);
	state.tooltip_title_buf[tlen] = 0;

	sz dlen = math::min(desc.len, (sz)255);
	mem::copy(&state.tooltip_desc_buf, desc, dlen);
	state.tooltip_desc_buf[dlen] = 0;
	state.tooltip_changed = true;
	state.lock.unlock();

	gfx::wake();
}

fn bool poll_event(TrayEvent* out)
{
	if (!state.initialized) return false;

	if (state.tooltip_changed)
	{
		apply_tooltip();
		state.tooltip_changed = false;
	}

	state.lock.lock();
	defer state.lock.unlock();
	if (state.event_count == 0) return false;
	*out = state.events[0];
	for (int i = 0; i < state.event_count - 1; i++)
	{
		state.events[i] = state.events[i + 1];
	}
	state.event_count--;
	return true;
}

fn void destroy()
{
	if (!state.initialized) return;

	if (state.status_item != null)
	{
		void* bar = ((MsgSend)&objc_msgSend)(objc_getClass("NSStatusBar"), sel_registerName("systemStatusBar"));
		((MsgSendVoidId)&objc_msgSend)(bar, sel_registerName("removeStatusItem:"), state.status_item);
		((MsgSendVoid)&objc_msgSend)(state.status_item, sel_registerName("release"));
		state.status_item = null;
	}

	if (state.target != null)
	{
		((MsgSendVoid)&objc_msgSend)(state.target, sel_registerName("release"));
		state.target = null;
	}

	state.lock.destroy();
	state.initialized = false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Linux Backend (D-Bus / StatusNotifierItem)
// ─────────────────────────────────────────────────────────────────────────────

module tray::linux @feat(LINUX);

import std::thread;
import std::gfx;
import std::math;

const int DBUS_BUS_SESSION = 0;

const uint DBUS_NAME_FLAG_DO_NOT_QUEUE = 0x4;
const int DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER = 1;

const int DBUS_MESSAGE_TYPE_METHOD_CALL   = 1;
const int DBUS_MESSAGE_TYPE_METHOD_RETURN = 2;
const int DBUS_MESSAGE_TYPE_ERROR         = 3;
const int DBUS_MESSAGE_TYPE_SIGNAL        = 4;

constdef DBusType : CInt
{
	BYTE        = 'y',
	BOOLEAN     = 'b',
	INT16       = 'n',
	UINT16      = 'q',
	INT32       = 'i',
	UINT32      = 'u',
	INT64       = 'x',
	UINT64      = 't',
	DOUBLE      = 'd',
	STRING      = 's',
	OBJECT_PATH = 'o',
	SIGNATURE   = 'g',
	ARRAY       = 'a',
	VARIANT     = 'v',
	STRUCT      = 'r',
	DICT_ENTRY  = 'e',
}

struct DBusConnection { void* _opaque; }
struct DBusMessage { void* _opaque; }

struct DBusError
{
	char* name;
	char* message;
	bitstruct : uint
	{
		bool dummy1 : 0;
		bool dummy2 : 1;
		bool dummy3 : 2;
		bool dummy4 : 3;
		bool dummy5 : 4;
	}
	void* padding1;
}

struct DBusMessageIter
{
	void* dummy1;
	void* dummy2;
	uint dummy3;
	int dummy4;
	int dummy5;
	int dummy6;
	int dummy7;
	int dummy8;
	int dummy9;
	int dummy10;
	int dummy11;
	int pad1;
	void* pad2;
	void* pad3;
}

extern fn void dbus_error_init(DBusError* error);
extern fn void dbus_error_free(DBusError* error);

extern fn DBusConnection* dbus_bus_get_private(int type, DBusError* error);
extern fn int dbus_bus_request_name(DBusConnection* connection, ZString name, uint flags, DBusError* error);
extern fn void dbus_bus_add_match(DBusConnection* connection, ZString rule, DBusError* error);

extern fn int dbus_connection_get_unix_fd(DBusConnection* connection, int* fd);
extern fn uint dbus_connection_read_write(DBusConnection* connection, int timeout_milliseconds);
extern fn DBusMessage* dbus_connection_pop_message(DBusConnection* connection);
extern fn bool dbus_connection_send(DBusConnection* connection, DBusMessage* message, uint* client_serial);
extern fn DBusMessage* dbus_connection_send_with_reply_and_block(DBusConnection* connection, DBusMessage* message, int timeout_milliseconds, DBusError* error);
extern fn void dbus_connection_flush(DBusConnection* connection);
extern fn void dbus_connection_close(DBusConnection* connection);
extern fn void dbus_connection_unref(DBusConnection* connection);

extern fn DBusMessage* dbus_message_new_signal(ZString path, ZString iface, ZString name);
extern fn DBusMessage* dbus_message_new_method_call(ZString destination, ZString path, ZString iface, ZString method);
extern fn DBusMessage* dbus_message_new_method_return(DBusMessage* method_call);
extern fn DBusMessage* dbus_message_new_error(DBusMessage* reply_to, ZString error_name, ZString error_message);
extern fn void dbus_message_unref(DBusMessage* message);

extern fn int dbus_message_get_type(DBusMessage* message);
extern fn ZString dbus_message_get_path(DBusMessage* message);
extern fn ZString dbus_message_get_interface(DBusMessage* message);
extern fn ZString dbus_message_get_member(DBusMessage* message);

extern fn bool dbus_message_iter_init(DBusMessage* message, DBusMessageIter* iter);
extern fn void dbus_message_iter_init_append(DBusMessage* message, DBusMessageIter* iter);
extern fn DBusType dbus_message_iter_get_arg_type(DBusMessageIter* iter);
extern fn void dbus_message_iter_get_basic(DBusMessageIter* iter, void* value);
extern fn bool dbus_message_iter_next(DBusMessageIter* iter);
extern fn void dbus_message_iter_recurse(DBusMessageIter* iter, DBusMessageIter* sub);
extern fn bool dbus_message_iter_append_basic(DBusMessageIter* iter, DBusType type, void* value);
extern fn bool dbus_message_iter_append_fixed_array(DBusMessageIter* iter, DBusType type, void* value, int n_elements);
extern fn bool dbus_message_iter_open_container(DBusMessageIter* iter, DBusType type, char* contained_signature, DBusMessageIter* sub);
extern fn bool dbus_message_iter_close_container(DBusMessageIter* iter, DBusMessageIter* sub);

extern fn CInt getpid();
extern fn uint dbus_threads_init_default();

struct State
{
	DBusConnection* conn;
	Thread thread;
	Mutex lock;
	bool running;
	bool initialized;

	TrayEvent[16] events;
	int event_count;

	int icon_w;
	int icon_h;
	char[] icon_argb;

	char[256] tooltip_title_buf;
	char[256] tooltip_desc_buf;
	bool tooltip_changed;
}

State state;

fn void push_event(TrayAction action, int scroll = 0) @local
{
	state.lock.lock();
	if (state.event_count < (int)state.events.len)
	{
		state.events[state.event_count++] = { action, scroll };
	}
	state.lock.unlock();
	gfx::wake();
}

macro void @with_container(DBusMessageIter* parent, DBusType type, char* sig; @body(DBusMessageIter* sub))
{
	DBusMessageIter sub;
	dbus_message_iter_open_container(parent, type, sig, &sub);
	@body(&sub);
	dbus_message_iter_close_container(parent, &sub);
}

macro void @with_dict_entry(DBusMessageIter* dict, ZString key, char* sig; @body(DBusMessageIter* v))
{
	@with_container(dict, DBusType.DICT_ENTRY, null; entry) {
		dbus_message_iter_append_basic(entry, DBusType.STRING, &key);
		@with_container(entry, DBusType.VARIANT, sig; v_sub) {
			@body(v_sub);
		};
	};
}

macro void @append_prop(DBusMessageIter* dict, ZString key, char* sig, DBusType dbus_type, val)
{
	@with_dict_entry(dict, key, sig; v) {
		var v_val = val;
		dbus_message_iter_append_basic(v, dbus_type, &v_val);
	};
}

macro void @reply_variant(DBusMessageIter* iter, char* sig, DBusType dbus_type, val)
{
	@with_container(iter, DBusType.VARIANT, sig; v) {
		var v_val = val;
		dbus_message_iter_append_basic(v, dbus_type, &v_val);
	};
}

fn void send_empty_reply(DBusConnection* conn, DBusMessage* msg)
{
	if (DBusMessage* reply = dbus_message_new_method_return(msg))
	{
		dbus_connection_send(conn, reply, null);
		dbus_message_unref(reply);
	}
}

fn void send_error_reply(DBusConnection* conn, DBusMessage* msg, ZString name, ZString message)
{
	if (DBusMessage* err = dbus_message_new_error(msg, name, message))
	{
		dbus_connection_send(conn, err, null);
		dbus_message_unref(err);
	}
}

fn void append_empty_pixmap_array(DBusMessageIter* iter)
{
	@with_container(iter, DBusType.ARRAY, "(iiay)"; arr) {};
}

fn void append_icon_pixmap(DBusMessageIter* iter, int width, int height, char* data, sz byte_len)
{
	@with_container(iter, DBusType.ARRAY, "(iiay)"; arr) {
		if (data != null && byte_len > 0)
		{
			@with_container(arr, DBusType.STRUCT, null; st) {
				dbus_message_iter_append_basic(st, DBusType.INT32, &width);
				dbus_message_iter_append_basic(st, DBusType.INT32, &height);

				@with_container(st, DBusType.ARRAY, "y"; bytes) {
					char* ptr = data;
					dbus_message_iter_append_fixed_array(bytes, DBusType.BYTE, &ptr, (int)byte_len);
				};
			};
		}
	};
}

fn void append_tooltip(DBusMessageIter* iter, ZString title, ZString desc)
{
	@with_container(iter, DBusType.STRUCT, null; st) {
		ZString empty = "";
		dbus_message_iter_append_basic(st, DBusType.STRING, &empty);
		append_empty_pixmap_array(st);
		dbus_message_iter_append_basic(st, DBusType.STRING, &title);
		dbus_message_iter_append_basic(st, DBusType.STRING, &desc);
	};
}

macro void @append_menu_item(DBusMessageIter* arr, int item_id, ZString label, ZString icon_name, bool enabled)
{
	@with_container(arr, DBusType.STRUCT, null; item) {
		dbus_message_iter_append_basic(item, DBusType.INT32, &item_id);
		@with_container(item, DBusType.ARRAY, "{sv}"; props) {
			@with_dict_entry(props, "label", "s"; v)     { dbus_message_iter_append_basic(v, DBusType.STRING, &label); };
			@with_dict_entry(props, "icon-name", "s"; v) { dbus_message_iter_append_basic(v, DBusType.STRING, &icon_name); };
			@with_dict_entry(props, "enabled", "b"; v)   { uint e = enabled ? 1 : 0; dbus_message_iter_append_basic(v, DBusType.BOOLEAN, &e); };
			@with_dict_entry(props, "visible", "b"; v)   { uint vis = 1; dbus_message_iter_append_basic(v, DBusType.BOOLEAN, &vis); };
			@with_dict_entry(props, "type", "s"; v)      { ZString t = "standard"; dbus_message_iter_append_basic(v, DBusType.STRING, &t); };
		};
		@with_container(item, DBusType.ARRAY, "v"; children) {};
	};
}

macro void @append_separator(DBusMessageIter* arr, int item_id)
{
	@with_container(arr, DBusType.STRUCT, null; item) {
		dbus_message_iter_append_basic(item, DBusType.INT32, &item_id);
		@with_container(item, DBusType.ARRAY, "{sv}"; props) {
			@with_dict_entry(props, "type", "s"; v) {
				ZString t = "separator";
				dbus_message_iter_append_basic(v, DBusType.STRING, &t);
			};
		};
		@with_container(item, DBusType.ARRAY, "v"; children) {};
	};
}

fn ZString introspect_xml_root() =>
	(ZString)`<!DOCTYPE node PUBLIC "-//freedesktop//DTD D-BUS Object Introspection 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd">
<node>
  <node name="StatusNotifierItem"/>
  <node name="menu"/>
</node>
`;

fn ZString introspect_xml_sni() =>
	(ZString)`<!DOCTYPE node PUBLIC "-//freedesktop//DTD D-BUS Object Introspection 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd">
<node>
  <interface name="org.freedesktop.DBus.Introspectable">
    <method name="Introspect">
      <arg name="data" type="s" direction="out"/>
    </method>
  </interface>
  <interface name="org.freedesktop.DBus.Properties">
    <method name="Get">
      <arg name="interface" type="s" direction="in"/>
      <arg name="property" type="s" direction="in"/>
      <arg name="value" type="v" direction="out"/>
    </method>
    <method name="Set">
      <arg name="interface" type="s" direction="in"/>
      <arg name="property" type="s" direction="in"/>
      <arg name="value" type="v" direction="in"/>
    </method>
    <method name="GetAll">
      <arg name="interface" type="s" direction="in"/>
      <arg name="properties" type="a{sv}" direction="out"/>
    </method>
    <signal name="PropertiesChanged">
      <arg name="interface" type="s"/>
      <arg name="changed_properties" type="a{sv}"/>
      <arg name="invalidated_properties" type="as"/>
    </signal>
  </interface>
  <interface name="org.kde.StatusNotifierItem">
    <property name="Category" type="s" access="read"/>
    <property name="Id" type="s" access="read"/>
    <property name="Title" type="s" access="read"/>
    <property name="Status" type="s" access="read"/>
    <property name="WindowId" type="i" access="read"/>
    <property name="IconThemePath" type="s" access="read"/>
    <property name="ItemIsMenu" type="b" access="read"/>
    <property name="Menu" type="o" access="read"/>
    <property name="IconName" type="s" access="read"/>
    <property name="IconPixmap" type="a(iiay)" access="read"/>
    <property name="OverlayIconName" type="s" access="read"/>
    <property name="OverlayIconPixmap" type="a(iiay)" access="read"/>
    <property name="AttentionIconName" type="s" access="read"/>
    <property name="AttentionIconPixmap" type="a(iiay)" access="read"/>
    <property name="AttentionMovieName" type="s" access="read"/>
    <property name="ToolTip" type="(sa(iiay)ss)" access="read"/>
    <method name="ContextMenu">
      <arg name="x" type="i" direction="in"/>
      <arg name="y" type="i" direction="in"/>
    </method>
    <method name="Activate">
      <arg name="x" type="i" direction="in"/>
      <arg name="y" type="i" direction="in"/>
    </method>
    <method name="SecondaryActivate">
      <arg name="x" type="i" direction="in"/>
      <arg name="y" type="i" direction="in"/>
    </method>
    <method name="Scroll">
      <arg name="delta" type="i" direction="in"/>
      <arg name="orientation" type="s" direction="in"/>
    </method>
    <method name="ProvideXdgActivationToken">
      <arg name="token" type="s" direction="in"/>
    </method>
    <signal name="NewTitle"/>
    <signal name="NewIcon"/>
    <signal name="NewAttentionIcon"/>
    <signal name="NewOverlayIcon"/>
    <signal name="NewToolTip"/>
    <signal name="NewStatus">
      <arg name="status" type="s"/>
    </signal>
  </interface>
</node>
`;

fn ZString introspect_xml_menu() =>
	(ZString)`<!DOCTYPE node PUBLIC "-//freedesktop//DTD D-BUS Object Introspection 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd">
<node>
  <interface name="org.freedesktop.DBus.Introspectable">
    <method name="Introspect">
      <arg name="data" type="s" direction="out"/>
    </method>
  </interface>
  <interface name="com.canonical.dbusmenu">
    <property name="Version" type="u" access="read"/>
    <property name="TextDirection" type="s" access="read"/>
    <property name="Status" type="s" access="read"/>
    <property name="IconThemePath" type="as" access="read"/>
    <method name="GetLayout">
      <arg name="parentId" type="i" direction="in"/>
      <arg name="recursionDepth" type="i" direction="in"/>
      <arg name="propertyNames" type="as" direction="in"/>
      <arg name="revision" type="u" direction="out"/>
      <arg name="layout" type="(ia{sv}av)" direction="out"/>
    </method>
    <method name="GetGroupProperties">
      <arg name="ids" type="ai" direction="in"/>
      <arg name="propertyNames" type="as" direction="in"/>
      <arg name="properties" type="a(ia{sv})" direction="out"/>
    </method>
    <method name="GetProperty">
      <arg name="id" type="i" direction="in"/>
      <arg name="name" type="s" direction="in"/>
      <arg name="value" type="v" direction="out"/>
    </method>
    <method name="Event">
      <arg name="id" type="i" direction="in"/>
      <arg name="eventId" type="s" direction="in"/>
      <arg name="data" type="v" direction="in"/>
      <arg name="timestamp" type="u" direction="in"/>
    </method>
    <method name="EventGroup">
      <arg name="events" type="a(isvu)" direction="in"/>
      <arg name="idErrors" type="ai" direction="out"/>
    </method>
    <method name="AboutToShow">
      <arg name="id" type="i" direction="in"/>
      <arg name="needUpdate" type="b" direction="out"/>
    </method>
    <method name="AboutToShowGroup">
      <arg name="ids" type="ai" direction="in"/>
      <arg name="updatesNeeded" type="ai" direction="out"/>
      <arg name="idErrors" type="ai" direction="out"/>
    </method>
    <signal name="ItemsPropertiesUpdated">
      <arg name="updatedProps" type="a(ia{sv})" direction="out"/>
      <arg name="removedProps" type="a(ias)" direction="out"/>
    </signal>
    <signal name="LayoutUpdated">
      <arg name="revision" type="u" direction="out"/>
      <arg name="parent" type="i" direction="out"/>
    </signal>
    <signal name="ItemActivationRequested">
      <arg name="id" type="i" direction="out"/>
      <arg name="timestamp" type="u" direction="out"/>
    </signal>
  </interface>
</node>
`;

fn void handle_introspect(DBusConnection* conn, DBusMessage* msg)
{
	ZString path = dbus_message_get_path(msg);
	ZString xml;
	if (path == "/")
	{
		xml = introspect_xml_root();
	}
	else if (path == "/menu")
	{
		xml = introspect_xml_menu();
	}
	else
	{
		xml = introspect_xml_sni();
	}

	DBusMessage* reply = dbus_message_new_method_return(msg);
	if (reply == null) return;
	defer dbus_message_unref(reply);

	DBusMessageIter iter;
	dbus_message_iter_init_append(reply, &iter);
	dbus_message_iter_append_basic(&iter, STRING, &xml);

	dbus_connection_send(conn, reply, null);
}

fn void handle_prop_get_all(DBusConnection* conn, DBusMessage* msg)
{
	DBusMessageIter in_iter;
	ZString iface_arg = "";
	if (dbus_message_iter_init(msg, &in_iter))
	{
		dbus_message_iter_get_basic(&in_iter, &iface_arg);
	}

	DBusMessage* reply = dbus_message_new_method_return(msg);
	if (reply == null) return;
	defer dbus_message_unref(reply);

	DBusMessageIter r_iter;
	dbus_message_iter_init_append(reply, &r_iter);

	if (iface_arg != "org.kde.StatusNotifierItem")
	{
		@with_container(&r_iter, DBusType.ARRAY, "{sv}"; d) {};
		dbus_connection_send(conn, reply, null);
		return;
	}

	@with_container(&r_iter, DBusType.ARRAY, "{sv}"; dict) {
		@append_prop(dict, "Category", "s", DBusType.STRING, (ZString)"ApplicationStatus");
		@append_prop(dict, "Id", "s", DBusType.STRING, (ZString)"c3aud");
		@append_prop(dict, "Title", "s", DBusType.STRING, (ZString)"c3aud");
		@append_prop(dict, "Status", "s", DBusType.STRING, (ZString)"Active");
		@append_prop(dict, "WindowId", "i", DBusType.INT32, 0);
		@append_prop(dict, "IconThemePath", "s", DBusType.STRING, (ZString)"");
		@append_prop(dict, "ItemIsMenu", "b", DBusType.BOOLEAN, (uint)0);
		@append_prop(dict, "Menu", "o", DBusType.OBJECT_PATH, (ZString)"/menu");
		@append_prop(dict, "IconName", "s", DBusType.STRING, (ZString)"c3aud");

		@with_dict_entry(dict, "IconPixmap", "a(iiay)"; v) {
			state.lock.lock();
			defer state.lock.unlock();
			append_icon_pixmap(v, state.icon_w, state.icon_h, state.icon_argb.ptr, state.icon_argb.len);
		};

		@append_prop(dict, "OverlayIconName", "s", DBusType.STRING, (ZString)"");
		@with_dict_entry(dict, "OverlayIconPixmap", "a(iiay)"; v) {
			append_empty_pixmap_array(v);
		};

		@append_prop(dict, "AttentionIconName", "s", DBusType.STRING, (ZString)"");
		@with_dict_entry(dict, "AttentionIconPixmap", "a(iiay)"; v) {
			append_empty_pixmap_array(v);
		};

		@append_prop(dict, "AttentionMovieName", "s", DBusType.STRING, (ZString)"");

		@with_dict_entry(dict, "ToolTip", "(sa(iiay)ss)"; v) {
			state.lock.lock();
			defer state.lock.unlock();
			append_tooltip(v, (ZString)&state.tooltip_title_buf, (ZString)&state.tooltip_desc_buf);
		};
	};

	dbus_connection_send(conn, reply, null);
}

fn void handle_prop_get(DBusConnection* conn, DBusMessage* msg)
{
	DBusMessageIter iter;
	if (!dbus_message_iter_init(msg, &iter)) return;

	ZString iface;
	dbus_message_iter_get_basic(&iter, &iface);
	dbus_message_iter_next(&iter);

	ZString prop;
	dbus_message_iter_get_basic(&iter, &prop);

	DBusMessage* reply = dbus_message_new_method_return(msg);
	if (reply == null) return;
	defer dbus_message_unref(reply);

	DBusMessageIter r_iter;
	dbus_message_iter_init_append(reply, &r_iter);

	switch (prop.str_view())
	{
		case "Category":
			@reply_variant(&r_iter, "s", DBusType.STRING, (ZString)"ApplicationStatus");
		case "Id":
		case "Title":
		case "IconName":
			@reply_variant(&r_iter, "s", DBusType.STRING, (ZString)"c3aud");
		case "Status":
			@reply_variant(&r_iter, "s", DBusType.STRING, (ZString)"Active");
		case "WindowId":
			@reply_variant(&r_iter, "i", DBusType.INT32, 0);
		case "IconThemePath":
		case "OverlayIconName":
		case "AttentionIconName":
		case "AttentionMovieName":
			@reply_variant(&r_iter, "s", DBusType.STRING, (ZString)"");
		case "ItemIsMenu":
			@reply_variant(&r_iter, "b", DBusType.BOOLEAN, (uint)0);
		case "Menu":
			@reply_variant(&r_iter, "o", DBusType.OBJECT_PATH, (ZString)"/menu");
		case "IconPixmap":
			@with_container(&r_iter, DBusType.VARIANT, "a(iiay)"; v) {
				state.lock.lock();
				defer state.lock.unlock();
				append_icon_pixmap(v, state.icon_w, state.icon_h, state.icon_argb.ptr, state.icon_argb.len);
			};
		case "OverlayIconPixmap":
		case "AttentionIconPixmap":
			@with_container(&r_iter, DBusType.VARIANT, "a(iiay)"; v) {
				append_empty_pixmap_array(v);
			};
		case "ToolTip":
			@with_container(&r_iter, DBusType.VARIANT, "(sa(iiay)ss)"; v) {
				state.lock.lock();
				defer state.lock.unlock();
				append_tooltip(v, (ZString)&state.tooltip_title_buf, (ZString)&state.tooltip_desc_buf);
			};
		default:
			send_error_reply(conn, msg, "org.freedesktop.DBus.Error.UnknownProperty", "Unknown property");
			return;
	}

	dbus_connection_send(conn, reply, null);
}

fn void register_with_watcher(DBusConnection* conn)
{
	DBusMessage* msg = dbus_message_new_method_call(
		"org.kde.StatusNotifierWatcher",
		"/StatusNotifierWatcher",
		"org.kde.StatusNotifierWatcher",
		"RegisterStatusNotifierItem"
	);
	if (msg == null) return;
	defer dbus_message_unref(msg);

	DBusMessageIter iter;
	dbus_message_iter_init_append(msg, &iter);
	ZString service = "/StatusNotifierItem";
	dbus_message_iter_append_basic(&iter, STRING, &service);

	dbus_connection_send(conn, msg, null);
	dbus_connection_flush(conn);
}

fn void handle_dbusmenu(DBusConnection* conn, DBusMessage* msg)
{
	ZString member = dbus_message_get_member(msg);
	if (member == null) return;

	if (member == "Introspect")
	{
		handle_introspect(conn, msg);
		return;
	}

	ZString iface = dbus_message_get_interface(msg);

	if (iface == "org.freedesktop.DBus.Properties")
	{
		switch (member.str_view())
		{
			case "GetAll":
			case "Get":
				DBusMessage* reply = dbus_message_new_method_return(msg);
				if (reply == null) return;
				defer dbus_message_unref(reply);
				DBusMessageIter r;
				dbus_message_iter_init_append(reply, &r);
				if (member == "GetAll")
				{
					@with_container(&r, DBusType.ARRAY, "{sv}"; props) {
						@with_dict_entry(props, "Version", "u"; v) {
							uint ver = 3;
							dbus_message_iter_append_basic(v, DBusType.UINT32, &ver);
						};
						@with_dict_entry(props, "Status", "s"; v) {
							ZString st = "normal";
							dbus_message_iter_append_basic(v, DBusType.STRING, &st);
						};
					};
				}
				else
				{
					DBusMessageIter in_iter;
					if (dbus_message_iter_init(msg, &in_iter))
					{
						dbus_message_iter_next(&in_iter);
						ZString prop;
						dbus_message_iter_get_basic(&in_iter, &prop);
						if (prop == "Version")
						{
							@with_container(&r, DBusType.VARIANT, "u"; v) {
								uint ver = 3;
								dbus_message_iter_append_basic(v, DBusType.UINT32, &ver);
							};
						}
						else if (prop == "Status")
						{
							@with_container(&r, DBusType.VARIANT, "s"; v) {
								ZString st = "normal";
								dbus_message_iter_append_basic(v, DBusType.STRING, &st);
							};
						}
					}
				}
				dbus_connection_send(conn, reply, null);
			case "Set":
				send_empty_reply(conn, msg);
		}
		return;
	}

	switch (member.str_view())
	{
		case "GetLayout":
			DBusMessage* reply = dbus_message_new_method_return(msg);
			if (reply == null) return;
			defer dbus_message_unref(reply);

			DBusMessageIter r;
			dbus_message_iter_init_append(reply, &r);

			uint rev = 1;
			dbus_message_iter_append_basic(&r, DBusType.UINT32, &rev);

			@with_container(&r, DBusType.STRUCT, null; root) {
				int root_id = 0;
				dbus_message_iter_append_basic(root, DBusType.INT32, &root_id);
				@with_container(root, DBusType.ARRAY, "{sv}"; rprops) {
					@with_dict_entry(rprops, "children-display", "s"; v) {
						ZString cd = "submenu";
						dbus_message_iter_append_basic(v, DBusType.STRING, &cd);
					};
				};
				@with_container(root, DBusType.ARRAY, "v"; children) {
					@with_container(children, DBusType.VARIANT, "(ia{sv}av)"; cv) {
						@append_menu_item(cv, 1, "Play/Pause", "media-playback-start", true);
					};
					@with_container(children, DBusType.VARIANT, "(ia{sv}av)"; cv) {
						@append_menu_item(cv, 2, "Previous",   "media-skip-backward",  true);
					};
					@with_container(children, DBusType.VARIANT, "(ia{sv}av)"; cv) {
						@append_menu_item(cv, 3, "Next",       "media-skip-forward",   true);
					};
					@with_container(children, DBusType.VARIANT, "(ia{sv}av)"; cv) {
						@append_separator(cv, 4);
					};
					@with_container(children, DBusType.VARIANT, "(ia{sv}av)"; cv) {
						@append_menu_item(cv, 5, "Quit", "application-exit", true);
					};
				};
			};

			dbus_connection_send(conn, reply, null);

		case "GetGroupProperties":
			DBusMessage* reply = dbus_message_new_method_return(msg);
			if (reply == null) return;
			defer dbus_message_unref(reply);
			DBusMessageIter r;
			dbus_message_iter_init_append(reply, &r);
			@with_container(&r, DBusType.ARRAY, "(ia{sv})"; arr) {
				@with_container(arr, DBusType.STRUCT, null; it) {
					int id = 0; dbus_message_iter_append_basic(it, DBusType.INT32, &id);
					@with_container(it, DBusType.ARRAY, "{sv}"; p) {
						@with_dict_entry(p, "children-display", "s"; v) {
							ZString cd = "submenu";
							dbus_message_iter_append_basic(v, DBusType.STRING, &cd);
						};
					};
				};
				@with_container(arr, DBusType.STRUCT, null; it) {
					int id = 1; dbus_message_iter_append_basic(it, DBusType.INT32, &id);
					@with_container(it, DBusType.ARRAY, "{sv}"; p) {
						@with_dict_entry(p, "label",     "s"; v) { ZString s = "Play/Pause";           dbus_message_iter_append_basic(v, DBusType.STRING, &s); };
						@with_dict_entry(p, "icon-name", "s"; v) { ZString s = "media-playback-start"; dbus_message_iter_append_basic(v, DBusType.STRING, &s); };
						@with_dict_entry(p, "enabled",   "b"; v) { uint e = 1; dbus_message_iter_append_basic(v, DBusType.BOOLEAN, &e); };
						@with_dict_entry(p, "visible",   "b"; v) { uint e = 1; dbus_message_iter_append_basic(v, DBusType.BOOLEAN, &e); };
						@with_dict_entry(p, "type",      "s"; v) { ZString s = "standard";             dbus_message_iter_append_basic(v, DBusType.STRING, &s); };
					};
				};
				@with_container(arr, DBusType.STRUCT, null; it) {
					int id = 2; dbus_message_iter_append_basic(it, DBusType.INT32, &id);
					@with_container(it, DBusType.ARRAY, "{sv}"; p) {
						@with_dict_entry(p, "label",     "s"; v) { ZString s = "Previous";            dbus_message_iter_append_basic(v, DBusType.STRING, &s); };
						@with_dict_entry(p, "icon-name", "s"; v) { ZString s = "media-skip-backward"; dbus_message_iter_append_basic(v, DBusType.STRING, &s); };
						@with_dict_entry(p, "enabled",   "b"; v) { uint e = 1; dbus_message_iter_append_basic(v, DBusType.BOOLEAN, &e); };
						@with_dict_entry(p, "visible",   "b"; v) { uint e = 1; dbus_message_iter_append_basic(v, DBusType.BOOLEAN, &e); };
						@with_dict_entry(p, "type",      "s"; v) { ZString s = "standard";            dbus_message_iter_append_basic(v, DBusType.STRING, &s); };
					};
				};
				@with_container(arr, DBusType.STRUCT, null; it) {
					int id = 3; dbus_message_iter_append_basic(it, DBusType.INT32, &id);
					@with_container(it, DBusType.ARRAY, "{sv}"; p) {
						@with_dict_entry(p, "label",     "s"; v) { ZString s = "Next";               dbus_message_iter_append_basic(v, DBusType.STRING, &s); };
						@with_dict_entry(p, "icon-name", "s"; v) { ZString s = "media-skip-forward"; dbus_message_iter_append_basic(v, DBusType.STRING, &s); };
						@with_dict_entry(p, "enabled",   "b"; v) { uint e = 1; dbus_message_iter_append_basic(v, DBusType.BOOLEAN, &e); };
						@with_dict_entry(p, "visible",   "b"; v) { uint e = 1; dbus_message_iter_append_basic(v, DBusType.BOOLEAN, &e); };
						@with_dict_entry(p, "type",      "s"; v) { ZString s = "standard";           dbus_message_iter_append_basic(v, DBusType.STRING, &s); };
					};
				};
				@with_container(arr, DBusType.STRUCT, null; it) {
					int id = 4; dbus_message_iter_append_basic(it, DBusType.INT32, &id);
					@with_container(it, DBusType.ARRAY, "{sv}"; p) {
						@with_dict_entry(p, "type", "s"; v) { ZString s = "separator"; dbus_message_iter_append_basic(v, DBusType.STRING, &s); };
					};
				};
				@with_container(arr, DBusType.STRUCT, null; it) {
					int id = 5; dbus_message_iter_append_basic(it, DBusType.INT32, &id);
					@with_container(it, DBusType.ARRAY, "{sv}"; p) {
						@with_dict_entry(p, "label",     "s"; v) { ZString s = "Quit";             dbus_message_iter_append_basic(v, DBusType.STRING, &s); };
						@with_dict_entry(p, "icon-name", "s"; v) { ZString s = "application-exit"; dbus_message_iter_append_basic(v, DBusType.STRING, &s); };
						@with_dict_entry(p, "enabled",   "b"; v) { uint e = 1; dbus_message_iter_append_basic(v, DBusType.BOOLEAN, &e); };
						@with_dict_entry(p, "visible",   "b"; v) { uint e = 1; dbus_message_iter_append_basic(v, DBusType.BOOLEAN, &e); };
						@with_dict_entry(p, "type",      "s"; v) { ZString s = "standard";         dbus_message_iter_append_basic(v, DBusType.STRING, &s); };
					};
				};
			};
			dbus_connection_send(conn, reply, null);

		case "AboutToShow":
			DBusMessage* reply = dbus_message_new_method_return(msg);
			if (reply == null) return;
			defer dbus_message_unref(reply);
			DBusMessageIter r;
			dbus_message_iter_init_append(reply, &r);
			uint need_update = 0;
			dbus_message_iter_append_basic(&r, DBusType.BOOLEAN, &need_update);
			dbus_connection_send(conn, reply, null);

		case "Event":
			DBusMessageIter iter;
			if (dbus_message_iter_init(msg, &iter))
			{
				int item_id = 0;
				dbus_message_iter_get_basic(&iter, &item_id);
				if (dbus_message_iter_next(&iter))
				{
					ZString event_id;
					dbus_message_iter_get_basic(&iter, &event_id);
					if (event_id == "clicked")
					{
						switch (item_id)
						{
							case 1: push_event(TOGGLE_PLAYBACK);
							case 2: push_event(PREV_TRACK);
							case 3: push_event(NEXT_TRACK);
							case 5: push_event(QUIT);
						}
					}
				}
			}

		case "AboutToShowGroup":
			DBusMessage* reply = dbus_message_new_method_return(msg);
			if (reply == null) return;
			defer dbus_message_unref(reply);
			DBusMessageIter r;
			dbus_message_iter_init_append(reply, &r);
			@with_container(&r, DBusType.ARRAY, "i"; upd) {};
			@with_container(&r, DBusType.ARRAY, "i"; err) {};
			dbus_connection_send(conn, reply, null);

		case "EventGroup":
			DBusMessageIter outer;
			if (dbus_message_iter_init(msg, &outer) &&
			    dbus_message_iter_get_arg_type(&outer) == DBusType.ARRAY)
			{
				DBusMessageIter arr;
				dbus_message_iter_recurse(&outer, &arr);
				while (dbus_message_iter_get_arg_type(&arr) == DBusType.STRUCT)
				{
					DBusMessageIter ev;
					dbus_message_iter_recurse(&arr, &ev);
					int item_id = 0;
					dbus_message_iter_get_basic(&ev, &item_id);
					if (dbus_message_iter_next(&ev))
					{
						ZString event_id;
						dbus_message_iter_get_basic(&ev, &event_id);
						if (event_id == "clicked")
						{
							switch (item_id)
							{
								case 1: push_event(TOGGLE_PLAYBACK);
								case 2: push_event(PREV_TRACK);
								case 3: push_event(NEXT_TRACK);
								case 5: push_event(QUIT);
							}
						}
					}
					dbus_message_iter_next(&arr);
				}
			}
			if (DBusMessage* reply = dbus_message_new_method_return(msg))
			{
				DBusMessageIter r;
				dbus_message_iter_init_append(reply, &r);
				@with_container(&r, DBusType.ARRAY, "i"; err) {};
				dbus_connection_send(conn, reply, null);
				dbus_message_unref(reply);
			}

		default:
			send_empty_reply(conn, msg);
	}
}

fn void handle_message(DBusConnection* conn, DBusMessage* msg)
{
	int msg_type = dbus_message_get_type(msg);
	if (msg_type == DBUS_MESSAGE_TYPE_SIGNAL)
	{
		ZString member = dbus_message_get_member(msg);
		if (member == "StatusNotifierWatcherRegistered")
		{
			register_with_watcher(conn);
		}
		return;
	}

	if (msg_type != DBUS_MESSAGE_TYPE_METHOD_CALL) return;

	ZString path = dbus_message_get_path(msg);
	if (path == "/menu")
	{
		handle_dbusmenu(conn, msg);
		return;
	}

	ZString iface = dbus_message_get_interface(msg);
	ZString member = dbus_message_get_member(msg);
	if (member == null) return;

	if (member == "Introspect")
	{
		handle_introspect(conn, msg);
		return;
	}

	if (iface == "org.freedesktop.DBus.Properties")
	{
		switch (member.str_view())
		{
			case "Get":
				handle_prop_get(conn, msg);
			case "GetAll":
				handle_prop_get_all(conn, msg);
			case "Set":
				send_empty_reply(conn, msg);
		}
		return;
	}

	if (iface == "org.kde.StatusNotifierItem")
	{
		switch (member.str_view())
		{
			case "Activate":
				push_event(TOGGLE_WINDOW);
			case "SecondaryActivate":
				push_event(TOGGLE_PLAYBACK);
			case "Scroll":
				DBusMessageIter iter;
				if (dbus_message_iter_init(msg, &iter) && dbus_message_iter_get_arg_type(&iter) == INT32)
				{
					int delta = 0;
					dbus_message_iter_get_basic(&iter, &delta);
					push_event(VOLUME_CHANGE, delta > 0 ? -1 : 1);
				}
		}
		send_empty_reply(conn, msg);
		return;
	}
}

fn int worker(void* arg @unused)
{
	while (state.running)
	{
		dbus_connection_read_write(state.conn, 50);

		DBusMessage* msg;
		while ((msg = dbus_connection_pop_message(state.conn)) != null)
		{
			handle_message(state.conn, msg);
			dbus_message_unref(msg);
		}

		bool send_tooltip = false;
		state.lock.lock();
		if (state.tooltip_changed)
		{
			send_tooltip = true;
			state.tooltip_changed = false;
		}
		state.lock.unlock();

		if (send_tooltip)
		{
			DBusMessage* signal = dbus_message_new_signal("/StatusNotifierItem", "org.kde.StatusNotifierItem", "NewToolTip");
			if (signal != null)
			{
				dbus_connection_send(state.conn, signal, null);
				dbus_message_unref(signal);
			}
		}

		dbus_connection_flush(state.conn);
	}
	return 0;
}

fn void init(char[] rgba_pixels, int w, int h)
{
	if (state.initialized) return;

	dbus_threads_init_default();

	DBusError err;
	dbus_error_init(&err);
	defer dbus_error_free(&err);

	DBusConnection* conn = dbus_bus_get_private(DBUS_BUS_SESSION, &err);
	if (conn == null) return;

	state.lock.init()!!;

	state.icon_w = w;
	state.icon_h = h;
	sz pixel_count = (sz)(w * h);
	state.icon_argb = mem::new_array(char, pixel_count * 4);

	for (sz i = 0; i < pixel_count; i++)
	{
		sz p = i * 4;
		state.icon_argb[p + 0] = rgba_pixels[p + 3];
		state.icon_argb[p + 1] = rgba_pixels[p + 0];
		state.icon_argb[p + 2] = rgba_pixels[p + 1];
		state.icon_argb[p + 3] = rgba_pixels[p + 2];
	}

	String default_title = "c3aud";
	mem::copy(&state.tooltip_title_buf, default_title, default_title.len);
	state.tooltip_title_buf[default_title.len] = 0;
	state.tooltip_desc_buf[0] = 0;

	int pid = (int)getpid();
	char[64] name_buf;
	String bus_name = string::bformat(&name_buf, "org.kde.StatusNotifierItem-%d-1", pid);
	dbus_bus_request_name(conn, (ZString)bus_name.ptr, DBUS_NAME_FLAG_DO_NOT_QUEUE, &err);

	dbus_bus_add_match(conn, "type='signal',interface='org.kde.StatusNotifierWatcher',member='StatusNotifierWatcherRegistered'", &err);
	register_with_watcher(conn);

	state.conn = conn;
	state.running = true;
	state.initialized = true;

	state.thread.create(&worker, null)!!;
}

fn void update_tooltip(String title, String desc)
{
	if (!state.initialized) return;

	state.lock.lock();
	sz tlen = math::min(title.len, (sz)255);
	mem::copy(&state.tooltip_title_buf, title, tlen);
	state.tooltip_title_buf[tlen] = 0;

	sz dlen = math::min(desc.len, (sz)255);
	mem::copy(&state.tooltip_desc_buf, desc, dlen);
	state.tooltip_desc_buf[dlen] = 0;
	state.tooltip_changed = true;
	state.lock.unlock();
}

fn bool poll_event(TrayEvent* out)
{
	if (!state.initialized) return false;
	state.lock.lock();
	defer state.lock.unlock();
	if (state.event_count == 0) return false;
	*out = state.events[0];
	for (int i = 0; i < state.event_count - 1; i++)
	{
		state.events[i] = state.events[i + 1];
	}
	state.event_count--;
	return true;
}

fn void destroy()
{
	if (!state.initialized) return;
	state.running = false;
	state.thread.join()!!;

	if (state.conn != null)
	{
		dbus_connection_close(state.conn);
		dbus_connection_unref(state.conn);
		state.conn = null;
	}

	if (state.icon_argb.len > 0)
	{
		mem::free(state.icon_argb);
	}

	state.lock.destroy();
	state.initialized = false;
}