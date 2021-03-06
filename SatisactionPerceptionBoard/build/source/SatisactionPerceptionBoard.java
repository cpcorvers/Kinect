import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import gausstoys.core.*; 
import websockets.*; 
import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SatisactionPerceptionBoard extends PApplet {

/********************
 * IMPORT
 *******************/





/********************
 * INIT
 *******************/
GaussSense gsMeta;
GaussSense[] gs = new GaussSense[2];
boolean showContour = true;
boolean testBoard = false;
int thld = 6 ; //Unit: Gauss
boolean horizontalGrid = true;

// background images
PImage playingfield;
String[] bgBoard = {"playingfield1.png", "playingfield2.png", "playingfield3.png", "playingfield4.png" };
int bgBoardIndex = 0;

PImage perspectives;
String[] bgScreen = {"perspective1.png",  "perspective3.png", "perspective4.png", "perspective5.png", "perspective6.png", "perspective7.png" };
int bgScreenIndex = 0;
PImage person_abstract;

// INIT SECOND SCREEN / SERVER CLIENT
Server s;
Client c;
String input;
String newInput;
int data[];
int port = 3030;

int boardScreen = 1;

// INIT 'databases'
Person p;
ArrayList<Person> boardPawns;
ArrayList<Person> screenPersons;
ArrayList<Person> historyPersons;

float scaleX = 1.4900f; //1.373 //width of screen
float scaleY = 1.550f; //1.350 //hight of screen
float offsetX = 10; // 76;
float offsetY = 10; // 65;

JSONArray pawnsOnDigiboard;
JSONObject pawn;
int recordArray = 0;

//INIT Display variables
int boardDisplayWidth = 1920;
int boardDisplayHeight = 1080;
int screenDisplayWidth = 1280;
int screenDisplayHeight = 800;
// int screen = 0;

public void settings() {
  fullScreen(P2D, boardScreen);
}


/********************
 * SETUP FUNCTION
 *******************/
public void setup() {
  // START THE SERVER
  s = new Server(this, port); // Start a simple server on a port
  frameRate(20);
  playingfield = loadImage(bgBoard[bgBoardIndex]);

  // List all serial ports
  // GaussSense.printSerialPortList();

  //Initialize the GaussSense
  for (int i = 0; i < 2; i ++) {
    gs[i] = new GaussSense(this, GaussSense.GSType.GAUSSSENSE_BASIC, Serial.list()[Serial.list().length - (i+1)], 115200);
    gs[i].setCalibrationFileName("BASIC-"+i+".data");
  }
  gsMeta = new GaussSense(this, GaussSense.GSType.GAUSSSENSE_BASIC, 2, 1);

  // Intitialize the arrays for pawns and persons
  boardPawns = new ArrayList<Person>();
  screenPersons = new ArrayList<Person>();
  historyPersons = new ArrayList<Person>();

  pawnsOnDigiboard = new JSONArray();
  // pawn = new JSONObject();

  perspectives = loadImage(bgScreen[bgScreenIndex]);
  person_abstract = loadImage("27.png");

  println("Setup complete");
  // println("display: " + displayWidth + "," + displayHeight);
}

/********************
 * DRAW FUNCTION
 *******************/
public void draw() {
  background(250);

  // create boardvisual on the boardscreen with keypress to switch images
  pushMatrix();
  translate(boardDisplayWidth, 0);
  rotate (PI/2);
  // image(playingfield, 0,  0, displayHeight, displayWidth );
  image(playingfield, 0,  0, displayHeight, displayWidth );
  popMatrix();

  //Set variables for drawing single-layer contour map
  //Try to change the Thld to see the results
  int upsampleFactor = 5;

  for (int i = 0; i < 2; i ++) {
    if (gs[i].getAdditionalData().size()>0) {
      int s = gs[i].getAdditionalData().get(0);
      //println(s);
      if (s == '1') gsMeta.set(gs[i], 0, 0, 2, false, false);
      if (s == '2') gsMeta.set(gs[i], 1, 0, 2, false, false);
    }
  }

  // show visuals as generated by the GaussSense product and software if showContour == true in INIT
  pushMatrix();
    translate(offsetX, offsetY);
    scale(scaleX, scaleY);
    if (showContour) {
      //Set and draw the upsampled contour map
       gsMeta.drawUpsampledContourMap2D(1280, 640, upsampleFactor, thld);
    } else {
      //Set but don't draw the upsampled contour map
      gsMeta.setUpsampledContourMap2D(1280, 640, upsampleFactor, thld);
    }
    // gsMeta.drawBasicGaussBits(); //draw a circle around the sensed magnets
  popMatrix();

  //receive data from GaussSense, create Person in Arraylists and add Person.parameters using class Person
  getGaussData();
  getPawnCenter();

  //visualise a pawn on the boardscreen and send Person.parameters to the clients
  dataVisualisation();

  // Play with JSON instead of Arraylists for interaction with clients.
  //  make a JSON object of all items in boardPawns and add to JSON Array
  createJSON();
  // saveJSONObject(pawn, "data/data.json");
  saveJSONArray(pawnsOnDigiboard, "data/data.json");


  // only for coding and debugging:
  // println(pawnsOnDigiboard);
  println(boardPawns.size() + " " + screenPersons.size() + " " + historyPersons.size());
}

// void createJSON() { //Just playing
//   // show every person which is taken==true
//   pawn = new JSONObject();
//   for (int i = 0; i < screenPersons.size(); i ++) {
//     // pawn = new JSONObject();
//     Person p = screenPersons.get(i);
//     if (p.takenJSON == false) {
//       p.getPawnCenter();
//       p.becomeJSONObject();
//       p.takenJSON = true;
//       };
//     }
//   if (pawn != null){
//     pawnsOnDigiboard.setJSONObject(recordArray, pawn);
//     recordArray++;
//     saveJSONArray(pawnsOnDigiboard, "data/data.json");
//     // pawn = null;
//     println(pawnsOnDigiboard);
//   }
// }

public void getGaussData() {
  //Receive data from the GaussSense sensors and store in an Arraylist
  ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);//API Demos
  for (int j=0; j < bGaussBitsList.size(); j++) {
    GData bGaussBits = bGaussBitsList.get(j);
    int polarity = bGaussBits.getPolarity(); //Get the polarity in Int. 0: North, 1:South

      int intensity = (int) bGaussBits.getIntensity(); //Get the intensity. Unit: gauss
      int x = round((int) bGaussBits.getX()); //Get the X coordinate on the display
      int y = round((int) bGaussBits.getY()); //Get the Y coordinate on the display
      // String polarityString = (polarity==0 ? "North" : "South" );
      int xx = round(((int) x * scaleX));
      int yy = round(((int) y * scaleY));
      // store data in the ArrayList boardPawns every .. millisecond
      // for (int i = 0; i <= 100; i++){
      //   if (i == 100) {
          boardPawns.add(new Person(xx, yy, polarity, intensity));
          // screenPersons.add(new Person(xx, yy, polarity, intensity));
          // historyPersons.add(new Person(xx, yy, polarity, intensity));

    // if the ArrayList boardPawns is bigger then the sensorlist,
    if (boardPawns.size() > bGaussBitsList.size()) {
      // then move the pawn record to historyPersons
      for (int i = 0; i < (boardPawns.size() - bGaussBitsList.size()); i++){
        Person hp = boardPawns.get(i);
        // historyPersons.add(hp);
        boardPawns.remove(i);
      }
    };
    // send the GaussSense data to the clients
    // if (intensity>0) s.write( j + " " + polarity+ " " + intensity + " " + x + " " + y +  " " + xx + " " + yy + "\n" );
  }
  // Empty ArrayList boardPawns when sensors give no data
  if (bGaussBitsList.size() == 0){ emptyBoardPawns(); }
  // Avoiding full of memory exeption by restricting the size of the ArrayLists
  if (boardPawns.size() > 200) {
    for (int i = 0; i < (boardPawns.size() - 200); i++){ boardPawns.remove(i); }
  }
  if (screenPersons.size() > 200) {
    for (int i = 0; i < (screenPersons.size() - 200); i++){ screenPersons.remove(i); }
  }
  if (historyPersons.size() > 200) {
    for (int i = 0; i < (historyPersons.size() - 200); i++){ historyPersons.remove(i); }
  }
}

public void getPawnCenter(){
  float x1;
  float y1;
  float x2;
  float y2;
  // for (Person cp1 : boardPawns) {
  for (int i = 0; i < (boardPawns.size()); i++){
    Person cp0 = boardPawns.get(i);

    if (cp0.pawn_polarity == 0){
      float recordDC = 500;
      Person matchedCenter = null;
      // for (Person cp2 : boardPawns) {
      for (int j = 0; j < (boardPawns.size()); j++){
        Person cp1 = boardPawns.get(j);
        if (cp1.pawn_polarity == 1){
          PVector center0 = cp0.getCenter();
          PVector center1 = cp1.getCenter();
          float dc = PVector.dist(center0, center1);
          if (dc < recordDC && !cp1.takenCenter ) {
            recordDC = dc;
            matchedCenter = cp1;
          }
          if (matchedCenter != null) {
            matchedCenter.takenCenter = true;
            x1 = cp0.pawn_x;
            y1 = cp0.pawn_y;
            x2 = matchedCenter.pawn_x;
            y2 = matchedCenter.pawn_y;
            matchedCenter.pawnCenterX = (x1 + x2) /2;
            matchedCenter.pawnCenterY = (y1 + y2) /2;
            // calculate the direction of the pawn by the angle between the two magnets of the pawn
            float degree = atan2( (y2 - y1) , (x2 - x1));
            matchedCenter.direction = degree; //radians(degree);
            cp0.becomePawnCenter(matchedCenter);
          }
        }
      }
      // println(pawnCentreX + pawnCentreY);
      // if (matchedCenter != null) {
      //   matchedCenter.takenCenter = true;
      //   x1 = cp1.pawn_x;
      //   y1 = cp1.pawn_y;
      //   x2 = matchedCenter.pawn_x;
      //   y2 = matchedCenter.pawn_y;
      //   matchedCenter.pawnCenterX = (x1 + x2) /2;
      //   matchedCenter.pawnCenterY = (y1 + y2) /2;
      //   // calculate the direction of the pawn by the angle between the two magnets of the pawn
      //   float degree = atan2( (y2 - y1) , (x2 - x1));
      //   matchedCenter.direction = degree; //radians(degree);
      //   cp1.becomePawnCenter(matchedCenter);
      // }
    }
  }
}

public void dataVisualisation() {
  // show every person which is taken==true
  for (Person p : boardPawns) {
    if ( p.pawn_polarity == 1) { //p.taken == true &&
      // p.getPawnCenter();
      p.showPawn(p.pawnCenterX, p.pawnCenterY, p.identity, p.direction);
    // } else if ( p.pawn_polarity == 0) {
    //   p.getPawnCenter();
    //   p.showPawn(p.pawnCenterX, p.pawnCenterY, p.identity, p.direction);
    }
  }
}

public void createJSON() {
  // show every person which is taken==true
  for (int i = 0; i < boardPawns.size(); i ++) {
    pawn = new JSONObject();
    Person p = boardPawns.get(i);
    // if (p.takenJSON == false) {
      // p.getPawnCenter();
      p.becomeJSONObject();
      // p.takenJSON = true;
      // };

    if (pawn != null){
      pawnsOnDigiboard.setJSONObject(recordArray, pawn);
      recordArray++;
      // saveJSONObject(pawn, "data/data.json");
      // pawn = null;
    }
  }
}

public void emptyBoardPawns(){
  for (int i = 0; i < boardPawns.size(); i++) {
    Person cp = boardPawns.get(i);
    boardPawns.remove(i);
  }
}

public void keyPressed() {
  //CHANGING PLAYINGFIELD BACKGROUND WITH Q AND W KEYPRESS
  if (key == 'q') {
    if (bgBoardIndex > 0) {
      bgBoardIndex-- ;
    } else {
      bgBoardIndex = bgBoard.length-1;
    }
    playingfield = loadImage(bgBoard[bgBoardIndex]);
  } else if (key == 'w') {
    if (bgBoardIndex < (bgBoard.length-1)) {
      bgBoardIndex++ ;
    } else {
      bgBoardIndex = 0;
    }
    playingfield = loadImage(bgBoard[bgBoardIndex]);
  } else if (key == 'n') {
    // println(pawnsOnDigiboard);

  }

}
// Person class on PerceptionBoard
class Person { // class

// Setup of JSONobject for Person Class
// String data = "{ \"p.pawn_x\:  , \"p.pawn_y\":  , \"p.pawn_polarity\":  ,\"p.pawn_intensity\":  , \"p.pawnCenterX\":  , \"p.pawnCenterY\":  , \"p.identity\":  , \"p.direction\" :  }";
// [{
//     "pawn_x": ,
//     "pawn_y": ,
//     "pawn_polarity": ,
//     "pawn_intensity": ,
//     "identity": ,
//     "pawnCenterX": ,
//     "pawnCenterY": ,
//     "direction": ,
//     "timestamp":
//   }
// ]

  // data:
  float xp;  // width of the perspective
  float zp;  // depth of the perspective
  float scalefactor; //variable to create a 3D perspective in 2D rendering of the person image
  float wp;
  float hp;
  PImage person_abstract = loadImage("27.png");

  PImage pawnVisual = loadImage("pawnVisual.png");
  int imagePawnWidth = 100; //width of the .png image of the pawn in birdview
  int imagePawnHeight = 50; //height of the .png image of the pawn in birdview

  int serverDisplayWidth = 1920;
  int serverDisplayHeight = 1080;
  int imagePersonWidth = 177; //width of the .png image
  int imagePersonHeight = 408; //height of the .png image

  float pawn_x;
  float pawn_y;
  float pawn_polarity;
  float pawn_intensity;
  float pawnCenterX;
  float pawnCenterY;
  float identity;
  float direction;
  float timestamp;

  float pawn_ID;
  float recordD = 1000;
  boolean taken = false;

  boolean takenCenter = false;
  boolean takenJSON = false;

  // constructors:
  Person(float x, float y) {
    pawn_x = x;
    pawn_y = y;
  };
  Person(float x, float y, float id) {
    pawn_x = x;
    pawn_y = y;
    pawn_ID = id;
  };
  Person(float x, float y, int polarity, float intensity) {
    pawn_x = x;
    pawn_y = y;
    pawn_polarity = polarity;
    pawn_intensity = intensity;
    giveIdentity();
    // getPawnCenter();
    // becomeJSONObject();
  };
  Person(float pawn_x, float pawn_y, float pawn_polarity, float pawn_intensity, float pawnCenterX, float pawnCenterY, float identity, float direction, float timestamp){
    pawn_x = pawn_x;
    pawn_y = pawn_y;
    pawn_polarity = pawn_polarity;
    pawn_intensity = pawn_intensity;
    pawnCenterX = pawnCenterX;
    pawnCenterY = pawnCenterY;
    identity = identity;
    direction = direction;
    timestamp = timestamp;
  };

  // function
  public void showPerson(float pawnCenterX, float pawnCenterY, float identity, float direction) { // xp, yp, scale
    pushMatrix();
    scalefactor = map(pawnCenterX, serverDisplayHeight, 0, 2.8f, 0.9f);
    zp = map(pawnCenterX, 0, serverDisplayWidth, 800, 100);
    xp = map(pawnCenterY, 0, serverDisplayHeight, 100, 1800);
    wp = (imagePersonWidth / scalefactor);
    hp = (imagePersonHeight / scalefactor);
    image(person_abstract, xp, zp, wp, hp);
    textSize(20);
    fill(0, 102, 153);
    text(identity, xp, zp);
    //image(smile00, width/2, personLevel, smileWidth/personScaleAdult, smileWidth/personScaleAdult);
    popMatrix();
}

  public void showPawn(float pawnCenterX, float pawnCenterY, float identity, float direction) {
    pushMatrix();
    translate(pawnCenterX + imagePawnWidth/2, pawnCenterY - imagePawnHeight/2);
    rotate(direction + (PI / 2));
    image(pawnVisual, 0, 0, imagePawnWidth, imagePawnHeight);
    textSize(20);
    fill(0, 102, 153);
    text(identity, 10, 70);
    popMatrix();
  }

  public PVector getCenter() {
    float x = pawn_x;
    float y = pawn_y;
    return new PVector(x,y);
  }

  public void becomePerson(Person other) {
    pawn_x = other.pawn_x;
    pawn_y = other.pawn_y;
    pawn_polarity = other.pawn_polarity;
    pawn_intensity = other.pawn_intensity;
    taken = other.taken;
  }

  public void giveIdentity() {
    if (pawn_polarity == 0) {
      if (pawn_intensity >0 && pawn_intensity <= 10 ) { identity = 1; }
      else if (pawn_intensity > 10 && pawn_intensity <= 15 ){ identity = 2; }
      else if (pawn_intensity > 15 && pawn_intensity <= 30 ){ identity = 3; }
      else if (pawn_intensity > 30 && pawn_intensity <= 40 ){ identity = 4; }
      else if (pawn_intensity > 40 && pawn_intensity <= 50 ){ identity = 5; }
    } else if (pawn_polarity == 1) {
      if (pawn_intensity >0 && pawn_intensity <= 4 ) { identity = 49; }
      else if (pawn_intensity > 4 && pawn_intensity <= 7 ){ identity = 50; }
      else if (pawn_intensity > 7 && pawn_intensity <= 10 ){ identity = 51; }
      else if (pawn_intensity > 10 && pawn_intensity <= 15 ){ identity = 52; }
      else if (pawn_intensity > 15 && pawn_intensity <= 30 ){ identity = 53; }
      else if (pawn_intensity > 30 && pawn_intensity <= 40 ){ identity = 54; }
      else if (pawn_intensity > 40 && pawn_intensity <= 50 ){ identity = 55; }
    } else { identity = 00; }
  }

  // void getPawnCenter(){
  //   float x1;
  //   float y1;
  //   float x2;
  //   float y2;
  //   // for (Person cp1 : boardPawns) {
  //   for (int i = 0; i < (boardPawns.size()); i++){
  //     Person cp0 = boardPawns.get(i);
  //
  //     if (cp0.pawn_polarity == 0){
  //       float recordDC = 500;
  //       Person matchedCenter = null;
  //       // for (Person cp2 : boardPawns) {
  //       for (int j = 0; j < (boardPawns.size()); j++){
  //         Person cp1 = boardPawns.get(j);
  //         if (cp1.pawn_polarity == 1){
  //           PVector center0 = cp0.getCenter();
  //           PVector center1 = cp1.getCenter();
  //           float dc = PVector.dist(center0, center1);
  //           if (dc < recordDC && !cp1.takenCenter ) {
  //             recordDC = dc;
  //             matchedCenter = cp1;
  //           }
  //           if (matchedCenter != null) {
  //             matchedCenter.takenCenter = true;
  //             x1 = cp0.pawn_x;
  //             y1 = cp0.pawn_y;
  //             x2 = matchedCenter.pawn_x;
  //             y2 = matchedCenter.pawn_y;
  //             matchedCenter.pawnCenterX = (x1 + x2) /2;
  //             matchedCenter.pawnCenterY = (y1 + y2) /2;
  //             // calculate the direction of the pawn by the angle between the two magnets of the pawn
  //             float degree = atan2( (y2 - y1) , (x2 - x1));
  //             matchedCenter.direction = degree; //radians(degree);
  //             cp0.becomePawnCenter(matchedCenter);
  //           }
  //         }
  //       }
  //       // println(pawnCentreX + pawnCentreY);
  //       // if (matchedCenter != null) {
  //       //   matchedCenter.takenCenter = true;
  //       //   x1 = cp1.pawn_x;
  //       //   y1 = cp1.pawn_y;
  //       //   x2 = matchedCenter.pawn_x;
  //       //   y2 = matchedCenter.pawn_y;
  //       //   matchedCenter.pawnCenterX = (x1 + x2) /2;
  //       //   matchedCenter.pawnCenterY = (y1 + y2) /2;
  //       //   // calculate the direction of the pawn by the angle between the two magnets of the pawn
  //       //   float degree = atan2( (y2 - y1) , (x2 - x1));
  //       //   matchedCenter.direction = degree; //radians(degree);
  //       //   cp1.becomePawnCenter(matchedCenter);
  //       // }
  //     }
  //   }
  // }

  public void becomePawnCenter(Person other) {
    pawnCenterX = other.pawnCenterX;
    pawnCenterY = other.pawnCenterY;
    direction = other.direction;
  }

  public void becomeJSONObject() {
    pawn.setFloat("pawn_x", pawn_x); //0
    pawn.setFloat("pawn_y", pawn_y); //1
    pawn.setFloat("pawn_polarity", pawn_polarity); //2
    pawn.setFloat("pawn_intensity", pawn_intensity); //3
    pawn.setFloat("pawnCenterX", pawnCenterX); //4
    pawn.setFloat("pawnCenterY", pawnCenterY); //5
    pawn.setFloat("identity", identity); //6
    pawn.setFloat("direction", direction); //7
    pawn.setFloat("timestamp", millis());
    pawn.setBoolean("showed", false);
  };

  public void addJSONArray(JSONObject pawn) {
    int i;
    if (pawn == null) {
        println("JSONObject could not be parsed");
    } else {
      if (pawnsOnDigiboard.size() == 0) {
        i = 0;
      } else { i = (pawnsOnDigiboard.size()+1);};
      // println(pawnsOnDigiboard.size());
      pawnsOnDigiboard.setJSONObject(i, pawn);
        println(pawnsOnDigiboard);
        println("size: " + pawnsOnDigiboard.size());
    }
  };

} //class Person
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SatisactionPerceptionBoard" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
