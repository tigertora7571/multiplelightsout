class Board {
  // 3つのパネルを用意
  Panel panels[] = {
    new Panel(50, 50, 2),
    new Panel(550, 50, 5),
    new Panel(50, 550, 6)
  };
  boolean is_speedrun = true;
  Score score = new Score();
  // マウスがどのライトの上にあるかの座標 -1はライトの上にないとき
  int focus_x = -1, focus_y = -1;
  // 最短手数
  int moves_num = 8;
  // プレイヤーの手数
  int player_moves = 0;
  // ゲーム開始のmillis
  int start_play_time = 0;
  // 経過時間 millis差分
  int play_time = 0;
  // クリアフラグ
  boolean is_clear = false;
  boolean is_highscore = false;
  // 正解の場所
  ArrayList<Integer> arraylist_moves;
  // 右下メニューのボタン
  UIrect menu_button = new UIrect(new String[]{"RESTART", "EXIT"}, new float[]{750, 750}, new float[]{820, 900}, 300, 50, #444444, #111111, #333333, #000000, #aaaaaa, #ffffff);

  void isSpeedrun(boolean is_speedrun) {
    this.is_speedrun = is_speedrun;
  }

  // ライトの数に対応する初期化
  void game_start() {
    for (int i = 0; i < this.panels.length; ++i) {
      this.panels[i].game_start();
    }
    this.score.load();
  }

  // 初期化いろいろ、難易度によってmoves_numが異なる
  void init(int moves_num) {
    // 穴が開いている場所の合計リスト
    int exist_list[] = new int[int(pow(light_len, 2))];
    this.moves_num = moves_num;
    // 穴をランダムで開ける 全パネルで同じ位置に穴があることがないようにする
    for (int i = 0; i < this.panels.length; ++i) {
      exist_list = this.panels[i].init_exist(exist_list);
    }
    // 手数だけランダムに数字を取得(重複なし)
    this.arraylist_moves = random_int_combination(int(pow(light_len, 2)), this.moves_num);
    // ライトを初期化(反転する)
    this.init_light();
    this.is_clear = false;
    if (is_speedrun) this.is_highscore = false;
    this.player_moves = 0;
    // ゲーム開始時間代入
    this.start_play_time = millis();
    this.play_time = 0;
  }

  void init_light() {
    // それぞれのパネルでライト反転処理
    for (int i = 0; i < this.panels.length; ++i) {
      this.panels[i].init_light(this.arraylist_moves, this.moves_num);
    }
  }

  // ライト描画
  void draw() {
    stroke(0);
    // 中央に線
    line(width/2, 0, width/2, height);
    line(0, height/2, width, height/2);
    // パネルごとに描画処理
    for (int i = 0; i < this.panels.length; ++i) {
      this.panels[i].draw();
    }
  }

  // マウスがパネルのどこにあるか計算
  void mouse(int mouse_x, int mouse_y) {
    // 右下にある場合 -1
    if (!(mouse_x > 500 && mouse_y > 500)) {
      int mouse_x_500 = mouse_x % 500;
      int mouse_y_500 = mouse_y % 500;
      // ライトがある範囲にマウスがあるか判定
      if (mouse_x_500 >= 50 && mouse_x_500 <= 450 && mouse_y_500 >= 50 && mouse_y_500 <= 450) {
        float light_size = 400 / light_len;
        // x,yそれぞれ計算
        this.focus_x = int((mouse_x_500 - 50) / light_size);
        this.focus_y = int((mouse_y_500 - 50) / light_size);
        // 右端OR下端にある場合、NullPointerExceptionになってしまうため、-1する。
        if (this.focus_x >= light_len) this.focus_x--;
        if (this.focus_y >= light_len) this.focus_y--;
      } else {
        // 範囲以外なら -1
        this.focus_x = -1;
        this.focus_y = -1;
      }
    } else {
      this.focus_x = -1;
      this.focus_y = -1;
    }
  }

  // マウスがライトの上にあれば、そのライトと上下左右に枠を描画する
  void focus_draw() {
    if (this.focus_x != -1 && this.focus_y != -1) {
      // パネルごとに描画
      for (int i = 0; i < this.panels.length; ++i) {
        this.panels[i].focus_draw(this.focus_x, this.focus_y);
      }
    }
  }

  // マウスをライトの上で押したかどうか -> 押したら反転
  void mouse_press(boolean isPR) {
    // マウスが押されたか
    if (isPR) {
      if (this.focus_x != -1 && this.focus_y != -1) {
        // プレイヤーの手数を増やして
        this.player_moves++;
        // 各パネル反転処理
        for (int i = 0; i < this.panels.length; ++i) {
          this.panels[i].change_light(this.focus_y, this.focus_x);
        }
      }
    }
  }

  boolean status_draw(boolean isPR) {
    return this.status_draw(isPR, -1);
  }

  // 右下のStatusの描画 返り値true=タイトルに戻る
  boolean status_draw(boolean isPR, int remain_time) {
    int view_time;
    // 経過時間を更新
    if (this.is_speedrun) {
      if (!this.is_clear) {
        this.play_time = millis() - this.start_play_time;
      }
      view_time = this.play_time;
    } else {
      if (remain_time > 0) {
        view_time = remain_time;
      } else {
        view_time = 0;
      }
    }
    fill(0);
    textSize(40);
    // 右揃え
    textAlign(RIGHT, CENTER);
    text("TIME", 730, 600);
    text("MOVES", 730, 700);
    text("BEST", 730, 750);
    // 分表示 nf 0埋め
    text(nf(int(view_time/60000)%60, 2), 800, 600);
    // 左揃え
    textAlign(LEFT, CENTER);
    // 秒表示 nf 0埋め
    text(nf(int(view_time/1000)%60, 2), 820, 600);
    // 中央揃え
    textAlign(CENTER, CENTER);
    text(":", 810, 600);
    textAlign(CENTER, CENTER);
    text(this.player_moves, 810, 700);
    text(this.moves_num, 810, 750);
    if (!this.is_clear) {
      // クリアしていなかったら下のRESTARTとEXITのボタンを有効にする
      if (this.menu_button.draw(mouseX, mouseY, isPR)) {
        if (this.menu_button.setMovesNum(new int[]{0,1}) == 0) {
          // RESTART
          this.init_light();
          this.player_moves = 0;
        } else {
          // EXIT
          return true;
        }
      }
    } else {
      // クリアしていたら下のRESTARTとEXITを描画するだけ
      this.menu_button.draw2();
    }
    return false;
  }

  void isClearCheck() {
    this.isClearCheck(-1);
  }

  // クリア判定 スコアアタック用の引数
  void isClearCheck(int now_score) {
    // Panelごとにすべてオフか判定
    for (int i = 0; i < this.panels.length; ++i) {
      if (!this.panels[i].isClear()) return;
    }
    this.is_clear = true;
    // ハイスコアの場合セーブ
    if (is_speedrun) {
      if (this.score.saveSpeedRun((moves_num-6)/2, play_time)) this.is_highscore = true;
    } else {
      if (this.score.saveScoreAttack(now_score)) this.is_highscore = true;
    }
  }

  // クリアしたか返す
  boolean isClear() {
    return is_clear;
  }

  // HighScoreかどうか返す
  boolean isHighScore() {
    return is_highscore;
  }
}