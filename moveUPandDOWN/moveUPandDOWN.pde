int[][] lista = new int[4][4];
int U,D=0;

void moveUPandDOWN(int l) {//UPが押されたときの動き。0があれば上に詰める。変更後]
if (keyCode == UP){
  U=l;
}
if (keyCode == DOWN) {
  D=l;
}
for (int j = 0; j < 4; j++) {
for (int i = 0; i < 4; i++) { 
    for (int k = 0+U; k < 4-D; k++) {//上から０以外があるか調べる。しかし、一番上の文字は詰めなくてよいので調べない。
      if (lista[k-D][i] != 0 && lista[k-U][i] == 0) {//kは行。０以外の数字を見つけるため。上の数が０なら詰める。
        lista[k-U][i] = lista[k-D][i];//1つ下の数字を上に詰める  
        lista[k-D][i] = 0;//詰めた後は０にする 
      }      
    }
  }
}
}
