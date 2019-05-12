void keyPressed() {
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
    perspectives = loadImage(bg[bgIndex]);
  } else if (key == 'p') {
    if (bgIndex < (bg.length-1)) {
      bgIndex++ ;
    } else {
      bgIndex = 0;
    }
    perspectives = loadImage(bg[bgIndex]);
    
    /*******
    *
    *  STOP THE APPLICATION WIHT S KEYPRESS
    *
    *************/
  } else if (key == 's') {
    exit();
  }
}
