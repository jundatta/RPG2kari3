// こちらがオリジナルです。
// 【作者】Kamoshikaさん
// 【作品名】午前0:19 2022年4月20日のツイート
// https://twitter.com/kamoshika_vrc/status/1516436446579609601
//
// ※つぶやきGLSLの詳細はこちら
// 「GLSL最短チャレンジ #つぶやきGLSL」
// https://zenn.dev/yuji_ap/articles/7f7f0cfd589bad

PShader s;
int startMillis;

void setup() {
  size(787, 442, P3D);
  //size(500, 800, P3D);
  noStroke();
  s = loadShader("twigl.glsl");
  s.set("resolution", width, height);
  // 最初のミリ秒を取り込んでおく
  startMillis = millis();
}

void draw() {
  s.set("backbuffer", getGraphics());
  s.set("time", (millis() - startMillis) / 1000.0f);
  s.set("mouse", (float)mouseX / (float)width, (float)mouseY / (float)height);
  shader(s);
  rect(0, 0, width, height);
  resetShader();
}
