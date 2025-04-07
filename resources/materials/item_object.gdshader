shader_type canvas_item;

uniform sampler2D noise_texture;
uniform float distortion_strength: hint_range(0.0, 1.0) = 1.0;
uniform float speed: hint_range(0.1, 10) = 1.0;
uniform float merging:hint_range(0,1) = 0;
uniform float transparency:hint_range(0.0, 1.0) = 1.0;
uniform bool greyed;

void fragment() {
	// Place fragment code here.
	vec4 white = vec4(1.0 ,1.0,1.0, 0);
	float r = 1.0/64.0;
	vec4 noise_pixel = texture(noise_texture, UV + sin(floor(TIME*speed))/3.0);
	vec2 uv_offset = (noise_pixel.rg * 2.0 - 1.0) * distortion_strength;
	vec4 true_color = 0.9*texture(TEXTURE, UV+uv_offset);
	true_color += 0.025*texture(TEXTURE, UV+vec2(r, 0)+uv_offset);
	true_color += 0.025*texture(TEXTURE, UV+vec2(-r, 0)+uv_offset);
	true_color += 0.025*texture(TEXTURE, UV+vec2(0, r)+uv_offset);
	true_color += 0.025*texture(TEXTURE, UV+vec2(0, -r)+uv_offset);

	vec4 o_color = true_color;//texture(TEXTURE, UV + uv_offset);
	vec4 n_color = white;
	n_color.rgb = o_color.rgb * (1.0-merging) + white.rgb * merging;
	n_color.a = o_color.a * max(merging, transparency);
	COLOR = n_color;
	if (greyed){
		float pix_color = (o_color.r+o_color.g+o_color.b)/5.0;
		float a = COLOR.a;
		if (n_color == vec4(1.0,1.0,1.0,1.0)){
			a = 0.0;
		}
		COLOR = vec4(pix_color, pix_color, pix_color, a);
	}
}