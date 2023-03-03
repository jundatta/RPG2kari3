// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】さん
// 【作品名】
// https://
//

class GameSceneCongratulationsTemplate extends GameSceneCongratulationsBase {
  @Override void setup() {
  }
  @Override void draw() {
    push();
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
