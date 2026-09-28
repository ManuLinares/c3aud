module c3aud;
import std;

struct TextVertex
{
	Vec2 pos;
	Vec2 uv;
	char[4] color;
}

fn char[4] pack_color(Vec4 c) => {
	(char)(math::clamp(c.r, 0.0f, 1.0f) * 255.0f + 0.5f),
	(char)(math::clamp(c.g, 0.0f, 1.0f) * 255.0f + 0.5f),
	(char)(math::clamp(c.b, 0.0f, 1.0f) * 255.0f + 0.5f),
	(char)(math::clamp(c.a, 0.0f, 1.0f) * 255.0f + 0.5f)
};

const float INV_128    = 1.0f / 128.0f;
const float GLYPH_UV_W = 5.0f / 128.0f;
const float GLYPH_UV_H = 8.0f / 128.0f;

fn void draw_text(GfxSize win_sz, String text, int x, int y, int size, Vec4 color, int max_w = 0, int fade_w = 0)
{
	if (text.len == 0 || win_sz.x <= 0 || win_sz.y <= 0) return;

	float scale   = (float)math::max(1, size / 8);
	float advance = 6.0f * scale;
	float cur_x   = (float)x;
	float cur_y   = (float)y;

	float inv_w = 2.0f / (float)win_sz.x;
	float inv_h = 2.0f / (float)win_sz.y;
	float gw = 5.0f * scale * inv_w;
	float gh = 8.0f * scale * inv_h;

	float limit_x      = max_w > 0 ? (float)(x + max_w) : 0.0f;
	float fade_start_x = (max_w > 0 && fade_w > 0) ? limit_x - (float)fade_w : limit_x;

	char[4] base_col = pack_color(color);

	sz needed = text.len * 6;
	state.text_verts.reserve(needed);

	TextVertex* v = &state.text_verts.entries[state.text_verts.size];
	sz count = 0;

	for (sz si = 0; si < text.len; )
	{
		char c = text[si];
		if (c == '\n')
		{
			cur_x = (float)x;
			cur_y += 10.0f * scale;
			si++;
			continue;
		}

		if (max_w > 0 && cur_x >= limit_x) break;

		sz width = text.len - si;
		Char32 cp = c;
		if (try decoded = conv::utf8_to_char32(&text[si], &width))
		{
			cp = decoded;
		}
		else
		{
			width = 1;
		}
		si += width;

		if (cp < 32 || cp > 255)
		{
			cur_x += advance;
			continue;
		}

		char[4] col_left = base_col;
		char[4] col_right = base_col;

		if (max_w > 0 && fade_w > 0 && (cur_x + 5.0f * scale) > fade_start_x)
		{
			float al = math::clamp((limit_x - cur_x) / (float)fade_w, 0.0f, 1.0f);
			float ar = math::clamp((limit_x - (cur_x + 5.0f * scale)) / (float)fade_w, 0.0f, 1.0f);

			Vec4 cl = color;
			cl.a *= al;
			col_left = pack_color(cl);

			Vec4 cr = color;
			cr.a *= ar;
			col_right = pack_color(cr);
		}

		int idx = (int)cp;
		int gx  = (idx % 16) * 8;
		int gy  = (idx / 16) * 8;

		float u0 = (float)gx * INV_128;
		float v0 = (float)gy * INV_128;
		float u1 = u0 + GLYPH_UV_W;
		float v1 = v0 + GLYPH_UV_H;

		float x0 = cur_x * inv_w - 1.0f;
		float y0 = 1.0f - cur_y * inv_h;
		float x1 = x0 + gw;
		float y1 = y0 - gh;

		v[count + 0] = { { x0, y0 }, { u0, v0 }, col_left };
		v[count + 1] = { { x0, y1 }, { u0, v1 }, col_left };
		v[count + 2] = { { x1, y0 }, { u1, v0 }, col_right };
		v[count + 3] = { { x1, y0 }, { u1, v0 }, col_right };
		v[count + 4] = { { x0, y1 }, { u0, v1 }, col_left };
		v[count + 5] = { { x1, y1 }, { u1, v1 }, col_right };
		count += 6;

		cur_x += advance;
	}

	state.text_verts.size += count;
}

fn void flush_text()
{
	if (state.text_verts.size == 0) return;

	gl_enable(GL_BLEND);
	gl_blend_func(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	gl_use_program(state.text_shader);

	gl_active_texture(GL_TEXTURE0);
	gl_bind_texture(GL_TEXTURE_2D, state.font_tex);

	gl_bind_vertex_array(state.text_vao);
	gl_bind_buffer(GL_ARRAY_BUFFER, state.text_vbo);
	gl_buffer_data(GL_ARRAY_BUFFER, (usz)(state.text_verts.size * TextVertex::size), state.text_verts.entries, GL_DYNAMIC_DRAW);
	gl_draw_arrays(GL_TRIANGLES, 0, (int)state.text_verts.size);
	gl_bind_vertex_array(0);

	gl_disable(GL_BLEND);
	state.text_verts.clear();
}

// ─────────────────────────────────────────────────────────────────────────────
// Embedded Font Glyphs
// ─────────────────────────────────────────────────────────────────────────────

enum FontGlyph : (char ch, ulong bitmap)
{
	A { 'A', 0b01110_10001_10001_11111_10001_10001_10001_00000UL },
	B { 'B', 0b11110_10001_10001_11110_10001_10001_11110_00000UL },
	C { 'C', 0b01111_10000_10000_10000_10000_10000_01111_00000UL },
	D { 'D', 0b11110_10001_10001_10001_10001_10001_11110_00000UL },
	E { 'E', 0b11111_10000_10000_11110_10000_10000_11111_00000UL },
	F { 'F', 0b11111_10000_10000_11110_10000_10000_10000_00000UL },
	G { 'G', 0b01111_10000_10000_10111_10001_10001_01111_00000UL },
	H { 'H', 0b10001_10001_10001_11111_10001_10001_10001_00000UL },
	I { 'I', 0b01110_00100_00100_00100_00100_00100_01110_00000UL },
	J { 'J', 0b00111_00010_00010_00010_00010_10010_01100_00000UL },
	K { 'K', 0b10001_10010_10100_11000_10100_10010_10001_00000UL },
	L { 'L', 0b10000_10000_10000_10000_10000_10000_11111_00000UL },
	M { 'M', 0b10001_11011_10101_10101_10001_10001_10001_00000UL },
	N { 'N', 0b10001_11001_10101_10011_10001_10001_10001_00000UL },
	O { 'O', 0b01110_10001_10001_10001_10001_10001_01110_00000UL },
	P { 'P', 0b11110_10001_10001_11110_10000_10000_10000_00000UL },
	Q { 'Q', 0b01110_10001_10001_10001_10101_10010_01101_00000UL },
	R { 'R', 0b11110_10001_10001_11110_10100_10010_10001_00000UL },
	S { 'S', 0b01111_10000_10000_01110_00001_00001_11110_00000UL },
	T { 'T', 0b11111_00100_00100_00100_00100_00100_00100_00000UL },
	U { 'U', 0b10001_10001_10001_10001_10001_10001_01110_00000UL },
	V { 'V', 0b10001_10001_10001_10001_10001_01010_00100_00000UL },
	W { 'W', 0b10001_10001_10001_10101_10101_11011_10001_00000UL },
	X { 'X', 0b10001_10001_01010_00100_01010_10001_10001_00000UL },
	Y { 'Y', 0b10001_10001_01010_00100_00100_00100_00100_00000UL },
	Z { 'Z', 0b11111_00001_00010_00100_01000_10000_11111_00000UL },

	LOWER_A { 'a', 0b00000_00000_01111_00001_01111_10001_01111_00000UL },
	LOWER_B { 'b', 0b10000_10000_11110_10001_10001_10001_11110_00000UL },
	LOWER_C { 'c', 0b00000_00000_01111_10000_10000_10000_01111_00000UL },
	LOWER_D { 'd', 0b00001_00001_01111_10001_10001_10001_01111_00000UL },
	LOWER_E { 'e', 0b00000_00000_01111_10001_11111_10000_01111_00000UL },
	LOWER_F { 'f', 0b00110_01001_01000_11110_01000_01000_01000_00000UL },
	LOWER_G { 'g', 0b00000_00000_01111_10001_10001_01111_00001_11110UL },
	LOWER_H { 'h', 0b10000_10000_11110_10001_10001_10001_10001_00000UL },
	LOWER_I { 'i', 0b00100_00000_01100_00100_00100_00100_01110_00000UL },
	LOWER_J { 'j', 0b00010_00000_00010_00010_00010_00010_10010_01100UL },
	LOWER_K { 'k', 0b10000_10000_10010_10100_11000_10100_10010_00000UL },
	LOWER_L { 'l', 0b01100_00100_00100_00100_00100_00100_01110_00000UL },
	LOWER_M { 'm', 0b00000_00000_11010_10101_10101_10101_10101_00000UL },
	LOWER_N { 'n', 0b00000_00000_11110_10001_10001_10001_10001_00000UL },
	LOWER_O { 'o', 0b00000_00000_01110_10001_10001_10001_01110_00000UL },
	LOWER_P { 'p', 0b00000_00000_11110_10001_10001_11110_10000_10000UL },
	LOWER_Q { 'q', 0b00000_00000_01111_10001_10001_01111_00001_00001UL },
	LOWER_R { 'r', 0b00000_00000_10110_11001_10000_10000_10000_00000UL },
	LOWER_S { 's', 0b00000_00000_01111_10000_01110_00001_11110_00000UL },
	LOWER_T { 't', 0b00100_00100_11111_00100_00100_00100_00011_00000UL },
	LOWER_U { 'u', 0b00000_00000_10001_10001_10001_10011_01101_00000UL },
	LOWER_V { 'v', 0b00000_00000_10001_10001_10001_01010_00100_00000UL },
	LOWER_W { 'w', 0b00000_00000_10001_10001_10101_10101_01010_00000UL },
	LOWER_X { 'x', 0b00000_00000_10001_01010_00100_01010_10001_00000UL },
	LOWER_Y { 'y', 0b00000_00000_10001_10001_10001_01111_00001_11110UL },
	LOWER_Z { 'z', 0b00000_00000_11111_00010_00100_01000_11111_00000UL },

	ZERO  { '0', 0b01110_10001_10011_10101_11001_10001_01110_00000UL },
	ONE   { '1', 0b00100_01100_00100_00100_00100_00100_01110_00000UL },
	TWO   { '2', 0b01110_10001_00001_00010_00100_01000_11111_00000UL },
	THREE { '3', 0b11111_00010_00100_00010_00001_10001_01110_00000UL },
	FOUR  { '4', 0b00010_00110_01010_10010_11111_00010_00010_00000UL },
	FIVE  { '5', 0b11111_10000_11110_00001_00001_10001_01110_00000UL },
	SIX   { '6', 0b00110_01000_10000_11110_10001_10001_01110_00000UL },
	SEVEN { '7', 0b11111_00001_00010_00100_01000_01000_01000_00000UL },
	EIGHT { '8', 0b01110_10001_10001_01110_10001_10001_01110_00000UL },
	NINE  { '9', 0b01110_10001_10001_01111_00001_00010_01100_00000UL },
	SPACE { ' ', 0b00000_00000_00000_00000_00000_00000_00000_00000UL },
	COLON { ':', 0b00000_00000_00110_00110_00000_00110_00110_00000UL },
	DOT   { '.', 0b00000_00000_00000_00000_00000_00110_00110_00000UL },
	PERCENT   { '%', 0b11000_11001_00010_00100_01000_10011_00011_00000UL },
	AMPERSAND { '&', 0b01100_10010_01100_01010_10001_10010_01101_00000UL },
	LBRACKET  { '[', 0b01110_01000_01000_01000_01000_01000_01110_00000UL },
	RBRACKET  { ']', 0b01110_00010_00010_00010_00010_00010_01110_00000UL },
	SLASH     { '/', 0b00001_00010_00010_00100_00100_01000_01000_10000UL },
	HYPHEN    { '-', 0b00000_00000_00000_11111_00000_00000_00000_00000UL },
	LESS      { '<', 0b00010_00100_01000_10000_01000_00100_00010_00000UL },
	GREATER   { '>', 0b01000_00100_00010_00001_00010_00100_01000_00000UL },
	PIPE      { '|', 0b00100_00100_00100_00100_00100_00100_00100_00000UL },

	UPPER_A_ACUTE     { (char)193, 0b00010_01110_10001_10001_11111_10001_10001_10001UL },
	UPPER_E_ACUTE     { (char)201, 0b00010_11111_10000_10000_11110_10000_10000_11111UL },
	UPPER_I_ACUTE     { (char)205, 0b00010_01110_00100_00100_00100_00100_00100_01110UL },
	UPPER_N_TILDE     { (char)209, 0b01100_10001_11001_10101_10011_10001_10001_10001UL },
	UPPER_O_ACUTE     { (char)211, 0b00010_01110_10001_10001_10001_10001_10001_01110UL },
	UPPER_U_ACUTE     { (char)218, 0b00010_10001_10001_10001_10001_10001_10001_01110UL },
	UPPER_U_DIERESIS  { (char)220, 0b01010_10001_10001_10001_10001_10001_10001_01110UL },

	LOWER_A_ACUTE     { (char)225, 0b00010_00100_01111_00001_01111_10001_01111_00000UL },
	LOWER_E_ACUTE     { (char)233, 0b00010_00100_01111_10001_11111_10000_01111_00000UL },
	LOWER_I_ACUTE     { (char)237, 0b00010_00100_01100_00100_00100_00100_01110_00000UL },
	LOWER_N_TILDE     { (char)241, 0b01100_00110_11110_10001_10001_10001_10001_00000UL },
	LOWER_O_ACUTE     { (char)243, 0b00010_00100_01110_10001_10001_10001_01110_00000UL },
	LOWER_U_ACUTE     { (char)250, 0b00010_00100_10001_10001_10001_10011_01101_00000UL },
	LOWER_U_DIERESIS  { (char)252, 0b00000_01010_10001_10001_10001_10011_01101_00000UL },

	INVERTED_EXCLAM   { (char)161, 0b00000_00100_00000_00100_00100_00100_00100_00000UL },
	INVERTED_QUESTION { (char)191, 0b00000_00100_00000_00100_00010_10001_01110_00000UL },
}