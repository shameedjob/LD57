shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest_mipmap;
uniform float offset = 1.0;
uniform float warp_amount :hint_range(-5.0, 5.0) = 1.0; // Warp the texture edges simulating the curved glass of a CRT monitor or old TV.
// Takes in the UV and warps the edges, creating the spherized effect

uniform float vignette_intensity = 0.4; // Size of the vignette, how far towards the middle it should go.
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.5;
uniform float scanlines_opacity = 0.2;
uniform float scanlines_width = 0.01;
uniform vec2 resolution = vec2(1280, 960);

vec2 warp(vec2 uv){
	vec2 delta = uv - 0.5;
	float delta2 = dot(delta.xy, delta.xy);
	float delta4 = delta2 * delta2;
	float delta_offset = delta4 * warp_amount;

	return uv + delta * delta_offset;
}
float vignette(vec2 uv){
	uv *= 1.0 - uv.xy;
	float vignette = uv.x * uv.y * 15.0;
	return pow(vignette, vignette_intensity * vignette_opacity);
}

float border (vec2 uv){
	float radius = min(warp_amount/5.0, 0.08);
	radius = max(min(min(abs(radius * 2.0), abs(1.0)), abs(1.0)), 1e-5);
	vec2 abs_uv = abs(uv * 2.0 - 1.0) - vec2(1.0, 1.0) + radius;
	float dist = length(max(vec2(0.0), abs_uv)) / radius;
	float square = smoothstep(0.96, 1.0, dist);
	return clamp(1.0 - square, 0.0, 1.0);
}

void fragment() {
	vec2 uv = warp(UV);//3.0+vec2(0.5, 0.5)-vec2(0.5, 0.5)/3.0);
	vec4 red_channel = texture(SCREEN_TEXTURE, vec2(uv.x + offset * SCREEN_PIXEL_SIZE.x, uv.y));
	vec4 blue_channel = texture(SCREEN_TEXTURE, vec2(uv.x - offset * SCREEN_PIXEL_SIZE.x, uv.y));
	vec4 green_channel = texture(SCREEN_TEXTURE, uv);
	COLOR = vec4(red_channel.r,green_channel.g, blue_channel.b, 1.0);
	float scanlines = 0.5;
	if (scanlines_opacity > 0.0)
	{
		// Same technique as above, create lines with sine and applying it to the texture. Smoothstep to allow setting the line size.
		scanlines = smoothstep(scanlines_width, scanlines_width + 0.5, abs(sin(uv.y * (resolution.y * 3.14159265))));
		COLOR.rgb = mix(COLOR.rgb, COLOR.rgb * vec3(scanlines), scanlines_opacity);
	}
	COLOR.rgb *= border(uv);
	COLOR.rgb *= vignette(uv);
	// Place fragment code here.
}
