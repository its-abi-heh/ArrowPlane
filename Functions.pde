void createWeather() {
  for (int i = 0; i < num_winds; i++) {
    float x = random(width);
    float y = random(height);
    float r = random(80, 200);
    winds[i] = new Weather("Wind", x, y, r);
  }
  
  for (int i = 0; i < num_clouds; i++) {
  float x = random(width);
  float y = random(height);
  float r = random(40, 100);
  clouds[i] = new Weather("Cloud", x, y, r);
  }
}

// calculate compass direction of something
  String getBearing(float x, float y) {
    float bearingAngle = 0;

    // calculate angle based on direction vector
    float angle = degrees(atan2(x, -y));
  
    // keep angle between 0 and 360 (a way to fix the bug we encountered)
    if (angle < 0) {
      angle += 360;
    }
  
    // initialize first and second direction (Ex. N (primary) 10 W (secondary))
    String primary = "";
    String secondary = "";
   
   // direction is NE
    if (angle >= 0 && angle < 90) {
      primary = "N";
      secondary = "E";
      bearingAngle = angle;
    }
  
    // direction is SE
    else if (angle >= 90 && angle < 180) {
      primary = "S";
      secondary = "E";
      bearingAngle = 180 - angle;
    }
  
    // direction is SW
    else if (angle >= 180 && angle < 270) {
      primary = "S";
      secondary = "W";
      bearingAngle = angle - 180;
    }
  
    // direction is NW
    else {
      primary = "N";
      secondary = "W";
      bearingAngle = 360 - angle;
    }
  
    // return final calculated bearing as a string
    return primary + " " + int(bearingAngle) + "° " + secondary;
  }

void createCompass(float x, float y, float size) {

  // Outer circle
  stroke(0);
  fill(240);
  ellipse(x, y, size, size);

  // Labels
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(size * 0.12);

  text("N", x, y - size * 0.42);
  text("S", x, y + size * 0.42);
  text("E", x + size * 0.42, y);
  text("W", x - size * 0.42, y);

  // North needle (red)
  fill(255, 0, 0);
  triangle(
    x, y - size * 0.35,
    x - size * 0.05, y,
    x + size * 0.05, y
  );

  // South needle (gray)
  fill(100);
  triangle(
    x, y + size * 0.35,
    x - size * 0.05, y,
    x + size * 0.05, y
  );

// EAST needle (blue)
  fill(0, 100, 255);
  triangle(
    x + size * 0.35, y,
    x, y - size * 0.05,
    x, y + size * 0.05
  );

  // WEST needle (green)
  fill(0, 180, 100);
  triangle(
    x - size * 0.35, y,
    x, y - size * 0.05,
    x, y + size * 0.05
  );

  // Center dot
  fill(0);
  ellipse(x, y, size * 0.06, size * 0.06);
}

// update the text area box (communication panel) with information on a selected object
void updateInformationBox() {
  String text;
  
  // if the selected item is a plane...
  if (!planes.isEmpty() && selectedPlane != null) {
    
    // set the text to be the retrieved info about the selected plane
    informationBox.setText(selectedPlane.getInfo());
    text = selectedPlane.departure.name + " → " + selectedPlane.arrival.name;
  }
  
  // no plane or wind is selected (null selected type)
  else {
    text = "Select a Plane or Weather Event to see it's information :)";
  }
  
  // updatae communication panel
  selectedPlaneTitle.setText(text);

}

// a handy helper function to check if a user's mouse pos relative to an object
boolean checkObjectOfInterest(float x, float y) {
  return dist(mouseX, mouseY, x, y) <= searchR;
}

// populate airport array list
void createAirports() { 
  
  // define new airports
  Airport torontoP = new Airport(273, 178, "Toronto Pearson", "Toronto", "Canada", "toronto.jpg");
  Airport shanghai = new Airport(836, 198, "Shanghai Pudong International", "Shanghai", "China", "sh.jpg");
  Airport losAngeles = new Airport(166, 184, "Los Angeles International", "Los Angeles", "United States of America", "la.jpg");
  Airport miami = new Airport(277, 212, "Miami International ", "Miami", "United States of America", "miami.jpg");
  Airport newYork = new Airport(292, 170, "John F. Kennedy International", "New York City", "United States of America", "jfk.jpg");
  Airport mexicoCity = new Airport(219, 226, "Mexico City International", "Mexico City", "Mexico", "mexico.jpg");
  Airport saoPaulo = new Airport(384, 364, "São Paulo-Guarulhos International", "São Paulo", "Brazil", "saopaulo.png");
  Airport buenosAires = new Airport(337, 418, "Ezeiza International", "Buenos Aires", "Argentina", "bA.jpg");
  Airport london = new Airport(498, 128, "London Heathrow", "London", "United Kingdom", "london.jpg");
  Airport paris = new Airport(525, 160, "Charles de Gaulle", "Paris", "France", "paris.jpg");
  Airport cairo = new Airport(610, 225, "Cairo International", "Cairo", "Egypt", "cairo.jpg");
  Airport johannesburg = new Airport(592, 348, "O. R. Tambo International", "Johannesburg", "South Africa", "johannesburg.jpg");
  Airport tokyo = new Airport(888, 182, "Tokyo Haneda", "Tokyo", "Japan", "tokyo.jpg");
  Airport dubai = new Airport(654, 217, "Dubai International", "Dubai", "United Arab Emirates", "dubai.jpg");
  Airport sydney = new Airport(919, 408, "Sydney Kingsford Smith", "Sydney", "Australia", "sydney.jpg");
  Airport auckland = new Airport(983, 417, "Auckland", "Auckland", "New Zealand", "auckland.jpg");
  Airport antarctica1 = new Airport(620, 560, "McMurdo Airfield", "McMurdo Station", "Antarctica", "antarctica.jpg");
  Airport southpole = new Airport(700, 575, "Amundsen–Scott South Pole Station", "South Pole", "Antarctica", "southpole.jpg");
 
  // add airports to list
  airports.add(torontoP);
  airports.add(shanghai);
  airports.add(losAngeles);
  airports.add(miami);
  airports.add(newYork);
  airports.add(mexicoCity);
  airports.add(saoPaulo);
  airports.add(buenosAires);
  airports.add(london);
  airports.add(paris);
  airports.add(cairo);
  airports.add(johannesburg);
  airports.add(tokyo);
  airports.add(dubai);
  airports.add(sydney);
  airports.add(auckland);
  airports.add(antarctica1);
  airports.add(southpole);

  println(airports.size());

}

// populate G4P dropdown lists
void createDropdownLists() {
  
  // departure and arrival airports can be any airport in the airports array list
  possibleDestinations = new String[airports.size()];
  
  // display the city to the user in the dropdown list
  for (int i = 0; i < airports.size(); i++) {
    possibleDestinations[i] = airports.get(i).city;
  }
  
  // default option, showing two different locations (can't travel to same airport)
  departureList.setItems(possibleDestinations, 0);
  arrivalList.setItems(possibleDestinations, 1);
  
  // initialize departure, arrival locations so no null pointer exception
  departure = airports.get(0);
  arrival = airports.get(1);
}

// if user clicks, check if an object has been selected
void mousePressed() {

  selectedType = "";  // used to differentiate between selected objects
  selectedPlane = null;

  // check if it is a plane that has been selected
  for (int i = planes.size() - 1; i >= 0; i--) {
      Plane p = planes.get(i);
      
    // if the user's click was within the search radius, the function returns true
    if (checkObjectOfInterest(p.pos.x, p.pos.y)) {

      // assign values to selected plane and generate the plane window
      selectedPlane = p;
      selectedType = "plane";
      PlaneWindow.setVisible(true);
      
      break;
    }
  }

  //println(mouseX, mouseY, selectedPlane);
}
