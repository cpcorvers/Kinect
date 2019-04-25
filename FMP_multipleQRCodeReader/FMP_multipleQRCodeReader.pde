////This tab is for coding on the Raspberry Pi system

///*****************************************************************************
// *
// *  multipleQRCodeReader - v07/29/2018
// *
// *  An example of the use of the ZXING4P.multipleQRCodeReader() and
// *  ZXING4P.getPositionMarkers() methods.
// *
// *  There are two operation modes:
// *  - IMAGE
// *  - CAM
// *
// *  You can toggle between the two modes by pressing the <c>-key
// *
// *  IMAGE mode:
// *  You can move the QR-codes around using dragging and dropping them.
// *  The codes will be constantly detected and decoded in their new positions.
// *
// *  CAM mode:
// *  It opens and displays the cam capture.
// *  Just hold one or more QR codes in front of the cam and the code(s) will be
// *  detected and decoded.
// *
// *  Library page:
// *  http://cagewebdev.com/zxing4processing-processing-library/
// *
// *  (c) 2013-2018 Rolf van Gelder, http://cagewebdev.com, http://rvg.cage.nl
// * 
// *****************************************************************************/

//// IMPORT THE ZXING4PROCESSING LIBRARY AND DECLARE A ZXING4P OBJECT
//import com.cage.zxing4p3.*;
//ZXING4P zxing4p;

//// PROCESSING VIDEO LIBRARY
////import processing.video.*;
////Capture video;

//import gohai.glvideo.*;
//GLCapture video;

//// FOR COMPARING ARRAYS
//import java.util.Arrays;

//// THE QR CODES
//ArrayList<QRCode> qrcodes = new ArrayList<QRCode>();

//ArrayList<PVector[]> allMarkers = new ArrayList<PVector[]>();

//String detectedCodes[]    = null;
//String detectedCodesOld[] = null;

//PVector[] camMarkers;

//PGraphics pg;

//boolean useCam      = true;
//boolean showMarkers = true;
//boolean showText    = true;
//boolean debug       = true;


///*****************************************************************************
// *
// *  SETUP
// *
// *****************************************************************************/
//void setup() {
//  size(640, 480, P2D);
//  //int xp = 1920 / 3;
//  //var yp = 1280 / 3;
//  //size(1280, 720, P2D);
  
  
//  String[] devices = GLCapture.list();
//  String[] configs = GLCapture.configs(devices[0]);
//  println("start: "); 
//  printArray(devices);
//  printArray(configs);
//  println("// end");
  
//  // CREATE QR-CODES (for IMAGE mode)
//  qrcodes.add(new QRCode("qr1.png", 10, 10, 0));
//  qrcodes.add(new QRCode("qr2.png", 400, 240, 1));
//  qrcodes.add(new QRCode("qr3.png", 200, 300, 2));
 
//  //pg  = createGraphics(width, height, P2D);

//  // CREATE CAPTURE
//  //video = new Capture(this, width, height);
//  //video = new GLCapture(this);
//  //video = new GLCapture(this, devices[0], 640, 480, 40); 
//  video = new GLCapture(this, devices[0], 640, 480, 30); 

//  // START CAPTURING
//  video.start();  

//  // CREATE A NEW EN-/DECODER INSTANCE
//  zxing4p = new ZXING4P();

//  // DISPLAY VERSION INFORMATION
//  zxing4p.version();
//} // setup()


///*****************************************************************************
// *
// *  DRAW
// *
// *****************************************************************************/
//void draw() { 
//  background(0);

//  if (useCam) {
//    // UPDATE CAPTURE
//    if (video.available()) 
//      video.read();
//      //pg.beginDraw();
//      //pg.clear();
//      //pg.image(video,0,0);
//      //pg.endDraw();     
      
//      //beginDraw();
//      clear();
//      image(video,0,0);
//      //endDraw();
      
//      //image(video,0,0);
//   } else {
//    // SHOW TWO QR CODES
//    //pg.beginDraw();
//    //pg.
//    clear();
//    for (int i = 0; i < qrcodes.size(); i++) {
//      //pg.
//      image(qrcodes.get(i).img, qrcodes.get(i).x, qrcodes.get(i).y);
//    }
//    //pg.endDraw();
  
//  } // if (useCam)

//  // SHOW IMAGE
//  //image(pg, 0, 0);
//  //image(video, 100, 100);

//  // TRY TO DETECT AND DECODE A QRCODE IN THE VIDEO CAPTURE
//  // decodeImage(boolean tryHarder, PImage img)
//  // tryHarder: false => fast detection (less accurate)
//  //            true  => best detection (little slower)
//  try {  
//    //detectedCodes = zxing4p.multipleQRCodeReader(pg, false);
//    detectedCodes = zxing4p.multipleQRCodeReader(video, false);

//    if (detectedCodes.length > 0) {
//      // QR-CODES DETECTED
//      if (debug) {
//        if (!Arrays.equals(detectedCodes, detectedCodesOld)) {
//          // DIFFERENT CODES DETECTED
//          println("\nNumber of QR Code(s) detected: " + detectedCodes.length);
//        } // if (!Arrays.equals(detectedCodes, detectedCodesOld))
//      }
//    }

//    // CLEAN UP
//    allMarkers.clear();

//    for (int i = 0; i < detectedCodes.length; i++) {
//      allMarkers.add(zxing4p.getPositionMarkers(i));
//    }

//    if (debug) {
//      for (int i = 0; i < detectedCodes.length; i++) {
//        if (!Arrays.equals(detectedCodes, detectedCodesOld)) {
//          //println((i + 1) + ". " + detectedCodes[i]);
                    
//          println("cam Markers:");
//          printArray(camMarkers);
          
//          //println("Detected Codes Old:");
//          //printArray(detectedCodesOld);          
          
//          println("Detected Codes:");
//          printArray(detectedCodes);
          
//          //println("All Markers:");
//          //printArray(allMarkers);          
          
//          println("QR Codes:");
//          printArray(qrcodes );
    
//        } // if (!Arrays.equals(decodedArr, decodedArrOld))
//      } // for (int i = 0; i < detectedCodes.length; i++)
//    } // if (decodedArr.length > 0)

//    // DISPLAY MARKERS AND DECODED TEXT
//    if (useCam) {
//      if (showMarkers) {
//        for (int i = 0; i < allMarkers.size(); i++) {
//          camMarkers = allMarkers.get(i);
//          showMarkers(camMarkers);        
//        } // for (int i = 0; i < allCamMarkers.size(); i++)
//      } // if (showMarkers)
//    } else {
//      for (int i = 0; i < qrcodes.size(); i++) {
//        if (showText) qrcodes.get(i).showText(detectedCodes[i]);      
//        if (showMarkers) {
//          camMarkers = allMarkers.get(i);
//          showMarkers(camMarkers);
//        }
//      } // for (int i = 0; i < qrcodes.size(); i++)
//    } // if (useCam)
//    detectedCodesOld = detectedCodes;
//  }
//  catch (Exception e) {
//  } // try

//  // SHOW LIST OF DETECTED CODES
//  if (useCam && detectedCodes != null) {
//    int x = 10;
//    int y = 30;
//    pushStyle();
//    textSize(18);
//    fill(0, 255, 0);
//    for (int i = 0; i < detectedCodes.length; i++) {
//      text(i + ". " + detectedCodes[i], x, y);
//      y += 20;
//    }
//    popStyle();
//  }
//} // draw()



//This tab is for coding on the MacBook Laptop system

/*****************************************************************************
 *
 *  multipleQRCodeReader - v07/29/2018
 *
 *  An example of the use of the ZXING4P.multipleQRCodeReader() and
 *  ZXING4P.getPositionMarkers() methods.
 *
 *  There are two operation modes:
 *  - IMAGE
 *  - CAM
 *
 *  You can toggle between the two modes by pressing the <c>-key
 *
 *  IMAGE mode:
 *  You can move the QR-codes around using dragging and dropping them.
 *  The codes will be constantly detected and decoded in their new positions.
 *
 *  CAM mode:
 *  It opens and displays the cam capture.
 *  Just hold one or more QR codes in front of the cam and the code(s) will be
 *  detected and decoded.
 *
 *  Library page:
 *  http://cagewebdev.com/zxing4processing-processing-library/
 *
 *  (c) 2013-2018 Rolf van Gelder, http://cagewebdev.com, http://rvg.cage.nl
 * 
 *****************************************************************************/

// IMPORT THE ZXING4PROCESSING LIBRARY AND DECLARE A ZXING4P OBJECT
import com.cage.zxing4p3.*;
ZXING4P zxing4p;

// PROCESSING VIDEO LIBRARY
import processing.video.*;
Capture video;


// FOR COMPARING ARRAYS
import java.util.Arrays;

// THE QR CODES
ArrayList<QRCode> qrcodes = new ArrayList<QRCode>();

ArrayList<PVector[]> allMarkers = new ArrayList<PVector[]>();

String detectedCodes[]    = null;
String detectedCodesOld[] = null;

PVector[] camMarkers;

PGraphics pg;

boolean useCam      = true;
boolean showMarkers = true;
boolean showText    = true;
boolean debug       = true;

/*****************************************************************************
 *
 *  SETUP
 *
 *****************************************************************************/
void setup() {
  size(640, 480, P2D);
  //int xp = 1920 / 3;
  //var yp = 1280 / 3;
  //size(1280, 720, P2D);
  
  
  String devices [] = Capture.list();
  //String configs [] = Capture.configs(devices[0]); 
  
  //String[] devices = GLCapture.list();
  //String[] configs = GLCapture.configs(devices[0]);
  println("start: "); 
  printArray(devices);
  //printArray(configs);
  println("// end");
  
  // CREATE QR-CODES (for IMAGE mode)
  qrcodes.add(new QRCode("qr1.png", 10, 10, 0));
  qrcodes.add(new QRCode("qr2.png", 400, 240, 1));
  qrcodes.add(new QRCode("qr3.png", 200, 300, 2));
 
  pg  = createGraphics(width, height, P2D);

  // CREATE CAPTURE
  video = new Capture(this, devices[0]);
  //video = new GLCapture(this);
  //video = new GLCapture(this, devices[0], 640, 480, 40); 
  //video = new GLCapture(this, devices[0], 640, 480, 30); 

  // START CAPTURING
  video.start();  

  // CREATE A NEW EN-/DECODER INSTANCE
  zxing4p = new ZXING4P();

  // DISPLAY VERSION INFORMATION
  zxing4p.version();
} // setup()


/*****************************************************************************
 *
 *  DRAW
 *
 *****************************************************************************/
void draw() { 
  background(123);

  if (useCam) {
    // UPDATE CAPTURE
    if (video.available()) 
      video.read();
      pg.beginDraw();
      pg.clear();
      pg.image(video,0,0);
      pg.endDraw();     
      
      //beginDraw();
      //clear();
      //image(video,100,100);
      //endDraw();
      
      //image(video,0,0);
   } else {
    // SHOW TWO QR CODES
    //pg.beginDraw();
    //pg.
    clear();
    for (int i = 0; i < qrcodes.size(); i++) {
      pg.image(qrcodes.get(i).img, qrcodes.get(i).x, qrcodes.get(i).y);
    } //pg.endDraw();
  
  } // if (useCam)

  // SHOW IMAGE
  image(pg, 0, 0);

  // TRY TO DETECT AND DECODE A QRCODE IN THE VIDEO CAPTURE
  // decodeImage(boolean tryHarder, PImage img)
  // tryHarder: false => fast detection (less accurate)
  //            true  => best detection (little slower)
  try {  
    //detectedCodes = zxing4p.multipleQRCodeReader(pg, false);
    detectedCodes = zxing4p.multipleQRCodeReader(video, false);

    if (detectedCodes.length > 0) {
      // QR-CODES DETECTED
      if (debug) {
        if (!Arrays.equals(detectedCodes, detectedCodesOld)) {
          // DIFFERENT CODES DETECTED
          println("\nNumber of QR Code(s) detected: " + detectedCodes.length);
        } // if (!Arrays.equals(detectedCodes, detectedCodesOld))
      }
    }

    // CLEAN UP
    allMarkers.clear();

    for (int i = 0; i < detectedCodes.length; i++) {
      allMarkers.add(zxing4p.getPositionMarkers(i));
    }

    if (debug) {
      for (int i = 0; i < detectedCodes.length; i++) {
        if (!Arrays.equals(detectedCodes, detectedCodesOld)) {
          //println((i + 1) + ". " + detectedCodes[i]);
                    
          //println("cam Markers:");
          //printArray(camMarkers);
          
          //println("Detected Codes Old:");
          //printArray(detectedCodesOld);          
          
          //println("Detected Codes:");
          //printArray(detectedCodes);
          
          //println("All Markers:");
          //printArray(allMarkers);          
          
          //println("QR Codes:");
          //printArray(qrcodes );
          
        } // if (!Arrays.equals(decodedArr, decodedArrOld))
      } // for (int i = 0; i < detectedCodes.length; i++)
    } // if (decodedArr.length > 0)

    // DISPLAY MARKERS AND DECODED TEXT
    if (useCam) {
      if (showMarkers) {
        for (int i = 0; i < allMarkers.size(); i++) {
          camMarkers = allMarkers.get(i);
          showMarkers(camMarkers); 

        } // for (int i = 0; i < allCamMarkers.size(); i++)
      } // if (showMarkers)
    } else {
      for (int i = 0; i < qrcodes.size(); i++) {
        if (showText) qrcodes.get(i).showText(detectedCodes[i]);      
        if (showMarkers) {
          camMarkers = allMarkers.get(i);
          showMarkers(camMarkers);

        }
      } // for (int i = 0; i < qrcodes.size(); i++)
    } // if (useCam)
    detectedCodesOld = detectedCodes;
  }
  catch (Exception e) {
  } // try

  // SHOW LIST OF DETECTED CODES
  if (useCam && detectedCodes != null) {
    int x = 10;
    int y = 30;
    pushStyle();
    textSize(18);
    fill(0, 255, 0);
    for (int i = 0; i < detectedCodes.length; i++) {
      text(i + ". " + detectedCodes[i], x, y);
      y += 20;
    }
    popStyle();
  }
} // draw()
