import java.util.Arrays;
int moveCount = 0;    //draw()で使用
int cellQty = 4;    //マスの数
int fps = 20;     //draw()で使用,アニメーションのコマ数
int keyInput;        //move(),sum(),keyPressed()で使用
boolean isMoved;        //move(),sum(),keyPressed()で使用
boolean isGameover;        //checkGameover(),writeMap()で使用
boolean isStarted;        //setup(),mousePressed(),keyPressed()で使用
boolean isRetry;        //keyPressed(),mousePressed(),checkRetry()で使用
boolean isMoving = false;
int score;    //sum(),writeMap()で使用
int recordScore;    //keyPressed()で使用
int tentativeScore;    //keyPressed()で使用
int[][] mapList;    //マップの状態を記録
int[][] recordList;    //keyPressed()で使用
int[][] tentativeList;    //keyPressed()で使用(仮のリスト)
FloatList moveCellList = new FloatList();    //keyPressed()で使用
String numImage = "A";    //数字の画像を変更するための変数
boolean colorChangeFunction = false;    //数字の画像を変更するための変数
boolean gameOvermode= false;//簡単にゲームオーバー画面を表示するため
int mode=0;//画面を管理するための変数(0:スタート画面、1:ゲーム画面、2:ゲームオーバー画面、3:数字変更画面,4:チュートリアル画面)
int lectureNumX=250;//チュートリアル画面の数字の位置を管理するための変数
int Y2=-40;//2048の2の位置を管理するための変数
PImage[] NumberImageList=new PImage[10];//数字の画像表示
PImage backImg;


int p;        //move(),sum(),keyPressed()で使用
int q;        //move(),sum(),keyPressed()で使用
int r;        //gameover(),writeMap()で使用



int time = 0;    //タイマー用
int elapsed = 0;    //タイマー用
boolean isElapsed = false;    //タイマー開始の状態を記録
boolean keyCommand = true;    //キー入力を有効化するための変数
boolean k = false;    //リトライ確認の状態を記録するための変数

//開始時のランダム生成とマップの表示
void setup() {
  frameRate(60);
  size(500, 400);
  PFont font = createFont("Meiryo", 50);
  textFont(font);
  background(255);
  fill(200, 200, 255);
  noStroke();
  fill(0);
  textSize(20);
  textAlign(LEFT);
  mode=0;//スタート画面
  for (int i=0; i<10; i++) {
    NumberImageList[i]=loadImage("img/number_"+i+"_"+numImage+".png");//数字の画像表示
  }
  backImg =loadImage("img/background_1.png");
  isStarted = true;      //ゲーム開始前の状態を記録
}

void draw() {
  lecture();
  letter2048();

  if (isMoving) {
    fill(255);
    rect(0, 0, width, 220);
    fill(245);
    for (int i=0; i<cellQty; i++) {
      for (int j=0; j<cellQty; j++) {
        rect(i*400/cellQty+200/cellQty, j*200/cellQty+40/cellQty, 392/cellQty, 192/cellQty);
        if (mapList[j][i] != 0) {
          backgroundImage(j, i);
          numImage(j, i, str(mapList[j][i]));
        }
      }
    }
    fill(245);
    for (int i=0; i<moveCellList.size()/5; i++) { //動くマスの数だけループ
      float blx = moveCellList.get(i*5+2)+moveCellList.get(i*5+4)*(1-float(moveCount)/fps);
      float bly = moveCellList.get(i*5+1)+moveCellList.get(i*5+3)*(1-float(moveCount)/fps);
      rect(blx*400/cellQty+200/cellQty, bly*200/cellQty+40/cellQty, 392/cellQty, 192/cellQty);
    }

    for (int i = 0; i < moveCellList.size()/5; i++) {
      int num = int(moveCellList.get(i*5));
      moveCellList.set(i*5+1, moveCellList.get(i*5+1) + moveCellList.get(i*5+3)/fps);
      moveCellList.set(i*5+2, moveCellList.get(i*5+2) + moveCellList.get(i*5+4)/fps);
      if (num <= 10) {
        tint(#893333);//画像全体に色付け
      } else if (num <= 100) {
        tint(#FFE4C4);//画像全体に色付け
      } else if (num <= 1000) {
        tint(#FF9B9B);//画像全体に色付け
      } else if (num <=10000) {
        tint(#44B22E);//画像全体に色付け
      } else if (num >= 100000) {
        tint(#893333);//画像全体に色付け
      }
      image(backImg, moveCellList.get(i*5+2)*400/cellQty+200/cellQty, moveCellList.get(i*5+1)*200/cellQty+40/cellQty, 392/cellQty, 192/cellQty);//サイズと位置
      noTint();//色付け終了
      for (int k=0; k<str(num).length(); k++) {
        char numk=str(num).charAt(k);
        PImage NumberImage=NumberImageList[Integer.parseInt(str(numk))];//数字の画像表示
        image(NumberImage, (moveCellList.get(i*5+2)+1)*400/cellQty-200/cellQty+392/cellQty/str(num).length()*k, moveCellList.get(i*5+1)*200/cellQty+40/cellQty, 392/cellQty/str(num).length(), 192/cellQty);//サイズと位置
      }
    }
    moveCount++;
    if (moveCount >= fps) {
      moveCount = 0;
      isMoving = false;
      add2();
      checkGameover();
      writeMap();
    }
  }

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

void mousePressed() {
  if (mouseButton == LEFT && isStarted) {      //ゲーム開始前の状態
    if (mode==0 && mouseX > 380 && mouseX < 480 && mouseY > 210 && mouseY < 290) {
      mode=4;//チュートリアルの画面に移動
    }
    if (mouseX > 30 && mouseX < 120 && mouseY > 210 && mouseY < 290) {
      colorChangeFunction=true;
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


    moveCellList = new FloatList();    //移動したマスの座標を記録するリストを初期化
    loadMap(tentativeList, mapList);    //移動前のマップを記録
    tentativeScore = score;    //移動前のスコアを記録

    isMoved = false;      //移動回数を初期化(今回の入力で1回でも動いたかを記録)
    run(keyInput);    //移動する
    if (isMoved) {        //一回でも動いたなら
      if (!isMoving) {
        isMoving = true;
      }
      loadMap(recordList, tentativeList);    //1つ前のマップを更新
      recordScore =  tentativeScore;    //1つ前のスコアを更新
    }
    checkGameover();

    // writeMap();
  }
}


void run(int keyInput) {
  for (int i = 0; i < cellQty; i++) {
    int n = 0;
    int sumPoint = -1;
    for (int j = 0; j < cellQty; j++) {
      int[] zeroPointList = {j, cellQty - 1 - j, i, i};
      int[] afterPointList = {n, cellQty - 1 - n, i, i};
      int[] nextPointList = {n - 1, cellQty - n, i, i};
      if (mapList[zeroPointList[keyInput]][zeroPointList[(keyInput + 2) % 4]] != 0) {
        int m = mapList[zeroPointList[keyInput]][zeroPointList[(keyInput + 2) % 4]];
        mapList[zeroPointList[keyInput]][zeroPointList[(keyInput + 2) % 4]] = 0;
        mapList[afterPointList[keyInput]][afterPointList[(keyInput+2)%4]] = m;
        if (n > 0 && sumPoint != n && mapList[afterPointList[keyInput]][afterPointList[(keyInput+2)%4]] == mapList[nextPointList[keyInput]][nextPointList[(keyInput+2)%4]]) {
          moveCellList.append(mapList[nextPointList[keyInput]][nextPointList[(keyInput+2)%4]]);
          mapList[nextPointList[keyInput]][nextPointList[(keyInput+2)%4]] *= 2;
          score += mapList[nextPointList[keyInput]][nextPointList[(keyInput+2)%4]];
          mapList[afterPointList[keyInput]][afterPointList[(keyInput+2)%4]] = 0;
          sumPoint = n;
          isMoved = true;
          moveCellList.append(zeroPointList[keyInput]);
          moveCellList.append(zeroPointList[(keyInput+2)%4]);
          moveCellList.append(nextPointList[keyInput] - zeroPointList[keyInput]);
          moveCellList.append(nextPointList[(keyInput+2)%4] - zeroPointList[(keyInput+2)%4]);
        } else {
          if (j != n) {
            isMoved = true;      //移動を記録(keyPressed()で使用)
            moveCellList.append(mapList[afterPointList[keyInput]][afterPointList[(keyInput+2)%4]]);
            moveCellList.append(zeroPointList[keyInput]);
            moveCellList.append(zeroPointList[(keyInput+2)%4]);
            moveCellList.append(afterPointList[keyInput] - zeroPointList[keyInput]);
            moveCellList.append(afterPointList[(keyInput+2)%4] - zeroPointList[(keyInput+2)%4]);
          }
          n++;
        }
      }
    }
  }
}

//ランダムに2を生成する処理
void add2() {
  int add2Count = 0;      //2の生成回数(1回だけにする)
  int idx = 0;          //シャッフル後リストの座標
  StringList orderedList = new StringList();      //空の文字列リスト
  for (int i = 0; i < cellQty * cellQty; i++) {            //0から15まで追加
    orderedList.append(str(i));
  }
  orderedList.shuffle();      //シャッフルする

  int[] shuffledList = new int[cellQty * cellQty];          //0が16個入ったリスト
  for (int i = 0; i < cellQty * cellQty; i++) {
    shuffledList[i] = Integer.parseInt(orderedList.get(i));      //シャッフル後の数列を取得
  }
  while (add2Count < 1) {      //2が生成されるまでループ
    if (mapList[shuffledList[idx]/cellQty][shuffledList[idx]%cellQty] == 0) {      //現在地が0なら
      mapList[shuffledList[idx]/cellQty][shuffledList[idx]%cellQty] = 2;      //2を生成
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
  for (int i = 0; i < cellQty; i++) {
    for (int j = 0; j < cellQty; j++) {
      if (mapList[j][i] == 0) {
        isGameover = false;
      }
    }
    for (int j = 0; j < cellQty - 1; j++) {
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
  if (isGameover||gameOvermode) {
    //動かせなくなったら
    time = millis();        //タイマー用
    background(255, 80, 30);
    text("Game Over", 190, 350);      //テキスト表示
    isElapsed = true;      //タイマー開始の状態を記録
  }
  for (int i = 0; i < cellQty; i++) {
    for (int j = 0; j < cellQty; j++) {
      String strMap = str(mapList[j][i]);     //現在地の数を記録
      if (mapList[j][i] == 0) {          //現在地が0なら
        strMap = " ";                         //空白にして
        fill(245);
      }
      rect(i*400/cellQty+200/cellQty, j*200/cellQty+40/cellQty, 392/cellQty, 192/cellQty);    //マスの表示
      backgroundImage(j, i);           //背景を画像で表示
      numImage(j, i, strMap);           //数を画像で表示
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
  mapList = new int[cellQty][cellQty];    //4*4のマップを生成(要素はすべて0)
  recordList = new int[cellQty][cellQty]; //1つ前のマップを記録するリストを生成
  tentativeList = new int[cellQty][cellQty];  //recordListの仮のリストを生成
  moveCellList = new FloatList();    //移動したマスの座標を記録するリストを初期化
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
  for (int i = 0; i < cellQty; i++) {
    for (int j = 0; j < cellQty; j++) {
      in[j][i] = out[j][i];
      r = 1;
    }
  }
}


//数字を画像で表示
void numImage(int j, int i, String s) {
  if (mapList[j][i] != 0) {
    for (int k=0; k<s.length(); k++) {
      char numk=s.charAt(k);
      PImage NumberImage=NumberImageList[Integer.parseInt(str(numk))];//数字の画像表示
      image(NumberImage, (i+1)*400/cellQty-200/cellQty+392/cellQty/s.length()*k, j*200/cellQty+40/cellQty, 392/cellQty/s.length(), 192/cellQty);//サイズと位置
    }
  }
}

//背景を画像で表示
void backgroundImage(int j, int i) {
  if (mapList[j][i] != 0) {
    if (mapList[j][i] <= 10) {
      tint(#893333);//画像全体に色付け
    } else if (mapList[j][i] <= 100) {
      tint(#FFE4C4);//画像全体に色付け
    } else if (mapList[j][i] <= 1000) {
      tint(#FF9B9B);//画像全体に色付け
    } else if (mapList[j][i] <=10000) {
      tint(#44B22E);//画像全体に色付け
    } else if (mapList[j][i] >= 100000) {
      tint(#893333);//画像全体に色付け
    }

    PImage backImg=loadImage("img/background_1.png");
    image(backImg, i*400/cellQty+200/cellQty, j*200/cellQty+40/cellQty, 392/cellQty, 192/cellQty);//サイズと位置
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
    keyCommand = true;                //キー入力を有効化
  }
}
//lectureNumX=250;
void lecture() {
  if (mode==4) {
    if (lectureNumX == 100) {
      lectureletter();
      PImage numA=NumberImageList[4];//4の数字の画像表示

      image(numA, 100, 10, 70, 60);
      lectureNumX=lectureNumX-1;
    } else if (lectureNumX == 99) {
      delay(1000);
      lectureNumX=250;
    } else {
      lectureletter();
      PImage numA=NumberImageList[2];//2の数字の画像表示
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

void lectureletter() {
  background(255);
  textAlign(LEFT);
  fill(0);
  textSize(18);
  text("このゲームは、2048を作るゲームです。", 20, 120);
  text("矢印キーで数字を動かし、同じ数字が重なると足されます。", 20, 140);
  text("2がランダムマップ上に生成されます。", 20, 160);
  text("動かせなくなるとゲームオーバーです。", 20, 180);
  text("リトライはRキー、一回戻すのはZキーです。", 20, 200);
  //スタートボタンと戻るボタンの四角を設置
  PImage back =loadImage("img/back_button.png");
  image(back, 30, 300, 110, 80);//戻るボタンの四角
  PImage gameStart =loadImage("img/gameStart_button.png");
  image(gameStart, 170, 210, 160, 80);//スタートボタンの四角
}

void startMode() {
  background(255);
  PImage gameStart =loadImage("img/gameStart_button.png");
  image(gameStart, 170, 210, 160, 80);//スタートボタン
  PImage letterChange=loadImage("img/letterChange_button.png");//文字の背景
  image(letterChange, 30, 210, 100, 80);
  PImage tutorial =loadImage("img/tutorial_button.png");
  image(tutorial, 380, 210, 100, 80);//チュートリアルのボタン
}

//2048の文字をアニメーション付きで表示する処理
void letter2048() {
  if (mode==0) {
    if (Y2 < 110) {
      startMode();
      PImage num2=NumberImageList[2];//2の数字の画像表示
      PImage num0=NumberImageList[0];//0の数字の画像表示
      PImage num4=NumberImageList[4];//4の数字の画像表示
      PImage num8=NumberImageList[8];//8の数字の画像表示
      image(num2, 100, Y2, 70, Y2);//2の数字の画像表示
      image(num0, 170, Y2, 70, Y2);//0の数字の画像表示
      image(num4, 240, Y2, 70, Y2);//4の数字の画像表示
      image(num8, 310, Y2, 70, Y2);//8の数字の画像表示
      Y2=Y2+2;
    } else if (Y2 == 110) {
      delay(3000);
      Y2=-40;
    }
  }
}
//これは青木のやつです2
