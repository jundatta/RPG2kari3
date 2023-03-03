// こちらがオリジナルです。
// 【作者】Kamoshikaさん
// 【作品名】午前5:18 2023年1月8日のツイート
// https://twitter.com/kamoshika_vrc/status/1611819657652207617
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
#define r resolution
#define FC gl_FragCoord
#define o gl_FragColor
#define b backbuffer
#define texture texture2D

const float PI = acos(-1.);
const float PI2 = acos(-1.)*2.;

vec3 hsv(float h, float s, float v){
    vec4 t = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(vec3(h) + t.xyz) * 6.0 - vec3(t.w));
    return v * mix(vec3(t.x), clamp(p - vec3(t.x), 0.0, 1.0), s);
}
// fract sin noise
float fsnoise(vec2 c){
    return fract(sin(dot(c, vec2(12.9898, 78.233))) * 43758.5453);
}

#define F fsnoise(I+=I)

void main(void) {
	vec4 ooo = vec4(0);
	ooo+=.8;
	float h = 0.0;
	for(float i = 0.0;i++<5.;){
		vec2 p=FC.xy/r.y*(6.-i)+.7;
		h=fract(sin(ceil(p.x)+i/5.)*3e3);
		p.y-=t*.5+h;
		h+=p.y*.4;
		p=fract(p)-.5;
		vec4 q=vec4(p,p-.1);
		q.yw-=(.4-abs(q.xz))*abs(q.xz)*4.-q.yw*.6;
		ooo*=smoothstep(.1,.4,length(q.xy))*.5+.5;
		if(length(q.wz)<.25) {
			ooo.rgb=hsv(h,.5,1.);
		}
	}
	ooo.a = 1.0;
	o = ooo;
}
