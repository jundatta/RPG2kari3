// こちらがオリジナルです。
// 【作者】Kamoshikaさん
// 【作品名】午後11:31 2022年5月31日のツイート
// https://twitter.com/kamoshika_vrc/status/1531644620261969921
//
// ※つぶやきGLSLの詳細はこちら
// 「GLSL最短チャレンジ #つぶやきGLSL」
// https://zenn.dev/yuji_ap/articles/7f7f0cfd589bad

precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

#define t time
// #define r resolution
#define FC gl_FragCoord
#define o gl_FragColor

vec3 hsv(float h, float s, float v){
    vec4 t = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(vec3(h) + t.xyz) * 6.0 - vec3(t.w));
    return v * mix(vec3(t.x), clamp(p - vec3(t.x), 0.0, 1.0), s);
}

#define S smoothstep

void main(void) {
	vec2 p=(FC.xy*2.-resolution)/resolution.y*(5e-4+pow(cos(t*.15),8.)*1.5);
	vec2 q = vec2(0);
	p.x-=1.4185;
	float d=9.;
	for(float i=0.0;i++<300.&&dot(q,q)<4.;d=min(d,length(q-sin(vec2(9,7)*t*.1)))){
		q=vec2(q.x*q.x-q.y*q.y,2.*q.x*q.y)+p;
	}
	vec4 ooo = vec4(0);
	ooo.r=S(.5,.45,d);
	ooo.gb+=S(.25,.23,d);
	ooo.rg-=S(.13,.12,d);
	ooo.a = 1.0;
	o = ooo;
}