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
