// コングラチュレーション画面
//
// オリジナルはこちらです。
// 【作者】中内　純(ハンドルネーム：JunKiyoshi)さん
// 【作品名】Waving. Draw by openFrameworks
// https://junkiyoshi.com/2023/04/04/
//

class GameSceneCongratulations524 extends GameSceneCongratulationsBase {
  ofMesh face = new ofMesh();
  ofMesh line = new ofMesh();

  //--------------------------------------------------------------
  @Override void setup() {
  }

  //--------------------------------------------------------------
  void update() {
    ofSeedRandom(39);

    face.clear();
    line.clear();

    var noise_param = new PVector(random(360), random(360), random(360));

    for (int radius = 50; radius <= 300; radius += 5) {
      var rotation = new PVector(
        map(openFrameworksNoise.ofNoise(noise_param.x, radius * 0.005 - ofGetFrameNum() * 0.03), 0, 1, -30, 30),
        map(openFrameworksNoise.ofNoise(noise_param.y, radius * 0.005 - ofGetFrameNum() * 0.03), 0, 1, -30, 30),
        map(openFrameworksNoise.ofNoise(noise_param.z, radius * 0.005 - ofGetFrameNum() * 0.03), 0, 1, -30, 30));

      PMatrix3D rotation_x = new PMatrix3D();
      rotation_x.rotateX(rotation.x * DEG_TO_RAD);
      PMatrix3D rotation_y = new PMatrix3D();
      rotation_y.rotateY(rotation.y * DEG_TO_RAD);

      int start_index = line.getNumVertices();
      int index = start_index;
      for (int deg = 0; deg < 360; deg += 1) {
        var vertex = new PVector(radius * cos(deg * DEG_TO_RAD), radius * sin(deg * DEG_TO_RAD), 0);
        if (radius % 100 != 0) {
          vertex = rotation_x.mult(vertex, null);
          vertex = rotation_y.mult(vertex, null);
        }

        face.addVertex(vertex);
        line.addVertex(vertex);
        if (deg > 0) {
          line.addIndex(index - 1);
          line.addIndex(index);
        }
        index++;
      }
      line.addIndex(line.getNumVertices() - 1);
      line.addIndex(start_index);
    }

    int index_span = 1;
    for (int index = 0; index < face.getNumVertices() - 361; index += index_span) {
      face.addIndex(index);
      face.addIndex(index + 1);
      face.addIndex(index + 361);
      face.addIndex(index);
      face.addIndex(index + 361);
      face.addIndex(index + 360);
    }

    index_span = 30;
    for (int index = 0; index < line.getNumVertices() - 360; index += index_span) {
      line.addIndex(index);
      line.addIndex(index + 360);
    }
  }

  //--------------------------------------------------------------
  @Override void draw() {
    push();
    update();
    translate(width * 0.5f, height * 0.5f);

    background(239);

    ofSetLineWidth(1);

    //ofRotateZ(ofGetFrameNum());
    ofRotateX(45);

    face.draw(color(0));

    line.drawWireframe(color(255));
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
