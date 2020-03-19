class Game {
  
  final int maxBugCount = 50;
  final int maxFoodCount = 600;
  
  private float mutationRate = 0.01;
  
  boolean isRunning;
  
  BugHandler bugHandler;
  FoodHandler foodHandler;
  
  Game() {
    bugHandler = new BugHandler();
    foodHandler = new FoodHandler();
  }
  
  void init() {
    print("Initialising Simulation...\n");
    foodHandler.init(maxFoodCount);
    bugHandler.init(foodHandler, maxBugCount);
    isRunning = true;
    print("Simulation succesfully initialised!\nSimulation is starting...\nSimulation is running!\n");
  }
  
  void update() {
    foodHandler.update();
    bugHandler.update();
    if(!(bugHandler.getEntityCount() > 0)) {
      bugHandler.repopulate();
      foodHandler.regrow();
    }
  }
  
  void postUpdate() {
    foodHandler.postUpdate();
    bugHandler.postUpdate();
  }
  
  void events() {
    if(!isRunning) {
      print("Simulation is exiting...");
      exit();
    }
  }
  
  void clearing() {}
  
}
