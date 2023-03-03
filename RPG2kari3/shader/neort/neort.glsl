// ‚±‚¿‚ç‚ªƒIƒŠƒWƒiƒ‹‚Å‚·B
// yìŽÒzfotfla‚³‚ñ
// yì•i–¼zJapanese Traditional Textile 2
// https://neort.io/art/blgu3rc3p9fei75evhe0

precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

const float PI = 3.1415926;

float hash(vec2 uv){
    return fract(45316.3261 * sin(dot(uv,vec2(12.456,17.355))));
}

mat2 rot(float a){
    float c = cos(a),s = sin(a);
    return mat2(c,s,-s,c);
}

float rect(vec2 p ,float x1,float y1, float x2,float y2){
    float d = 0.00001;
    return smoothstep(x1,x1 + d,p.x) * smoothstep(x2,x2-d,p.x) * smoothstep(y1,y1 + d,p.y) * smoothstep(y2,y2 -d,p.y);
}

// "Sayagata" by "AMAGI" https://neort.io/art/bimnhbk3p9f9psc9oc20 #NEORT
vec3 sayagata(vec2 uv){
    uv.y *= 2.0;
    uv *= 4.0;
    uv = rot(PI * 0.25) * uv;
    
    vec2 f = fract(uv);
    
    f.x = mod(uv.x,2.0) > 1.0 ? 1.0 - f.x : f.x;
    f.y = mod(uv.y,2.0) > 1.0 ? 1.0 - f.y : f.y;
    
    float i = 0.0;
    
    for(int x =0; x < 4;x++){
      i += clamp(rect(f,0.15,-0.1,0.25,0.65) + rect(f,0.2,0.35,0.45,0.45) + rect(f,0.2,-.1,1.1,0.05),0.0,1.0);
      f = rot(PI / 2.0) * (f - 0.5) + 0.5;
    }
    return vec3(i);
}

float petal(vec2 uv, float s){
    float a = atan(uv.y,uv.x);
    float r = length(uv);
    float d = min(abs(cos(a * 2.5)) + 0.5 + s,abs(sin(a * 2.5)) + 1.2 + s) * (0.32);
    return step(r,d);
}

float center(vec2 uv){
    float a = atan(uv.y,uv.x);
    float r = length(uv);
    float d = pow(cos(a * 2.5) * cos(a * 2.5),5.) * 0.15 + 0.1;//min(abs(cos(a * 2.5)),pow(cos(a * 5.0),5.) * 0.5) * 0.1 + 0.1;
    return step(r,d);
}

vec3 flower(vec2 uv){
    vec2 iuv = floor(uv);
    float rnd = hash(iuv);
    float ry = hash(vec2(iuv.y));
    // uv.x -=time;
    uv.x += ry * 3.0 - time * (ry + 0.3) * 0.5;
    iuv = floor(uv);
    rnd = hash(iuv);
    vec2 fuv = fract(uv);
    fuv -=0.5;
    fuv = rot(rnd * PI + time * 0.4) * fuv;
    fuv *= rnd + 0.1;
    float m = rnd > 0.9 ? petal(fuv, .0) : 0.0;
    float m2 = rnd > 0.9 ? petal(fuv, .1) : 0.0;
    float m3 = rnd > 0.9 ? center(fuv) : 0.0;
    return vec3(m,m2,m3);
}

vec3 sakuraColor(vec2 p){
    vec3 fc = vec3(197.,169.,196.)/255.;
    vec2 p1 = rot(PI / 8.) * p;
    p1 *= 2.;
    vec3 m = flower(p1);
    float me = m.y * (1. - m.x);
    vec2 p2 = rot(PI / 8.0 + 0.1) *p;
    p2*= 3.0;
    vec3 m1 = flower(p2);
    float me2 = m1.y*(1.0 - m1.x); 
    float saya = sayagata(p).x;
    vec3 bgColor = mix(vec3(105.,176.,118)/255.,vec3(2.,135.,96)/255., saya);
    vec3 sakura_b = fc * m1.x + (1.0 - m1.y) * bgColor + fc * 1.1 * me2 + vec3(m1.z);
    vec3 sakura_f = fc * m.x + fc * 1.1 * me + vec3(m.z);
    vec3 sakura = sakura_b *( 1. -m.y) +  sakura_f;
    return sakura;
}

void main(){
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / resolution.y;
    vec3 c = sakuraColor(p);
    gl_FragColor = vec4(c, 1.0);
}