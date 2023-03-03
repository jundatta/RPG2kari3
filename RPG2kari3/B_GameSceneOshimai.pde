class GameSceneOshimai extends GameScene {
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
    fill(300, 100, 100);
    textSize(80);
    text("おしまい♪", 35, (height / 5) * 4);
    text("＼(^_^)／", 45, (height / 5) * 4.5);
  }
  @Override void mousePressed() {
  }
  @Override void keyPressed() {
  }
}
