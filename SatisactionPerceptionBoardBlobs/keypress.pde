void keyPressed() {
  // if (key == 'd') {
  //   ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);
  //   for (int i=0; i<bGaussBitsList.size(); i++) {
  //    GData bGaussBits = bGaussBitsList.get(i);
  //    printPointData(bGaussBits, i);
  //    sendPointData(bGaussBits, i);
  //    println(bGaussBits);
  //    ellipseMode(CENTER);
  //   }
  // }
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
