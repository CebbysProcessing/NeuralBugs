class BugHandler {
  
  // TODO list with previous species names
  
  ArrayList<Bug> bugs;
  int bugCount;
  JSONArray bestNeuronStructure;
  
  double bestEff;
  
  FoodHandler foodHandler;
  
  BugHandler() {
    bugs = new ArrayList<Bug>();
  }
  
  void repopulate() {
    this.bugs.clear();
    this.fillWithBugs(false);
  }
  
  void init(FoodHandler _fh, int _bc) {
    print("Initialising BugHandler...\n");
    foodHandler = _fh;
    bugCount = _bc;
    bestEff = -99999;
    fillWithBugs(false);
    print("BugHandler succesfully initialised!\n");
  }
  
  void update() {
    collisionDetection();
    for(int i = 0; i < bugs.size(); i++) {
      bugs.get(i).update(bugs);
      if(!bugs.get(i).isAlive()) {
        Bug test = bugs.get(i);
        if(this.bestEff < test.getEfficiency()) {
          this.bestEff = test.getEfficiency();
          this.bestNeuronStructure = test.getNeuronStructure();
        }
        //print("\nBug (" + test + ")\n");
        //print("Ate (" + test.foodAten + ") food\n");
        //print("Was alive for (" + test.timeAlive + ") ticks\n");
        //print("Colided with bugs for (" + test.timeBugColided + ") ticks\n");
        //print("Traveled (" + test.travelDist + ") pixels\n");
        bugs.remove(i);
      }
    }
    if(bugs.size() == 0) {
      saveJSONArray(this.bestNeuronStructure, "Mind/test2.txt");
      this.bestEff -= 500;
    }
  }
  
  void fillWithBugs(boolean t) {
    if(bugs.size() < bugCount) while(bugs.size() < bugCount) {
      Bug newBug = new Bug(t);
      newBug.init();
      bugs.add(newBug); // TODO implement custom function for species naming and bug init()
    }
  }
  
  void postUpdate() {
  }
  
  int getEntityCount() {
    return bugs.size();
  }
  
  Bug getBug(int _i) {
    return bugs.get(_i);
  }
  
  private void collisionDetection() {
    for(int i = 0; i < bugs.size(); i++) {
      Bug bug1 = bugs.get(i);
      for(int j = 0; j < bugs.size(); j++) {
        if(i != j) {
          Bug bug2 = bugs.get(j);
          if(rectangleRectangle2d(bug1.getCollisionBox(), bug2.getCollisionBox())) {
            bug1.colidesWithBug(true);
            break;
          }
        }
        bug1.colidesWithBug(false);
      }
      
      // Food colision detection
      for(int j = 0; j < foodHandler.getSize(); j++) {
        Food food = foodHandler.getFood(j);
        if(rectangleRectangle2d(bug1.getCollisionBox(), food.getCollisionBox())) {
          foodHandler.eatFood(j);
          bug1.colidedWithFood();
          break;
        }
      }
    }
  }
}

class FoodHandler {

  ArrayList<Food> foodEntities;
  int maxFoodCount;

  FoodHandler() {
    foodEntities = new ArrayList<Food>();
  }

  void init(int _mfc) {
    maxFoodCount = _mfc;
  }
  
  void regrow() {
    foodEntities.clear();
  }
  
  void update() {
    float maxD = 2000;
    if(random(0,1) > 0.8) if(foodEntities.size() < maxFoodCount) createFood(random(-maxD, maxD), random(-maxD, maxD)); // TODO Update x y for plants
    for(int i = 0; i < foodEntities.size(); i++) {
      foodEntities.get(i).update();
    }
  }
  
  void postUpdate() {}
  
  private void createFood(float _x, float _y) {
    Food newFood = new Food();
    newFood.init(_x, _y, random(5, 10));
    foodEntities.add(newFood);
  }

  Food getFood(int _i) {
    return foodEntities.get(_i);
  }
  Food eatFood(int _i) {
    return foodEntities.remove(_i);
  }
  int getSize() {
    return foodEntities.size();
  }
  
  ArrayList<Food> getFoodArray() {
    return foodEntities;
  }
}
