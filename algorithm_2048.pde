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
// String strMap;     //drawMap()で使用
String numImage = "A";    //数字の画像を変更するための変数
boolean colorChangeFunction = false;    //数字の画像を変更するための変数
boolean gameOvermode= false;//簡単にゲームオーバー画面を表示するため
int mode=0;//画面を管理するための変数(0:スタート画面、1:ゲーム画面、2:ゲームオーバー画面、3:数字変更画面,4:チュートリアル画面)
int lectureNumX=250;//チュートリアル画面の数字の位置を管理するための変数

//開始時のランダム生成とマップの表示
void setup() {
  size(500, 400);
  PFont font = createFont("Meiryo", 50);
  textFont(font);
  background(255);
  fill(200, 200, 255);
  noStroke();
  PImage gameStart =loadImage("img/gameStart_button.png");
  image(gameStart, 170, 210, 160, 80);//スタートボタン
  PImage letterChange=loadImage("img/letterChange_button.png");//文字の背景
  image(letterChange, 30, 210, 100, 80);
  PImage tutorial =loadImage("img/tutorial_button.png");
  image(tutorial, 380, 210, 100, 80);//チュートリアルのボタン
  textSize(80);
  fill(0);
  textAlign(CENTER);
  text("2048", width/2, 150);
  textSize(30);
  textSize(20);
  textAlign(LEFT);
  mode=0;//スタート画面
  isStarted = true;      //ゲーム開始前の状態を記録
}
void draw() {
  lecture();
}

void mousePressed() {
  if (mouseButton == LEFT && isStarted) {      //ゲーム開始前の状態
    if (mode==0 && mouseX > 380 && mouseX < 480 && mouseY > 210 && mouseY < 290) {
      mode=4;//チュートリアルの画面に移動
    }
    if (mode==0 && mouseX > 30 && mouseX < 130 && mouseY > 210 && mouseY < 290) {
      mode=3;//数字の画像を変更する画面に移動
    }
    lecture();
    colorChange();
    if ( mouseX > 170 && mouseX < 330 && mouseY > 210 && mouseY < 290) {
      isStarted = false;      //ゲーム開始後の状態を記録
      mode=1;
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
}

//キー入力の処理
void keyPressed() {
  if (isStarted || isRetry) {      //ゲーム開始前、リトライ確認中
    return;     //キー入力を無視する
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
  isGameover = true;
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

//ゲーム画面の表示設定（マップ、ゲームオーバー、スコアの表示）
void writeMap() {
  background(255);
  textSize(50);
  if (isGameover||gameOvermode) {                       //動かせなくなったら
    background(255, 80, 30);
    text("Game Over", 190, 350);      //テキスト表示
  }
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      String strMap = str(mapList[j][i]);     //現在地の数を記録
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
  PFont scoreFont = createFont("HGSoeiKakupoptai", 20);
  textFont(scoreFont);
  fill(212, 175, 55);
  text("スコア：" + score, 20, 250);    //スコアのテキスト
  text("リトライ：Rキー", 20, 280);    //リトライのテキスト
  text("一回戻す：Zキー", 20, 310);    //一回戻すのテキスト
  PImage back =loadImage("img/backToStart_button.png");
  image(back, 10, 315, 200, 43);//スタート画面に戻る
  PImage gameOver =loadImage("img/gameOver_button.png");
  image(gameOver, 10, 360, 200, 38);//ゲームオーバー
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
    }
  }
}

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
    tint(#823809);//画像全体に色付け
    PImage backImg=loadImage("img/background_1.png");
    image(backImg, i*100+50, j*50+8, 100, 50);//サイズと位置
    noTint();//色付け終了
  }
}

//rect(30, 210, 90, 80);//文字画像変えるボタンを押したときの処理
void colorChange() {
  if (mode==3) {
    //スタートボタンを設置
    background(255);
    fill(0);
    PImage gameStart =loadImage("img/gameStart_button.png");
    image(gameStart, 170, 210, 160, 80);//スタートボタンの四角
    PImage back =loadImage("img/back_button.png");
    image(back, 30, 300, 90, 60);//戻るボタンの四角
    textSize(30);
    fill(255);
    textAlign(CENTER);
    //数字の画像変更用のイメージを表示
    PImage numA=loadImage("img/number_0_A.png");//Aの数字の画像表示
    image(numA, 30, 100, 90, 80);
    PImage numB=loadImage("img/number_0_B.png");//Bの数字の画像表示
    image(numB, 150, 100, 90, 80);
    if (mousePressed) {
      if (mouseX > 30&&mouseX < 140 && mouseY > 300&&mouseY < 380) {//戻るボタンを押したときの処理
        setup();
        mode=0;//スタート画面に戻る
      }
      if (mouseX > 30 && mouseX < 120 && mouseY > 100 && mouseY < 180) {
        numImage="A";//Aの数字の画像に変更
      }
      if (mouseX > 150 && mouseX < 240 && mouseY > 100 && mouseY < 180) {
        numImage="B";//Bの数字の画像に変更
      }
    }
  }
}

//rect(10, 315, 200, 43);//スタート画面に戻るのボタン
//rect(10, 360, 200, 38);//ゲームオーバーの四角
void returnToStart() {
  if (mouseX > 10 && mouseX < 210 && mouseY > 315 && mouseY < 358 && isStarted==false) {
    setup();
    isStarted = true;      //ゲーム開始前の状態を記録
    gameOvermode=false;
  }
  if (mouseX > 10 && mouseX < 210 && mouseY > 360 && mouseY < 398 && isStarted==false) {
    gameOvermode=true;
    writeMap();
  }
}
//lectureNumX=250;
void lecture() {
  if (mode==4) {
    if (lectureNumX == 100) {
      lectureletter();
      PImage numA=loadImage("img/number_4_"+numImage+".png");//Aの数字の画像表示
      image(numA, 100, 10, 70, 60);
      lectureNumX=lectureNumX-1;
    }else if(lectureNumX == 99){
      delay(1000);
      lectureNumX=250;
    }else{
      lectureletter();
      PImage numA=loadImage("img/number_2_"+numImage+".png");//Aの数字の画像表示
      image(numA, 100, 10, 70, 60);
      image(numA, lectureNumX, 10, 70, 60);
      lectureNumX=lectureNumX-2;
    } 
    if (mousePressed) {
      if (mouseX > 30 &&mouseX < 140 && mouseY > 300 && mouseY < 380) {
        setup();
        mode=0;
      }
    }
  }
}

void lectureletter(){
  background(255);
  textAlign(LEFT);
  fill(0);
  textSize(18);
  text("このゲームは、2048を作るゲームです。", 20, 100);
  text("矢印キーで数字を動かし、同じ数字が重なると足されます。", 20, 120);
  text("2がランダムマップ上に生成されます。", 20, 140);
  text("2048を作るとクリアです。", 20, 160);
  text("動かせなくなるとゲームオーバーです。", 20, 180);
  text("リトライはRキー、一回戻すのはZキーです。", 20, 200);
  //スタートボタンと戻るボタンの四角を設置
  PImage back =loadImage("img/back_button.png");
  image(back, 30, 300, 110, 80);//戻るボタンの四角
  PImage gameStart =loadImage("img/gameStart_button.png");
  image(gameStart, 170, 210, 160, 80);//スタートボタンの四角
}