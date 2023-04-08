// コングラチュレーション画面
//
// オリジナルはこちらです。
// 【作者】panna_pudiさん
// 【作品名】Power (Chainsaw Man)
// https://www.shadertoy.com/view/cljGR3
// ※ただし、持ってきたソースはこちら（GLSL SANDBOX）です
// https://glslsandbox.com/e#102455.0
//

class GameSceneCongratulations526 extends GameSceneCongratulationsBase {
  PShader s;
  int startMillis;

  @Override void setup() {
    noStroke();
    s = loadShader("data/526/glslSandbox.glsl");
    s.set("resolution", width, height);
    // 最初のミリ秒を取り込んでおく
    startMillis = millis();
  }
  @Override void draw() {
    push();
    s.set("backbuffer", getGraphics());
    s.set("time", (millis() - startMillis) / 1000.0f);
    s.set("mouse", (float)mouseX / (float)width, (float)mouseY / (float)height);
    shader(s);
    rect(0, 0, width, height);
    resetShader();
    pop();

    logoRightLower(#ff0000);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
