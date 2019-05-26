void matchingLists(){
    for (int i = 0; i < screenPersons.size(); i++) {
      Person p = screenPersons.get(i);
      p.taken = false;
    }
    for (Person cp : boardPawns) {
      float recordD = 100;
      Person matched = null;
      for (Person hp : historyPersons) {
        PVector centerP = cp.getCenter();
        PVector centerCP = hp.getCenter();
        float d = PVector.dist(centerP, centerCP);
        if (d < recordD && hp.taken == false) {
          recordD = d;
          matched = hp;
        }
      }
      if (matched != null) {
        matched.taken = true;
        cp.becomePerson(matched);
      }
    }
    for (int i = 0; i < screenPersons.size(); i++) {
      Person p = screenPersons.get(i);
        if (p.taken == false){
          screenPersons.remove(p);
        }
    }
  }
