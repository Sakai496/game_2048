int ix;
int iy;
IntList myList;
int count;
int m;
int n;
int o;
String s;

int[][] lista = new int[4][4];


void setup() {
  size(300, 300);
  count = 0;
  for (int i = 0; i < 2; i++) {
    add2();
  }
  writeMap();
}

void draw() {
}

void keyPressed() {
  if (keyCode == UP) {
    for (int i = 0; i < 4; i++) {
      moveUP(i);
      for (int j = 0; j < 3; j++) {
        if ((lista[j][i] != 0)&&(lista[j][i] == lista[j+1][i])) {
          lista[j][i] *= 2;
          lista[j+1][i] = 0;
        }
      }
      moveUP(i);
    }
  }
  if (keyCode == DOWN) {
    for (int i = 0; i < 4; i++) {
      moveDOWN(i);
      for (int j = 0; j < 3; j++) {
        if ((lista[3-j][i] != 0)&&(lista[3-j][i] == lista[2-j][i])) {
          lista[3-j][i] *= 2;
          lista[2-j][i] = 0;
        }
      }
      moveDOWN(i);
    }
  }
  if (keyCode == LEFT) {
    for (int i = 0; i < 4; i++) {
      moveLEFT(i);
      for (int j = 0; j < 3; j++) {
        if ((lista[i][j] != 0)&&(lista[i][j] == lista[i][j+1])) {
          lista[i][j] *= 2;
          lista[i][j+1] = 0;
        }
      }
      moveLEFT(i);
    }
  }
  if (keyCode == RIGHT) {
    for (int i = 0; i < 4; i++) {
      moveRIGHT(i);
      for (int j = 0; j < 3; j++) {
        if ((lista[i][3-j] != 0)&&(lista[i][3-j] == lista[i][2-j])) {
          lista[i][3-j] *= 2;
          lista[i][2-j] = 0;
        }
      }
      moveRIGHT(i);
    }
  }
  add2();
  writeMap();
}



void moveUP(int i) {
  n = 0;
  for (int j = 0; j < 3; j++) {
    o = 0;
    for (int k = 0; k < 4-j; k++) {
      if (lista[3-k][i] != 0) {
        o = 1;
      }
    }
    while (lista[j][i] == 0 && n < 3 && o != 0) {
      for (int k = 0; k < 3-j; k++) {
        lista[k+j][i] = lista[k+j+1][i];
      }
      lista[3][i] = 0;
      n += 1;
    }
  }
}

void moveDOWN(int i){
  n = 0;
  for (int j = 0; j < 3; j++) {
    o = 0;
    for (int k = 0; k < 4-j; k++) {
      if (lista[k][i] != 0) {
        o = 1;
      }
    }
    while (lista[3-j][i] == 0 && n < 3 && o != 0) {
      for (int k = 0; k < 3-j; k++) {
        lista[3-k-j][i] = lista[2-k-j][i];
      }
      lista[0][i] = 0;
      n += 1;
    }
  }
}

void moveLEFT(int i){
  n = 0;
  for (int j = 0; j < 3; j++) {
    o = 0;
    for (int k = 0; k < 4-j; k++) {
      if (lista[i][3-k] != 0) {
        o = 1;
      }
    }
    while (lista[i][j] == 0 && n < 3 && o != 0) {
      for (int k = 0; k < 3-j; k++) {
        lista[i][k+j] = lista[i][k+j+1];
      }
      lista[i][3] = 0;
      n += 1;
    }
  }  
}

void moveRIGHT(int i){
  n = 0;
  for (int j = 0; j < 3; j++) {
    o = 0;
    for (int k = 0; k < 4-j; k++) {
      if (lista[i][k] != 0) {
        o = 1;
      }
    }
    while (lista[i][3-j] == 0 && n < 3 && o != 0) {
      for (int k = 0; k < 3-j; k++) {
        lista[i][3-k-j] = lista[i][2-k-j];
      }
      lista[i][0] = 0;
      n += 1;
    }
  }  
}

void add2() {
  count = 0;
  m = 0;
  StringList listb = new StringList();
  for (int i = 0; i < 16; i++) {
    listb.append(str(i));
  }
  listb.shuffle();
  int[] listc = new int[16];
  for (int i = 0; i < 16; i++) {
    listc[i] = Integer.parseInt(listb.get(i));
  }
  while (count < 1) {
    if (lista[listc[m]/4][listc[m]%4] == 0) {
      lista[listc[m]/4][listc[m]%4] = 2;
      println(listc[m]);
      count++;
    }
    m++;
  }
}

void writeMap() {
  background(255);
  println(" ");
  for (int i = 0; i < 4; i++) {
    s = " ";
    for (int j = 0; j < 4; j++) {
      s += str(lista[i][j]);
      if (lista[i][j] < 10) {
        s += "   ";
      }
      else{
        s += " ";
      }
    }
    fill(0);
    textSize(60);
    text(s, 0, 50*(i+1));
  }
}
