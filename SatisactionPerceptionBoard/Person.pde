// Person class on PerceptionBoard
class Person { // class

// Setup of JSONobject for Person Class
// String data = "{ \"p.pawn_x\:  , \"p.pawn_y\":  , \"p.pawn_polarity\":  ,\"p.pawn_intensity\":  , \"p.pawnCenterX\":  , \"p.pawnCenterY\":  , \"p.identity\":  , \"p.direction\" :  }";
// [{
//     "pawn_x": ,
//     "pawn_y": ,
//     "pawn_polarity": ,
//     "pawn_intensity": ,
//     "identity": ,
//     "pawnCenterX": ,
//     "pawnCenterY": ,
//     "direction": ,
//     "timestamp":
//   }
// ]

  // data:
  float xp;  // width of the perspective
  float zp;  // depth of the perspective
  float scalefactor; //variable to create a 3D perspective in 2D rendering of the person image
  float wp;
  float hp;
  PImage person_abstract = loadImage("27.png");

  PImage pawnVisual = loadImage("pawnVisual.png");
  int imagePawnWidth = 100; //width of the .png image of the pawn in birdview
  int imagePawnHeight = 50; //height of the .png image of the pawn in birdview

  int serverDisplayWidth = 1920;
  int serverDisplayHeight = 1080;
  int imagePersonWidth = 177; //width of the .png image
  int imagePersonHeight = 408; //height of the .png image

  float pawn_x;
  float pawn_y;
  float pawn_polarity;
  float pawn_intensity;
  float pawnCenterX;
  float pawnCenterY;
  float identity;
  float direction;
  String timestamp;

  float pawn_ID;
  float recordD = 1000;
  boolean taken = false;

  boolean takenCenter = false;
  boolean takenJSON = false;


  // constructors:
  Person(float x, float y) {
    pawn_x = x;
    pawn_y = y;
  };
  Person(float x, float y, float id) {
    pawn_x = x;
    pawn_y = y;
    pawn_ID = id;
  };
  Person(float x, float y, int polarity, float intensity) {
    pawn_x = x;
    pawn_y = y;
    pawn_polarity = polarity;
    pawn_intensity = intensity;
    giveIdentity();
    // getPawnCenter();
    // becomeJSONObject();
  };
  Person(float pawn_x, float pawn_y, float pawn_polarity, float pawn_intensity, float pawnCenterX, float pawnCenterY, float identity, float direction, float timestamp){
    pawn_x = pawn_x;
    pawn_y = pawn_y;
    pawn_polarity = pawn_polarity;
    pawn_intensity = pawn_intensity;
    pawnCenterX = pawnCenterX;
    pawnCenterY = pawnCenterY;
    identity = identity;
    direction = direction;
    timestamp = timestamp;
  };

  // function
  void showPerson(float pawnCenterX, float pawnCenterY, float identity, float direction) { // xp, yp, scale
    pushMatrix();
    scalefactor = map(pawnCenterX, serverDisplayHeight, 0, 2.8, 0.9);
    zp = map(pawnCenterX, 0, serverDisplayWidth, 800, 100);
    xp = map(pawnCenterY, 0, serverDisplayHeight, 100, 1800);
    wp = (imagePersonWidth / scalefactor);
    hp = (imagePersonHeight / scalefactor);
    image(person_abstract, xp, zp, wp, hp);
    textSize(20);
    fill(0, 102, 153);
    text(identity, xp, zp);
    //image(smile00, width/2, personLevel, smileWidth/personScaleAdult, smileWidth/personScaleAdult);
    popMatrix();
}

  void showPawn(float pawnCenterX, float pawnCenterY, float identity, float direction) {
    pushMatrix();
    translate(pawnCenterX + imagePawnWidth/2, pawnCenterY - imagePawnHeight/2);
    rotate(direction + (PI / 2));
    image(pawnVisual, 0, 0, imagePawnWidth, imagePawnHeight);
    textSize(20);
    fill(0, 102, 153);
    text(identity, 10, 70);
    popMatrix();
  }

  PVector getCenter() {
    float x = pawn_x;
    float y = pawn_y;
    return new PVector(x,y);
  }

  void becomePerson(Person other) {
    pawn_x = other.pawn_x;
    pawn_y = other.pawn_y;
    pawn_polarity = other.pawn_polarity;
    pawn_intensity = other.pawn_intensity;
    taken = other.taken;
  }

  void giveIdentity() {
    if (pawn_polarity == 0) {
      if (pawn_intensity >0 && pawn_intensity <= 10 ) { identity = 1; }
      else if (pawn_intensity > 10 && pawn_intensity <= 15 ){ identity = 2; }
      else if (pawn_intensity > 15 && pawn_intensity <= 30 ){ identity = 3; }
      else if (pawn_intensity > 30 && pawn_intensity <= 40 ){ identity = 4; }
      else if (pawn_intensity > 40 && pawn_intensity <= 50 ){ identity = 5; }
    } else if (pawn_polarity == 1) {
      if (pawn_intensity >0 && pawn_intensity <= 4 ) { identity = 49; }
      else if (pawn_intensity > 4 && pawn_intensity <= 7 ){ identity = 50; }
      else if (pawn_intensity > 7 && pawn_intensity <= 10 ){ identity = 51; }
      else if (pawn_intensity > 10 && pawn_intensity <= 15 ){ identity = 52; }
      else if (pawn_intensity > 15 && pawn_intensity <= 30 ){ identity = 53; }
      else if (pawn_intensity > 30 && pawn_intensity <= 40 ){ identity = 54; }
      else if (pawn_intensity > 40 && pawn_intensity <= 50 ){ identity = 55; }
    } else { identity = 00; }
  }

  // void getPawnCenter(){
  //   float x1;
  //   float y1;
  //   float x2;
  //   float y2;
  //   // for (Person cp1 : boardPawns) {
  //   for (int i = 0; i < (boardPawns.size()); i++){
  //     Person cp0 = boardPawns.get(i);
  //
  //     if (cp0.pawn_polarity == 0){
  //       float recordDC = 500;
  //       Person matchedCenter = null;
  //       // for (Person cp2 : boardPawns) {
  //       for (int j = 0; j < (boardPawns.size()); j++){
  //         Person cp1 = boardPawns.get(j);
  //         if (cp1.pawn_polarity == 1){
  //           PVector center0 = cp0.getCenter();
  //           PVector center1 = cp1.getCenter();
  //           float dc = PVector.dist(center0, center1);
  //           if (dc < recordDC && !cp1.takenCenter ) {
  //             recordDC = dc;
  //             matchedCenter = cp1;
  //           }
  //           if (matchedCenter != null) {
  //             matchedCenter.takenCenter = true;
  //             x1 = cp0.pawn_x;
  //             y1 = cp0.pawn_y;
  //             x2 = matchedCenter.pawn_x;
  //             y2 = matchedCenter.pawn_y;
  //             matchedCenter.pawnCenterX = (x1 + x2) /2;
  //             matchedCenter.pawnCenterY = (y1 + y2) /2;
  //             // calculate the direction of the pawn by the angle between the two magnets of the pawn
  //             float degree = atan2( (y2 - y1) , (x2 - x1));
  //             matchedCenter.direction = degree; //radians(degree);
  //             cp0.becomePawnCenter(matchedCenter);
  //           }
  //         }
  //       }
  //       // println(pawnCentreX + pawnCentreY);
  //       // if (matchedCenter != null) {
  //       //   matchedCenter.takenCenter = true;
  //       //   x1 = cp1.pawn_x;
  //       //   y1 = cp1.pawn_y;
  //       //   x2 = matchedCenter.pawn_x;
  //       //   y2 = matchedCenter.pawn_y;
  //       //   matchedCenter.pawnCenterX = (x1 + x2) /2;
  //       //   matchedCenter.pawnCenterY = (y1 + y2) /2;
  //       //   // calculate the direction of the pawn by the angle between the two magnets of the pawn
  //       //   float degree = atan2( (y2 - y1) , (x2 - x1));
  //       //   matchedCenter.direction = degree; //radians(degree);
  //       //   cp1.becomePawnCenter(matchedCenter);
  //       // }
  //     }
  //   }
  // }

  void becomePawnCenter(Person other) {
    pawnCenterX = other.pawnCenterX;
    pawnCenterY = other.pawnCenterY;
    direction = other.direction;
  }

  void becomeJSONObject() {
    long time = new Date().getTime();
    timestamp = (time +"L");
    // println(timestamp);
    pawn.setFloat("pawn_x", pawn_x); //0
    pawn.setFloat("pawn_y", pawn_y); //1
    pawn.setFloat("pawn_polarity", pawn_polarity); //2
    pawn.setFloat("pawn_intensity", pawn_intensity); //3
    pawn.setFloat("pawnCenterX", pawnCenterX); //4
    pawn.setFloat("pawnCenterY", pawnCenterY); //5
    pawn.setFloat("identity", identity); //6
    pawn.setFloat("direction", direction); //7
    pawn.setString("timestamp", timestamp);
    pawn.setBoolean("showed", false);
  };

} //class Person
