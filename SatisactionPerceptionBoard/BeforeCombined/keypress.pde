void keyPressed() {
  //CHANGING PLAYINGFIELD BACKGROUND WITH Q AND W KEYPRESS

  if (key == 'q') {
    if (bgIndex > 0) {
      bgIndex-- ;
    } else {
      bgIndex = bg.length-1;
    }
    playingfield = loadImage(bg[bgIndex]);
  } else if (key == 'w') {
    if (bgIndex < (bg.length-1)) {
      bgIndex++ ;
    } else {
      bgIndex = 0;
    }
    playingfield = loadImage(bg[bgIndex]);
  }
}
