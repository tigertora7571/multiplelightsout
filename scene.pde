// 画面遷移を管理するクラス
class Scene {
  int scene = 0;
  Mouse mouse = new Mouse(false, false); // Mouseが押したか押されたか保存するクラス
  Board board = new Board(); // Game画面全体を統括するクラス
  UIrect mode_button = new UIrect(new String[]{"EASY", "NORMAL", "HARD"}, new float[]{500, 500, 500, 500}, new float[]{490, 570, 650}, 350, 60, #464e20, #464e20, #333333, #000000, #999999, #ffffff); // 難易度選択ボタン
  UIrect game_mode_button = new UIrect(new String[]{"Game Rule", "Speedrun", "Score Attack", "Records"}, new float[]{500, 500, 500, 500}, new float[]{250, 380, 750, 850}, 600, 68, #464e20, #464e20, #333333, #000000, #999999, #ffffff); // 難易度選択ボタン
  UIrect records_return_button = new UIrect(new String[]{"BACK"}, new float[]{500}, new float[]{900}, 350, 60, #444444, #111111, #333333, #000000, #aaaaaa, #ffffff);
  int count = 0; // Animationのカウンター
  int score_attack_moves_num = 6; // Score Attackの最短手数
  int score_attack_time = 0; // Score Attackのmillis+制限時間
  int init_score_attack_time = 3*60*1000; // Score Attackのms
  protected int TITLE = 0, RULE = 1, SPEEDRUN = 2, SCOREATTACK = 3, RECORDS = 4; // わかりやすいように変数定義

  void draw() {
    // 画面分岐
    if (this.scene == TITLE) {
      this.title();
    } else if (this.scene == RULE) {
      this.rule();
    } else if (this.scene == SPEEDRUN) {
      this.speedRun();
    } else if (this.scene == SCOREATTACK) {
      this.scoreAttack();
    } else if (this.scene == RECORDS) {
      this.records();
    }
  }

  // Animationのカウントリセット
  void init_count() {
    this.count = 0;
  }

  // TITLE画面
  void title() {
    textAlign(CENTER, TOP);
    textSize(64);
    fill(0xff);
    text("MULTIPLE LIGHTS OUT", 500, 100);
    textSize(48);
    // 難易度選択ボタン表示 if文true=マウスがボタンの中にあるかつマウスを押した
    if (this.mode_button.draw(mouseX, mouseY, this.mouse.isPressedAndReleased(false))) {
      // Panelの数の初期化
      this.board.game_start();
      int moves_num = this.mode_button.setMovesNum(new int[]{6, 8, 10});
      if (moves_num > 0) {
        // ゲーム生成
        this.board.init(moves_num);
        // ゲーム画面に遷移
        this.scene = SPEEDRUN;
        this.board.isSpeedrun(true);
      }
      this.mouse.isPressedAndReleased(true);
      return;
    }
    textSize(56);
    if (this.game_mode_button.draw(mouseX, mouseY, this.mouse.isPressedAndReleased())) {
      int mode_num = this.game_mode_button.setMovesNum(new int[]{1, 0, 2, 3});
      if (mode_num == 1) {
        // 動画ループ再生
        ruleMovie.loop();
        this.scene = RULE;
      } else if (mode_num == 2) {
        // ゲーム生成
        this.board.game_start();
        this.board.init(this.score_attack_moves_num);
        // スピードランではない
        this.board.isSpeedrun(false);
        // 時間初期化
        this.score_attack_time = millis() + init_score_attack_time;
        // ゲーム画面に遷移
        this.scene = SCOREATTACK;
      } else if (mode_num == 3) {
        // High Scoreをロード
        this.board.score.load();
        this.scene = RECORDS;
      }
    }
  }

  // Game Ruleを再生
  void rule() {
    textAlign(CENTER, TOP);
    textSize(64);
    fill(0xff);
    text("GAME RULE", 500, 20);
    // 動画再生
    image(ruleMovie, 100, 100, 800, 800);
    textSize(48);
    text("Click to Return the Title", 500, 930);
    // クリックしたらタイトルに戻る
    if (this.mouse.isPressedAndReleased()) {
      ruleMovie.stop();
      this.scene = TITLE;
    }
  }

  void speedRun() {
    // ライトを描画
    this.board.draw();
    // 右下にStatusを描画 返り値true=ゲーム終了
    if (this.board.status_draw(this.mouse.isPressedAndReleased(false))) {
      this.mouse.reset();
      this.scene = TITLE;
      return;
    }
    // true=クリアしていないなら
    if (!this.board.isClear()) {
      // マウスがどのライトの上にあるか計算
      this.board.mouse(mouseX, mouseY);
      // ライトの上にある場合、枠が表示される
      this.board.focus_draw();
      // マウスがクリックされたら反転する処理
      this.board.mouse_press(this.mouse.isPressedAndReleased());
      this.board.isClearCheck();
    } else {
      // Animationのようにして暗くする
      fill(0, 0, 0, int(map(this.count, 0, 0xf, 0, 0xaa)));
      noStroke();
      rect(0, 0, width, height);
      textAlign(CENTER, CENTER);
      textSize(50);
      // 文字も同様
      fill(255, int(map(this.count, 0, 0xf, 0, 0xff)));
      text("CLEAR!", 500, 400);
      textSize(35);
      // High Scoreを更新したら表示する
      if (this.board.isHighScore()) text("NEW RECORD!!!", 500, 500);
      textSize(50);
      text(nf(int(this.board.play_time/60000)%60, 2)+":"+nf(int(this.board.play_time/1000)%60, 2), 500, 550);
      text("Click to Return the Title", 500, 800);
      // カウント
      if (this.count < 0xf) this.count++;
      // マウスが押されたらcount初期化かつタイトルに戻る
      if (this.mouse.isPressedAndReleased()) {
        this.init_count();
        this.scene = TITLE;
      }
    }
  }

  void scoreAttack() {
    // ライトを描画
    this.board.draw();
    // 右下にStatusを描画 返り値true=ゲーム終了
    if (this.board.status_draw(this.mouse.isPressedAndReleased(false), this.score_attack_time - millis())) {
      this.mouse.reset();
      this.score_attack_moves_num = 6;
      this.scene = TITLE;
      return;
    }
    // 制限時間をすぎたら
    if (this.score_attack_time - millis() <= 0) {
      // Animationのようにして暗くする
      fill(0, 0, 0, int(map(this.count, 0, 0xf, 0, 0xaa)));
      noStroke();
      rect(0, 0, width, height);
      textAlign(CENTER, CENTER);
      textSize(50);
      // 文字も同様
      fill(255, int(map(this.count, 0, 0xf, 0, 0xff)));
      text("TIME UP!", 500, 400);
      textSize(35);
      // High Scoreを更新したら表示する
      if (this.board.isHighScore()) text("NEW RECORD!!!", 500, 500);
      textSize(50);
      text(this.score_attack_moves_num-6, 500, 550);
      text("Press Space to Return the Title", 500, 800);
      // カウント
      if (this.count < 0xf) this.count++;
      this.mouse.reset();
      // スペースキーが押されたらcount初期化かつタイトルに戻る
      if (key == ' ' && keyPressed) {
        this.init_count();
        this.score_attack_moves_num = 6;
        this.scene = TITLE;
      }
      return;
    }
    // true=クリアしていないなら
    if (!this.board.isClear()) {
      // マウスがどのライトの上にあるか計算
      this.board.mouse(mouseX, mouseY);
      // ライトの上にある場合、枠が表示される
      this.board.focus_draw();
      // マウスがクリックされたら反転する処理
      this.board.mouse_press(this.mouse.isPressedAndReleased());
      this.board.isClearCheck(this.score_attack_moves_num-6+1);
      if (this.board.isClear()) this.score_attack_moves_num++;
    } else {
      this.mouse.reset();
      // Animationのようにして暗くする
      fill(0, 0, 0, int(map(this.count, 0, 60, 0, 0xaa)));
      noStroke();
      rect(0, 0, width, height);
      textAlign(CENTER, CENTER);
      textSize(50);
      // 文字も同様
      fill(255, int(map(this.count, 0, 60, 0, 0xff)));
      text("CLEAR!", 500, 500);
      // カウント
      if (this.count <= 60) {
        this.count++;
      } else {
        // カウントが60以上になったら新しいボード生成かつ制限時間を1秒だけ増やす
        this.score_attack_time += 1000;
        this.init_count();
        this.board.init(score_attack_moves_num);
        this.board.isSpeedrun(false);
      }
    }
  }

  // 記録表示
  void records() {
    // スピードランの記録読み込み
    int score_speedrun[] = this.board.score.loadScoresSpeedrun();
    String n[] = {"EASY", "NORMAL", "HARD"};
    // 文字表示ここから
    fill(0);
    // 中央揃え
    textAlign(CENTER, CENTER);
    textSize(64);
    text("Records", 500, 150);
    textSize(56);
    text("Speedrun", 500, 300);
    textSize(48);
    fill(0x22);
    for (int i = 0; i < score_speedrun.length; ++i) {
      // 右揃え
      textAlign(RIGHT, CENTER);
      text(n[i], 400, 400+i*90);
      // 分表示 nf 0埋め
      text(nf(int(score_speedrun[i]/60000)%60, 2), 650, 400+i*90);
      // 左揃え
      textAlign(LEFT, CENTER);
      // 秒表示 nf 0埋め
      text(nf(int(score_speedrun[i]/1000)%60, 2), 670, 400+i*90);
      // 中央揃え
      textAlign(CENTER, CENTER);
      text(":", 660, 400+i*90);
    }
    // 中央揃え
    textAlign(CENTER, CENTER);
    textSize(56);
    fill(0);
    text("Score Attack", 500, 700);
    textSize(48);
    fill(0x22);
    // スコアアタックのスコアをロードして表示
    text(this.board.score.loadScoreAttack(), 500, 780);
    // ボタンをクリックしたら戻る
    if (this.records_return_button.draw(mouseX, mouseY, this.mouse.isPressedAndReleased())) {
      this.scene = TITLE;
    }
  }
}