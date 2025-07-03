shader_type spatial;

uniform sampler2D noise : filter_nearest;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec3 color_param : source_color;
uniform float transparency : hint_range(0.0, 1.0);
uniform float wave_strength = 1.0;
uniform float wave_speed = 1.0;
uniform float wave_interval = 1.0;
uniform float big_wave_interval = 1.0;
uniform float big_wave_strength = 1.0;
uniform float big_wave_speed = 1.0;
uniform float metallic = 0.0;
uniform float roughness = 0.0;
uniform float ripple = 1.0;
uniform float reflection = 0.5;
uniform float darkness = 0.5;
uniform float specular_strength = 1.0;
uniform float blur_lod : hint_range(0.0, 4.0) = 1.0;
uniform float distort_amt : hint_range(0.0,0.01) = 0.005;

varying float wave_height;

void vertex() {
	wave_height = VERTEX.y;
	float noiseX = texture(noise, UV).x;
	float noiseZ = texture(noise, UV).z;

	//Main, smaller waves
	VERTEX.y += clamp(sin(((((VERTEX.x + TIME) / wave_interval) + noiseX) + (((VERTEX.z + TIME) / wave_interval)  + noiseZ)) * wave_speed) * wave_strength, -0.5, 3);

	//Bigger waves
	VERTEX.y += clamp(sin(((((VERTEX.x + TIME) / big_wave_interval) + noiseX)  + (((VERTEX.z + TIME) / big_wave_interval)  + noiseZ)) * big_wave_speed) * big_wave_strength, 0, 2);
}

void fragment() {

	float depth_t = smoothstep(-1.0, 1.0, wave_height);
    vec3 deep_color  = color_param * darkness;
    vec3 shallow_col = color_param;
    vec3 water_col  = mix(shallow_col, deep_color, depth_t);

	 // Sample a high-frequency noise/normal map
    vec3 bump = texture(noise, UV * ripple).rgb;
    vec3 nmap = normalize(bump * 2.0 - 1.0);
    vec3 final_normal = normalize(NORMAL + nmap * reflection);

	vec2 screen_uv = SCREEN_UV;
    float distort = sin((UV.x + TIME) * wave_speed)*distort_amt;
    screen_uv.x += distort;
    screen_uv.y += distort;
    vec3 scene = textureLod(SCREEN_TEXTURE, screen_uv, blur_lod).rgb;

    NORMAL = final_normal;
	ALBEDO = mix(scene,water_col, 0.8);
	METALLIC = metallic;
	SPECULAR = specular_strength;
	ROUGHNESS = roughness;
	ALPHA = transparency;
}
