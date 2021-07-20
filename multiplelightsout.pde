/*
Scene -> Board -> Panel -> Light
ProcessingのVideoライブラリはクラッシュが起きやすくエラーを吐くが正常に動く
*/
import processing.video.*;
Movie ruleMovie;
// 初期値5x5
int light_len = 5;
Scene scene = new Scene();
PFont font;

void setup() {
  size(1000, 1000, P2D);
  background(#576128);
  // 良さげなイタリックフォント
  font = loadFont("BonaNova-Italic-64.vlw");
  ruleMovie = new Movie(this, "rule.mov");
  ruleMovie.jump(0);
  textFont(font);
}

void draw() {
  background(#576128);
  scene.draw();
}

// mouseが押されたらMouseクラスのmouse.pressをtrueにする
void mousePressed() {
  scene.mouse.pressed();
}

// mouseが押されたらMouseクラスのmouse.releaseをtrueにする
void mouseReleased() {
  scene.mouse.released();
}

void movieEvent(Movie m) {
  m.read();
}