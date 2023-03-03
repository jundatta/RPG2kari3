package processing.app.ui;

import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseWheelEvent;
import java.util.ArrayList;
import java.util.Collection;
import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.JPopupMenu;
import javax.swing.Timer;
import javax.swing.event.MenuEvent;
import javax.swing.event.MenuListener;

/**
 * スクロール可能メニュー.
 * メニュー項目を設定したあと、{@link #initScroller() }でスクローラーを初期化します.
 * つぎに、{@link #setScrollableItems(java.util.Collection) }で、スクロールさせる
 * メニュー項目を設定します。
 * 表示可能なアイテム数を調整するために、このメニューオブジェクトのselectedイベントの
 * タイミングで、{@link #adjustMaxVisible(int) }を呼び出して表示項目数を調整します。
 *
 * @author seraphy
 */
public class JScrollableMenu extends JMenu {

    /**
     * 自動スクロールの既定の間隔(mSec).
     */
    public static final int DEFAULT_REPEAT_DELAY = 200;

    /**
     * 高速自動スクロールの既定の間隔(mSec).
     */
    public static final int DEFAULT_FAST_REPEAT_DELAY = 80;

    /**
     * 既定の最大表示アイテム数.
     */
    public static final int DEFAULT_MAX_VISIBLE = 10;

    /**
     * リピートの閾値.
     * スクロール数が、この数値を超えた場合に高速スクロール化する.
     */
    public static final int DEFAULT_REPEAT_THRESHOLD = 3;


    /**
     * スクロールするアイテムのメニューの開始位置.
     */
    private int _startPos;

    /**
     * 現在表示されている最初のアイテムのオフセット.
     */
    private int _offset;

    /**
     * スクロールするメニュー項目のリスト.
     */
    private ArrayList<JMenuItem> _menus = new ArrayList<>();


    /**
     * 自動スクロールのためのタイマー.
     */
    private Timer _timer;

    /**
     * 自動スクロールしたカウント.
     */
    private int _scrollCount;


    /**
     * スクローラー(上).
     */
    private JScrollerMenuItem _upButton;

    /**
     * スクローラー(下).
     */
    private JScrollerMenuItem _downButton;


    /**
     * 通常スクロール時の自動スクロールの間隔.
     */
    private int _delay = DEFAULT_REPEAT_DELAY;

    /**
     * 高速スクロール時の自動スクロールの間隔.
     */
    private int _delayFast = DEFAULT_FAST_REPEAT_DELAY;

    /**
     * リピートの閾値.
     * スクロール数が、この数値を超えた場合に高速スクロール化する.
     */
    private int _repeat_threshold = DEFAULT_REPEAT_THRESHOLD;


    /**
     * 現在のスクロール方向を示すフラグ.
     * タイマーハンドラの中で判定するため.
     * nullの場合はスクロールしていないを示す.
     */
    private Boolean _directionUp;


    /**
     * 最大表示アイテム数.
     */
    private int maxVisible = DEFAULT_MAX_VISIBLE;


    /**
     * 表示名を指定してメニューを構築する.
     *
     * @param name 表示名
     */
    public JScrollableMenu(String name) {
        super(name);
        initScrollableMenu();
    }

    /**
     * スクロール可能メニューの基本状態を設定する.
     */
    private void initScrollableMenu() {
        // 自動スクロールのためのタイマ
        this._timer = new Timer(_delay, e -> {
            // スクロール
            doScroll();

            // スクロール数をカウントアップ
            _scrollCount++;

            // スクロール数が閾値を超えたら高速化
            if (_scrollCount >= _repeat_threshold) {
                ((Timer) e.getSource()).setDelay(_delayFast);
            }
        });
        addMenuListener(new MenuListener() {
            @Override public void menuCanceled(MenuEvent e) {
                // このメニューがキャンセルされたときにスクロールを停止する
                JScrollableMenu.this._timer.stop();
                _directionUp = null;
            }

            @Override public void menuDeselected(MenuEvent e) {
                // このメニューが非選択状態になったときスクロールを停止する
                JScrollableMenu.this._timer.stop();
                _directionUp = null;
            }

            @Override public void menuSelected(MenuEvent e) {
                // 何もしない
            }
        });

        JPopupMenu popup = getPopupMenu();
        popup.addMouseWheelListener(new MouseAdapter() {
            @Override public void mouseWheelMoved(MouseWheelEvent e) {
                if (e.getWheelRotation() < 0) {
                    scrollDown();
                } else {
                    scrollUp();
                }
            }
        });
    }

    /**
     * スクローラーを初期化します.
     * スクロールしない固定のメニュー項目などを設定したあとで、このメソッドを呼び出します.
     * すでに初期化されている場合は何もしません.
     */
    public void initScroller() {
        if (_upButton != null || _downButton != null) {
            // すでに初期化済み
            removeAllScrollableItems();
            return;
        }

        // スクローラー用ボタンアイコン
//        ImageIcon iconDown = new ImageIcon(getClass().getResource("arrow-down.png"));
//        ImageIcon iconUp = new ImageIcon(getClass().getResource("arrow-up.png"));

        // スクローラー用メニュー項目
        _upButton = new JScrollerMenuItem("▲");
        _downButton = new JScrollerMenuItem("▼");

        // スクローラー用メニュー(最上)
        JMenuItem firstButton = new JMenuItem("△") {
            @Override protected void processMouseEvent(MouseEvent e) {
                if (e.getID() == MouseEvent.MOUSE_CLICKED) {
                    _offset = 0;
                    updateScrollableMenus();
                }
            }
        };
        // スクローラー用メニュー(最下)
        JMenuItem endButton = new JMenuItem("▽") {
            @Override protected void processMouseEvent(MouseEvent e) {
                if (e.getID() == MouseEvent.MOUSE_CLICKED) {
                    int limit = _menus.size() - maxVisible;
                    if (limit < 0) {
                        limit = 0;
                    }
                    _offset = limit;
                    updateScrollableMenus();
                }
            }
        };

        // スクローラーのマウスイベントを受け取る
        final ScrollableMenuEventListener sc = new ScrollableMenuEventListener() {
            @Override public void start(ScrollableMenuEvent e) {
                if (e.getSource().equals(_upButton)) {
                    // 上スクロール
                    _directionUp = Boolean.TRUE;
                } else {
                    // 下スクロール
                    _directionUp = Boolean.FALSE;
                }

                // マウスクリックに対するスクロール
                doScroll();

                // 自動スクロール開始
                _scrollCount = 0;
                _timer.setDelay(_delay);
                _timer.start();
            }

            @Override public void end(ScrollableMenuEvent e) {
                // 自動スクロール停止
                _timer.stop();
                _directionUp = null;
            }
        };

        _upButton.addScrollableMenuEventListener(sc);
        _downButton.addScrollableMenuEventListener(sc);

        add(firstButton);
        add(_upButton);
        _startPos = getItemCount(); // upButtonの次のインデックス
        add(_downButton);
        add(endButton);


        // Mac OS Xのスクリーンメニューはスクロール可能なので、
        // スクローラー用アイテムは非表示にして、デフォルトの機能に任せる。
        // (逆に、スクリーンメニューではカスタムメニューは、うまく機能しない。)
        if (isScreenMenu()) {
            _upButton.setVisible(false);
            _downButton.setVisible(false);
        }
    }

    /**
     * スクロールする.
     */
    protected void doScroll() {
        // 現在の方向に応じて処理内容を分岐する.
        if (_directionUp != null) {
            if (_directionUp) {
                scrollDown();
            } else {
                scrollUp();
            }
        }
    }

    /**
     * Mac OS Xのスクリーンメニューを使用しているか?
     *
     * @return 使用している場合はtrue
     */
    protected static boolean isScreenMenu() {
        String macScreenMenu = System.getProperty("apple.laf.useScreenMenuBar");
        return macScreenMenu != null && macScreenMenu.toLowerCase().equals("true");
    }

    /**
     * 表示可能な最大行数を設定する.
     *
     * @param maxVisible 最大行数
     */
    public void setMaxVisible(int maxVisible) {
        this.maxVisible = maxVisible;
    }

    /**
     * 表示可能な最大行数を取得する.
     *
     * @return 表示可能な最大行数
     */
    public int getMaxVisible() {
        return this.maxVisible;
    }

    /**
     * 画面の高さを指定して、表示可能なスクロールのアイテム数を算定し、
     * スクロールを表示し直す.
     *
     * @param height 画面の高さを示す(px)
     */
    public void adjustMaxVisible(int height) {
        int numOfItems = 0;
        if (_menus.size() > 0) {
            int heightPerItem = _menus.get(0).getPreferredSize().height;
            if (heightPerItem <= 0) {
                // 調整できないので何もしない.
                return;
            }
            numOfItems = height / heightPerItem;
        }
        numOfItems = numOfItems - (_startPos + 1 + 2 + 2); // 既存 + up/downボタン分 + 上下余白を差し引く
        if (numOfItems < 0) {
            numOfItems = 1;
        }
        this.maxVisible = numOfItems;
        updateScrollableMenus();
    }

    /**
     * 通常スクロールの間隔を取得する.
     *
     * @return 通常スクロールの間隔(mSec)
     */
    public int getRepeatDelay() {
        return this._delay;
    }

    /**
     * 高速スクロールの間隔を取得する.
     *
     * @return 高速スクロールの間隔(mSec)
     */
    public int getRepeatDelayFast() {
        return this._delayFast;
    }

    /**
     * 通常スクロールの間隔を設定する.
     *
     * @param delay 通常スクロールの間隔(mSec)
     */
    public void setRepeatDelay(int delay) {
        this._delay = delay;
    }

    /**
     * 高速スクロールの間隔を設定する.
     *
     * @param delayFast 高速スクロールの間隔(mSec)
     */
    public void setRepeatDelayFast(int delayFast) {
        this._delayFast = delayFast;
    }

    /**
     * スクロール可能アイテムを設定します.
     * 既存のアイテムがある場合は、すべて登録解除されます.
     * 事前にスクローラーは初期化済みでなければなりません.
     *
     * @param menus メニューリスト
     */
    public void setScrollableItems(Collection<? extends JMenuItem> menus) {
        if (_upButton == null || _downButton == null) {
            throw new IllegalStateException("initScrollerを先に呼び出してください");
        }
        removeAllScrollableItems();

        if (menus != null) {
            for (JMenuItem item : menus) {
                int idx = _startPos + _menus.size();
                this.add(item, idx);
                _menus.add(item);
            }
        }

        updateScrollableMenus();
    }

    /**
     * 現在のスクロール可能アイテムをすべて除去します.
     */
    public void removeAllScrollableItems() {
        for (JMenuItem item : _menus) {
            this.remove(item);
        }
        _menus.clear();
        _offset = 0;
    }

    /**
     * 現在のスクロール範囲でスクロール可能項目を表示します.
     */
    public void updateScrollableMenus() {
        boolean screenMenu = isScreenMenu();
        int numOfItems = _menus.size();
        for (int idx = 0; idx < numOfItems; idx++) {
            boolean visible = false;
            if (idx >= _offset && idx < (_offset + maxVisible) || screenMenu) {
                // メニュー項目が表示範囲内であれば表示、範囲外であれび非表示とする。
                // ただし、Mac OS Xのスクリーンメニューであれば無条件にすべて表示。
                visible = true;
            }
            _menus.get(idx).setVisible(visible);
        }
    }

    /**
     * 現在表示されているスクロール項目のオフセットを取得する.
     *
     * @return 現在のオフセット
     */
    public int getOffset() {
        return _offset;
    }

    /**
     * 上方向にスクロールします.
     * これ以上スクロールできない場合は何もしません.
     * その場合、自動スクロール中であればスクロールは停止します.
     */
    public void scrollUp() {
        int numOfItems = _menus.size();
        int limit = numOfItems - maxVisible;
        if (limit < 0) {
            limit = 0;
        }

        _offset++;

        if (_offset >= limit) {
            _offset = limit;
            _timer.stop();
            _directionUp = null;
        }

        updateScrollableMenus();
    }

    /**
     * 下方向にスクロールします.
     * これ以上スクロールできない場合は何もしません。
     * その場合、自動スクロール中であればスクロールは停止します。
     */
    public void scrollDown() {
        _offset--;
        if (_offset < 0) {
            _offset = 0;
            _timer.stop();
            _directionUp = null;
        }
        updateScrollableMenus();
    }
}
