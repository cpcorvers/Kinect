// snapshot of board with characters (e.g. GausseSense with GausseBits) into ArrayCurrentState
// compare the snapshot with ArrayHistoryState
// Prevent movement on small instability of GausseSense: If change is within 5.0px then no change otherwise add new state to ArrayHistoryState
// Create dataset/Array of movements of Bits on the Sense
// Create improvement of data exchange over client/server
void bitsInArray(GData g, int i) {
  println("bitsInArray started");




  ArrayList<Bit> currentBits = new ArrayList<Bit>();

  // int[] currentGaussBitsList = new int[5];

  ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);//API Demos
  int polarityInt = g.getPolarity(); //Get the polarity in Int. 0: North, 1:South
  int intensity = (int) g.getIntensity(); //Get the intensity. Unit: gauss
  int x = (int) g.getX(); //Get the X coordinate on the display
  int y = (int) g.getY(); //Get the Y coordinate on the display
  // String polarityString = (polarityInt==0 ? "North" : "South" );
  for (int j=0; j<bGaussBitsList.size(); j++) {
    GData bGaussBits = bGaussBitsList.get(j);
    if (intensity>0) {
      // s.write( j + " " + polarityString + " " + (int)intensity + " " + x + " " + y +  " " + ((int)bGaussBits.x*1.5) + " " +((int)bGaussBits.y*1.6875) + "\n" );
      boolean found = false;
      for (Bit b : currentBits) {
        if (b.isNear(x,y)) {
          b.add(x, y); //, intensity, polarityInt);
          found = true;
          break;
        }
      }
      if (!found) {
        Bit b = new Bit(x,y);
        currentBits.add(b);
      }
    }
  } // identification - polarity - intensity - x - y - dispX - dispY
for (Bit b: currentBits) {
  b.show();
}


  println("bitsInArray finished");
  // printArray(currentBitsList);

}

//
//
//
//
//   ArrayList<GData> currentGaussBitsList = new ArrayList<GData>();
//   ArrayList<GData> historyGaussBitsList = new ArrayList<GData>();
//
//
//
// }
//
// //printPointData
//   ArrayList<GData> bGaussBitsList = gsMeta.getBasicGaussBits(thld);//API Demos
//   int polarityInt = g.getPolarity(); //Get the polarity in Int. 0: North, 1:South
//   int intensity = (int) g.getIntensity(); //Get the intensity. Unit: gauss
//   int x = (int) g.getX(); //Get the X coordinate on the display
//   int y = (int) g.getY(); //Get the Y coordinate on the display
//   String polarityString = (polarityInt==0 ? "North" : "South" );
//   for (int j=0; j<bGaussBitsList.size(); j++) {
//     GData bGaussBits = bGaussBitsList.get(j);
//     //if (intensity>0) println(i+":"+polarityString +", BasicGaussBits: ~ " + (int)intensity + " gauss, (x,y)= ("+x+","+y+")" + "(x,y) = "+ ((int)bGaussBits.x*1.5) + "," +((int)bGaussBits.y*1.6875) );
//   }
// // end printPointData
//
//
//   // There are no blobs!
//   if (blobs.isEmpty() && currentBlobs.size() > 0) {
//     println("Adding blobs!");
//     for (Blob b : currentBlobs) {
//       b.id = blobCounter;
//       blobs.add(b);
//       blobCounter++;
//     }
//   } else if (blobs.size() <= currentBlobs.size()) {
//     // Match whatever blobs you can match
//     for (Blob b : blobs) {
//       float recordD = 1000;
//       Blob matched = null;
//       for (Blob cb : currentBlobs) {
//         PVector centerB = b.getCenter();
//         PVector centerCB = cb.getCenter();
//         float d = PVector.dist(centerB, centerCB);
//         if (d < recordD && !cb.taken) {
//           recordD = d;
//           matched = cb;
//         }
//       }
//       matched.taken = true;
//       b.become(matched);
//     }
//
//     // Whatever is leftover make new blobs
//     for (Blob b : currentBlobs) {
//       if (!b.taken) {
//         b.id = blobCounter;
//         blobs.add(b);
//         blobCounter++;
//       }
//     }
//   } else if (blobs.size() > currentBlobs.size()) {
//     for (Blob b : blobs) {
//       b.taken = false;
//     }
//
//
//     // Match whatever blobs you can match
//     for (Blob cb : currentBlobs) {
//       float recordD = 1000;
//       Blob matched = null;
//       for (Blob b : blobs) {
//         PVector centerB = b.getCenter();
//         PVector centerCB = cb.getCenter();
//         float d = PVector.dist(centerB, centerCB);
//         if (d < recordD && !b.taken) {
//           recordD = d;
//           matched = b;
//         }
//       }
//       if (matched != null) {
//         matched.taken = true;
//         matched.become(cb);
//       }
//     }
//
//     for (int i = blobs.size() - 1; i >= 0; i--) {
//       Blob b = blobs.get(i);
//       if (!b.taken) {
//         blobs.remove(i);
//       }
//     }
//   }
//
//   for (Blob b : blobs) {
//     b.show();
//   }
