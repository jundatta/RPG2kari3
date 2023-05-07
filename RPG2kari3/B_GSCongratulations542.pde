// コングラチュレーション画面
//
// こちらがオリジナルです。
// 【作者】中内　純(ハンドルネーム：JunKiyoshi)さん
// 【作品名】Random walker group random walking. Draw by openFrameworks
// https://junkiyoshi.com/openframeworks20230428/
//

class GameSceneCongratulations542 extends GameSceneCongratulationsBase {
  class Actor {
    int select_index;
    int next_index;
    PVector location;
    color c;

    // destination_listの中にindexと同じ値があればtrueを返す
    boolean isSameValue(IntList destination_list, int index) {
      for (int d : destination_list) {
        if (d == index) {
          // 同じ値が見つかったのでtrueを返す
          return true;
        }
      }
      // 同じ値はなかったのでfalseを返す
      return false;
    }
    //Actor(vector<glm::vec3>& location_list, vector<vector<int>>& next_index_list, vector<int>& destination_list);
    // コンストラクタの引数に色も追加して生成時に色もセットする
    Actor(ArrayList<PVector> location_list, IntList destination_list, color c) {
      this.select_index = (int)random(location_list.size());
      // select_indexと同じ値がdestination_listになければ追加する
      // select_indexと同じ値がある場合は(select_index+1)で改めてdestination_listを走査する
      while (true) {
        // select_indexと同じ値がdestination_listにあるか調べる
        if (isSameValue(destination_list, select_index) == false) {
          // 同じ値はなかったので追加して抜ける
          destination_list.append(this.select_index);
          break;
        }
        this.select_index = (this.select_index + 1) % location_list.size();
      }
      this.next_index = this.select_index;

      this.c = c;
    }
    //void update(const int& frame_span, vector<glm::vec3>& location_list, vector<vector<int>>& next_index_list, vector<int>& destination_list);
    void update(int frame_span, ArrayList<PVector> location_list, ArrayList<IntList> next_index_list, IntList destination_list) {
      if (ofGetFrameNum() % frame_span == 0) {
        var tmp_index = this.select_index;
        this.select_index = this.next_index;
        //int retry = next_index_list[this->select_index].size();
        IntList ixList = next_index_list.get(this.select_index);
        int retry = ixList.size();
        //this->next_index = next_index_list[this->select_index][(int)ofRandom(next_index_list[this->select_index].size())];
        int ix = (int)random(retry);
        this.next_index = ixList.get(ix);
        while (--retry > 0) {
          // destination_listの中にnext_indexがなければ処理する
          if (isSameValue(destination_list, next_index) == false) {
            if (tmp_index != this.next_index) {
              destination_list.append(this.next_index);
              break;
            }
          }
          //this->next_index = next_index_list[this->select_index][(this->next_index + 1) % next_index_list[this->select_index].size()];
          // いやいや、chatなんちゃらさんの指摘は間違ってない。
          //  ⇒this.next_index = (this.next_index + 1) % ixList.size();
          //    ixList.get()が抜けてるだけで俺の置き換え間違い...orz
          //    （うぎゃぁぁあああああああ＼(^_^)／）
          //this.next_index = ixList.get(this.next_index + 1) % ixList.size();
          this.next_index = ixList.get((this.next_index + 1) % ixList.size());
        }
        if (retry <= 0) {
          destination_list.append(this.select_index);
          this.next_index = this.select_index;
        }
      }
      int param = ofGetFrameNum() % frame_span;
      //auto distance = location_list[this->next_index] - location_list[this->select_index];
      PVector nV = location_list.get(this.next_index);
      PVector sV = location_list.get(this.select_index);
      PVector distance = PVector.sub(nV, sV);
      //this->location = location_list[this->select_index] + distance / frame_span * param;
      distance.div(frame_span);
      distance.mult(param);
      this.location = PVector.add(sV, distance);
    }
    PVector getLocation() {
      return this.location;
    }
    color getColor() {
      return this.c;
    }
  }

  ArrayList<PVector> parent_location_group;
  ArrayList<IntList> parent_next_index_group;
  IntList parent_destination_group;
  ArrayList<Actor> parent_actor_group;

  ArrayList<ArrayList<PVector>> location_group_list;
  ArrayList<ArrayList<IntList>> next_index_group_list;
  ArrayList<IntList> destination_group_list;
  ArrayList<ArrayList<Actor>> actor_group_list;

  //--------------------------------------------------------------
  @Override void setup() {
    parent_location_group = new ArrayList();
    parent_next_index_group = new ArrayList();
    parent_destination_group = new IntList();
    parent_actor_group = new ArrayList();

    location_group_list = new ArrayList();
    next_index_group_list = new ArrayList();
    destination_group_list = new ArrayList();
    actor_group_list = new ArrayList();

    IntList base_color_list = new IntList();
    int[] hex_list = { #ee6352, #59cd90, #3fa7d6, #fac05e, #f79d84 };
    for (int hex : hex_list) {
      base_color_list.append(hex);
    }

    int span = 135;
    for (int x = -span; x <= span; x += span) {
      for (int y = -span; y <= span; y += span) {
        for (int z = -span; z <= span; z += span) {
          this.parent_location_group.add(new PVector(x, y, z));
        }
      }
    }

    for (var location : this.parent_location_group) {
      IntList next_index = new IntList();
      int index = -1;
      for (var other : this.parent_location_group) {
        index++;
        //if (location == other) {
        if (location.x == other.x
          && location.y == other.y
          && location.z == other.z) {
          continue;
        }

        float distance = PVector.dist(location, other);
        if (distance <= span) {
          next_index.append(index);
        }
      }
      this.parent_next_index_group.add(next_index);
    }

    for (int i = 0; i < 20; i++) {
      color c = base_color_list.get(i % base_color_list.size());
      Actor a = new Actor(this.parent_location_group, this.parent_destination_group, c);
      this.parent_actor_group.add(a);
    }

    span = 25;
    for (int g = 0; g < this.parent_actor_group.size(); g++) {
      ArrayList<PVector> location_group = new ArrayList();
      for (int x = -span * 2; x <= span * 2; x += span) {
        for (int y = -span * 2; y <= span * 2; y += span) {
          for (int z = -span * 2; z <= span * 2; z += span) {
            location_group.add(new PVector(x, y, z));
          }
        }
      }
      location_group_list.add(location_group);

      ArrayList<IntList> next_index_group = new ArrayList();
      for (var location : location_group) {
        IntList next_index = new IntList();
        int index = -1;
        for (var other : location_group) {
          index++;
          //if (location == other) {
          if (location.x == other.x
            && location.y == other.y
            && location.z == other.z) {
            continue;
          }

          float distance = PVector.dist(location, other);
          if (distance <= span) {
            next_index.append(index);
          }
        }
        next_index_group.add(next_index);
      }
      this.next_index_group_list.add(next_index_group);

      ArrayList<Actor> actor_group = new ArrayList();
      IntList destination_group = new IntList();
      for (int i = 0; i < 100; i++) {
        //color.setHsb((int)(this->parent_actor_group[g]->getColor().getHue() + ofRandom(30)) % 255, 255, 255);
        //actor_group.back()->setColor(color);
        Actor aa = this.parent_actor_group.get(g);
        color c = aa.getColor();
        push();
        colorMode(HSB, 255, 255, 255);
        int h = ((int)hue(c) + (int)random(30)) % 255;
        c = color(h, 255, 255);
        pop();

        var a = new Actor(location_group, destination_group, c);
        actor_group.add(a);
      }

      this.actor_group_list.add(actor_group);
      this.destination_group_list.add(destination_group);
    }
  }

  //--------------------------------------------------------------
  void update() {
    int frame_span = 30;
    int prev_index_size = 0;

    if (ofGetFrameNum() % frame_span == 0) {
      prev_index_size = this.parent_destination_group.size();
    }

    for (var actor : this.parent_actor_group) {
      actor.update(frame_span, this.parent_location_group, this.parent_next_index_group, this.parent_destination_group);
    }

    if (prev_index_size != 0) {
      //this.parent_destination_group->erase(this.parent_destination_group->begin(), this->parent_destination_group.begin() + prev_index_size);
      for (int i = 0; i < prev_index_size; i++) {
        this.parent_destination_group.remove(0);
      }
    }

    frame_span = 10;
    for (int g = 0; g < this.parent_actor_group.size(); g++) {
      IntList destList = this.destination_group_list.get(g);
      ArrayList<PVector> locList = this.location_group_list.get(g);
      ArrayList<IntList> nextList = this.next_index_group_list.get(g);
      ArrayList<Actor> actList = this.actor_group_list.get(g);

      if (ofGetFrameNum() % frame_span == 0) {
        prev_index_size = destList.size();
      }

      for (var actor : actList) {
        actor.update(frame_span, locList, nextList, destList);
      }

      if (prev_index_size != 0) {
        //this->destination_group_list[g].erase(this->destination_group_list[g].begin(), this->destination_group_list[g].begin() + prev_index_size);
        for (int i = 0; i < prev_index_size; i++) {
          destList.remove(0);
        }
      }
    }
  }

  //--------------------------------------------------------------
  @Override void draw() {
    push();
    update();
    translate(width * 0.5f, height * 0.5f);

    background(239);
    ofSetLineWidth(1);

    ofRotateY(ofGetFrameNum() * 0.5);

    for (int g = 0; g < parent_actor_group.size(); g++) {
      pushMatrix();
      PVector loc = this.parent_actor_group.get(g).getLocation();
      translate(loc.x, loc.y, loc.z);

      for (var actor : this.actor_group_list.get(g)) {
        fill(actor.getColor());
        stroke(239);
        push();
        PVector p = actor.getLocation();
        translate(p.x, p.y, p.z);
        box(22);
        pop();
      }
      popMatrix();
    }
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
