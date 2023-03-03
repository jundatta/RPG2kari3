import ddf.minim.*;

import java.util.Map;  //ハッシュマップの機能をインポート
import java.util.HashMap;

class MinimAssistance {
  Minim mMinim;
  HashMap<String, AudioPlayer> mHashMap;

  MinimAssistance(PApplet pa) {
    mMinim = new Minim(pa);
    mHashMap = new HashMap<String, AudioPlayer>();
  }
  void entry(String lookUp, String fileName) {
    AudioPlayer ap = mMinim.loadFile(fileName);
    mHashMap.put(lookUp, ap);
  }
  void remove(String lookUp) {
    pauseAndRewind(lookUp);
    mHashMap.remove(lookUp);
  }
  void playAndRewind(String lookUp) {
    AudioPlayer ap = mHashMap.get(lookUp);
    ap.play();
    ap.rewind();
  }
  void loop(String lookUp) {
    AudioPlayer ap = mHashMap.get(lookUp);
    ap.loop();
  }
  void pauseAndRewind(String lookUp) {
    AudioPlayer ap = mHashMap.get(lookUp);
    ap.pause();
    ap.rewind();
  }
  void allPauseAndRewind() {
    for (Map.Entry<String, AudioPlayer> me : mHashMap.entrySet()) {
      AudioPlayer ap = me.getValue();
      ap.pause();
      ap.rewind();
    }
  }
  void allRemove() {
    for (Map.Entry<String, AudioPlayer> me : mHashMap.entrySet()) {
      AudioPlayer ap = me.getValue();
      ap.close();
    }
    mMinim.stop();
  }
}
