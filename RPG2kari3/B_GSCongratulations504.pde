// コングラチュレーション画面
//
// オリジナルはこちらです。
// 【作者】中内　純(ハンドルネーム：JunKiyoshi)さん
// 【作品名】Heart wave. Draw by openFrameworks
// https://https://junkiyoshi.com/2023/02/19/
//

class GameSceneCongratulations504 extends GameSceneCongratulationsBase {
  ArrayList<PVector> location_list = new ArrayList();
  FloatList size_list = new FloatList();
  FloatList speed_list = new FloatList();
  FloatList max_size_list = new FloatList();
  FloatList deg_list = new FloatList();
  IntList color_list = new IntList();

  @Override void setup() {
  }

  //--------------------------------------------------------------
  void update() {
    for (int i = location_list.size() - 1; i >= 0; i--) {
      //    size_list[i] += speed_list[i];
      float sp = speed_list.get(i);
      float sz = size_list.get(i);
      sz += sp;
      size_list.set(i, sz);

      if (size_list.get(i) > max_size_list.get(i)) {
        location_list.remove(i);
        size_list.remove(i);
        speed_list.remove(i);
        max_size_list.remove(i);
        deg_list.remove(i);
        color_list.remove(i);
      }
    }

    push();
    colorMode(HSB, 255, 255, 255);
    for (int i = 0; i < 10; i++) {
      float random_x = random(width * -0.5, width * 0.5);
      float y = map(openFrameworksNoise.ofNoise(random_x * 0.0025 + ofGetFrameNum() * 0.015), 0, 1, height * -0.5, height * 0.5);

      PVector location = new PVector(random_x, y + random(-30, 30));
      location_list.add(location);
      size_list.append(1);
      speed_list.append(random(1, 4));
      max_size_list.append(random(20, 40));
      deg_list.append(random(360));
      color c = color(random(255), 200, 255);
      color_list.append(c);
    }
    pop();
  }

  //--------------------------------------------------------------
  @Override void draw() {
    push();
    update();

    background(0);
    blendMode(ADD);

    translate(width * 0.5f, height * 0.5f);
    noFill();

    for (int i = 0; i < location_list.size(); i++) {
      pushMatrix();
      PVector loc = location_list.get(i);
      translate(loc.x, loc.y);
      rotate(radians(deg_list.get(i)));

      float sz = size_list.get(i);
      ArrayList<PVector> vertices = new ArrayList();
      for (int deg = 0; deg < 360; deg += 2) {
        PVector p = make_point(deg * DEG_TO_RAD);
        p.x *= sz / 30.0f;
        p.y *= sz / 30.0f;
        vertices.add(p);
      }

      color c = color_list.get(i);
      stroke(c);
      float msz = max_size_list.get(i);
      int alpha = sz > msz * 0.6 ? (int)map(sz, msz * 0.6, msz, 255, 0) : 255;
      fill(red(c), green(c), blue(c), alpha);

      beginShape();
      for (PVector v : vertices) {
        vertex(v.x, v.y);
      }
      endShape(CLOSE);
      popMatrix();
    }
    pop();

    logoRightLower(#ff0000);
  }
  //--------------------------------------------------------------
  //Reference by https://twitter.com/shiffman/status/1095764239665512453
  PVector make_point(float theta) {
    float x = 16 * (pow(sin(theta), 3));
    float y = 13 * cos(theta) - 5 * cos(2 * theta) - 2 * cos(3 * theta) - cos(4 * theta);
    return new PVector(x, -y);
  }
  
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
