shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_disabled,unshaded;

const vec3 start_color = vec3(.120, 0.125, 01.38);

vec3 hash3(vec3 p) {
  p = vec3(dot(p, vec3(127.1, 311.7, 74.7)),
    dot(p, vec3(269.5, 183.3, 246.1)),
    dot(p, vec3(113.5, 271.9, 124.6)));

  return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(vec3 p) {
  vec3 i = floor(p);
  vec3 f = fract(p);

  vec3 u = f * f * (3.0 - 2.0 * f);

  float n0 = dot(hash3(i + vec3(0.0, 0.0, 0.0)), f - vec3(0.0, 0.0, 0.0));
  float n1 = dot(hash3(i + vec3(1.0, 0.0, 0.0)), f - vec3(1.0, 0.0, 0.0));
  float n2 = dot(hash3(i + vec3(0.0, 1.0, 0.0)), f - vec3(0.0, 1.0, 0.0));
  float n3 = dot(hash3(i + vec3(1.0, 1.0, 0.0)), f - vec3(1.0, 1.0, 0.0));
  float n4 = dot(hash3(i + vec3(0.0, 0.0, 1.0)), f - vec3(0.0, 0.0, 1.0));
  float n5 = dot(hash3(i + vec3(1.0, 0.0, 1.0)), f - vec3(1.0, 0.0, 1.0));
  float n6 = dot(hash3(i + vec3(0.0, 1.0, 1.0)), f - vec3(0.0, 1.0, 1.0));
  float n7 = dot(hash3(i + vec3(1.0, 1.0, 1.0)), f - vec3(1.0, 1.0, 1.0));

  float ix0 = mix(n0, n1, u.x);
  float ix1 = mix(n2, n3, u.x);
  float ix2 = mix(n4, n5, u.x);
  float ix3 = mix(n6, n7, u.x);

  float ret = mix(mix(ix0, ix1, u.y), mix(ix2, ix3, u.y), u.z) * 0.5 + 0.5;
  return ret * 2.0 - 1.0;
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

float circle( in vec2 uv, float r1, float r2, vec2 ab) {
  float t = r1 - r2;
  float r = r1;
  return smoothstep(ab.x, ab.y, (-length(uv) + r ) - t / 10.0);
}

float circle2( in vec2 uv, float r1, float r2, vec2 ab) {
  float t = r1 - r2;
  float r = r1;
  return smoothstep(ab.x, ab.y, (+length(uv) - r) - t / 10.0);
}

vec3 color(vec2 uv) {
	vec3 colx = start_color;
	vec3 noise_coordinates = vec3(uv * 5.0, TIME * 0.25);
	noise_coordinates = vec3(atan(uv.x, uv.y) / 6.2832 + .5, length(uv) * .4, .5) + vec3(0., TIME * .05, TIME * .01);
	float noise_sum = abs(snoise(noise_coordinates));
	float nx2 = 0.5 * abs(snoise(noise_coordinates * 2.0));
	float nx3 = 0.25 * abs(snoise(noise_coordinates * 4.0));
	float nx4 = 0.125 * abs(snoise(noise_coordinates * 6.0));
	noise_sum += nx2 + nx3 + nx4;
	
	float circle1_r1 = 1.2;
	float circle1_r2 = 0.19;
	
	float circle2_r1 = 0.3;
	float circle2_r2 = 0.19;

	float c1=circle(uv * 3., circle1_r1, circle1_r2, vec2(-0.25, 0.8));
	float c2=circle2(uv * 3.,  circle2_r1, circle2_r2, vec2(-0.24645, 1.28));
	float circle_min = min(1.5*c1,c2);
	float n = noise_sum * circle_min;
	
	n *= (100.001);
	n *= circle_min;
	colx = 0.25 * colx + colx * (0.5 + 0.5 * cos(TIME + uv.xyx + vec3(0, 2, 4)));
	colx *= .2 / vec3(noise_sum - nx2, -nx3 + noise_sum, -nx4 + noise_sum);
	vec3 col = colx / max(n,0.001);

	col = clamp(abs(col), vec3(0.), vec3(2.));
	col = 2. * pow(col, vec3(0.645));
	col = col+col * col;

//	col = min

	return min(vec3(1.), pow(col, vec3(2.0))) * (1. - 1.2 * circle_min);
}

vec4 mi(vec2 uv) {
  uv*=0.9;
  vec3 col = vec3(0.);
  col = color(uv);
  return vec4(col, 1.0);
}

void fragment() {
	vec3 col = mi(UV-0.5).rgb;
	float a= min(dot(col,vec3(1.)), 1.);
	ALBEDO=col.rgb;
	//ALPHA=a*0.25+0.72;
	ALPHA=1.0;
	
}