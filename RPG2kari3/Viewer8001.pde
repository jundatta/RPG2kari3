import processing.awt.PSurfaceAWT;
import processing.core.PApplet;
import processing.event.KeyEvent;

import javax.swing.BorderFactory;
import javax.swing.DefaultListModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JLayeredPane;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.ListCellRenderer;
import javax.swing.ListSelectionModel;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Font;
import java.awt.Image;
import java.util.Comparator;
import java.util.List;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

// コングラチュレーション画面側でnoLoop()を呼ばないこと
// 「スクリーンショット」のボタンを押してmainApp.save(file)が
// 呼ばれたときに（JavaVM？の都合が悪いみたいで？）落ちる
//
//#
//# A fatal error has been detected by the Java Runtime Environment:
//#
//#  EXCEPTION_ACCESS_VIOLATION (0xc0000005) at pc=0x00007ffcbf76988c, pid=4620, tid=8712
//#
//# JRE version:
//OpenJDK Runtime Environment Temurin-17.0.4+8 (17.0.4+8) (build 17.0.4+8)
//# Java VM:
//OpenJDK 64-Bit Server VM Temurin-17.0.4+8 (17.0.4+8, mixed mode, sharing, tiered, compressed oops, compressed class ptrs, g1 gc, windows-amd64)
//# Problematic frame:
//# C  [vm3dgl64.dll+0x3b988c]
//#
//# No core dump will be written. Minidumps are not enabled by default on client versions of Windows
//#
//# If you would like to submit a bug report, please visit:
//#   https://github.com/adoptium/adoptium-support/issues
//# The crash happened outside the Java Virtual Machine in native code.
//# See problematic frame for where to report the bug.
//#


  // コングラビューワー
  public class Viewer8001 extends PApplet implements ListSelectionListener {
  private final PApplet mainApp;
  private final Viewer8001GameStack gameStack;
  private final DefaultListModel<Viewer8001Item> model = new DefaultListModel<>();
  private final JList<Viewer8001Item> list = new JList<>(model);

  Viewer8001(PApplet app, Viewer8001GameStack gameStack) {
    mainApp = app;
    this.gameStack = gameStack;

    for (var clazz : gameStack.classes) {
      model.addElement(new Viewer8001Item(clazz));
    }
  }

  void settings() {
    size(700, 800);
    noLoop();
  }

  void setup() {
    //surface.setResizable(true); // ほんとはリサイズも許可したいが、再描画してくれないのであきらめる（sizeを調整して）

    var l = getWindowLocation(mainApp);
    surface.setLocation(int(l.x) + mainApp.width, int(l.y)); // 位置を本体？右に

    // mainAppのkeyEventを傍受
    mainApp.registerMethod("keyEvent", this);

    // swingのコンポーネントを使用する準備
    var canvas = (PSurfaceAWT.SmoothCanvas) surface.getNative();
    var layeredPane = (JLayeredPane) canvas.getParent().getParent();

    list.addListSelectionListener(this);
    list.setCellRenderer(new Viewer8001ItemRenderer());
    list.setLayoutOrientation(JList.HORIZONTAL_WRAP);
    list.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
    list.setVisibleRowCount(0);

    var panel = new JPanel(new BorderLayout());
    panel.setSize(layeredPane.getWidth(), layeredPane.getHeight());
    var scroll = new JScrollPane(list);
    scroll.getVerticalScrollBar().setUnitIncrement(30);
    panel.add(scroll, BorderLayout.CENTER);

    var button = new JButton("スクリーンショット");
    button.setFont(new Font(Font.SANS_SERIF, Font.BOLD, 24));
    button.addActionListener(e -> {
      if (list.getSelectedValue() != null) {
        var item = list.getSelectedValue();
        var clazz = item.clazz;

        // ↓こうしたいだけなのだがPAppletごとにAnimation Threadがあり、ほとんどの操作はそのスレッドに限られる
        //gameStack.change(clazz);

        // そのためmainAppに捏造したイベントを送り、コールバック（keyEvent()）内から操作することにする
        // キーイベントを捏造（マウスでもいいがキーのほうが頻度が少ない＆マウスよりは相手（GameSceneCongratulations）に被害がないだろう
        // （キーによる遷移はつぶしているが、keyやkeyCodeを見ずに何かしているような場合はそれが動いてしまう）
        mainApp.postEvent(new KeyEvent(clazz, 0, KeyEvent.TYPE, 0, '写', -1)); // ありえないkeyやkeyCodeにしているが気休め程度ｗ
      }
    }
    );
    panel.add(button, BorderLayout.NORTH);

    layeredPane.add(panel);
  }

  @Override public void valueChanged(ListSelectionEvent e) {
    if (e.getValueIsAdjusting()) return;

    if (list.getSelectedValue() != null) {
      var item = list.getSelectedValue();
      mainApp.postEvent(new KeyEvent(item.clazz, 0, KeyEvent.TYPE, 0, '移', -1));
    }
  }

  public void keyEvent(KeyEvent e) {
    if (e.getAction() != KeyEvent.TYPE) return;

    if (e.getKey() == '写') { // スクショ
      var file = "screenshot\\" + ((Class) e.getNative()).getSimpleName() + ".png";
      mainApp.save(file); // 同期のはず

      // Item入れ替えによりその場で表示更新
      model.set(list.getSelectedIndex(), new Viewer8001Item((Class) e.getNative()));
    }

    if (e.getKey() == '移') { // 遷移
      gameStack.change((Class) e.getNative());
    }
  }


  // PAppletの位置取得（P2D,P3D,JAVA2D only）
  // https://discourse.processing.org/t/get-location-of-a-papplet-window/28039/10
  PVector getWindowLocation(PApplet app) {
    switch (app.sketchRenderer()) {
    case P2D:
    case P3D:
      var p = new com.jogamp.nativewindow.util.Point(); // クライアントエリア座標
      ((com.jogamp.newt.opengl.GLWindow) app.getSurface().getNative()).getLocationOnScreen(p);

      // タイトルバー・枠の分のサイズをViewerからとってくる（ダサい
      var i = ((PSurfaceAWT.SmoothCanvas) surface.getNative()).getFrame().getInsets();
      return new PVector(p.getX() - i.left, p.getY() - i.top);

    case JAVA2D:
      var f = ((PSurfaceAWT.SmoothCanvas) app.getSurface().getNative()).getFrame();
      return new PVector(f.getX(), f.getY());
    }

    throw new IllegalStateException("P2D,P3D,JAVA2D only");
  }
}

// リストボックスカスタムレンダラー
class Viewer8001ItemRenderer extends JPanel implements ListCellRenderer<Viewer8001Item> {
  private final JLabel icon = new JLabel();
  private final JLabel name = new JLabel();

  Viewer8001ItemRenderer() {
    super(new BorderLayout());
    setBorder(BorderFactory.createEmptyBorder(5, 10, 10, 10));

    name.setFont(new Font(Font.SANS_SERIF, Font.BOLD, 36));
    add(name, BorderLayout.NORTH);
    add(icon, BorderLayout.CENTER);
  }

  @Override
    public Component getListCellRendererComponent(JList<? extends Viewer8001Item> list, Viewer8001Item item, int index, boolean isSelected, boolean cellHasFocus) {
    icon.setIcon(item.imageIcon);
    name.setText(item.name);
    setBackground(isSelected ? list.getSelectionBackground() : list.getBackground());
    return this;
  }
}

// リストボックスアイテム
class Viewer8001Item {
  final Class clazz;
  final String name;
  final ImageIcon imageIcon;

  Viewer8001Item(Class clazz) {
    this.clazz = clazz;
    this.name = clazz.getSimpleName().replace("GameSceneCongratulations", "");

    var file = new File(sketchPath() + "\\screenshot", clazz.getSimpleName() + ".png");
    if (file.exists()) {
      imageIcon = new ImageIcon(new ImageIcon(file.getAbsolutePath())
        .getImage().getScaledInstance(150, 240, Image.SCALE_DEFAULT)); // 画像リサイズ（3/10）
    } else {
      imageIcon = null;
    }
  }
}

// 遷移しない＆スクショ撮るカスタムGameStack
class Viewer8001GameStack extends GameStack {
  final List<Class> classes; // 全コングラClass
  GameScene current = new GameSceneTitle(); // 選択（再生）中のコングラ

  Viewer8001GameStack(PApplet pa) {
    super(pa);
    mApplet.push();

    var list = new ArrayList<Class>();
    var pattern = Pattern.compile(".*?([0-9]+)$"); // 正規表現（最後が数字で終わるか）
    var allClasses = pa.getClass().getDeclaredClasses(); // PAppletのすべての内部クラス（＝ .pdeに書かれているすべてのclass）
    for (Class c : allClasses) {
      if (!GameSceneCongratulationsBase.class.isAssignableFrom(c)) continue; // BaseかBaseの派生クラスでなければ... continue
      if (!pattern.matcher(c.getSimpleName()).matches()) continue; // クラス名が数字で終わらなければ... continue

      list.add((Class) c); // コングラClassを追加
    }

    // 後ろの数字順にソート
    Comparator<Class> comparator = (e1, e2) -> {
      var i1 = Integer.valueOf(pattern.matcher(e1.getSimpleName()).replaceAll("$1"));
      var i2 = Integer.valueOf(pattern.matcher(e2.getSimpleName()).replaceAll("$1"));
      return i1.compareTo(i2);
    };
    classes = list.stream().sorted(comparator).collect(Collectors.toList());
    classes.forEach((x) -> System.out.println(x.getSimpleName()));

    // Viewer起動
    PApplet.runSketch(new String[]{"Viewer"}, new Viewer8001(pa, this));
  }

  void change(Class clazz) {
    mApplet.pop();
    mApplet.push();

    mCleanup = current;
    try {
      var ctor = clazz.getDeclaredConstructor(mApplet.getClass()); // Classからコンストラクタ取得
      current = (GameScene)ctor.newInstance(mApplet); // コングらインスタンス生成
    }
    catch (Exception e) {
      e.printStackTrace();
    }

    var number = clazz.getSimpleName().replaceAll("[^0-9]", "");
    mApplet.getSurface().setTitle(mainTitle + "[" + number + "]");
  }

  @Override GameScene peek() {
    return current;
  }

  // 遷移を止めるため無視
  @Override void change(GameScene gs) {
    // デモの遷移は絶対阻止！！
    gbAutoDemo = false;
  }

  @Override void push(GameScene gs) {
  }

  @Override void pop() {
  }
}
