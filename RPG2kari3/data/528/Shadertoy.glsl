// Ç±ÇøÇÁÇ™ÉIÉäÉWÉiÉãÇ≈Ç∑ÅB
// ÅyçÏé“Åzpanna_pudiÇ≥ÇÒ
// ÅyçÏïiñºÅzTatami Walk
// https://www.shadertoy.com/view/ctXGRS

uniform vec3 iResolution;
uniform vec4 iMouse;
uniform float iTime;
uniform int iFrame;
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;

/*
    Once again I saw ending from Tatami Galazy and 
    finally I got my hands on reproducing moment from it
    https://www.youtube.com/watch?v=-IcFDwygw-o
    
    Golden Section Zoom by Fizzer:
    https://www.shadertoy.com/view/WlcSD8
*/

const float PI = acos(-1.);
const float TAU = 2. * PI;

float smooth_floor(float x, float c) {
    float a = fract(x);
    float b = floor(x);
    return ((pow(a, c) - pow(1. - a, c)) / 2.) + b;
}

#define AAstep(thre, val) smoothstep(-.2,.8,(val-thre)/min(0.03,fwidth(val-thre)))

float hash21(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float hash11(float p) {
    return fract(sin(p * 78.233) * 43758.5453);
}

mat2 rot(float a) {
    float c = cos(a), s = sin(a);
    return mat2(c, -s, s, c);
}

float sd_box(vec2 p, vec2 h) {
    p = abs(p) - h;
    return length(max(p, 0.)) + min(0., max(p.x, p.y));
}

float sd_circle(vec2 p, float r) {
    return length(p) - r;
}

const vec4 phases = vec4(0.71, 1.21, 1.18, 0.);
const vec4 amp = vec4(-.63, -.63, -.52, 0.);
const vec4 freq = vec4(1.06, 1.31, 1.99, 0.);
const vec4 offsets = vec4(-.36, -.16, 0.01, 0.);

vec3 to_rgb(vec4 grad) {
    vec4 k = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(grad.xxx + k.xyz) * 6.0 - k.www);
    return grad.z * mix(k.xxx, clamp(p - k.xxx, 0.0, 1.0), grad.y);
}

vec3 palette(float x) {
    vec4 phase = phases * TAU;
    x *= TAU;

    vec4 col = vec4(offsets.r + amp.r * 0.5 * cos(x * freq.r + phase.r) + 0.5,
                    offsets.g + amp.g * 0.5 * cos(x * freq.g + phase.g) + 0.5,
                    offsets.b + amp.b * 0.5 * cos(x * freq.b + phase.b) + 0.5,
                    offsets.a + amp.a * 0.5 * cos(x * freq.a + phase.a) + 0.5);
    return to_rgb(clamp(col, 0., 1.));
}


float outline(float x) {
    return abs(x) - 0.008;
}

vec3 tatami(vec2 p, float id, float time) {
    vec3 col = vec3(0.);
    vec2 pp = p + vec2(-0.002, 0.004);
    float room = sd_box(pp, vec2(0.475, 0.49));

    vec2 tatami_size = vec2(0.16, 0.34);
    float tatami = sd_box(pp, vec2(0.18));
    tatami = outline(tatami);
    tatami = min(tatami, outline(sd_box(pp - vec2(0.34, 0.16), tatami_size)));
    tatami = min(tatami, outline(sd_box(pp - vec2(-0.34, -0.16), tatami_size)));
    tatami = max(tatami, room);

    float entrance = sd_box(pp - vec2(0.488, 0.38), vec2(0.008, 0.07));
    vec2 dp = pp - vec2(-0.415, -0.49);
    dp *= rot(abs(sin(time * 5. + id)) * (PI / 2.));
    float door = sd_circle(dp, 0.227);
    door = max(door, -(dp.x));
    door = max(door, -(dp.x + dp.y));
    door = max(door, room);
    
    float toilet = sd_box(pp - vec2(0.4, -0.345), vec2(0.03, 0.07)) - 0.01;
    toilet = min(toilet, sd_circle(pp * vec2(1., 1.3) - vec2(0.3, -0.45), 0.08));

    float cid = abs(sin((id))) * 8.;
    vec3 floor_col = palette(cid);
    floor_col = smoothstep(0.05, 0.8, floor_col);
    vec3 door_col = vec3(1., 0.8, 0.3) * 0.7;

    col = mix(col, floor_col, AAstep(room, 0.));
    col = mix(col, floor_col * .3, AAstep(tatami, 0.));
    col = mix(col, door_col, AAstep(entrance, 0.));
    col = mix(col, door_col, AAstep(door, 0.));
    col = mix(col, vec3(0.), AAstep(outline(door), 0.));
    if (hash11(cid) < .05 && time > 7.) {
        col = mix(col, palette(hash11(cid)), AAstep(toilet, 0.));
        col = mix(col, vec3(0.013), AAstep(outline(toilet), 0.));
    }
    return col;
}

const float phi = (sqrt(5.) + 1.) / 2.;

vec3 golden_zoom(vec2 uv, float time) {
    vec2 pp = vec2(pow(phi - 1., 4.), pow(phi - 1., 3.));

    vec2 zc = vec2(1., pp.y) / (1. - pp.x);

    uv += vec2(cos(time * 1. * TAU), sin(-time * 1. * TAU)) * .1;

    float a = .15 * time * TAU;
    mat2 m = rot(a);

    float scale = pow(pp.x, 1. + fract(time));

    uv = m * uv * scale + zc;

    vec3 color = vec3(0.);

    for (float i = 0.; i < 32.; i++) {
        float j = i + floor(time) * 4.;
        if (uv.x < 1.) {
            color = tatami(uv - 0.5, j, time);
            break;
        }
        uv = (uv - vec2(1., 1.)).yx * vec2(-1., 1.) * phi;
    }

    return color;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    float t = iTime;// + hash21(uv + iTime) * 2e-3;
    t += smooth_floor(t * 0.8, 15.);
    t *= 0.2;
    
    vec3 col = golden_zoom(uv, t);
    
    col = pow(col, vec3(1. / 2.2));

    vec2 in_uv = fragCoord / iResolution.xy;
    col *= pow(10. * in_uv.x * in_uv.y * (1. - in_uv.x) * (1. - in_uv.y), .096);
    
    fragColor = vec4(col, 1.0);
}

void main() {
	vec4 fragColor;
	vec2 fragCoord = gl_FragCoord.xy;
	mainImage(fragColor, fragCoord);
	fragColor.a = 1.0;
	gl_FragColor = fragColor;
}
