shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_disabled,unshaded;

uniform vec4 color_bias: hint_color; //= vec3(.120, 0.125, 1.3);
uniform float circle_bias : hint_range(1.0, 100.0);
uniform float spin_speed = 0.00;
uniform float zoom_speed = 0.08;
uniform float flicker_speed = 0.07;
uniform float brightness_divisor = 8.0;
uniform float circle_pattern_multiplier = 0.6;

vec3 hash3(vec3 p) {
  p = vec3(dot(p, vec3(127.1, 311.7, 74.7)),
    dot(p, vec3(269.5, 183.3, 246.1)),
    dot(p, vec3(113.5, 271.9, 124.6)));

  return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float snoise(vec3 uv) {
  const vec3 s = vec3(1e0, 1e2, 1e3);

  float res = 16.;
  uv *= res;
  vec3 uv0 = floor(mod(uv, res)) * s;
  vec3 uv1 = floor(mod(uv + vec3(1.), res)) * s;

  vec3 f = fract(uv);
  f = f * f * (3.0 - 2.0 * f);

  vec4 v = vec4(uv0.x + uv0.y + uv0.z, uv1.x + uv0.y + uv0.z,
    uv0.x + uv1.y + uv0.z, uv1.x + uv1.y + uv0.z);

  vec4 r = fract(sin(v * 1e-1) * 1e3);
  float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);

  r = fract(sin((v + uv1.z - uv0.z) * 1e-1) * 1e3);
  float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);

  return mix(r0, r1, f.z) * 2. - 1.;
}

const float PI = 3.141;
vec3 color(vec2 uv) {
	// maybe use another noise texture for spinning motion similar to the crystal
	
	// atan() seems to add circular pattern
//	float x_sampler = atan(uv.x, uv.y) / (circle_bias * PI);
	float x_sampler = atan(uv.x, uv.y) / (circle_bias * PI);
	float y_sampler = length(uv) * circle_pattern_multiplier;
	
	
	vec3 space_components = vec3(x_sampler, y_sampler , 0.0);
	vec3 time_components = TIME * vec3(spin_speed, zoom_speed, flicker_speed);
	
	// where to sample the noise texture
	vec3 noise_coordinates = space_components + time_components;
	float noise_sum = abs(snoise(noise_coordinates) * 1.0);
	// the multiplicator is the frequency of the noise
	float noise_red = 0.5 * abs(snoise(noise_coordinates * 2.0));
	float noise_green = 0.25 * abs(snoise(noise_coordinates * 4.0));
	float noise_blue = 0.125 * abs(snoise(noise_coordinates * 8.0));
	noise_sum += noise_red + noise_green + noise_blue;// + noise_green + noise_blue;
	
	vec3 color = color_bias.rgb;
	// change HUE (Farbton)
	// interestingly without this offset of 0,2,4 the perceived brightness fluctuates so leave it in
	color = 0.25 * color + 0.5 * color * (0.5 + 0.5 * cos(TIME + uv.xyx + vec3(0, 2, 4)));
	// change PATTERN with noise
	color /= 5.0 * vec3(noise_sum);

	// reduce brightness
	color = color / brightness_divisor;

	
	// clamp color to 1
	color = min(vec3(1.), color);

	return color;
}

//	color = clamp(abs(color), vec3(0.), vec3(1.));

void fragment() {
	vec3 col = color(UV-0.5).rgb;
	ALBEDO=col.rgb;
//	float alpha = min(dot(col,vec3(1.)), 1.);
	//ALPHA=a*0.25+0.72;
}