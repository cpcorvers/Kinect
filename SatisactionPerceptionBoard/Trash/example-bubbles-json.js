This example demonstrates how to use loadJSON() to retrieve data from a JSON file and make objects from that data. * Here is what the JSON looks like (partial):
* { "bubbles": [ { "position": { "x": 160, "y": 103 }, "diameter": 43.19838, "label": "Happy" }, { "position": { "x": 372, "y": 137 }, "diameter": 52.42526, "label": "Sad" } ] }


// An Array of Bubble objects
Bubble[] bubbles;
// A JSON object
JSONObject json;

void setup() {
  size(640, 360);
  loadData();
}

void draw() {
  background(255);
  // Display all bubbles
  for (Bubble b : bubbles) {
    b.display();
    b.rollover(mouseX, mouseY);
  }
  //
  textAlign(LEFT);
  fill(0);
  text("Click to add bubbles.", 10, height-10);
}
 void loadData() {
  // Load JSON file
  // Temporary full path until path problem resolved.
  json = loadJSONObject("data.json");

  JSONArray bubbleData = json.getJSONArray("bubbles");

  // The size of the array of Bubble objects is determined by the total XML elements named "bubble"
  bubbles = new Bubble[bubbleData.size()];

  for (int i = 0; i < bubbleData.size(); i++) {
    // Get each object in the array
    JSONObject bubble = bubbleData.getJSONObject(i);
    // Get a position object
    JSONObject position = bubble.getJSONObject("position");
    // Get x,y from position
    int x = position.getInt("x");
    int y = position.getInt("y");

    // Get diamter and label
    float diameter = bubble.getFloat("diameter");
    String label = bubble.getString("label");

    // Put object in array
    bubbles[i] = new Bubble(x, y, diameter, label);
  }
}

 void mousePressed() {
  // Create a new JSON bubble object
  JSONObject newBubble = new JSONObject();

  // Create a new JSON position object
  JSONObject position = new JSONObject();
  position.setInt("x", mouseX);
  position.setInt("y", mouseY);

  // Add position to bubble
  newBubble.setJSONObject("position", position);

  // Add diamater and label to bubble
  newBubble.setFloat("diameter", random(40, 80));
  newBubble.setString("label", "New label");

  // Append the new JSON bubble object to the array
  JSONArray bubbleData = json.getJSONArray("bubbles");
  bubbleData.append(newBubble);

  if (bubbleData.size() > 10) {
    bubbleData.remove(0);
  }

  // Save new data
  saveJSONObject(json,"data/data.json");
  loadData();
}




// A Bubble class

class Bubble {
  float x,y;
  float diameter;
  String name;

  boolean over = false;

  // Create  the Bubble
  Bubble(float x_, float y_, float diameter_, String s) {
    x = x_;
    y = y_;
    diameter = diameter_;
    name = s;
  }

  // CHecking if mouse is over the Bubble
  void rollover(float px, float py) {
    float d = dist(px,py,x,y);
    if (d < diameter/2) {
      over = true;
    } else {
      over = false;
    }
  }

  // Display the Bubble
  void display() {
    stroke(0);
    strokeWeight(2);
    noFill();
    ellipse(x,y,diameter,diameter);
    if (over) {
      fill(0);
      textAlign(CENTER);
      text(name,x,y+diameter/2+20);
    }
  }
}
