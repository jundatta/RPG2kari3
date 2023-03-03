// https://openprocessing.org/sketch/1390657

PShader Shader;
PGraphics coolingMap;
PGraphics tex;

PGraphics tmp;

void setup() {
  size(500, 800, P3D);
  pixelDensity(1);
  noStroke();

  coolingMap=createGraphics(width, height, P2D);
  coolingMap.beginDraw();
  coolingMap.loadPixels();
  for (int y=0; y<height; y++) {
    for (int x=0; x<width; x++) {
      float n = noise(x/50.0f, y/50.0f);
      float val=pow(n, 3)*255;
      coolingMap.pixels[x+y*width] = color((int)val);
    }
  }
  coolingMap.updatePixels();
  coolingMap.endDraw();

  tex=createGraphics(width, height, P2D);

  background(0);

  Shader = loadShader("frag.glsl", "vert.glsl");
  Shader.set("uResolution", (float)width, (float)height);
  //  Shader.set("uTime", millis() / 1000.0);


  tmp=createGraphics(width, height, P2D);
}

int uprisingSpeed=2;
int utime=0;

void draw() {
  shader(Shader);

  PGraphics canv = getGraphics();
  tex.beginDraw();
  tex.background(0);
  tex.image(canv, 0, -uprisingSpeed, width, height);
  tex.endDraw();

  // （自分自身にコピー。はうまくいかない？）
  // （beginDraw()をいれてもうまくいかにゃい）
  //coolingMap.image(coolingMap, 0, -uprisingSpeed, width, height);
  tmp.beginDraw();
  tmp.image(coolingMap, 0, -uprisingSpeed, width, height);
  tmp.endDraw();
  coolingMap.beginDraw();
  coolingMap.image(tmp, 0, 0);
  coolingMap.endDraw();

  coolingMap.beginDraw();
  coolingMap.loadPixels();
  if (uprisingSpeed>0) {
    for (int y=height-uprisingSpeed; y<height; y++) {
      for (int x=0; x<width; x++) {
        float n = noise(x/50.0f, (y+utime*uprisingSpeed)/50.0f);
        float val=pow(n, 3)*255;
        coolingMap.pixels[x+y*width] = color((int)val);
      }
    }
  } else if (uprisingSpeed<0) {
    for (int y=-uprisingSpeed-1; y>=0; y--) {
      for (int x=0; x<width; x++) {
        float n = noise(x/50.0f, (y+utime*uprisingSpeed)/50.0f);
        float val=pow(n, 3)*255;
        coolingMap.pixels[x+y*width] = color((int)val);
      }
    }
  }
  coolingMap.updatePixels();
  coolingMap.endDraw();

  Shader.set("tex", tex);
  Shader.set("coolingMap", coolingMap);
  rect(0, 0, width, height);
  if (uprisingSpeed!=0) {
    utime++;
  }
}
void keyPressed() {
  if (keyCode==UP&&uprisingSpeed<4) {
    utime*=uprisingSpeed==0?1:uprisingSpeed;
    uprisingSpeed+=1;
    utime/=uprisingSpeed==0?1:uprisingSpeed;
  }
  if (keyCode==DOWN&&uprisingSpeed>-4) {
    utime*=uprisingSpeed==0?1:uprisingSpeed;
    uprisingSpeed-=1;
    utime/=uprisingSpeed==0?1:uprisingSpeed;
  }
}
