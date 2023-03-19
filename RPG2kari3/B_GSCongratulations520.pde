// コングラチュレーション画面
//
// オリジナルはこちらです。
// 【作者】中内　純(ハンドルネーム：JunKiyoshi)さん
// 【作品名】Connect circles of 3 layer. Draw by openFrameworks
// https://junkiyoshi.com/openframeworks20230312/
//

class GameSceneCongratulations520 extends GameSceneCongratulationsBase {
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

    background(0);
    ofSetLineWidth(3);

    blendMode(ADD);

    translate(width * 0.5f, height * 0.5f);

    var x = 0;

    for (int radius = 50; radius <= 300; radius += 100) {
      int deg_start = (int)map(openFrameworksNoise.ofNoise(random(1000), ofGetFrameNum() * 0.001), 0, 1, -360, 360);

      for (int deg = deg_start; deg < deg_start + 360; deg += 1) {
        pushMatrix();
        ofRotate(deg);

        var base_location = new PVector(x, radius);
        var target_location = new PVector(x, radius + 80);
        //var distance = target_location - base_location;
        var distance = new PVector(
          target_location.x - base_location.x, target_location.y - base_location.y);
        var len = distance.mag();
        var noise_seed = random(1000);
        var nd = distance.copy();
        nd.normalize();

        ArrayList<PVector> vertices = new ArrayList();
        for (int d = 0; d <= len; d++) {
          //var location = base_location + glm::normalize(distance) * d;
          PVector location = new PVector(
            base_location.x + (nd.x * d), base_location.y + (nd.y * d));

          var gap = abs(len * 0.5 - d);
          var power = gap < len * 0.35 ? 1 : map(gap, len * 0.35, len * 0.5, 1, 0);

          var noise_x = map(openFrameworksNoise.ofNoise(noise_seed, location.x * 0.05, location.y * 0.015 + ofGetFrameNum() * 0.05), 0, 1, -10, 10);
          //location += glm::vec2(noise_x * power, 0);
          location.x += noise_x * power;
          location.y += 0;

          vertices.add(location);
        }

        push();
        colorMode(HSB, 255, 255, 255);
        color c = color(map(deg, deg_start, deg_start + 360, 0, 255), 200, 255);
        pop();

        stroke(c);

        noFill();
        beginShape();
        //ofVertices(vertices);
        for (var v : vertices) {
          vertex(v.x, v.y);
        }
        endShape();

        fill(c);
        //ofDrawCircle(vertices.front(), 2);
        PVector front = vertices.get(0);
        circle(front.x, front.y, 2);
        //ofDrawCircle(vertices.back(), 2);
        PVector back = vertices.get(vertices.size()-1);
        circle(back.x, back.y, 2);

        popMatrix();
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
