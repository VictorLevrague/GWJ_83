shader_type canvas_item;
uniform vec2 center = vec2(0.5);
uniform float size: hint_range(0.0,5.0) = 1.0; //change size to well, change the size of your gradient
uniform vec2 squishness = vec2(1.0); // how squashed your gradient is

//choose colors in the inspector
uniform vec4 color1 : source_color = vec4(0., 0., 0., 0.);
uniform vec4 color2 : source_color = vec4(0.56, 0.56, 0.56, 1.);
uniform vec4 color3 : source_color = vec4(0.77, 0.77, 0.77, 1.);
uniform vec4 color4 : source_color = vec4(0.77, 0.77, 0.77, 1.);
uniform vec4 color5 : source_color = vec4(1., 1., 1., 1.);
uniform vec4 color6 : source_color = vec4(0., 0., 0., 1.);

//choose how far the colors are from each other in the inspector
uniform float step1 : hint_range(0.0,1.0) = 0.115;
uniform float step2 : hint_range(0.0,1.0) = 0.182;
uniform float step3 : hint_range(0.0,1.0) = 0.233;
uniform float step4 : hint_range(0.0,1.0) = 0.264;
uniform float step5 : hint_range(0.0,1.0) = 0.265;
uniform float step6 : hint_range(0.0,1.0) = 0.458;

vec4 get_gradient_color(float dist) {
    vec4 c = mix(color1, color2, smoothstep(step1 * size, step2 * size, dist));
    c = mix(c, color3, smoothstep(step2 * size, step3 * size, dist));
    c = mix(c, color4, smoothstep(step3 * size, step4 * size, dist));
    c = mix(c, color5, smoothstep(step4 * size, step5 * size, dist));
    c = mix(c, color6, smoothstep(step5 * size, step6 * size, dist));
    return c;
}

void fragment() {
	float dist = distance(center*squishness,UV*squishness);
    vec4 gradient_color = get_gradient_color(dist);
    vec4 texture_base = texture(TEXTURE, UV);
    COLOR = mix(texture_base, gradient_color, gradient_color);
    COLOR.a = mix(texture_base.a, gradient_color.a, texture_base.a);
}