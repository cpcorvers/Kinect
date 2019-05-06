void sendPointData(GData g, int i) {
  ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);//API Demos
  int polarityInt = g.getPolarity(); //Get the polarity in Int. 0: North, 1:South
  int intensity = (int) g.getIntensity(); //Get the intensity. Unit: gauss
  int x = (int) g.getX(); //Get the X coordinate on the display
  int y = (int) g.getY(); //Get the Y coordinate on the display
  String polarityString = (polarityInt==0 ? "North" : "South" ); 
  for (int j=0; j<bGaussBitsList.size(); j++) {
    GData bGaussBits = bGaussBitsList.get(j);
    if (intensity>0) s.write( i + " " + polarityString + " " + (int)intensity + " " + x + " " + y +  " " + ((int)bGaussBits.x*1.5) + " " +((int)bGaussBits.y*1.6875) + "\n" );
  } // identification - polarity - intensity - x - y - dispX - dispY
}

void receiveDataServer() { //receive data from client on a server
  c = s.available();

  if (c != null) {
    input = c.readString();
    input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    data = int(split(input, ' ')); // Split values into an array
    newInput = ("Message: " + input); // Set data in string for textbox
    //dataReceived = (data[0] + data[1] + data[2] + data[3] + data[4] + data[5], data[6]);
  } else {
    newInput = ("no message received");
  }
  text(newInput, 50, 100, 200, 300);
}

void receiveDataClient() { //receive data from server on a client
  if (c.available() > 0) {
    input = c.readString();
    input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    data = int(split(input, ' ')); // Split values into an array
    newInput = ("Message: " + input); // Set data in string for textbox
    //dataReceived = (data[0] + data[1] + data[2] + data[3] + data[4] + data[5], data[6]);
  } else {
    newInput = ("no message received");
  }
  text(newInput, 50, 100, 200, 300);
}
