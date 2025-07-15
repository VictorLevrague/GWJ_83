shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform sampler2D burn_color_gradient;

uniform float dissolve_threshold: hint_range(0.0, 1.0) = 1.0;
uniform float burn_size: hint_range(1.0, 1.5) = 1.3;

// Converts the value v from the range [a, b] to the range [0, 1]
float inverse_lerp(float a, float b, float v) {
	return (v - a) / (b - a);
}

void fragment() {
    vec4 main_texture = texture(TEXTURE, UV);
    vec4 noise_texture = texture(noise, UV);
    main_texture.a *= step(noise_texture.r, dissolve_threshold);
    //Scale [dissolve_threshold, dissolve_threshold * burn_size] to [0,1] values for UV usage
    vec2 burn_uv = vec2(inverse_lerp(dissolve_threshold, dissolve_threshold * burn_size, noise_texture.r), 0.0); 
    vec4 burn_texture = texture(burn_color_gradient, burn_uv);
    burn_texture.a *= texture(TEXTURE, UV).a; //To match texture initial transparency
    burn_texture.a *= step(noise_texture.r, dissolve_threshold*burn_size);
    COLOR = mix(burn_texture, main_texture, main_texture.a);
}
