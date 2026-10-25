shader_type canvas_item;

uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float alpha = 1.0;
uniform float inner_radius = 0.0;
uniform float outer_radius = 1.0;

void fragment() {
	float x = abs(UV.r - 0.5) * 2.0;
	float y = abs(UV.g - 0.5) * 2.0;
	float q = 1.0 - (1.0 - sqrt(x * x + y * y) / outer_radius) / (1.0 - inner_radius);
	COLOR = vec4(color.rgb, q * alpha * color.a);
}