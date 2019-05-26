// class Pawn { // class
//
//   // data:
//   float xp;  // width of the board
//   float yp;  // height of the board
//   float scalefactor; //variable to create a 3D perspective in 2D rendering of the person image
//   // float wp;
//   // float hp;
//   // PImage person_abstract = loadImage("27.png");
//
//   PImage pawnVisual = loadImage("pawnVisual.png");
//   int imagePawnWidth = 100; //width of the .png image of the pawn in birdview
//   int imagePawnHeight = 50; //height of the .png image of the pawn in birdview
//
//   int serverDisplayWidth = 1920;
//   int serverDisplayHeight = 1080;
//   int imagePersonWidth = 177; //width of the .png image of the person in landview
//   int imagePersonHeight = 408; //height of the .png image of the person in landview
//
//   float identity;
//   float pawn_polarity;
//   float pawn_intensity;
//   float pawn_x;
//   float pawn_y;
//   float pawn_ID;
//   boolean taken = false;
//
//   // constructors:
//   Pawn(float x, float y) {
//     // locationP = (dispX + dispY);
//     // float identity;
//     // float polarity;
//     // float intensity;
//     pawn_x = x;
//     pawn_y = y;
//     // pawn_ID = 88;
//   };
//   Pawn(float x, float y, float id) {
//     pawn_x = x;
//     pawn_y = y;
//     pawn_ID = id;
//   };
//   Pawn(float x, float y, float polarity, float intensity) {
//     pawn_x = x;
//     pawn_y = y;
//     pawn_polarity = polarity;
//     pawn_intensity = intensity;
//   };
//
//   // function
//   void showPawn() {
//     float centreX = pawn_x - (imagePawnWidth / 2);
//     float centreY = pawn_y - (imagePawnHeight / 2);
//     image(pawnVisual, centreX, centreY, imagePawnWidth, imagePawnHeight);
//     textSize(20);
//     fill(0, 102, 153);
//     text(pawn_ID, pawn_x, pawn_y);
//   }
//
//   PVector getCenter() {
//     float x = pawn_x;
//     float y = pawn_y;
//     return new PVector(x,y);
//   }
//
//   PVector makePerson() {
//     float x = pawn_x;
//     float y = pawn_y;
//     float polarity = pawn_polarity;
//     float intensity = pawn_intensity;
//     println(x + " " + y +" " + polarity +" " + intensity);
//     return new PVector(x, y, polarity, intensity);
//   }
//   // void becomePerson(Pawn other) {
//   //   pawn_x = other.pawn_x;
//   //   pawn_y = other.pawn_y;
//   //   pawn_ID = other.pawn_ID;
//   //   // taken = true;
//   // }
//
//   void giveIdentity() {
//     if (pawn_polarity == 0) {
//       if (pawn_intensity >0 && pawn_intensity <= 50 ) {
//         identity = 1;
//         } else if (pawn_intensity > 50 && pawn_intensity <= 100 ){
//           identity = 2;
//           } else if (pawn_intensity > 100 && pawn_intensity <= 150 ){
//             identity = 3;
//             } else if (pawn_intensity > 150 && pawn_intensity <= 200 ){
//               identity = 4;
//               } else if (pawn_intensity > 200 && pawn_intensity <= 250 ){
//                 identity = 5;
//                 }
//     } else if (pawn_polarity == 1){
//       if (pawn_intensity >0 && pawn_intensity <= 50 ) {
//         identity = 51;
//         } else if (pawn_intensity > 50 && pawn_intensity <= 100 ){
//           identity = 52;
//           } else if (pawn_intensity > 100 && pawn_intensity <= 150 ){
//             identity = 53;
//             } else if (pawn_intensity > 150 && pawn_intensity <= 200 ){
//               identity = 54;
//               } else if (pawn_intensity > 200 && pawn_intensity <= 250 ){
//                 identity = 55;
//                 }
//     } else {
//       identity = 00;
//     }
//   }
//
//   // void giveDirection() {
//   //
//   // }
// }
