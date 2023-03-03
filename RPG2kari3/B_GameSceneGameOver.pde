class GameSceneGameOver extends GameScene {
  @Override void draw() {
    colorMode(HSB, 360, 100, 100);
    imageMode(CENTER);
    
    fill(0, 100, 100);
    textSize(50);
    text("ざんねん～w", 10, (height / 5) * 3);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }

  int mFrame;
  @Override void autoSetup() {
    mFrame = frameCount;
  }
  // true:遷移した
  @Override boolean autoDraw() {
    // デモ状態でなければ何もしない
    if (gbAutoDemo == false) {
      return false;
    }
    // デモ状態なので。。。
    // 3秒間放置されたらコングラチュレーション画面にとべよ～
    if (mFrame + 60 * 3 < frameCount) {
      gCongratulations.jump();
      return true;
    }
    return false;
  }
}
