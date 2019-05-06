void keyPressed() {
  if (key == 'd') t1.takePictureWithUI(0);

  /***********
   * 
   * CHANGING PLAYINGFIELD BACKGROUND WITH Q AND W KEYPRESS
   *
   ***************/

  if (key == 'q') {
    if (bgIndex > 0) {
      bgIndex-- ;
    } else {
      bgIndex = bg.length-1;
    }
    //t1.showImage(bg[bgIndex]);
    playingfield = loadImage(bg[bgIndex]);
  } else if (key == 'w') {
    if (bgIndex < (bg.length-1)) {
      bgIndex++ ;
    } else {
      bgIndex = 0;
    }
    //t1.showImage(bg[bgIndex]);
    playingfield = loadImage(bg[bgIndex]);
  }
}
