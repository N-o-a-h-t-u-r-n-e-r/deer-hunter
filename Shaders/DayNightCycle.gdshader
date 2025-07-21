shader_type sky;

uniform vec4 baseColor : source_color;
uniform vec4 cloudColor : source_color;
uniform sampler2D cloudNoise : filter_nearest;

// how quickly noise repeats
uniform vec2 noiseScale = vec2(1.0);

// cloud density threshold
uniform float cloudThreshold = 0.5;

// at what UV‑y you want clouds to start fading out (0→bottom, 1→top)
uniform float cutoffUV = 0.85;
// over how many UV units the fade goes from full to zero
uniform float fadeRange = 0.10;

void sky() {
    // get your UV (or SCREEN_UV / SAFE_UV in Godot)
    vec2 uv = SKY_COORDS * noiseScale;

    // sample the noise
    float n = texture(cloudNoise, uv).r;

    // basic cloud mask
    float cloudMask = smoothstep(cloudThreshold - 0.1,
                                 cloudThreshold + 0.1,
                                 n);

    // compute a fade‑out factor that ramps from 1 → 0
    // as uv.y goes from cutoffUV to cutoffUV+fadeRange
    float fade = smoothstep(cutoffUV,
                            cutoffUV + fadeRange*0.5,
                            -uv.y);
    // invert so fade==0 at cutoffUV, fade==1 at cutoffUV+fadeRange
    fade = clamp(fade, 0.0, 1.0);

    // knock down your clouds at the top
    cloudMask *= (1.0 - fade);

    // mix sky and cloud colors
    vec3 col = mix(baseColor.rgb, cloudColor.rgb, cloudMask);
    COLOR = col;
}
