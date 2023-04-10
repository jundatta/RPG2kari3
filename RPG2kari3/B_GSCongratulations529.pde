// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】panna_pudiさん
// 【作品名】Torus Knotus Rotatus
// https://www.shadertoy.com/view/7ttBDj
//

class GameSceneCongratulations529 extends GameSceneCongratulationsBase {
  PShader bfA;
  PShader sd;
  int startMillis;
  int startCount;

  @Override void setup() {
    noStroke();
    textureWrap(REPEAT);

    bfA = loadShader("data/529/BufferA.glsl");
    bfA.set("iResolution", (float)width, (float)height, 0.0f);

    sd = loadShader("data/529/Shadertoy.glsl");
    sd.set("iResolution", (float)width, (float)height, 0.0f);

    startMillis = millis();
    startCount = frameCount;
  }
  @Override void draw() {
    push();
    bfA.set("iTime", (millis() - startMillis) / 1000.0f);
    bfA.set("iChannel0", getGraphics());
    shader(bfA);
    rect(0, 0, width, height);
    resetShader();

    // よくわかりゃん＼(^_^)／がまぁいいか♪
    // ⇒やっぱよくわかってにゃい＼(^_^)／

    // 　⇒「かんせーい♪」（でいいのか？！）

    //sd.set("iChannel0", getGraphics());
    //shader(sd);
    //rect(0, 0, width, height);
    //resetShader();
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
