Game game;
GameRenderer rend;

void setup() {
  //size(700, 700, P3D);
  fullScreen(P3D);
  
  game = new Game();
  rend = new GameRenderer();
  
  game.init();
  rend.init(game);
}

void draw() {
  background(200);
  game.events();
  game.update();
  rend.compose();
  game.postUpdate();
}
