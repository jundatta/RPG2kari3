import java.util.LinkedList;


// コングラチュレーション画面まとめ
class Congratulations {
  final LinkedList<Class> mStub = new LinkedList<>();
  final PApplet mApp;

  Congratulations(PApplet app) {
    mApp = app;
    setup();
  }

  // コングラチュレーション画面を準備しておく
  void setup() {
    mStub.clear();

    Class[] classes = mApp.getClass().getDeclaredClasses(); // すべてのクラスを列挙
    for (Class clazz : classes) {
      if (!GameSceneCongratulationsBase.class.isAssignableFrom(clazz)) continue; // GameSceneCongratulationsBaseかその派生でなければcontinue
      String name = clazz.getSimpleName(); // クラス名
      if (!Character.isDigit(name.charAt(name.length() - 1))) continue; // 最後が数字でなければcontinue
      mStub.add(clazz);
    }

    java.util.Collections.shuffle(mStub);
  }

  // コングラチュレーション画面へとべよー
  void jump() {
    if (mStub.isEmpty()) {
      // おしまい♪
      // ＼(^_^)／
      //      setup();
      gGameStack.change(new GameSceneOshimai());
      return;
    }

    Class clazz = mStub.pop();
    try {
      java.lang.reflect.Constructor<GameScene> ctor = clazz.getDeclaredConstructor(mApp.getClass()); // コンストラクタ取得
      GameScene gs = ctor.newInstance(mApp); // コングラインスタンス生成
      gGameStack.change(gs); // 遷移
    }
    catch(Exception e) {
      e.printStackTrace();
    }

    String s = clazz.getSimpleName();
    println(s);
    String number = s.replaceAll("[^0-9]", "");
    surface.setTitle(mainTitle + "[" + number + "]");
  }
}

class GameSceneCongratulationsBase extends GameScene {
  final int omakeSec = 16;  // オマケのデモ秒数
  int mMillis;
  MinimAssistance mMA = null;

  // コングラチュレーション画面毎で使うframeCountを設ける
  int mFrameCount;
  void resetCount() {
    mFrameCount = frameCount;
  }
  int getCount() {
    return frameCount - mFrameCount;
  }

  @Override void autoSetup() {
    mMA = new MinimAssistance(gGameStack.mApplet);
    mMillis = millis();
  }
  // true:遷移した
  @Override boolean autoDraw() {
    // デモ状態でなければ何もしない
    if (gbAutoDemo == false) {
      return false;
    }

    // デモ状態なので。。。
    // omakeSec秒間放置されたらタイトル画面にとべよ～
    if (mMillis + omakeSec * 1000 < millis()) {
      gGameStack.change(new GameSceneTitle());
      return true;
    }
    return false;
  }
  @Override void cleanup() {
    // minim（音を鳴らすやつ）のコングラチュレーション画面毎の
    // あとかたずけをする
    if (mMA == null) {
      return;
    }
    mMA.allRemove();
  }

  // コングラチュレーションのテキスト表示
  void logoRightLower(color c) {
    push();
    translate(width * 0.64f, 0);
    scale(0.4f);
    translate(0, +(height * 1.90f));
    logo(c);
    pop();
  }
  void logoRightUpper(color c) {
    push();
    translate(width * 0.64f, 0);
    scale(0.4f);
    translate(0, -(height * 0.45f));
    logo(c);
    pop();
  }
  void logoLeftLower(color c) {
    push();
    translate(-(width * 0.05f), 0);
    scale(0.4f);
    translate(0, +(height * 1.90f));
    logo(c);
    pop();
  }
  void logo(color c) {
    PGraphics pg = getGraphics();
    logo(pg, c);
  }
  void logo(PGraphics pg, color c) {
    pg.push();
    pg.fill(c);
    pg.textAlign(CENTER, CENTER);
    pg.textFont(gPacifico);
    pg.textSize(50);
    String s = "Congratulation!";
    if (gbAutoDemo) {
      s = "Demonstration!";
    }
    pg.text(s, 0, 0, width, height);
    pg.pop();
  }
}
