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

  //displaysize second screen: 1281, 801

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
  // Person() {
  //     pawn_x = x;
  //     pawn_y = y;
  //     pawn_ID = id;
  // };

  // function
  void show() { // xp, yp, scale
    scalefactor = map(pawn_y, serverDisplayHeight, 0, 2.8, 0.9);
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


  // function
  // void showPerson(float pawn_y, float pawn_x) { // xp, yp, scale
  //   scalefactor = map(pawn_y, serverDisplayHeight, 0, 2.8, 0.9);
  //   xp = map(pawn_x, 0, serverDisplayHeight, 0, 1280);
  //   zp = map(pawn_y, 0, serverDisplayHeight, 800, 200);
  //   wp = (imagePersonWidth / scalefactor);
  //   hp = (imagePersonHeight / scalefactor);
  //
  //   image(person_abstract, xp, zp, wp, hp);
  //   //image(smile00, width/2, personLevel, smileWidth/personScaleAdult, smileWidth/personScaleAdult);
  // }

  // void addPerson(float x, float y) {
  //
  //   // minx = min(minx, x);
  //   // miny = min(miny, y);
  //   // maxx = max(maxx, x);
  //   // maxy = max(maxy, y);
  // }

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
  //
  // boolean isNear(float x, float y) {
  //
  //   float cx = max(min(x, maxx), minx);
  //   float cy = max(min(y, maxy), miny);
  //   float d = distSq(cx, cy, x, y);
  //
  //   if (d < distThreshold*distThreshold) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  /*
    int personWidth = 89;
   int personHeight = 205;
   int personScaleAdult = 1;
   int personScaleYoungAdult = 2;
   int personScaleKid = 3;
   int personLevel = 370;
   int smileWidth = 123/2;
   image(person_abstract, width/2, personLevel, personWidth/personScaleAdult, personHeight/personScaleAdult);
   image(smile00, width/2, personLevel, smileWidth/personScaleAdult, smileWidth/personScaleAdult);
   }
   */
}
