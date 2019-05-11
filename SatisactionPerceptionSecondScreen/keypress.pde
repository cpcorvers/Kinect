void keyPressed() {
<<<<<<< HEAD
  // if (key == 'd') t1.takePictureWithUI(0);
=======
  //if (key == 'd') t1.takePictureWithUI(0);
>>>>>>> 8468d79766c20f21f51fcd7b7abc764379ae4466

  /***********
   *
   * CHANGING BACKGROUND SECOND SCREEN WITH O AND P KEYPRESS
   *
   ***************/

  if (key == 'o') {
    if (bgIndex > 0) {
      bgIndex-- ;
    } else {
      bgIndex = bg.length-1;
    }
    //t1.showImage(bg[bgIndex]);
    perspectives = loadImage(bg[bgIndex]);
  } else if (key == 'p') {
    if (bgIndex < (bg.length-1)) {
      bgIndex++ ;
    } else {
      bgIndex = 0;
    }
    //t1.showImage(bg[bgIndex]);
    perspectives = loadImage(bg[bgIndex]);
  }
}
