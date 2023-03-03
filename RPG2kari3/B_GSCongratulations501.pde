// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Sayamaさん
// 【作品名】SeasonalSnowDome
// https://openprocessing.org/sketch/803047
//

class GameSceneCongratulations501 extends GameSceneCongratulationsBase {
  PGraphics gra;
  ArrayList<P> lists = new ArrayList();
  float power = 0;
  float pNum = 100;//パーティクルの数
  boolean touching = false;
  int size;

  //画像
  PImage maskImg;
  PImage bgImg;
  PImage partImg;
  PImage[] partImgs = new PImage[4*4];
  PImage bgColorImg;

  //季節
  float season = 0;//春 = 0,夏 = 1,秋　 = 2, 冬 = 3

  void preload() {
    maskImg = loadImage("data/501/mask.png");//マスク画像●1000*1000px
    bgImg = loadImage("data/501/background.png");//背景画像●1000*1000px
    partImg = loadImage("data/501/particle.png");//パーティクル画像●1080*1080px 4*4

    int partW = partImg.width / 4;
    int partH = partImg.height / 4;
    for (int season = 0; season < 4; season++) {
      for (int index = 0; index < 4; index++) {
        PImage pImg = createImage(partW, partH, ARGB);
        for (int dy = 0; dy < partH; dy++) {
          for (int dx = 0; dx < partW; dx++) {
            int sx = index * partW + dx;
            int sy = season * partH + dy;
            color c = partImg.get(sx, sy);
            pImg.set(dx, dy, c);
          }
        }
        partImgs[season * 4 + index] = pImg;
      }
    }

    bgColorImg = loadImage("data/501/bgColor.png");//背景色指定画像●適当なサイズ 0-24時の背景の色を横方向のグラデーションで指定
  }

  @Override void setup() {
    preload();
    size = floor(min(width, height)*0.9);
    gra = createGraphics(size, size);

    for (float i = 0; i < pNum; i++) {
      P p = new P(size);
      lists.add(p);
    }
  }
  @Override void draw() {
    push();
    noStroke();
    imageMode(CENTER);
    rectMode(CENTER);

    //月を取得
    float m = month();
    //条件分岐で季節を設定●
    if (m >=3 && m <= 5) {
      season = 0;
    } else if (m >= 6 && m <= 8) {
      season = 1;
    } else if (m >= 9 && m <= 11) {
      season = 2;
    } else {
      season = 3;
    }
    //season = 0;//コメントアウトを外して任意の季節を指定●

    gra.beginDraw();
    gra.clear();
    background(0, 0, 0); //背景色(マスク画像と色を合わせる)●
    if (touching && power < 3) {
      power +=0.1;
    }

    partImg.loadPixels();
    for (int i = 0; i < lists.size(); i++) {
      lists.get(i).act();
    }
    partImg.updatePixels();
    gra.endDraw();

    //時間情報の整理
    float sec = second() ;
    float min = minute() + sec /60;//分（小数点以下も含）
    float ho = hour() + min/60;//時間（小数点以下も含）

    //空の色の設定
    color bgColor;
    bgColor = bgColorImg.get(int(ho/24.0f * bgColorImg.width), 10); //24時間で一周
    fill(bgColor);//空の色
    stroke(0);//境界線対策 マスク画像と色を合わせる●
    float x = floor(width/2.0f);
    float y = floor(height/2.0f);
    rect(x, y, size, size);//空
    image(bgImg, x, y, size, size);//　　背景画像
    image(gra, x, y);//パーティクル
    image(maskImg, x, y, size, size);//マスク
    pop();

    logoRightLower(#ff0000);
  }

  //  パーティクルクラス
  class P {
    float x, y, yA;
    float spinX, spinY;
    float rot;

    int size;
    int index;

    float xV, yV;
    float spinXV, spinYV;
    float rotV;

    P(int sss) {
      //ポジション
      this.x = random(gra.width);
      this.y = random(gra.height);
      this.yA = random(0.009);//加速度●

      //スピン
      this.spinX = random(360);
      this.spinY = random(360);

      //回転
      this.rot = random(360);
      this.setV(1);

      //サイズ
      this.size = int(sss/50.0f+random(sss/60.0f));//数字を変えると大きさが変わる●

      //画像インデックス
      this.index = floor(random(3.99));
    }

    //スピードをセット
    void setV(float s) {
      //ポジション
      this.xV = (random(1)-0.5)*s/2.0f;
      this.yV = (random(1)*-1 - 0.1)*s;
      //スピン
      this.spinXV = random(2) + 1;
      this.spinYV = random(2) + 1;
      //回転
      this.rotV = random(1) + 0.5;
    }


    void jump(float s) {
      this.y -= random(5)+0.5;
      this.setV(s);
    }

    //  描画
    void act() {
      //  各種パラメータ計算
      this.spinX += this.spinXV+ abs(this.yV);
      this.spinY += this.spinYV+ abs(this.yV);
      this.rot += this.rotV + abs(this.yV)*2;
      this.x += this.xV;
      this.yV += this.yA;
      this.y += this.yV;


      //  雪の描画
      gra.push();
      gra.translate(this.x, this.y);
      gra.scale(sin(radians(this.spinX)), sin(radians(this.spinY)));
      gra.rotate(radians(this.rot));
      //gra.image(partImg, 0, 0, this.size, this.size, this.index*partImg.width/4, season*partImg.height/4, partImg.width/4, partImg.height/4 );
      PImage pImg = partImgs[int(season * 4 + this.index)];
      gra.image(pImg, 0, 0, this.size, this.size);
      gra.pop();

      if (this.x >= gra.width || this.x <= 0) {
        this.xV *= -1;
      }

      if (this.y <=0) {
        this.yV *= -0.5;
        this.y += 1;
      }

      if (this.y >= gra.height) {
        //  地面より下の場合は停止
        this.xV = 0;
        this.y = gra.height;
        this.yV = 0;
        this.rotV = 0;
        this.spinXV = 0;
        this.spinYV = 0;
      }
    }
  }

  @Override void mousePressed() {
    touching = true;
  }
  @Override void mouseReleased() {
    touching = false;
    for (int i = 0; i < lists.size(); i++) {
      lists.get(i).jump(power);
    }
    power = 0;
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
