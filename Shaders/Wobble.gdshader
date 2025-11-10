shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx;

uniform sampler2D texture_albedo : source_color, filter_nearest_mipmap, repeat_enable;
uniform vec4  albedo_color : source_color = vec4(1.0);
uniform bool  use_texture = true; 

uniform float roughness : hint_range(0.0, 1.0) = 0.5;
uniform float specular  : hint_range(0.0, 1.0, 0.01) = 0.01;
uniform float metallic  : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float grid_size = 200.0;

void vertex() {
    vec4 view_pos = MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
    vec4 clip_pos = PROJECTION_MATRIX * view_pos;
    float gridCount = grid_size;
    vec2 ndc = clip_pos.xy / clip_pos.w;
    ndc = floor((ndc * 0.5 + 0.5) * gridCount) / gridCount * 2.0 - 1.0;
    POSITION = vec4(ndc * clip_pos.w, clip_pos.zw);
}

void fragment() {
    vec3 tex = use_texture ? texture(texture_albedo, UV).rgb : vec3(1.0);
    ALBEDO    = albedo_color.rgb * tex;
    METALLIC  = metallic;
    SPECULAR  = specular;
    ROUGHNESS = roughness;
}
