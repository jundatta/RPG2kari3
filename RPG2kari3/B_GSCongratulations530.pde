// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】panna_pudiさん
// 【作品名】Desert Bloom
// https://www.shadertoy.com/view/7ld3DX
//

class GameSceneCongratulations530 extends GameSceneCongratulationsBase {
  PShader sd;
  int startMillis;
  int startCount;

  @Override void setup() {
    noStroke();
    textureWrap(REPEAT);

    sd = loadShader("data/530/Shadertoy.glsl");
    sd.set("iResolution", (float)width, (float)height, 0.0f);

    startMillis = millis();
    startCount = frameCount;
  }
  @Override void draw() {
    push();
    sd.set("iTime", (millis() - startMillis) / 1000.0f);
    shader(sd);
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
