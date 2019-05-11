// void sendPointData(GData g, int i) {
//   ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);//API Demos
//   int polarityInt = g.getPolarity(); //Get the polarity in Int. 0: North, 1:South
//   int intensity = (int) g.getIntensity(); //Get the intensity. Unit: gauss
//   int x = (int) g.getX(); //Get the X coordinate on the display
//   int y = (int) g.getY(); //Get the Y coordinate on the display
//   String polarityString = (polarityInt==0 ? "North" : "South" );
//   for (int j=0; j<bGaussBitsList.size(); j++) {
//     GData bGaussBits = bGaussBitsList.get(j);
//     if (intensity>0) s.write( i + " " + polarityString + " " + (int)intensity + " " + x + " " + y +  " " + " " + ((int)bGaussBits.x*1.5) + " " +((int)bGaussBits.y*1.6875) + "\n" );
//   } // identification - polarity - intensity - x - y - dispX - dispY
// }

// void printPointData(GData g, int i) {
//   ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);//API Demos
//   int polarityInt = g.getPolarity(); //Get the polarity in Int. 0: North, 1:South
//   int intensity = (int) g.getIntensity(); //Get the intensity. Unit: gauss
//   int x = (int) g.getX(); //Get the X coordinate on the display
//   int y = (int) g.getY(); //Get the Y coordinate on the display
//   String polarityString = (polarityInt==0 ? "North" : "South" );
//   for (int j=0; j<bGaussBitsList.size(); j++) {
//     GData bGaussBits = bGaussBitsList.get(j);
//     if (intensity>0) println(i+":"+polarityString +", BasicGaussBits: ~ " + (int)intensity + " gauss, (x,y)= ("+x+","+y+")" + "(x,y) = "+ ((int)bGaussBits.x*1.5) + "," +((int)bGaussBits.y*1.6875) );
//   }
// }

// void receiveDataServer() { //receive data from client on a server
//   c = s.available();
//
//   if (c != null) {
//     input = c.readString();
//     input = input.substring(0, input.indexOf("\n")); // Only up to the newline
//     data = int(split(input, ' ')); // Split values into an array
//     newInput = ("Message: " + input); // Set data in string for textbox
//     //dataReceived = (data[0] + data[1] + data[2] + data[3] + data[4] + data[5], data[6]);
//   } else {
//     newInput = ("no message received");
//   }
//   //text(newInput, 50, 100, 200, 300);
// }

void receiveDataClient() { //receive data from server on a client
  // if data is send from the GausseSense
  // e.g. if there is a pawn on the board
  // then put data in boardPersons
  // else empty boardPersons
  if (c.available() > 0) {
    input = c.readString();
    input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    data = int(split(input, ' ')); // Split values into an array
     // Data strutcture from server:identification - polarity - intensity - x - y - dispX - dispY
     // float id = parseFloat (data[0]);
     // float id = 0; //personCounter;
     float polarity = parseFloat (data[1]);
     float intensity = parseFloat (data[2]);
     float x = parseFloat (data[3]);
     float y = parseFloat (data[4]);
     boardPersons.add(new Person(x, y));
     // println(data);
     // personCounter++;
  // } else if (c.available() <= 0 && boardPersons.size() <= 0) {
    // // println("no pawns on the board");
    // for (int i = 0; i < boardPersons.size(); i++) {
    //   // Person p = boardPersons.get(i);
    //   boardPersons.remove(i);
      // println("boardPersons is empty");
    // }
  }
}
