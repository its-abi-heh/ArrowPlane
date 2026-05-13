// PLANE CLASS

class Plane {

  // VARIABLES & FIELDS
  
  // airport objects for the starting and ending airports
  Airport departure, arrival;
  
  // stores all previous positions of the plane
  // used to draw the green trail behind the aircraft
  ArrayList<PVector> trail;

  String departureName, arrivalName, bearing;
  
  // velocity = combined components vx, vy
  float vx, vy, speed, velocity, 
        dx, dy, d, searchRadius, aggression;
        
  float totalDistanceTravelled = 0;
  float elapsedHours = 0;      // time spent traveling
  float planeSize = 30;
  
  boolean visible, showPath, showTrail, showRadius, arrived;
  boolean avoidPlanes = true;
  boolean avoidWeather = true;

  // use PVectors for position and velocity
  PVector pos;
  PVector vel;
  
  PImage planeImg;
  
  // CONSTRUCTOR
  Plane(Airport d, Airport a, String fp) {
    this.planeImg = loadImage(fp);
    this.visible = true;
    this.showPath = false;
    this.showTrail = true;
    this.showRadius = false;
    this.bearing = "CURRENTLY BOARDING";
    
    // can be adjusted in Plane g4p window
    this.searchRadius = 60;
    this.speed = 2;
    this.aggression = 0.5;

    // store departure and arrival airports
    this.departure = d;
    this.arrival = a;

    // plane starts at departure airport coordinates
    pos = new PVector(departure.x_pos, departure.y_pos);

    // velocity vector
    vel = new PVector(0, 0);

    // create trail ArrayList and add the starting point
    trail = new ArrayList<PVector>();
    trail.add(pos.copy());
  }
  
  // METHODS

  // move the plane
  void update() {

    // variables defining where we want to go
    float targetX = arrival.x_pos;
    float targetY = arrival.y_pos;

    // variables to calculate how far we still have to fly
    dx = targetX - pos.x;
    dy = targetY - pos.y;
    d = dist(pos.x, pos.y, targetX, targetY);
    
    // plane will stop moving once it has arrived
    if (arrived) {
      return;
    }
   
    // create a normalized direction vector (|d| = 1) and use it to calculate bearing later on
    if (d > 0) {
      dx = dx/d;
      dy = dy/d;
    }

    // desired velocity toward destination
    PVector desired = new PVector(dx * speed, dy * speed);

    // move velocity by 3% closer to the velocity we want every frame that is run 
    vel.lerp(desired, 0.03);

    // avoid other planes using another method
    if (avoidPlanes) {
      checkPlanes();
    }

    // update plane position
    pos.add(vel);

    // store velocity components
    vx = vel.x;
    vy = vel.y;

    // update calculations like velocity/time/bearing
    updateFlightMetrics();

    // save current position into trail but only every 3 frames to reduce the lag time
    if (frameCount % 3 == 0) {
      trail.add(pos.copy());
    }
    if (trail.size() > 300) {
      trail.remove(0);
    }

    //the plane position will probably never be exactly the same as the arrival location
    // but if it is close enough, then mark it as arrived
    float arrivalDistance = dist(pos.x, pos.y, arrival.x_pos, arrival.y_pos);
    
    if (arrivalDistance < 10) {
      arrived = true;
    }
  }

  void updateFlightMetrics() {
    
    // calculate the magnitude of velocity using the pythagorean theorum and 
    // the components of velocity
    velocity = sqrt(vx * vx + vy * vy);

    // calculate instantaneous distance flown within this current frame
    float instDistance = velocity;

    // add instantaneous distance to total travelled distance
    totalDistanceTravelled += instDistance;

    // convert pixels into km, since it isn't to scale
    float kmTravelled = totalDistanceTravelled * kmScale;

    // calculate elapsed travel time = d/velocity
    elapsedHours = kmTravelled / (velocity * velocityScale);

    // calculate bearing using another method
    this.bearing = getBearing(dx, dy);
  }

  // check for other planes to try and avoid collisions
  void checkPlanes() {

    // check all other planes
    for (int i = planes.size() - 1; i >= 0; i--) {
      Plane other = planes.get(i);
      
      // for every plane that isn't itself...
      if (other != this && !other.arrived) {

        // calculate distance between planes, and if the plane is close by...
        float d = dist(pos.x, pos.y, other.pos.x, other.pos.y);
        
        if (d < searchRadius) {

          // avoid vertically
          if (pos.x < other.pos.x) {
            
            // agression value is how much the pilot will avoid other planes
            vel.x -= this.aggression;
            
          } else {
            vel.x += this.aggression;
          }

          // avoid horizontally
          if (pos.y < other.pos.y) {
            vel.y -= this.aggression;
            
          } else {
            vel.y += this.aggression;
          }
        }
      }
    }
  }

  // draw the plane and other effects (trail, desired path, e.t.c)
  void display() {
  
    // calculate plane rotation angle = arctan(vy/vx)
    float angle = atan2(vy, vx);

    // draw direct path from departure to arrival airport as a green line
    if (showPath) {
      stroke(0, 255, 0);
      strokeWeight(2);
      line(departure.x_pos, departure.y_pos, arrival.x_pos, arrival.y_pos);
    }

    // draw exhaust trail as white line
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
      circle(pos.x, pos.y, searchRadius * 2);
    }
    
    // draw the actual plane
    if (visible) {    
    
      // use push and pop matrix to rotate the image
      pushMatrix();
      
      translate(pos.x, pos.y);
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
    
      translate(pos.x, pos.y);
      rotate(angle);
      triangle(12, 0, -8, -6, -8, 6);
    
      popMatrix();
    }
  }
  
  // used to update the communication panel if selected object is a plane
  String getInfo() {
    String info = "";

    info += ("PLANE #: " + str(int(planes.indexOf(this))+1)) + "\n";
    info += "DEPARTURE: " + this.departure.name + " Airport\n";
    info += "ARRIVAL: " + this.arrival.name + " Airport\n\n";
    info += "VELOCITY: " + nf(velocity * velocityScale, 0, 0) + " km/h\n";
    info += "BEARING: " + this.bearing + "\n";
    info += "TRAVEL TIME: " + nf(elapsedHours, 0, 1) + " hrs\n\n";
    info += "STATUS: ";

    if (arrived) {
      info += "ARRIVED";
    } 
    
    else if (pos.x == this.departure.x_pos) {
      info += "CURRENTLY BOARDING";
    }
    
    else {
      info += "IN FLIGHT";
    }
    
    return info;
  }
}
