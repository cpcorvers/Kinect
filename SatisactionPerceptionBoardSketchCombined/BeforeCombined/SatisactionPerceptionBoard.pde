/********************
 *
 * IMPORT
 *
 *******************/

import processing.serial.*;
import gausstoys.core.*;
import websockets.*;
import processing.net.*;

/********************
 *
 * INIT
 *
 *******************/

GaussSense gsMeta;
GaussSense[] gs = new GaussSense[2];
boolean showContour = false;
boolean testBoard = false;
int thld = 6 ; //Unit: Gauss
boolean horizontalGrid = true;

// background images
PImage playingfield;
String[] bg = {"playingfield1.png", "playingfield2.png", "playingfield3.png", "playingfield4.png" };
int bgIndex = 0;

// INIT SECOND SCREEN / SERVER CLIENT
Server s;
Client c;
String input;
String newInput;
int data[];
int port = 3030;

// INIT 'databases'
Person p;
ArrayList<Person> boardPawns;
ArrayList<Person> screenPersons;
ArrayList<Person> historyPersons;

float scaleX = 1.4900; //1.373 //width of screen
float scaleY = 1.550; //1.350 //hight of screen
float offsetX = 10; // 76;
float offsetY = 10; // 65;

/********************
 *
 * SETUP FUNCTION
 *
 *******************/
void setup() {
  // START THE SERVER
  s = new Server(this, port); // Start a simple server on a port
  size(1920, 1080, P2D);
  frameRate(20);
  playingfield = loadImage(bg[bgIndex]);

  // List all serial ports
  GaussSense.printSerialPortList();

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

  println("Setup complete");
}

/********************
 *
 * DRAW FUNCTION
 *
 *******************/

void draw() {
  background(250);

  // create boardvisual on the boardscreen with keypress to switch images
  pushMatrix();
  translate(displayWidth, 0);
  rotate (PI/2);
  image(playingfield, 0, 0, displayHeight, displayWidth );
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

  // show visuals as generated by the GaussSense product and software
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

  getGaussData();
  dataVisualisation();
  println(boardPawns.size() + " " + screenPersons.size() + " " + historyPersons.size());
}

void dataVisualisation() {
  // show every person which is taken==true
  for (Person p : boardPawns) {
    if ( p.pawn_polarity == 1) { //p.taken == true &&
      p.getPawnCenter();
      p.showPawn(p.pawnCenterX, p.pawnCenterY, p.identity, p.direction);
      println( p.pawn_x + " " + p.pawn_y + " " + p.pawn_polarity + " " + p.pawn_intensity + " " + p.pawnCenterX + " " + p.pawnCenterY + " " + p.identity + " " + p.direction );

      // send the GaussSense data to the clients
      // s.write( j + " " + polarity+ " " + intensity + " " + x + " " + y +  " " + xx + " " + yy + "\n" );
      s.write( p.pawn_x + " " + p.pawn_y + " " + p.pawn_polarity + " " + p.pawn_intensity + " " + p.pawnCenterX + " " + p.pawnCenterY + " " + p.identity + " " + p.direction + "\n" );

    }
  }
}
