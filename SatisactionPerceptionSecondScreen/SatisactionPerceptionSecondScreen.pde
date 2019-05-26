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

void settings() {
  fullScreen(P2D, secondScreen);
}

void setup() {
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

void draw() {

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

void getJSONData(){
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

void dataVisualisation() {
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
