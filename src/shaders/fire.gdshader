shader_type canvas_item;
render_mode unshaded;

//Noise and color uniforms
uniform sampler2D	noise_tex			: hint_default_white, repeat_enable;
uniform vec4		root_color			: source_color = vec4(1.0, 0.75, 0.3, 1.0);
uniform vec4		tip_color			: source_color = vec4(1.0, 0.03, 0.001, 1.0);
uniform float		poster_color		: hint_range(0.0, 16.0) = 6.0;
//Fire stuff
uniform float		fire_alpha			: hint_range(0.0, 1.0) = 1.0;
uniform vec2		fire_speed= vec2(0.015, 0.5);
uniform float		fire_aperture		: hint_range(0.0, 5.0) = 0.22;
uniform float fire_strength: hint_range(0.0, 1.0, 0.1) = 1.0;

vec2 polar_coordinates(vec2 uv, vec2 center, float zoom, float repeat) {
    vec2 d = uv - center;
    float r     = length(d) * 2.0;
    float theta = atan(d.y, d.x) * (1.0 / (2.0 * 3.1416));
    return mod(vec2(r * zoom, theta * repeat), 1.0);
}

void fragment() {
	vec2  center = vec2(0.5);
	vec2  p = polar_coordinates(UV, center, 1.0, 1.0);

	//fire "movement"
	p.x += TIME * fire_speed.y;
	p.y += sin(TIME) * fire_speed.x; //-> X is rotation!

	float noise = texture(noise_tex, p).r;

	//color posterization
	vec4 fire_color;
	if (poster_color >= 1.0){
		float quantized = floor(noise * poster_color) / poster_color;
		fire_color = mix(tip_color, root_color, quantized);
	}
	else{
		fire_color = mix(tip_color, root_color, noise);
	}

    vec4 base_texture = texture(TEXTURE, UV);
    COLOR.rgb = mix(fire_color.rgb, base_texture.rgb, 1.-fire_strength);
}