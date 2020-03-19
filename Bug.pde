class BugStats {
  int maxEnergy;
  int matingTimer;
  int maxAge;
  
  BugStats() {
    this.maxEnergy = 5000;
    this.matingTimer = 0;
    this.maxAge = 10000;
  }
  BugStats setMaxEnergy(int n) {
    this.maxEnergy = n;
    return this;
  }
  BugStats setMatingTimer(int n) {
    this.matingTimer = n;
    return this;
  }
  BugStats setMaxAge(int a) {
    this.maxAge = a;
    return this;
  }
}

class Bug {
  
  BugStats stats;
  
  private final float bugWidth = 30;
  private final float bugHeight = 40;
  private final double precision = 0.000001;
  
  private float velocityValue = 5;
  private float rotationValue = (TWO_PI / 36);
  
  float energy;
  boolean colidesWithBug;
  float rotationAngle;
    
  int timeAlive;
  int foodAten;
  int timeBugColided;
  float travelDist;
  
  boolean hasAi;
  
  private Point prePos;
  private Point curPos;
  
  Mind mind;
  Rectangle bugShape;
  Rectangle coliderBox;
  
  Line[] bugAntenas;
  int antenaCount = 2;
  float antenaLength = 15;
  float antenaSpred = PI/6;
  
  color bugColor;
  Bug(JSONArray parentBrain) {
    this(true, true, parentBrain, 0.1);
  }
  Bug(boolean load) {
    this(true, load, null, 0.1);
  }
  Bug(boolean ai, boolean load, JSONArray brainStruct, double mutation) {
    this.stats = new BugStats();
    this.hasAi = ai;
    
    int inputs = 4; 
    int outputs = 2;
    int[] layers = {3, 3};
    if(brainStruct != null) mind = new Mind(brainStruct, 0.5);
    else if(load) mind = new Mind(loadJSONArray("Mind/test2.txt"), mutation);
    else mind = new Mind(inputs, outputs, layers);
    
    float valD = 1000;
    bugShape = new Rectangle(new Point(random(-valD, valD), random(-valD, valD)), bugWidth, bugHeight);
    //bugShape = new Rectangle(new Point(0, 0), bugWidth, bugHeight);
    coliderBox = new Rectangle(new Point(), bugShape.getDiagonal());
    bugAntenas = new Line[antenaCount];
  }
  
  private void initSensorBoxes() {
  }
  void init() {
    this.init(bugShape.getCenterPoint(), (int)(this.stats.maxEnergy / 3));
  }
  void init(Point pos, float ene) { // Todo setting bug size and specs
    this.initSensorBoxes();
    
    this.energy = ene;
    this.timeAlive = 0;
    this.timeBugColided = 0;
    this.travelDist = 0;
    this.colidesWithBug = false;
    
    this.prePos = pos;
    this.curPos = pos;
    
    this.bugColor = color(random(100, 200), random(50, 100), random(10, 50));
    
    this.rotationAngle = random(0, TWO_PI);
  }
  
  void update(ArrayList<Bug> bugEntities) {
    if(this.hasAi) {
      // TODO Bug input updates to the mind
      // TODO Implement proper sensor update system using antenas
      // TEMP ->
      if(random(0, 1) > 0.9) this.mind.updateInput(0);
      this.mind.updateInput(1, this.energy / this.stats.maxEnergy);
      if(this.colidesWithBug) this.mind.updateInput(2);
      this.mind.updateInput(3, this.timeAlive / this.stats.maxAge);
      // <- TEMP
      
      this.mind.update();
      
      // TODO getting Bug outputs from mind
      // TEMP ->
      
      if(this.energy > (this.stats.maxEnergy * 0.8)) {
        this.offspring(bugEntities);
        print("Ofspringing\n");
      }
      double velocity = this.mind.getOutput(0) * this.velocityValue;
      double rotation = this.mind.getOutput(1) * this.rotationValue;
      if(this.colidesWithBug) {
        velocity *= 0.2;
        rotation *= 0.5;
        this.timeBugColided++;
      }
      
      if(velocity > this.precision || velocity < - this.precision) {
        float a = this.getRotationAngle();
        Point p0 = this.bugShape.getCenterPoint();
        Point p1 = new Point((float)(cos(a) * velocity + p0.getX()), (float)(sin(a) * velocity + p0.getY()));
        this.bugShape.setCenterPoint(p1);
        this.energy = this.colidesWithBug ? (float)(this.energy - Math.abs(velocity * 2.0)) : (float)(this.energy - Math.abs(velocity));
      }
      if(rotation > this.precision || rotation < - this.precision) {
        this.rotationAngle += rotation;
        energy = colidesWithBug ? (float)(energy - Math.abs(rotation * 1.1)) : (float)(energy - Math.abs(rotation));
      }
      
      // TODO proper energy system for rewarding
      this.coliderBox.setCenterPoint(this.bugShape.getCenterPoint());
      timeAlive++;
      updateTravelDistance();
      energy--;
    }
  }
  
   JSONArray getNeuronStructure() {
    return mind.getNeuronStructure(); // TODO Change mind saving string
  }
  
  void colidesWithBug(boolean t) {
    this.colidesWithBug = t;
  }
  
  void colidedWithFood() {
    this.energy += 3000;
    print(this.energy + "\n");
    if(this.energy > this.stats.maxEnergy) this.energy = this.stats.maxEnergy;
    foodAten++;
  }
  
  private void updateTravelDistance() {
    curPos = new Point(bugShape.getCenterPoint());
    float dx = prePos.getX() - curPos.getX();
    float dy = prePos.getY() - curPos.getY();
    float d = sqrt(dx * dx + dy * dy);
    travelDist += d;
    prePos = new Point(bugShape.getCenterPoint());
  }
  
  private void offspring(ArrayList<Bug> bugs) {
    Bug child;
    child = new Bug(this.getNeuronStructure());
    child.init(this.curPos, this.stats.maxEnergy * 0.3);
    this.energy -= this.stats.maxEnergy * 0.3;
    bugs.add(child);
  }
  
  
  
  boolean isAlive() {
    return this.energy > 0 && this.timeAlive < this.stats.maxAge;
  }
  Rectangle getBugShape() {
    return bugShape;
  }
  Rectangle getCollisionBox() {
    Rectangle box = new Rectangle(this.coliderBox);
    box.setCenterPoint(this.bugShape.getCenterPoint());
    return box;
  }
  color getBugColor() {
    return bugColor;
  }
  float getRotationAngle() {
    return this.rotationAngle;
  }
  double getEfficiency() {
    double eff = this.timeAlive / 10 + this.travelDist + this.foodAten * 10 - this.timeBugColided * 2;
    return eff;
  }
}
