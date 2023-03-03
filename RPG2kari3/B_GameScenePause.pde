class GameScenePause extends GameScene {
  @Override void draw() {
    colorMode(HSB, 360, 100, 100);
    imageMode(CENTER);
    
    // 背景消去
    clearBackground(5);

    fill(0, 100, 100);
    textSize(50);
    text("休憩するにゃー♪", 10, (height / 5) * 3);
  }
  @Override void mousePressed() {
    gGameStack.pop();
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.pop();
  }
}
