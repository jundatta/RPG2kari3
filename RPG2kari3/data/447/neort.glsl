// Ç±ÇøÇÁÇ™ÉIÉäÉWÉiÉãÇ≈Ç∑ÅB
// ÅyçÏé“ÅzKamoshikaÇ≥ÇÒ
// ÅyçÏïiñºÅzStairway to Heaven
// https://neort.io/art/c00rj2k3p9f30ks58e50

precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

#define saturate(x) clamp(x, 0., 1.)

const float pi = acos(-1.);

mat3 rotate3D(float angle, vec3 axis) {
    vec3 n = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float r = 1.0 - c;
    return mat3(
        n.x * n.x * r + c,
        n.x * n.y * r - n.z * s,
        n.z * n.x * r + n.y * s,
        n.x * n.y * r + n.z * s,
        n.y * n.y * r + c,
        n.y * n.z * r - n.x * s,
        n.z * n.x * r - n.y * s,
        n.y * n.z * r + n.x * s,
        n.z * n.z * r + c
    );
}

float rand(float x) {
    return fract(sin(x) * 43758.5453);
}

float noise(vec3 x) {
	vec3 p = floor(x);
	vec3 f = fract(x);
	f = f * f * (3.0 - 2.0 * f);
	vec3 b = vec3(173, 61, 3);
	float n = dot(p, b);
	return mix(	mix(	mix(rand(n), rand(n+b.x), f.x),
		   				mix(rand(n+b.y), rand(n+b.x+b.y), f.x),
		   				f.y),
		  	 	mix(	mix(rand(n+b.z), rand(n+b.x+b.z), f.x),
		   				mix(rand(n+b.y+b.z), rand(n+b.x+b.y+b.z), f.x),
		   				f.y),
		  	 	f.z);
}

float fbm(vec3 p) {
    float s = 0.;
    float a = 0.5;
    for(int i=0; i<5; i++) {
        s += a*noise(p);
        a *= 0.5;
        p *= 2.01;
    }
    return s;
}

float sampleDensity(vec3 p) {
    float n = fbm(p*0.1)-0.5;
    return saturate(n*17.5);
}

float distStairway(vec3 p) {
    p.z = mod(p.z, sqrt(2.)) - sqrt(2.)/2.;
    p.zx = abs(p.zx);
    float d1 = dot(p, normalize(vec3(0, 1, 1))) - 0.5;
    float d2 = dot(p, normalize(vec3(0, -1, -1))) - 0.5;
    return max(p.x - 5., max(d1, d2));
}

vec4 genAmbientOcclusion(vec3 ro, vec3 rd) {
    vec4 totao = vec4(0.);
    float sca = 1.;
    for(int aoi=0; aoi<10; aoi++) {
        float hr = 0.01 + 0.02 *float(aoi*aoi);
        vec3 aopos = ro + rd * hr;
        float dd = distStairway(aopos);
        float ao = saturate(hr-dd);
        totao += ao * sca * vec4(1);
        sca *= 0.75;
    }
    const float aoCoef = 0.5;
    totao.w = 1.0 - saturate(aoCoef * totao.w);
    return totao;
}

vec3 getStairwayNormal(vec3 p) {
    vec3 normal = vec3(0, 1, 1);
    if(p.x > 4.995) {
        normal = vec3(1, 0, 0);
    } else if(p.x < -4.995) {
        normal = vec3(-1, 0, 0);
    } else {
        p.z = mod(p.z, sqrt(2.)) - sqrt(2.)/2.;
        if(p.y > 0.) {
            if(p.z > 0.) {
                normal = vec3(0, 1, 1);
            } else {
                normal = vec3(0, 1, -1);
            }
        } else {
            if(p.z > 0.) {
                normal = vec3(0, -1, -1);
            } else {
                normal = vec3(0, -1, 1);
            }
        }
    }
    return normalize(normal);
}

void main(void) {
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
    
    vec3 cPos = vec3(0, 16, 16);
    cPos *= rotate3D(time*0.1+3.5, vec3(0, 1, -1));
    vec3 cDir = normalize(-cPos);
    cPos += vec3(0, 0, -1)*time*5.;
    vec3 cUp = normalize(vec3(0, 1, -1));
    vec3 cSide = normalize(cross(cDir, cUp));
    
    vec3 ray = normalize(p.x*cSide + p.y*cUp + cDir*2.5);
    vec3 lightDir = normalize(vec3(3., 2., 0.4));
    
    // sky and sun
    vec3 col = vec3(0.5, 0.6, 0.9)*0.1;
    float s = max(dot(lightDir, ray), 0.);
    col = mix(col, vec3(1), pow(s, 40.)*0.7);
    
    // stairway
    vec3 rayPos = cPos;
    float d = 0.;
    for(int i=0; i<100; i++) {
        d = distStairway(rayPos);
        if(abs(d) < 0.0001 || length(rayPos-cPos) > 100.) {
            break;
        }
        rayPos += ray * d;
    }
    if(abs(d) < 0.1) {
        vec3 normal = getStairwayNormal(rayPos);
        float diff = max(dot(lightDir, normal), 0.1);
        vec4 ao = genAmbientOcclusion(rayPos, normal);
        col = vec3(1. - ao.xyz * ao.w) * diff;
    }
    
    // cloud
    // Reference:
    // https://qiita.com/aa_debdeb/items/eabc92aaee4ae226b4d5
    float rayStepSize = 4.;
    vec3 rayStep = ray * rayStepSize;
    float shadowStepSize = 2.;
    vec3 shadowStep = lightDir * shadowStepSize;
    vec3 accum = vec3(0);
    int maxItr = int(length(rayPos-cPos)/rayStepSize) + 1;
    rayPos = cPos;
    float T = 1.;
    for(int i=0; i<20; i++) {
        if(i >= maxItr) {
            break;
        }
        float density = sampleDensity(rayPos);
        if(density > 0.001) {
            density = saturate(density * 0.1);
            vec3 shadowPos = rayPos;
            float shadowDensity = 0.;
            for(int j=0; j<2; j++) {
                shadowPos += shadowStep;
                shadowDensity += sampleDensity(shadowPos);
            }
            vec3 ATT = exp(-shadowDensity * vec3(0.7, 0.8, 0.7) * 1.);
            accum += vec3(1) * ATT * T * density;
            T *= 1.-density;
        }
        if(T < 0.001) {
            break;
        }
        rayPos += rayStep;
    }
    col += accum + T*col;
    col = pow(col, vec3(1./2.2));
    
    gl_FragColor = vec4(col, 1.0);
}
