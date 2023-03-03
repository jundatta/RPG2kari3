// こちらがオリジナルです。
// 【作者】Kamoshikaさん
// 【作品名】午前5:38 2022年2月5日のツイート
// https://twitter.com/kamoshika_vrc/status/1489699798210859009
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

vec3 hsv(float h, float s, float v){
    vec4 t = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(vec3(h) + t.xyz) * 6.0 - vec3(t.w));
    return v * mix(vec3(t.x), clamp(p - vec3(t.x), 0.0, 1.0), s);
}

#define X(s)d=(s*sqrt(D)-b)/a;P=d*R;if(d<m&&sin((atan(P.z+1.,P.x)+P.y*3.-t)*9.)>.9)m=d,ooo.rgb=hsv(i*9.,.7,i/m);

void main(void) {
	vec3 P,R=vec3((FC.xy-r*.5)/r.y,-1);
	P = vec3(0);
	vec4 ooo = vec4(0);
	for(float i=0.,m=9.;i<.7;i+=.07){
		float c=cos(i);
		float e=c*c;
		float a=R.y*R.y-dot(R,R)*e;
		float b=R.y-e*(R.y+R.z);
		float D=b*b-a+2.*a*e,d;
		X(1.)
		ooo.a = 1.0;
		o = ooo;
		X(-1.)
		ooo.a = 1.0;
		o = ooo;
	}
}