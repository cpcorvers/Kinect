// (historyPersons) boardPersons is the RealTime Arraylist from the PerceptionBoard
// (currentPersons) screenPersons is the NearRealTime Arraylist for the SecondScreen
// historyPersons is the OldTime or Backup Arraylist for logbook purpose

// A pawn on the PerceptionBoard becomes:
// 1. a RealTime visual on the board screen ;
// 2. a NearRealTime visual on the second screen ;
// 3. a History item in the logbook .

// ArrayList<Person> currentPersons = new ArrayList<Person>();

// There are pawns but no visuals on the screen!

void secondScreenInteraction() {
  if (screenPersons.isEmpty() && boardPersons.size() > 0) {
    // println("Adding persons!");
    for (Person p : boardPersons) {
      p.pawn_ID = personCounter;
      screenPersons.add(p);
      personCounter++;
    }
  // There are equal or more pawns on the board as screen visuals!
  } else if (screenPersons.size() <= boardPersons.size()) {
    // Match whatever blobs you can match
    for (Person p : screenPersons) {
      float recordD = 1000;
      Person matched = null;
      for (Person cp : boardPersons) {
        PVector centerP = p.getCenter();
        PVector centerCP = cp.getCenter();
        float d = PVector.dist(centerP, centerCP);
        // println(d);
        if (d < recordD && !cp.taken) {
          recordD = d;
           matched = cp;
        }
      }
      if (matched != null) {
        matched.taken = true;
        p.becomePerson(matched);
      }
    }
    // There are less pawns on the board as screen visuals!
    // Whatever is leftover make new blobs
    for (Person p : screenPersons) {
      if (!p.taken) {
        p.pawn_ID = personCounter;
        screenPersons.add(p);
        personCounter++;
      }
    }
  } else if (screenPersons.size() > boardPersons.size()) {

    for (Person p : screenPersons) {
      p.taken = false;
    }

    // Match whatever blobs you can match
    for (Person cp : boardPersons) {
      float recordD = 1000;
      Person matched = null;
      for (Person p : screenPersons) {
        PVector centerP = p.getCenter();
        PVector centerCP = cp.getCenter();
        float d = PVector.dist(centerP, centerCP);
        if (d < recordD && !p.taken) {
          recordD = d;
          matched = p;
        }
      }
      if (matched != null) {
        matched.taken = true;
        matched.becomePerson(cp);
      }
    }
    for (int i = screenPersons.size() - 1; i >= 0; i--) {
      Person p = screenPersons.get(i);
      if (!p.taken) {
        screenPersons.remove(i);
      }
    }
  }

  // show the person on a location with a background.
  image(perspectives, 0,0,1280,800);
  for (Person p : screenPersons){
    p.show();
  }

  // Avoiding full of memory exeption by restricting the size of the boardPersons ArrayList
  if (boardPersons.size() > 1000) {
    // println("boardPerson size is above 1000");
    boardPersons.remove(0);
  }

}
