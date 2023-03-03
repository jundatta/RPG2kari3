// https://forum.processing.org/two/discussion/26800/how-to-create-a-3d-cylinder-using-pshape-and-vertex-x-y-z
// detail=24
PShape createCan(float r, float h, int detail) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(-x, -0, -z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);
  }
  sh.endShape();
  return sh;
}
PShape createCan(float r, float h) {
  return createCan(r, h, 24);
}
// ふたつき缶（PC-8001さんありがとう）
PShape createCan(float radius, float height, int detail, boolean bottomCap, boolean topCap) {
  textureMode(NORMAL);
  PShape group = createShape(GROUP);
  float angle = TWO_PI / detail;

  if (bottomCap) {
    PShape bottom = createShape();
    bottom.beginShape();
    bottom.noStroke();
    for (int i = 0; i < detail; i++) {
      float x = sin(i * angle);
      float z = cos(i * angle);
      //float u = float(i) / detail;
      //bottom.normal(x, 0, z);
      bottom.vertex(x * radius, +height / 2, z * radius);
    }
    bottom.endShape(CLOSE);
    group.addChild(bottom);
  }

  group.addChild(createCan(radius, height, detail));

  if (topCap) {
    PShape top = createShape();
    top.beginShape();
    top.noStroke();
    for (int i = 0; i < detail; i++) {
      float x = sin(i * angle);
      float z = cos(i * angle);
      //float u = float(i) / detail;
      //top.normal(x, 0, z);
      top.vertex(x * radius, -height / 2, z * radius);
    }
    top.endShape(CLOSE);
    group.addChild(top);
  }

  return group;
}

// 缶が立ってるイメージなのでこれを横に倒したい
PShape createPipe(float r, float w, int detail) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float y = sin(i * angle);
    float z = cos(i * angle);
    float v = float(i) / detail;
    sh.normal(-0, -y, -z);
    sh.vertex(-w/2, y * r, z * r, 0, v * detail);
    sh.vertex(+w/2, y * r, z * r, 1, v * detail);
  }
  sh.endShape();
  return sh;
}

// detail=24
PShape createCone(float r, float h, int detail) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(-x, -0, -z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * 0, +h/2, z * 0, u, 1);
  }
  sh.endShape();
  return sh;
}
PShape createCone(float r, float h) {
  return createCone(r, h, 24);
}
PShape createTorus(float outerRad, float innerRad, int numc, int numt) {
  PShape sh = createShape();
  sh.beginShape(TRIANGLE_STRIP);
  //  sh.beginShape(TRIANGLES);
  sh.noStroke();

  sh.textureMode(NORMAL);
  //  sh.noTint();

  float x, y, z, s, t, u, v;
  float nx, ny, nz;
  float a1, a2;
  //  int idx = 0;
  for (int i = 0; i < numc; i++) {
    for (int j = 0; j <= numt; j++) {
      for (int k = 1; k >= 0; k--) {
        //  s = (i + k) % numc + 0.5;
        s = (i + k);
        //  t = j % numt;
        t = j;
        u = s / numc;
        v = t / numt;
        a1 = s * TWO_PI / numc;
        a2 = t * TWO_PI / numt;

        x = (outerRad + innerRad * cos(a1)) * cos(a2);
        y = (outerRad + innerRad * cos(a1)) * sin(a2);
        z = innerRad * sin(a1);

        nx = cos(a1) * cos(a2);
        ny = cos(a1) * sin(a2);
        nz = sin(a1);
        sh.normal(nx, ny, nz);
        sh.vertex(x, y, z, u, v);
      }
    }
  }
  sh.endShape();
  return sh;
}
PShape createTorus(float outerRad, float innerRad) {
  return createTorus(outerRad, innerRad, 24, 16);
}
PShape createTorus(float outerRad, float innerRad, int numc, int numt,
  color strokeColor) {
  PShape sh = createShape();
  sh.beginShape(TRIANGLE_STRIP);
  //  sh.beginShape(TRIANGLES);
  sh.noStroke();

  sh.noFill();
  sh.stroke(strokeColor);
  sh.strokeWeight(1);

  sh.textureMode(NORMAL);
  //  sh.noTint();

  float x, y, z, s, t, u, v;
  float nx, ny, nz;
  float a1, a2;
  //  int idx = 0;
  for (int i = 0; i < numc; i++) {
    for (int j = 0; j <= numt; j++) {
      for (int k = 1; k >= 0; k--) {
        //  s = (i + k) % numc + 0.5;
        s = (i + k);
        //  t = j % numt;
        t = j;
        u = s / numc;
        v = t / numt;
        a1 = s * TWO_PI / numc;
        a2 = t * TWO_PI / numt;

        x = (outerRad + innerRad * cos(a1)) * cos(a2);
        y = (outerRad + innerRad * cos(a1)) * sin(a2);
        z = innerRad * sin(a1);

        nx = cos(a1) * cos(a2);
        ny = cos(a1) * sin(a2);
        nz = sin(a1);
        sh.normal(nx, ny, nz);
        sh.vertex(x, y, z, u, v);
      }
    }
  }
  sh.endShape();
  return sh;
}

// copied and adapted from http://code.google.com/p/webgltimer/source/browse/src/net/icapsid/counter/client/Icosahedron.java?r=170e4fcc41bf20700dcb6dc67272073af112c65c
public class Sphere {
  ArrayList<PVector> vertexList = new ArrayList<>();

  final float X = 0.525731112119133606f;
  final float Z = 0.850650808352039932f;

  final PVector vdata[] = {
    new PVector(-X, 0.0f, Z),
    new PVector(X, 0.0f, Z),
    new PVector(-X, 0.0f, -Z),
    new PVector(X, 0.0f, -Z),
    new PVector(0.0f, Z, X),
    new PVector(0.0f, Z, -X),
    new PVector(0.0f, -Z, X),
    new PVector(0.0f, -Z, -X),
    new PVector(Z, X, 0.0f),
    new PVector(-Z, X, 0.0f),
    new PVector(Z, -X, 0.0f),
    new PVector(-Z, -X, 0.0f),
  };

  final int tindices[][] = {{0, 4, 1}, {0, 9, 4}, {9, 5, 4},
    {4, 5, 8}, {4, 8, 1}, {8, 10, 1}, {8, 3, 10},
    {5, 3, 8}, {5, 2, 3}, {2, 7, 3}, {7, 10, 3},
    {7, 6, 10}, {7, 11, 6}, {11, 0, 6}, {0, 1, 6},
    {6, 1, 10}, {9, 0, 11}, {9, 11, 2}, {9, 2, 5},
    {7, 2, 11}};

  int r;

  public Sphere(int r, int ite) {
    this.r = r;
    for (int i = 0; i < 20; ++i) {
      subdivide(
        vdata[tindices[i][0]],
        vdata[tindices[i][1]],
        vdata[tindices[i][2]], ite);
    }

    ArrayList<PVector> vertices = new ArrayList();
    for (PVector v : vertexList) {
      PVector vv = PVector.mult(v, r);
      vertices.add(vv);
    }
    vertexList = vertices;
  }

  PShape get() {
    var mesh = createShape();

    mesh.beginShape(TRIANGLES);
    for (PVector v : vertexList) {
      mesh.vertex(v.x, v.y, v.z);
    }
    mesh.endShape();

    return mesh;
  }

  ArrayList<PVector> getVertices() {
    return vertexList;
  }

  private void subdivide(PVector v1, PVector v2, PVector v3, int depth) {
    if (depth == 0) {
      vertexList.add(v1);
      vertexList.add(v2);
      vertexList.add(v3);
      return;
    }

    var v12 = PVector.add(v1, v2).div(2);
    var v23 = PVector.add(v2, v3).div(2);
    var v31 = PVector.add(v3, v1).div(2);

    v12.normalize();
    v23.normalize();
    v31.normalize();

    subdivide(v1, v12, v31, depth - 1);
    subdivide(v2, v23, v12, depth - 1);
    subdivide(v3, v31, v23, depth - 1);
    subdivide(v12, v23, v31, depth - 1);
  }
}
