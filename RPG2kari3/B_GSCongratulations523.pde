// コングラチュレーション画面
//
// オリジナルはこちらです。
// 【作者】中内　純(ハンドルネーム：JunKiyoshi)さん
// 【作品名】Square ring. Draw by openFrameworks
// https://junkiyoshi.com/2023/04/03/
//

class GameSceneCongratulations523 extends GameSceneCongratulationsBase {
  ofMesh face = new ofMesh();
  ofMesh frame = new ofMesh();

  //--------------------------------------------------------------
  @Override void setup() {
  }
  //--------------------------------------------------------------
  void update() {
    ofSeedRandom(39);

    face.clear();
    frame.clear();

    var noise_seed = new PVector(random(1000), random(1000));
    for (var radius = 60; radius <= 360; radius += 15) {

      var angle_x = map(openFrameworksNoise.ofNoise(noise_seed.x, ofGetFrameNum() * -0.004 + radius * 0.005), 0, 1, -45, 45);
      var angle_y = map(openFrameworksNoise.ofNoise(noise_seed.y, ofGetFrameNum() * -0.004 + radius * 0.005), 0, 1, -45, 45);
      setRingToMesh(face, frame, new PVector(), radius, 10, 20, angle_x * DEG_TO_RAD, angle_y * DEG_TO_RAD);
    }
  }

  //--------------------------------------------------------------
  @Override void draw() {
    push();
    update();

    translate(width * 0.5f, height * 0.5f);
    background(239);
    ofSetLineWidth(1.5);

    ofRotateX(180);
    ofRotateY(ofGetFrameNum());

    face.draw(color(0));

    frame.drawWireframe(color(255));
    pop();

    logoRightLower(#ff0000);
  }

  //--------------------------------------------------------------
  void setRingToMesh(ofMesh face_target, ofMesh frame_target, PVector location, float radius, float width, float height, float angle_x, float angle_y) {
    //var rotation_x = glm::rotate(glm::mat4(), angle_x, glm::vec3(1, 0, 0));
    //var rotation_y = glm::rotate(glm::mat4(), angle_y, glm::vec3(0, 1, 0));
    PMatrix3D rotation_x = new PMatrix3D();
    rotation_x.rotateX(angle_x);
    PMatrix3D rotation_y = new PMatrix3D();
    rotation_y.rotateY(angle_y);

    int deg_span = 90;
    for (int deg = 0; deg < 360; deg += deg_span) {
      var face_index = face_target.getNumVertices();

      ArrayList<PVector> vertices = new ArrayList();
      vertices.add(new PVector((radius + width * 0.5) * cos(deg * DEG_TO_RAD), (radius + width * 0.5) * sin(deg * DEG_TO_RAD), height * -0.5));
      vertices.add(new PVector((radius + width * 0.5) * cos((deg + deg_span) * DEG_TO_RAD), (radius + width * 0.5) * sin((deg + deg_span) * DEG_TO_RAD), height * -0.5));
      vertices.add(new PVector((radius + width * 0.5) * cos((deg + deg_span) * DEG_TO_RAD), (radius + width * 0.5) * sin((deg + deg_span) * DEG_TO_RAD), height * 0.5));
      vertices.add(new PVector((radius + width * 0.5) * cos(deg * DEG_TO_RAD), (radius + width * 0.5) * sin(deg * DEG_TO_RAD), height * 0.5));

      vertices.add(new PVector((radius - width * 0.5) * cos(deg * DEG_TO_RAD), (radius - width * 0.5) * sin(deg * DEG_TO_RAD), height * -0.5));
      vertices.add(new PVector((radius - width * 0.5) * cos((deg + deg_span) * DEG_TO_RAD), (radius - width * 0.5) * sin((deg + deg_span) * DEG_TO_RAD), height * -0.5));
      vertices.add(new PVector((radius - width * 0.5) * cos((deg + deg_span) * DEG_TO_RAD), (radius - width * 0.5) * sin((deg + deg_span) * DEG_TO_RAD), height * 0.5));
      vertices.add(new PVector((radius - width * 0.5) * cos(deg * DEG_TO_RAD), (radius - width * 0.5) * sin(deg * DEG_TO_RAD), height * 0.5));

      ArrayList<PVector> newVertices = new ArrayList();
      for (var vertex : vertices) {
        // vertexの中身を書き換えることに注意
        //vertex = location + glm::vec4(vertex, 0) * rotation_y * rotation_x;
        vertex = rotation_y.mult(vertex, null);
        vertex = rotation_x.mult(vertex, null);
        newVertices.add(vertex);
      }

      face_target.addVertices(newVertices);

      face_target.addIndex(face_index + 0);
      face_target.addIndex(face_index + 1);
      face_target.addIndex(face_index + 2);
      face_target.addIndex(face_index + 0);
      face_target.addIndex(face_index + 2);
      face_target.addIndex(face_index + 3);

      face_target.addIndex(face_index + 4);
      face_target.addIndex(face_index + 5);
      face_target.addIndex(face_index + 6);
      face_target.addIndex(face_index + 4);
      face_target.addIndex(face_index + 6);
      face_target.addIndex(face_index + 7);

      face_target.addIndex(face_index + 0);
      face_target.addIndex(face_index + 4);
      face_target.addIndex(face_index + 5);
      face_target.addIndex(face_index + 0);
      face_target.addIndex(face_index + 5);
      face_target.addIndex(face_index + 1);

      face_target.addIndex(face_index + 3);
      face_target.addIndex(face_index + 7);
      face_target.addIndex(face_index + 6);
      face_target.addIndex(face_index + 3);
      face_target.addIndex(face_index + 6);
      face_target.addIndex(face_index + 2);

      var frame_index = frame_target.getNumVertices();

      frame_target.addVertices(newVertices);

      frame_target.addIndex(frame_index + 0);
      frame_target.addIndex(frame_index + 1);
      frame_target.addIndex(frame_index + 2);
      frame_target.addIndex(frame_index + 3);
      frame_target.addIndex(frame_index + 4);
      frame_target.addIndex(frame_index + 5);
      frame_target.addIndex(frame_index + 6);
      frame_target.addIndex(frame_index + 7);

      frame_target.addIndex(frame_index + 0);
      frame_target.addIndex(frame_index + 3);
    }
  }
  @Override void mousePressed() {
    gGameStack.change(new GameSceneTitle());
  }
  @Override void keyPressed() {
    super.keyPressed();

    gGameStack.change(new GameSceneTitle());
  }
}
