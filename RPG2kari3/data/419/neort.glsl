// Ç±ÇøÇÁÇ™ÉIÉäÉWÉiÉãÇ≈Ç∑ÅB
// ÅyçÏé“ÅzKamoshikaÇ≥ÇÒ
// ÅyçÏïiñºÅzReflecting Pseudo Kleinian
// https://neort.io/art/c78qlsk3p9f3hsjeasig

precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

const float pi=acos(-1.);
const float c=.9;
const float sp=1.;
float ac;
float T,b;

void rot3d(inout vec3 v,float a,vec3 ax){
  ax=normalize(ax);
  v=mix(dot(ax,v)*ax,v,cos(a))-sin(a)*cross(ax,v);
}

#define ihash(x) floor(fract(sin(x)*1426.1623)*3.-1.)*c*2.
float in1d(float x){
  x/=c*2.;
  float i=floor(x);
  float s=.2;
  float u=smoothstep(.5-s,.5+s,fract(x));
  return mix(ihash(i),ihash(i+1.),u);
}

float map(vec3 p){
  float d1,d2,a=1.;
  vec3 p0=p;
  p=abs(mod(p,c*2.)-c);
  
  for(int i=0;i<3;i++){
    p=2.*clamp(p,-c,c)-p;
    float k=max(1./dot(p,p),1.);
    p*=k;
    a*=k;
  }
  d1=(p.x+p.y+p.z-1.54)/a*.5;
  d2=p.y/a*.5;
  float s=smoothstep(-2.,2.,b-p0.z);
  float Tm=mod(T+.5,4.);
  if(Tm<1.){
    d1=mix(d1,d2,s);
    ac+=mix(a,1.,s);
  }else if(Tm<2.){
    d1=d2;
    ac+=1.;
  }else if(Tm<3.){
    d1=mix(d2,d1,s);
    ac+=mix(1.,a,s);
  }else{
    ac+=a;
  }
  
  return d1;
}

vec3 calcN(vec3 p){
  vec2 e=vec2(.001,0);
  return normalize(vec3(map(p+e.xyy)-map(p-e.xyy),
  map(p+e.yxy)-map(p-e.yxy),
  map(p+e.yyx)-map(p-e.yyx)));
}

float fs(float f0,float c){
  return f0+(1.-f0)*pow(1.-c,5.);
}

vec3 hsv(float h,float s,float v){
  vec3 res=fract(h+vec3(0,2,1)/3.)*6.-3.;
  res=clamp(abs(res)-1.,0.,1.);
  res=(res-1.)*s+1.;
  res*=v;
  return res;
}

vec3 getC(vec3 rp){
  float i=floor(T+.5);
  vec3 c1=hsv(pi*.5*i,.8,1.);
  vec3 c2=hsv(pi*.5*(i+1.),.8,1.);
  float v=smoothstep(-.3,.3,b-rp.z);
  return mix(c1,c2,v);
}

vec3 march(inout vec3 rp,inout vec3 rd,inout vec3 ra,vec3 cp){
  vec3 col=vec3(0);
  float d,t=0.;
  ac=0.;
  for(int i=0;i<100;i++){
    d=map(rp);
    if(abs(d)<.0001||t>20.)break;
    t+=d;
    rp+=rd*d;
  }
  
  vec3 n=calcN(rp);
  vec3 ref=reflect(rd,n);
  float fog=exp(-t*t*.01);
  vec3 al=getC(rp);
  float lp=.1/abs(b-rp.z);
  
  col+=al*lp+ac*.0005;
  col=mix(vec3(1),col,fog);
  
  col*=ra;
  ra*=al*fs(.8,dot(ref,n))*fog;
  
  rp+=.001*n;
  rd=ref;
  
  return col;
}

void main(void){
  vec2 uv = vec2(gl_FragCoord.x / resolution.x, gl_FragCoord.y / resolution.y);
  uv -= 0.5;
  uv /= vec2(resolution.y / resolution.x, 1)*.5;
  vec3 col=vec3(0);
  
  T=time*sp/c*.5;
  
  vec3 cp=vec3(0,0,-time*sp);
  cp.x+=in1d(cp.z*.5-c);
  float Tm=mod(T+.5,4.);
  cp.y+=in1d(cp.z*.5-c*400.);
  
  b=cp.z+tan(T*pi);
  
  vec3 rd=normalize(vec3(uv,-1));
  
  rot3d(rd,time*.5,vec3(1,2,9));
  rot3d(rd,pi/4.,vec3(0,1,0));
  
  vec3 rp=cp;
  vec3 ra=vec3(1);
  col+=march(rp,rd,ra,cp);
  col+=march(rp,rd,ra,cp);
  col+=march(rp,rd,ra,cp);
  
  gl_FragColor = vec4(col,1);
}