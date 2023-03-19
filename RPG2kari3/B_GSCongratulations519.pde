// コングラチュレーション画面
//
// オリジナルはこちらです。
// 【作者】Richard Bourneさん
// 【作品名】Squishy Squish Squish
// https://openprocessing.org/sketch/1847401
//

import java.util.HashSet;

class GameSceneCongratulations519 extends GameSceneCongratulationsBase {
  final float maxVertexCount = 500; // Increase to get more blobs. Not really a max but more of a guideline for the setup :)
  final float substeps = 10; // How many physics steps per frame
  final float maxRadius = 0.25; // relative to min canvas length [min(widht,length)]
  final float minRadius = 0.1; // relative to min canvas length [min(widht,length)]
  final float vertexDistance = 0.015; // How far apart are the vertices (relative to min canvas length) (smaller number == more cpu work)
  final boolean outlineOnly = false; // draw only the outline, no fill
  final boolean showCollisionAreas = false;

  float mx;
  float my;
  class Blob {
    float area;
    float currentArea;
    float areaDiff;
    ChainableParticle rootParticle;
    ArrayList<ChainableParticle> particles;
    ArrayList<DistanceJoint> joints;
    float radius;
    color c;
    Blob(float area, float currentArea, float areaDiff,
      ChainableParticle rootParticle, ArrayList<ChainableParticle> particles,
      ArrayList<DistanceJoint> joints, float radius, color c) {
      this.area = area;
      this.currentArea = currentArea;
      this.areaDiff = areaDiff;
      this.rootParticle = rootParticle;
      this.particles = particles;
      this.joints = joints;
      this.radius = radius;
      this.c = c;
    }
  }
  ArrayList<Blob> blobs;
  ArrayList<ChainableParticle> particles;
  ArrayList<DistanceJoint> distanceJoints;
  HashGrid hashGrid;
  float effectiveVertexDistance;

  float marginX = 20;
  float marginY = 5;

  @Override void setup() {
    colorMode(HSB, 360, 100, 100, 100);

    effectiveVertexDistance = vertexDistance * min(width, height);

    mx = 0;
    my = 0;
    hashGrid = new HashGrid(width, height, floor(effectiveVertexDistance*2));
    particles = new ArrayList();
    distanceJoints = new ArrayList();
    blobs = new ArrayList();

    float minLength = min(width, height);
    float offsetY = 0;
    float totalArea = 0;
    float prevRadius = 0;
    float maxArea = (width - marginX * 2) * (height - marginY * 2) * 0.8;
    while (totalArea < maxArea && particles.size() < maxVertexCount) {
      float radiusLimit = (maxArea - totalArea) / (PI * 2);
      float radius = min(radiusLimit, (pow(random(1), 3) * (maxRadius-minRadius) + minRadius)*minLength);
      offsetY += prevRadius + radius + 50;
      var blob = generateBlob(width / 2+random(-1, 1)*(width/2-marginX-radius), height / 2 - offsetY, radius);
      totalArea += blob.area;
      blobs.add(blob);
      //particles.push(...blob.particles);
      for (var p : blob.particles) {
        particles.add(p);
      }
      //distanceJoints.push(...blob.joints);
      for (var dj : blob.joints) {
        distanceJoints.add(dj);
      }
      prevRadius = radius;
    }
  }
  @Override void draw() {
    push();
    float mr = min(width, height)*0.1;
    mx = lerp(mx, mouseX, 1);
    my = lerp(my, mouseY, 1);

    float dt = 1 / 60.0f;
    float sdt = dt / substeps;

    // (i--) != 0は評価の順番的にあやしい（汗）
    for (int i=particles.size(); (i--) != 0; ) {
      var particle = particles.get(i);
      particle.updateClient();
    }

    for (float substep = substeps; (substep--) != 0; ) {
      for (int i=blobs.size(); (i--) != 0; ) {
        var blob = blobs.get(i);
        blob.currentArea = geometry.polygonArea(blob.particles);
        blob.areaDiff = (blob.area - blob.currentArea) / blob.area;
      }

      for (int i=particles.size(); (i--) != 0; ) {
        var particle = particles.get(i);
        particle.addForce(0, 1000 * sdt);
        var coord = new Coordinate2D(particle.vx, particle.vy);
        var v = geometry.limit(coord, effectiveVertexDistance / sdt *2);
        particle.vx = v.x;
        particle.vy = v.y;
        particle.update(sdt);
      }

      // ここもi--;を(i--) != 0;に変えても評価的にあってるか（汗）
      for (int i=particles.size(); (i--) != 0; ) {
        var v = particles.get(i);
        // Area constraint
        var v0 = v.prevSibling;
        var v1 = v.nextSibling;
        var lineNormal = geometry.getLineNormal(v0.x, v0.y, v1.x, v1.y);
        var dir = v.parent.areaDiff;
        v.move(lineNormal.x * dir, lineNormal.y * dir);
      }

      // ここも（汗）
      for (int i=distanceJoints.size(); (i--) != 0; ) {
        distanceJoints.get(i).update(1);
      }

      for (int i=particles.size(); (i--) != 0; ) {
        var particle = particles.get(i);
        HashSet<ChainableParticle> cps
          = hashGrid.query((int)particle.x, (int)particle.y, (int)particle.radius);
        //.forEach((other) => {
        for (var other : cps) {
          // ここの比較中身なのだとしたらどうするのかなぁ？
          if (
            other == particle ||
            other == particle.nextSibling ||
            other == particle.prevSibling
            )
            break;

          var force = particle.testCollision(
            other.x,
            other.y,
            other.radius
            );

          if (force != null) {
            particle.move(force.x * 0.5, force.y * 0.5);
            other.move(-force.x * 0.5, -force.y * 0.5);
          }
        }
      }

      // ここも（汗）
      for (int i=particles.size(); (i--) != 0; ) {
        var particle = particles.get(i);
        particle.collide(mx, my, mr);
        particle.constrain(
          marginX,
          -99999,
          width - marginX,
          height - marginY
          );
        particle.endUpdate(sdt);
      }
    }

    background(10);
    fill(20);
    noStroke();
    circle(mx, my, mr * 2 - 2);

    // ここも（汗）
    for (int i=blobs.size(); (i--) != 0; ) {
      var blob = blobs.get(i);
      var currentParticle = blob.rootParticle;

      if (outlineOnly) {
        //stroke(blob.c);
        noFill();
        //strokeWeight(1);
      } else {
        // 「stroke()の呪い」回避！！
        //stroke(blob.c);
        //strokeWeight(effectiveVertexDistance*2-6);
        fill(blob.c);
      }
      beginShape();
      do {
        curveVertex(currentParticle.x, currentParticle.y);
        currentParticle = currentParticle.nextSibling;
      } while (currentParticle != blob.rootParticle);

      curveVertex(currentParticle.x, currentParticle.y);
      currentParticle = currentParticle.nextSibling;
      curveVertex(currentParticle.x, currentParticle.y);
      currentParticle = currentParticle.nextSibling;
      curveVertex(currentParticle.x, currentParticle.y);
      endShape();

      if (showCollisionAreas) {
        strokeWeight(1);
        stroke(blob.c);
        noFill();
        currentParticle = blob.rootParticle;
        do {
          circle(currentParticle.x, currentParticle.y, currentParticle.radius*2);
          currentParticle = currentParticle.nextSibling;
        } while (currentParticle != blob.rootParticle);
      }
    }
    pop();

    logoRightLower(#ff0000);
  }

  Blob generateBlob(float offsetX, float offsetY, float radius) {
    int numPoints = floor((radius * PI * 2) / effectiveVertexDistance);
    ArrayList<ChainableParticle> vertices = new ArrayList();
    for (int i = 0; i < numPoints; i++) {
      float t = i / (float)numPoints;
      float angle = t * TWO_PI;
      float x = cos(angle) * radius + offsetX;
      float y = sin(angle) * radius + offsetY;
      float rad = effectiveVertexDistance;
      float damping = 1;
      float friction = 0.1f;
      float mass = 1;
      Blob parent = null;
      ChainableParticle particle = new ChainableParticle(x, y, rad, damping, friction, mass, parent);
      particle.setClient(hashGrid.createClient(particle));
      vertices.add(particle);
    }

    int len = vertices.size();
    for (int i = 0; i < len; i++) {
      var v = vertices.get(i);

      var vprev = vertices.get((i + len - 1) % len);
      var vnext = vertices.get((i + 1) % len);
      v.setPrevSibling(vprev);
      v.setNextSibling(vnext);
      if (i == 0) {
        v.setIsRoot(true);
      }
    }

    ArrayList<DistanceJoint> joints = new ArrayList();
    for (var v : vertices) {
      var v2 = v.nextSibling.nextSibling;
      var dj = new DistanceJoint(v, v.nextSibling, effectiveVertexDistance, 0.75);
      joints.add(dj);
      dj = new DistanceJoint(v, v2, effectiveVertexDistance * 2, 0.25);
      joints.add(dj);
    }
    // うぅう、わかりゃん＼(^_^)／コメントアウトする（汗）
    //joints.flat();

    float area = geometry.polygonArea(vertices) * random(0.6, 0.9);
    float currentArea = area;
    float areaDiff = 0;
    ChainableParticle rootParticle = vertices.get(0);
    ArrayList<ChainableParticle> particles = vertices;
    color c = color(random(360), 100, 100);
    Blob blob = new Blob(area, currentArea, areaDiff,
      rootParticle, particles, joints, radius, c);
    for (var particle : blob.particles) {
      particle.parent = blob;
    }
    return blob;
  }
  class Coordinate2D {
    float x, y;
    Coordinate2D(float x, float y) {
      this.x = x;
      this.y = y;
    }
  }
  //static class geometry {
  Geometry geometry = new Geometry();
  class Geometry {
    //static Coordinate2D getLineNormal(
    Coordinate2D getLineNormal(
      float x1,
      float y1,
      float x2,
      float y2
      ) {
      return new Coordinate2D(y2 - y1, -(x2 - x1));
    }

    //static Coordinate2D normalize
    Coordinate2D normalize
      (Coordinate2D coord) {
      float mag = pow((coord.x * coord.x + coord.y * coord.y), 0.5);
      if (mag > 1) {
        return new Coordinate2D(coord.x / mag, coord.y / mag);
      }
      return new Coordinate2D(0, 0);
    }

    //static Coordinate2D limit
    Coordinate2D limit
      (Coordinate2D coord, float maxLength) {
      if (coord == null) return null;
      float mag = pow((coord.x * coord.x + coord.y * coord.y), 0.5);
      if (mag > maxLength) {
        return new Coordinate2D((coord.x / mag) * maxLength, (coord.y / mag) * maxLength);
      }
      return coord;
    }

    //static Coordinate2D rotate
    Coordinate2D rotate
      (float x, float y, float rot) {
      return new Coordinate2D(x * cos(rot) - y * sin(rot), x * sin(rot) + y * cos(rot));
    }

    //static float polygonArea
    float polygonArea
      (ArrayList<ChainableParticle> polygon) {
      // compute area
      float area = 0;
      int n = polygon.size();
      for (int i = 1; i <= n; i++) {
        area +=
          polygon.get(i % n).x * (polygon.get((i + 1) % n).y - polygon.get((i - 1) % n).y);
      }
      return area / 2.0f;
    }
  }
  class HashGrid {
    int w, h;
    int cellSize;
    HashMap<String, HashSet<ChainableParticle>> grid;
    HashGrid(int w, int h, int cellSize) {
      this.w = w;
      this.h = h;
      this.cellSize = cellSize;
      this.grid = new HashMap();
      this._initGrid();
    }

    void _initGrid() {
      int yLen = this.h / this.cellSize;
      int xLen = this.w / this.cellSize;
      for (int y = 0; y < yLen; y++) {
        for (int x = 0; x < xLen; x++) {
          this.grid.put(
            this.getKey(x * this.cellSize, y * this.cellSize),
            new HashSet()
            );
        }
      }
    }

    int getIndex(int value) {
      return (int)(value / this.cellSize);
    }

    String getKey(int x, int y) {
      return this._getKeyByIndices(this.getIndex(x), this.getIndex(y));
    }

    String _getKeyByIndices(int xi, int yi) {
      return xi + "." + yi;
    }

    HashSet<ChainableParticle> addItem(ChainableParticle item) {
      String ky = this.getKey((int)item.x, (int)item.y);
      if (this.grid.get(ky) == null) {
        HashSet<ChainableParticle> cell = new HashSet();
        cell.add(item);
        this.grid.put(ky, cell);
        return cell;
      }
      // （これコピーして返さんで大丈夫かなぁ。。。）
      HashSet<ChainableParticle> cell = this.grid.get(ky);
      cell.add(item);
      return cell;
    }

    void removeItem(ChainableParticle item) {
      String ky = this.getKey((int)item.x, (int)item.y);
      if (this.grid.get(ky) == null) return;
      this.grid.get(ky).remove(item);
    }

    HashSet<ChainableParticle> query(int x, int y, int radius) {
      int xi0 = this.getIndex(x - radius) - 1;
      int xi1 = this.getIndex(x + radius) + 1;
      int yi0 = this.getIndex(y - radius) - 1;
      int yi1 = this.getIndex(y + radius) + 1;
      HashSet<ChainableParticle> result = new HashSet();
      String ky;
      for (int xi = xi0; xi <= xi1; xi++) {
        for (int yi = yi0; yi <= yi1; yi++) {
          ky = this._getKeyByIndices(xi, yi);
          if (this.grid.get(ky) != null) {
            //this.grid.get(ky).forEach(result.add, result);
            HashSet<ChainableParticle> v = this.grid.get(ky);
            for (ChainableParticle p : v) {
              result.add(p);
            }
          }
        }
      }
      return result;
    }

    HashGridClient createClient(ChainableParticle item) {
      return new HashGridClient(this, item);
    }
  }

  class HashGridClient {
    HashGrid hashGrid;
    ChainableParticle item;
    int indexX, indexY;
    HashSet<ChainableParticle> cell;
    HashGridClient(HashGrid hashGrid, ChainableParticle item) {
      this.hashGrid = hashGrid;
      this.item = item;
      this.indexX = this.hashGrid.getIndex((int)item.x);
      this.indexY = this.hashGrid.getIndex((int)item.y);
      this.cell = this.hashGrid.addItem(item);
    }

    void update() {
      int newIndexX = this.hashGrid.getIndex((int)this.item.x);
      int newIndexY = this.hashGrid.getIndex((int)this.item.x);
      if (newIndexX == this.indexX && newIndexY == this.indexY) return;

      this.cell.remove(this.item);
      this.cell = this.hashGrid.addItem(this.item);
      this.indexX = newIndexX;
      this.indexY = newIndexY;
    }

    void delete() {
      this.cell.remove(this.item);
    }
  }
  class DistanceJoint {
    Particle pointA, pointB;
    float originalLen, len, strength;
    DistanceJoint(
      Particle pointA,
      Particle pointB,
      float len,
      float strength
      ) {
      this.pointA = pointA;
      this.pointB = pointB;
      this.originalLen = len;
      this.len = len;
      this.strength = strength;
    }

    //void update(dt = 1) {
    void update(float dt) {
      float diffx = this.pointB.x - this.pointA.x;
      float diffy = this.pointB.y - this.pointA.y;
      float mag = pow((diffx * diffx + diffy * diffy), 0.5);
      float diffMag = this.len - mag;
      if (mag > 0) {
        float dA =
          (((this.pointA.mass / (this.pointA.mass + this.pointB.mass)) *
          diffMag *
          this.strength) /
          mag) *
          -dt;
        float dB =
          (((this.pointB.mass / (this.pointA.mass + this.pointB.mass)) *
          diffMag *
          this.strength) /
          mag) *
          dt;
        this.pointA.move(diffx * dA, diffy * dA);
        this.pointB.move(diffx * dB, diffy * dB);
      }
    }
  }
  class Particle extends Coordinate2D {
    float prevX, prevY;
    float sx, sy;
    float vx, vy;
    float radius;
    float damping;
    float friction;
    float mass;
    Blob parent;
    HashGridClient client;
    Particle(
      float x,
      float y,
      float radius,
      float damping,
      float friction,
      float mass,
      Blob parent
      ) {
      super(x, y);
      this.prevX = x;
      this.prevY = y;
      this.sx = x;
      this.sy = y;
      this.vx = 0;
      this.vy = 0;
      // とりあえず、こうしておこう♪
      //this.radius = radius ?? 10;
      //this.damping = damping ?? 0.9;
      //this.friction = friction ?? 0.1;
      //this.mass = mass ?? 1;
      this.radius = radius;
      this.damping = damping;
      this.friction = friction;
      this.mass = mass;
      this.parent = parent;
    }

    void setClient(HashGridClient client) {
      this.client = client;
    }

    void move(float dx, float dy) {
      this.x += dx;
      this.y += dy;
    }

    void addForce(float fx, float fy) {
      this.vx += fx;
      this.vy += fy;
    }

    void attract(
      float otherX,
      float otherY,
      //strength = 1
      float strength
      ) {
      float diffx = otherX - this.x;
      float diffy = otherY - this.y;
      float mag = diffx * diffx + diffy * diffy;
      if (mag > 0.1) {
        float magSqrt = 1 / pow(mag, 0.5);
        this.addForce(
          diffx * magSqrt * strength, // force x
          diffy * magSqrt * strength // force y
          );
      }
    }

    Coordinate2D repel(
      float otherX,
      float otherY,
      //radius = 1,
      //strength = 1
      float radius,
      float strength
      ) {
      float diffx = this.x - otherX;
      float diffy = this.y - otherY;
      float mag = diffx * diffx + diffy * diffy;
      float combinedRadius = radius + this.radius;
      float minDist = combinedRadius * combinedRadius;
      if (mag > 0 && mag < minDist) {
        float magSqrt = pow(1 / mag, 0.5);
        float forceX = diffx * magSqrt * strength;
        float forceY = diffy * magSqrt * strength;
        this.addForce(forceX, forceY);
        return new Coordinate2D(forceX, forceY);
      }
      return null;
    }

    Coordinate2D testCollision(
      float otherX,
      float otherY,
      float radius
      ) {
      float diffx = otherX - this.x;
      float diffy = otherY - this.y;
      float diffMag = diffx * diffx + diffy * diffy;
      float combinedRadius = radius + this.radius;
      if (diffMag < pow(combinedRadius, 2)) {
        float forceMag = pow(diffMag, 0.5) - combinedRadius;
        float invMag = 1 / diffMag;
        float fx = diffx * invMag * forceMag;
        float fy = diffy * invMag * forceMag;
        return new Coordinate2D(fx, fy);
      }
      return null;
    }

    Coordinate2D collide(
      float otherX,
      float otherY,
      float radius
      ) {
      float diffx = otherX - this.x;
      float diffy = otherY - this.y;
      float diffMag = diffx * diffx + diffy * diffy;
      float combinedRadius = radius + this.radius;
      if (diffMag < pow(combinedRadius, 2)) {
        float forceMag = pow(diffMag, 0.5) - combinedRadius;
        float invMag = 1 / diffMag;
        float fx = diffx * invMag * forceMag;
        float fy = diffy * invMag * forceMag;

        this.move(fx, fy);

        this.prevX = lerp(this.prevX, this.x, this.friction);
        this.prevY = lerp(this.prevY, this.y, this.friction);

        return new Coordinate2D(fx, fy);
      }
      return null;
    }

    void constrain(
      float left,
      float top,
      float right,
      float bottom
      ) {
      final float x = this.x;
      final float y = this.y;
      final float friction = this.friction;
      final float radius = this.radius;

      left += radius;
      top += radius;
      right -= radius;
      bottom -= radius;

      boolean collide = false;

      if (x > right) {
        this.x = right;
        collide = true;
      } else if (x < left) {
        this.x = left;
        collide = true;
      }
      if (y > bottom) {
        this.y = bottom;
        collide = true;
      } else if (y < top) {
        this.y = top;
        collide = true;
      }

      if (collide) {
        this.prevX = lerp(this.prevX, this.x, friction);
        this.prevY = lerp(this.prevY, this.y, friction);
      }
    }

    Coordinate2D getVelocity() {
      return new Coordinate2D(this.vx, this.vy);
    }

    float getVelocityMag() {
      return pow((this.vx * this.vx + this.vy * this.vy), 0.5);
    }

    //update(dt = 1) {
    void update(float dt) {
      this.prevX = this.x;
      this.prevY = this.y;

      this.x += this.vx * dt;
      this.y += this.vy * dt;
    }

    //endUpdate(dt = 1) {
    void endUpdate(float dt) {
      float m = this.damping / dt;
      this.vx = (this.x - this.prevX) * m;
      this.vy = (this.y - this.prevY) * m;
    }

    void updateClient() {
      if (this.client != null) this.client.update();
    }
  }

  class ChainableParticle extends Particle {
    boolean isRoot;
    ChainableParticle prevSibling, nextSibling;
    ChainableParticle(
      float x,
      float y,
      float radius,
      float damping,
      float friction,
      float mass,
      Blob parent
      ) {
      super(x, y, radius, damping, friction, mass, parent);
      this.isRoot = false;
      this.prevSibling = null;
      this.nextSibling = null;
    }
    void setIsRoot(boolean isRoot) {
      this.isRoot = isRoot;
    }

    void setNextSibling(ChainableParticle sibling) {
      this.nextSibling = sibling;
    }
    void setPrevSibling(ChainableParticle sibling) {
      this.prevSibling = sibling;
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
