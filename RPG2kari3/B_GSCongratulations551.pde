// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】banana_sakamoさん
// 【作品名】Rising
// https://neort.io/art/chqnkfcn70roimkcmt6g
//

class GameSceneCongratulations551 extends GameSceneCongratulationsBase {
  // 範囲
  int rangeHalf = 50;
  // プロットする点の数
  int sampleR = 10;
  int sampleT = 30;
  // 点の幅
  float skip = rangeHalf * 2 / (float)sampleR;

  PlotBox[][] plotBoxes;

  @Override void setup() {
    plotBoxes = new PlotBox[sampleR][];
    for (int r = 0; r < sampleR; r++) {
      float radius = (r + 1) * skip;

      plotBoxes[r] = new PlotBox[sampleT];

      for (int t = 0; t < sampleT; t++) {
        float theta = t * 360 / (float)sampleT;

        plotBoxes[r][t] = new PlotBox(radius, theta, -0.1);
      }
    }
  }
  @Override void draw() {
    push();
    translate(width * 0.5, height * 0.5);
    camera(
      cos(radians(1 * frameCount)) * 120, 120, sin(radians(1 * frameCount)) * 120,
      0, 0, 0,
      0, -1, 0
      );

    background(0);

    for (int r = 0; r < sampleR; r++) {
      for (int t = 0; t < sampleT; t++) {
        plotBoxes[r][t].update(sampleR * skip);
      }
    }
    pop();

    logoRightLower(#ff0000);
  }

  class PlotBox {
    float radius, theta, velocity;
    PVector posi;
    PlotBox(float r, float t, float v) {
      this.radius = r;
      this.theta = t;
      this.posi = this.PCStoRCS(this.radius, this.theta);
      this.velocity = v;
    }

    void update(float nextRadius) {
      if ((this.posi.x * this.posi.x) + (this.posi.z * this.posi.z) < 0.5) {
        this.radius = nextRadius;
      }
      //  点の移動
      this.radius += this.velocity;
      this.posi = this.PCStoRCS(this.radius, this.theta);

      // y座標の計算
      float denominator = (this.posi.x * this.posi.x) + (this.posi.z * this.posi.z);
      this.posi = this.getPosition(this.posi.x, this.posi.z, denominator);

      push();
      translate(this.posi.x, this.posi.y, this.posi.z);
      stroke(200, 200, 255);
      box(0.5);
      pop();
    }

    // 極座標系からデカルト座標系への変換(xz平面)
    PVector PCStoRCS(float r, float theta) {
      return new PVector(r * cos(radians(theta)), 0, r * sin(radians(theta)));
    }

    // 以下の式を返す(denominator: 分母)
    // y = 1000 / (x^2 + z^2)
    PVector getPosition(float x, float z, float denominator) {
      float y = 0;
      if (denominator != 0) {
        y = 10000 / denominator;
      }
      return new PVector(x, y, z);
    }
  }
  
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
