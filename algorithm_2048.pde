<<<<<<< HEAD
import java.util.Arrays;
int keyInput;        //move(),sum(),keyPressed()で使用
boolean isMoved;        //move(),sum(),keyPressed()で使用
boolean isGameover;        //checkGameover(),writeMap()で使用
boolean isStarted;        //setup(),mousePressed(),keyPressed()で使用
boolean isRetry;        //keyPressed(),mousePressed(),checkRetry()で使用
int score;    //sum(),writeMap()で使用
int recordScore;    //keyPressed()で使用
int tentativeScore;    //keyPressed()で使用
int[][] mapList;    //マップの状態を記録
int[][] recordList;    //keyPressed()で使用
int[][] tentativeList;    //keyPressed()で使用(仮のリスト)
String strMap;     //drawMap()で使用
String numImage = "A";    //数字の画像を変更するための変数
boolean colorChangeFunction = false;    //数字の画像を変更するための変数
=======
int p;        //move(),sum(),keyPressed()で使用
int q;        //move(),sum(),keyPressed()で使用
int r;        //gameover(),writeMap()で使用
>>>>>>> 6d1fe1721388fc13b1313550b195891ac9f83da8

int[][] mapList = new int[4][4];    //4*4のマップを生成(要素はすべて0)

<<<<<<< HEAD
int time = 0;    //タイマー用
int elapsed = 0;    //タイマー用
boolean isElapsed = false;    //タイマー開始の状態を記録
boolean keyCommand = true;    //キー入力を有効化するための変数
boolean k = false;    //リトライ確認の状態を記録するための変数

//開始時のランダム生成とマップの表示
void setup() {
  size(500, 400);
  PFont font = createFont("Meiryo", 50);
  textFont(font);
  background(255);
  fill(200, 200, 255);
  noStroke();
  rect(170, 210, 160, 80);//スタートボタン
  rect(30, 210, 90, 80);//文字画像変えるボタン
  textSize(80);
  fill(0);
  textAlign(CENTER);
  text("2048", width/2, 150);
  textSize(30);
  text("start", width/2, 260);
  textSize(20);
  text( "数字変更", 75, 260);
  textAlign(LEFT);
  isStarted = true;      //ゲーム開始前の状態を記録
=======
//開始時のランダム生成とマップの表示
void setup() {
  size(500, 300);
  for (int i = 0; i < 2; i++) {      //2つ生成
    add2();
  }
  gameover();
  writeMap();
>>>>>>> 6d1fe1721388fc13b1313550b195891ac9f83da8
}

void draw() {
  if (isGameover && isElapsed) {                  //動かせなくなったらタイマー開始
    keyCommand = false;                //キー入力を無効化
    elapsed = millis() - time;       //経過時間を計算
    println(elapsed);                //確認用
    println(keyCommand);                //確認用
    PImage img1;
    PImage img2;
    img1 = loadImage("img/gameOver_background_eating1.png");
    img2 = loadImage("img/gameOver_background_eating2.png");
   if (elapsed > 1000) {    //1秒経過したら
    image(img1, 180, 8, 150, 200);
    fill(245);
    rect(330, 8, 120, 200);
   }
   if (elapsed > 2000) {    //2秒経過したら
    tint(245);
    image(img2, 110, 8, 150, 200);
    fill(245);
    rect(230, 8, 200, 200);
   }
  
   if (elapsed > 3000) {    //3秒経過したら
    fill(245);
    rect(50, 8, 400, 200);
   }
   if (elapsed > 4000) {    //4秒経過したら
    fill(0);
    textSize(50);
    text("スコア：" + score, 110, 90);
    isElapsed = false;      //タイマー終了の状態を記録
    k = true;      //リトライ確認の状態を記録
    fill(0);
    rect(80, 120, 160, 60);
    rect(260, 120, 160, 60);
    fill(255);
    textSize(20);
    text("リトライ", 120, 160);
    textSize(17);
    text("スタート画面に戻る", 265, 160);
   }
 }
}

<<<<<<< HEAD
void mousePressed() {
  if (mouseButton == LEFT && isStarted) {      //ゲーム開始前の状態
    if (mouseX > 30 && mouseX < 120 && mouseY > 210 && mouseY < 290) {
      colorChangeFunction=true;
    }
    colorChange();
    if (mouseX > 170 && mouseX < 330 && mouseY > 210 && mouseY < 290) {
      isStarted = false;      //ゲーム開始後の状態を記録
      startGame();
    }
  } else {
    returnToStart();
  }
  if (mouseButton == LEFT && isRetry) {      //リトライ確認中の状態
    if (mouseX > 70 && mouseX < 230 && mouseY > 120 && mouseY < 190) {      //いいえを選択した場合
      isRetry = false;      //リトライ確認を終了
      writeMap();
    }
    if (mouseX > 270 && mouseX < 430 && mouseY > 120 && mouseY < 190) {      //はいを選択した場合
      isRetry = false;      //リトライ確認を終了
      startGame();
    }
  }

  if (k) {
    if (mouseX > 80 && mouseX < 240 && mouseY > 120 && mouseY < 180) {      //リトライを選択した場合
      k = false;      //リトライ確認を終了
      keyCommand = true;                //キー入力を有効化
      startGame();
    }
    if (mouseX > 260 && mouseX < 420 && mouseY > 120 && mouseY < 180) {      //スタート画面に戻るを選択した場合
      k = false;      //リトライ確認を終了
      keyCommand = true;                //キー入力を有効化
      setup();
    }
  }

}

//キー入力の処理
void keyPressed() {
  if (isStarted || isRetry) {      //ゲーム開始前、リトライ確認中
    return;     //キー入力を無視する
  }
  
  if (keyCommand) {
   if (key == 'a' || key == 'A') {
    isGameover = true;
    writeMap();
    return;


   }
   if (key == 'r' || key == 'R') {     //リトライが押された場合
    checkRetry();
    return;
   }
   if (key == 'z' || key == 'Z') {
    if (recordList != null) {
      loadMap(mapList, recordList);      //1つ前のマップを復元
      score = recordScore;      //1つ前のスコアを復元
      checkGameover();
      writeMap();
    }
    return;
   }
   if (keyCode == UP) {
    keyInput = 0;
   }
   if (keyCode == DOWN) {
    keyInput = 1;
   }
   if (keyCode == LEFT) {
    keyInput = 2;
   }
   if (keyCode == RIGHT) {
    keyInput = 3;
   }
  

   loadMap(tentativeList, mapList);    //移動前のマップを記録
   tentativeScore = score;    //移動前のスコアを記録

   isMoved = false;      //移動回数を初期化(今回の入力で1回でも動いたかを記録)
   for (int i = 0; i < 4; i++) {
    move(i);    //移動して
    sum(i);     //足して
    move(i);    //移動する
   }
   if (isMoved) {        //一回でも動いたなら
    add2();
    loadMap(recordList, tentativeList);    //1つ前のマップを更新
    recordScore =  tentativeScore;    //1つ前のスコアを更新
   }
   checkGameover();
   writeMap();
 }
}

//0以外の数字を手前(移動方向)に寄せる処理(足し算はしない)
void move(int i) {      //4回ループ
  for (int j = 0; j < 3; j++) {          //3回ループ(1番手前以外を参照)
    int hasValue = 0;          //j以降の数に0以外があるかを確認
    for (int k = 0; k < 4-j; k++) {      //奥から手前にjまで確認
      int[] frontList = {3-k, k, i, i};      //x,y座標の指定
      if (mapList[frontList[keyInput]][frontList[(keyInput+2)%4]] != 0) {      //0以外があったら((keyInput+2)%4で2つずれる)
        hasValue = 1;
      }
    }
    int[] zeroPointList = {j, 3-j, i, i};      //縦軸と横軸の指定
    while (mapList[zeroPointList[keyInput]][zeroPointList[(keyInput+2)%4]] == 0 && hasValue != 0) {      //現在地が0で、奥に0でない数があれば
      for (int k = 0; k < 3-j; k++) {          //現在地より奥にあるマスの数だけループ
        int[] targetList = {k+j, 3-k-j, i, i};      //x,y座標の指定(コピー先)
        int[] sourceList = {1+k+j, 2-k-j, i, i};    //移動方向の指定(手前から奥)(コピー元)
        mapList[targetList[keyInput]][targetList[(keyInput+2)%4]] = mapList[sourceList[keyInput]][sourceList[(keyInput+2)%4]];      //一つ奥の値をコピー
      }
      int[] lastPointList = {3, 0, i, i};              //1番奥の座標を指定
      mapList[lastPointList[keyInput]][lastPointList[(keyInput+2)%4]] = 0;
      isMoved = true;      //移動を記録(keyPressed()で使用)
    }
  }
}

//連続した同じ数を足す処理
void sum(int i) {      //4回ループ
  for (int j = 0; j < 3; j++) {        // 3回ループ
    int[] nowList = {j, 3-j, i, i};      //x,y座標の指定
    int[] nextList = {1+j, 2-j, i, i};    //移動方向の指定(手前から奥)
    if (mapList[nowList[keyInput]][nowList[(keyInput+2)%4]] != 0) {     //現在地が0でなく、
      if (mapList[nowList[keyInput]][nowList[(keyInput+2)%4]] == mapList[nextList[keyInput]][nextList[(keyInput+2)%4]]) {  //次の数と値が等しいなら
        mapList[nowList[keyInput]][nowList[(keyInput+2)%4]] *= 2;      //現在地を2倍
        score += mapList[nowList[keyInput]][nowList[(keyInput+2)%4]];   //スコアに加算
        mapList[nextList[keyInput]][nextList[(keyInput+2)%4]] = 0;       //次の数を0にする
        isMoved = true;      //移動を記録(keyPressed()で使用)
      }
    }
  }
}

//ランダムに2を生成する処理
void add2() {
  int add2Count = 0;      //2の生成回数(1回だけにする)
  int idx = 0;          //シャッフル後リストの座標
  StringList orderedList = new StringList();      //空の文字列リスト
  for (int i = 0; i < 16; i++) {            //0から15まで追加
    orderedList.append(str(i));
  }
  orderedList.shuffle();      //シャッフルする
  int[] shuffledList = new int[16];          //0が16個入ったリスト
  for (int i = 0; i < 16; i++) {
    shuffledList[i] = Integer.parseInt(orderedList.get(i));      //シャッフル後の数列を取得
  }
  while (add2Count < 1) {      //2が生成されるまでループ
    if (mapList[shuffledList[idx]/4][shuffledList[idx]%4] == 0) {      //現在地が0なら
      mapList[shuffledList[idx]/4][shuffledList[idx]%4] = 2;      //2を生成
      add2Count++;      //生成回数を記録
    }
    if (add2Count == 0) {      //生成できていないなら
      idx++;                 //次の座標を指定
    }
  }
}

//動かせなくなったかの確認(0があれば動かせる、連続した同じ数があれば動かせる)
void checkGameover() {
  isGameover = true;      //動かせない状態を記録
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (mapList[j][i] == 0) {
        isGameover = false;
      }
    }
    for (int j = 0; j < 3; j++) {
      if (mapList[j][i] == mapList[j+1][i]) {
        isGameover = false;
      }
      if (mapList[i][j] == mapList[i][j+1]) {
        isGameover = false;
      }
    }
  }  
}

//マップ、ゲームオーバー、スコアの表示
void writeMap() {
  background(255);
  textSize(50);

  if (isGameover) {                       //動かせなくなったら
    time = millis();        //タイマー用
    background(255, 80, 30);
    text("Game Over", 190, 350);      //テキスト表示
    isElapsed = true;      //タイマー開始の状態を記録
  }


  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      strMap = str(mapList[j][i]);     //現在地の数を記録
      fill(250);                         //背景の色
      if (mapList[j][i] == 0) {          //現在地が0なら
        strMap = " ";                         //空白にして
        fill(247);                       //背景の色を変える
      }
      rect(i*100+50, j*50+10, 98, 48);      //数ごとに背景を表示
      backgroundImage(j, i);                    //背景画像を表示
      numImage(j, i, strMap);                    //数を画像で表示
      fill(0);                               //数の色
      // text(strMap, i*100+50, (j+1)*50);          //数を表示
    }
  }
  textSize(20);
  textAlign(LEFT);
  text("スコア：" + score, 20, 250);    //スコアのテキスト
  text("リトライ：Rキー", 20, 280);    //リトライのテキスト
  text("一回戻す：Zキー", 20, 310);    //一回戻すのテキスト
  rect(10, 315, 200, 40);//スタート画面に戻るのボタン
  fill(255);//文字色を白に変更
  text("スタート画面に戻る", 20, 340);//スタート画面に戻るのテキスト
}

//ゲームの初期化
void startGame() {
  mapList = new int[4][4];    //4*4のマップを生成(要素はすべて0)
  recordList = new int[4][4]; //1つ前のマップを記録するリストを生成
  tentativeList = new int[4][4];  //recordListの仮のリストを生成
  score = 0;
  for (int i = 0; i < 2; i++) {      //2つ生成
    add2();
  }
  loadMap(recordList, mapList);    //開始前のマップを記録
  recordScore = score;    //開始前のスコアを記録
  checkGameover();
  writeMap();
}

//リトライを確認するテキスト
void checkRetry() {
  fill(235);
  rect(50, 50, 400, 150);
  fill(220);
  rect(70, 120, 160, 70);
  fill(200, 200, 255);
  rect(270, 120, 160, 70);
  fill(0);
  textSize(20);
  text("本当にリトライしますか？", 130, 100);
  text("いいえ", 120, 160);
  text("はい", 330, 160);
  isRetry = true;      //リトライ確認中の状態にする
}

//マップの状態をコピーする処理
void loadMap(int[][] in, int[][] out) {
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      in[j][i] = out[j][i];
=======
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
>>>>>>> 6d1fe1721388fc13b1313550b195891ac9f83da8
    }
  }
}

<<<<<<< HEAD



//数字を画像で表示
void numImage(int j, int i, String s) {
  if (mapList[j][i] != 0) {
    for (int k=0; k<s.length(); k++) {
      char numk=s.charAt(k);
      PImage NumberImage=loadImage("img/number_"+numk+"_"+numImage+".png");//数字の画像表示
      image(NumberImage, (i+1)*100-50+98/s.length()*k, j*50+10, 98/s.length(), 48);//サイズと位置
    }
  }
}
//背景を画像で表示
void backgroundImage(int j, int i) {
  if (mapList[j][i] != 0) {
    if (mapList[j][i] <= 10) {
      tint(#893333);//画像全体に色付け
    }else if (mapList[j][i] <= 100) {
      tint(#FFE4C4);//画像全体に色付け
    }else if (mapList[j][i] <= 1000) {
      tint(#FF9B9B);//画像全体に色付け
    }else if (mapList[j][i] <=10000) {
      tint(#44B22E);//画像全体に色付け
    }else if (mapList[j][i] >= 100000) {
      tint(#893333);//画像全体に色付け
    }
    
    PImage backImg=loadImage("img/background_1.png");
    image(backImg, i*100+50, j*50+8, 100, 50);//サイズと位置
    noTint();//色付け終了
  }
}

//rect(30, 210, 90, 80);//文字画像変えるボタンを押したときの処理
void colorChange() {
  if (colorChangeFunction) {
    //スタートボタンを設置
    background(255);
    fill(0);
    rect(170, 210, 160, 80);//スタートボタンの四角
    textSize(30);
    fill(255);
    textAlign(CENTER);
    text("start", width/2, 260);
    //数字の画像変更用のイメージを表示
    PImage numA=loadImage("img/number_0_A.png");//Aの数字の画像表示
    image(numA, 30, 100, 90, 80);
    PImage numB=loadImage("img/number_0_B.png");//Bの数字の画像表示
    image(numB, 150, 100, 90, 80);


 


    if (mousePressed) {
      if (mouseX > 30 && mouseX < 120 && mouseY > 100 && mouseY < 180) {
        numImage="A";//Aの数字の画像に変更
      }
      if (mouseX > 150 && mouseX < 240 && mouseY > 100 && mouseY < 180) {
        numImage="B";//Bの数字の画像に変更
      }
    }
    if (numImage == "A") {
      fill(255, 00, 0, 128);
      rect(30, 100, 90, 80);        //選択中の表示
      image(numA, 30, 100, 90, 80);
    }
    if (numImage == "B") {
      fill(255, 00, 0, 128);
      rect(150, 100, 90, 80);        //選択中の表示
      image(numB, 150, 100, 90, 80);
    }
  }
}

//rect(10, 315, 200, 40);//スタート画面に戻るのボタン
void returnToStart() {
  if (mouseX > 10 && mouseX < 210 && mouseY > 315 && mouseY < 355 && isStarted==false) {
    setup();
    isStarted = true;      //ゲーム開始前の状態を記録
    keyCommand = true;                //キー入力を有効化
  }
}
=======
//これは青木のやつです2
>>>>>>> 6d1fe1721388fc13b1313550b195891ac9f83da8
