void getGaussData() {
  ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);//API Demos
  // String polarityString = (polarityInt==0 ? "North" : "South" );
  for (int j=0; j<bGaussBitsList.size(); j++) {
    GData bGaussBits = bGaussBitsList.get(j);
    int polarity = bGaussBits.getPolarity(); //Get the polarity in Int. 0: North, 1:South
    int intensity = (int) bGaussBits.getIntensity(); //Get the intensity. Unit: gauss
    int x = round((int) bGaussBits.getX()); //Get the X coordinate on the display
    int y = round((int) bGaussBits.getY()); //Get the Y coordinate on the display

  // for (int k=0; k<bGaussBitsList.size(); k++) {
  //
  // }
    String polarityString = (polarity==0 ? "North" : "South" );
    // int xx = round(((int) x * 1.5));
    // int yy = round(((int) y * 1.6875));
    int xx = round(((int) x * scaleX));
    int yy = round(((int) y * scaleY));

    // store data in the ArrayList boardPawns every .. millisecond
    for (int i = 0; i <= 100; i++){
      if (i == 100) {
        boardPawns.add(new Person(xx, yy, polarity, intensity));
      }// println("getData added: " + boardPawns);
    }
    // if the ArrayList boardPawns is bigger then the sensorlist,
    if (boardPawns.size() > bGaussBitsList.size()) {
      // then move the pawn record to historyPersons
      Person cp = boardPawns.get(0);
      historyPersons.add(cp);
      boardPawns.remove(0);
    };

// send the GaussSense data to the clients
    // if (intensity>0) s.write( j + " " + polarity+ " " + intensity + " " + x + " " + y +  " " + xx + " " + yy + "\n" );
  }
  // Empty pawn list when sensor give no data
  if (bGaussBitsList.size() == 0){
    emptyBoardPawns();
  }
  // Avoiding full of memory exeption by restricting the size of the ArrayLists
  if (boardPawns.size() > 200) {
    boardPawns.remove(0);
  }
  if (screenPersons.size() > 200) {
    for (int i = 0; i < (screenPersons.size()-200); i++){
      screenPersons.remove(i);
    }
  }
  if (historyPersons.size() > 200) {
    for (int i = 0; i < (historyPersons.size()-200); i++){
      historyPersons.remove(i);
    }
  }
}

void emptyBoardPawns(){
  for (int i = 0; i < boardPawns.size(); i++) {
    Person cp = boardPawns.get(i);
    boardPawns.remove(i);
  }
}
