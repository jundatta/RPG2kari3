setup=_=> {
  createCanvas(800, 600, WEBGL);
  n=0;
}
draw=_=> {
  background(0);

  // スポットライトを置く
  // 光の色は紫色にする
  // ライトの位置は原点から画面手前（z座標）500.0fにする
  // ライトの向きを横にぐるぐる回す
  // コーンの広がりを60度、よくわかりゃん値を20.0fにする
  spotLight(255, 0, 255, 0, 0, 500, sin(n), 0, cos(n), PI/3.0, 20);

  // 白い板にスポットライトを当てる
  noStroke();
  fill(255);
  box(600, 500, 10);

  n+=0.02;
}
