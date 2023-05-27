// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Richard Bourneさん
// 【作品名】Another Analog Clock
// https://openprocessing.org/sketch/1912884
//

class GameSceneCongratulations549 extends GameSceneCongratulationsBase {
  int i, j, ms;
  float h, m, s, r, x0, x1, y0, y1;
  PGraphics pg;

  @Override void setup() {
    pg = createGraphics(width, height);
    if (width > height) {
      r = height / 2;
    } else {
      r = width / 2;
    }
    r -= r / 8;
    s = second();
    while (s == second());
    ms = millis();
  }
  @Override void draw() {
    push();
    pg.beginDraw();
    pg.textAlign(CENTER, CENTER);
    pg.rectMode(CENTER);

    pg.background(0);
    pg.noStroke();
    pg.fill(0, 0, 64);
    pg.ellipse(width / 2, height / 2, 2 * r, 2 * r);
    for (j = 0; j < height; j += height / 32) {
      for (i = 0; i < width - width / 64; i += width / 64) {
        x0 = float(i);
        y0 = float(j) + height / 64 * sin(i * TWO_PI / width * 8);
        x1 = float(i + width / 64);
        y1 = float(j) + height / 64 * sin((i + width / 64) * TWO_PI / width * 8);
        pg.stroke(0, 0, 128, 128);
        pg.strokeWeight(r / 256);
        pg.line(x0 - 2, y0 - 2, x1 - 2, y1 - 2);
        pg.stroke(0, 0, 96, 128);
        pg.strokeWeight(r / 128);
        pg.line(x0, y0, x1, y1);
      }
    }
    pg.loadPixels();
    for (j = -height / 2; j < height / 2; j++) {
      for (i = -width / 2; i < width / 2; i++) {
        if (i * i + j * j > r * r) {
          pg.pixels[(height / 2 + j) * width + (width / 2) + i] = color(0);
        }
      }
    }
    pg.updatePixels();
    pg.stroke(255);
    pg.strokeWeight(r / 64);
    pg.noFill();
    pg.ellipse(width / 2, height / 2, 2 * r, 2 * r);
    pg.fill(255);
    for (i = 0; i < 60; i++) {
      if (i % 5 == 0) {
        x0 = width / 2 + (r - r / 8) * cos(i * TWO_PI / 60);
        x1 = width / 2 + r * cos(i * TWO_PI / 60);
        y0 = height / 2 + (r - r / 8) * sin(i * TWO_PI / 60);
        y1 = height / 2 + r * sin(i * TWO_PI / 60);
        pg.strokeWeight(r / 128);
      } else {
        x0 = width / 2 + (r - r / 16) * cos(i * TWO_PI / 60);
        x1 = width / 2 + r * cos(i * TWO_PI / 60);
        y0 = height / 2 + (r - r / 16) * sin(i * TWO_PI / 60);
        y1 = height / 2 + r * sin(i * TWO_PI / 60);
        pg.strokeWeight(r / 256);
      }
      pg.line(x0, y0, x1, y1);
      if (i % 5 == 0) {
        x0 = width / 2 + (r - r / 5) * cos(i * TWO_PI / 60);
        y0 = height / 2 + (r - r / 5) * sin(i * TWO_PI / 60);
        pg.textSize(r / 8);
        pg.text((i / 5 + 2) % 12 + 1, x0, y0);
        x0 = width / 2 + (r - 2 * r / 5) * cos(i * TWO_PI / 60);
        y0 = height / 2 + (r - 2 * r / 5) * sin(i * TWO_PI / 60);
        pg.textSize(r / 12);
        pg.text((i / 5 + 2) % 12 + 13, x0, y0);
        x0 = width / 2 + (r + r / 12) * cos(i * TWO_PI / 60);
        y0 = height / 2 + (r + r / 12) * sin(i * TWO_PI / 60);
        pg.text((i + 15) % 60, x0, y0);
      }
    }
    pg.stroke(0);
    pg.strokeWeight(r / 128);
    pg.fill(255);
    x0 = width / 2;
    y0 = height * 2 /3.2;
    pg.ellipse(x0, y0, r / 7, r / 7);
    pg.fill(0);
    pg.textSize(r / 12);
    pg.text(day(), x0, y0 - r / 160);
    pg.noStroke();
    pg.fill(255);
    pg.ellipse(width / 2, height / 2, r / 16, r / 16);
    pg.textSize(r / 9);
    pg.text("R", width / 2 - r / 20 - 1, 9 * height / 25);
    pg.text("J", width / 2, 9 * height / 25);
    pg.text("B", width / 2 + r / 20 + 1, 9 * height / 25);
    pg.textSize(r / 4);
    h = float(hour());
    m = float(minute());
    s = float(second()) + float((millis() - ms) % 1000) / 1000.0;
    m += s / 60.0;
    h += m / 60.0;
    x0 = width / 2 + (r - r / 2) * cos((h - 3) * TWO_PI / 12);
    y0 = height / 2 + (r - r / 2) * sin((h - 3) * TWO_PI / 12);
    pg.stroke(255);
    pg.strokeWeight(r / 32);
    pg.line(width / 2, height / 2, x0, y0);
    x0 = width / 2 + (r - r / 4) * cos((m - 15) * TWO_PI / 60);
    y0 = height / 2 + (r - r / 4) * sin((m - 15) * TWO_PI / 60);
    pg.stroke(255);
    pg.strokeWeight(r / 64);
    pg.line(width / 2, height / 2, x0, y0);
    pg.noStroke();
    pg.fill(255, 0, 0);
    pg.ellipse(width / 2, height / 2, r / 32, r / 32);
    x0 = width / 2 + (r - r / 6) * cos((s - 15) * TWO_PI / 60);
    y0 = height / 2 + (r - r / 6) * sin((s - 15) * TWO_PI / 60);
    x1 = width / 2 + (r - 2 * r / 9) * cos((s - 15) * TWO_PI / 60);
    y1 = height / 2 + (r - 2 * r / 9) * sin((s - 15) * TWO_PI / 60);
    pg.stroke(255, 0, 0);
    pg.strokeWeight(r / 128);
    pg.line(width / 2, height / 2, x0, y0);
    pg.strokeWeight(r / 256);
    pg.fill(255);
    pg.ellipse(x1, y1, r / 24, r / 24);
    pg.endDraw();
    image(pg, 0, 0);
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
