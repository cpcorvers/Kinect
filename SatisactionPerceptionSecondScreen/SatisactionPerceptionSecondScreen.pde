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

// other images
PImage house;
PImage person_abstract;
PImage smile00;
PImage smile01;
PImage smile02;
PImage smile03;
PImage smile04;
PImage smile05;

Person p;
float pawn_x;
float pawn_y; 
float pawn_ID;

Tramontana t1;
String device01 = "10.0.1.14";

//INIT SECOND SCREEN / SERVER CLIENT
int port = 12000;
Server s;
Client c;
String input;
String newInput;
int data[];

/********************
 *
 * SETUP FUNCTION
 *
 *******************/
void setup() {
  size(1281, 801, P2D);
  //frameRate(20);

  perspectives = loadImage(bg[bgIndex]);
  person_abstract = loadImage("27.png");
  smile00 = loadImage("34.png");
  smile01 = loadImage("29.png");
  smile02 = loadImage("30.png");
  smile03 = loadImage("31.png");
  smile04 = loadImage("32.png");
  smile05 = loadImage("33.png");

  // START THE SERVER OR CLIENT
  //s = new Server(this, port); // Start a simple server on a port, uncomment when on sercer system
  c = new Client(this, "10.0.1.3", port); // uncomment when on client system
  p = new Person();
}
/********************
 *
 * DRAW FUNCTION
 *
 *******************/

void draw() {
  background(perspectives);
  fill(0, 0, 250);
  receiveDataClient(); // get data from server into data[]
  int dispX = data[3]; // load data[3] = x coordinate of pawn on gausseSense 
  int dispY = data[4]; // load data[4] = x coordinate of pawn on gausseSense
  //println(dispX +", " + dispY);
  p.showPerson(dispX, dispY); //show a person with the person class on the second screen in other perspective

  pushStyle();
  fill(250, 0, 0);
  ellipse(100, 100, 100, 150);
  popStyle();
  
}
