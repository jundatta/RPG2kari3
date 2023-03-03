// ‚±‚¿‚ç‚ªƒIƒŠƒWƒiƒ‹‚Å‚·B
// yìŽÒzKamoshika‚³‚ñ
// yì•i–¼zSpherical Shell with Slits 4
// https://neort.io/art/c5i090k3p9fe3sqpms00

precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

#define t time
#define r resolution
#define FC gl_FragCoord
#define o gl_FragColor

// ‚æ‚­‚í‚©‚è‚á‚ñ_(^_^)^‚ªBBB
//RuntimeException: Cannot compile fragment shader:
//0:43(8): error: syntax error, unexpected FLOATCONSTANT, expecting ',' or ';'
//#define X(s)d=1.-s*sqrt(D);if(D>0.&&d<m&&sin((acos(P.y/l)+s*acos(P.x/length(vec2(P.x,1.-d)))-t)*10.)>0.)m=d;

#define X(s)d=1.-(s)*sqrt(D);if(D>0.&&d<m&&sin((acos(P.y/l)+(s)*acos(P.x/length(vec2(P.x,1.-d)))-t)*10.)>0.)m=d;

vec3 hsv(float h, float s, float v) {
    vec4 a = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(vec3(h) + a.xyz) * 6.0 - vec3(a.w));
    return v * mix(vec3(a.x), clamp(p - vec3(a.x), 0.0, 1.0), s);
}

void main(void) {
    vec2 P=vec2(FC.xy*2.-r)/r.y;
    float d,m=1e5,D;
    for(float l=.2;l<1.;l+=.2){
        D=l*l-dot(P,P);
        X(1.)
        X(-1.)
    }
    o.rgb=hsv(length(vec3(P,1.-m)),.6,exp(-m*m*.6)*1.7);
    o.a=1.;
}
