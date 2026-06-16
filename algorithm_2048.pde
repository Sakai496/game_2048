int p;        //move(),sum(),keyPressed()で使用
int q;        //move(),sum(),keyPressed()で使用
int r;        //gameover(),writeMap()で使用
int score;    //スコアを記録する変数

int[][] mapList = new int[4][4];    //4*4のマップを生成(要素はすべて0)

//開始時のランダム生成とマップの表示
void setup() {
  PFont font = createFont("Meiryo", 50);
  textFont(font);
  score = 0;
  size(500, 300);
  for (int i = 0; i < 2; i++) {      //2つ生成
    add2();
  }
  gameover();
  writeMap();
}

void draw() {
}

//キー入力の処理
void keyPressed() {
  if (keyCode == UP) {
    p = 0;
  }
  if (keyCode == DOWN) {
    p = 1;
  }
  if (keyCode == LEFT) {
    p = 2;
  }
  if (keyCode == RIGHT) {
    p = 3;
  }
  q = 0;      //移動回数を初期化(今回の入力で1回でも動いたかを記録)
  for (int i = 0; i < 4; i++) {
    move(i);    //移動して
    sum(i);     //足して
    move(i);    //移動する
  }
  if (q > 0) {        //一回でも動いたなら
    add2();
  }
  gameover();
  writeMap();
}

//0以外の数字を手前(移動方向)に寄せる処理(足し算はしない)
void move(int i) {      //4回ループ
  int n = 0;            //ずらした回数を記録(3回まで)
  for (int j = 0; j < 3; j++) {          //3回ループ(1番手前以外を参照)
    int o = 0;          //j以降の数に0以外があるかを確認
    for (int k = 0; k < 4-j; k++) {      //奥から手前にjまで確認
      int[] listd = {3-k, k, i, i};      //x,y座標の指定
      if (mapList[listd[p]][listd[(p+2)%4]] != 0) {      //0以外があったら((p+2)%4で2つずれる)
        o = 1;
      }
    }
    int[] liste = {j, 3-j, i, i};      //縦軸と横軸の指定
    while (mapList[liste[p]][liste[(p+2)%4]] == 0 && n < 3 && o != 0) {      //現在地が0で、奥に0でない数があれば
      for (int k = 0; k < 3-j; k++) {          //現在地より奥にあるマスの数だけループ
        int[] listf = {k+j, 3-k-j, i, i};      //x,y座標の指定
        int[] listg = {1+k+j, 2-k-j, i, i};    //移動方向の指定(手前から奥)
        mapList[listf[p]][listf[(p+2)%4]] = mapList[listg[p]][listg[(p+2)%4]];      //一つ奥の値をコピー
      }
      int[] listh = {3, 0, i, i};              //1番奥の座標を指定
      mapList[listh[p]][listh[(p+2)%4]] = 0;
      n += 1;      //ずらした回数を記録
      q += 1;      //移動回数を増やす
    }
  }
}

//連続した同じ数を足す処理
void sum(int i) {      //4回ループ
  for (int j = 0; j < 3; j++) {        // 3回ループ
    int[] listi = {j, 3-j, i, i};      //x,y座標の指定
    int[] listj = {1+j, 2-j, i, i};    //移動方向の指定(手前から奥)
    if ((mapList[listi[p]][listi[(p+2)%4]] != 0)&&(mapList[listi[p]][listi[(p+2)%4]] == mapList[listj[p]][listj[(p+2)%4]])) {  //現在地が0でなく、次の数と値が等しいなら
      mapList[listi[p]][listi[(p+2)%4]] *= 2;      //現在地を2倍
      score += mapList[listi[p]][listi[(p+2)%4]];   //スコアに加算
      mapList[listj[p]][listj[(p+2)%4]] = 0;       //次の数を0にする
      q += 1;      //移動回数を増やす(keyPressed()で使用)
    }
  }
}

//ランダムに2を生成する処理
void add2() {
  int count = 0;      //2の生成回数(1回だけにする)
  int m = 0;          //シャッフル後リストの座標
  StringList orderedList = new StringList();      //空の文字列リスト
  for (int i = 0; i < 16; i++) {            //0から15まで追加
    orderedList.append(str(i));
  }
  orderedList.shuffle();      //シャッフルする
  int[] shuffledList = new int[16];          //0が16個入ったリスト
  for (int i = 0; i < 16; i++) {
    shuffledList[i] = Integer.parseInt(orderedList.get(i));      //シャッフル後の数列を取得
  }
  while (count < 1) {      //2が生成されるまでループ
    if (mapList[shuffledList[m]/4][shuffledList[m]%4] == 0) {      //現在地が0なら
      mapList[shuffledList[m]/4][shuffledList[m]%4] = 2;           //2を生成
      count++;      //生成回数を記録
    }
    if (count == 0) {      //生成できていないなら
      m++;                 //次の座標を指定
    }
  }
}

//動かせなくなったかの確認(0があれば動かせる、連続した同じ数があれば動かせる)
void gameover() {
  r = 0;
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (mapList[j][i] == 0) {
        r = 1;
      }
    }
    for (int j = 0; j < 3; j++) {
      if (mapList[j][i] == mapList[j+1][i]) {
        r = 1;
      }
      if (mapList[i][j] == mapList[i][j+1]) {
        r = 1;
      }
    }
  }
}

//マップの表示とゲームオーバーの表示
void writeMap() {
  background(255);
  textSize(50);
  text("スコア：" + score, 20, 250);    //スコアのテキスト
  if (r == 0) {                       //動かせなくなったら
    background(255, 80, 30);
    text("Game Over", 190, 250);      //テキスト表示
  }
  noStroke();
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      String s = str(mapList[j][i]);     //現在地の数を記録
      fill(250);                       //背景の色
      if (mapList[j][i] == 0) {          //現在地が0なら
        s = " ";                       //空白にして
        fill(247);                     //背景の色を変える
      }
      rect((i+1)*100, j*50+10, 98, 48);      //数ごとに背景を表示
      fill(0);                               //数の色
      text(s, (i+1)*100, (j+1)*50);          //数を表示
    }
  }
}
