// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Richard Bourneさん
// 【作品名】3D Clock
// https://openprocessing.org/sketch/1226951
//

class GameSceneCongratulations534 extends GameSceneCongratulationsBase {
  PFont myFont;

  PShape cylinder;
  PShape torus;

  PGraphics pg;
  final int orgW = 1112;
  final int orgH = 834;

  void preload() {
    myFont = createFont("data/534/TitilliumWeb-Bold.ttf", 50, true);
  }

  @Override void setup() {
    preload();

    pg = createGraphics(orgW, orgH, P3D);
    pg.beginDraw();
    pg.colorMode(HSB, 360, 100, 100, 100);
    pg.textFont(myFont);
    pg.textSize(80);
    pg.textAlign(CENTER, CENTER);
    pg.beginDraw();

    colorMode(HSB, 360, 100, 100, 100);

    //cylinder(height/2.3, 20);
    cylinder = createCan(orgH/2.3, 20, 24, true, true);
    cylinder.setStroke(false);
    cylinder.setFill(color(160, 100, 100));
    //torus(height/2.2, 15);
    torus = createTorus(orgH/2.2, 15);
    torus.setStroke(false);
    torus.setFill(color(20, 20, 20));
  }
  @Override void draw() {
    push();
    pg.beginDraw();
    pg.translate(orgW * 0.5f, orgH * 0.5f);

    //  orbitControl();
    pg.background(0.0, 0.0, 90.0);
    pg.push();
    pg.lights();
    pg.ambientLight(80, 80, 80);
    pg.noStroke();
    pg.fill(255);
    pg.rotateX(PI/2.0f);
    pg.translate(0, -20, 0);
    //  ambientMaterial(80);
    pg.ambient(80);
    //cylinder(height/2.3, 20);
    pg.shape(cylinder);
    pg.pop();
    pg.push();
    pg.fill(20);
    pg.translate(0, 0, -20);
    //torus(height/2.2, 15);
    pg.shape(torus);
    pg.pop();
    pg.noLights();
    pg.fill(0.0, 0.0, 20.0, 100.0);
    pg.noStroke();
    pg.ellipse(0.0, 0.0, 40.0, 40.0);
    final float dialRadius = orgW * 0.27;
    for (float dial = 0; dial < 12; dial++) {
      float dialRadian = TWO_PI * dial / 12.0 - PI / 3.0;
      pg.text((int)dial + 1, dialRadius * cos(dialRadian), dialRadius * sin(dialRadian) - 15.0);
    }

    // draw clock hands
    int h = hour() % 12;
    int m = minute();
    int s = second();

    pg.fill(0.0, 0.0, 20.0, 100.0);
    drawHand(pg, h / 12.0 + m / (60.0 * 12.0), 0.22, 1.0);
    drawHand(pg, m / 60.0, 0.26, 0.7);

    pg.fill(0.0, 70.0, 70.0, 100.0);
    drawHand(pg, s / 60.0, 0.3, 0.4);
    pg.endDraw();
    image(pg, 0, 0, width, height);
    pop();

    logoRightLower(#ff0000);
  }

  void drawHand(PGraphics pg, float _rotation, float _length, float _width) {
    pg.push();  //translate(0,0,2);
    pg.rotate(TWO_PI * _rotation);
    pg.beginShape();
    pg.translate(0, 0, -5);

    pg.vertex(-20.0 * _width, 0.0, 0.0);
    pg.translate(0, 0, 2);

    pg.vertex(20.0 * _width, 0.0, 0.0);
    pg.translate(0, 0, 2);

    pg.vertex(0.0, -width * _length, 0.0);
    pg.endShape(CLOSE);
    pg.pop();
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
