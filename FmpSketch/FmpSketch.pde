import processing.video.*;
import gab.opencv.*;
import com.cage.zxing4p3.*;

Capture video;

void setup(){
  size(600,400);
  
  printArray(Capture.list());

  video = new Capture(this,Capture.list()[3]);
  video.start();
};

void captureEvent(Capture video) {
  video.read();
}

void draw(){
  background(0);
  image(video,0,0);
};
