//Select background

//select environment

//select characters

//give perspective on characters

//reflect mood of representative in background

//select rights-duties-interest

//select available tool

PImage house;
PImage person_abstract;
PImage smile00;
PImage smile01;
PImage smile02;
PImage smile03;
PImage smile04;
PImage smile05;

void preload() {
  
}

void setup() {
  size(800, 600, P2D);
    house = loadImage("28.png");
    person_abstract = loadImage("27.png");
    smile00 = loadImage("34.png");
    smile01 = loadImage("29.png");
    smile02 = loadImage("30.png");
    smile03 = loadImage("31.png");
    smile04 = loadImage("32.png");
    smile05 = loadImage("33.png");
}

void draw() {
 background(0,150,200);
 //background(0,0,0);
 
 fill(0, 200, 120);
 rect(0, height/2, width, height/2);
 
   int xh = 59*4;
   int yh = 150;
   int wh = 59*4;
   int hh = 77*4;
  image(house, 0, yh, wh, hh);
  image(house, xh, yh, wh, hh);
  image(house, (xh*2), yh, wh, hh);
  image(house, (xh*3), yh, wh, hh);
  
  int personWidth = 89;
  int personHeight = 205;
  int personScaleAdult = 1;
  int personScaleYoungAdult = 2;
  int personScaleKid = 3;
  int personLevel = 370;
  int smileWidth = 123/2;
  image(person_abstract, width/2, personLevel, personWidth/personScaleAdult, personHeight/personScaleAdult);
  image(smile00, width/2, personLevel, smileWidth/personScaleAdult, smileWidth/personScaleAdult);
  
  image(person_abstract, width/2-personWidth, personLevel, personWidth/personScaleKid, personHeight/personScaleKid);
  image(smile01, width/2-personWidth, personLevel, smileWidth/personScaleKid, smileWidth/personScaleKid);
  
  image(person_abstract, width/2+personWidth, personLevel, personWidth/personScaleYoungAdult, personHeight/personScaleYoungAdult);
  image(smile02, width/2+personWidth, personLevel, smileWidth/personScaleYoungAdult, smileWidth/personScaleYoungAdult);
  
  image(person_abstract, width/2-2*personWidth, personLevel, personWidth/personScaleYoungAdult, personHeight/personScaleYoungAdult);
  image(smile03, width/2-2*personWidth, personLevel, smileWidth/personScaleYoungAdult, smileWidth/personScaleYoungAdult);
}
