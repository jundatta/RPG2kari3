let Shader;
let HE2vH;

function preload() {
  HE2vH = loadImage("data/HE2vH.png");
}

function setup() {
  let renderer = createCanvas(1112, 834, WEBGL);

  projector = new p5.Camera(renderer);
  projector.camera(0, 0, (height/4.0) / tan(PI*30.0 / 180.0), 0, 0, 0, 0, 1, 0);
  projector.perspective(PI*2/3, 1.0, 0.1, 100);

  Shader = createShader(vsGlsl, fsGlsl);
  shader(Shader);
  
  console.log(projector.projMatrix.mat4);
  
  Shader.setUniform("txr_font", HE2vH);
  Shader.setUniform("fxs", width/150.0);
  Shader.setUniform("fys", height/50.0);
  noStroke();
}

function draw() {
  rect(-width/2, -height/2, width, height);
}

let vsGlsl = `
  precision highp float;

attribute vec3 aPosition;
uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;
//---------------------------------------------------------------------------
// Vertex
//---------------------------------------------------------------------------
varying vec2 pos;   // screen position <-1,+1>
void main()
{
  gl_Position= uProjectionMatrix * uModelViewMatrix * vec4(aPosition, 1.0);
  pos=gl_Position.xy;
}
//---------------------------------------------------------------------------
`;

let fsGlsl = `
  precision highp float;

uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;
uniform mat4 uViewMatrix;

//---------------------------------------------------------------------------
// Fragment
//---------------------------------------------------------------------------
varying vec2 pos;                   // screen position <-1,+1>
uniform sampler2D txr_font;     // ASCII 32x8 characters font texture unit
uniform float fxs, fys;          // font/screen resolution ratio
//---------------------------------------------------------------------------
const int _txtsiz=8;           // text buffer size
int txt[_txtsiz], txtsiz;        // text buffer and its actual size
vec4 col;                       // color interface for txt_print()
//---------------------------------------------------------------------------
void txt_decimal(float x)       // print float x into txt
{
  int c;          // l is size of string
  float y, a;
  const float base=10.0;

  // handle sign
  if (x<0.0) {
    txt[0]=0x2d;
    txtsiz++;
    x=-x;
  } else {
    txt[0]=0x2b;
    txtsiz++;
  }
  // divide to int(x).fract(y) parts of number
  y=x;
  x=floor(x);
  y-=x;
  // handle integer part
  float backupX = x;
  int len = 0;
  for (int ix = 0; ix < _txtsiz; ix++)
  {
    a=x;
    x=floor(x/base);
    a-=base*x;
    len++;
    if (x<=0.0) {
      break;
    }
  }
  x = backupX;
  int min = txtsiz;
  int max = (txtsiz + len) - 1;
  for (int ix = _txtsiz - 1; ix >= 0; ix--)
  {
    if (ix < min || max < ix) {
      continue;
    }
    a=x;
    x=floor(x/base);
    a-=base*x;
    txt[ix]=int(a)+0x30;
    txtsiz++;
  }
  // handle fractional part
  int ixPoint = txtsiz;
  min = ixPoint + 1;
  max = (min + 3) - 1;
  for (int ix = 0; ix < _txtsiz; ix++)
  {
    if (ix == ixPoint) {
      txt[ix]=0x2e;
      txtsiz++;
      continue;
    }
    if (ix < min || max < ix) {
      continue;
    }
    y*=base;
    a=floor(y);
    y-=a;
    txt[ix]=int(a)+0x30;
    txtsiz++;
    if (y<=0.0) break;
  }
}
//---------------------------------------------------------------------------
void txt_print(float x0, float y0)   // print txt at x0,y0 [chars]
  {
  int i;
float x, y;
// fragment position [chars] relative to x0,y0
x=0.5*(1.0+pos.x)/fxs;
x-=x0;
y=0.5*(1.0-pos.y)/fys;
y-=y0;
// inside bbox?
if ((x<0.0)||(x>float(txtsiz))||(y<0.0)||(y>1.0)) return;
// get font texture position for target ASCII
i=int(x);               // char index in txt
x-=float(i);
for (int ix = 0; ix < _txtsiz; ix++) {
  if (ix == i) {
    i=txt[ix];
    break;
  }
}
x+=float(int(i-((i/32)*32)));
y+=float(int(i/32));
x/=32.0;
y/=8.0;    // offset in char texture
col=texture2D(txr_font, vec2(x, y));
}
//---------------------------------------------------------------------------

void show(float x, float y, float value) {
  txtsiz=0;
  txt_decimal(value);
  txt_print(x, y);
}
void show(float x, float y, vec4 v) {
  const float TAB = 12.0;
  show(x + TAB * 0.0, y, v.x);
  show(x + TAB * 1.0, y, v.y);
  show(x + TAB * 2.0, y, v.z);
  show(x + TAB * 3.0, y, v.w);
}
void show(float x, float y, mat4 m) {
  show(x, y + 0.0, m[0]);
  show(x, y + 1.0, m[1]);
  show(x, y + 2.0, m[2]);
  show(x, y + 3.0, m[3]);
}

void main()
{
  col=vec4(0.0, 0.0, 1.0, 1.0);  // background color

  show(-20.0, -20.0, uViewMatrix);
  show(-20.0, -10.0, uModelViewMatrix);
  show(-20.0, 0.0, uProjectionMatrix);
  mat4 m = uProjectionMatrix * uModelViewMatrix;
  show(-20.0, +10.0, m);

  gl_FragColor=col;
}
//---------------------------------------------------------------------------
`;
