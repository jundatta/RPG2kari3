// コングラチュレーション画面
//
// オリジナルはこちらです。
// 【作者】中内　純(ハンドルネーム：JunKiyoshi)さん
// 【作品名】wave on hexagons. Draw by openFrameworks
// https://junkiyoshi.com/2023/03/27/
//

class GameSceneCongratulations522 extends GameSceneCongratulationsBase {
  float radius;
  ArrayList<PVector> location_list = new ArrayList();

  //--------------------------------------------------------------
  @Override void setup() {
    radius = 16;
    var x_span = radius * sqrt(3);
    var flg = true;
    for (float y = -650; y < 650; y += radius * 1.5) {
      for (float x = -650; x < 650; x += x_span) {
        PVector location;
        if (flg) {
          location = new PVector(x, y);
        } else {
          location = new PVector(x + (x_span / 2), y);
        }
        location_list.add(location);
      }
      flg = !flg;
    }
  }
  //--------------------------------------------------------------
  void update() {
    ofSeedRandom(39);
  }

  //--------------------------------------------------------------
  @Override void draw() {
    push();
    update();

    translate(width * 0.5, height * 0.5);

    background(0);
    ofSetLineWidth(1.5);
    blendMode(ADD);

    IntList color_list = new IntList();
    color_list.append(color(255, 0, 0));
    color_list.append(color(0, 255, 0));
    color_list.append(color(0, 0, 255));

    for (var cc : color_list) {
      var noise_seed = random(1000);
      for (var location : location_list) {
        ArrayList<PVector> vertices = new ArrayList();
        for (int deg = 90; deg < 450; deg += 60) {
          //vertices.push_back(location + glm::vec2(radius * cos(deg * DEG_TO_RAD), radius * sin(deg * DEG_TO_RAD)));
          float x = radius * cos(deg * DEG_TO_RAD);
          float y = radius * sin(deg * DEG_TO_RAD);
          PVector v = new PVector(location.x + x, location.y + y);
          vertices.add(v);
        }
        var noise_y = map(openFrameworksNoise.ofNoise(noise_seed, location.x * 0.001 + ofGetFrameNum() * 0.005), 0, 1, -200, 200);
        float distance = abs(location.y - noise_y);

        if (distance < radius * 6) {
          //ofNoFill();
          //ofSetColor(color, ofMap(distance, 0, radius * 6, 255, 0));
          stroke(red(cc), green(cc), blue(cc), map(distance, 0, radius * 6, 255, 0));

          //ofFill();
          //ofSetColor(color, ofMap(distance, 0, radius * 6, 128, 0));
          fill(red(cc), green(cc), blue(cc), map(distance, 0, radius * 6, 128, 0));

          beginShape();
          for (PVector v : vertices) {
            vertex(v.x, v.y);
          }
          endShape(CLOSE);
        }
      }
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
