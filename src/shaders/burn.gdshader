shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform float dissolve_threshold: hint_range(0.0, 1.0);

void fragment() {
    vec4 main_texture = texture(TEXTURE, UV);
    vec4 noise_texture = texture(noise, UV);
    main_texture.a *= floor(dissolve_threshold + noise_texture.r); //rgb values are between 0 and 1
    COLOR = main_texture;
}
