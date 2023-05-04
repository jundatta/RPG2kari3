// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Richard Bourneさん
// 【作品名】Railstation Clock
// https://openprocessing.org/sketch/1842126
//

class GameSceneCongratulations540 extends GameSceneCongratulationsBase {
  final int windowWidth = 1112;
  final int windowHeight = 834;

  int hu;
  int shorterSide;

  PGraphics pg;

  @Override void setup() {
    pg = createGraphics(windowWidth, windowHeight, P3D);
    pg.beginDraw();
    pg.colorMode(HSB, 360, 100, 100);
    hu = (int)random(360);
    shorterSide = (windowWidth < windowHeight) ? windowWidth : windowHeight;
    pg.endDraw();
  }
  @Override void draw() {
    push();
    pg.beginDraw();
    pg.translate(pg.width * 0.5f, pg.height * 0.5f);

    pg.background(hu, 20, 100);
    pg.stroke(0);
    pg.fill(0);
    pg.strokeWeight(1);
    pg.circle(0, 0, shorterSide/24.0f);
    var r = shorterSide/2.1;

    pg.strokeWeight(shorterSide/24.0f);
    for (var i = 0; i < 12; i++) {
      var x1 = r * -cos(radians(i*360/12.0f));
      var y1 = r * -sin(radians(i*360/12.0f));
      var x2 = r * 0.7 * -cos(radians(i*360/12.0f));
      var y2 = r * 0.7 * -sin(radians(i*360/12.0f));
      pg.line(x1, y1, x2, y2);
    }
    pg.strokeWeight(5);
    for (var i = 0; i < 60; i++) {
      var x1 = r * -cos(radians(i*360/60.0f));
      var y1 = r * -sin(radians(i*360/60.0f));
      var x2 = r * 0.85 * -cos(radians(i*360/60.0f));
      var y2 = r * 0.85 * -sin(radians(i*360/60.0f));
      pg.line(x1, y1, x2, y2);
    }

    pg.strokeWeight(shorterSide/24.0f);
    var h = radians((hour() + minute()/60.0f + second()/3600.0f) * 360 / 12.0f + 90);
    var xh = r * 0.6 * -cos(h);
    var yh = r * 0.6 * -sin(h);
    pg.line(0, 0, xh, yh);

    pg.strokeWeight(shorterSide/40.0f);
    var m = radians((minute() + second()/60.0f) * 360 / 60.0f + 90);
    var xm = r * 0.95 * -cos(m);
    var ym = r * 0.95 * -sin(m);
    pg.line(0, 0, xm, ym);

    // （あえて「RGB」で「赤」にする。「そう決めた！！」＼(^_^)／）
    pg.push();
    pg.colorMode(RGB, 255, 255, 255);
    pg.stroke(255, 0, 0);
    pg.strokeWeight(shorterSide/80.0f);
    var s = radians(second() * 360 / 60.0f + 90);
    var xs = r * 0.9 * -cos(s);
    var ys = r * 0.9 * -sin(s);
    pg.line(0, 0, xs, ys);
    pg.pop();
    pg.endDraw();
    image(pg, 0, 0, width, height);
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
