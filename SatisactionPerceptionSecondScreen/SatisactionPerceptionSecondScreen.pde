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
int thld = 5; //Unit: Gauss
boolean horizontalGrid = true;

// background images
PImage perspectives;
//PImage perspectives2;
//String[] bg = {"perspective1.png", "perspective2.png", "perspective3.png", "perspective4.png", "perspective5.png", "perspective6.png", "perspective7.png" };
//String[] bg = {"perspective1.png", "perspective2.png"};
int bgIndex = 0;
PImage bgImage;

// other images
PImage house;
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
Server s;
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
void setup() {
  size(1280, 800, P2D);
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

void draw() {
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
