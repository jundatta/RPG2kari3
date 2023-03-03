// こちらがオリジナルです。
// 【作者】Kamoshikaさん
// 【作品名】午後3:58 2022年10月1日のツイート
// https://twitter.com/kamoshika_vrc/status/1576104344683880448
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
	float d = 0;
	for(float i = 0.0;i++<5.;)
	{
		vec2 p=(FC.xy-r*.4)/r.y,I;
		I = vec2(0);
		d=i/length(p)*.1;
		p=vec2(mod(atan(p.y,p.x)+i+t*.2,PI2),d+t)/PI*2.;
		for(int j = 0;j++<5&&F<.5;){
			I=ceil(p+=p)+i;
		}
		vec4 ooo = vec4(0);
		if(F<.5&&length(max(abs(fract(p)-.5)-.3,0.))<.15){
			ooo.rgb+=hsv(F,.6,exp(-d*d*.2)*.5);
		}
	    ooo+=texture(b,FC.xy/r)*.75;
		ooo.a = 1.0;
		o = ooo;
	}
}