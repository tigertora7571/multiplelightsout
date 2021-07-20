class Mouse {
  // マウスを押したか、離したか
  boolean press, release;

  // 初期化
  Mouse (boolean press, boolean release) {
    this.press = press;
    this.release = release;
  }

  // 押された
  void pressed() {
    this.press = true;
  }

  // 離した
  void released() {
    this.release = true;
  }

  // リセット
  void reset() {
    this.press = false;
    this.release = false;
  }

  // 簡単に書きたいから
  boolean isPressedAndReleased() {
    return isPressedAndReleased(true);
  }

  // 押して離したか
  boolean isPressedAndReleased(boolean is_reset) {
    if (this.press && this.release) {
      // リセットするかどうか もう一度使いたい時などに
      if (is_reset) this.reset();
      return true;
    }
    return false;
  }
}