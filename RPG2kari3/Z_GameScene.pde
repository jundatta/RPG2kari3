class GameScene {
  // 一番最初のdraw()でsetup()を起動する
  boolean mbSetup = true;

  // デモ用setup()
  void autoSetup() {
  }
  void setup() {
  }
  // デモ用draw()
  // true:遷移した
  boolean autoDraw() {
    return false;
  }
  void draw() {
  }
  // 終了処理
  void cleanup() {
  }
  void mousePressed() {
  }
  void mouseReleased() {
  }
  void mouseDragged() {
  }
  void mouseMoved() {
  }
  void keyPressed() {
    if (key == ESC) {
      key = 0;
    }
  }
  void keyReleased() {
  }
  void keyTyped() {
  }

  // 背景消去
  void clearBackground(int alpha) {
    fill(0, 0, 0, alpha);
    rect(0, 0, width, height);
  }

  // 押されたキーを確認する
  boolean isKey(int checkKey) {
    // そもそもキーが押されているか？
    if (!keyPressed) {
      return false;
    }
    // 特殊なキーでない普通のキーコードで合致するか？
    if (key == checkKey) {
      return true;
    }
    // 特殊キー待ちか？
    //final int[] SPECIAL = {
    //  UP, DOWN, LEFT, RIGHT, ALT, CONTROL, SHIFT,
    //  BACKSPACE, TAB, ENTER, RETURN, ESC, DELETE
    //};
    //int i;
    //for (i = 0; i < SPECIAL.length; i++) {
    //  if (SPECIAL[i] == checkKey) {
    //    break;
    //  }
    //}
    //if (i == SPECIAL.length) {
    //  return false;  // 特殊キー待ちではなかったので終わる
    //}
    // 待っている特殊キーと合致するか？
    if (keyCode == checkKey) {
      return true;
    }
    return false;
  }
}
