// PLANE CLASS
// change this.x_pos to pVector
class Plane {

  // VARIABLES & FIELDS
  
  // Airport objects for the starting and ending airports
  Airport departure, arrival;
  
  // Stores all previous positions of the plane
  // Used to draw the green trail behind the aircraft
  ArrayList<PVector> trail;

  String departureName, arrivalName;
  String bearing = "CURRENTLY BOARDING";       // Current compass direction of the plane
  
  // velocity = combined components vx, vy
  float x_pos, y_pos, vx, vy, speed, velocity, 
        dx, dy, d, searchRadius, aggression;
  float totalDistanceTravelled = 0;
  float elapsedHours = 0;      // time spent traveling
  float planeSize = 30;
  boolean visible, showPath, showTrail, showRadius, arrived;
  boolean avoidPlanes = true;
  boolean avoidWeather = true;
  
  PImage planeImg;
  
  // CONSTRUCTOR
  Plane(Airport d, Airport a, String fp) {
    this.planeImg = loadImage(fp);
    this.visible = true;
    this.showPath = false;
    this.showTrail = true;
    this.showRadius = false;
    
    // can be adjusted in Plane g4p window
    this.searchRadius = 60;
    this.speed = 2;
    this.aggression = 0.5;

    // store departure and arrival airports
    this.departure = d;
    this.arrival = a;

    // plane starts at departure airport coordinates
    x_pos = departure.x_pos;
    y_pos = departure.y_pos;

    // create trail ArrayList and add the starting point
    trail = new ArrayList<PVector>();
    trail.add(new PVector(x_pos, y_pos));
  }
  // METHODS

  // move the plane
  void update(ArrayList<Plane> otherPlanes) {

    // variables defining where we want to go
    float targetX = arrival.x_pos;
    float targetY = arrival.y_pos;

    // variables to calculate how far we still have to fly
    dx = targetX - x_pos;
    dy = targetY - y_pos;
    d = dist(x_pos, y_pos, targetX, targetY);
    
    // plane will stop moving once it has arrived
    if (arrived) {
      return;
    }
   
    // create a normalized direction vector (|d| = 1) and use it to calculate bearing later on
    if (d > 0) {
      dx = dx/d;
      dy = dy/d;
    }

    // velocity must have a direction and a speed
    vx = dx * speed;
    vy = dy * speed;

    // change vx velocity to avoid any weather events that may be occuring
    if (avoidWeather) {
      vx += sin(frameCount * 0.03) * 0.05;
      vy += sin(frameCount * 0.03) * 0.05;
    }

    // avoid other planes using another method
    if (avoidPlanes) {
      checkPlanes(otherPlanes);
    }

    // update plane position
    x_pos += vx;
    y_pos += vy;

    // update calculations like velocity/time/bearing
    updateFlightMetrics();

    // save current position into trail
    trail.add(new PVector(x_pos, y_pos));

    //the plane position will probably never be exactly the same as the arrival location
    // but if it is close enough, then mark it as arrived
    float arrivalDistance = dist(x_pos, y_pos, arrival.x_pos, arrival.y_pos);
    if (arrivalDistance < 10) {
      arrived = true;
    }
  }

  void updateFlightMetrics() {
    
    // calculate the magnitude of velocity using the pythagorean theorum and 
    // the components of velocity
    velocity = sqrt(vx * vx + vy * vy);

    // calculate instantaneous distance flown within this current frame
    float instDistance = dist(x_pos, y_pos, x_pos - vx, y_pos - vy);

    // add instantaneous distance to total travelled distance
    totalDistanceTravelled += instDistance;

    // convert pixels into km, since it isn't to scale
    float kmTravelled = totalDistanceTravelled * kmScale;

    // calculate elapsed travel time = d/velocity
    elapsedHours = kmTravelled / (velocity * velocityScale);

    // calculate bearing using another method
    bearing = getBearing();
  }

  // check for other planes to try and avoid collisions
  void checkPlanes(ArrayList<Plane> otherPlanes) {

    // check all other planes
    for (Plane other : otherPlanes) {

      // for every plane that isn't itself...
      if (other != this) {

        // calculate distance between planes, and if the plane is close by...
        float d = dist(x_pos, y_pos, other.x_pos, other.y_pos);
        if (d < searchRadius) {

          // avoid vertically
          if (x_pos < other.x_pos) {
            
            // agression value is how much the pilot will avoid other planes
            vx -= this.aggression;
          } else {
            vx += this.aggression;
          }

          // avoid horizontally
          if (y_pos < other.y_pos) {
            vy -= this.aggression;
          } else {
            vy += this.aggression;
          }
        }
      }
    }
  }

  // draw the plane and other effects (trail, desired path, e.t.c)
  void display() {
  
    // calculate plane rotation angle = arctan(vy/vx)
    float angle = atan2(vy, vx);

    // draw direct path from departure to arrival airport as a GREEN line
    if (showPath) {
      stroke(0, 255, 0);
      strokeWeight(2);
      line(departure.x_pos, departure.y_pos, arrival.x_pos, arrival.y_pos);
    }

    // draw exhaust trail as WHITE line
    if (showTrail) {

      stroke(255);
      strokeWeight(2);
      noFill();
      
      // because the trail may not be linear, use Shape
      beginShape();

      // draw every saved trail point
      for (PVector point : trail) {
        vertex(point.x, point.y);
      }

      endShape();
    }


    // draw the searchRadius circle which is used to detect other objects
    if (showRadius) {
      noFill();
      stroke(0, 255, 255);
      circle(x_pos, y_pos, searchRadius * 2);
    }
    
    // draw the actual plane
    if (visible) {    
      // use push and pop matrix to rotate the image
      pushMatrix();
      
      translate(x_pos, y_pos);
      rotate(angle);
      imageMode(CENTER);
      image(this.planeImg, 0, 0, 30, 30);
      
      popMatrix();
    
      // default image mode is corner for drawing the map;
      // since draw() is on loop, this is needed
      imageMode(CORNER);
    }
    
    // draw arrowhead if plane is not visible (ARROWPLANE >:])
    else {
      fill(appTheme[2][0], appTheme[2][1], appTheme[2][2]);
      
      pushMatrix();
    
      translate(x_pos, y_pos);
      rotate(angle);
      triangle(12, 0, -8, -6, -8, 6);
    
      popMatrix();
    }
  }

  // calculate compass direction of the plane
  String getBearing() {
    float bearingAngle = 0;

    // calculate angle based on direction vector
    float angle = degrees(atan2(dx, -dy));
  
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
  
  // used to update the communication panel if selected object is a plane
  String getInfo() {
    String info = "";

    info += ("PLANE #: " + str(int(planes.indexOf(this))+1)) + "\n";
    info += "DEPARTURE: " + this.departure.name + " Airport\n";
    info += "ARRIVAL: " + this.arrival.name + " Airport\n\n";
    info += "VELOCITY: " + nf(velocity * velocityScale, 0, 0) + " km/h\n";
    info += "BEARING: " + bearing + "\n";
    info += "TRAVEL TIME: " + nf(elapsedHours, 0, 1) + " hrs\n\n";
    info += "STATUS: ";

    if (arrived) {
      info += "ARRIVED";
    } 
    else if (this.x_pos == this.departure.x_pos) {
      info += "CURRENTLY BOARDING";
    }
    else {
      info += "IN FLIGHT";
    }
    return info;
  }
}
