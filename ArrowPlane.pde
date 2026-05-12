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

int[][] appTheme = {{255, 255, 224}, {255, 0, 0}, {0, 0, 255}};

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

  // draw airports
  for (Airport a : airports) {
    a.drawPoint();
    
    // if user has hovered over the airport, display tag information
    if (checkObjectOfInterest(a.x_pos, a.y_pos)) {
     a.drawTag(); 
    }
  }

  // draw planes whenever they are added
  if (!started || !running) {

    for (int i = 0; i < planes.size(); i++) {
      Plane p = planes.get(i);
      p.display();
    }
  }
  else {
    
    // if the simulation is running
    if (running) {
      
      // for each plane, update their position and draw them on screen
      for (int i = 0; i < planes.size(); i++) {
        Plane p = planes.get(i);

        p.update(planes);
        p.display();
      }
    }
  }
  
  // the info box displays information to the user and must be updated constantly
  // to check for items of interest
  updateInformationBox();
}
