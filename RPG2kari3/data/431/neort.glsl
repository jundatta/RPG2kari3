// ‚±‚¿‚ç‚ªƒIƒŠƒWƒiƒ‹‚Å‚·B
// yìŽÒzKamoshika‚³‚ñ
// yì•i–¼z7-Segment Display Characters
// https://neort.io/art/c49vfn43p9ffolj05dl0

precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

#define t time
#define r resolution
#define FC gl_FragCoord
#define o gl_FragColor

float fsnoise(vec2 c) {
    return fract(sin(dot(c, vec2(12.9898, 78.233))) * 43758.5453);
}

mat2 rotate2D(float a) {
    return mat2(cos(a), sin(a), -sin(a), cos(a));
}

void main(void) {
    vec2 p=FC.xy/r.y*10.,a=vec2(.7,1.4);
    p.y-=t;
    float n=fsnoise(ceil(p/a)),s;
    p=mod(p,a)-a*.5;
    s=fsnoise(ceil(p*rotate2D(.785)/.28+.5+ceil(n*5e2+t*2.)));
    p=abs(p);
    p.y-=.2;
    p=abs(p);
    p=p.y>p.x?p.yx:p;
    p.x-=.2;
    p=abs(p);
    if(n<.7)n=max(p.y-.1,0.)+p.x;
    if(n>.03&&n<.08&&s<.7)o.g=1.;
    o.w=1.;
}
