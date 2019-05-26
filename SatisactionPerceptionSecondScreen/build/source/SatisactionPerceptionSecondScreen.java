import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SatisactionPerceptionSecondScreen extends PApplet {

// Raspberry Pi Model 3B+
// OS Raspbian
// App Processing 3 for Pi
// 10.1" LCD-TFT Touch screen




// Init  images
PImage perspectives;
String[] bg = {"perspective1.png",  "perspective3.png", "perspective4.png", "perspective5.png", "perspective6.png", "perspective7.png" };
int bgIndex = 0;
PImage person_abstract;
// PImage smile00;
// PImage smile01;
// PImage smile02;
// PImage smile03;
// PImage smile04;
// PImage smile05;

Person p;
// float pawn_x;
// float pawn_y;
// float pawn_ID;

float dispX;
float dispY;

//PVector person;

//INIT SECOND SCREEN / SERVER CLIENT
int port = 3030;
Client c;
String input;
String newInput;
int data[];
int personCounter = 0;

int secondScreen = 2;

ArrayList<Person> boardPawns;
ArrayList<Person> screenPersons;
ArrayList<Person> historyPersons;

int  x;
int  y;






int secondScreenWidthMin = 0;
int secondScreenWidthMax = 1280;
int secondScreenHeightMin = 0;
int secondScreenHeightMax = 800;

int boardScreenWidthMin = 0;
int boardScreenWidthMax = 1920;
int boardScreenHeightMin = 0;
int boardScreenHeightMax = 1080;

int imagePersonWidth = 177; //width of the .png image
int imagePersonHeight = 408; //height of the .png image






JSONArray pawnsOnDigiboard;
JSONObject pawn;

float time0 = 1000;

public void settings() {
  fullScreen(P2D, secondScreen);
}

public void setup() {
  // START THE SERVER OR CLIENT
  // c = new Client(this, "10.0.1.3", port);
  //c = new Client(this, "10.0.1.4", port);

  // size(1280, 800, P2D);
  //frameRate(60);
  perspectives = loadImage(bg[bgIndex]);
  person_abstract = loadImage("27.png");
  // smile00 = loadImage("34.png");
  // smile01 = loadImage("29.png");
  // smile02 = loadImage("30.png");
  // smile03 = loadImage("31.png");
  // smile04 = loadImage("32.png");
  // smile05 = loadImage("33.png");


  boardPawns = new ArrayList<Person>();
  screenPersons = new ArrayList<Person>();
  historyPersons = new ArrayList<Person>();

  println("Setup complete");
}

public void draw() {

  background(0);

  pushMatrix();
    image(perspectives, 0, 0, 1280, 800);
  popMatrix();

  pawnsOnDigiboard = loadJSONArray("/Users/PeterMacBookPro/Documents/Coding/Kinect/SatisactionPerceptionBoard/data/data.json");
  // JSONArray pawns = pawnsOnDigiboard.getJSONArray(0);

  getJSONData();

  dataVisualisation();


  // receiveDataClient(); // get data from server into data[ identification - polarity - intensity - x - y - xx - yy ]
  // secondScreenInteraction(); // analyse data and show positions on the second screen
  // if (c.available() > 0) {
    // // for (int i = 0; i < (screenPersons.size()); i++){
    // //   screenPersons.remove(i);
    // // }
    // input = c.readString();
    // println("input String: " + input);
    // String input1 = input.substring(0, input.indexOf("\n")); // Only up to the newline
    // // (input.indexOf("\n")-1)
    // String input2 = input.substring(input.indexOf("\n"), input.indexOf("\n")); // Only up to the newline
    //
    // println("input substring 1: " +input1);
    // println("input substring 2: " +input2);
    //
    // data = int(split(input, ' ')); // Split values into an array
    //  // Data strutcture from server: s.write( p.pawn_x + " " + p.pawn_y + " " + p.pawn_polarity + " " + p.pawnCenterX + " " + p.pawnCenterY + " " + p.identity + " " + p.direction + "\n" );
    //  // println(data);
    //  float pawn_x = parseFloat (data[0]);
    //  float pawn_y = parseFloat (data[1]);
    //  float pawn_polarity = parseFloat (data[2]);
    //  float pawn_intensity = parseFloat (data[3]);
    //  float pawnCenterX = parseFloat (data[4]);
    //  float pawnCenterY = parseFloat (data[5]);
    //  float identity = parseFloat (data[6]);
    //  float direction = parseFloat (data[7]);
    //  screenPersons.add(new Person(pawn_x, pawn_y, pawn_polarity, pawn_intensity, pawnCenterX, pawnCenterY, identity, direction));
    //  // println( pawn_x + " " + pawn_y + " " + pawn_polarity + " " + pawnCenterX + " " + pawnCenterY + " " + identity + " " + direction );
    //  println(pawn_x);

    // // receive input from server
    // input = c.readString();
    // //parse the received data to a JSONobject
    // JSONObject person = parseJSONObject(input);
    // if (input == null) {
    //   println("JSONObject could not be parsed");
    // } else {
    //   println(person);
    //   float pol = person.getFloat("pawn_polarity");
    //   if (pol == 1)
    //   {float x1 = person.getFloat("pawn_x");
    //   float y1 = person.getFloat("pawn_y");
    //   x = int(x1);
    //   y = int(y1);}
    // }

  // }

  // image(person_abstract, x, y, 50, 100);
  // image(perspectives, 0, 0, 1280, 800);
  // if (screenPersons.size() > 0){
  //   for (int i = 0; i < screenPersons.size(); i++) {
  //     Person p = screenPersons.get(i);
  //   // for (Person p : screenPersons){
  //   // p.showPerson(p.pawnCenterX, p.pawnCenterY, p.identity, p.direction);
  //   p.showPawn(p.pawnCenterX, p.pawnCenterY, p.identity, p.direction);
  //     // p.showPawn();
  //     // p.remove();
  //   }
  // }

  // if (boardPawns.size() > 0){
  //   for (int i = 0; i < boardPawns.size(); i++) {
  //     Person p = boardPawns.get(i);
  //   // for (Person p : screenPersons){
  //     p.showPerson(p.pawnCenterX, p.pawnCenterY, p.identity, p.direction);
  //     // p.showPawn();
  //     // p.remove();
  //   }
  // }

  // only for coding and debugging:
  // println(pawnsOnDigiboard);
  println(boardPawns.size() + " " + screenPersons.size() + " " + historyPersons.size());
}

public void getJSONData(){
  for (int i = 0; i < pawnsOnDigiboard.size(); i++) {
    JSONObject pawn = pawnsOnDigiboard.getJSONObject(i);
    // if (pawn != null) {
    //   println("pawn is: " + pawn);
    //   boolean showed = pawn.getBoolean("showed");
    //   if (showed == false){
    float pawn_x =  pawn.getFloat("pawn_x"); //0
    float pawn_y =  pawn.getFloat("pawn_y"); //1
    float pawn_polarity =  pawn.getFloat("pawn_polarity"); //2
    float pawn_intensity =  pawn.getFloat("pawn_intensity"); //3
    float pawnCenterX=  pawn.getFloat("pawnCenterX"); //4
    float pawnCenterY=  pawn.getFloat("pawnCenterY"); //5
    float identity =  pawn.getFloat("identity"); //6
    // float direction =  0; //6
    float direction =  pawn.getFloat("direction"); //7
    float timestamp  =  pawn.getFloat("timestamp");

    // if (timestamp == 3144) {
      // screenPersons.add(new Person(pawn_x, pawn_y, pawn_polarity, pawn_intensity, pawnCenterX, pawnCenterY, identity, direction, timestamp));
    // }

    // boardPawns.add(new Person(pawn_x, pawn_y, pawn_polarity, pawn_intensity, pawnCenterX, pawnCenterY, identity, direction, timestamp));
    screenPersons.add(new Person(pawn_y, pawn_x, pawn_polarity, pawn_intensity, pawnCenterY, pawnCenterX, identity, direction, timestamp));

    // if (screenPersons.size() > boardPawns.size()) {
    //   for (int j = 0; j < (screenPersons.size() - boardPawns.size()); j++){
    //     Person hp = screenPersons.get(i);
    //     screenPersons.remove(i);
    //   }
    // };
  }
  if (boardPawns.size() > 100) {
    for (int i = 0; i < (boardPawns.size() - 100); i++){ boardPawns.remove(i); }
  }
  if (screenPersons.size() > 100) {
    for (int i = 0; i < (screenPersons.size() - 100); i++){ screenPersons.remove(i); }
  }
  if (historyPersons.size() > 100) {
    for (int i = 0; i < (historyPersons.size() - 100); i++){ historyPersons.remove(i); }
  }
}

public void dataVisualisation() {
  // show every person which is taken==true
  // for (Person p : screenPersons) {
  if (screenPersons.size() > 0){
    for (int i=0; i < screenPersons.size(); i++){
      Person p = screenPersons.get(i);
      // p.showPerson(p.pawnCenterX, p.pawnCenterY, p.identity, p.direction);
      pushMatrix();
      // scalefactor = map(pawn_x, secondScreenWidthMax, secondScreenWidthMin, 3, 1);
      float xp = map(p.pawnCenterX, boardScreenHeightMin, boardScreenHeightMax, secondScreenWidthMin+300, secondScreenWidthMax-500);
      float zp = map(p.pawnCenterY, boardScreenWidthMin, boardScreenWidthMax, secondScreenHeightMax-600, secondScreenHeightMin+300);
      // wp = (imagePersonWidth / scalefactor);
      // hp = (imagePersonHeight / scalefactor);
      float wp = (imagePersonWidth / 3);
      float hp = (imagePersonHeight / 3);
      image(person_abstract, xp, zp, wp, hp);
      // image(person_abstract, zp, xp, wp, hp);
      textSize(20);
      fill(0, 102, 153);
      text(p.identity, xp, zp);
      //image(smile00, width/2, personLevel, smileWidth/personScaleAdult, smileWidth/personScaleAdult);
      popMatrix();
      println(xp + "," + zp);

    }
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

  int secondScreenWidthMin = 0;
  int secondScreenWidthMax = 1280;
  int secondScreenHeightMin = 0;
  int secondScreenHeightMax = 800;

  int boardScreenWidthMin = 0;
  int boardScreenWidthMax = 1920;
  int boardScreenHeightMin = 0;
  int boardScreenHeightMax = 1080;

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
  boolean showed;

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
  Person(float x, float y, float polarity, float intensity) {
    pawn_x = x;
    pawn_y = y;
    pawn_polarity = polarity;
    pawn_intensity = intensity;
    giveIdentity();
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
  // void showPerson(float pawnCenterX, float pawnCenterY, float identity, float direction) { // xp, yp, scale
  //   scalefactor = map(pawn_x, serverDisplayHeight, 0, 2.8, 0.9);
  //   zp = map(pawn_x, 0, serverDisplayWidth, 800, 100);
  //   xp = map(pawn_y, 0, serverDisplayHeight, 100, 1800);
  //   wp = (imagePersonWidth / scalefactor);
  //   hp = (imagePersonHeight / scalefactor);
  //   image(person_abstract, xp, zp, wp, hp);
  //   textSize(20);
  //   fill(0, 102, 153);
  //   text(pawn_intensity, xp, zp);
  //   //image(smile00, width/2, personLevel, smileWidth/personScaleAdult, smileWidth/personScaleAdult);
  // }

  // void showPerson(float pawn_x, float pawn_y, float identity, float direction) { // xp, yp, scale
  //   pushMatrix();
  //   scalefactor = map(pawn_x, serverDisplayHeight, 0, 2.8, 0.9);
  //   xp = map(pawn_y, 0, serverDisplayHeight, 100, 1000);
  //   zp = map(pawn_x, 0, serverDisplayWidth, 800, 100);
  //   wp = (imagePersonWidth / scalefactor);
  //   hp = (imagePersonHeight / scalefactor);
  //   // image(person_abstract, xp, zp, wp, hp);
  //   // image(person_abstract, zp, xp, wp, hp);
  //   textSize(20);
  //   fill(0, 102, 153);
  //   text(identity + "testing", zp, xp);
  //   //image(smile00, width/2, personLevel, smileWidth/personScaleAdult, smileWidth/personScaleAdult);
  //   popMatrix();
  // }

  public void showPerson(float pawn_x, float pawn_y, float identity, float direction) { // xp, yp, scale
    pushMatrix();
    scalefactor = map(pawn_x, secondScreenWidthMax, secondScreenWidthMin, 3, 1);
    xp = map(pawn_x, boardScreenHeightMin, boardScreenHeightMax, secondScreenWidthMin+100, secondScreenWidthMax-100);
    zp = map(pawn_y, boardScreenWidthMin, boardScreenWidthMax, secondScreenHeightMax-300, secondScreenHeightMin+100);
    // wp = (imagePersonWidth / scalefactor);
    // hp = (imagePersonHeight / scalefactor);
    wp = (imagePersonWidth / 3);
    hp = (imagePersonHeight / 3);
    image(person_abstract, xp, zp, wp, hp);
    // image(person_abstract, zp, xp, wp, hp);
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
      if (pawn_intensity >0 && pawn_intensity <= 50 ) { identity = 1; }
      else if (pawn_intensity > 50 && pawn_intensity <= 100 ){ identity = 2; }
      else if (pawn_intensity > 100 && pawn_intensity <= 150 ){ identity = 3; }
      else if (pawn_intensity > 150 && pawn_intensity <= 200 ){ identity = 4; }
      else if (pawn_intensity > 200 && pawn_intensity <= 250 ){ identity = 5; }
    } else if (pawn_polarity == 1) {
      if (pawn_intensity >0 && pawn_intensity <= 50 ) { identity = 51; }
      else if (pawn_intensity > 50 && pawn_intensity <= 100 ){ identity = 52; }
      else if (pawn_intensity > 100 && pawn_intensity <= 150 ){ identity = 53; }
      else if (pawn_intensity > 150 && pawn_intensity <= 200 ){ identity = 54; }
      else if (pawn_intensity > 200 && pawn_intensity <= 250 ){ identity = 55; }
    } else { identity = 00; }
  }

  public void getPawnCenter(){
    float x1;
    float y1;
    float x2;
    float y2;
    for (Person cp1 : boardPawns) {
      if (cp1.pawn_polarity == 0){
        float recordDC = 1000;
        Person matchedCenter = null;
        for (Person cp2 : boardPawns) {
          if (cp2.pawn_polarity == 1){
            PVector center0 = cp1.getCenter();
            PVector center1 = cp2.getCenter();
            float dc = PVector.dist(center0, center1);
            if (dc < recordDC && !cp2.takenCenter ) {
              recordDC = dc;
              matchedCenter = cp2;
            }
          }
        }
        // println(pawnCentreX + pawnCentreY);
        if (matchedCenter != null) {
          matchedCenter.takenCenter = true;
          x1 = cp1.pawn_x;
          y1 = cp1.pawn_y;
          x2 = matchedCenter.pawn_x;
          y2 = matchedCenter.pawn_y;
          matchedCenter.pawnCenterX = (x1 + x2) /2;
          matchedCenter.pawnCenterY = (y1 + y2) /2;
          // calculate the direction of the pawn by the angle between the two magnets of the pawn
          float degree = atan2( (y2 - y1) , (x2 - x1));
          matchedCenter.direction = degree; //radians(degree);
          cp1.becomePawnCenter(matchedCenter);
        }
      }
    }
  }

  public void becomePawnCenter(Person other) {
    pawnCenterX = other.pawnCenterX;
    pawnCenterY = other.pawnCenterY;
    direction = other.direction;
    }
} //class Person
public void keyPressed() {
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
    perspectives = loadImage(bg[bgIndex]);
  } else if (key == 'p') {
    if (bgIndex < (bg.length-1)) {
      bgIndex++ ;
    } else {
      bgIndex = 0;
    }
    perspectives = loadImage(bg[bgIndex]);
    
    /*******
    *
    *  STOP THE APPLICATION WIHT S KEYPRESS
    *
    *************/
  } else if (key == 's') {
    exit();
  }
}
// boardPawns is the RealTime Arraylist from the PerceptionBoard
// screenPersons is the NearRealTime Arraylist for the SecondScreen
// historyPersons is the OldTime or Backup Arraylist for logbook purpose

// A pawn on the PerceptionBoard becomes:
// 1. a RealTime visual on the board screen ;
// 2. a NearRealTime visual on the second screen ;
// 3. a History item in the logbook .

// ArrayList<Person> currentPersons = new ArrayList<Person>();

// There are pawns but no visuals on the screen!

public void secondScreenInteraction() {
  if (screenPersons.isEmpty() && boardPawns.size() > 0) {
    // println("Adding persons!");
    for (Person p : boardPawns) {
      p.pawn_ID = personCounter;
      screenPersons.add(p);
      personCounter++;
    }
  // There are equal or more pawns on the board as screen visuals!
  } else if (screenPersons.size() <= boardPawns.size()) {
    // Match whatever blobs you can match
    for (Person p : screenPersons) {
      float recordD = 1000;
      Person matched = null;
      for (Person cp : boardPawns) {
        PVector centerP = p.getCenter();
        PVector centerCP = cp.getCenter();
        float d = PVector.dist(centerP, centerCP);
        // println(d);
        if (d < recordD && !cp.taken) {
          recordD = d;
           matched = cp;
        }
      }
      if (matched != null) {
        matched.taken = true;
        p.becomePerson(matched);
      }
    }
    // There are less pawns on the board as screen visuals!
    // Whatever is leftover make new blobs
    for (Person p : screenPersons) {
      if (!p.taken) {
        p.pawn_ID = personCounter;
        screenPersons.add(p);
        personCounter++;
      }
    }
  } else if (screenPersons.size() > boardPawns.size()) {

    for (Person p : screenPersons) {
      p.taken = false;
    }

    // Match whatever blobs you can match
    for (Person cp : boardPawns) {
      float recordD = 1000;
      Person matched = null;
      for (Person p : screenPersons) {
        PVector centerP = p.getCenter();
        PVector centerCP = cp.getCenter();
        float d = PVector.dist(centerP, centerCP);
        if (d < recordD && !p.taken) {
          recordD = d;
          matched = p;
        }
      }
      if (matched != null) {
        matched.taken = true;
        matched.becomePerson(cp);
      }
    }
    for (int i = screenPersons.size() - 1; i >= 0; i--) {
      Person p = screenPersons.get(i);
      if (!p.taken) {
        screenPersons.remove(i);
      }
    }
  }

  // Avoiding full of memory exeption by restricting the size of the boardPawns ArrayList
  if (boardPawns.size() > 500) {
     println("boardPerson size is above 500");
    boardPawns.remove(0);
  }
  //  if (screenPersons.size() > 500) {
  //   println("boardPerson size is above 1000");
  //  screenPersons.remove(0);
  //}

  // show the person on a location with a background.
  // image(perspectives, 0, 0, 1280, 800);
  // for (Person p : screenPersons){
  //   p.showPerson();
  // }
}
public void receiveDataClient() { //receive data from server on a client
  // if data is send from the GausseSense
  // e.g. if there is a pawn on the board
  // then put data in boardPersons
  // else empty boardPersons
  if (c.available() > 0) {
    input = c.readString();
    input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    data = PApplet.parseInt(split(input, ' ')); // Split values into an array
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SatisactionPerceptionSecondScreen" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
