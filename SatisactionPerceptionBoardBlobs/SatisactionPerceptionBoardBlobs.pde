/********************
 *
 * IMPORT
 *
 *******************/

import processing.serial.*;
import gausstoys.core.*;
import tramontana.library.*;
import websockets.*;
import processing.net.*;

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
void setup() {
  // START THE SERVER
  s = new Server(this, port); // Start a simple server on a port

  /* Start the connection with Tramontana iOS/AppleTV/Android */
  /* Look on your device for the ipAddress, it shows on the starting panel when you open the app */
  t1 = new Tramontana(this, device01);
  //t.setColor(255,128,128,255);

  size(1920, 1080, P2D);
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

void draw() {
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

  float scaleX = 1.4900; //1.373 //width of screen
  float scaleY = 1.550; //1.350 //hight of screen
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
