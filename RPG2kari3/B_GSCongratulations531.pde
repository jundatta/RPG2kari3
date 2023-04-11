// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Richard Bourneさん
// 【作品名】Windy Sea
// https://openprocessing.org/sketch/1877690
//

class GameSceneCongratulations531 extends GameSceneCongratulationsBase {
  int a = 0;
  int b = 300;
  int ln = 0;
  int delai = 0;
  int often = 100;

  PGraphics pg;

  @Override void setup() {
    pg = createGraphics(1112, 834);

    pg.beginDraw();
    pg.background(14, 60, 100);
    pg.smooth();
    pg.endDraw();
  }
  @Override void draw() {
    push();
    pg.beginDraw();
    pg.background(14, 60, random(95, 105), 255); //flashing background

    if (frameCount%often == 0) {
      ln = 1;
      delai = frameCount;
    }
    if (frameCount - delai > 10) {
      ln = 0;
    }
    //water backgroundcolor and rects
    pg.noStroke();
    //background lightning flash
    if (mousePressed || ln != 0) {
      pg.background(255);
    }

    //moon
    pg.fill(255);
    if (mousePressed || ln != 0) {
      pg.fill(a);
    }                          //I used some variables for the color vv
    pg.ellipse(150, b-150, 100, 100);
    //color for water
    pg.fill(#DEE5FA, 50); //right behind boat

    // ocean
    pg.fill(#7884A7, 50);//left under behind boat
    pg.rotate(sin(frameCount * .009)*-.11);
    pg.rect(pg.width/2-100, 550, pg.width*1.3, b);

    //see here for some variables^^

    //rain

    //I randomized the ends of them so it would look like it was
    //actually raining. I think it turned out pretty well.
    pg.strokeWeight(3);
    pg.stroke(150, 10);
    for (int i=0; i <pg.width; i += random(11, 30)) {
      pg.line(i, 0, i+i/2, random(600, 800));
    }

    pg.strokeWeight(2);
    pg.stroke(255, 25);
    for (int i=-300; i <pg.width; i += random(11, 30)) {
      pg.line(i, 0, i+370, random(600, 800));
    }

    pg.strokeWeight(1);
    pg.stroke(0, 50);
    for (int i=-700; i <pg.width; i += random(11, 30)) {
      pg.line(i, 0, i+700, random(600, 800));
    }

    //water lines

    //I did the same as I did with the rain to the ends of
    //the water lines to make it seem like it was moving
    //and/or the rain was hitting the water.
    pg.stroke(40);

    pg.fill(#020936);

    //lightning strike
    if (mousePressed || ln != 0) { //turn on when click
      pg.strokeWeight(10);

      //lightningbackground
      pg.pushMatrix();
      pg.translate(1, 1);
      pg.strokeWeight(10);
      pg.line(500, 0, 600, 120);
      pg.strokeWeight(9);
      pg.line(600, 120, 530, 150);
      pg.strokeWeight(7);
      pg.line(530, 150, 570, 200);
      pg.strokeWeight(5);
      pg.line(570, 200, 490, 300);
      pg.strokeWeight(3);
      pg.line(490, 300, 520, 350);
      pg.strokeWeight(2);
      pg.line(520, 350, 380, 500);

      pg.popMatrix();
      //lightning main
      pg.stroke(#F6FFB4);
      pg.strokeWeight(10);
      pg.line(500, 0, 600, 120);
      pg.strokeWeight(9);
      pg.line(600, 120, 530, 150);
      pg.strokeWeight(7);
      pg.line(530, 150, 570, 200);
      pg.strokeWeight(5);
      pg.line(570, 200, 490, 300);
      pg.strokeWeight(3);
      pg.line(490, 300, 520, 350);
      pg.strokeWeight(2);
      pg.line(520, 350, 380, 500);
    }


    pg.strokeWeight(4);
    //boat function/variable
    pg.pushMatrix();
    pg.rotate(radians(-20));
    boat(pg, 350, 590);
    pg.popMatrix();

    //splashes
    //same random effect on the splashes up on the boat
    pg.pushMatrix();
    pg.rotate(radians(-20));
    pg.strokeWeight(2);
    pg.stroke(230);

    pg.popMatrix();

    pg.endDraw();
    image(pg, 0, 0, width, height);
    pop();

    logoRightLower(#ff0000);
  }

  void boat(PGraphics pg, int x, int y) {
    pg.pushMatrix();

    pg.translate(x+100, y+40);
    // rock the ship!
    pg.rotate(.35+sin(frameCount*.01)*.14);
    // mostly all of the if (mousePressed)'s are used to change
    //the stroke/fill colors to black or white to make a
    //silhouette of the ship

    if (mousePressed || ln != 0) {
      pg.fill(255);
    }

    pg.stroke(#482103);
    if (mousePressed || ln != 0) {
      pg.stroke(0);
    }

    //bow
    for (int i=0; i <100; i += 4) {
      pg.line(i, 0, i, 100-i);
    }
    //middle
    for (int i=-300; i <0; i += 4) {
      pg.line(i, 0, i, 100);
    }
    //poop deck
    for (int i=-360; i <-200; i += 5) {
      pg.line(i-25, -40, i/2, 50);
    }
    pg.stroke(#482103);
    if (mousePressed || ln != 0) {
      pg.stroke(0);
    }
    //cap. quarters
    for (int i=-350; i <-280; i += 5) {
      pg.line(i, -30, i, 50-i/20);
    }
    pg.stroke(#B79E8B);
    if (mousePressed || ln != 0) {
      pg.stroke(0);
    }
    //middle sail
    for (int i=-200; i <100; i +=10) {
      pg.line(-120, -100 +i/2, -50, -150+ i);
    }
    //back sail
    for (int i=-150; i <80; i +=10) {
      pg.line(-210, -100 +i/2, -150, -150+ i);
    }
    //front sail
    for (int i=-70; i <120; i +=10) {
      pg.line(-40, -100 +i/2, 20, -150+ i);
    }
    //triangle sail
    for (int i=30; i <100; i += 10) {
      pg.line(i, -30, i, -120+i);
    }
    //poop deck sail
    for (int i=-350; i <-220; i += 10) {
      pg.line(i, -70, i, -180-i/5);
    }

    //cannon holes
    pg.strokeWeight(2);
    for (int i=-240; i <-10; i += 25) {
      pg.rect(i, 40, 10, 15);
    }

    //cap. quart. windows
    pg.strokeWeight(2);
    for (int i=-350; i <-260; i += 25) {
      pg.rect(i, -20, 20, 40);
    }


    //masts (front, back, middle)
    pg.strokeWeight(4);
    pg.stroke(#482103);
    if (mousePressed || ln != 0) {
      pg.stroke(0);
    }
    pg.line(-30, 0, -30, -130);
    pg.line(-190, 0, -190, -200);
    pg.line(-100, 0, -100, -265);

    pg.stroke(#B79E8B);
    if (mousePressed || ln != 0) {
      pg.stroke(0);
    }
    //poop deck railing
    for (int i=-380; i <-220; i += 10) {
      pg.line(i, -50, i, -50);
    }
    //railing
    for (int i=-170; i <100; i += 10) {
      pg.line(i, -10, i, -10);
    }

    pg.popMatrix();
    pg.rotate(.35+sin(frameCount*.02)*.05);
    pg.fill(#485487, 230);//left under behind boat
    pg.noStroke();
    pg.rectMode(CENTER);
    pg.rect(pg.width/2-100, 710, pg.width*1.4, pg.height/2);
  }
  @Override void mousePressed() {
    //gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
