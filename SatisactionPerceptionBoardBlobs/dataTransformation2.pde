// // boardPawns is the RealTime Arraylist from the PerceptionBoard
// // screenPersons is the NearRealTime Arraylist for the SecondScreen
// // historyPersons is the OldTime or Backup Arraylist for logbook purpose
//
// // A pawn on the PerceptionBoard becomes:
// // 1. a RealTime visual on the board screen ;
// // 2. a NearRealTime visual on the second screen ;
// // 3. a History item in the logbook .
//
// // ArrayList<Person> currentPersons = new ArrayList<Person>();
//
// // There are pawns but no visuals on the screen!
// void dataTransformation() {
//   if (screenPersons.isEmpty() && boardPawns.size() > 0) {
//     // println("Adding persons!");
//     for (Person cp : boardPawns) {
//       if (cp.taken == false){
//         cp.giveIdentity();
//         cp.taken = true;
//         screenPersons.add(cp);
//       }
//     }
//     // Remove matched pawn out of the list
//     for (int i = 0; i < boardPawns.size(); i++) {
//       Person cp = boardPawns.get(i);
//       if (cp.taken == false) {
//         boardPawns.remove(i);
//       }
//     }
//
//
//
//     // There are equal or more pawns on the board as screen visuals!
//     } else if (screenPersons.size() <= boardPawns.size() && boardPawns.size() > 0) {
//       // println("debug dataTransformation");
//       for (int i = 0; i < screenPersons.size(); i++) {
//         Person p = screenPersons.get(i);
//         p.taken = false;
//       }
//       // for (int i = 0; i < screenPersons.size(); i++) {
//       //   Person p = screenPersons.get(i);
//       //   println(p.recordD);
//       // }
//       // Match whatever pawns you can match
//       for (Person p : screenPersons) {
//         float recordD = 1000;
//         float d = 1000;
//         Person matched = null;
//         for (Person cp : boardPawns) {
//           for (int i = 0; i < boardPawns.size(); i++) {
//             Person pi = boardPawns.get(i);
//             pi.taken = false;
//           }
//           // cp.taken = false;
//           PVector centerP = p.getCenter();
//           PVector centerCP = cp.getCenter();
//           d = PVector.dist(centerP, centerCP);
//           if (d < recordD && cp.taken == false) {
//             recordD = d;
//             matched = cp;
//             matched.recordD = recordD;
//             cp.taken = true;
//           }
//         }
//         if (matched != null) {
//           // p.giveIdentity();
//           matched.taken = true;
//           p.becomePerson(matched);
//         }
//       }
//       // There are less pawns on the board as screen visuals!
//       // Remove unmatched visuals on screen
//       for (int i = 0; i < screenPersons.size(); i++) {
//         Person p = screenPersons.get(i);
//         if (p.taken == false) {
//           screenPersons.remove(i);
//         }
//       }
//       // Remove unmatched pawns in the list
//       for (int i = 0; i < boardPawns.size(); i++) {
//         Person cp = boardPawns.get(i);
//         if (cp.taken == false) {
//           boardPawns.remove(i);
//         }
//       }
//
//
//   // pawns are removed from the board list
//   } else if (screenPersons.size() > boardPawns.size() && boardPawns.size() > 0) {
//     // println("debug dataTransformation");
//     for (int i = 0; i < screenPersons.size(); i++) {
//       Person p = screenPersons.get(i);
//       p.taken = false;
//     }
//     // for (int i = 0; i < screenPersons.size(); i++) {
//     //   Person p = screenPersons.get(i);
//     //   println(p.recordD);
//     // }
//     // Match whatever pawns you can match
//     for (Person p : screenPersons) {
//       float recordD = 1000;
//       float d = 1000;
//       Person matched = null;
//       for (Person cp : boardPawns) {
//         for (int i = 0; i < boardPawns.size(); i++) {
//           Person pi = boardPawns.get(i);
//           pi.taken = false;
//         }
//         // cp.taken = false;
//         PVector centerP = p.getCenter();
//         PVector centerCP = cp.getCenter();
//         d = PVector.dist(centerP, centerCP);
//         if (d < recordD && cp.taken == false) {
//           recordD = d;
//           matched = cp;
//           matched.recordD = recordD;
//           cp.taken = true;
//         }
//       }
//       if (matched != null) {
//         // p.giveIdentity();
//         matched.taken = true;
//         p.becomePerson(matched);
//       }
//     }
//     // There are less pawns on the board as screen visuals!
//     // Remove unmatched visuals on screen
//     for (int i = 0; i < screenPersons.size(); i++) {
//       Person p = screenPersons.get(i);
//       if (p.taken == false) {
//         screenPersons.remove(i);
//       }
//     }
//   } else if (screenPersons.size() > 0 && boardPawns.isEmpty() ) {
//     for (int i = 0; i < screenPersons.size(); i++) {
//       Person p = screenPersons.get(i);
//       screenPersons.remove(i);
//     }
//   }
// }
//       // // Remove unmatched pawns in the list
//       // for (int i = 0; i < boardPawns.size(); i++) {
//       //   Person cp = boardPawns.get(i);
//       //   if (cp.taken == false) {
//       //     boardPawns.remove(i);
//       //   }
//       // }
//   // } else if (screenPersons.size() < boardPawns.size()) {
//   //
//   //   for (Person p : screenPersons) {
//   //     p.taken = false;
//   //     float recordD = 1000;
//   //     Person matched = null;
//   //     for (Person cp : boardPawns) {
//   //       cp.taken = false;
//   //       PVector centerP = p.getCenter();
//   //       PVector centerCP = cp.getCenter();
//   //       float d = PVector.dist(centerP, centerCP);
//   //       if (d < recordD && !cp.taken) {
//   //         recordD = d;
//   //         matched = cp;
//   //         cp.taken = true;
//   //       }
//   //     }
//   //     if (matched != null) {
//   //       // p.giveIdentity();
//   //       matched.taken = true;
//   //       p.becomePerson(matched);
//   //       // Remove matched pawn out of the list
//   //       for (int i = 0; i < boardPawns.size(); i++) {
//   //         Person cp = boardPawns.get(i);
//   //         if (cp.taken == false) {
//   //           boardPawns.remove(i);
//   //         }
//   //       }
//   //     }
//   //   }
//   //   for (Person cp : boardPawns) {
//   //     if (cp.taken == false){
//   //       cp.giveIdentity();
//   //       cp.taken = true;
//   //       screenPersons.add(cp);
//   //     }
//   //   }
//   // }
//
//
//
//
//
//
//   //   for (Person p : screenPersons) {
//   //     p.taken = false;
//   //   }
//   //   // Match whatever blobs you can match
//   //   for (Person cp : boardPawns) {
//   //     float recordD = 1000;
//   //     Person matched = null;
//   //     for (Person p : screenPersons) {
//   //       PVector centerP = p.getCenter();
//   //       PVector centerCP = cp.getCenter();
//   //       float d = PVector.dist(centerP, centerCP);
//   //       if (d < recordD && !p.taken) {
//   //         recordD = d;
//   //         matched = p;
//   //       }
//   //     }
//   //     if (matched != null) {
//   //       matched.taken = true;
//   //       matched.becomePerson(cp);
//   //     }
//   //   }
//   //   for (Person p : screenPersons) {
//   //     if (p.taken == false) {
//   //       screenPersons.remove(p);
//   //       println("debug");
//   //     }
//   //   }
//   //
//   //   // for (int i = screenPersons.size() - 1; i >= 0; i--) {
//   //   //   Person p = screenPersons.get(i);
//   //   //   if (!p.taken) {
//   //   //     screenPersons.remove(i);
//   //   //   }
//   //   // }
//   // }
//
//
//
//   // show the person on a location with a background.
//   // image(perspectives, 0, 0, 1280, 800);
//   // for (Person p : screenPersons){
//   //   p.showPerson();
//   // }
//
//
// void dataVisualisation() {
//   // show every person which is taken==true
//   for (Person p : boardPawns) {
//     // if ( p.pawn_polarity == 0) { //p.taken == true &&
//       p.getPawnCenter();
//       p.showPawn(p.pawnCenterX, p.pawnCenterY, p.identity, p.direction);
//       // p.showPerson();
//     // }
//   }
// }
