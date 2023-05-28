// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Richard Bourneさん
// 【作品名】Day/Night Cycle
// https://openprocessing.org/sketch/1810553
//

class GameSceneCongratulations550 extends GameSceneCongratulationsBase {
  CosmoObject sun, moon;
  Star[] stars;
  float star_alpha;
  float cycle_length = 500 * 60;

  PGraphics pg;

  @Override void setup() {
    pg = createGraphics(width, height);

    sun = new CosmoObject(1);
    moon = new CosmoObject(-1);
    moon.get_pos(0);
    stars = new Star[500];
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
      stars[i].get_pos(0);
      if (dist(stars[i].x, stars[i].y, moon.x, moon.y) < 250) {
        stars[i].renew();
      }
    }
  }

  @Override void draw() {
    push();
    pg.beginDraw();
    float t = millis() % cycle_length;
    sky_box_cycle(pg, t);

    star_alpha = do_cycle_stars(t);
    for (int i = 0; i < stars.length; i++) {
      stars[i].get_pos(2 * PI * t / cycle_length);
      stars[i].draw(pg, color(255, 255, 255, 255 * star_alpha));
    }
    sun.get_pos(2 * PI * t / (cycle_length));
    sun.draw(pg);
    moon.get_pos(2 * PI * t / (cycle_length));
    moon.draw(pg);
    pg.endDraw();
    image(pg, 0, 0);
    pop();

    logoRightLower(#ff0000);
  }

  float do_cycle_stars(float time_point) {
    float cycle_point;
    if (time_point > 0.8 * cycle_length) {
      time_point += -cycle_length;
    }
    cycle_point = pow(4 * time_point / cycle_length - 0.95, 8);
    cycle_point = 1 - 0.75 * cycle_point;
    return cycle_point;
  }
  class CosmoObject {
    int type;
    float r, r_orbit;
    float x, y;
    color ccc;
    CosmoObject(int type) { // type=1: sun, type=-1: moon
      this.type = type;
      this.r = 200;
      this.r_orbit = 0.4 * width * type;
      this.x = 0;
      this.y = 0;
    }

    void get_pos(float angle) {
      this.x = width / 2.0f + 1.1 * this.r_orbit * cos(angle);
      this.y = height * 1.05 + this.r_orbit * sin(angle);
    }

    void get_sun_color() {
      float sunrise_alpha = (this.y - height * 2 / 3.0f) / (float)height;
      color color_high = color(255, 255, 230);
      color color_low = color(255, 255, 0);
      this.ccc = lerpColor(color_high, color_low, sunrise_alpha);
    }

    void get_moon_color() {
      float moonrise_alpha = (this.y - height / 2.0f) / (float)(1 / 3.0f * height);
      color color_high = color(210, 215, 235);
      color color_low = color(240, 245, 255);
      this.ccc = lerpColor(color_high, color_low, moonrise_alpha);
    }

    void draw(PGraphics pg) {
      pg.noStroke();
      if (1 + this.type != 0) {
        this.get_sun_color();
        float gloom_alpha = 40 * (height * 2 / 3.0f - this.y) / (float)height;
        pg.fill(color(250, 250, 80, gloom_alpha));

        pg.circle(this.x, this.y, this.r * 2.5);
        pg.circle(this.x, this.y, this.r * 2.2);
        pg.circle(this.x, this.y, this.r * 1.9);
        pg.circle(this.x, this.y, this.r * 1.6);
        pg.circle(this.x, this.y, this.r * 1.3);
        pg.fill(this.ccc);
        pg.circle(this.x, this.y, this.r);
      } else {
        this.get_moon_color();
        pg.fill(this.ccc);
        pg.circle(this.x, this.y, this.r);
        pg.fill(color(240, 245, 255));
        pg.circle(this.x - 8, this.y - 8, this.r * 0.88);
      }
    }
  }

  class Star {
    float r, angle, r_orbit;
    float x, y;
    Star() {
      this.r = random(2, 8);
      this.angle = random(2 * PI);
      this.r_orbit = random(100, max(width, height));
      this.x = 0;
      this.y = 0;
    }

    void renew() {
      this.r_orbit *= -1;
    }

    void get_pos(float angle) {
      this.x = width / 2.0f + 1.1 * this.r_orbit * cos(angle + this.angle);
      this.y = height * 1.05 + this.r_orbit * sin(angle + this.angle);
    }

    void draw(PGraphics pg, color col) {
      pg.noStroke();
      pg.fill(col);
      pg.circle(this.x, this.y, this.r);
    }
  }

  void set_gradient(PGraphics pg, color color1, color color2) {
    for (int y = 0; y < height + 1; y++) {
      float interp = map(y, 0, height, 0, 1);
      color interp_color = lerpColor(color1, color2, interp);
      pg.stroke(interp_color);
      pg.line(0, y, width, y);
    }
  }

  void sky_box_cycle(PGraphics pg, float time) {
    float[] time_stamps = {1 / 4.0f, 1 / 2.0f, 3 / 4.0f};

    float[] period_lengths = {time_stamps[0], time_stamps[1] - time_stamps[0], time_stamps[2] - time_stamps[1], 1 - time_stamps[2]};
    color[] day_grad = {color(142, 191, 255), color(220, 240, 255)};
    color[] sunset_grad = {color(219, 63, 110), color(199, 142, 77)};
    color[] night_grad = {color(0, 0, 50), color(32, 72, 145)};
    color[] sunrise_grad = {color(239, 172, 183), color(244, 192, 80)};

    float cycle_time = time / cycle_length; // normalize period time

    float light_cycle = 0.0f;
    color[] grad_from = null;
    color[] grad_to = null;
    if (cycle_time < time_stamps[0]) {
      light_cycle = sin(PI * cycle_time / (float)(2 * period_lengths[0]));
      light_cycle = sin(PI / 2.0f * sin(PI / 2.0f * sin(PI / 2.0f * light_cycle)));
      grad_from = sunset_grad;
      grad_to = night_grad;
    } else if (cycle_time < time_stamps[1]) {
      light_cycle = 1 - sin(PI * (cycle_time - time_stamps[0] + period_lengths[1]) / (float)(2 * period_lengths[1]));
      light_cycle = pow(light_cycle, 3);
      grad_from = night_grad;
      grad_to = sunrise_grad;
    } else if (cycle_time < time_stamps[2]) {
      light_cycle = sin(PI * (cycle_time - time_stamps[1]) / (float)(2 * period_lengths[2]));
      light_cycle = sin(PI / 2.0f * light_cycle);
      grad_from = sunrise_grad;
      grad_to = day_grad;
    } else {
      light_cycle = 1 - sin(PI * (cycle_time - time_stamps[2] + period_lengths[3]) / (float)(2 * period_lengths[3]));
      light_cycle = pow(light_cycle, 2);
      grad_from = day_grad;
      grad_to = sunset_grad;
    }

    color grad_col0 = lerpColor(grad_from[0], grad_to[0], light_cycle);
    color grad_col1 = lerpColor(grad_from[1], grad_to[1], light_cycle);
    set_gradient(pg, grad_col0, grad_col1);
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
