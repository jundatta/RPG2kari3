// Ç±ÇøÇÁÇ™ÉIÉäÉWÉiÉãÇ≈Ç∑ÅB
// ÅyçÏé“Åzphi16Ç≥ÇÒ
// ÅyçÏïiñºÅzLight in rain : side F
// https://neort.io/art/bko7vos3p9f7drq1jio0

precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

float rand(vec2 co) {
    return fract(sin(dot(co,vec2(95.92921,392.492))) * 93683.2319);
}

float noise(vec2 r) {
	vec2 p = floor(r);
    vec2 f = fract(r);
    f = smoothstep(0.,1.,f);
    vec2 e = vec2(0,1);
    float p00 = rand(p+e.xx);
    float p01 = rand(p+e.xy);
    float p10 = rand(p+e.yx);
    float p11 = rand(p+e.yy);
	return mix(
        mix(p00,p01,f.y),
        mix(p10,p11,f.y),
    f.x) - 0.5;
}

float ot(vec2 r) {
	float v = noise(r) + noise(r*2.*mat2(1,-2,2,1)/sqrt(5.))/2. + noise(r*4.*mat2(-3,5,-5,-3)/sqrt(34.))/4.;
    return v * 0.5 + 0.5;
}

vec3 pmul(vec3 a, vec3 b) {
	return vec3(a.y*b.y, a.z*b.y+a.y*b.z, a.z*b.z);
}

void main(void) {
    vec2 uv = (gl_FragCoord.xy * 2.0 - resolution.xy) / resolution.y;
    vec3 color = vec3(0.03);
    vec3 cam = vec3(0.,1.,0.);
    vec3 dir = normalize(vec3(uv,1.));
    dir.yz *= mat2(5,1,-1,5)/sqrt(26.);
    float maxD = 1000.;
    
    // (cam + dir * t).y = 0
    if(dir.y < -0.05) {
	    float groundT = (0. - cam.y) / dir.y;
        maxD = min(maxD, groundT);
    	vec3 groundPos = cam + dir * groundT;
        vec2 coord = groundPos.xz*3.;
        vec3 normal = vec3(ot(coord)*2.-1., ot(coord+2.5)+0.1, ot(coord+4.2)*2.-1.);
        normal = normalize(normal);
        vec3 ld = normalize(vec3(0.3,2,-1));
        vec3 diff = vec3(0.1,0.1,0.2) * dot(normal,ld);
        color = diff;
        vec3 rd = reflect(dir, normal);
        vec3 spec = pow(max(0.,dot(rd,ld)), 9.) * vec3(0.4,0.4,0.5);
        color += spec;
        vec3 u = groundPos - vec3(1,1.5,2.0);
        u.xy *= mat2(2,-1,1,2)/sqrt(5.);
        float ll = length(u.xz) - abs(u.y*0.2);
        color = mix(vec3(1,0.8,0.4),color,(smoothstep(0.5,-0.5,1. - ll)*0.6+0.4));
        
        float depth = ot(coord*0.3+0.1);
        vec3 drop = vec3(0,0,0.2);
        drop = mix(drop, diff, 0.2);
        vec3 side = vec3(1,1,1);
        color = mix(color, mix(drop, side, smoothstep(0.55,0.52,depth)), smoothstep(0.5,0.6,depth));
    }
    // rain
    for(int i=0;i<15;i++) {
        float a = atan(dir.z,dir.x)/3.1415926535/2.;
        float sep = 40.*(float(i)+2.);
        float baseIndex = floor(a*sep+0.5);
        float per = time*0.2*3. + rand(vec2(baseIndex,3+i));
        float seed = (baseIndex + floor(per)*sqrt(2.)) * .2;
        float aix = floor(a*sep+0.5)/sep * 3.1415926535 * 2.;
        float rad = 2. + float(i) * 1.;
        rad += pow(rand(vec2(seed,1))*0.9+0.1,3.)*5.;
        float fpos = 3.0 - ((pow(fract(per),2.)+1.)*5. - 5.);
        vec3 rp = vec3(cos(aix),fpos,sin(aix)) * rad;
        float yScale = 0.03 + rand(vec2(seed,6)) * 0.01;
        // min_t distance(cam.xz + dir.xz * t, rp)
        vec3 fx = vec3(0,dir.x,cam.x-rp.x);
        vec3 fy = vec3(0,dir.y,cam.y-rp.y) * yScale;
        vec3 fz = vec3(0,dir.z,cam.z-rp.z);
        vec3 ff = pmul(fx,fx) + pmul(fy,fy) + pmul(fz,fz);
        // min_t <ff,(t^2,t,1)>
        vec2 ffp = vec2(2.*ff.x,ff.y);
        float rpt = - ffp.y / ffp.x;
        vec3 nep = cam + dir * rpt;
    	float ww = 2./(rand(vec2(seed,4)) * 0.5 + 0.5);
        float dist = length((nep-rp)*vec3(1,yScale,1));
        if(rpt < maxD) {
            if(dist < 0.08) {
                vec3 c = mix(vec3(0.3,0.4,1.0), vec3(1.), rand(vec2(seed,5)));
                c *= pow(rand(vec2(seed,6)),4.)*0.9+0.1;
                
                vec3 u = nep - vec3(1,1.5,2.0);
                u.xy *= mat2(2,-1,1,2)/sqrt(5.);
                float ll = length(u.xz) - abs(u.y*0.2);
                c = mix(vec3(1,0.8,0.4),c,smoothstep(0.5,-0.5,1. - ll) * 0.5 + 0.5);
                
                color = mix(color, c, smoothstep(0.08,0.05,dist) * smoothstep(0.,0.2,nep.y));
                
            }
        }
    }
    float t = 0.0;
    for(int i=0;i<20;i++) {
    	t += 0.2;
        vec3 po = cam + dir * t;
        vec3 u = po - vec3(2.5,5,2.0);
        u.xy *= mat2(2,-1,1,2)/sqrt(5.);
        float ll = length(u.xz) - abs(u.y*0.2);
        color += vec3(1,0.8,0.4) * pow(smoothstep(0.5,0.,ll), 2.0) * 0.02;
    }
    gl_FragColor = vec4(color,1.0);
}
