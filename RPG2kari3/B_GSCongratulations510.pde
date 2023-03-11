// コングラチュレーション画面
//
// オリジナルはこちらです。
// 【作者】中内　純(ハンドルネーム：JunKiyoshi)さん
// 【作品名】Line and ripple. Draw by openFrameworks
// https://junkiyoshi.com/openframeworks20230309/
//

class GameSceneCongratulations510 extends GameSceneCongratulationsBase {
  ArrayList<PVector> location_list = new ArrayList();
  FloatList radius_list = new FloatList();
  FloatList speed_list = new FloatList();
  FloatList max_radius_list = new FloatList();
  IntList color_list = new IntList();

  //--------------------------------------------------------------
  @Override void setup() {
  }

  //--------------------------------------------------------------
  void update() {
    for (int i = location_list.size() - 1; i >= 0; i--) {
      float radius = radius_list.get(i);
      if (radius > 0) {
        radius += speed_list.get(i);
      } else {
        radius += speed_list.get(i) * 20;
      }
      radius_list.set(i, radius);

      if (radius > max_radius_list.get(i)) {
        location_list.remove(i);
        radius_list.remove(i);
        speed_list.remove(i);
        max_radius_list.remove(i);
        color_list.remove(i);
      }
    }

    push();
    colorMode(HSB, 255, 255, 255);
    for (int i = 0; i < 1; i++) {
      int random_deg = (int)random(360);
      int random_radius = 250 + (int)random(-20, 20);

      PVector location = new PVector(random_radius * cos(random_deg * DEG_TO_RAD), random_radius * sin(random_deg * DEG_TO_RAD));
      location_list.add(location);
      radius_list.append(random(-600, -300));
      speed_list.append(random(0.1, 0.5));
      max_radius_list.append(random(15, 30));

      color c = color(map(location.x, -270, 270, 0, 255), 255, 255);
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
    strokeWeight(1.5f);

    translate(width * 0.5f, height * 0.5f);

    for (int i = 0; i < location_list.size(); i++) {
      float radius = radius_list.get(i);
      float max_radius = max_radius_list.get(i);
      color c = color_list.get(i);
      PVector location = location_list.get(i);
      float x = location.x;
      float y = location.y;
      if (radius > 0) {
        float alpha = radius < max_radius * 0.8 ? 255 : map(radius, max_radius * 0.8, max_radius, 255, 64);
        stroke(red(c), green(c), blue(c), alpha);
        noFill();
        circle(x, y, radius * 2);

        fill(c);
        noFill();
        circle(x, y, 2 * 2);
      } else {
        float alpha = map(radius, -600, 0, 64, 255);
        stroke(red(c), green(c), blue(c), alpha);
        noFill();
        line(x, y, radius, x, y, radius - 20);
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
