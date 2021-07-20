// 難易度選択ボタン等のボタンをrectとtextでうまくやるUI
class UIrect {
  // txt, x, yの大きさは同じにする
  String txt[];
  float x[];
  float y[];
  float w, h;
  int fill_color, fill_hover_color, stroke_color, stroke_hover_color, text_color, text_hover_color; // カラーコード
  int focus = -1; // マウスがどこにあるかを代入する変数

  // 初期化
  UIrect (String[] txt, float[] x, float[] y, float w, float h, int fill_color, int fill_hover_color, int stroke_color, int stroke_hover_color, int text_color, int text_hover_color) {
    this.txt = txt;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.fill_color = fill_color;
    this.fill_hover_color = fill_hover_color;
    this.stroke_color = stroke_color;
    this.stroke_hover_color = stroke_hover_color;
    this.text_color = text_color;
    this.text_hover_color = text_hover_color;
  }

  // ボタン生成 返り値:ボタンを押したかどうか
  boolean draw(int mouse_x, int mouse_y, boolean isPR) {
    boolean return_boolean = false;
    // テキスト表示位置変更
    textAlign(CENTER, TOP);
    this.focus = -1; // 初期化
    // 描画 マウスが四角の中にあれば、色を変える
    for (int i = 0; i < this.txt.length; ++i) {
      boolean flag = mouse_x >= this.x[i]-this.w/2 && mouse_x <= this.x[i]+this.w/2 && mouse_y >= this.y[i] && mouse_y <= this.y[i]+this.h;
      // rectの枠と中の色変更
      if (flag) {
        fill(this.fill_hover_color);
        stroke(this.stroke_hover_color);
      } else {
        fill(this.fill_color);
        stroke(this.stroke_color);
      }
      // rectだから位置調整
      rect(this.x[i]-this.w/2, this.y[i], this.w, this.h);
      // textの色変更
      if (flag) {
        fill(this.text_hover_color);
      } else {
        fill(this.text_color);
      }
      text(this.txt[i], this.x[i], this.y[i]+6);
      // マウスがボタンの中にあり、かつマウスが押されたらtrueを返す, focusに押されたボタンの番号を代入
      if (flag && isPR) {
        this.focus = i;
        return_boolean = true;
      }
    }
    return return_boolean;
  }

  // クリア後のボタン生成
  void draw2() {
    textAlign(CENTER, TOP);
    for (int i = 0; i < this.txt.length; ++i) {
      fill(this.fill_color);
      stroke(this.stroke_color);
      rect(this.x[i]-this.w/2, this.y[i], this.w, this.h);
      fill(this.text_color);
      text(this.txt[i], this.x[i], this.y[i]+6);
    }
  }

  // 押されたものに対応する数字を返す
  int setMovesNum(int mn[]) {
    if (this.focus != -1) {
      return mn[this.focus];
    }
    return 0; // 0が返ることは無い
  }
}