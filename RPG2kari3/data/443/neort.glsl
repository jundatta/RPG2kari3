// ‚±‚¿‚ç‚ªƒIƒŠƒWƒiƒ‹‚Å‚·B
// yìŽÒzKamoshika‚³‚ñ
// yì•i–¼zRibbons
// https://neort.io/art/c5i0cvk3p9fe3sqpms70

precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

#define t time
#define r resolution
#define FC gl_FragCoord
#define o gl_FragColor

#define X(s,l)d=s*sqrt(h);if(h>0.&&d>m&&sin(atan(d,P.y)+P.x*3.+t*l*4.)>.9)m=d;

vec3 hsv(float h, float s, float v) {
    vec4 a = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(vec3(h) + a.xyz) * 6.0 - vec3(a.w));
    return v * mix(vec3(a.x), clamp(p - vec3(a.x), 0.0, 1.0), s);
}

void main(void) {
    vec2 P=(FC.xy*2.-r)/r.y*1.1;
    float d,h,m=-1e8;
    for(float l=.1;l<1.1;l+=.1){
        h=l*l-P.y*P.y;
        X(1.,l)
        X(-1.,l)
    }
    P.x=m;
    d=length(P);
	vec4 ooo = vec4(0);
    if(m>-2.)ooo.rgb=hsv(d+.4,.7,max(m/d,.2))+pow(max(m/d,0.),40.)*.5;
    ooo.a=1.;
	o = ooo;
}
