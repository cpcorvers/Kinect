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
int thld = 3; //Unit: Gauss
boolean horizontalGrid = true;

// background images
PImage perspectives;
PImage perspectives2;
String[] bg = {"perspective1.png", "perspective2.png", "perspective3.png", "perspective4.png", "perspective5.png", "perspective6.png", "perspective7.png" };
int bgIndex = 0;

Tramontana t1;
String device01 = "10.0.1.14";

//INIT SECOND SCREEN / SERVER CLIENT
int port = 12000;
Server s;
Client c;
String input;
String newInput;
int data[];

//void preload() {
//  perspectives = loadImage("27.png");
//}


/********************
 *
 * SETUP FUNCTION
 *
 *******************/
void setup() {
  size(1281, 801);
  //frameRate(20);
  String img = bg[bgIndex];
  perspectives = loadImage(img);
  //perspectives2 = loadImage("27.png");

  // START THE SERVER
  //s = new Server(this, port); // Start a simple server on a port, uncomment when on sercer system
  //c = new Client(this, "10.0.1.3", port); // uncomment when on client system
}
/********************
 *
 * DRAW FUNCTION
 *
 *******************/

void draw() {
  background(125);
  //image(perspectives, 0, 0, 400, 300);
  fill(250, 0, 0);
  ellipse(100, 100, 100, 150);

  //float scaleX = 1.4900; //1.373 //width of screen
  //float scaleY = 1.550; //1.350 //height of screen 
  //float offsetX = 10; // 76;
  //float offsetY = 10; // 65;
  //pushMatrix();
  //translate(offsetX, offsetY);
  //scale(scaleX, scaleY);
  //if (showContour) { 
  //  //Set and draw the upsampled contour map
  //  gsMeta.drawUpsampledContourMap2D(1280, 640, upsampleFactor, thld);
  //  //gsMeta.drawUpsampledContourMap2D(1280, 640, 50, upsampleFactor, thld);
  //} else { 
  //  //Set but don't draw the upsampled contour map
  //  gsMeta.setUpsampledContourMap2D(1280, 640, upsampleFactor, thld);
  //}

  //pushStyle();
  //noStroke();
  //ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);
  //for (int i=0; i<bGaussBitsList.size(); i++) {
  //  GData bGaussBits = bGaussBitsList.get(i);
  //  //printPointData(bGaussBits, i);
  //  //sendPointData(bGaussBits, i);
  //  ellipseMode(CENTER);
  //}
  //popStyle();
  //fill(0, 0, 0);
  //gsMeta.drawBasicGaussBits();
  ////t1.showImage("perspective5.png");
  //t1.showImage(bg[bgIndex]);
  //t.playVideo("https://www.youtube.com/watch?v=x3KTCXundFo");

  //image(, 100, 100, 50, 100);


  //popMatrix();
  //image(perspectives, 100, 100, 50, 100);
  //receiveDataServer(); //uncomment for server system
  //receiveDataClient(); //uncomment for client system
}
