// High Scoreを保存するクラス
class Score {
  String score_speedrun[];
  String score_scoreattack[];

  // ロード
  void load() {
    this.score_speedrun = loadStrings("highscore_speedrun.txt");
    this.score_scoreattack = loadStrings("highscore_scoreattack.txt");
  }

  // Speedrunのハイスコア保存 ハイスコアならtrueを返す
  boolean saveSpeedRun(int mode, int ms) {
    // ハイスコア？
    if (int(this.score_speedrun[mode]) > ms) {
      // String型に変換して保存
      this.score_speedrun[mode] = str(ms);
      saveStrings("data/highscore_speedrun.txt", this.score_speedrun);
      return true;
    }
    return false;
  }

  // Score Attackのハイスコア保存 ハイスコアならtrueを返す
  boolean saveScoreAttack(int now_score) {
    // ハイスコア？
    if (now_score > int(this.score_scoreattack[0])) {
      // String型に変換して保存
      this.score_scoreattack[0] = str(now_score);
      saveStrings("data/highscore_scoreattack.txt", this.score_scoreattack);
      return true;
    }
    return false;
  }

  // intに変換して返す
  int[] loadScoresSpeedrun() {
    return int(this.score_speedrun);
  }

  // intに変換して返す
  int loadScoreAttack() {
    return int(this.score_scoreattack[0]);
  }
}