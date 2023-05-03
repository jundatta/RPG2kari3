final String mainTitle = "RPG2（仮）^3";

GameStack gGameStack;
MinimAssistance gMinimAssistance;
PApplet gApplet;

PImage gEarth;
PImage gMoon;
PFont gFont;
PFont gPacifico;
PFont gTitanOne;

// デモ状態かどうかを表すフラグ
// true : デモ中
boolean gbAutoDemo = false;

// コングラチュレーション画面まとめ
Congratulations gCongratulations;

void setup() {
  gApplet = this;

  P5JS.setup(this);

  size(540, 960, P3D);
  //  printMatrix();
  background(0);
  // こちらを参考にさせて頂きました。
  // http://mslabo.sakura.ne.jp/WordPress/make/processing%E3%80%80%E9%80%86%E5%BC%95%E3%81%8D%E3%83%AA%E3%83%95%E3%82%A1%E3%83%AC%E3%83%B3%E3%82%B9/ttf-otf%E3%83%95%E3%82%A9%E3%83%B3%E3%83%88%E3%82%92%E8%AA%AD%E3%81%BF%E8%BE%BC%E3%82%80%E3%81%AB%E3%81%AF/
  // 自己啓発。人生について考える
  // 　TTF/OTFフォントを読み込むには
  //  gFont = createFont("メイリオ", 50);
  // https://inaridarkfox4231.github.io/assets/HuiFont29.ttf
  gFont = createFont("HuiFont29.ttf", 50, true);
  gPacifico = createFont("Pacifico-Regular.ttf", 50, true);
  gTitanOne = createFont("TitanOne-Regular.ttf", 50, true);
  textFont(gFont);

  gEarth = loadImage("earth.png");
  gMoon = loadImage("full-moon-1869760_640.png");

  setupMinim(this);

  // コングラチュレーション画面を準備しておく
  gCongratulations = new Congratulations(this);
  gCongratulations.setup();

  gGameStack = setupEventHook(this);
  // ビューア機能搭載＼(^_^)／（by PC-8001(TN8001)さん）
  //gGameStack = new Viewer8001GameStack(this);

  gGameStack.change(new GameSceneTitle());
  //gGameStack.change(new GameSceneCongratulations538());
}

void setupMinim(PApplet applet) {
  gMinimAssistance = new MinimAssistance(applet);
  gMinimAssistance.entry("立ちました！！", "35.mp3");  // "決定、ボタン押下35.mp3"
  gMinimAssistance.entry("堕ちました。", "26.mp3");  // "決定、ボタン押下26.mp3"
  gMinimAssistance.entry("ポン！！", "34.mp3");  // "決定、ボタン押下34.mp3"
  gMinimAssistance.entry("壁！！", "47.mp3");  // "決定、ボタン押下47.mp3"
}
