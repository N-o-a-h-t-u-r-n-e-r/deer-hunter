shader_type spatial;
uniform sampler2D texture_albedo : source_color;
uniform float buldge = 1.1;
uniform float zoom = 0.895;
uniform vec3 vin_color : source_color;
uniform vec3 crosshair_color: source_color;
uniform float crosshair_size = 0.003;
uniform float vignette_fade = 2.915;
uniform float vignette_radius = 5.535;
uniform float metallic = 0.2;
uniform float roughness = 0.2;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//center the UV coords since they start top left (0,0)
	float center = 0.5;
	vec2 centered_uv = UV - vec2(center);

	//Convert to polar coordinates
	float radius = sqrt((centered_uv.x * centered_uv.x + centered_uv.y * centered_uv.y));
	float angle = atan(centered_uv.y, centered_uv.x);
	radius = pow(radius, buldge) * zoom;

	//Get distance from the center to the radius
	float dist = distance(center, radius);

	//fade to vignette color based distance
	float vignette = smoothstep(radius, center * vignette_fade, dist * vignette_radius);


	//Convert back to cartesian coordinates
	float X = radius * (cos(angle));
	float Y = radius * (sin(angle));

	vec2  warped = vec2(X + center, Y + center);
	vec4  col = texture(texture_albedo, warped);

	//Make crosshair
	if(UV.x >= 0.5 - crosshair_size && UV.x <= 0.5 + crosshair_size || UV.y >= 0.5 - crosshair_size && UV.y <= 0.5 + crosshair_size){
		col.rgb = vin_color.rgb;
	}

	ALBEDO = col.rgb * (vin_color.rgb + vignette);
	ALPHA = col.a;
	METALLIC = metallic;
	ROUGHNESS = roughness;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
