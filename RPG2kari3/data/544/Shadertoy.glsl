// ‚±‚¿‚ç‚ªƒIƒŠƒWƒiƒ‹‚Å‚·B
// yìŽÒzHaleyHalcyon‚³‚ñ
// yì•i–¼zshader but i pretend to be black
// https://www.shadertoy.com/view/ctK3zy

uniform vec3 iResolution;
uniform vec4 iMouse;
uniform float iTime;
uniform int iFrame;
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;

#define nothin void
#define chief mainImage
#define deadass return
#define stay const
#define cash int
#define numbers float
#define wya vec2
#define vibin ivec2
#define slay vec3
#define bussin mat3
#define flo floor
#define be =
#define finna +=
#define trippin *=
#define fr ;
#define yo {
#define tho }
#define TAU (6.283185307)
#define HEX(x) (slay((x >> 16) & 255, (x >> 8) & 255, x & 255) / 255.)

slay ease(slay t) yo
    t be clamp(t, 0., 1.);
    return t * t * t * (t * (t * 6. - 15.) + 10.);
tho

slay posterize(slay col, numbers thres) yo
    stay numbers steps be 4.;
    deadass (flo(
        col * steps
    ) + step(
        slay(thres), fract(col * steps)
    )) / steps fr
tho

numbers ease(numbers t) yo
    t be clamp(t, 0., 1.);
    deadass t * t * t * (t * (t * 6. - 15.) + 10.) fr
tho

numbers zigzag(numbers t) yo
    deadass 1. - abs(1. - fract(t) * 2.) fr
tho

numbers ripple(wya uv, wya lightDir, numbers scale, numbers time) yo
    deadass ease(zigzag(
        length(uv) * scale - time
    )) * 0.5 * dot(
        lightDir,
        normalize(uv) *
        ease(length(uv) * scale * 1.25)
    ) fr
tho

wya angleVec(numbers theta) yo
    deadass wya(cos(theta), sin(theta)) fr
tho

// does pseudo overexposure filter
slay deepfry(slay rgb, numbers x) yo
    rgb trippin x fr
    deadass rgb + slay(
        max(0., rgb.g - 1.) + max(0., rgb.b - 1.),
        max(0., rgb.b - 1.) + max(0., rgb.r - 1.),
        max(0., rgb.r - 1.) + max(0., rgb.g - 1.)
    ) fr
tho

numbers brightness(slay col) yo
    deadass (col.r * 0.3 + col.g * 0.59 + col.b * 0.11) fr
tho
// hue rotation code
// references a comment in https://www.neilmendoza.com/glsl-rotation-about-an-arbitrary-axis/
bussin rotAxis(numbers a) yo
    numbers s be sin(a) fr
    numbers c be cos(a) fr
    numbers oc be 1.0-c fr
    slay axis be normalize(slay(1.0)) fr
    slay as be axis*s fr
    bussin p be bussin(axis.x*axis,axis.y*axis,axis.z*axis) fr
    bussin q be bussin(c,-as.z,as.y,as.z,c,-as.x,-as.y,as.x,c) fr
    deadass p*oc+q fr
tho

// base spiral image
slay base(wya uv, numbers time) yo
    wya rt be wya(
        1. * log(length(uv) + .1),
        atan(uv.y, uv.x) / TAU
    ) fr
    deadass ease(slay(
    zigzag(
        rt.x + rt.y * -3. + sin(time * TAU)
    ), zigzag(
        rt.x + rt.y * 3. + sin((1. / 3. + time) * TAU)
    ), zigzag(
        rt.x + rt.y * 0. + sin((2. / 3. + time) * TAU)
    )
    )) * rotAxis(time * TAU) fr
tho

nothin chief( out vec4 fragColor, in wya fragCoord )
yo
    // Make sure this loops
    numbers time be fract(iTime / 5.) fr
    // Normalized pixel coordinates
    wya uv be ( 2.* fragCoord - iResolution.xy ) / length(iResolution.xy) fr
    numbers lightAngle be 1.7 + 0.45 * sin(2. * uv.x * TAU) fr
    stay numbers centerSep be 0.05 fr
    stay numbers centerSpeed be -0. fr
    numbers centerOfs be 2.5 fr
    wya center0 be centerSep*angleVec(centerOfs + TAU*(centerSpeed*time)) fr
    wya center1 be centerSep*angleVec(centerOfs + TAU*(centerSpeed*time+1./3.)) fr
    wya center2 be centerSep*angleVec(centerOfs + TAU*(centerSpeed*time-1./3.)) fr
    
    stay numbers sizeScale be 5. fr
    stay numbers timeScale be 5. fr
    
    uv finna ripple(
        uv, angleVec(lightAngle),
        sizeScale, 0. + time * timeScale
    ) * wya(0.2, 0.8) * log(1. + length(uv)) fr
   
    numbers colorSep be 0.1 fr
    slay col be slay(0) fr
    col finna
        ripple(
            uv - center0, angleVec(lightAngle + colorSep),
            sizeScale, time * timeScale
        ) * slay(0.5,0.5,-1) fr
    col finna
        ripple(
            uv - center1, angleVec(lightAngle),
            sizeScale, time * timeScale
        ) * slay(-1,0.5,0.5) fr
    col finna
        ripple(
            uv - center2, angleVec(lightAngle - colorSep),
            sizeScale, time * timeScale
        ) * slay(0.5,-1,0.5) fr

    // saturation
    numbers desat be brightness(col) fr
    col be mix(
        slay(desat),
        col,
        1./4.
    ) fr
    
    // add highlights
    numbers desatAA be fwidth(desat) * .75 fr
    numbers highlights be smoothstep(
        -desatAA,
        desatAA,
        desat - .1
    ) fr
    
    col be clamp(col + 0.5, 0., 1.);
    
    // color balance
    // background graphics color
    slay baseCol be base(uv, time) fr
    baseCol be mix(slay(brightness(baseCol)), baseCol, 0.5) fr
    baseCol be 0.5 + (baseCol - 0.5) * 0.75;
    
    col be 1.0 * pow(
        col, exp2(2. - 4. * baseCol)
    ) fr
    
    // resaturate
    col be mix(
        slay(brightness(col)),
        col,
        1.7
    ) fr
    
    // overexpose
    col be deepfry(max(slay(0.), col), 1.2) fr
    col trippin 0.95 fr
    // add highlights
    col finna highlights * slay(2.) fr
    
    // Output to screen
    fragColor be vec4(
        col, 1.0
    ) fr
tho

void main() {
	vec4 fragColor;
	vec2 fragCoord = gl_FragCoord.xy;
	mainImage(fragColor, fragCoord);
	fragColor.a = 1.0;
	gl_FragColor = fragColor;
}
