import java.util.ArrayDeque;
import java.util.Deque;

class GameStack {
  PApplet mApplet;
  Deque<GameScene> mGameScene;
  // 終わるGameScene
  GameScene mCleanup;

  GameStack(PApplet pa) {
    mApplet = pa;
    mGameScene = new ArrayDeque<GameScene>();
    mCleanup = null;
  }
  void change(GameScene gs) {
    if (!mGameScene.isEmpty()) {
      mApplet.pop();      // 描画のpop()
      mCleanup = mGameScene.pop();
    }
    mApplet.push();      // 描画のpush()
    mGameScene.push(gs);
  }
  GameScene peek() {
    return mGameScene.peek();
  }
  void push(GameScene gs) {
    mApplet.push();      // 描画のpush()
    mGameScene.push(gs);
  }
  void pop() {
    mApplet.pop();      // 描画のpop()
    mGameScene.pop();
  }
}
