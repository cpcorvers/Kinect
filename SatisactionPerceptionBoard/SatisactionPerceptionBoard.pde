/********************
 *
 * IMPORT GAUSSE SENSE
 *
 *******************/

import processing.serial.*;
import gausstoys.core.*;

/********************
 *
 * IMPORT TRAMONTAN
 *
 *******************/
/****
 Tramontana for Processing
 Tramontana is a tool for interactive spaces. It communicates with iOS devices. You can download the app here: https://itunes.apple.com/us/app/tramontana/id1121069555?mt=8
 made by Pierluigi Dalla Rosa
 
 B_ChangeColor
 With this sketch you can change the color of your device. 
 
 Don't forget to change the ipAddress below (192.168.1.17) to match the one visible on your device when you open the app.
 ***/

///IMPORT TRAMONTANA
import tramontana.library.*;

///Tramontana needs websockets that can be found at:
///https://github.com/alexandrainst/processing_websockets
import websockets.*;

/********************
 *
 * IMPORT SERVER CLIENT STUFF
 *
 *******************/
 
 import processing.net.*;

 
 
 /********************
 *
 * INIT GAUSSE SENSE
 *
 *******************/

GaussSense gsMeta;
GaussSense[] gs = new GaussSense[2];
boolean showContour = true;
int thld = 3; //Unit: Gauss
boolean horizontalGrid = true;

//// Play with tags
//boolean isTagOn() =true;
//int[] getTagID();

// background images
PImage perspectives;
String[] bg = {"perspective1.png", "perspective2.png", "perspective3.png", "perspective4.png", "perspective5.png", "perspective6.png", "perspective7.png" };
int bgIndex = 0;


/********************
 *
 * INIT TRAMONTAN
 *
 *******************/
/* Create an instance of Tramonana */
Tramontana t1;
String device01 = "10.0.1.14";

/********************
 *
 * INIT SECOND SCREEN / SERVER CLIENT
 *
 *******************/
Server s;
Client c;
String input;
String newInput;
int data[];

int port = 12000;

void preload() {
  perspectives = loadImage("27.png");
}


/********************
 *
 * SETUP FUNCTION
 *
 *******************/
void setup() {

  //size(480, 240);
  // START THE SERVER
  s = new Server(this, port); // Start a simple server on a port


  /* Start the connection with Tramontana iOS/AppleTV/Android */
  /* Look on your device for the ipAddress, it shows on the starting panel when you open the app */
  t1 = new Tramontana(this, device01);
  //t.setColor(255,128,128,255);

  size(1920, 1080);
  frameRate(20);
  //perspectives = loadImage("27.png");

  // List all serial ports
  GaussSense.printSerialPortList();

  //// try multi display settings
  //  GraphicsEnvironment ge = GraphicsEnvironment.
  // getLocalGraphicsEnvironment();
  // GraphicsDevice[] gs = ge.getScreenDevices();


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
  fill(250, 0, 0);
  ellipse( 100, 100, 100, 150);
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
    //gsMeta.drawUpsampledContourMap2D(1280, 640, 50, upsampleFactor, thld);
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
    ellipseMode(CENTER);
  }
  popStyle();
  fill(0, 0, 0);
  gsMeta.drawBasicGaussBits();
  //t1.showImage("perspective5.png");
  t1.showImage(bg[bgIndex]);
  //t.playVideo("https://www.youtube.com/watch?v=x3KTCXundFo");
  //image(perspectives, 100, 100, 50, 100);
  

  popMatrix();
  
  //playing around with draw
  //gsMeta.drawBasicBipolarMidpoint(0, 75); //added to play with drawings
  //gsMeta.drawBasicBipolarPoints(0,50); //added to play with drawings
  //gsMeta.drawTiltableGaussBitsWithAreas(100,100,100); //added to play with drawings
  //gsMeta.drawBasicNorthPoint();
  
  
  
  receiveDataServer(); //uncomment for server system
  //receiveDataClient(); //uncomment for client system
  
    
}
