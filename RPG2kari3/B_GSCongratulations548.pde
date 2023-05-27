// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】中内　純(ハンドルネーム：JunKiyoshi)さん
// 【作品名】Ring Tunnel. Draw by openFrameworks
// https://junkiyoshi.com/openframeworks20230520/
//

class GameSceneCongratulations548 extends GameSceneCongratulationsBase {
  ofMesh face = new ofMesh();

  //--------------------------------------------------------------
  @Override void setup() {
  }

  //--------------------------------------------------------------
  void update() {
    ofSeedRandom(39);

    face.clear();

    float threshold_1 = 0.4;
    float threshold_2 = 0.6;
    //float deg_span = 0.25;
    //float z_span = 1;
    float deg_span = 2.0;
    float z_span = 16;

    float radius = 320;
    float noise_span = 0.005;

    for (float deg = 0; deg < 360; deg += deg_span) {
      for (float z = -300; z < 4096; z += z_span) {
        var noise_value = openFrameworksNoise.ofNoise(radius * cos(deg * DEG_TO_RAD) * noise_span, radius * sin(deg * DEG_TO_RAD) * noise_span, z * noise_span + ofGetFrameNum() * 0.075);
        if (noise_value <= threshold_1 || noise_value >= threshold_2) {
          continue;
        }

        var index = face.getNumVertices();
        PVector[] vertices = new PVector[4];

        vertices[0] = new PVector(radius * cos((deg - deg_span * 0.5) * DEG_TO_RAD), radius * sin((deg - deg_span * 0.5) * DEG_TO_RAD), z - z_span * 0.5);
        vertices[1] = new PVector(radius * cos((deg + deg_span * 0.5) * DEG_TO_RAD), radius * sin((deg + deg_span * 0.5) * DEG_TO_RAD), z - z_span * 0.5);
        vertices[2] = new PVector(radius * cos((deg - deg_span * 0.5) * DEG_TO_RAD), radius * sin((deg - deg_span * 0.5) * DEG_TO_RAD), z + z_span * 0.5);
        vertices[3] = new PVector(radius * cos((deg + deg_span * 0.5) * DEG_TO_RAD), radius * sin((deg + deg_span * 0.5) * DEG_TO_RAD), z + z_span * 0.5);

        ArrayList<PVector> pvArray = new ArrayList();
        for (PVector v : vertices) {
          pvArray.add(v);
        }
        face.addVertices(pvArray);

        face.addIndex(index + 0);
        face.addIndex(index + 1);
        face.addIndex(index + 3);
        face.addIndex(index + 0);
        face.addIndex(index + 2);
        face.addIndex(index + 3);
      }
    }
  }

  //--------------------------------------------------------------
  @Override void draw() {
    push();
    update();
    translate(width * 0.5f, height * 0.5f);

    background(239);
    ofSetLineWidth(2);

    ofRotateY(180);

    stroke(color(0));
    face.draw(color(39));
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
