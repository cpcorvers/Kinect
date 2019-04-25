//printArray(camMarkers);

// Situation, a system constellation of a specific family issue case is made with artefacts by a representative.
// Arteffects (characters) with qr code are detected in front of the Raspberry Pi model 3B 
// with camera module v2.
// The application uses the Zxing qr code library and example multipleQRCodeReader and the GLCapture method 
// from the OpenCV for processing library. This library works slightly different with the rendering of an image
// therfor the createGraphics method is taken out of the multipleQRCodeReader code.
// 
// The next step is to setup the perspective of the user e.g. create an image from the system constellation.
// Three classess are constructed, character, role and namegiver.
// The character has the information of the artefact like position, identifier and roles[].
// The role has the information as known by the representative: name, timestamp and namegiver.
// The namegiver had the information of the representative: organisation, representative_name[] and organisation_tools[].

//Number of QR Code(s) detected: 1
//cam Markers:
//[0] [ 539.0, 346.0, 0.0 ]
//[1] [ 540.5, 375.0, 0.0 ]
//[2] [ 510.0, 372.0, 0.0 ]
//Detected Codes:
//[0] "Background_003"

//Number of QR Code(s) detected: 1
//cam Markers:
//[0] [ 458.7, 291.1, 0.0 ]
//[1] [ 451.0, 356.5, 0.0 ]
//[2] [ 383.0, 349.5, 0.0 ]
//Detected Codes:
//[0] "Rainbow unicorn"



/*****************************************************************************
 *
 *  SHOW THE MARKERS FOR ONE QR-CODE
 *
 *****************************************************************************/
void showMarkers(PVector[] markers) {
  int j;
  float xm = (markers[0].x + markers[2].x ) /2; // Calculate the x centre of the qr code
  float ym = (markers[0].y + markers[2].y ) /2; // Calculate the y centre of the qr code
  pushStyle();

 //for (int i = 0; i < detectedCodes.length; i++) {
 //     j = 250 ;
 //     if (detectedCodes[i].equals("Rainbow unicorn")==true) {
 //       fill(0,j,0);
 //     //} // detectedCodes equal
 //      } else if (detectedCodes[i].equals("Background_001")==true) {
 //        fill(0,0,j);     
 //      } else if (detectedCodes[i].equals("Background_002")==true) {
 //        fill(j,0,j);       
 //      } else if (detectedCodes[i].equals("Background_003")==true) {
 //        fill(j,j,j);       
 //      } else if (detectedCodes[i].equals("Background_004")==true) {
 //        fill(j,0,0);       
 //      } else if (detectedCodes[i].equals("Background_005")==true) {
 //        fill(j,j,0);
 //      } else  
 //     { fill(0,0,0); }
 //   }


  fill(255, 0, 0);
  stroke(255, 0, 0);
  strokeWeight(2);
  rectMode(CENTER);
  rect(xm, ym, 40, 40);
  
  
  //for (int p = 0; p < markers.length; p++) {
  //  j = p + 1;
  //  if (j > 3) j = 0;
  //  line(markers[p].x, markers[p].y, markers[j].x, markers[j].y);
  //} // for (int i = 0; i < pvArr.length; i++)
  popStyle();
} // showMarkers()
