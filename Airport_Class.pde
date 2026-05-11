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
    fill(255, 255, 224);
    rect(x_pos, y_pos, 200, 225);

    // use self created image function to resize the airport img to fit the tag
    image(this.img, x_pos + 10, y_pos + 10, 180, 130);

    fill(0);
    text(name + " airport", this.x_pos + 10, this.y_pos + 160);
    text("Location: " + this.city + ", " + this.country, this.x_pos + 10, this.y_pos + 180);
  }
}
