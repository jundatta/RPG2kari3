// コングラチュレーション画面
//
// オリジナルはこちらです。
// 【作者】はぅ君さん
// 【作品名】つぶやきCoding | 2023/03/02 by はぅ君
// https://twitter.com/Hau_kun/status/1631295483539849219
//

class GameSceneCongratulations505 extends GameSceneCongratulationsBase {
  float t=0;
  float W = 720;
  @Override void setup() {
  }
  @Override void draw() {
    push();
    t+=.05;
    colorMode(HSB, 360, 100, 100);
    noStroke();
    background(0);
    for (float y=0; y<W; y+=89) {
      for (float x=0; x<W; x+=2) {
        float R = x/17*PI+t*4;
        float S = sin(R)*30;
        fill(y/2.0f, 70+S, 70-S);
        float X = x*2%W;
        float Y = 360+sin(X/99.0f+y/9.0f+t/y*150)/5.0f*y+pow(noise(X/99.0f+t/2.0f, y), 5)*99;
        square(X, Y, sin(R/2.0f)*(y/90.0f+12));
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
