shader_type canvas_item;
render_mode blend_mix, unshaded;


uniform float rain_amount = 200.0;
uniform float near_rain_length : hint_range(0.01, 1.0) = 0.2;
uniform float far_rain_length : hint_range(0.01, 1.0) = 0.1;
uniform float near_rain_width : hint_range(0.1, 1.0) = 1.0;
uniform float far_rain_width : hint_range(0.1, 1.0) = 0.5;
uniform float near_rain_transparency : hint_range(0.1, 1.0) = 1.0;
uniform float far_rain_transparency : hint_range(0.1, 1.0) = 0.5;
uniform vec4 rain_color : source_color = vec4(0.8, 0.8, 0.8, 1.0);
uniform float base_rain_speed : hint_range(0.1, 5.0) = 0.5;
uniform float additional_rain_speed : hint_range(0.1, 5.0) = 0.5;
uniform float slant : hint_range(-1.0, 1.0) = 0.2;

void fragment() {
    float time = 10000.0 + TIME;
    vec2 uv = vec2(0.0);

    float remainder = mod(UV.x - UV.y * slant, 1.0 / rain_amount);
    uv.x = (UV.x - UV.y * slant) - remainder;

    float rn = fract(sin(uv.x * rain_amount));
    uv.y = fract(UV.y + rn);

    float rain_step = step(
        1.0 - (far_rain_length + (near_rain_length - far_rain_length) * rn),
        fract(uv.y - time * (base_rain_speed + additional_rain_speed * rn))
    );

    float width_step = step(
        remainder * rain_amount,
        far_rain_width + (near_rain_width - far_rain_width) * rn
    );

    float transparency = far_rain_transparency + (near_rain_transparency - far_rain_transparency) * rn;

    float rain_mask = rain_step * transparency * width_step;

    COLOR = vec4(rain_color.rgb, rain_color.a * rain_mask);
}