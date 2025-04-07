shader_type canvas_item;
render_mode blend_mix;

uniform vec2 offset = vec2(8.0, 8.0);
uniform vec4 modulate : source_color;
uniform sampler2D noise_texture;
uniform float distortion_strength;
uniform float speed;

void fragment() {
	vec2 ps = TEXTURE_PIXEL_SIZE;
	vec4 noise_pixel = texture(noise_texture, UV + sin(floor(TIME*speed))/3.0);
	vec2 uv_offset = (noise_pixel.rg * 2.0 - 1.0) * distortion_strength*ps;

	vec4 shadow = vec4(modulate.rgb, texture(TEXTURE, UV - vec2(offset.x, 0) * ps + uv_offset).a * modulate.a);
	shadow = shadow + vec4(modulate.rgb, texture(TEXTURE, UV - vec2(0, offset.y) * ps + uv_offset).a * modulate.a);
	shadow = shadow + vec4(modulate.rgb, texture(TEXTURE, UV - vec2(0, -offset.y) * ps + uv_offset).a * modulate.a);
	shadow = shadow + vec4(modulate.rgb, texture(TEXTURE, UV - vec2(-offset.x, 0) * ps + uv_offset).a * modulate.a);
	shadow = shadow + vec4(modulate.rgb, texture(TEXTURE, UV - vec2(-offset.x, offset.y) * ps + uv_offset).a * modulate.a);
	shadow = shadow + vec4(modulate.rgb, texture(TEXTURE, UV - vec2(offset.x, -offset.y) * ps + uv_offset).a * modulate.a);
	shadow = shadow + vec4(modulate.rgb, texture(TEXTURE, UV - offset * ps + uv_offset).a * modulate.a);
	shadow = shadow + vec4(modulate.rgb, texture(TEXTURE, UV + offset * ps + uv_offset).a * modulate.a);
	vec4 col = texture(TEXTURE, UV+uv_offset);
	COLOR = mix(shadow, col, col.a);
}