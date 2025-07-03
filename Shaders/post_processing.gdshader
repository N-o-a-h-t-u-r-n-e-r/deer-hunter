shader_type spatial;
// Prevent the quad from being affected by lighting and fog. This also improves performance.
render_mode unshaded, fog_disabled;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D screen_texture : source_color, hint_screen_texture;

void vertex() {

  	POSITION = vec4(VERTEX.xy, 0.5, 0.5);
}

void fragment() {
	vec4 screen = texture(screen_texture, SCREEN_UV);
	float depth = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
  	view.xyz /= view.w;
  	float linear_depth = mix(-10, 10, depth);
	//vec4 world = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
  	//vec3 world_position = world.xyz / world.w;
	ALBEDO.rgb = screen.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
