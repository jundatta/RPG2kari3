// コングラチュレーション画面
//
// オリジナルはこちらです。
// 【作者】Richard Bourneさん
// 【作品名】Pretty Pottery 2
// https://openprocessing.org/sketch/1860477
//

class GameSceneCongratulations508 extends GameSceneCongratulationsBase {
  PVector[][] globe;
  float r = 200;
  int total = 20;
  float lapse = 0;    // timer

  @Override void setup() {
    colorMode(HSB);
    noStroke();
    globe = new PVector[total + 1][total + 1];
  }
  @Override void draw() {
    push();
    background(0);
    translate(width / 2, height / 2.4, 280);
    rotateX(86);
    rotateZ(frameCount/100 + radians(mouseX/2));
    rotateX(-radians(mouseY/2));

    for (int i = 0; i < total + 1; i++) {
      float lat = map(i, 0, total, -HALF_PI, HALF_PI);

      for (int j = 0; j < total+ 1; j++) {
        float lon = map(j, 0, total, -PI/2, PI/2);

        float x = r * sin(lon) * cos(lat);
        float y = r * sin(lon) * sin(lat);
        float z = r * cos(lon);

        globe[i][j] = new PVector(x, y, z);
      }
    }

    for (int i = 0; i < total; i++) {
      beginShape(TRIANGLE_STRIP);
      for (int j = 0; j < total + 1; j++) {
        PVector v1 = globe[i][j];
        PVector v2 = globe[i + 1][j];

        //
        float hu = map(j, 0, total, 0, 255 * 6);
        fill(hu % 255, 255, 255);

        vertex(v1.x, v1.y, v1.z);
        vertex(v2.x, v2.y, v2.z);
      }
      endShape();
    }
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
