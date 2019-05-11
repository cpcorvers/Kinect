class Person { // class

  // data:
  float xp;  // width of the perspective
  float zp;  // depth of the perspective
  float scalefactor; //variable to create a 3D perspective in 2D rendering of the person image
  float wp;
  float hp;
  PImage person_abstract = loadImage("27.png");

  int serverDisplayWidth = 1920;
  int serverDisplayHeight = 1080;
  int imagePersonWidth = 177; //width of the .png image
  int imagePersonHeight = 408; //height of the .png image

  float identity;
  float polarity;
  float intensity;
  float pawn_x;
  float pawn_y;
  float pawn_ID;
  boolean taken = false;

  // constructors:
  Person(float x, float y) {
    // locationP = (dispX + dispY);
    // float identity;
    // float polarity;
    // float intensity;
    pawn_x = x;
    pawn_y = y;
    // pawn_ID = 88;
  };
  Person(float x, float y, float id) {
    pawn_x = x;
    pawn_y = y;
    pawn_ID = id;
  };

  // function
  void show() { // xp, yp, scale
    scalefactor = map(pawn_x, serverDisplayHeight, 0, 2.8, 0.9);
    zp = map(pawn_x, 0, serverDisplayWidth, 800, 100);
    xp = map(pawn_y, 0, serverDisplayHeight, 100, 1800);
    wp = (imagePersonWidth / scalefactor);
    hp = (imagePersonHeight / scalefactor);

    image(person_abstract, xp, zp, wp, hp);

    textSize(20);
    fill(0, 102, 153);
    text(pawn_ID, xp, zp);
    //image(smile00, width/2, personLevel, smileWidth/personScaleAdult, smileWidth/personScaleAdult);
  }

  PVector getCenter() {
    float x = pawn_x;
    float y = pawn_y;
    return new PVector(x,y);
  }

  void becomePerson(Person other) {
    pawn_x = other.pawn_x;
    pawn_y = other.pawn_y;
    pawn_ID = other.pawn_ID;
    // taken = true;
  }
  
}
