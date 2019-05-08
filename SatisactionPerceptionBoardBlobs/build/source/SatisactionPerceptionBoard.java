import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import gausstoys.core.*; 
import tramontana.library.*; 
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
 *
 * IMPORT
 *
 *******************/







/********************
 *
 * INIT
 *
 *******************/

GaussSense gsMeta;
GaussSense[] gs = new GaussSense[2];
boolean showContour = true;
boolean testBoard = false;
int thld = 5; //Unit: Gauss
boolean horizontalGrid = true;

// background images
PImage playingfield;
String[] bg = {"playingfield1.png", "playingfield2.png", "playingfield3.png", "playingfield4.png" };
int bgIndex = 0;

// init tramontan
Tramontana t1;
String device01 = "10.0.1.14";

// INIT SECOND SCREEN / SERVER CLIENT
Server s;
Client c;
String input;
String newInput;
int data[];
int port = 12000;

// TEST WITH BITS blobs
ArrayList<Bit> currentBits = new ArrayList<Bit>();



/********************
 *
 * SETUP FUNCTION
 *
 *******************/
public void setup() {
  // START THE SERVER
  s = new Server(this, port); // Start a simple server on a port

  /* Start the connection with Tramontana iOS/AppleTV/Android */
  /* Look on your device for the ipAddress, it shows on the starting panel when you open the app */
  t1 = new Tramontana(this, device01);
  //t.setColor(255,128,128,255);

  
  //size(1281, 801);
  frameRate(20);
  println(bg[bgIndex]);
  playingfield = loadImage(bg[bgIndex]);

  // List all serial ports
  //GaussSense.printSerialPortList();

  //Initialize the GaussSense
  for (int i = 0; i < 2; i ++) {
    gs[i] = new GaussSense(this, GaussSense.GSType.GAUSSSENSE_BASIC, Serial.list()[Serial.list().length - (i+1)], 115200);
    gs[i].setCalibrationFileName("BASIC-"+i+".data");
  }
  gsMeta = new GaussSense(this, GaussSense.GSType.GAUSSSENSE_BASIC, 2, 1);
}

/********************
 *
 * DRAW FUNCTION
 *
 *******************/

public void draw() {
  background(250);
  pushMatrix();
  translate(displayWidth, 0);
  rotate (PI/2);
  image(playingfield, 0, 0, displayHeight, displayWidth );

  // Bit.clear();

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
      //if (s == 3) gsMeta.set(gs[i], 1, 0, 1, true, false);
      //if (s == 4) gsMeta.set(gs[i], 0, 0, 1, false, true);
    }
  }

  float scaleX = 1.4900f; //1.373 //width of screen
  float scaleY = 1.550f; //1.350 //hight of screen
  float offsetX = 10; // 76;
  float offsetY = 10; // 65;
  pushMatrix();
  translate(offsetX, offsetY);
  scale(scaleX, scaleY);
  if (showContour) {
    //Set and draw the upsampled contour map
    gsMeta.drawUpsampledContourMap2D(1280, 640, upsampleFactor, thld);
    //playing around with draw
    gsMeta.drawBasicBipolarMidpoint(thld); //added to play with drawings
    gsMeta.drawBasicBipolarPoints(thld); //added to play with drawings
  } else {
    //Set but don't draw the upsampled contour map
    gsMeta.setUpsampledContourMap2D(1280, 640, upsampleFactor, thld);
  }

  pushStyle();
  noStroke();

  ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);
  for (int i=0; i<bGaussBitsList.size(); i++) {
   GData bGaussBits = bGaussBitsList.get(i);
   printPointData(bGaussBits, i);
   sendPointData(bGaussBits, i);
   bitsInArray(bGaussBits, i);
   ellipseMode(CENTER);
  }

  popStyle();
  fill(0, 0, 0);
  gsMeta.drawBasicGaussBits();
  //t1.showImage("perspective5.png");
  // t1.showImage(bg[bgIndex]);
  //t.playVideo("https://www.youtube.com/watch?v=x3KTCXundFo");
  //image(perspectives, 100, 100, 50, 100);


  popMatrix();

  receiveDataServer(); //uncomment for server system
  //receiveDataClient(); //uncomment for client system
}
// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/r0lvsMPGEoY

class Bit {

  float threshold = 40;
  float distThreshold = 50;


  float minx;
  float miny;
  float maxx;
  float maxy;

  int id = 0;

  boolean taken = false;

  Bit(float x, float y) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
  }

  public void show() {
    stroke(0);
    fill(255, 100);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minx, miny, maxx, maxy);

    textAlign(CENTER);
    textSize(64);
    fill(0);
    text(id, minx + (maxx-minx)*0.5f, maxy - 10);
  }


  public void add(float x, float y) {
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
  }

  public void become(Bit other) {
    minx = other.minx;
    maxx = other.maxx;
    miny = other.miny;
    maxy = other.maxy;
  }

  public float size() {
    return (maxx-minx)*(maxy-miny);
  }

  public PVector getCenter() {
    float x = (maxx - minx)* 0.5f + minx;
    float y = (maxy - miny)* 0.5f + miny;
    return new PVector(x,y);
  }

  public boolean isNear(float x, float y) {

    float cx = max(min(x, maxx), minx);
    float cy = max(min(y, maxy), miny);
    float d = distSq(cx, cy, x, y);

    if (d < distThreshold*distThreshold) {
      return true;
    } else {
      return false;
    }
  }
  public float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}


public float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}
}
// snapshot of board with characters (e.g. GausseSense with GausseBits) into ArrayCurrentState
// compare the snapshot with ArrayHistoryState
// Prevent movement on small instability of GausseSense: If change is within 5.0px then no change otherwise add new state to ArrayHistoryState
// Create dataset/Array of movements of Bits on the Sense
// Create improvement of data exchange over client/server
public void bitsInArray(GData g, int i) {
  println("bitsInArray started");




  ArrayList<Bit> currentBits = new ArrayList<Bit>();

  // int[] currentGaussBitsList = new int[5];

  ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);//API Demos
  int polarityInt = g.getPolarity(); //Get the polarity in Int. 0: North, 1:South
  int intensity = (int) g.getIntensity(); //Get the intensity. Unit: gauss
  int x = (int) g.getX(); //Get the X coordinate on the display
  int y = (int) g.getY(); //Get the Y coordinate on the display
  // String polarityString = (polarityInt==0 ? "North" : "South" );
  for (int j=0; j<bGaussBitsList.size(); j++) {
    GData bGaussBits = bGaussBitsList.get(j);
    if (intensity>0) {
      // s.write( j + " " + polarityString + " " + (int)intensity + " " + x + " " + y +  " " + ((int)bGaussBits.x*1.5) + " " +((int)bGaussBits.y*1.6875) + "\n" );
      boolean found = false;
      for (Bit b : currentBits) {
        if (b.isNear(x,y)) {
          b.add(x, y); //, intensity, polarityInt);
          found = true;
          break;
        }
      }
      if (!found) {
        Bit b = new Bit(x,y);
        currentBits.add(b);
      }
    }
  } // identification - polarity - intensity - x - y - dispX - dispY
for (Bit b: currentBits) {
  b.show();
}


  println("bitsInArray finished");
  // printArray(currentBitsList);

}

//
//
//
//
//   ArrayList<GData> currentGaussBitsList = new ArrayList<GData>();
//   ArrayList<GData> historyGaussBitsList = new ArrayList<GData>();
//
//
//
// }
//
// //printPointData
//   ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);//API Demos
//   int polarityInt = g.getPolarity(); //Get the polarity in Int. 0: North, 1:South
//   int intensity = (int) g.getIntensity(); //Get the intensity. Unit: gauss
//   int x = (int) g.getX(); //Get the X coordinate on the display
//   int y = (int) g.getY(); //Get the Y coordinate on the display
//   String polarityString = (polarityInt==0 ? "North" : "South" );
//   for (int j=0; j<bGaussBitsList.size(); j++) {
//     GData bGaussBits = bGaussBitsList.get(j);
//     //if (intensity>0) println(i+":"+polarityString +", BasicGaussBits: ~ " + (int)intensity + " gauss, (x,y)= ("+x+","+y+")" + "(x,y) = "+ ((int)bGaussBits.x*1.5) + "," +((int)bGaussBits.y*1.6875) );
//   }
// // end printPointData
//
//
//   // There are no blobs!
//   if (blobs.isEmpty() && currentBlobs.size() > 0) {
//     println("Adding blobs!");
//     for (Blob b : currentBlobs) {
//       b.id = blobCounter;
//       blobs.add(b);
//       blobCounter++;
//     }
//   } else if (blobs.size() <= currentBlobs.size()) {
//     // Match whatever blobs you can match
//     for (Blob b : blobs) {
//       float recordD = 1000;
//       Blob matched = null;
//       for (Blob cb : currentBlobs) {
//         PVector centerB = b.getCenter();
//         PVector centerCB = cb.getCenter();
//         float d = PVector.dist(centerB, centerCB);
//         if (d < recordD && !cb.taken) {
//           recordD = d;
//           matched = cb;
//         }
//       }
//       matched.taken = true;
//       b.become(matched);
//     }
//
//     // Whatever is leftover make new blobs
//     for (Blob b : currentBlobs) {
//       if (!b.taken) {
//         b.id = blobCounter;
//         blobs.add(b);
//         blobCounter++;
//       }
//     }
//   } else if (blobs.size() > currentBlobs.size()) {
//     for (Blob b : blobs) {
//       b.taken = false;
//     }
//
//
//     // Match whatever blobs you can match
//     for (Blob cb : currentBlobs) {
//       float recordD = 1000;
//       Blob matched = null;
//       for (Blob b : blobs) {
//         PVector centerB = b.getCenter();
//         PVector centerCB = cb.getCenter();
//         float d = PVector.dist(centerB, centerCB);
//         if (d < recordD && !b.taken) {
//           recordD = d;
//           matched = b;
//         }
//       }
//       if (matched != null) {
//         matched.taken = true;
//         matched.become(cb);
//       }
//     }
//
//     for (int i = blobs.size() - 1; i >= 0; i--) {
//       Blob b = blobs.get(i);
//       if (!b.taken) {
//         blobs.remove(i);
//       }
//     }
//   }
//
//   for (Blob b : blobs) {
//     b.show();
//   }
public void keyPressed() {
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
public void printPointData(GData g, int i) {
  ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);//API Demos
  int polarityInt = g.getPolarity(); //Get the polarity in Int. 0: North, 1:South
  int intensity = (int) g.getIntensity(); //Get the intensity. Unit: gauss
  int x = (int) g.getX(); //Get the X coordinate on the display
  int y = (int) g.getY(); //Get the Y coordinate on the display
  String polarityString = (polarityInt==0 ? "North" : "South" );
  for (int j=0; j<bGaussBitsList.size(); j++) {
    GData bGaussBits = bGaussBitsList.get(j);
    //if (intensity>0) println(i+":"+polarityString +", BasicGaussBits: ~ " + (int)intensity + " gauss, (x,y)= ("+x+","+y+")" + "(x,y) = "+ ((int)bGaussBits.x*1.5) + "," +((int)bGaussBits.y*1.6875) );
  }
}

//void printImageSecondDisplay() {
//  t.showImage("perspective6.png");
//  t.showImage("27.png", 100, 100, 20, 60);
//}
public void sendPointData(GData g, int i) {
  ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);//API Demos
  int polarityInt = g.getPolarity(); //Get the polarity in Int. 0: North, 1:South
  int intensity = (int) g.getIntensity(); //Get the intensity. Unit: gauss
  int x = (int) g.getX(); //Get the X coordinate on the display
  int y = (int) g.getY(); //Get the Y coordinate on the display
  String polarityString = (polarityInt==0 ? "North" : "South" ); 
  for (int j=0; j<bGaussBitsList.size(); j++) {
    GData bGaussBits = bGaussBitsList.get(j);
    if (intensity>0) s.write( i + " " + polarityString + " " + (int)intensity + " " + x + " " + y +  " " + ((int)bGaussBits.x*1.5f) + " " +((int)bGaussBits.y*1.6875f) + "\n" );
  } // identification - polarity - intensity - x - y - dispX - dispY
}

public void receiveDataServer() { //receive data from client on a server
  c = s.available();

  if (c != null) {
    input = c.readString();
    input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    data = PApplet.parseInt(split(input, ' ')); // Split values into an array
    newInput = ("Message: " + input); // Set data in string for textbox
    //dataReceived = (data[0] + data[1] + data[2] + data[3] + data[4] + data[5], data[6]);
  } else if (testBoard == true) {
    int i = 0;
    int x = mouseX;
    int y = mouseY;
    int polarityString = 1;
    int intensity = 30;
    s.write( i + " " + polarityString + " " + (int)intensity + " " + x + " " + y +  " "  + "\n" );
    println( i + " " + polarityString + " " + (int)intensity + " " + x + " " + y +  " "  + "\n" );
  } else {
    newInput = ("no message received");
  }
  //text(newInput, 50, 100, 200, 300);
}

public void receiveDataClient() { //receive data from server on a client
  if (c.available() > 0) {
    input = c.readString();
    input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    data = PApplet.parseInt(split(input, ' ')); // Split values into an array
    newInput = ("Message: " + input); // Set data in string for textbox
    //dataReceived = (data[0] + data[1] + data[2] + data[3] + data[4] + data[5], data[6]);
  } else {
    newInput = ("no message received");
  }
  //text(newInput, 50, 100, 200, 300);
}
  public void settings() {  size(1920, 1080, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SatisactionPerceptionBoard" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
