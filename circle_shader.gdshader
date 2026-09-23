shader_type canvas_item;

void fragment() {
    // Calculate distance from center (UV coordinates go from 0.0 to 1.0)
    float dist = distance(UV, vec2(0.5));
    
    // Smooth anti-aliased edge around the circle border (radius = 0.5)
    float alpha = 1.0 - smoothstep(0.48, 0.5, dist);
    
    // Apply smooth transparency outside the radius
    COLOR.a *= alpha;
}