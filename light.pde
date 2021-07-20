class Light {
  // オンとオフの時の画像を用意
  PImage light_on_image = loadImage("lighton.png");
  PImage light_off_image = loadImage("lightoff.png");
  float x, y, size;
  // ライトのオンオフ、存在しているか
  boolean on, exist;

  // 初期化
  Light (float x, float y, float size, boolean on, boolean exist) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.on = on;
    this.exist = exist;
  }

  // ライトの描画、オンオフによって表示する画像を変える
  void draw() {
    if (exist) {
      if (on) {
        image(this.light_on_image, this.x, this.y, this.size, this.size);
      } else {
        image(this.light_off_image, this.x, this.y, this.size, this.size);
      }
    }
  }

  // init x,y,sizeが必要

  // 存在しているかの初期化
  void init_exist(boolean exist) {
    this.exist = exist;
  }

  // ゲームを作成する前の初期化 オフにする
  void init_light() {
    this.on = false;
  }

  // ライトのオンオフを反転する
  void change() {
    if (this.exist) this.on = !this.on;
  }

  // マウス位置によって描画する枠
  void mouse_draw() {
    // 存在していたらnoFillで枠を描画する
    if (this.exist) {
      fill(#45b0e6, 0x44);
      stroke(#45b0e6);
      rect(x, y, this.size, this.size);
    }
  }

  // マウス位置の上下左右の枠の描画 色が薄い
  void mouse_draw2() {
    // 存在していたらnoFillで枠を描画する
    if (this.exist) {
      fill(#1678a9, 0x44);
      stroke(#1678a9);
      rect(x, y, this.size, this.size);
    }
  }

  // Onかどうか
  boolean isOn() {
    return on;
  }
}