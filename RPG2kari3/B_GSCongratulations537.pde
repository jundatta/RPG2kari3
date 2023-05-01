// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】kari_najさん
// 【作品名】期末
// https://openprocessing.org/sketch/1830303
//

class GameSceneCongratulations537 extends GameSceneCongratulationsBase {
  PGraphics pg;
  final int orgW = 1120;
  final int orgH = 678;

  @Override void setup() {
    pg = createGraphics(orgW, orgH);
    pg.beginDraw();
    pg.background(31, 31, 39, 255);
    pg.noStroke();

    //gradient SKY
    var Q = 560;
    var Q2 = 510;

    pg.fill(35, 38, 46, 225);
    pg.ellipse(Q, Q2, 1300, 1300);
    pg.fill(195, 200, 203, 40);
    pg.ellipse(Q, Q2, 1120, 1120);
    pg.fill(229, 229, 217, 40);
    pg.ellipse(Q, Q2, 800, 800);
    pg.fill(244, 235, 204, 40);
    pg.ellipse(Q, Q2, 500, 500);

    pg.fill(252, 242, 189, 40);
    pg.ellipse(384, 404, 60, 60);//月
    var w = 15;
    pg.fill(255, 255, 255, 255);
    pg.ellipse(384, 404, w, w);//月

    //ほし
    for ( var i = 0; i<150; i++) {
      pg.stroke(255);
      pg.strokeWeight(2);
      pg.point(random(-5, 1120), random(-5, 510));
    }

    //////////////////////////

    pg.noStroke();
    //left cloud
    var T = random(0, 300);
    var U = random(300, 510);

    pg.fill(64, 67, 60, 150);//雲
    pg.rect(T, U, 150, 200);

    var T2 = random(0, 300);
    var U2 = random(300, 510);
    //雲
    pg.rect(T2, U2, 150, 200);

    var T3 = random(0, 300);
    var U3 = random(300, 510);

    pg.rect(T3, U3, 150, 200);

    var T4 = random(0, 300);
    var U4= random(300, 510);

    pg.rect(T4, U4, 150, 200);

    var T5 = random(0, 300);
    var U5 = random(300, 510);//雲

    pg.rect(T5, U5, 150, 200);
    var T6 = random(0, 300);
    var U6 = random(300, 510);

    pg.rect(T6, U6, 150, 200);

    var T7 = random(0, 300);
    var U7 = random(300, 510);

    pg.rect(T7, U7, 150, 200);

    ////////////////////////////////////////

    //right cloud

    var R = random(600, 1120);
    var S = random(300, 510);

    pg.fill(64, 67, 60, 150);
    pg.rect(R, S, 150, 200);

    var R2 = random(600, 1120);
    var S2 = random(300, 510);

    pg.rect(R2, S2, 150, 200);

    var R3 = random(600, 1120);
    var S3 = random(300, 510);

    pg.rect(R3, S3, 150, 200);

    pg.rect(T4, U4, 150, 200);

    var R5 = random(600, 1120);
    var S5 = random(300, 510);

    pg.rect(R5, S5, 150, 200);

    pg.rect(T6, U6, 150, 200);

    var R7 = random(600, 1120);
    var S7 = random(200, 540);

    pg.rect(R7, S7, 150, 200);

    ////////////////////////////////////

    //top left clouds
    var I = random(170, 400);
    var V = random(13, 200);

    pg.rect(I, V, 70, 50);
    pg.rect(I+30, V+30, 70, 50);
    pg.rect(I+100, V+50, 70, 50);

    var I4 = random(170, 400);
    var V4 = random(13, 200);
    pg.rect(I4, V4, 70, 50);

    ///////////////////////////////////
    //top right clouds
    var C = random(600, 1000);
    var D = random(13, 200);

    pg.rect(C, D, 70, 50);
    pg.rect(C+50, D+20, 70, 50);
    pg.rect(C+70, D+100, 70, 50);

    pg.rect(I4, V4, 70, 50);

    pg.fill(36, 45, 52, 255);//海
    pg.rect(0, 510, 1120, 226);//海
    pg.endDraw();
  }
  float K = 0;
  @Override void draw() {
    push();
    pg.beginDraw();
    var X= 112;
    var Y= 113;

    ////////////////////////////////////////////////
    //BACKGROUND

    pg.noStroke();
    //建物
    pg.noStroke();
    pg.fill(25, 34, 40, 255);
    pg.rect(K, 510, random(-3, -15), random(-3, -17));
    K = K + random(3, 13);

    ////////////////////////////////////////////////

    //小さい船

    //小さい船 1
    pg.noStroke();
    pg.fill(25, 34, 40, 255);
    pg.triangle(459, 570, 444, 555, 474, 555);// back
    pg.rect(444, 555, 30, -7);
    //side bottom
    pg.quad(459, 570, 444, 555, 424, 555, 427, 558);
    //side top
    pg.rect(424, 555, 20, -7);

    pg.rect(444, 548, 15, -4);//guy sitting in the boat

    pg.rect(449, 544, 7, -5);

    //小さい 船 2
    pg.strokeWeight(4);
    pg.stroke(25, 34, 40, 255);
    pg.line(80, 530, 80, 360);//v poll
    pg.noStroke();
    pg.triangle(56, 460, 79, 450, 79, 530);// sail
    pg.strokeWeight(1);
    pg.stroke(25, 34, 40, 255);
    pg.line(56, 460, 80, 450);//sail poll
    pg.noStroke();
    pg.quad(35, 5*113-30, 85, 5*113-30, 65, 5*113-50, 20, 5*113-50);//back
    pg.fill(25, 34, 40, 255);
    pg.quad(85, 5*113-30, 65, 5*113-50, 100, 530, 100, 5*113-30);// side

    //small boat 3
    pg.fill(25, 34, 40, 255);
    pg.quad(1028, 576, 988, 566, 1038, 566, 1110, 576);//inside
    pg.strokeWeight(4);
    pg.stroke(25, 34, 40, 255);
    pg.line(1068, 576, 1068, 379);//poll
    pg.noStroke();
    pg.fill(25, 34, 40, 255);
    pg.quad(1070, 409, 1070, 571, 1100, 546, 1090, 400);
    pg.triangle(1070, 379, 1070, 561, 1080, 566);//sail
    pg.rect(1038, 566, 15, 10);//guy sitting in the boat
    pg.rect(1043, 562, 5, 4);

    pg.noStroke();
    pg.quad(1008, 596, 1090, 596, 1110, 576, 1028, 576);
    pg.triangle(1110, 576, 1028, 576, 1080, 566);//back
    pg.quad(1028, 576, 1008, 596, 988, 576, 988, 566);//side

    //back boat
    pg.strokeWeight(2);
    pg.stroke(25, 34, 40, 255);
    pg.line(298, 510, 330, 490);
    pg.noStroke();
    pg.fill(25, 34, 40, 255);
    pg.quad(100, 515, 300, 508, 270, 540, 130, 540);//side boat
    pg.triangle(320, 500, 204, 367, 170, 520);//sail

    //////////////////////////

    ///BOAT 2

    //back sail
    pg.fill(25, 34, 40, 255);
    pg.arc(172, 430, 150, 90, radians(9), radians(183));//bottom sail
    pg.arc(177, 370, 130, 120, radians(7), radians(183));//middle sail
    pg.arc(170, 302, 70, 67, radians(0), radians(180));//top

    //  backpoll
    pg.strokeWeight(4);
    pg.stroke(25, 34, 40, 255);
    pg.line(168, 226, 168, 510);// 　v-poll
    pg.line(100+20, 302, 182+20, 302);// short h-poll
    pg.line(70+20, 374, 234+20, 346+30);//  中　h-poll
    pg.line(X-40, Y*4-30, X*2+56, Y*4-10);//long poll

    //sail
    pg.noStroke();
    pg.fill(25, 34, 40, 255);
    pg.arc(145, 275, 74, 80, radians(355), radians(170));//top sail
    pg.arc(150, 351, 120, 140, radians(355), radians(175));//middle sail

    //front poll
    pg.strokeWeight(4);
    pg.stroke(25, 34, 40, 255);
    pg.line(148, 163, 148, 510);//the longest v-poll#2
    pg.line(100, 282, 182, 272);// short h-poll
    pg.line(70, 360, 234, 343);//  中　h-poll
    pg.line(56, 414, 264, 397);//長い　h-poll
    pg.strokeWeight(2);
    pg.stroke(25, 34, 40, 255);
    pg.line(147, 440, 128, 370);

    pg.noStroke();
    pg.fill(25, 34, 40, 255);
    pg.triangle(147, 440, 128, 370, 147, 480);//sail in the back

    //boat
    pg.noStroke();
    pg.fill(25, 34, 40, 255);
    pg.rect(100, 510, 90, 30);
    pg.quad(100, 540, 190, 540, 210, 560, 120, 560);//back of the boat2
    pg.rect(170, 510, 40, 30);
    pg.quad(170, 540, 210, 540, 210, 560, 190, 560);//side of boat2

    //lights
    pg.fill(252, 242, 189);
    pg.quad(120, 520, 120, 530, 125, 530, 125, 520);
    pg.quad(130, 520, 130, 530, 135, 530, 135, 520);
    pg.quad(140, 520, 140, 530, 145, 530, 145, 520);

    ////////////////////////////

    //BOAT 1
    //poll behind

    pg.strokeWeight(4);
    pg.stroke(25, 34, 40, 255);
    pg.line(714, 477, 724, 87-10);//　v-poll
    pg.line(556, 374-10, 808, 400-10);//longest h
    pg.line(628, 251-10, 794, 267-10);//中 h-poll
    pg.line(648, 188-5, 755, 193-5);//middle top h-poll

    //sail behind

    pg.noStroke();
    pg.fill(25, 34, 40, 255);
    pg.quad(624, 377-5, 642, 469-5, 786, 469-5, 795, 395-5);//bottom sail
    pg.quad(602, 373-5, 715, 370-5, 715, 256-5, 640, 248-5);//bottom middle sail left
    pg.quad(715, 370-5, 715, 256-5, 774, 262-5, 798, 394-5);//middle sail right
    pg.quad(777, 259-5, 715, 246-5, 715, 192-5, 747, 193-5);//bottom middle sail right
    pg.quad(715, 246-5, 715, 192-5, 653, 188-5, 635, 245-5);//middle sail right
    pg.quad(653, 188-5, 714, 186-5, 714, 145-5, 680, 142-5);//top sail left
    pg.quad(714, 186-5, 714, 145-5, 744, 148-5, 750, 193-5);//sail right

    //boat #1 poll

    pg.strokeWeight(4);
    pg.stroke(25, 34, 40, 255);
    pg.line(754, 472, 754, 82);//　v-poll
    pg.line(606, 369, 848, 395);//longest h
    pg.line(668, 246, 834, 262);//中 h-poll
    pg.line(688, 188, 795, 193);//middle top h-poll

    var Z = 628+826-682+30;

    //boat 1 SAIL
    pg.noStroke();
    pg.fill(25, 34, 40, 255);
    pg.quad(664, 377, 682, 469, 826, 469, 835, 395);//bottom sail

    pg.quad(642, 373, 755, 370, 755, 256, 680, 248);//bottom middle sail left
    pg.quad(755, 370, 755, 256, 814, 262, 838, 394);//middle sail right

    pg.quad(817, 259, 755, 246, 755, 192, 787, 193);//bottom middle sail right
    pg.quad(755, 246, 755, 192, 693, 188, 675, 245);//middle sail right

    pg.quad(693, 188, 754, 186, 754, 145, 720, 142);//top sail left
    pg.quad(754, 186, 754, 145, 784, 148, 790, 193);//sail right

    pg.triangle(Z, 457-80, Z-30, 457, 755, 256);

    //boat
    pg.noStroke();
    pg.fill(25, 34, 40, 255);
    pg.quad(672, 550, 682, 472, 630, 472, 640, 550);//side

    pg.quad(784, 550, 672, 550, 682, 472, 826, 472);//back of boat1
    pg.triangle(682, 472, 826, 472, 628+826-682, 457);
    pg.stroke(25, 34, 40, 255);
    pg.strokeWeight(3);
    pg.line(Z-30, 457, Z, 457-80);

    //lights
    pg.fill(252, 242, 189);
    pg.noStroke();
    pg.quad(780, 515, 775, 515, 780, 490, 785, 490);
    pg.quad(768, 515, 762, 515, 767, 490, 773, 490);
    pg.ellipse(658, 500, 5, 15);
    pg.ellipse(668, 500, 5, 15);
    pg.endDraw();
    image(pg, 0, 0, width, height);
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
