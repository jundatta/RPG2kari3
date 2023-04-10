// ‚±‚¿‚ç‚ªƒIƒŠƒWƒiƒ‹‚Å‚·B
// yìŽÒzpanna_pudi‚³‚ñ
// yì•i–¼zTorus Knotus Rotatus
// https://www.shadertoy.com/view/7ttBDj

uniform vec3 iResolution;
uniform vec4 iMouse;
uniform float iTime;
uniform int iFrame;
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;

const float PI = acos(-1.);
const float TAU = PI * 2.;

#define AAstep(x0, x) clamp(((x) - (x0)) / (2. * 2. / iResolution.y), 0., 1.)

float hash31(vec3 p) {
    float n = sin(dot(p, vec3(7, 157, 113)));
    return fract(262144. * n);
}
float hash21(vec2 p){
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

mat2 rot(float a){
    float c = cos(a), s = sin(a);
    return mat2(c, -s, s, c);
}
float trig(vec2 p, float tF, float s) {
    return max(abs(p.x) * .866025 + tF * p.y * .5, -tF * p.y) - s;
}

float box(float a, float s) {
    return abs(a) - s;
}

struct Res {
    vec3 col;
    float contour;
    float depth;
};

Res truschet(vec2 p, bool var) {
    vec2 ip = floor(p);
    float rng = hash21(ip);
    p = fract(p) - 0.5;
    float dir = mod(ip.x + ip.y, 2.) > 0.5 ? 1. : -1.;

    p.y *= rng < 0.5 ? -1. : 1.;
    p *= p.x > -p.y ? 1. : -1.;

    const float th = 0.3;
    vec2 cp = p - 0.5;
    float d = length(cp);
    d = abs(d - 0.5) - th / 2.;

    float border = max(d - 0.010, -d);
    border = AAstep(0.015, border);

    float angle = atan(cp.y, cp.x);
    cp *= rot(-iTime * dir);

    const float aNum = 6.;
    float a = atan(cp.y, cp.x);
    float ia = floor(a / TAU * aNum) + .5;

    cp *= rot(-ia * TAU / aNum);
    cp.x -= 0.5;

    float arrow = box(mod(a - .30 * dir, TAU / aNum) - .5 * TAU / aNum, .35);
    arrow = max(d + .14, -arrow);
    arrow = min(arrow, trig(cp, dir, .025));
    arrow = smoothstep(0., 0.01, arrow);

    float sep = mod(a * dir + d + 0.8, TAU / aNum) - .5 * TAU / aNum;
    sep = abs(abs(sep) - 0.07) - 0.03;
    sep = smoothstep(0., .02, sep);

    d = AAstep(0.01, d);

    vec3 col;
    if (var) {
        col = vec3(1.2);
        col = mix(col, vec3(0.13), (1. - sep));
        col = mix(col, vec3(0.013), 1. - border);
        col = mix(col, vec3(.5, .05, .05), (1. - arrow) * .95);
    } else {
        col = vec3(.1);
        col = mix(col, vec3(1.4), (1. - sep));
        col = mix(col, vec3(0.013), 1. - border);
        col = mix(col, vec3(0.2, 0.4, .9), (1. - arrow));
    }

    float depth = cos(3. * angle * dir) * .5 + .5;
    col *= mix(0.0, 1., depth);

    return Res(col * (1. - d), d, depth * (1. - d));
}

vec3 pattern(vec2 p, vec3 ref_col) {
    vec3 col = vec3(0.);

    vec2 ip = floor(p);
    vec2 q = p - ip - 0.5;
    q.y *= mod(ip.x + ip.y, 2.) > 0.5 ? 1. : -1.;
    col += (abs(fract((q.x + q.y) * 20. + .5) - .5) * 2. - .5) / 20.;
    col += ref_col;
    Res t1 = truschet(p, true);
    Res t2 = truschet(p - 0.5, false);

   if (t1.depth > t2.depth) {
        col = mix(t2.col, t1.col, 1. - t1.contour);
    }
    if (t2.depth > t1.depth) {
        col = mix(t1.col, t2.col, 1. - t2.contour);
    }
    return col;
}

// https://www.shadertoy.com/view/7sKGzR
vec2 polar_smooth_fold(vec2 p, float n, float k) {
    n *= 0.5;
    float a = asin(sin(atan(p.x, p.y) * n) / (k + 1.0)) / n;
    return vec2(sin(a), cos(a)) * length(p);
}

const vec2 TORUS = vec2(1.0, 0.33);
float knot(vec3 p) {
    float time = iTime;

    float f = length(p.xz) - TORUS.x;
    vec2 tube = vec2(f, p.y);
    float xz = atan(p.x, p.z);

    tube *= rot(time * 0.25);

    tube *= rot(xz * 1. / 3.);
    tube = polar_smooth_fold(tube, 3., 0.1);
    tube.y = (tube.y) - 0.48;

    float w = TORUS.y;
    return length(tube) - w;
}

vec4 map(vec3 p) {
    float t = iTime * smoothstep(5., 10., iTime);
    p.xy *= rot(t * 0.1);
    p.zy *= rot(t * 0.2);
    return vec4(knot(p), p);
}

vec2 trace(vec3 ro, vec3 rd, out vec3 q) {
    float t = 0.;
    for (int i = 0; i < 150; i++) {
        vec3 pos = ro + rd * t;
        vec4 res = map(pos);
        float d = res.x; q = res.yzw;
        if (abs(d) < 0.0001) { return vec2(t, 1.); }
        t += d;
        if (t > 10.) { break; };
    }
    return vec2(t, -1.);
}

vec3 get_norm(vec3 p) {
    mat3 k = mat3(p,p,p) - mat3(0.001);
    return normalize(map(p).x - vec3(map(k[0]).x, map(k[1]).x, map(k[2]).x));
}

mat3 get_cam(vec3 eye, vec3 target) {
    vec3 zaxis = normalize(target - eye);
    vec3 xaxis = normalize(cross(zaxis, vec3(0, 1., 0.)));
    vec3 yaxis = cross(xaxis, zaxis);
    return mat3(xaxis, yaxis, zaxis);
}

//  https://iquilezles.org/articles/rmshadows/
float soft_shadow(vec3 ro, vec3 lp, vec3 n, float k) {
    ro += n * .0015;
    vec3 rd = lp - ro;

    float shade = 1.;
    float t = 0.;
    float end = max(length(rd), .0001);
    rd /= end;

    for (int i = 0; i < 24; i++) {
        float d = map(ro + rd * t).x;
        shade = min(shade, k * d / t);
        t += clamp(d, .01, .25);
        if (d < 0. || t > end) break;
    }

    return max(shade, 0.);
}

// https://iquilezles.org/articles/multiresaocc/
float calcAO(in vec3 p, in vec3 n) {
    float sca = 2., occ = 0.;
    for (int i = 0; i < 5; i++) {
        float hr = float(i + 1) * .25 / 5.;
        float d = map(p + n * hr).x;
        occ += (hr - d) * sca;
        sca *= .75;
        if (occ > 1e5) break;
    }

    return clamp(1. - occ, 0., 1.);
}

vec3 sky(vec3 rd) {
    vec3 col = vec3(0.);
    col += mix(0.5 * vec3(0.75, 0.4, 0.4), 0.9 * vec3(0.25, 0.5, 1.0),
               0.5 + 0.5 * normalize(rd).y);
    col += mix(0.9 * vec3(0., 0., 0.), 0.1 * vec3(0., 0., 0.0),
               0.9 + 0.5 * normalize(-rd).y);
    col += smoothstep(-0.4, 0.4,
               dot(rd + vec3(0.0, 0.7, 0.0), normalize(vec3(0.0, -0.2, 0.0)))) *
           vec3(0.1, 0.0, 0.3) * 1.3;
    return col * 0.1 + hash31(rd) * 0.02;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    vec3 ro = vec3(-2.5, 3., 2.5);
    /* ro.xz *= rot(pc.time); */
    mat3 cam = get_cam(ro, vec3(0., 0.15, 0.));
    vec3 rd = cam * normalize(vec3(uv, 1.4));

    vec3 q;
    vec2 res = trace(ro, rd, q);

    vec3 lp = ro + vec3(.25, .75, -1);
    float fblend = 0.;

    vec3 col = sky(rd);
    if (res.y > 0.) {
        vec3 pos = ro + rd * res.x;
        vec3 nor = get_norm(pos);

        vec3 ld = lp - pos;
        float ldist = max(length(ld), .001);
        ld /= ldist;

        float ao = calcAO(pos, nor);
        float sh = soft_shadow(pos, lp, nor, 3.);

        float diff = max(dot(nor, ld), 0.);
        float spec = pow(max(dot(reflect(ld, nor), rd), 0.), 15.);

        vec3 ref = reflect(rd, nor);
        vec3 ref_col = sky(-ref);
        float sp_ref = pow(max(dot(normalize(-rd + ld), nor), 0.), 16.);
        ref_col = sp_ref * ref_col * ref_col * 6.;

        vec3 tex;
        {
            float d = length(q.xz) - TORUS.x;
            float a = atan(q.z, q.x), b = atan(q.y, d);

            float r = TORUS.y / TORUS.x;
            float ir = sqrt(1. - r * r);
            b = 2. / ir * atan((r + 0.3) / ir * tan(b / 2.));
            vec2 uv = vec2(a, b) * vec2(4.00, 4.) / PI;

            tex = pattern(uv, ref_col);
        }

        fblend = 1. - smoothstep(-.2, .2, abs(dot(rd, nor)) - .2);

        col =  0.05 * tex * diff * vec3(1.15, 0.90, 0.55);
        col += tex * (diff * sh + vec3(1, .7, .4) * spec * sh);

        col *=  1. / (1. + ldist * .05);
    }
    
    vec2 in_uv = fragCoord / iResolution.xy;
    col *= pow(100. * in_uv.x * in_uv.y * (1. - in_uv.x) * (1. - in_uv.y), .256);

    // Thanks Shane for a nice trick. Removes a good amount of flickering on edges
    // https://www.shadertoy.com/view/7dyfRc
    vec4 precol = texelFetch(iChannel0, ivec2(fragCoord), 0);
    float blend = (iFrame < 2) ? 1. : 1./(1. + fblend*8.); 
    fragColor = mix(precol, vec4(clamp(col, 0., 1.), 1), blend);
}

void main() {
	vec4 fragColor;
	vec2 fragCoord = gl_FragCoord.xy;
	mainImage(fragColor, fragCoord);
	fragColor.a = 1.0;
	gl_FragColor = fragColor;
}
