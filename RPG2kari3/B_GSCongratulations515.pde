// コングラチュレーション画面
//
// オリジナルはこちらです。
// 【作者】Richard Bourneさん
// 【作品名】Timmy the Train
// https://openprocessing.org/sketch/1864134
//

class GameSceneCongratulations515 extends GameSceneCongratulationsBase {
  Train timmy;
  Track[] trax=new Track[15];
  Bugs[] bugsy=new Bugs[10];
  int trans;
  int sliderX;
  int bounds=15;
  boolean light;

  PGraphics pg;
  final int screenW = 1112;
  final int screenH = 834;

  @Override void setup() {
    timmy=new Train();
    for (int i=0; i<trax.length; i++) {
      trax[i]=new Track(20+i*75, 418);
    }//end trax setup

    for (int i=0; i<bugsy.length; i++) {
      bugsy[i]=new Bugs();
    }//end bugsy setup
    sliderX=20;

    pg = createGraphics(screenW, screenH);
  }
  @Override void draw() {
    push();
    pg.beginDraw();
    pg.background(255);

    pg.fill(50, 140, 200);
    pg.rect(0, 600, pg.width, 275);//river
    pg.fill(43, 234, 76);
    pg.rect(0, 425, pg.width, 275);//grass
    pg.fill(54, 244, 252);
    pg.rect(0, 0, pg.width, 425);//sky
    pg.fill(185, 122, 87);
    pg.rect(0, 489, pg.width, 10);//rail

    for (int i=0; i<trax.length; i++) {
      trax[i].update();
      trax[i].display(pg);
    }//end trax setup

    pg.pushMatrix();
    pg.translate(150, 240);
    //scale(0.7);//drew train too big in design, didn't want to redraw
    timmy.display(pg);
    pg.popMatrix();

    pg.fill(0, trans);
    pg.rect(0, 0, pg.width, pg.height);//"day" rectangle

    //creates light from lantern, on top of "day" rectangle to be seen as a light at night
    if (light) {
      pg.pushMatrix();
      //same translation as train so i don't have to find scaled coordinates of lantern
      pg.translate(334, 260);
      pg.scale(0.7);
      //using the stroke of the arc so it doesn't also cover up the lantern
      pg.noFill();
      pg.stroke(250, 255, 0);
      pg.strokeWeight(30);
      pg.strokeCap(SQUARE);
      //creating rings of light, getting more transparent as the light goes out (3 levels of transparency)
      for (int i=0; i<7; i++) {
        pg.arc(585, 67, 70+i*50, 70+i*50, radians(-25), radians(25));
      }
      pg.stroke(250, 255, 0, 200);
      for (int i=0; i<7; i++) {
        pg.arc(585, 67, 370+i*59, 370+i*59, radians(-25), radians(25));
      }
      pg.stroke(250, 255, 0, 140);
      for (int i=0; i<7; i++) {
        pg.arc(585, 67, 784+i*59, 784+i*59, radians(-25), radians(25));
      }//end light arcs

      pg.popMatrix();

      pg.stroke(0);
      pg.strokeWeight(1);
      pg.strokeCap(ROUND);
    }//end light check

    //bugs are only displayed at a certain brightness
    if (trans>150) {
      for (int i=0; i<bugsy.length; i++) {
        bugsy[i].update();
        bugsy[i].display(pg);
      }//end bugsy display for
    }//end night check

    dayTime(pg);
    lightSwitch(pg);
    pg.endDraw();
    image(pg, 0, 0, width, height);
    pop();

    logoRightLower(#ff0000);
  }

  void dayTime(PGraphics pg) {
    //float checkD=dist(mouseX, mouseY, sliderX, 33);
    int offscreenX = (int)map(mouseX, 0, width, 0, pg.width);
    int offscreenY = (int)map(mouseY, 0, height, 0, pg.height);
    float checkD=dist(offscreenX, offscreenY, sliderX, 33);

    if (mousePressed && checkD<=bounds/2) {//allows user to grab slider, which affects day time
      //sliderX=mouseX;
      sliderX=offscreenX;
      bounds=pg.width;
    } else {
      bounds=15;
    }//end slider grab check

    sliderX=constrain(sliderX, 20, 120);//constrains slider to slide bar

    trans=int(map(sliderX, 20, 120, 0, 200));//maps transparency of "day" rectangle to slider position

    pg.fill(128);
    pg.textSize(24);
    pg.text("Time", 35, 3, 100, 40);

    pg.fill(0, 0, 255);
    pg.rect(20, 30, 100, 6);

    pg.fill(255, 0, 0);
    pg.ellipse(sliderX, 33, 15, 15);
  }//end dayTime()


  void lightSwitch(PGraphics pg) {
    int offscreenX = (int)map(mouseX, 0, width, 0, pg.width);
    int offscreenY = (int)map(mouseY, 0, height, 0, pg.height);
    float checkOn=dist(offscreenX, offscreenY, 700, 50);
    float checkOff=dist(offscreenX, offscreenY, 770, 50);

    //two buttons to toggle train light on/off
    if (mousePressed & checkOn<40) {
      light=true;
    }
    if (mousePressed & checkOff<40) {
      light=false;
    }//end mouse check

    pg.fill(128);
    pg.textSize(24);
    pg.text("Lights", 705, 3, 100, 40);

    pg.fill(0, 255, 0);
    pg.ellipse(700, 50, 40, 40);

    pg.fill(255, 0, 0);
    pg.ellipse(770, 50, 40, 40);
  }//end lightSwitch

  class Beam {
    int x, y, recAngle;
    float recX, recY;

    Beam(int tx, int ty) {
      x=tx;
      y=ty;
    }//end constructor

    void update() {
      //rotates main beam around origin (x, y)
      recAngle+=8;
      recX=(70/2)*cos(radians(recAngle));
      recY=(70/2)*sin(radians(recAngle));
    }//end update()

    void display(PGraphics pg) {
      pg.fill(200);
      pg.pushMatrix();
      pg.translate(x, y);
      pg.rect(recX, recY, 150, 10);//entire rect rotates around point
      pg.beginShape();
      //only a portion rotates
      pg.vertex(recX+150, recY);
      pg.vertex(recX+150, recY+10);
      //part is grounded to train
      pg.vertex(262, 10);
      pg.vertex(262, 0);
      pg.vertex(recX+150, recY);
      pg.endShape();
      // rect(512, 0, 10, 10);
      pg.popMatrix();
    }//end display()
  }//end class Beam
  class Bugs {
    int x, y;

    Bugs() {
      x=int(random(screenW));
      y=int(random(screenH));
    }//end constructor

    void update() {
      //bugs just kinda jitter
      x=int(random(x-3, x+4));
      y=int(random(y-3, y+4));
      //they stay on screen
      x=constrain(x, 0+5, screenW-5);
      y=constrain(y, 0+5, screenH-5);
    }//end update()

    void display(PGraphics pg) {
      pg.noStroke();
      pg.fill(250, 255, 0, 128);
      pg.ellipse(x, y, 10, 10);
      pg.fill(255);
      pg.ellipse(x, y, 5, 5);
      pg.stroke(0);
      pg.strokeWeight(1);
    }//end display()
  }//end class Bugs
  class Smoke {
    int grayCol;
    int size;
    int x, y;

    Smoke(int tx) {
      grayCol=int(random(150, 165));//random color
      size=int(random(10, 29));//random size
      x=int(random(tx+33, tx+42));//slightly random x position, the starting position is scattered so it doesn't clump in the beginning
      y=37-int(map(tx, 0, 500, 100, 0));//y is mapped to different heights so they don't start in a straight line
      grayCol=int(random(150, 165));//random color
    }//end constructor

    void update() {
      if (y-size/2<17) {//x only changes once it leaves the smoke stack
        x-=random(5, 10);//x decreases by a random amount, but is always moving
      }//end out of stack check
      y-=random(5);//y decreases by a random amount

      if (x+size/2<-0) {
        x=int(random(533, 542));
        y=37;
      }//end out of bound check
    }//end update()

    void display(PGraphics pg) {
      pg.noStroke();
      pg.fill(grayCol, 140 + y);
      pg.ellipse(x, y-20, size, size);
      pg.stroke(0);
      pg.strokeWeight(1);
    }//end display()
  }//end class Smoke

  class Track {
    int x, y;

    Track(int tx, int ty) {
      x=tx;
      y=ty;
    }//end constructor

    void update() {
      x-=5;
      if (x<0) {
        x=1130;
      }//end x bound
    }//end update()

    void display(PGraphics pg) {
      pg.fill(230);
      pg.pushMatrix();
      pg.translate(x, y+80);
      pg.rect(0, 0, 25, 7);
      pg.popMatrix();
    }//end display()
  }//end class Track
  class Train {

    Wheel[] wheelz=new Wheel[4];
    Wheel tiny;
    Beam bob;
    Smoke[] sam=new Smoke[500];

    Train() {
      for (int i=0; i<wheelz.length; i++) {
        wheelz[i]=new Wheel(250+i*75, 212, 75);
      }//end wheelz for
      tiny=new Wheel(615, 227, 45);
      bob=new Beam(248, 208);
      for (int i=0; i<sam.length; i++) {
        sam[i]=new Smoke(i);
      }//end sam setup for
    }//end constructor

    void display(PGraphics pg) {
      //engineer
      pg.fill(220, 160, 160);
      // neck
      pg.rect(190, 102, 9, 20);
      // nose
      pg.ellipse(198, 102, 15, 5);
      // head
      pg.ellipse(195, 99, 15, 20);
      // eye
      pg.fill(30);
      pg.ellipse(200, 98, 2, 2);
      // body
      pg.fill(80, 140, 170);
      pg.rect(188, 110, 14, 50);
      // cap
      pg.rect(187, 86, 15, 8);
      // peak
      pg.rect(187, 92, 22, 2);
      // arm
      pg.pushMatrix();
      pg.translate(-10, 64);
      pg.rotate(-.3);
      pg.rect(178, 104, 8, 25);
      pg.popMatrix();

      //cab area
      pg.fill(0);
      pg.rect(55, 190, 175, 25);
      // hitch
      pg.rect(10, 216, 80, 10);
      pg.rect(0, 214, 20, 14);
      pg.fill(31, 219, 41);
      pg.rect(75, 25, 25, 165);
      pg.rect(250, 25, 25, 165);
      pg.rect(100, 25, 150, 25);
      pg.rect(100, 125, 150, 65);
      pg.fill(0);
      pg.rect(45, 10, 230, 20);

      //tank
      pg.fill(28, 250, 40);
      pg.rect(275, 100, 300, 75);
      pg.fill(220, 255, 0);
      pg.rect(575, 105, 5, 65);
      pg.rect(580, 110, 5, 55);
      pg.rect(585, 115, 5, 45);

      //back whistle
      pg.fill(220);
      pg.beginShape();
      pg.vertex(287, 100);
      pg.vertex(287, 85);
      pg.vertex(300, 75);
      pg.vertex(340, 75);
      pg.vertex(353, 85);
      pg.vertex(353, 100);
      pg.endShape();
      pg.fill(0);
      pg.beginShape();
      pg.vertex(300, 75);
      pg.vertex(300, 40);
      pg.vertex(315, 25);
      pg.vertex(325, 25);
      pg.vertex(340, 40);
      pg.vertex(340, 75);
      pg.endShape();
      pg.fill(220);
      pg.beginShape();
      pg.vertex(315, 25);
      pg.vertex(320, 15);
      pg.vertex(325, 25);
      pg.endShape();

      //bell
      pg.fill(220, 255, 0);
      pg.ellipse(412, 62, 20, 20);
      pg.beginShape();
      pg.vertex(396, 78);
      pg.vertex(402, 72);
      pg.vertex(402, 62);
      pg.vertex(422, 62);
      pg.vertex(422, 72);
      pg.vertex(428, 78);
      pg.vertex(396, 78);
      pg.endShape();
      pg.fill(220);
      pg.rect(410, 50, 4, 45);
      pg.fill(0);
      pg.rect(390, 95, 44, 5);

      //front whistle
      pg.fill(220);
      pg.beginShape();
      pg.vertex(460, 100);
      pg.vertex(460, 85);
      pg.vertex(465, 80);
      pg.vertex(505, 80);
      pg.vertex(510, 85);
      pg.vertex(510, 100);
      pg.endShape();
      pg.fill(0);
      pg.rect(465, 45, 40, 35);
      pg.fill(220);
      pg.beginShape();
      pg.vertex(465, 45);
      pg.vertex(475, 35);
      pg.vertex(495, 35);
      pg.vertex(505, 45);
      pg.endShape();
      pg.fill(255);
      pg.beginShape();
      pg.vertex(475, 35);
      pg.vertex(485, 20);
      pg.vertex(495, 35);
      pg.endShape();

      for (int i=0; i<sam.length; i++) {
        sam[i].update();
        sam[i].display(pg);
      }//end sam updating

      //smokestack
      pg.fill(100);
      pg.rect(525, 50, 25, 50);
      pg.fill(50);
      pg.beginShape();
      pg.vertex(525, 50);
      pg.vertex(512, 37);
      pg.vertex(525, 20);
      pg.vertex(550, 20);
      pg.vertex(563, 37);
      pg.vertex(550, 50);
      pg.endShape();
      pg.fill(100);
      pg.rect(523, 17, 29, 3);

      //lantern
      pg.fill(0);
      pg.rect(550, 50, 20, 3);
      pg.rect(550, 85, 20, 3);
      pg.fill(31, 219, 41);
      pg.rect(570, 43, 30, 50);
      pg.fill(220, 255, 0);
      pg.rect(570, 93, 30, 3);
      pg.fill(0);
      pg.beginShape();
      pg.vertex(570, 43);
      pg.vertex(575, 37);
      pg.vertex(595, 37);
      pg.vertex(600, 43);
      pg.endShape();
      pg.fill(220, 255, 0);
      pg.rect(575, 32, 20, 5);
      pg.rect(600, 50, 5, 35);

      //bottom thingy
      pg.fill(50);
      pg.rect(525, 175, 50, 25);
      pg.fill(20);
      pg.rect(575, 185, 63, 25);
      pg.fill(0);
      pg.rect(638, 185, 12, 25);
      pg.rect(512, 200, 75, 25);
      pg.fill(100);
      pg.rect(587, 210, 25, 5);
      pg.fill(185, 122, 87);
      pg.beginShape();
      pg.vertex(650, 185);
      pg.vertex(650, 225);
      pg.vertex(710, 225);
      pg.vertex(650, 185);
      pg.endShape();
      pg.fill(0);
      pg.beginShape();
      pg.vertex(570, 130);
      pg.vertex(570, 135);
      pg.vertex(645, 190);
      pg.vertex(650, 190);
      pg.vertex(570, 130);
      pg.endShape();

      //wheels/beam
      for (int i=0; i<wheelz.length; i++) {
        wheelz[i].update();
        wheelz[i].display(pg);
      }//end wheelz update for
      tiny.update();
      tiny.display(pg);
      bob.update();
      bob.display(pg);
    }//end display()
  }//end class Train

  class Wheel {
    int wheelRot;
    int x, y, size;

    Wheel(int tx, int ty, int tsize) {
      x=tx;
      y=ty;
      size=tsize;
    }//end constructor

    void update() {
      wheelRot-=3;// sets rotation
    }//end update

    void display(PGraphics pg) {
      pg.pushMatrix();
      pg.translate(x, y);//translates it to where it needs to go
      pg.rotate(wheelRot);//rotates it
      pg.fill(100);
      pg.ellipse(0, 0, size, size);//wheel
      pg.fill(185, 122, 87);
      pg.rectMode(CENTER);//makes it easier to draw
      //toggles
      pg.rect(0, 0, size/7, size);
      pg.rect(0, 0, size, size/7);
      pg.rectMode(CORNER);//so it doesn't f with the rest of the sketch
      pg.popMatrix();
    }//end display()
  }

  @Override void mousePressed() {
    //gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
