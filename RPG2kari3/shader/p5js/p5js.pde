// こちらがオリジナルです。
// 【作者】Richard Bourneさん
// 【作品名】Flat Faces Shader with p5.Graphics
// https://openprocessing.org/sketch/1711940

PShader sh;

void setup() {
  size(500, 800, P3D);
  noStroke();

  // 球の分割数をp5.jsに合わせて30から24に変えとく♪
  // （でもなんか違う...orz）
  sphereDetail(24);

  sh = loadShader("frag.glsl", "vert.glsl");
}

int uprisingSpeed=2;
int utime=0;

void draw() {
  translate(width * 0.5f, height * 0.5f);

  background(0);

  ambientLight(80, 80, 80);
  rotateY((millis() / 1000.0f) * (PI / 4.0f));

  shader(sh);

  sphere(320);

  resetShader();
}
