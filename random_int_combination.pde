// r回重複なしでランダムに 0 ~ high-1 の数字を選ぶ
ArrayList<Integer> random_int_combination(int high, int r) {
  ArrayList<Integer> arraylist = new ArrayList<Integer>();
  int random_num;
  // r回選ぶまで回す
  while (arraylist.size() < r) {
    // ランダムに選ぶ
    random_num = int(random(high));
    // 存在していなかったら追加
    if (arraylist.indexOf(random_num) == -1) {
      arraylist.add(random_num);
    }
  }
  // ArrayListで返す
  return arraylist;
}