shader_type sky;

uniform vec4 baseColor : source_color;
uniform vec4 skyColor : source_color;
uniform vec4 cloudColor : source_color;
uniform vec4 starColor : source_color;
uniform sampler2D cloudNoise : filter_nearest;
uniform sampler2D starNoise : filter_nearest;    
uniform float cloudAmount : hint_range(0.0, 1.0);
uniform float starAmount : hint_range(0.0, 1.0);
uniform float sunPosx: hint_range(-1.0, 1.0);
uniform float sunPosy: hint_range(-1.0, 1.0);

void sky() {
	
	if(AT_CUBEMAP_PASS){
		COLOR = skyColor.rgb;
	}

	if(EYEDIR.y>0.0 && !AT_CUBEMAP_PASS){
		float gradientStep = (EYEDIR.x * sunPosx) + (EYEDIR.y * sunPosy);
		vec3 gradientCol = mix(baseColor.rgb*0.8, baseColor.rgb*8.0, gradientStep*0.1);
		
		float sunDot = dot(EYEDIR.xy, vec2(sunPosx, sunPosy));
		float moonDot = dot(EYEDIR.xy, vec2(-sunPosx, -sunPosy));
		
		if(sunDot > 0.999){
			gradientCol*=50.0;
		}
		if(moonDot > 0.998){
			
			gradientCol = mix(vec3(0.1), vec3(0.8), 0.7);
		}
		  
	    float star_n = texture(starNoise, EYEDIR.xz / sqrt(EYEDIR.y)).r;
		
		star_n = clamp(star_n * starAmount, 0.0, 1.0);	
		
	    vec3 skyCol = mix(gradientCol.rgb, starColor.rgb, star_n);
		
	    vec2 cloudUV = EYEDIR.xz / sqrt(EYEDIR.y);
	    float n = texture(cloudNoise, cloudUV).r;
	    n = clamp(n * cloudAmount, 0.0, 1.0);
	    vec3 cloudCol = mix(vec3(0.0), cloudColor.rgb, n);

	    //Combine sky + clouds
	    COLOR = (skyCol + cloudCol);
	}
}
