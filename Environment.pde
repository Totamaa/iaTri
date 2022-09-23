////////////////////////////////////////////////////////////////////////
// Environment is the class containing all the information about the agents and the food.
// It contains all the logic, it performs the actions, and it even provide the agents with perceptions.
class Environment { 
  ////////////////////////////////////////////////////////////////////////
  // AgentInfo is a class only existing in Environment, it allows to "hide" information from the agent scope.
  // That way, the position, orientation, or inventory, can not be accessed/modified directly by agent.
  class AgentInfo extends Agent {
    // Position of the agent with x in [0, width[ and y in [0, height[
    private PVector position;
    // Orientation of the agent where 2*PI is a full turn
    private float orientation;
    // Inventory of the agent, can contain one food (>0) or nothing (0)
    private int inventory;
  
    // Constructor
    AgentInfo(Environment env_) {
      // Init super class (Agent)
      super(env_);
      // Agent spawn with a random location/orientation and empty inventory
      position = new PVector(random(width), random(height));
      orientation = random(0, 2.*PI);
      inventory = 0;
    }
      
    // Move agent with a little step facing the orientation
    public void doMove() {
      // Do a step
      position.add((new PVector(width/GRID_SIZE, 0)).rotate(orientation));
      
      // Move back agents going outside the frame
      position.x = min(width - 0.5, position.x);
      position.x = max(0.5, position.x);
      position.y = min(height - 0.5, position.y);
      position.y = max(0.5, position.y);
    }

    // Change the agent orientation from +-45°
    public void doRotate() {
      orientation += random(-PI, PI)/4.;
    }
    
    ////// GETTER-SETTER //////
    public void setInventory(int food) {
      if (food < 0) throw new InvalidParameterException("In AgentInfo.setInventory(), \"food\" parameter is to low, lower bound is: " + 0);
      if (food > NB_FOOD_TYPE) throw new InvalidParameterException("In AgentInfo.setInventory(), \"food\" parameter is to high, upper bound is: " + NB_FOOD_TYPE);
      inventory = food;
    }
    
    public int getInventory() {
      return inventory;
    }
    
    public PVector getPosition() {
      return position.copy();
    }
    
    public float getOrientation() {
      return orientation;
    }
    ////// - //////
  }
  ////////////////////////////////////////////////////////////////////////
  
  
  
  // List containing all the agents
  private ArrayList<AgentInfo> agentList;
  // Grid containing all the food
  private int[][] foodGrid;



  // Constructor
  Environment() {
    // Init the agent list
    agentList = new ArrayList<AgentInfo>();
    
    // Fill the agent list
    for (int i = 0; i < NB_AGENTS; i++) {
      agentList.add(new AgentInfo(this));
    }


    // Init the food grid
    foodGrid = new int[GRID_SIZE][GRID_SIZE];
    for (int x = 0; x < GRID_SIZE; x++) {
      for (int y = 0; y < GRID_SIZE; y++) {
        foodGrid[x][y] = 0;
      }
    }
    
    // While not enough food add some
    int countFood = 0;
    while (countFood < int(GRID_SIZE*GRID_SIZE*FOOD_RATIO)) {
      int randX = int(random(GRID_SIZE));
      int randY = int(random(GRID_SIZE));

      // If random cell do not contain food
      if (foodGrid[randX][randY] == 0) {
        foodGrid[randX][randY] = int(random(NB_FOOD_TYPE)) + 1;
        countFood += 1;
      }
    }
  }
  
  
  
  ////// ACTIONS //////
  private void tryMove(Agent agent) {
    AgentInfo agentInfo = ((AgentInfo) agent);
    agentInfo.doMove();
  }
  
  private void tryRotate(Agent agent) {
    AgentInfo agentInfo = ((AgentInfo) agent);
    agentInfo.doRotate();
  }
  
  private void tryTake(Agent agent) {
    AgentInfo agentInfo = ((AgentInfo) agent);
    
    // If the inventory is empty, then angent can pick up food
    if (agentInfo.getInventory() == 0) {
      int gridX = int(GRID_SIZE*agentInfo.getPosition().x/width);
      int gridY = int(GRID_SIZE*agentInfo.getPosition().y/height);
      
      agentInfo.setInventory(foodGrid[gridX][gridY]);
      foodGrid[gridX][gridY] = 0;
    }
  }
  
  private void tryDeposit(Agent agent) {
    AgentInfo agentInfo = ((AgentInfo) agent);
    
    // If the inventory is NOT empty, but the cell underneath is, then angent can deposit food
    if (agentInfo.getInventory() != 0) {
      int gridX = int(GRID_SIZE*agentInfo.getPosition().x/width);
      int gridY = int(GRID_SIZE*agentInfo.getPosition().y/height);
      
      if (foodGrid[gridX][gridY] == 0) {
        foodGrid[gridX][gridY] = agentInfo.getInventory();
        agentInfo.setInventory(0);
      }
    }
  }
  ////// - //////
  
  
  
  // Update agents perceptions, and make them do one step
  public void step() {
    for (int i = 0; i < NB_AGENTS; i++) {
      int gridX = int(GRID_SIZE*agentList.get(i).getPosition().x/width);
      int gridY = int(GRID_SIZE*agentList.get(i).getPosition().y/height);
      
      agentList.get(i).cellSensor = foodGrid[gridX][gridY];
      agentList.get(i).inventorySensor = agentList.get(i).getInventory();
      agentList.get(i).step();
    }
  }
  
  
  
  // Display the environment
  public void display() {    
    // Clear screen
    background(#212121);
    
    // Display food grid
    for (int x = 0; x < GRID_SIZE; x++) {
      for (int y = 0; y < GRID_SIZE; y++) {
        if (foodGrid[x][y] != 0) {
          noStroke();
          fill(COLOR_LIST[foodGrid[x][y] - 1]);
          rect(x*width/GRID_SIZE, y*height/GRID_SIZE, width/GRID_SIZE, height/GRID_SIZE);
        }
      }
    }
    
    // Display agents
    for (int i = 0; i < NB_AGENTS; i++) {
      pushMatrix();
      translate(agentList.get(i).getPosition().x, agentList.get(i).getPosition().y);
      rotate(agentList.get(i).getOrientation());
      
      strokeWeight(2);
      colorMode(HSB, 360, 100, 100);
      stroke((millis()/20)%360, 100, 100);
      colorMode(RGB);
      agentList.get(i).display();
      
      popMatrix();
    }
  }
}
////////////////////////////////////////////////////////////////////////
