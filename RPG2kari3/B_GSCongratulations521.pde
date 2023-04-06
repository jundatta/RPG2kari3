// コングラチュレーション画面
//
// オリジナルはこちらです。
// 【作者】Richard Bourneさん
// 【作品名】Cone Spheres
// https://openprocessing.org/sketch/1782503
//

class GameSceneCongratulations521 extends GameSceneCongratulationsBase {
  class Triangle {
    PVector[] t = new PVector[3];
    void setup(float x1, float y1, float z1,
      float x2, float y2, float z2, float x3, float y3, float z3) {
      t[0] = new PVector(x1, y1, z1);
      t[1] = new PVector(x2, y2, z2);
      t[2] = new PVector(x3, y3, z3);
    }
    Triangle(float x1, float y1, float z1,
      float x2, float y2, float z2, float x3, float y3, float z3) {
      setup(x1, y1, z1, x2, y2, z2, x3, y3, z3);
    }
    Triangle(PVector p1, PVector p2, PVector p3) {
      setup(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, p3.x, p3.y, p3.z);
    }
  }
  float _count;
  //final int _limitCount = 3;
  final int _limitCount = 2;
  //final int _numSphere = 1;
  final int _numSphere = 5;
  BaseTriangle _bt[] = new BaseTriangle[_numSphere];

  final float _noiseStepT = 0.008f;
  float _sphereR;
  float _maxAreaR;
  float _maxSphereR;

  PVector _InitNoiseXYZ;
  PVector _InitRot;
  PVector _NoiseRangeXYZ;

  PShape cone;
  PGraphics tex;

  @Override void setup() {
    noStroke();

    _maxAreaR = width/2.5f;
    _maxSphereR = width/5.0f;
    for (int i = 0; i < _numSphere; i++) {
      float maxCentX = _maxAreaR - _maxSphereR;
      float maxCentY = _maxAreaR - _maxSphereR;
      float maxCentZ = _maxAreaR - _maxSphereR;
      PVector sphereCenter = new PVector(maxCentX*random(-1, 1), maxCentY*random(-1, 1), maxCentZ*random(-1, 1));
      _bt[i] = new BaseTriangle(_maxSphereR, sphereCenter);
    }

    _InitNoiseXYZ = new PVector(random(100), random(100), random(100));
    _InitRot = new PVector(random(360), random(360), random(360));
    _NoiseRangeXYZ = new PVector(1.0/1.5/2.0f, 1.0/1.5/2.0f, 1.0/1.5/2.0f);

    _sphereR = width/1000.0f;

    _count = 0;

    cone = createCone(1, 1);
    tex = createGraphics(1, 1);
  }
  @Override void draw() {
    push();
    translate(width * 0.5f, height * 0.5f);
    //background(200);
    colorMode(HSB, 255, 255, 255, 255);
    background(0);
    directionalLight(105, 0, 150, -1, 1, -1);
    directionalLight(105, 0, 150, -1, 1, -1);
    ambientLight(255, 0, 192);  // 環境光に白を入れて色を飛ばしてみた＼(^_^)／
    //specularMaterial(0);  // あきらめる

    //rotateX(_InitRot.x + _count/300.0f);
    //rotateY(_InitRot.y + _count/100.0f);
    //rotateZ(_InitRot.z + _count/200.0f);
    float freq = 4;
    float d = 2;
    for (int j = 0; j < _numSphere; j++) {
      BaseTriangle bt = _bt[j];
      for (int i = 0; i < bt._aryTriangle.size(); i++) {
        PVector tc = bt._aryTriCenter.get(i);
        float noiseVal = pow(sin(freq * 2*PI * noise(
          _InitNoiseXYZ.x + _NoiseRangeXYZ.x * tc.x / _maxAreaR,
          _InitNoiseXYZ.y + _NoiseRangeXYZ.y * tc.y / _maxAreaR - _noiseStepT * _count,
          _InitNoiseXYZ.z + _NoiseRangeXYZ.z * tc.z / _maxAreaR
          )), d) * 1 + 0;

        float threshold = 0.1;
        float ratio = (noiseVal-threshold)/(1.0f-threshold);
        if (noiseVal > threshold) {
          push();
          translate(bt._SphereCenter.x, bt._SphereCenter.y, bt._SphereCenter.z);
          rotateZ(-PI/2.0f);
          PVector crYZ = bt._aryCentRotYZ.get(i);
          rotateX(crYZ.y);
          rotateZ(crYZ.z);
          float coneRatio = 0.07;
          float coneHeight = _sphereR * ratio;
          translate(0, _maxSphereR, 0);
          translate(0, coneHeight/2.0f, 0);
          //fill(i%255, 255, 255);
          tex.beginDraw();
          tex.colorMode(HSB, 255, 255, 255, 255);
          tex.background(i%255, 255, 255);
          tex.endDraw();
          cone.setTexture(tex);
          //cone(coneHeight / coneRatio, coneHeight);
          //PShape cone = createCone(coneHeight / coneRatio, coneHeight);
          scale(coneHeight / coneRatio * 1.5f, coneHeight, coneHeight / coneRatio * 1.5f);
          shape(cone);
          pop();
        }
      }
    }

    _count++;
    pop();

    logoRightLower(#ff0000);
  }

  class BaseTriangle {
    ArrayList<Triangle> _aryTriangle;
    ArrayList<PVector> _aryTriCenter;
    ArrayList<PVector> _aryCentRotYZ;
    PVector _SphereCenter;
    BaseTriangle(float r, PVector aryCentXYZ) {
      _aryTriangle = new ArrayList();
      _aryTriCenter = new ArrayList();
      _aryCentRotYZ = new ArrayList();
      _SphereCenter = aryCentXYZ;
      Triangle[] triangles = new Triangle[8];
      triangles[0] = new Triangle(r+aryCentXYZ.x, 0+aryCentXYZ.y, 0+aryCentXYZ.z, 0+aryCentXYZ.x, 0+aryCentXYZ.y, r+aryCentXYZ.z, 0+aryCentXYZ.x, -r+aryCentXYZ.y, 0+aryCentXYZ.z);
      triangles[1] = new Triangle(-r+aryCentXYZ.x, 0+aryCentXYZ.y, 0+aryCentXYZ.z, 0+aryCentXYZ.x, 0+aryCentXYZ.y, r+aryCentXYZ.z, 0+aryCentXYZ.x, -r+aryCentXYZ.y, 0+aryCentXYZ.z);
      triangles[2] = new Triangle(r+aryCentXYZ.x, 0+aryCentXYZ.y, 0+aryCentXYZ.z, 0+aryCentXYZ.x, 0+aryCentXYZ.y, -r+aryCentXYZ.z, 0+aryCentXYZ.x, -r+aryCentXYZ.y, 0+aryCentXYZ.z);
      triangles[3] = new Triangle(-r+aryCentXYZ.x, 0+aryCentXYZ.y, 0+aryCentXYZ.z, 0+aryCentXYZ.x, 0+aryCentXYZ.y, -r+aryCentXYZ.z, 0+aryCentXYZ.x, -r+aryCentXYZ.y, 0+aryCentXYZ.z);
      triangles[4] = new Triangle(r+aryCentXYZ.x, 0+aryCentXYZ.y, 0+aryCentXYZ.z, 0+aryCentXYZ.x, 0+aryCentXYZ.y, r+aryCentXYZ.z, 0+aryCentXYZ.x, r+aryCentXYZ.y, 0+aryCentXYZ.z);
      triangles[5] = new Triangle(-r+aryCentXYZ.x, 0+aryCentXYZ.y, 0+aryCentXYZ.z, 0+aryCentXYZ.x, 0+aryCentXYZ.y, r+aryCentXYZ.z, 0+aryCentXYZ.x, r+aryCentXYZ.y, 0+aryCentXYZ.z);
      triangles[6] = new Triangle(r+aryCentXYZ.x, 0+aryCentXYZ.y, 0+aryCentXYZ.z, 0+aryCentXYZ.x, 0+aryCentXYZ.y, -r+aryCentXYZ.z, 0+aryCentXYZ.x, r+aryCentXYZ.y, 0+aryCentXYZ.z);
      triangles[7] = new Triangle(-r+aryCentXYZ.x, 0+aryCentXYZ.y, 0+aryCentXYZ.z, 0+aryCentXYZ.x, 0+aryCentXYZ.y, -r+aryCentXYZ.z, 0+aryCentXYZ.x, r+aryCentXYZ.y, 0+aryCentXYZ.z);
      int countObj = 0;
      for (int i = 0; i < triangles.length; i++) {
        subTriangle(triangles[i], countObj + 1, r);
      }
    }
    void subTriangle(Triangle triangle, int countObj, float r) { //triangle = [[x1, y1, z1], [x2, y2, z2], [x3, y3, z3]]
      if (countObj <= _limitCount) {
        PVector XYZ1 = triangle.t[0];
        PVector XYZ2 = triangle.t[1];
        PVector XYZ3 = triangle.t[2];
        Triangle newMidXYZ = divide(XYZ1, XYZ2, XYZ3, r);
        Triangle[] triangles = new Triangle[4];
        triangles[0] = new Triangle(XYZ1, newMidXYZ.t[0], newMidXYZ.t[2]);
        triangles[1] = new Triangle(newMidXYZ.t[0], XYZ2, newMidXYZ.t[1]);
        triangles[2] = new Triangle(newMidXYZ.t[2], newMidXYZ.t[1], XYZ3);
        triangles[3] = new Triangle(newMidXYZ.t[0], newMidXYZ.t[1], newMidXYZ.t[2]);
        for (int i = 0; i < triangles.length; i++) {
          subTriangle(triangles[i], countObj + 1, r);
        }
      } else {
        this.addCenter(triangle); //[[x1, y1, z1], [x2, y2, z2], [x3, y3, z3]] -> [ave.x, ave.y, ave.z]
        this.addCentRotYZ(); //angle X-Z plane, angle X-Y plane
        _aryTriangle.add(triangle);
      }
    }
    Triangle divide(PVector XYZ1, PVector XYZ2, PVector XYZ3, float r) {
      PVector midXYZ_1_2 = new PVector(
        (XYZ1.x + XYZ2.x)/2.0f,
        (XYZ1.y + XYZ2.y)/2.0f,
        (XYZ1.z + XYZ2.z)/2.0f
        );
      PVector midXYZ_2_3 = new PVector(
        (XYZ2.x + XYZ3.x)/2.0f,
        (XYZ2.y + XYZ3.y)/2.0f,
        (XYZ2.z + XYZ3.z)/2.0f
        );
      PVector midXYZ_3_1 = new PVector(
        (XYZ3.x + XYZ1.x)/2.0f,
        (XYZ3.y + XYZ1.y)/2.0f,
        (XYZ3.z + XYZ1.z)/2.0f
        );
      float distMid_1_2 = pow(
        pow(midXYZ_1_2.x - _SphereCenter.x, 2) +
        pow(midXYZ_1_2.y - _SphereCenter.y, 2) +
        pow(midXYZ_1_2.z - _SphereCenter.z, 2), 0.5);
      float distMid_2_3 = pow(
        pow(midXYZ_2_3.x - _SphereCenter.x, 2) +
        pow(midXYZ_2_3.y - _SphereCenter.y, 2) +
        pow(midXYZ_2_3.z - _SphereCenter.z, 2), 0.5);
      float distMid_3_1 = pow(
        pow(midXYZ_3_1.x - _SphereCenter.x, 2) +
        pow(midXYZ_3_1.y - _SphereCenter.y, 2) +
        pow(midXYZ_3_1.z - _SphereCenter.z, 2), 0.5);
      PVector newMidXYZ_1_2 = new PVector(
        (midXYZ_1_2.x - _SphereCenter.x) / distMid_1_2 * r + _SphereCenter.x,
        (midXYZ_1_2.y - _SphereCenter.y) / distMid_1_2 * r + _SphereCenter.y,
        (midXYZ_1_2.z - _SphereCenter.z) / distMid_1_2 * r + _SphereCenter.z
        );
      PVector newMidXYZ_2_3 = new PVector(
        (midXYZ_2_3.x - _SphereCenter.x) / distMid_2_3 * r + _SphereCenter.x,
        (midXYZ_2_3.y - _SphereCenter.y) / distMid_2_3 * r + _SphereCenter.y,
        (midXYZ_2_3.z - _SphereCenter.z) / distMid_2_3 * r + _SphereCenter.z
        );
      PVector newMidXYZ_3_1 = new PVector(
        (midXYZ_3_1.x - _SphereCenter.x) / distMid_3_1 * r + _SphereCenter.x,
        (midXYZ_3_1.y - _SphereCenter.y) / distMid_3_1 * r + _SphereCenter.y,
        (midXYZ_3_1.z - _SphereCenter.z) / distMid_3_1 * r + _SphereCenter.z
        );
      return new Triangle(newMidXYZ_1_2, newMidXYZ_2_3, newMidXYZ_3_1);
    }
    void addCenter(Triangle triangle) {
      PVector t0 = triangle.t[0];
      PVector t1 = triangle.t[1];
      PVector t2 = triangle.t[2];
      float centX = t0.x + t1.x + t2.x;
      float centY = t0.y + t1.y + t2.y;
      float centZ = t0.z + t1.z + t2.z;
      centX /= (float)triangle.t.length;
      centY /= (float)triangle.t.length;
      centZ /= (float)triangle.t.length;
      _aryTriCenter.add(new PVector(centX, centY, centZ));
    }
    void addCentRotYZ() {
      _aryCentRotYZ = new ArrayList();
      for (PVector tc : _aryTriCenter) {
        float rotY = atan2(
          tc.z - _SphereCenter.z,
          tc.x - _SphereCenter.x);
        float rx = pow(pow(tc.z - _SphereCenter.z, 2) + pow(tc.x - _SphereCenter.x, 2), 0.5);
        float ry = tc.y - _SphereCenter.y;
        float rotZ = atan2(ry, rx);
        _aryCentRotYZ.add(new PVector(0, rotY, rotZ));
      }
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
