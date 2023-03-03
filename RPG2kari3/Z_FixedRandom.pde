// 【デバッグ用】Processing java用の乱数固定化

class FixedRandom {
  final String fileName = "debug/fixedFandom.csv";
  PrintWriter writer;
  FloatList randomList = new FloatList();
  int ctLoad;
  void saveOpen() {
    writer = createWriter(fileName);
  }
  float saveRandom() {
    float r = random(1);
    writer.println(r);
    writer.flush();
    return r;
  }
  void saveClose() {
    writer.close();
  }

  void loadSetup() {
    randomList = new FloatList();
    BufferedReader reader = createReader(fileName);
    try {
      String s = reader.readLine();
      while (s != null) {
        randomList.append(float(s));
        s = reader.readLine();
      }
      reader.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
    ctLoad = 0;
  }
  float loadRandom() {
    float r = randomList.get(ctLoad);
    ctLoad++;
    return r;
  }
  int loadSize() {
    return randomList.size();
  }
}

// P5.js用の乱数固定化（読み込みだけ）

/**************************************************************
 // ※インスタンス生成（new）はfunction preload()で行ってくださいにゃー
 class FixedRandom {
 constructor() {
 this.randomList = loadStrings('debug/fixedFandom.csv');
 this.ctLoad = 0;
 }
 
 loadRandom() {
 let r = this.randomList[this.ctLoad];
 this.ctLoad++;
 return float(r);
 }
 loadSize() {
 return this.randomList.length - 1;
 }
 }**************************************************************/
