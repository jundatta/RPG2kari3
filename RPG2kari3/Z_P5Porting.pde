static class P5JS {
  static PApplet mPApplet;
  static void setup(PApplet pa) {
    mPApplet = pa;
  }

  // TN8001(PC-8001)さんに頂きました！！
  static <T> T random(T... args) {
    return args[int(mPApplet.random(args.length))];
  }
  static <T> T random(ArrayList<T> args) {
    return args.get(int(mPApplet.random(args.size())));
  }
  static color random(color[] args) {
    return args[int(mPApplet.random(args.length))];
  }
  static float random(float[] args) {
    return args[int(mPApplet.random(args.length))];
  }

  static void swap(color[] arr, int i, int j) {
    color tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
  }
  // 元ネタは変更しません！！（副作用はありません）
  static color[] shuffle(color[] args) {
    color[] arr = args.clone();
    for (int i = arr.length; 1 < i; i--) {
      P5JS.swap(arr, i-1, (int)mPApplet.random(i));
    }
    return arr;
  }

  static float map(float value, float start1, float stop1, float start2, float stop2, boolean withinBounds) {
    if (withinBounds) {
      float nMin = min(start1, stop1);
      float nMax = max(start1, stop1);
      value = min(value, nMax);
      value = max(value, nMin);
    }
    return PApplet.map(value, start1, stop1, start2, stop2);
  }

  // ※angleMode(DEGREES)はsin(),cos()にも効いている

  static class P5Vector {
    static PVector mult(final PVector v1, final PVector v2) {
      return new PVector(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z);
    }
  }

  static float randomGaussian(float mean, float sd) {
    return (mPApplet.randomGaussian() * sd) + mean;
  }

  static PVector reflect(PVector surfaceNormal, PVector v) {
    PVector r = v.copy();
    surfaceNormal.normalize();
    return r.sub(surfaceNormal.mult(2 * r.dot(surfaceNormal)));
  }

  static void image(PGraphics out, int dx, int dy, int dWidth, int dHeight,
    PImage img, int sx, int sy, int sWidth, int sHeight) {
    PGraphics tmp = mPApplet.createGraphics(sWidth, sHeight);
    tmp.beginDraw();
    tmp.clear();
    tmp.loadPixels();
    color[] dst = tmp.pixels;
    color[] src = img.pixels;
    for (int y = 0; y < sHeight; y++) {
      for (int x = 0; x < sWidth; x++) {
        dst[y*tmp.width+x] = src[(sy+y)*img.width+(sx+x)];
      }
    }
    tmp.updatePixels();
    tmp.endDraw();
    out.image(tmp, dx, dy, dWidth, dHeight);
  }

  static float fract(float value) {
    return value - (int)value;
  }

  // https://www.peko-step.com/tool/hslrgb.html#ppick3
  static color hsla2rgba(int H, int S, int L, float A) {
    int MAX, MIN;
    if (L < 50) {
      MAX = (int)(2.55f * (L + L * (S / 100.0f)));
      MIN = (int)(2.55f * (L - L * (S / 100.0f)));
    } else {
      MAX = (int)(2.55f * (L + (100 - L) * (S / 100.0f)));
      MIN = (int)(2.55f * (L - (100 - L) * (S / 100.0f)));
    }

    mPApplet.push();
    mPApplet.colorMode(RGB, 255, 255, 255, 1.0f);

    int r, g, b;
    if (H <= 60) {
      r = MAX;
      g = (int)((H / 60.0f) * (MAX - MIN)) + MIN;
      b = MIN;
    } else if (H <= 120) {
      r = (int)(((120 - H) / 60.0f) * (MAX - MIN)) + MIN;
      g = MAX;
      b = MIN;
    } else if (H <= 180) {
      r = MIN;
      g = MAX;
      b = (int)(((H - 120) / 60.0f) * (MAX - MIN)) + MIN;
    } else if (H <= 240) {
      r = MIN;
      g = (int)(((240 - H) / 60.0f) * (MAX - MIN)) + MIN;
      b = MAX;
    } else if (H <= 300) {
      r = (int)(((H - 240) / 60.0f) * (MAX - MIN)) + MIN;
      g = MIN;
      b = MAX;
    } else {
      r = MAX;
      g = MIN;
      b = (int)(((360 - H) / 60.0f) * (MAX - MIN)) + MIN;
    }
    color c = mPApplet.color(r, g, b, A);

    mPApplet.pop();

    return c;
  }
}
