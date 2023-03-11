// コングラチュレーション画面
//
// オリジナルはこちらです。
// 【作者】中内　純(ハンドルネーム：JunKiyoshi)さん
// 【作品名】Rail. Draw by openFrameworks
// https://junkiyoshi.com/openframeworks20230308/
//

class GameSceneCongratulations514 extends GameSceneCongratulationsBase {
  @Override void setup() {
  }
  //--------------------------------------------------------------
  void update() {
    ofSeedRandom(39);
  }

  //--------------------------------------------------------------
  @Override void draw() {
    push();
    update();
    translate(width * 0.5f, height * 0.5f);

    background(0);
    stroke(255);
    ofSetLineWidth(1.5);

    var radius = 150;
    int deg_span = 6;

    var target_deg = ofGetFrameNum() % 360;
    for (int deg = 0; deg < 360; deg += deg_span) {

      var location = new PVector(radius * cos(deg * DEG_TO_RAD), radius * sin(deg * DEG_TO_RAD), 0);
      var target_location = new PVector(radius * cos(target_deg * DEG_TO_RAD), radius * sin(target_deg * DEG_TO_RAD), 0);
      var distance = PVector.dist(location, target_location);

      var len = 20.0f;
      if (distance < 60) {
        len = map(distance, 0, 60, 60, 20);
      }

      var location_1 = new PVector((radius + len * 0.5) * cos(deg * DEG_TO_RAD), (radius + len * 0.5) * sin(deg * DEG_TO_RAD), 0);
      var location_2 = new PVector((radius - len * 0.5) * cos(deg * DEG_TO_RAD), (radius - len * 0.5) * sin(deg * DEG_TO_RAD), 0);

      var sx = location_1.x;
      var sy = location_1.y;
      var sz = location_1.z;
      var ex = location_2.x;
      var ey = location_2.y;
      var ez = location_2.z;
      line(sx, sy, sz, ex, ey, ez);
      push();
      translate(sx, sy, sz);
      sphere(2);
      pop();
      push();
      translate(ex, ey, ez);
      sphere(2);
      pop();

      push();
      translate(target_location.x, target_location.y, target_location.z);
      sphere(8);
      pop();
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
