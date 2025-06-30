shader_type spatial;
uniform sampler2D texture_albedo : source_color;
uniform float falloff;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//center the UV coords since they start top left (0,0)
	float center = 0.5;
	vec2 centered_uv = UV - vec2(center);
	
	float radius = sqrt((centered_uv.x * centered_uv.x + centered_uv.y * centered_uv.y));
	float angle = atan(centered_uv.y, centered_uv.x);
	radius = pow(radius, falloff);
	float X = radius * (cos(angle));
	float Y = radius * (sin(angle));
	
	vec2  warped = vec2(X + center, Y + center);  
	vec4  col = texture(texture_albedo, warped);


	ALBEDO = col.rgb;
	ALPHA = col.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
