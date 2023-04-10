// Ç±ÇøÇÁÇ™ÉIÉäÉWÉiÉãÇ≈Ç∑ÅB
// ÅyçÏé“Åzpanna_pudiÇ≥ÇÒ
// ÅyçÏïiñºÅzTorus Knotus Rotatus
// https://www.shadertoy.com/view/7ttBDj

uniform vec3 iResolution;
uniform vec4 iMouse;
uniform float iTime;
uniform int iFrame;
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;

// Torus Knotus Rotatus by Pudi
// Email: k.a.komissar@gmail.com
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//
// Thanks to Flopine, provod, YX, NuSan, slerpy, Shane, z0rg, Tater, nekos in general
// BigWings, FabriceNeyret, iq, and Blackle for sharing their knowledge
//
// Specifically thanks morimea for giving good references and guiding me
// and wrighter for hanging out with me on modeling stage.
//
// 'Square Truchet Flow' by Shane
// I actually spoilered myself how to make pretty arrows
// on truchet by casually browsing shadertoy. And it's super pretty!
// https://www.shadertoy.com/view/XtfyDX
//
// 'Conformal Torus Mapping' by Fabrice
// It took me some time to ungold this shader and
// I was surprised it's working for knot variations
// https://www.shadertoy.com/view/sdd3R4

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = fragCoord/iResolution.xy;
    
    vec3 col = texture(iChannel0, uv).rgb;
    col = pow(col, vec3(1. / 2.2));
    fragColor = vec4(col, 1.0);
}

void main() {
	vec4 fragColor;
	vec2 fragCoord = gl_FragCoord.xy;
	mainImage(fragColor, fragCoord);
	fragColor.a = 1.0;
	gl_FragColor = fragColor;
}
