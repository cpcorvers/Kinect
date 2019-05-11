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

/********************
 *
 * IMPORT
 *
 *******************/


// import gausstoys.core.*;
// import tramontana.library.*;
// import websockets.*;


/********************
 *
 * INIT
 *
 *******************/

// GaussSense gsMeta;
// GaussSense[] gs = new GaussSense[2];
// boolean showContour = true;
// int thld = 5; //Unit: Gauss
// boolean horizontalGrid = true;

// background images
PImage perspectives;
//PImage perspectives2;
//String[] bg = {"perspective1.png", "perspective2.png", "perspective3.png", "perspective4.png", "perspective5.png", "perspective6.png", "perspective7.png" };
//String[] bg = {"perspective1.png", "perspective2.png"};
int bgIndex = 0;
PImage bgImage;

// other images
// PImage house;
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

PVector person;

// Tramontana t1;
// String device01 = "10.0.1.14";

//INIT SECOND SCREEN / SERVER CLIENT
int port = 3030;
// Server s;
Client c;
String input;
// String input2;
String newInput;
int data[];
// int dispX;
// int dispY;
int personCounter = 0;

ArrayList<Person> boardPersons;
ArrayList<Person> screenPersons;
ArrayList<Person> historyPersons;

/********************
 *
 * SETUP FUNCTION
 *
 *******************/
public void setup() {
  
  //frameRate(60);
  bgImage = loadImage("perspective1.png");
  //perspectives = loadImage(bg[bgIndex]);
  person_abstract = loadImage("27.png");
  // smile00 = loadImage("34.png");
  // smile01 = loadImage("29.png");
  // smile02 = loadImage("30.png");
  // smile03 = loadImage("31.png");
  // smile04 = loadImage("32.png");
  // smile05 = loadImage("33.png");

  // START THE SERVER OR CLIENT
  //s = new Server(this, port); // Start a simple server on a port, uncomment when on sercer system
  c = new Client(this, "10.0.1.3", port); // uncomment when on client system

  // c = new Client(this, "127.0.0.1", port); // uncomment when on client system

  boardPersons = new ArrayList<Person>();
  screenPersons = new ArrayList<Person>();
  historyPersons = new ArrayList<Person>();
}
/********************
 *
 * DRAW FUNCTION
 *
 *******************/

public void draw() {
  //background(perspectives);
  background(bgImage);
  fill(0, 0, 250);
  receiveDataClient(); // get data from server into data[ identification - polarity - intensity - x - y - xx - yy ]
  secondScreenInteraction();
  // for (Person p : screenPersons){
  //   p.show();
  // };
  // // for (Person p : boardPersons){
  //   p.show();
  // };
  // for (Person p : historyPersons){
  //   p.show();
  // };
}
class Person { // class

  // data:

  float xp;  // width of the perspective
  float zp;  // depth of the perspective
  float scalefactor; //variable to create a 3D perspective in 2D rendering of the person image
  float wp;
  float hp;
  PImage person_abstract = loadImage("27.png");

  int serverDisplayWidth = 1920;
  int serverDisplayHeight = 1080;
  int imagePersonWidth = 177; //width of the .png image
  int imagePersonHeight = 408; //height of the .png image

  float identity;
  float polarity;
  float intensity;
  float pawn_x;
  float pawn_y;
  float pawn_ID;
  boolean taken = false;

  //displaysize second screen: 1281, 801

  // constructors:
  Person(float x, float y) {
    // locationP = (dispX + dispY);
    // float identity;
    // float polarity;
    // float intensity;
    pawn_x = x;
    pawn_y = y;
    // pawn_ID = 88;
  };
  Person(float x, float y, float id) {
    pawn_x = x;
    pawn_y = y;
    pawn_ID = id;
  };
  // Person() {
  //     pawn_x = x;
  //     pawn_y = y;
  //     pawn_ID = id;
  // };

  // function
  public void show() { // xp, yp, scale
    scalefactor = map(pawn_x, serverDisplayHeight, 0, 2.8f, 0.9f);
    zp = map(pawn_x, 0, serverDisplayWidth, 800, 100);
    xp = map(pawn_y, 0, serverDisplayHeight, 100, 1800);
    wp = (imagePersonWidth / scalefactor);
    hp = (imagePersonHeight / scalefactor);

    image(person_abstract, xp, zp, wp, hp);

    textSize(20);
    fill(0, 102, 153);
    text(pawn_ID, xp, zp);
    //image(smile00, width/2, personLevel, smileWidth/personScaleAdult, smileWidth/personScaleAdult);
  }


  // function
  // void showPerson(float pawn_y, float pawn_x) { // xp, yp, scale
  //   scalefactor = map(pawn_y, serverDisplayHeight, 0, 2.8, 0.9);
  //   xp = map(pawn_x, 0, serverDisplayHeight, 0, 1280);
  //   zp = map(pawn_y, 0, serverDisplayHeight, 800, 200);
  //   wp = (imagePersonWidth / scalefactor);
  //   hp = (imagePersonHeight / scalefactor);
  //
  //   image(person_abstract, xp, zp, wp, hp);
  //   //image(smile00, width/2, personLevel, smileWidth/personScaleAdult, smileWidth/personScaleAdult);
  // }

  // void addPerson(float x, float y) {
  //
  //   // minx = min(minx, x);
  //   // miny = min(miny, y);
  //   // maxx = max(maxx, x);
  //   // maxy = max(maxy, y);
  // }

  public PVector getCenter() {
    float x = pawn_x;
    float y = pawn_y;
    return new PVector(x,y);
  }

  public void becomePerson(Person other) {
    pawn_x = other.pawn_x;
    pawn_y = other.pawn_y;
    pawn_ID = other.pawn_ID;
    // taken = true;
  }
  //
  // boolean isNear(float x, float y) {
  //
  //   float cx = max(min(x, maxx), minx);
  //   float cy = max(min(y, maxy), miny);
  //   float d = distSq(cx, cy, x, y);
  //
  //   if (d < distThreshold*distThreshold) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  /*
    int personWidth = 89;
   int personHeight = 205;
   int personScaleAdult = 1;
   int personScaleYoungAdult = 2;
   int personScaleKid = 3;
   int personLevel = 370;
   int smileWidth = 123/2;
   image(person_abstract, width/2, personLevel, personWidth/personScaleAdult, personHeight/personScaleAdult);
   image(smile00, width/2, personLevel, smileWidth/personScaleAdult, smileWidth/personScaleAdult);
   }
   */
}
//void keyPressed() {
//  // if (key == 'd') t1.takePictureWithUI(0);
//  /***********
//   *
//   * CHANGING BACKGROUND SECOND SCREEN WITH O AND P KEYPRESS
//   *
//   ***************/

//  if (key == 'o') {
//    if (bgIndex > 0) {
//      bgIndex-- ;
//    } else {
//      bgIndex = bg.length-1;
//    }
//    //t1.showImage(bg[bgIndex]);
//    perspectives = loadImage(bg[bgIndex]);
//  } else if (key == 'p') {
//    if (bgIndex < (bg.length-1)) {
//      bgIndex++ ;
//    } else {
//      bgIndex = 0;
//    }
//    //t1.showImage(bg[bgIndex]);
//    perspectives = loadImage(bg[bgIndex]);
//  }
//}
// (historyPersons) boardPersons is the RealTime Arraylist from the PerceptionBoard
// (currentPersons) screenPersons is the NearRealTime Arraylist for the SecondScreen
// historyPersons is the OldTime or Backup Arraylist for logbook purpose

// A pawn on the PerceptionBoard becomes:
// 1. a RealTime visual on the board screen ;
// 2. a NearRealTime visual on the second screen ;
// 3. a History item in the logbook .

// ArrayList<Person> currentPersons = new ArrayList<Person>();

// There are pawns but no visuals on the screen!

public void secondScreenInteraction() {
  if (screenPersons.isEmpty() && boardPersons.size() > 0) {
    // println("Adding persons!");
    for (Person p : boardPersons) {
      p.pawn_ID = personCounter;
      screenPersons.add(p);
      personCounter++;
    }
  // There are equal or more pawns on the board as screen visuals!
  } else if (screenPersons.size() <= boardPersons.size()) {
    // Match whatever blobs you can match
    for (Person p : screenPersons) {
      float recordD = 1000;
      Person matched = null;
      for (Person cp : boardPersons) {
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
  } else if (screenPersons.size() > boardPersons.size()) {
    for (Person p : screenPersons) {
      p.taken = false;
    }
    // Match whatever blobs you can match
    for (Person cp : boardPersons) {
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

  for (Person p : screenPersons){
    p.show();
  }
  // for (Person p : boardPersons){
  //   p.show();
  // };
  // for (Person p : historyPersons){
  //   p.show();
  // };

  if (screenPersons.size() > 1000) {
    for (int i = screenPersons.size() - 1; i >= 0; i--) {
      Person p = screenPersons.get(i);
      if (!p.taken) {
        screenPersons.remove(i);
      }
    }
    for (int i = boardPersons.size() - 1; i >= 0; i--) {
      Person p = boardPersons.get(i);
      if (!p.taken) {
        boardPersons.remove(i);
      }
    }
  }
}
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
  public void settings() {  size(1280, 800, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SatisactionPerceptionSecondScreen" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
