////////////////////////////////////////////////////////////////////////
// Agent is the class that containing all the AI logic.
class Agent {
  // The agent has access the environment to try to perform action
  private Environment env;
  // Sensor attributes
  public int cellSensor;
  public int inventorySensor;
  public ArrayList<Integer> memory;
  
  // Constructor
  Agent(Environment env_) {
    env = env_;
    memory = new ArrayList<Integer>();
  }
  
  ////// TODO PART //////  
  public void step() {
    env.tryRotate(this);
    env.tryMove(this);
    memory.add(cellSensor);
    if (memory.size() > MEMORY_SIZE)
    {
      memory.remove(0);
    }
    float densityCell = calcDensity(cellSensor);
    float densityInventory = calcDensity(inventorySensor);
    
    float probPose = pow(densityInventory / ((float)K_MINUS + densityInventory), 2);
    float probTake = pow((float)K_PLUS / ((float)K_PLUS + densityCell), 2);
    
    if (random(1) < probPose)
    {
      env.tryDeposit(this);
    }
    if (random(1) < probTake)
    {
      env.tryTake(this);
    }
  }
  
  public void display() {
    int w = width / GRID_SIZE;
    triangle(-2 * w, 1 * w, -2 * w, -1 * w, 2 * w, 0);
    fill(0, 255, 0);
  }
  
  public float calcDensity(int numFood)
  {
    int nbSameFoodMemory = 0;
    for (int i = 0; i < memory.size(); i++)
    {
      if (memory.get(i) == numFood)
      {
        nbSameFoodMemory++;
      }
    }
    return (float)nbSameFoodMemory / (float)memory.size();
  }
  ////// - //////
}
////////////////////////////////////////////////////////////////////////
