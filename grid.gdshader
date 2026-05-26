shader_type canvas_item;

uniform float grid_size_x = 32.0;
uniform float grid_size_y = 32.0;
uniform float line_width = 0.1;
uniform vec4 grid_color : source_color = vec4(0.25, 0.25, 0.25, 1.0);
uniform vec4 bg_color : source_color = vec4(0.08, 0.08, 0.08, 1.0);

void fragment() {
    vec2 grid = vec2(fract(FRAGCOORD.x / grid_size_x)/fwidth(FRAGCOORD.x/grid_size_x), fract(FRAGCOORD.y/grid_size_y)/fwidth(FRAGCOORD.y/grid_size_y));
    float line = min(grid.x, grid.y);
    float alpha = 1.0 - min(line / line_width, 1.0);
    COLOR = mix(bg_color, grid_color, alpha);
}