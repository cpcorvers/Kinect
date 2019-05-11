// Raspberry Pi Model 3B+
// OS Raspbian
// App Processing 3 for Pi
// 10.1" LCD-TFT Touch screen

import processing.serial.*;
import processing.net.*;

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

PVector person;

//INIT SECOND SCREEN / SERVER CLIENT
int port = 3030;
Client c;
String input;
String newInput;
int data[];
int personCounter = 0;

ArrayList<Person> boardPersons;
ArrayList<Person> screenPersons;
ArrayList<Person> historyPersons;

void setup() {
  size(1280, 800, P2D);
  //frameRate(60);
  perspectives = loadImage(bg[bgIndex]);
  person_abstract = loadImage("27.png");
  // smile00 = loadImage("34.png");
  // smile01 = loadImage("29.png");
  // smile02 = loadImage("30.png");
  // smile03 = loadImage("31.png");
  // smile04 = loadImage("32.png");
  // smile05 = loadImage("33.png");

  // START THE SERVER OR CLIENT
  c = new Client(this, "10.0.1.3", port);
  boardPersons = new ArrayList<Person>();
  screenPersons = new ArrayList<Person>();
  historyPersons = new ArrayList<Person>();
}

void draw() {
  //background(perspectives);
  background(250);
  //image(perspectives, 0,0,1280,800);
  //fill(0, 0, 250);

  receiveDataClient(); // get data from server into data[ identification - polarity - intensity - x - y - xx - yy ]
  secondScreenInteraction(); // analyse data and show positions on the second screen

}
