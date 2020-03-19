class GameRenderer {
  
  Game game;
  Camera cam;
  BugRenderer bugs;
  FoodRenderer foods;
  
  GameRenderer() {
    cam = new Camera();
    bugs = new BugRenderer();
    foods = new FoodRenderer();
  }
  
  void init(Game _g) {
    game = _g;
    cam.init(0, 0);
    bugs.init();
    foods.init();
  }
  
  void compose() {
    cam.compose();
    for(int i = 0; i < game.foodHandler.getSize(); i++) {
      foods.compose(game.foodHandler.getFood(i));
    }
    for(int i = 0; i < game.bugHandler.getEntityCount(); i++) {
      bugs.compose(game.bugHandler.getBug(i), true);
    }
  }

}

class FoodRenderer {
  
  PImage texture;
  
  float[][] matrix = {
      {0, 0},
      {0, 0},
      {0, 0},
      {0, 0}
  };
  
  FoodRenderer() {
    texture = createImage(30, 30, RGB);
  }
  
  void init() {}
  
  void compose(Food _f) {
    Rectangle s = _f.getFoodShape();
    float w = s.getWidth();
    float h = s.getHeight();
    
    float x = s.getX();
    float y = s.getY();
    
    if(true) updateMatrix(w, h);
    
    beginShape(QUAD);
    noStroke();
    fill(_f.getColor());
    vertex(x + matrix[0][0], y + matrix[0][1], 0);
    vertex(x + matrix[1][0], y + matrix[1][1], 0);
    vertex(x + matrix[2][0], y + matrix[2][1], 0);
    vertex(x + matrix[3][0], y + matrix[3][1], 0);
    endShape(CLOSE);
  }
  
  private void updateMatrix(float w, float h) {
    matrix[0][0] = (- w / 2);
    matrix[0][1] = (- h / 2);
    matrix[1][0] = (+ w / 2);
    matrix[1][1] = (- h / 2);
    matrix[2][0] = (+ w / 2);
    matrix[2][1] = (+ h / 2);
    matrix[3][0] = (- w / 2);
    matrix[3][1] = (+ h / 2);
  }
  
}

class BugRenderer {
  
  PImage texture;
  
  float[][] matrix = {
      {0, 0},
      {0, 0},
      {0, 0},
      {0, 0}
  };
  
  BugRenderer() {
    texture = createImage(20, 30, RGB);
  }
  
  void init() {
  }
  
  void compose(Bug _b) {
    compose(_b, false);
  }
  
  void compose(Bug _b, boolean _t) {
    Rectangle s = _b.getBugShape();
    float a = _b.getRotationAngle();
    float w = s.getWidth();
    float h = s.getHeight();
    
    float x = s.getX();
    float y = s.getY();
    
    if(true) updateMatrix(w, h, a + PI/2);
    
    beginShape(QUAD);
    noStroke();
    
    fill(_b.getBugColor());
    vertex(x + matrix[0][0], y + matrix[0][1], 0);
    vertex(x + matrix[1][0], y + matrix[1][1], 0);
    vertex(x + matrix[2][0], y + matrix[2][1], 0);
    vertex(x + matrix[3][0], y + matrix[3][1], 0);
    endShape(CLOSE);
    
    if(_t) {
      Rectangle colider = _b.getCollisionBox();
      float coliderW = colider.getWidth() / 2;
      float coliderH = colider.getWidth() / 2;
      beginShape(QUAD); 
      strokeWeight(0.5);
      if(_b.colidesWithBug) stroke(color(255, 0, 0));
      else stroke(255);
      noFill();
      vertex(x - coliderW, y - coliderH, 0);
      vertex(x + coliderW, y - coliderH, 0);
      vertex(x + coliderW, y + coliderH, 0);
      vertex(x - coliderW, y + coliderH, 0);
      endShape(CLOSE);
      
      
    }
  }
  
  private void updateMatrix(float w, float h, float a) {
    matrix[0][0] = ( - (w / 2)) * cos(a) - ( - (h / 2)) * sin(a);
    matrix[0][1] = ( - (w / 2)) * sin(a) + ( - (h / 2)) * cos(a);
    matrix[1][0] = ( + (w / 2)) * cos(a) - ( - (h / 2)) * sin(a);
    matrix[1][1] = ( + (w / 2)) * sin(a) + ( - (h / 2)) * cos(a);
    matrix[2][0] = ( + (w / 2)) * cos(a) - ( + (h / 2)) * sin(a);
    matrix[2][1] = ( + (w / 2)) * sin(a) + ( + (h / 2)) * cos(a);
    matrix[3][0] = ( - (w / 2)) * cos(a) - ( + (h / 2)) * sin(a);
    matrix[3][1] = ( - (w / 2)) * sin(a) + ( + (h / 2)) * cos(a);
  }
  
  private void updateTexture(color _c) {
    texture.loadPixels();
    for(int j = 0; j < texture.height; j++) for(int i = 0; i < texture.width; i++) {
      if((j >= 3 && j <= 10) && (i >= 6 && i <= 13)) texture.pixels[j * texture.width + i] = color(0);
      else texture.pixels[j * texture.width + i] = _c;
    }
    texture.updatePixels();
  }
}

class Camera {
  
  float x, y, z;
  float px = 0, py = 1, pz = 0;
  
  Camera() {}
  
  void init(int _x, int _y) {
    x = _x;
    y = _y;
    z = 3000;
  }
  
  void compose() {
    if(keyPressed) {
      moveCamera();
    }
    camera(x, y, z, x, y, 0, px, py, pz);
  }
  
  void moveCamera() {
    if(key == 'a' || key == 'A') {
      x -= 4;
    }
    else if(key == 'd' || key == 'D') {
      x += 4;
    }
    if(key == 'w' || key == 'W') {
      y -= 4;
    }
    else if(key == 's' || key == 'S') {
      y += 4;
    }
  }
}
