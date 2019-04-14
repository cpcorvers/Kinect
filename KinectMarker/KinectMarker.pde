// Daniel Shiffman
// All features test

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*; //<>// //<>// //<>//
import processing.video.*;

// Get the libs for data form kinect v2
Kinect2 kinect2;

// Get the libs for videostream from the Laptopcamera
Capture video;

// Get the libs for markerdetection
// https://github.com/atduskgreg/opencv-processing/blob/master/examples/MarkerDetection/MarkerDetection.pde

void setup() {
  size(1024, 848, P2D);

  //Setup for Kinect sensor
  kinect2 = new Kinect2(this);
  kinect2.initVideo();
  kinect2.initDepth();
  kinect2.initIR();
  kinect2.initRegistered();
  // Start all data
  kinect2.initDevice();

  //Setup for Laptopcamera
  video = new Capture(this,640,480,30);
  video.start();

}

// on the event of mousePressed this code is executed e.g. it creates a snapshot
// good followup idea for caputuring a moment of the constelation or emotion image of the person
void mousePressed() {
  video.read();

}

// on the event of captureEvent this code is executed e.g. it creates a videostream
void captureEvent(Capture video) {
  video.read();
}

void draw() {
  background(0);

  //Draw for kinect
  image(kinect2.getVideoImage(), 0, 0, kinect2.colorWidth*0.267, kinect2.colorHeight*0.267);
  //image(kinect2.getDepthImage(), kinect2.depthWidth, 0);
  image(kinect2.getIrImage(), 0, kinect2.depthHeight);

  //image(kinect2.getRegisteredImage(), kinect2.depthWidth, kinect2.depthHeight);
  fill(255);
  text("Framerate: " + (int)(frameRate), 10, 515);

  // Draw for Laptopcamera
  image(video,kinect2.depthWidth,0);

  // Draw from MarkerDetection

}
