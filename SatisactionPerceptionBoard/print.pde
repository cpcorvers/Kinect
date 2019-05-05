void printPointData(GData g, int i) {
  ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);//API Demos
  int polarityInt = g.getPolarity(); //Get the polarity in Int. 0: North, 1:South
  int intensity = (int) g.getIntensity(); //Get the intensity. Unit: gauss
  int x = (int) g.getX(); //Get the X coordinate on the display
  int y = (int) g.getY(); //Get the Y coordinate on the display
  String polarityString = (polarityInt==0 ? "North" : "South" ); 
  for (int j=0; j<bGaussBitsList.size(); j++) {
    GData bGaussBits = bGaussBitsList.get(j);
    if (intensity>0) println(i+":"+polarityString +", BasicGaussBits: ~ " + (int)intensity + " gauss, (x,y)= ("+x+","+y+")" + "(x,y) = "+ ((int)bGaussBits.x*1.5) + "," +((int)bGaussBits.y*1.6875) );
  }
}

void sendPointData(GData g, int i) {
  ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);//API Demos
  int polarityInt = g.getPolarity(); //Get the polarity in Int. 0: North, 1:South
  int intensity = (int) g.getIntensity(); //Get the intensity. Unit: gauss
  int x = (int) g.getX(); //Get the X coordinate on the display
  int y = (int) g.getY(); //Get the Y coordinate on the display
  String polarityString = (polarityInt==0 ? "North" : "South" ); 
  for (int j=0; j<bGaussBitsList.size(); j++) {
    GData bGaussBits = bGaussBitsList.get(j);
    if (intensity>0) s.write( i + " " + polarityString + " " + (int)intensity + " " + x + " " + y +  " " + " " + ((int)bGaussBits.x*1.5) + " " +((int)bGaussBits.y*1.6875) + "\n" );
  } // identification - polarity - intensity - x - y - dispX - dispY
}

void receiveData() {
  c = s.available();
  
  if (c != null) {
     input = c.readString();
    input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    data = int(split(input, ' ')); // Split values into an array
    // Draw line using received coords

     newInput = ("Message: " + input);
    //dataReceived = (data[0] + data[1] + data[2] + data[3] + data[4] + data[5], data[6]); 
  } else {
     newInput = ("no message received");
  }
  text(newInput, 50, 100, 200, 300);
}

//void printImageSecondDisplay() {  
//  t.showImage("perspective6.png");
//  t.showImage("27.png", 100, 100, 20, 60);
//}

void keyPressed() {
  if (key == 'd') t1.takePictureWithUI(0);

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
    t1.showImage(bg[bgIndex]);
  } else if (key == 'p') {
    if (bgIndex < (bg.length-1)) {
      bgIndex++ ;
    } else {
      bgIndex = 0;
    }
    t1.showImage(bg[bgIndex]);
  }
}
