GameStack setupEventHook(PApplet applet) {
  GameStack gameStack = new GameStack(applet);
  return gameStack;
}

void draw() {
  // GameStackから外れていくGameSceneがあればcleanup()を呼ぶ
  if (gGameStack.mCleanup != null) {
    gGameStack.mCleanup.cleanup();
    gGameStack.mCleanup = null;

    // frameRateを60に再設定する
    frameRate(60);

    // シェーダーをやめる
    resetShader();
    // パースを戻す
    perspective();
    // カメラに関連する行列をデフォルトに戻す
    camera();
    // 光源をデフォルトに戻す
    lights();
    // sphereDetail()はpush()/pop()でガードできない模様なので
    // ここでデフォルト値に戻す
    sphereDetail(30);
    // Zバッファのチェックを有効に戻す
    hint(ENABLE_DEPTH_TEST);

    // 光源の設定をデフォルトに戻す
    // 　⇒ void draw()が呼ばれるたびに初期化されていると思われるため
    // 　　 再設定は不要と考える
    // lights();

    // ambient()を呼んでもpush()/pop()で環境光の反射の割合の値
    // （ambientR,ambientG,amgientB）を保存しているが、
    // 環境光の計算をするか否かを示す？フラグ（setAmbient）は
    // push()/pop()の対象ではなかった。
    //
    // 初期値？と思われる1.0にpop()で戻るとこの1.0で環境光の計算をしていると
    // 思われるがこの値だと真っ白になってしまう。
    //
    // 。。。（本来であれば）push()/pop()の対象にsetAmbientを含めるのが
    // ベターと考えるが、APL側からこのフラグを書き換えることができたため
    // setAmbientのフラグをfalseに落とすようにした。
    PGraphics g = getGraphics();
    g.setAmbient = false;

    return;
  }
  GameScene gs = gGameStack.peek();
  if (gs.mbSetup) {
    gs.mbSetup = false;
    gs.autoSetup();
    gs.setup();
    return;
  }
  boolean bChangeState = gs.autoDraw();
  // 遷移していたらリターンする（draw()はしない。終わり）
  if (bChangeState) {
    return;
  }
  gs.draw();
}
void mousePressed() {
  gGameStack.peek().mousePressed();
}
void mouseReleased() {
  gGameStack.peek().mouseReleased();
}
void mouseDragged() {
  gGameStack.peek().mouseDragged();
}
void mouseMoved() {
  gGameStack.peek().mouseMoved();
}

void keyPressed() {
  gGameStack.peek().keyPressed();
}
void keyReleased() {
  gGameStack.peek().keyReleased();
}
void keyTyped() {
  gGameStack.peek().keyTyped();
}
