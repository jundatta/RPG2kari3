class ofMesh {
  ArrayList<PVector> vertices;
  IntList colors;
  ArrayList<PVector> texCoords;
  IntList indices;
  PImage tex;

  ofMesh() {
    vertices = new ArrayList();
    colors = new IntList();
    indices = new IntList();
    texCoords = new ArrayList();
    tex = null;
  }
  void clear() {
    vertices.clear();
    colors.clear();
    indices.clear();
    texCoords.clear();
    tex = null;
  }
  void addVertices(ArrayList<PVector> vertices) {
    for (PVector v : vertices) {
      this.vertices.add(v);
    }
  }
  void addVertex(PVector v) {
    this.vertices.add(v);
  }
  int getNumVertices() {
    return vertices.size();
  }
  void addColor(color c) {
    colors.append(c);
  }
  color getColor(int ix) {
    return colors.get(ix);
  }
  void setColor(int ix, color c) {
    colors.set(ix, c);
  }
  void addIndex(int ix) {
    indices.append(ix);
  }
  void addTriangle(int ix0, int ix1, int ix2) {
    indices.append(ix0);
    indices.append(ix1);
    indices.append(ix2);
  }
  ArrayList<PVector> getVertices() {
    return vertices;
  }
  PVector getVertex(int ix) {
    return vertices.get(ix);
  }
  void addTexCoord(PVector t) {
    texCoords.add(t);
  }
  void setTexture(PImage tex) {
    this.tex = tex;
  }
  // 設定されたOF_PRIMITIVE_LINESの解釈で描画する
  void drawWireframe() {
    PShape sh = createShape();
    sh.setFill(false);
    sh.beginShape(LINES);
    for (int i : indices) {
      PVector v = vertices.get(i);
      sh.vertex(v.x, v.y, v.z);
    }
    sh.endShape();
    if (0 < colors.size()) {
      for (int i = 0; i < indices.size(); i++) {
        int idx = indices.get(i);
        color col = colors.get(idx);
        sh.setStroke(i, col);
      }
    }
    shape(sh);
  }
  // stroke()の色を指定して線を描画する
  void drawWireframe(PGraphics pg, color stroke) {
    PShape sh = createShape();
    sh.setFill(false);
    sh.beginShape(LINES);
    for (int i : indices) {
      PVector v = vertices.get(i);
      sh.vertex(v.x, v.y, v.z);
    }
    sh.endShape();
    sh.setStroke(stroke);
    pg.shape(sh);
  }
  void drawWireframe(color stroke) {
    PGraphics pg = getGraphics();
    drawWireframe(pg, stroke);
  }
  // デフォルトのOF_PRIMITIVE_TRIANGLESの解釈で描画する
  void draw() {
    PShape sh = createShape();
    sh.setStroke(false);
    sh.beginShape(TRIANGLES);
    if (tex == null) {
      for (int i : indices) {
        PVector v = vertices.get(i);
        sh.vertex(v.x, v.y, v.z);
      }
    } else {
      sh.textureMode(NORMAL);
      sh.texture(tex);
      for (int i : indices) {
        PVector v = vertices.get(i);
        PVector uv = texCoords.get(i);
        sh.vertex(v.x, v.y, v.z, uv.x, uv.y);
      }
    }
    sh.endShape();
    if (0 < colors.size()) {
      for (int i = 0; i < indices.size(); i++) {
        int idx = indices.get(i);
        color col = colors.get(idx);
        sh.setFill(i, col);
      }
    }
    shape(sh);
  }
  // fill()の色を指定して描画する
  void draw(PGraphics pg, color fill) {
    PShape sh = createShape();
    sh.setStroke(false);
    sh.beginShape(TRIANGLES);
    for (int i : indices) {
      PVector v = vertices.get(i);
      sh.vertex(v.x, v.y, v.z);
    }
    sh.endShape();
    for (int i = 0; i < indices.size(); i++) {
      sh.setFill(i, fill);
    }
    pg.shape(sh);
  }
  void draw(color fill) {
    PGraphics pg = getGraphics();
    draw(pg, fill);
  }
  void drawFaces() {
    draw();
  }
}
class ofMeshFace {
  PVector[] triangle = new PVector[3];
  ofMeshFace(PVector t0, PVector t1, PVector t2) {
    triangle[0] = t0;
    triangle[1] = t1;
    triangle[2] = t2;
  }
  PVector getVertex(int idx) {
    return triangle[idx];
  }
}

int ofGetFrameNum() {
  return frameCount;
}
void ofSetLineWidth(float s) {
  strokeWeight(s);
}
void ofRotateX(float degrees) {
  rotateX(radians(degrees));
}
void ofRotateY(float degrees) {
  rotateY(radians(degrees));
}
void ofRotateZ(float degrees) {
  rotateZ(radians(degrees));
}
void ofSeedRandom(int val) {
  randomSeed(val);
}
