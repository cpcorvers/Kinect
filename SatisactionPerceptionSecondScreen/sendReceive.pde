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
     boardPawns.add(new Person(x, y));
  }
}
