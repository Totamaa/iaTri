import java.security.*;

// ENVIRONMENT PARAMETERS
final int GRID_SIZE = 100;      // [10, 800]
final float FOOD_RATIO = 0.5;   // [0.01, 0.99]
final int NB_FOOD_TYPE = 4;     // [1, 5]
final int NB_AGENTS = 20;       // [1, +inf[
// AGENTS PARAMETERS
final int MEMORY_SIZE = 50;    // [1, +inf[
final float K_MINUS = 0.3;      // [0, +inf[
final float K_PLUS = 0.1;       // [0, +inf[

// Environment instance
Environment env;
// Counters
float displayEach = 1;
int step = 0;

// Define a color list
color[] COLOR_LIST = new color[5];



void setup() {
  // Define screen size and refresh rate
  size(800, 800);
  frameRate(60);
  surface.setLocation(displayWidth/2 - width/2, displayHeight/2 - height/2);
  
  // Fill the color list
  COLOR_LIST[0] = #ffa1a4;
  COLOR_LIST[1] = #ffe190;
  COLOR_LIST[2] = #c1ec7b;
  COLOR_LIST[3] = #6abdf1;
  COLOR_LIST[4] = #a989d5;
  
  // Verify the parameters
  if (GRID_SIZE < 10) throw new InvalidParameterException("GRID_SIZE is to low, lower bound is: " + 10);
  if (GRID_SIZE > min(width, height)) throw new InvalidParameterException("GRID_SIZE is to hight, upper bound is: " + min(width, height));
  if (FOOD_RATIO < 0.01) throw new InvalidParameterException("FOOD_RATIO is to low, lower bound is: " + 0.01);
  if (FOOD_RATIO > 0.99) throw new InvalidParameterException("FOOD_RATIO is to hight, upper bound is: " + 0.99);
  if (NB_FOOD_TYPE < 1) throw new InvalidParameterException("NB_FOOD_TYPE is to low, lower bound is: " + 1);
  if (NB_FOOD_TYPE > 5) throw new InvalidParameterException("NB_FOOD_TYPE is to hight, upper bound is: " + 5);
  if (NB_AGENTS < 1) throw new InvalidParameterException("NB_AGENTS is to low, lower bound is: " + 1);
  if (MEMORY_SIZE < 1) throw new InvalidParameterException("MEMORY_SIZE is to low, lower bound is: " + 1);
  if (K_MINUS < 0) throw new InvalidParameterException("K_MINUS is to low, lower bound is: " + 0);
  if (K_PLUS < 0) throw new InvalidParameterException("K_PLUS is to low, lower bound is: " + 0);
  
  // Create the environment
  env = new Environment();
}



void draw() {
  // Do steps of environment
  for (int i = 0; i < displayEach + 1; i++)
    env.step();
  step += displayEach + 1;
  
  // Display the environment and update title
  env.display();
  surface.setTitle("Collective Sort | Speed: x" + displayEach + " | Step: " + step);
}



// Change simulation speed When mouse wheel is scrolled
void mouseWheel(MouseEvent event) {
  displayEach *= (event.getCount() >= 0)? 0.5:2.;
  displayEach = max(1/16., min(1000000, displayEach));
  frameRate(60 * min(1, displayEach));
}
