class Food {
  
  final float growScale = 0.1;
  
  final int plantColorR = 80;
  final int plantColorG = 130;
  final int plantColorB = 20;
  
  final float maxPlantSize = 30;
  
  Rectangle foodShape;
  
  Food() {
  }
  
  void init(float _x, float _y, float _s) {
    foodShape = new Rectangle(new Point(_x, _y), _s);
  }
  
  void update() {
    if(foodShape.getDiagonal() < maxPlantSize) foodShape.rescale(growScale);
  }
  
  Rectangle getFoodShape() {
    return this.foodShape;
  }
  
  Rectangle getCollisionBox() {
    return this.foodShape;
  }
  
  color getColor() {
    float dif = foodShape.getDiagonal() / maxPlantSize;
    return color(plantColorR * dif, plantColorG * dif, plantColorB * dif);
  }
}
