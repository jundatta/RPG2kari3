// https://stackoverflow.com/questions/44793883/convert-floating-point-numbers-to-decimal-digits-in-glsl
// GLSL内部で値を表示する
// （PC-8001さんに教えていただきました）
//
PShader shader;

void debugPMatrix3D(PMatrix3D m) {
  println(
    "[m00]:" + m.m00 + ", " +
    "[m01]:" + m.m01 + ", " +
    "[m02]:" + m.m02 + ", " +
    "[m03]:" + m.m03);

  println(
    "[m10]:" + m.m10 + ", " +
    "[m11]:" + m.m11 + ", " +
    "[m12]:" + m.m12 + ", " +
    "[m13]:" + m.m13);

  println(
    "[m20]:" + m.m20 + ", " +
    "[m21]:" + m.m21 + ", " +
    "[m22]:" + m.m22 + ", " +
    "[m23]:" + m.m23);

  println(
    "[m30]:" + m.m30 + ", " +
    "[m31]:" + m.m31 + ", " +
    "[m32]:" + m.m32 + ", " +
    "[m33]:" + m.m33);
}

void setup() {
  size(1112, 834, P3D);

  // （projection == transformみたいな感じの最適化はしない）
  // （もともとのOpenGLイメージにview行列やmodel行列の扱いを戻す）
  hint(DISABLE_OPTIMIZED_STROKE);

  shader = loadShader("fs.glsl", "vs.glsl");
  shader(shader);
  PImage HE2vH = loadImage("HE2vH.png");
  shader.set("txr_font", HE2vH);
  shader.set("fxs", width/150.0f);
  shader.set("fys", height/50.0f);
  noStroke();
}

void draw() {
  // p5.jsに合わせてY軸上方向＋、画面中央に原点移動
  //  translate(width/2, height/2, 0);

  PMatrix3D projection = ((PGraphicsOpenGL)g).projection.get();
  println();
  debugPMatrix3D(projection);
  rect(-width/2, -height/2, width*2, height*2);
}
