// ‚±‚¿‚ç‚ªƒIƒŠƒWƒiƒ‹‚Å‚·B
// yìÒzkishimisu‚³‚ñ
// yì•i–¼zNeon Core [290 chars]
// https://www.shadertoy.com/view/dlc3Wl

uniform vec3 iResolution;
uniform vec4 iMouse;
uniform float iTime;
uniform int iFrame;
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;

/* Neon Core by @kishimisu (2023) - https://www.shadertoy.com/view/dlc3Wl
   [290 chars]
   
   There's only one "real" sphere, all others are mirror versions
*/

#define M(p) p *= mat2(cos(round((atan(p.x,p.y)+k)/.3)*.3-k + vec4(0,33,11,0))),//
#define L length(p)//

void mainImage(out vec4 O, vec2 F) {   
    vec3  p, R = iResolution;
	R.z = 1.0;
    float i = 0.0, t = 0.0, k = iTime*.2;

	vec4 ooo = vec4(0);
    for (ooo *= t; 
         i++ < 30.; 
         ooo += .005 * (1. + cos(k+k+t+vec4(0,1,2,0))) / L
    ) 
         p = R - vec3(F+F, R.y),
         p = t/L*p - 3./R,
         M(p.zx) M(p.yx)
         p.x -= 2., t -= L - .1,
		O = ooo;
}

void main() {
	vec4 fragColor;
	vec2 fragCoord = gl_FragCoord.xy;
	mainImage(fragColor, fragCoord);
	fragColor.a = 1.0;
	gl_FragColor = fragColor;
}
