// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】matheusfs2さん
// 【作品名】cup of wine
// https://www.shadertoy.com/view/mltSz8
//

class GameSceneCongratulations547 extends GameSceneCongratulationsBase {
  PShader sd;
  int startMillis;
  int startCount;

  @Override void setup() {
    noStroke();
    textureWrap(REPEAT);

    sd = loadShader("data/547/Shadertoy.glsl");
    sd.set("iResolution", (float)width, (float)height, 0.0f);

    // 最初のミリ秒を取り込んでおく
    startMillis = millis();
    startCount = frameCount;
  }
  @Override void draw() {
    push();
    sd.set("iTime", (millis() - startMillis) / 1000.0f);
    sd.set("iMouse", (float)mouseX, (float)mouseY, 0.0f, 0.0f);
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
