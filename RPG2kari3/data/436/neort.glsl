// Ç±ÇøÇÁÇ™ÉIÉäÉWÉiÉãÇ≈Ç∑ÅB
// ÅyçÏé“ÅzKamoshikaÇ≥ÇÒ
// ÅyçÏïiñºÅzRings 2
// https://neort.io/art/c5ld0ec3p9fe3sqpnsi0

precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

#define t time
#define r resolution
#define FC gl_FragCoord
#define o gl_FragColor

const float PI = acos(-1.);

mat2 rotate2D(float a) {
    return mat2(cos(a), sin(a), -sin(a), cos(a));
}

mat3 rotate3D(float angle, vec3 axis){
    vec3 a = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float r = 1.0 - c;
    return mat3(
        a.x * a.x * r + c,
        a.y * a.x * r + a.z * s,
        a.z * a.x * r - a.y * s,
        a.x * a.y * r - a.z * s,
        a.y * a.y * r + c,
        a.z * a.y * r + a.x * s,
        a.x * a.z * r + a.y * s,
        a.y * a.z * r - a.x * s,
        a.z * a.z * r + c
    );
}

void main(void) {
    vec3 P = vec3(0);
    vec3 Q,S;
    P.z=5.;
    float d=1.;
    vec4 ooo = vec4(0);
    for(int i=0;i<99;i++){
        if(d<1e-4)break;
        Q=P*rotate3D(t/PI,vec3(1,5,3));
        d=9.;
        for(float j=.25;j<3.;j+=.25){
            S=Q;
            S.xy*=rotate2D(sin(t*.5)*2.*j+t*.5);
            d=min(d,max(abs(S.y),abs(length(S.zx)-j))-.1);
        }
        P+=normalize(vec3((FC.xy*2.-r)/r.y,-2))*d;
//        o+=exp(-d)*.05;
//        o.a=1.;
        ooo+=exp(-d)*.05;
        ooo.a=1.;
    }
    o = ooo;
}