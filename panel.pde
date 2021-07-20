class Panel {
  // 左上座標
  float x, y;
  // 穴あきの数
  int not_exist_num;
  // 各ライト
  Light lights[][];
  // 穴あきの座標(重複なし)
  ArrayList<Integer> arraylist_not_exist;

  // 初期化
  Panel (float x, float y, int not_exist_num) {
    this.x = x;
    this.y = y;
    this.not_exist_num = not_exist_num;
  }

  // ライトの数に対応する初期化
  void game_start() {
    this.lights = new Light[light_len][light_len];
    for (int i = 0; i < light_len; ++i) {
      for (int j = 0; j < light_len; ++j) {
        this.lights[i][j] = new Light(x + 400/light_len*j, y + 400/light_len*i, 400/light_len, false, true);
      }
    }
  }

  // 穴をランダムで開ける
  int[] init_exist(int[] exist_list) {
    // 穴をランダムで選ぶ
    this.arraylist_not_exist = random_int_combination(int(pow(light_len, 2)), this.not_exist_num);
    boolean exist;
    for (int i = 0; i < light_len; ++i) {
      for (int j = 0; j < light_len; ++j) {
        // ArrayListにあるか判定
        exist = this.arraylist_not_exist.indexOf(i * light_len + j) == -1;
        // ないならリストに追加
        if (!exist) exist_list[i*light_len+j]++;
        // 3つ目のパネル、他2枚も同じところが開いていたら開けない
        if (exist_list[i*light_len+j] == 3) exist = true;
        // 各ライトの穴あきの初期化
        this.lights[i][j].init_exist(exist);
      }
    }
    return exist_list;
  }

  // ライトの初期化 引数のArrayList=正解の座標リスト
  void init_light(ArrayList<Integer> arraylist_moves, int moves_num) {
    // 一旦すべてライトをオフにする
    for (int i = 0; i < light_len; ++i) {
      for (int j = 0; j < light_len; ++j) {
        this.lights[i][j].init_light();
      }
    }
    int moves_index, index1, index2;
    for (int i = 0; i < moves_num; ++i) {
      moves_index = arraylist_moves.get(i);
      // 中身は0 ~ light_len*light_len-1 であるから2重配列に対応した計算をする
      index1 = moves_index / light_len;
      index2 = moves_index % light_len;
      // ライトを反転する
      this.change_light(index1, index2);
    }
  }

  // 各ライトの描画
  void draw() {
    fill(#464e20);
    noStroke();
    // 背景描画
    rect(this.x-1, this.y-1, 402, 402);
    // ライト描画
    for (int i = 0; i < light_len; ++i) {
      for (int j = 0; j < light_len; ++j) {
        this.lights[i][j].draw();
      }
    }
  }

  // ライトの反転処理
  void change_light(int index1, int index2) {
    // ライトが存在しているときだけ反転する
    if (this.lights[index1][index2].exist) {
      this.lights[index1][index2].change();
      // 上下左右 ライトがあるかそれぞれ判定し、反転する
      if (index1 > 0) this.lights[index1-1][index2].change();
      if (index1 < light_len-1) this.lights[index1+1][index2].change();
      if (index2 > 0) this.lights[index1][index2-1].change();
      if (index2 < light_len-1) this.lights[index1][index2+1].change();
    }
  }

  // マウス位置によってrectを描画 change_lightと似たような処理
  void focus_draw(int focus_x, int focus_y) {
    // ライトが存在しているときだけ描画する
    if (this.lights[focus_y][focus_x].exist) {
      // 上下左右 ライトがあるかそれぞれ判定し、rect描画
      if (focus_y > 0) this.lights[focus_y-1][focus_x].mouse_draw2();
      if (focus_y < light_len-1) this.lights[focus_y+1][focus_x].mouse_draw2();
      if (focus_x > 0) this.lights[focus_y][focus_x-1].mouse_draw2();
      if (focus_x < light_len-1) this.lights[focus_y][focus_x+1].mouse_draw2();
    }
    // ライトが存在しているときだけ反転する
    this.lights[focus_y][focus_x].mouse_draw();
  }

  // 全ライトがオフかどうか判定
  boolean isClear() {
    for (int i = 0; i < light_len; ++i) {
      for (int j = 0; j < light_len; ++j) {
        if (this.lights[i][j].isOn()) return false;
      }
    }
    return true;
  }
}