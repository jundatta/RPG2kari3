// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Ty Carpenterさん
// 【作品名】Camp Fire
// https://openprocessing.org/sketch/336291
//

class GameSceneCongratulations538 extends GameSceneCongratulationsBase {
  PGraphics pg;
  final int orgW = 1000;
  final int orgH = 600;

  //CLASSES

  Ember[] fire = new Ember[15];
  Flower[] pedal = new Flower[30];
  float fx, fy;
  float flickerW;
  float easing = .05;

  @Override void setup() {
    pg = createGraphics(orgW, orgH);

    pg.beginDraw();
    pg.smooth();
    pg.endDraw();

    //more classes

    for (int i = 0; i <fire.length; i++) {
      fire[i] = new Ember(width/2 + random (-10, 10), height/2 + random(-100, 100));
    }

    for (int j = 0; j <pedal.length; j++) {
      pedal[j] = new Flower(width/2 + random (-10, 10), height/2 + random(-100, 100));
    }
  }

  @Override void draw() {
    push();
    pg.beginDraw();
    pg.background (60, 30, 120);
    // BACKGROUND AND GRASS COLORING
    pg.noStroke();
    //BACKGROUND
    pg.fill(#0E0CC1);
    pg.rect(0, 0, width, 470);
    pg.fill(#1110AD);
    pg.rect(0, 0, width, 360);
    pg.fill(#110F98);
    pg.rect(0, 0, width, 260);
    pg.fill(#080786);
    pg.rect(0, 0, width, 210);
    pg.fill(#090871);
    pg.rect(0, 0, width, 140);
    pg.fill(#07065D);
    pg.rect(0, 0, width, 90);
    pg.fill(#050440);
    pg.rect(0, 0, width, 60);

    pg.strokeWeight(1);

    //MOON
    pg.fill(#E8E8F7, 30);
    pg.ellipse(280, 180, 130, 130);
    pg.fill(#E8E8F7);
    pg.ellipse(280, 180, 100, 100);

    //STARS
    pg.fill (250, 265, 265);
    pg.ellipse (250, 250, 5, 5);
    pg.ellipse (470, 200, 5, 5);
    pg.ellipse (780, 60, 5, 5);
    pg.ellipse (100, 30, 5, 5);
    pg.ellipse (600, 380, 5, 5);
    pg.ellipse (360, 300, 5, 5);
    pg.ellipse (400, 20, 5, 5);
    pg.ellipse (550, 150, 10, 10);
    pg.ellipse (500, 100, 10, 10);
    pg.ellipse (300, 20, 10, 10);
    pg.ellipse (660, 370, 10, 10);
    pg.ellipse (750, 260, 10, 10);
    pg.ellipse (10, 240, 10, 10);
    pg.ellipse (490, 320, 10, 10);
    pg.ellipse (170, 280, 10, 10);

    pg.fill(#087621);
    pg.rect(0, 425, width, height);

    //Grass shadows (leftside)
    pg.fill(#003E0E);
    pg.rect(0, 425, 30, height);
    pg.fill(#034612);
    pg.rect(30, 425, 60, height);
    pg.fill(#035816);
    pg.rect(90, 425, 20, height);
    pg.fill(#066A1D);
    pg.rect(110, 425, 50, height);
    pg.fill(#03831F);
    pg.rect(160, 425, 80, height);
    pg.fill(#049324);
    pg.rect(240, 425, 110, height);
    //Grass shadows (rightside)
    pg.fill(#11A532);
    pg.rect(350, 425, 140, height);
    pg.fill(#049324);
    pg.rect(490, 425, 110, height);
    pg.fill(#03831F);
    pg.rect(600, 425, 80, height);
    pg.fill(#066A1D);
    pg.rect(680, 425, 50, height);
    pg.fill(#035816);
    pg.rect(720, 425, 20, height);
    pg.fill(#034612);
    pg.rect(740, 425, 60, height);
    pg.fill(#003E0E);
    pg.rect(800, 425, 45, height);
    pg.fill(#022C0B);
    pg.rect(845, 425, 100, height);
    pg.fill(#002408);
    pg.rect(945, 425, 55, height);

    // calling tree function
    tree(pg, 130, 120, 1, 1);
    tree(pg, 550, 210, -.7, .7);

    pg.noStroke();
    //shadow
    pg.fill(255, 255, 0, random( 60, 80));
    pg.ellipse(418, 487, random(200, 260), 100);
    pg.stroke(1);

    //displaying and calling fire and pedal classes
    for (int i = 0; i <fire.length; i++) {
      fire[i].update();
      fire[i].display(pg);
    }

    firewood(pg, 413, 476);
    tent(pg, 744, 373, 1);

    for (int j = 0; j <pedal.length; j++) {
      pedal[j].update();
      pedal[j].display(pg);
    }

    tree(pg, 900, 100, 2, 2);
    pg.endDraw();
    image(pg, 0, 0, width, height);
    pop();

    logoRightLower(#ff0000);
  }

  class Ember {  //basically setup
    float locX;
    float locXF;
    float locY;
    float locYF;
    float diameter = 10;
    float diameterF = diameter;
    float dirX =1;
    float dirY = 1;
    float speedX =3;
    float speedY =3;
    float red = 0;
    float green = 0;
    float blue = 0;
    float redE = red;
    float grey = 0;
    float greyE = grey;

    Ember(float tx, float ty) {
      locX = tx;
      locY = ty;
      locXF= locX;
      locYF= locY;
    }
    void update() {              //mathy stuff
      locYF += (locY - locYF) * .3;
      locXF += (locX - locXF) * .3;
      redE += (red - redE) *.1;
      diameterF += (diameter - diameterF) * .1;
      //formula for X velocity
      locX += dirX * speedX;
      //formula for Y velocity
      locY += dirY * speedY;
      if (locY < 300 - diameter/2 ) {
        dirY = 1;
        speedX= random (6, 15);
        diameter= random(6, 15);
        red = random(230, 255);
      }
      if (locX > 475 - diameter/2 ) {
        dirX = -1;
        speedX= random (6, 15);
        diameter= random(6, 14);
        red = random(210, 255);
      }
      if (locX < 350 - diameter/2 ) {
        dirX = 1;
        speedX= random (6, 15);
        diameter= random(3, 18);
        red = random(180, 255);
      }
      if (locY > 470 - diameter/2 ) {
        dirY = -1;
        speedX= random (6, 15);
        diameter= random(6, 15);
        red = random(230, 255);
      }
    }

    void display(PGraphics pg) {
      pg.fill(redE, 100, 100);
      pg.ellipse(locXF, locYF, diameterF, diameterF);
    }
  }

  void firewood(PGraphics pg, float fx, float fy) {
    pg.pushMatrix();

    pg.translate(fx, fy);

    pg.fill(#6F2F2F);
    pg.quad(-30, -5, 40, 25, 45, 15, -35, -25);
    pg.fill(#894D4D);
    pg.quad(-25, 25, 35, 0, 30, -20, -40, 0);

    pg.popMatrix();
  }

  class Flower {
    float Fx = random(width);
    float Fy = random (-600, 0);
    float x1, angle1, angle2;
    float locX, locY, diameterFW, diameterFH;
    float direcX, direcY;
    float speedFX, speedFY;
    float scalar = random(14, 20);
    float  diameter;

    Flower (float Fx, float Fy) {
      diameterFW = 20;
      diameterFH =10;
      speedFX =random (.3, .5);
      speedFY =random (.3, .5);
    }

    void update() {
      float ang1 = radians(angle1);
      x1 = 0 + (scalar * cos(ang1));
      Fx += speedFX;
      Fy += speedFY;
      if (Fx + x1 >= 1000 + scalar) {
        Fx = 0 - scalar/2;
      }
      if (Fy  >= 600 + scalar) {
        Fy = 0 - scalar/2;
      }
    }

    void display(PGraphics pg) {
      pg.strokeWeight(1);
      pg.fill(#F58181);
      pg.stroke(0, 255);
      pg.ellipse(Fx + x1, Fy, scalar, scalar);

      angle1 += random(1, 6);
    }
  }
  void tent(PGraphics pg, float tentx, float tenty, float scalar) {
    pg.pushMatrix();

    pg.translate(tentx, tenty);
    pg.fill(#5F2323);
    pg.triangle(-100, 70, -10, 90, -50, -30);
    pg.quad(-50, -30, -10, 90, 100, 60, 80, -10);
    pg.fill(#481111);
    pg.triangle(-50, -30, -60, 80, -65, 82);

    pg.line(-50, -33, 10, 100);
    pg.line(-50, -33, -120, 70);
    pg.line(80, -10, 110, 70);

    //MOUSEPRESSED TO READ!
    if (mousePressed) {
      pg.pushMatrix();
      pg.strokeWeight(0);
      pg.fill(#FFFBC9, random(40, 60));
      pg.ellipse(37, 30, 90, 60);

      pg.strokeWeight(10);
      pg.stroke(0, 40);
      pg.line(50, 30, 55, 40);
      pg.line(55, 40, 55, 52);
      pg.strokeWeight(6);
      pg.line(53, 32, 45, 45);
      pg.line(45, 45, 35, 40);
      pg.strokeWeight(3);
      pg.line(50, 30, 48, 28);
      pg.fill(0, 40);
      pg.ellipse(40, 20, 18, 19);
      pg.ellipse(31, 28, 5, 5);
      pg.ellipse(35, 15, 15, 5);
      pg.ellipse(46, 15, 5, 10);

      pg.quad(40, 40, 30, 42, 25, 40, 20, 30);
      pg.popMatrix();
    }

    pg.popMatrix();
  }


  void tree(PGraphics pg, float treeX, float treeY, float sx, float sy) {
    pg.pushMatrix();

    pg.translate(treeX, treeY);
    pg.scale(sx, sy);

    pg.strokeWeight(1);
    pg.stroke(0, 255);
    pg.fill(#6F2F2F, 255);
    pg.beginShape();
    pg.vertex(0, -10);
    pg.vertex(-20, 40);
    pg.vertex(-15, 80);
    pg.vertex(0, 140);
    pg.vertex(-5, 250);
    pg.vertex(15, 300);
    pg.vertex(80, 350);
    pg.vertex(20, 330);
    pg.vertex(-10, 360);
    pg.vertex(-20, 310);
    pg.vertex(-50, 355);
    pg.vertex(-25, 300);
    pg.vertex(-40, 240);
    pg.vertex(-20, 180);
    pg.vertex(-45, 70);
    pg.vertex(-70, 0);
    pg.endShape();

    pg.fill(#F58181);
    pg.beginShape();
    pg.vertex(-200, -60);
    pg.vertex(-250, -20);
    pg.vertex(-215, 60);
    pg.vertex(-180, 80);
    pg.vertex(-100, 55);
    pg.vertex(-50, 65);
    pg.vertex(0, 100);
    pg.vertex(40, 80);
    pg.vertex(90, 60);
    pg.vertex(70, 20);
    pg.vertex(100, 0);
    pg.vertex(170, -30);
    pg.vertex(180, -60);
    pg.vertex(190, -70);
    pg.vertex(80, -80);
    pg.vertex(30, -100);
    pg.vertex(0, -130);
    pg.vertex(-80, -80);
    pg.vertex(-120, -90);
    pg.vertex(-150, -80);
    pg.endShape();

    pg.popMatrix();
  }

  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
