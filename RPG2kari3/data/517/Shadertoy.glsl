// Ç±ÇøÇÁÇ™ÉIÉäÉWÉiÉãÇ≈Ç∑ÅB
// ÅyçÏé“ÅzsrtussÇ≥ÇÒ
// ÅyçÏïiñºÅzRelentless
// https://www.shadertoy.com/view/lss3WS

uniform vec3 iResolution;
uniform vec4 iMouse;
uniform float iTime;
uniform int iFrame;
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;

// srtuss, 2016

vec2 solve(float A, float B, float C)
{
    float X0, X1, Q;
    float Discr = B * B - 4.0 * A * C;
    if(Discr < 0.0)
    {
        return vec2(100.0, 100.0);
    }
    else if(Discr == 0.0)
    {X0 = X1 = -0.5 * B / A;}
    else
    {
        Q = (B > 0.0) ? -0.5 * (B + sqrt(Discr)) : -0.5 * (B - sqrt(Discr));
        X0 = Q / A;
        X1 = C / Q;
    }
    if(X0 > X1)
    {
        float H = X1;
        X1 = X0;
        X0 = H;
    }
    return vec2(X0, X1);
}
/*float hsh(vec2 p)
{
    float V = fract(p.x * 2467.0 + p.x * 4789.0 - p.x * p.y * 3761.0);
    return V;
}*/
float hsh(vec2 p)
{
    return fract(sin(p.x * 234.28972) + cos(p.y * 298.879812) * 279872.18979);
}

struct HIT
{
    float t0;
    vec3 nml;
    vec3 pos;
    float oid;
};

vec3 gsph1 = vec3(0., -0.5, 0.);
#define gsph2 vec3(1., sin(iTime) * 0.2 - 1.0, 0.)
vec3 gsph3 = vec3(1.5, -0.5, -1.4);

HIT scene(vec3 RO, vec3 RD)
{
    float WOID = -1.0;
    vec3 WHit, WNml;
    float Radius = 0.5;
    vec3 Center = gsph1;
    vec3 WL = RO - Center; float A = dot(RD, RD), B = 2.0 * dot(RD, WL), C = dot(WL, WL) - Radius * Radius;
    float WT0 = 100.0, WT1;
    WT1 = solve(A, B, C).x;
    if(WT1 > 0.0)
    {
        WT0 = WT1;
        WHit = WT1 * RD + RO;
        WNml = WHit - Center;
        WOID = 0.0;
    }

    vec3 PN = normalize(vec3(0.0, -0.7, 0.0));
    WT1 = (0.0 - dot(PN, RO)) / dot(PN, RD);
    if(WT1 > 0.0 && WT1 < WT0)
    {
        WT0 = WT1;
        WNml = PN;
        WOID = 1.0;
    }

    PN = normalize(vec3(0.0, 0.0, -1.0));
    WT1 = (-1.501 - dot(PN, RO)) / dot(PN, RD);
    if(WT1 > 0.0 && WT1 < WT0)
    {
        WT0 = WT1;
        WNml = PN;
        WOID = 4.0;
    }

    Radius = 0.2;
    Center = gsph2;
    WL = RO - Center; A = dot(RD, RD); B = 2.0 * dot(RD, WL); C = dot(WL, WL) - Radius * Radius;
    WT1 = solve(A, B, C).x;
    if(WT1 > 0.0 && WT1 < WT0)
    {
        WT0 = WT1;
        WHit = WT0 * RD + RO;
        WNml = WHit - Center;
        WOID = 2.0;
    }

    Radius = 0.6;
    Center = gsph3;
    WL = RO - Center; A = dot(RD, RD); B = 2.0 * dot(RD, WL); C = dot(WL, WL) - Radius * Radius;
    WT1 = solve(A, B, C).x;
    if(WT1 > 0.0 && WT1 < WT0)
    {
        WT0 = WT1;
        WHit = WT0 * RD + RO;
        WNml = WHit - Center;
        WOID = 3.0;
        
        //WNml += (fract(sin(WHit.x * 10.0 + WHit.y * 33.0 - WHit.z * 100.0) * 187252.521) - 0.5) * vec3(0.05);
    }

    HIT ret;
    ret.nml = WNml;
    ret.pos = RO + RD * WT0;
    ret.t0 = WT0;
    ret.oid = WOID;
    return ret;
}

float nse(vec2 p)
{
	return hsh(floor(p) * 1.01);
}

float map1(vec2 p, vec2 id)
{
    if(nse(id * 1012.1986982) > 0.5)
    {
        p = p.yx;
    }
    float v = length(vec2(p.x, max(abs(p.y) - 0.8, 0.0))) - 0.04;
    return v;
}

float map2(vec2 p, float ts, float g)
{
    p *= ts;
    //p += iTime;
    float stress = length(fwidth(p));
    
    float s = 1.0;
    vec2 id = floor(p / s), id3 = id;
    vec2 q = mod(p, s) - s * 0.5;
    float v = 1e38;
    
    if(hsh(id * 0.4) > 0.5)
	    v = length(max(abs(q) - 0.3, 0.0)) - 0.15;
    
    if(hsh(id * 0.7) > 0.5)
	    v = min(v, length(max(abs(q) - 0.1, 0.0)) - 0.1);
    
    s = 2.0;
    p += s * 0.25;
    id = floor(p / s);
    q = mod(p, s) - s * 0.5;
    vec2 q2 = mod(p + s * 0.5, s) - s * 0.5;
    vec2 id2 = floor(p / s + 0.5);
    //v = 1e38;
    
    float w = map1(q, id);
    w = min(w, map1(q2, id2));
    
    if(nse(id3) < 0.5)
	    v = min(w, max(v, -(w - 0.06)));
    else
        v = min(w, v);
    
    if(g > 0.5)
        v = abs(v);
    
    return smoothstep(0.0, stress / ts, v / ts);
}

float map0(vec2 p)
{
    return mix(0.6, map2(p, 0.5, 0.0) * 0.15 + 0.85, mix(map2(p, 2.0, 0.0), map2(p, 2.0, 1.0), map2(p * 0.4, 2.0, 0.0)));
}

vec3 obj0(vec3 hit, vec3 nml, vec3 o)
{
    float v = dot(hit - o, normalize(vec3(1.2, 1.0, 0.5)));
    v = abs(v) - 0.01;
    return smoothstep(0.0, 0.02, v) * vec3(1.0);
}

vec3 mtl(vec3 hit, vec3 nml, float oid)
{
    //Surf = vec(sinr(Hit:x() * 20), sinr(Hit:y() * 20), sinr(Hit:z() * 20)) * 0.1 + 0.7
    //Surf = array(vec(1.0, 0.5, 0.5), vec(0.4, 0.8, 0.5), vec(0.5, 0.5, 1.0), vec(1.0, 1.0, 0.5), vec(0.9))[OID + 1, vector]
    vec3 surf = vec3(0.0, 0.0, 0.0);
    surf = mix(surf, vec3(1) * obj0(hit, nml, gsph1), step(abs(oid - 0.0), 0.1));
    surf = mix(surf, vec3(0.8) * map0(hit.xz), step(abs(oid - 1.0), 0.1));
    surf = mix(surf, vec3(1) * obj0(hit, nml, gsph2), step(abs(oid - 2.0), 0.1));
    surf = mix(surf, vec3(1) * obj0(hit, nml, gsph3), step(abs(oid - 3.0), 0.1));
    surf = mix(surf, vec3(1), step(abs(oid - 4.0), 0.1));
    //surf *= (nse(hit.xz) * 0.3 + nse(hit.xz * 0.2) * 0.3 + 0.2);
    //Surf *= exp(Hit:distance(VEye) * -0.3) * 2.0
    float D = 2.;
    surf *= 1.0 - exp(max(0., distance(hit, vec3(1.5, 0.0, -1.4)) - 0.4) * -6.9) * 0.6;
    surf *= 1.0 - exp(max(0., distance(hit, vec3(0.)) - 0.2) * -3.9) * 0.6;
    return surf;
}

vec2 rotate(vec2 p, float a)
{
	return vec2(p.x * cos(a) - p.y * sin(a), p.x * sin(a) + p.y * cos(a));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    uv = uv * 2.0 - 1.0;
    uv.y *= iResolution.y / iResolution.x;
    uv.y *= -1.0;
    vec3 ro = vec3(0.4, -2., -3.5);
    vec3 rd = normalize(vec3(uv, 1.66));
    
    float ct = iTime * 0.1;
    ro.x += cos(ct);
    ro.y += sin(ct);
    
    rd.xy = rotate(rd.xy, 0.1);
    rd.xz = rotate(rd.xz, -0.1 + cos(ct) * 0.2);
    rd.yz = rotate(rd.yz, -0.5 + sin(ct) * 0.2);
    
    
    vec3 sun = normalize(vec3(-0.3, -1.0, -0.5));
    
    HIT h = scene(ro, rd);
    h.nml = normalize(h.nml);
    vec3 ref = reflect(rd, h.nml);
    vec3 col = max(0.0, dot(h.nml, sun) + 0.2) * mtl(h.pos, h.nml, h.oid);
    col += pow(max(0.0, dot(ref, sun)), 16.0);
    col *= step(40.0, scene(h.pos + sun * 0.001, sun).t0) * 0.5 + 0.5;
    col *= exp(h.t0 * -0.1);
    
    vec3 rdo = rd, roo = ro;
    
    rd = ref;
    ro = h.pos + rd * 0.0001;
    HIT hr = scene(ro, rd);
    vec3 colr = vec3(0.0);
    if(hr.t0 < 40.0)
    {
        hr.nml = normalize(hr.nml);
        ref = reflect(rd, hr.nml);
        colr = max(0.0, dot(hr.nml, sun) + 0.2) * mtl(hr.pos, hr.nml, hr.oid);
        colr += pow(max(0.0, dot(ref, sun)), 16.0);
        colr *= step(40.0, scene(hr.pos + sun * 0.001, sun).t0) * 0.5 + 0.5;
        colr *= exp((h.t0 + hr.t0) * -0.1);
    }
    
    /*vec3 pn = normalize(vec3(0.0, 1.0, 0.0));
    for(int i = 0; i < 5; ++i)
    {
        float t0 = (-0.6 - dot(roo, pn)) / dot(rdo, pn);
        vec3 hit = roo + rdo * t0;

        col += -map2(hit.xz, 5.0, 1.0) * 0.2;
    }
    col = max(col, vec3(0.));*/
    col = col * 0.9 + colr * 0.3;
    col = pow(col, vec3(3.2) * vec3(1.0, 0.8, 0.5)) * 2.0;
    col = pow(col, vec3(1.0 / 2.2));
	fragColor = vec4(col, 1.0);
}

void main() {
	vec4 fragColor;
	vec2 fragCoord = gl_FragCoord.xy;
	mainImage(fragColor, fragCoord);
	fragColor.a = 1.0;
	gl_FragColor = fragColor;
}
