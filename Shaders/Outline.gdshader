shader_type canvas_item;
uniform sampler2D texture_albedo : source_color, filter_nearest_mipmap;
uniform vec3 color: source_color;
uniform int texture_width = 1920;
uniform int texture_height = 1080;
uniform int search_radius = 20;
uniform float threshold = 1.0;
uniform float range = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 canvas = texture(texture_albedo, UV).rgba;
	vec2 pixel_size = vec2(1.0/float(texture_width), 1.0/float(texture_height));
	
	float nearest_distance = float(search_radius);
	for (int x = -search_radius; x < search_radius; x++){
		for (int y = -search_radius; y < search_radius; y++){
			vec2 offset = vec2(float(x), float(y));
			vec4 neighbor = texture(texture_albedo, UV + offset * pixel_size);
			float curr_distance = sqrt(float(x)*float(x) + float(y)*float(y));
			
			if (length(neighbor.rgb) > threshold){
				nearest_distance = min(nearest_distance, curr_distance);
			} 	
		}	
	}
	float distance_value = nearest_distance / float(search_radius);
	if (nearest_distance < float(search_radius) && nearest_distance > 0.0)
		COLOR = vec4(color, 1.0);
	else
		COLOR = vec4(1.0,1.0,1.0, 0.0);
	//COLOR = vec4(vec3(distance_value), 1.0);
	
}
