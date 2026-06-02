shader_type canvas_item;
render_mode blend_mix, unshaded;

uniform float rain_amount : hint_range(0.0, 1000.0) = 200.0; 
uniform float near_rain_length : hint_range(0.01, 1.0) = 0.2;
uniform float far_rain_length : hint_range(0.01, 0.1) = 0.1;

uniform float near_rain_width : hint_range(0.01, 0.5) = 0.05;
uniform float far_rain_width : hint_range(0.01, 0.5) = 0.02;

uniform float near_rain_transparency : hint_range(0.1, 1.0) = 1.0;
uniform float far_rain_transparency : hint_range(0.1, 1.0) = 0.5;
uniform vec4 rain_color : source_color = vec4(0.8, 0.8, 0.8, 1.0);
uniform float base_rain_speed : hint_range(0.1, 10.0) = 0.5;
uniform float slant : hint_range(-1.0, 1.0) = 0.2;

uniform float rain_density : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    float time = 10000.0 + TIME;
    
    float base_grid = 500.0; 
    
    float remainder = mod(UV.x - UV.y * slant, 1.0 / base_grid);
    vec2 uv = vec2(0.0);
    uv.x = (UV.x - UV.y * slant) - remainder;

    float rn = fract(sin(uv.x * base_grid) * 0.5 + 0.5);
    float rn2 = fract(sin(uv.x * base_grid * 3.7 + 1.3) * 43758.5);
    float rn3 = fract(sin(uv.x * base_grid * 7.1 + 2.9) * 23421.6);

    uv.y = fract(UV.y + rn);

    float speed_variation = base_rain_speed;
    float y_offset = rn2;

    float rain_step = step(
        1.0 - (far_rain_length + (near_rain_length - far_rain_length) * rn),
        fract(uv.y - time * speed_variation + y_offset)
    );

    float target_width = far_rain_width + (near_rain_width - far_rain_width) * rn;
    float width_step = step(remainder, target_width);

    float density_threshold = rain_amount / base_grid;
    float density_mask = step(rn3, density_threshold);

    float transparency = far_rain_transparency + (near_rain_transparency - far_rain_transparency) * rn;
    
    float rain_mask = rain_step * transparency * width_step * density_mask;

    COLOR = vec4(rain_color.rgb, rain_color.a * rain_mask);
}