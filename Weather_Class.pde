class Weather {
  String type; //Wind, storm, 
  PVector position, windSpeed, windForce; //Wind speed is how fast it moves on the screen, force is magnitude on the plane
  float radius; //Radius of the weather zone (circular)
  int num_arrows = 25; //How many arrows (visual)
  float[] ax, ay;       // each arrow's position (relative to weather centre)
  float[] angleOffset;  // slight angle variation per arrow so they aren't identical

  Weather(String t, float x, float y, float r) {
    this.type = t;
    this.position = new PVector(x, y);
    this.radius = r;

    
    float randomAngle = random(TWO_PI); //Makes a random wind current angle
    float strength = random(0.5, 2.0); 
    this.windForce = new PVector(cos(randomAngle) * strength, sin(randomAngle) * strength); //Makes the wind based on the random angle
    this.windSpeed = new PVector(windForce.x * 0.3, windForce.y * 0.3);
    
    // spread arrows randomly across the circle to start
    ax = new float[num_arrows]; //Arrow X
    ay = new float[num_arrows]; //Arrow Y
    angleOffset = new float[num_arrows]; //How much off center the arrows will be (for variation)
    for (int i = 0; i < num_arrows; i++) {
      spawnArrow(i, true);
    }
  }

  void spawnArrow(int i, boolean firstSpawn) {
    if (firstSpawn) {
      // fill the whole zone randomly at the start
      float a = random(TWO_PI);
      float r = sqrt(random(1)) * radius;   // sqrt gives even spread in a circle
      ax[i] = cos(a) * r;
      ay[i] = sin(a) * r;
    } 
    else { //After the first big round
      // Re-enter from the upwind edge, spread across the full width
      float upwind = windForce.heading() + PI; //Flips the arrow
      float perp   = windForce.heading() + HALF_PI; //Perpendicular
      float spread = random(-radius, radius);
      ax[i] = cos(upwind) * radius * 0.95 + cos(perp) * spread;
      ay[i] = sin(upwind) * radius * 0.95 + sin(perp) * spread;
    }
    angleOffset[i] = random(-0.2, 0.2);
  }

  void update() {
    position.add(windSpeed);
    //Makes sure the wind goes around the earth rather than off the map (Not working yet)
    if (position.x >  width  + radius) position.x = -radius;
    if (position.x < -radius)          position.x =  width  + radius;
    if (position.y >  height + radius) position.y = -radius;
    if (position.y < -radius)          position.y =  height + radius;

    if (!type.equals("Wind")) return; //Wind only

    for (int i = 0; i < num_arrows; i++) {
      // Move each arrow in the wind direction
      ax[i] += windForce.x * 1.5;
      ay[i] += windForce.y * 1.5;

      float d = sqrt(ax[i]*ax[i] + ay[i]*ay[i]); //Calculate distance from the center of the weather system
      if (d > radius) { //If it has left the circle
        spawnArrow(i, false);
      }
    }
  }

  void drawWind() {
    float baseAngle = windForce.heading(); //Calculate angle
    float arrowLength  = 30; //Arrow length (visual only)

    for (int i = 0; i < num_arrows; i++) {
      float d = sqrt(ax[i]*ax[i] + ay[i]*ay[i]); //Distance from the center again
      float alpha = map(d, radius * 0.5, radius, 200, 0); //Makes the edge arrows fade out
      alpha = constrain(alpha, 0, 200); //alpha is like transparency

      stroke(200, 215, 235, alpha); //Arrow colour
      strokeWeight(1.5);
      noFill();

      pushMatrix(); //This part basically changes the origin to be at and face the same direction as the arrow
        translate(ax[i], ay[i]);
        rotate(baseAngle + angleOffset[i]); //Rotate to face the wind direction
        line(0, 0, arrowLength, 0);
        line(arrowLength, 0, arrowLength - 8,  4);
        line(arrowLength, 0, arrowLength - 8, -4);
      popMatrix(); //Reset for the next arrow
    }
  }
  void affectPlane(Plane p) {
    float d = dist(this.position.x, this.position.y, p.x_pos, p.y_pos);
    if (d < this.radius) {
      if (this.type.equals("Wind")) {
        p.vx += windForce.x * 0.05;
        p.vy += windForce.y * 0.05;
      } 
      else if (this.type.equals("Storm")) { //Not finished
        p.vx *= 0.95;
        p.vy *= 0.95;
      }
    }
  }

  void drawMe() {
    pushMatrix();
    translate(position.x, position.y);
    if (type.equals("Wind")) {
      drawWind();
    } 
    else {
      drawCloud();
    }
    popMatrix();
  }

  

  void drawCloud() {
    noStroke();
    if (type.equals("Storm")) fill(90, 90, 100, 210);
    
    else fill(200, 200, 205, 150); //Regular clouds
    
    circle(0, 0, radius);
    circle(-radius * 0.4, 10, radius * 0.8);
    circle( radius * 0.4,  5, radius * 0.9);
  }
}
