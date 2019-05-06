class Person { // class

  // data:

  float xp;  // width of the perspective
  float zp;  // depth of the perspective
  float scalefactor; //variable to create a 3D perspective in 2D rendering of the person image
  float wp;
  float hp;
  PImage person_abstract;
  int serverDisplayWidth = 1920;
  int serverDisplayHeight = 1080;
  int imagePersonWidth = 177; //width of the .png image
  int imagePersonHeight = 408; //height of the .png image

  //displaysize second screen: 1281, 801

  // constructor:
  Person() {
    person_abstract = loadImage("27.png");
  }

  // function
  void showPerson( int pawn_y, int pawn_x) { // xp, yp, scale
    scalefactor = map(pawn_y, serverDisplayHeight, 0, 2.8, 0.9);  
    xp = map(pawn_x, 0, serverDisplayHeight, 0, 1281);
    zp = map(pawn_y, 0, serverDisplayHeight, 820, 400);
    wp = (imagePersonWidth / scalefactor);
    hp = (imagePersonHeight / scalefactor);

    image(person_abstract, xp, zp, wp, hp);
    //image(smile00, width/2, personLevel, smileWidth/personScaleAdult, smileWidth/personScaleAdult);
  }



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
