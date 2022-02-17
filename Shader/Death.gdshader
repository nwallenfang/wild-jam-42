shader_type canvas_item;

uniform sampler2D dissolve_texture;
uniform float threshold: hint_range(0, 1);

const vec4 transparent = vec4(0.0);
const vec4 black = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	vec4 voronoi = texture(dissolve_texture, UV);
	float mask = float(threshold > voronoi.r);
	// show black if mask is 1.0 else show transparent
    COLOR = mask * black;
}

