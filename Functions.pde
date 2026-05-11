
void drawLegend() {
  
  
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
  Airport torontoP = new Airport(273, 178, "Toronto Pearson", "Toronto", "Canada", "tp.jpg");
  Airport shanghai = new Airport(836, 198, "Shanghai Pudong International", "Shanghai", "China", "sh.jpg");
  Airport losAngeles = new Airport(166, 184, "Los Angeles International", "Los Angeles", "United States of America", "la.jpg");
  Airport miami = new Airport(277, 212, "Miami International Airport", "Miami", "United States of America", "miami.jpg");

  // add airports to list
  airports.add(torontoP);
  airports.add(shanghai);
  airports.add(losAngeles);
  airports.add(miami);
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
  for (Plane p : planes) {

    // if the user's click was within the search radius, the function returns true
    if (checkObjectOfInterest(p.x_pos, p.y_pos)) {

      // assign values to selected plane and generate the plane window
      selectedPlane = p;
      selectedType = "plane";
      PlaneWindow.setVisible(true);
      
      break;
    }
  }

  //println(mouseX, mouseY, selectedPlane);
}
