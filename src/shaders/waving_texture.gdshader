shader_type canvas_item;

uniform float base_strength : hint_range(0.0, 0.1) = 0.03;
uniform float wave_1_speed: hint_range(0.0, 5.0) = 1.0;
uniform float wave_2_speed: hint_range(0.0, 5.0) = 2.0;
uniform float wave_freq1 : hint_range(0.0, 20.0) = 6.0;
uniform float wave_freq2 : hint_range(0.0, 20.0) = 10.0;
uniform float y_distorsion: hint_range(0.0, 2.0, 0.1) = 1.;
uniform float x_distorsion: hint_range(0.0, 2.0, 0.1) = 0.3;

void fragment() {
    // Wavy offset combining two sine waves
    vec2 texture_uv = UV;
    float offset1 = sin(texture_uv.x * wave_freq1 + TIME * wave_1_speed);
    float offset2 = cos(texture_uv.y * wave_freq2 + TIME * wave_2_speed);
    float offset = (offset1 + offset2) * 0.5 * base_strength * 1.;
    
    texture_uv.y += offset * y_distorsion;
    texture_uv.x += offset * x_distorsion;

    COLOR = texture(TEXTURE, texture_uv);
}
