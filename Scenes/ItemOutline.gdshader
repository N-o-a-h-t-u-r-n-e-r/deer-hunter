shader_type spatial;
uniform vec4 outline_color: source_color;
uniform bool selected = false;
uniform sampler2D texture_albedo : source_color, filter_nearest_mipmap, repeat_enable;

void vertex() {
	if(selected){
		VERTEX.x -= 0.3;
		
		}
}

void fragment() {
	
	vec4 albedo_tex = texture(texture_albedo, UV);
	ALBEDO = albedo_tex.rgb;
	if(selected){
		ALBEDO = mix(ALBEDO,outline_color.rgb, outline_color.a);
		
	}

}

