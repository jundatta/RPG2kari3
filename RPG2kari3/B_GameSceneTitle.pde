class GameSceneTitle extends GameScene {
  int mFrame = frameCount;

  @Override void setup() {
    gbAutoDemo = false;
    surface.setTitle(mainTitle);
  }

  @Override void draw() {
    colorMode(HSB, 360, 100, 100);
    imageMode(CENTER);

    background(0);
    image(gEarth, 0, 0, gEarth.width, gEarth.height);

    // 3秒間放置されたらデモ画面にとべよ～
    if (mFrame + 60 * 3 < frameCount) {
      // デモ状態に遷移する
      gbAutoDemo = true;
      gCongratulations.jump();
      return;
    }

    fill(0, 100, 100);
    textSize(50);
    int titleX = 10;
    int titleY = (height / 5) * 3;
    text(mainTitle, titleX, titleY);
    textSize(16);
    fill(120, 100, 100);
    titleX += 200;
    titleY += 30;
    text("2nd EDITION", titleX, titleY);
    titleX += 40;
    titleY += 20;
    text("Ver2.31", titleX, titleY);

    if (frameCount / 30 % 2 == 0) {
      return;
    }
    fill(0, 100, 100);
    textSize(40);
    text("press any key to start", 10, (height / 5) * 4);
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneScene());
  }
  @Override void keyPressed() {
    // ESCキーが入力されたら終了する
    if (key == ESC) {
      return;
    }
    super.keyPressed();

    gGameStack.change(new GameSceneScene());
  }
}
