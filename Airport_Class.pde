// AIRPORT CLASS

class Airport {

  // VARIABLES & FIELDS
  float x_pos, y_pos;

  PImage img;

  String name;
  String city;
  String country;

  // color point differently depending on state (hover vs no hover)
  int[] ptColor = appTheme[0];

  // CONSTRUCTOR
  Airport(float x, float y, String n, String c, String c2, String fp) {
    this.x_pos = x;
    this.y_pos = y;

    this.name = n;
    this.city = c;
    this.country = c2;

    // load image 
    this.img = loadImage(fp);
  }

  // METHODS
  // used to draw the location of the airport on screen
  void drawPoint() {
    fill(ptColor[0], ptColor[1], ptColor[2]);
    circle(this.x_pos, this.y_pos, 10);
  }

  // used to display information about the airports to the user
  void drawTag() {
    float tagWidth = 200;
    float tagHeight = 225;
    float tagX = x_pos;
    float tagY = y_pos;

    // if tag would go below screen, draw upward
    if (tagY + tagHeight > height) {
      tagY = y_pos - tagHeight;
    }
  
    // prevent going above screen
    if (tagY < 0) {
      tagY = 0;
    }
  
    // if tag would go off right side
    if (tagX + tagWidth > width) {
      tagX = width - tagWidth;
    }
  
    // prevent going off left side
    if (tagX < 0) {
      tagX = 0;
    }
  
    fill(255, 255, 224);
    rect(tagX, tagY, tagWidth, tagHeight);
    image(this.img, tagX + 10, tagY + 10, 180, 130);
    fill(0);
    textAlign(LEFT, TOP);
    
    text(name + " airport", tagX + 10, tagY + 145, 180, 40);
    text("Location: " + city + ", " + country, tagX + 10, tagY + 175, 180, 50);  
  }
}
