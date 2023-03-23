//format:
/*
{{0, 0, 0,  0, 0, 0,   0, 0, 0},
 {0, 0, 0,   0, 0, 0,   0, 0, 0},
 {0, 0, 0,   0, 0, 0,   0, 0, 0},
 
 {0, 0, 0,   0, 0, 0,   0, 0, 0},
 {0, 0, 0,   0, 0, 0,   0, 0, 0},
 {0, 0, 0,   0, 0, 0,   0, 0, 0},
 
 {0, 0, 0,   0, 0, 0,   0, 0, 0},
 {0, 0, 0,   0, 0, 0,   0, 0, 0},
 {0, 0, 0,   0, 0, 0,   0, 0, 0}};
 */


int matrix_size = 9;
int[][] original_matrix = {{7, 0, 5,   9, 0, 2,    0, 0, 1},
                          {6, 0, 2,    0, 4, 7,    8, 5, 3},
                          {8, 4, 0,    5, 0, 6,    2, 0, 0},
                        
                          {4, 0, 0,   0, 0, 3,    0, 0, 0},
                          {2, 1, 0,    4, 0, 0,   9, 3, 6},
                          {0, 0, 8,   7, 0, 0,    5, 4, 2},
                        
                          {0, 7, 0,   3, 0, 9,    6, 0, 0},
                          {0, 0, 3,   6, 7, 0,    1, 2, 9},
                          {9, 0, 6,   0, 0, 0,    3, 7, 0}};

// Make sure we are working in a copy to check in the end if everything is alright.
//int [][] sudoku_matrix = original_matrix;



float cols, rows;
int[][] sudoku_matrix = new int[original_matrix.length][original_matrix[0].length];


void setup() {
  
  for (int i = 0; i < original_matrix.length; i++) {
    for (int j = 0; j < original_matrix[i].length; j++) {
      sudoku_matrix[i][j] = original_matrix[i][j];
    }
  }
  
  size(500, 500);
  background(0);

  // draw all the lines
  stroke(255);

  cols = width/matrix_size;
  rows = height/matrix_size;

  for (int i = 1; i < matrix_size; i++) {

    float x_pos = i*cols;
    float y_pos = i*rows;
    if (i%3!=0) {
      strokeWeight(0.5);
    } else {
      strokeWeight(3);
    }
    line(x_pos, 0, x_pos, height);
    line(0, y_pos, width, y_pos);
  }
}

int inRow(int[][] list, int value, int r) {
  int index = -1;
  for (int i = 0; i < matrix_size; i++) {
    if (list[r][i] == value) {
      index = i;
    }
  }
  return index;
}

// Make a list of numbers that are missing in a row
IntList rowCheck(int row) {
  IntList checked_row = new IntList();
  for (int i = 1; i < 10; i++) {
    checked_row.append(i); // add the numbers 0 to 9 to the list
  }
  for (int i = 9; i > 0; i--) {
    if (inRow(sudoku_matrix, i, row) > -1) {
      checked_row.remove(i-1);
    }
  }
  //println("Checked row " + row + "  and gotten these results: " + checked_row);
  return checked_row;
}

int inCol(int[][] list, int value, int c) {
  int index = -1;
  for (int i = 0; i < matrix_size; i++) {
    if (list[i][c] == value) {
      index = i;
    }
  }
  return index;
}

// Make a list of numbers that are missing in a row
IntList colCheck(int col) {
  IntList checked_col = new IntList();
  for (int i = 1; i < 10; i++) {
    checked_col.append(i); // add the numbers 0 to 9 to the list
  }
  for (int i = 9; i > 0; i--) {
    if (inCol(sudoku_matrix, i, col) > -1) {
      checked_col.remove(i-1);
    }
  }
  //println("Checked col " + col + "  and gotten these results: " + checked_col);
  return checked_col;
}

// Locates the box a single grid space is in
int whichBox(int x, int y) {
  int index = -1;
  int[][] boxLayout = {{0,1,2},
                     {3,4,5},
                     {6,7,8}};
  index = boxLayout[floor(y/3)][floor(x/3)];
  return index;
}



int inBox(int[][] list, int value, int b) {
  int index = -1;
  int restB = floor(b/3);
  int startY = restB*3;
  int startX = (b-startY)*3;
  int x = 0;
  int y = 0;
  
  for (int i = 0; i < matrix_size; i++) {
    if (list[startY+y][startX+x] == value) {
      index = i;
    }
    if (x <2) {
      x++;
    } else {
      y++;
      x=0;
    }
  }
  
  //println("x: "+x+"y: "+y);
  return index;
}


// Make a list of numbers that are missing in a row
IntList boxCheck(int box) {
  IntList checked_box = new IntList();
  for (int i = 1; i < 10; i++) {
    checked_box.append(i); // add the numbers 0 to 9 to the list
  }
  for (int i = 9; i > 0; i--) {
    if (inBox(sudoku_matrix, i, box) > -1) {
      checked_box.remove(i-1);
    }
  }
  //println("Checked box " + box + " and gotten these results: " + checked_box);
  return checked_box;
}

IntList commonElements(IntList list1, IntList list2) {
  IntList commonElementsList = new IntList();
  //println("List1: " + list1);
  //println("List2: " + list2);


  for (int i = 0; i < list1.size(); i++) {
    for (int j = 0; j < list2.size(); j++) {
      if (list1.get(i) == list2.get(j)) {
        commonElementsList.append(list1.get(i)); // add the common element to the commonElements list
      }
    }
  }
  //println("List: " + commonElementsList);
  return commonElementsList;
}

IntList finalCheck(int x,int y) {
  IntList temp_list = new IntList();
  IntList final_list = new IntList();
  IntList col = colCheck(x);
  IntList row = rowCheck(y);
  IntList box = boxCheck(whichBox(x,y));
  temp_list = commonElements(col, row);
  final_list = commonElements(temp_list, box);
  
  println("Checked index x:" + (x) + " y:"+(y) + " and gotten these results: \n" + final_list + "\n");
  return final_list;
}



int empty = 0;
int remainEmpty = 0;

void draw() {
  // draw all the numbers
  textAlign(CENTER, CENTER);
  textSize(25);
  for (int y = 0; y < matrix_size; y++) {
    for (int x = 0; x < matrix_size; x++) {
      float x_pos = (x+0.5)*cols;
      float y_pos = (y+0.5)*rows;
      //println(original_matrix[y][x]<0);

      if (sudoku_matrix[y][x]>0) {
        if (original_matrix[y][x]>0) {
          fill(255,255,255);
        } else {
          fill(150,150,255);
        }
        text(sudoku_matrix[y][x], x_pos, y_pos);
        
      } else {
          empty+=1;
          remainEmpty+=1;
          IntList final_list = finalCheck(x,y);
          if (final_list.size() == 1) {
            sudoku_matrix[y][x] = final_list.get(0);
            remainEmpty-=1;
          } 
      }
    }
  }
  
    //for (int y = 0; y < matrix_size; y++) {
    //  for (int x = 0; x < matrix_size; x++) {
    //    print(original_matrix[y][x]);
        
    //  }
    //  print("\n");
    //}
  
  
  println("Empty slots at beginning: " + (empty-8));
  //noLoop();
}
