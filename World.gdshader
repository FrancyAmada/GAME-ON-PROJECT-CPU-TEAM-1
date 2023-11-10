shader_type canvas_item;

uniform float pixel_size : hint_range(1, 10) = 5.0;

void vertex() {
    // Calculate the rounded UV coordinates
    vec2 rounded_uv = floor(VERTEX.xy / pixel_size) * pixel_size;
    
    // Pass the modified UV coordinates to the fragment shader
    UV = rounded_uv;
}