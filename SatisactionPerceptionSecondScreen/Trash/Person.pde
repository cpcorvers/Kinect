// Person class on SecondScreen
class Person { // class

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

  float identity;
  float direction;
  float pawn_polarity;
  float pawn_intensity;
  float pawn_x;
  float pawn_y;
  float pawn_ID;
  float recordD = 1000;
  boolean taken = false;

  float pawnCenterX;
  float pawnCenterY;
  boolean takenCenter = false;

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
  Person(float x, float y, float polarity, float intensity) {
    pawn_x = x;
    pawn_y = y;
    pawn_polarity = polarity;
    pawn_intensity = intensity;
    giveIdentity();
  };
  Person(float pawn_x, float pawn_y, float pawn_polarity, float pawn_intensity, float pawnCenterX, float pawnCenterY, float identity, float direction){
    pawn_x = pawn_x;
    pawn_y = pawn_y;
    pawn_polarity = pawn_polarity;
    pawn_intensity = pawn_intensity;
    pawnCenterX = pawnCenterX;
    pawnCenterY = pawnCenterY;
    identity = identity;
    direction = direction;
  };

  // function
  void showPerson() { // xp, yp, scale
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

  void showPerson2() { // xp, yp, scale
    scalefactor = map(pawnCenterX, serverDisplayHeight, 0, 2.8, 0.9);
    zp = map(pawnCenterX, 0, serverDisplayWidth, 800, 100);
    xp = map(pawnCenterY, 0, serverDisplayHeight, 100, 1800);
    wp = (imagePersonWidth / scalefactor);
    hp = (imagePersonHeight / scalefactor);
    image(person_abstract, xp, zp, wp, hp);
    textSize(20);
    fill(0, 102, 153);
    text(pawnCenterX, xp, zp);
    //image(smile00, width/2, personLevel, smileWidth/personScaleAdult, smileWidth/personScaleAdult);
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

    void becomeCenterPawn(Person other) {
      pawnCenterX = other.pawnCenterX;
      pawnCenterY = other.pawnCenterY;
      direction = other.direction;
      }

  void giveIdentity() {
    if (pawn_polarity == 0) {
      if (pawn_intensity >0 && pawn_intensity <= 50 ) {
        identity = 1;
        } else if (pawn_intensity > 50 && pawn_intensity <= 100 ){
          identity = 2;
          } else if (pawn_intensity > 100 && pawn_intensity <= 150 ){
            identity = 3;
            } else if (pawn_intensity > 150 && pawn_intensity <= 200 ){
              identity = 4;
              } else if (pawn_intensity > 200 && pawn_intensity <= 250 ){
                identity = 5;
                }
    } else if (pawn_polarity == '1') {
      if (pawn_intensity >0 && pawn_intensity <= 50 ) {
        identity = 51;
        } else if (pawn_intensity > 50 && pawn_intensity <= 100 ){
          identity = 52;
          } else if (pawn_intensity > 100 && pawn_intensity <= 150 ){
            identity = 53;
            } else if (pawn_intensity > 150 && pawn_intensity <= 200 ){
              identity = 54;
              } else if (pawn_intensity > 200 && pawn_intensity <= 250 ){
                identity = 55;
                }
      } else {
        identity = 00;
    }
  }

  void getPawnCenter(){
    float x1;
    float y1;
    float x2;
    float y2;
    for (Person cp1 : boardPawns) {
      if (cp1.pawn_polarity == 0){
        float recordDC = 1000;
        Person matchedCenter = null;
        for (Person cp2 : boardPawns) {
          if (cp2.pawn_polarity == 1){
            PVector center0 = cp1.getCenter();
            PVector center1 = cp2.getCenter();
            float dc = PVector.dist(center0, center1);
            if (dc < recordDC && !cp2.takenCenter ) {
              recordDC = dc;
              matchedCenter = cp2;
            }
          }
        }
        // println(pawnCentreX + pawnCentreY);
        if (matchedCenter != null) {
          matchedCenter.takenCenter = true;
          x1 = cp1.pawn_x;
          y1 = cp1.pawn_y;
          x2 = matchedCenter.pawn_x;
          y2 = matchedCenter.pawn_y;
          matchedCenter.pawnCenterX = (x1 + x2) /2;
          matchedCenter.pawnCenterY = (y1 + y2) /2;
          // calculate the direction of the pawn by the angle between the two magnets of the pawn
          float degree = atan2( (y2 - y1) , (x2 - x1));
          matchedCenter.direction = degree; //radians(degree);
          cp1.becomeCenterPawn(matchedCenter);
        }
      }
    }
  }
} //class Person
