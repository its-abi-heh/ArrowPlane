/* MAIN
 * ARROWPLANE- Air Traffic Control Simulator
 * Code Written By:  Zack Boone, Abigail Chan, Fedor Kuznetsov
 * Date Submitted:
 
 * DESCRIPTION: 
*/

import g4p_controls.*;

// VARIABLES
ArrayList<Airport> airports;
ArrayList<Plane> planes;

String[] possibleDestinations;
String selectedType = "";

int[][] appTheme = {{255, 255, 224}, {255, 0, 0}, {0, 0, 255}};

boolean started, running, drawCompass;

PImage map;

// USER VARIABLES (Can edit)
float kmScale = 18;
float velocityScale = 320;
int searchR = 10;   // adjust sensitivity of the hover and mouse press funcitons
int num_winds = 3; //Number of wind currents on the map
int num_clouds = 10; //Number of clouds on the map
boolean showClouds = false;

// initialize class objects
Airport departure, arrival;
Plane selectedPlane = null;
Weather[] winds = new Weather[num_winds];
Weather[] clouds = new Weather[num_clouds];

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
  
  // populate weather array list
  createWeather();
  
  // G4P stuff- create command window, plane window is not visible
  createGUI();
  PlaneWindow.setVisible(false);

  // populate dropdown lists on command window
  createDropdownLists();
}

void draw() {

  // draw image background
  image(map, 0, 0, width, height);

  // check boolean to draw compass (controlled by checkbox on G4P window
  if (drawCompass == true) {
      createCompass(100, 100, 100); 
  }
  
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
    
    for (int i = 0; i < num_winds; i++) {
      winds[i].update();
      winds[i].drawMe();
      for (Plane p : planes) {
        winds[i].affectPlane(p);
      }
    }

    if (showClouds) {
      for (int i = 0; i < num_clouds; i++) {
        clouds[i].drawMe();
      }
    }
  }
  
  // the info box displays information to the user and must be updated constantly
  // to check for items of interest
  updateInformationBox();
}
