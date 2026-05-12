/*
 * ARROWPLANE- Air Traffic Control Simulator
 * Code Written By:  Zack Boone, Abigail Chan, Fedor Kuznetsov
 * Date Submitted:
 
 * DESCRIPTION: 
*/


import g4p_controls.*;

// VARIABLES
ArrayList<Airport> airports;
ArrayList<Plane> planes;

Airport departure, arrival;
Plane selectedPlane = null;

String[] possibleDestinations;
String selectedType = "";

int[][] appTheme = {{255, 255, 224}, {255, 0, 0}};

boolean started, running;

PImage map;

// USER VARIABLES (Can edit)
float kmScale = 18;
float velocityScale = 320;
int searchR = 10;   // adjust sensitivity of the hover and mouse press funcitons

void setup() {
  
  // load map background image
  map = loadImage("map1.jpg");
  size(1000, 600);
  surface.setLocation(350, 0); // use setLocation to ensure windows don't overlap
  
  // define airports
  airports = new ArrayList<Airport>();
  planes = new ArrayList<Plane>();
  
  // populate airports array list
  createAirports();
  
  // G4P stuff- create command window, plane window is not visible
  createGUI();
  PlaneWindow.setVisible(false);

  // populate dropdown lists on command window
  createDropdownLists();
}

void draw() {

  // draw image background
  image(map, 0, 0, width, height);

  Airport hoveredAirport = null;

  // find hovered airport
  for (Airport a : airports) {
    if (checkObjectOfInterest(a.x_pos, a.y_pos)) {
      hoveredAirport = a;
    }
  }

  // draw tag first
  if (hoveredAirport != null) {
    hoveredAirport.drawTag();
  }

  // draw airport points
  for (Airport a : airports) {

    boolean coveredByTag = false;

    // if a tag exists, check whether this airport is inside tag area
    if (hoveredAirport != null) {

      float tagX = hoveredAirport.x_pos + 15;
      float tagY = hoveredAirport.y_pos - 40;

      float tagW = 140;
      float tagH = 50;

      if (a.x_pos > tagX &&
          a.x_pos < tagX + tagW &&
          a.y_pos > tagY &&
          a.y_pos < tagY + tagH) {

        coveredByTag = true;
      }
    }

    // only draw visible airports
    if (!coveredByTag) {
      a.drawPoint();
    }
  }

  // planes
  if (!started || !running) {

    for (int i = 0; i < planes.size(); i++) {
      Plane p = planes.get(i);
      p.display();
    }

  } else {

    if (running) {

      for (int i = 0; i < planes.size(); i++) {
        Plane p = planes.get(i);

        p.update(planes);
        p.display();
      }
    }
  }

  updateInformationBox();
}
