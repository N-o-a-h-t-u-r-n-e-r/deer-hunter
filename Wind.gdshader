shader_type spatial;
render_mode depth_prepass_alpha, cull_disabled;

uniform sampler2D texture_albedo : source_color, filter_nearest;
uniform vec4 transmission : source_color;

uniform float sway_speed = 1.0;
uniform float sway_strength = 0.05;
uniform float sway_point = 0.05;


void vertex() {
	//Mesh up axis is -z so divide that by the set sway point
	float body = (-VERTEX.z) / sway_point;

	//Only sway if above the threshold
	if(body > 0.7){
		VERTEX.x += sin(VERTEX.x + (TIME + body) * sway_speed + INSTANCE_CUSTOM.x) * sway_strength;
		VERTEX.y += sin(VERTEX.y + (TIME + body) * sway_speed + INSTANCE_CUSTOM.y) * sway_strength;
	}
}

void fragment() {
	vec4 albedo_tex = texture(texture_albedo, UV);
	ALBEDO = albedo_tex.rgb;
	ALPHA = albedo_tex.a;
	METALLIC = 0.0;
	ROUGHNESS = 1.0;
	SSS_TRANSMITTANCE_COLOR = transmission.rgba;
}
