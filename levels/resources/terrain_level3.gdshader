shader_type spatial;

uniform vec3 base_color : source_color = vec3(0.3, 0.6, 0.2);

uniform float min_height = -1.0;
uniform float max_height = 2.0;

uniform float dark_strength = 0.5;
uniform float bright_strength = 0.5;

varying float world_height;

void vertex() {
    vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    world_height = world_pos.y;
}

void fragment() {
    float height_factor = clamp(
        (world_height - min_height) / (max_height - min_height),
        0.0,
        1.0
    );

    float centered = height_factor * 2.0 - 1.0;

    float brightness = 1.0;

    if (centered < 0.0) {
        brightness += centered * dark_strength;
    } else {
        brightness += centered * bright_strength;
    }

    ALBEDO = base_color * brightness;
}