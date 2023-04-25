// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】Richard Bourneさん
// 【作品名】Nut Job
// https://openprocessing.org/sketch/1905890
//

class GameSceneCongratulations533 extends GameSceneCongratulationsBase {
  PShape normalNutMesh;

  void preload() {
    normalNutMesh = loadShape("data/533/cube.obj");
  }

  @Override void setup() {
    preload();
    background(100);
    noStroke();
  }
  @Override void draw() {
    push();
    translate(width * 0.5f, height * 0.5f);

    scale(1.6);
    background(100);
    // より金属感をフェイクするために陰影を際立たせるようにしました＼(^_^)／
    // （⇒specular()が効いてる気がしにゃいのでｗ）
    // １．デフォルトのライティング（lights()）をやめました。
    //lights();
    // ２．環境光をやめました。
    //ambientLight(200, 200, 200);
    // ３．点光源をナットの近くに置いて、反射角が少しでもきつくなるようにしました。
    // （⇒鏡面反射のピキーン感をフェイクしました）
    //directionalLight(100, 100, 100, width, 0, 50);
    // ４．ライトを増やして明るいところがより明るくなるようにしました。
    // （⇒あまりやりすぎると白飛びするので加減大事ｗ）
    directionalLight(150, 150, 150, width, 0, -50);
    pointLight(150, 150, 150, width, 0, +300);
    pointLight(150, 150, 150, width, 0, +300);
    pointLight(150, 150, 150, width, 0, +300);
    rotateY(millis() * 0.0005);
    rotateX(millis() * 0.0002);
    //specularMaterial(50);
    specular(50);
    shape(normalNutMesh);
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
