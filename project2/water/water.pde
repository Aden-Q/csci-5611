import java.lang.Math.*;

//Create Window
String windowTitle = "Shallow Water Equations";
void setup() {
  size(600, 400, P3D);
  surface.setTitle(windowTitle);
  initScene();
}

int numCells = 40;  // number of cells
float dx = 2.0;  // length of each cell
float h[] = new float[numCells];  // height
float hu[] = new float[numCells];  // momentum
float scale = 0.2;
float gravity = 5;
float damp = 0.9;

void initScene(){
  for (int i = 0; i < numCells; i++) {
    h[i] = sin(6*i/numCells) + 2;
  }
}

void update(float dt){
  float dhdt[] = new float[numCells];  // height derivative
  float dhudt[] = new float[numCells];  // momentum derivative
  float h_mid[] = new float[numCells];  // height midpoint
  float hu_mid[] = new float[numCells];  // momentum midpoint
  float dhdt_mid[] = new float[numCells];  // height derivative midpoint
  float dhudt_mid[] = new float[numCells];  // momentum derivative midpoint
  
  for (int i = 0; i < numCells - 1; i++) {
    h_mid[i] = (h[i] + h[i+1]) / 2;
    hu_mid[i] = (hu[i] + hu[i+1]) / 2;
  }
  
  for (int i = 0; i < numCells - 1; i++) {
    float dhudx_mid = (hu[i+1] - hu[i])/dx;
    dhdt_mid[i] = -dhudx_mid;
    float dhu2dx_mid = (hu[i+1]*hu[i+1]/h[i+1] - hu[i]*hu[i]/h[i])/dx;
    float dgh2dx_mid = (gravity*h[i+1]*h[i+1] - h[i]*h[i])/dx;
    dhudt_mid[i] = -(dhu2dx_mid + 0.5*dgh2dx_mid);
  }
  
  for (int i = 0; i < numCells; i++) {
    h_mid[i] += dhdt_mid[i]*dt/2;
    hu_mid[i] += dhudt_mid[i]*dt/2;
  }
  
  for (int i = 1; i < numCells - 1; i++) {
    float dhudx = (hu_mid[i] - hu_mid[i-1])/dx;
    dhdt[i] = -dhudx;
    float dhu2dx = (hu_mid[i]*hu_mid[i]/h_mid[i] - hu_mid[i-1]*hu_mid[i-1]/h_mid[i-1])/dx;
    float dgh2dx = gravity*(h_mid[i]*h_mid[i] - h_mid[i-1]*h_mid[i-1])/dx;
    dhudt[i] = -(dhu2dx + 0.5*dgh2dx);
  }
  
  for (int i = 0; i < numCells; i++) {
    h[i] += damp*dhdt[i]*dt;
    hu[i] += damp*dhudt[i]*dt;
  }
  
  h[0] = h[1];
  h[numCells-1] = h[numCells-2];
  hu[0] = -hu[1];
  hu[numCells-1] = -hu[numCells-2];
}

//Draw the scene: one sphere per mass, one line connecting each pair
boolean paused = true;
void draw() {
  background(255,255,255);
  noStroke();
  
  for (int i = 0; i < 50; i++) {
    if (!paused){
      update(1/(50*frameRate));
    }
  }
  
  // color
  fill(0,0,255);
  for (int i = 0; i < numCells - 1; i++) {
    float x1 = 2*i/(numCells-1)-1;
    x1 = width - (x1 * width + width);
    float x2 = 2*(i+1)/(numCells-1)-1;
    x2 = width - (x2 * width + width);
    float y1 = (h[i]-1)*scale;
    y1 = height - y1*height;
    float y2 = (h[i+1]-1)*scale;
    y2 = height - y2*height;
    quad(x1,y1,x2,y2,x2,height,x1,height);
  }
  
  if (paused)
    surface.setTitle(windowTitle + " [PAUSED]");
  else
    surface.setTitle(windowTitle + " "+ nf(frameRate,0,2) + "FPS");
}

void keyPressed(){
  if (key == ' ')
    paused = !paused;
}

///////////////////
// Vec2D Library
///////////////////

public class Vec2 {
  public float x, y;
  
  public Vec2(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public String toString(){
    return "(" + x+ ", " + y +")";
  }
  
  public float length(){
    return sqrt(x*x+y*y);
  }
  
  public float lengthSqr(){
    return x*x+y*y;
  }
  
  public Vec2 plus(Vec2 rhs){
    return new Vec2(x+rhs.x, y+rhs.y);
  }
  
  public void add(Vec2 rhs){
    x += rhs.x;
    y += rhs.y;
  }
  
  public Vec2 minus(Vec2 rhs){
    return new Vec2(x-rhs.x, y-rhs.y);
  }
  
  public void subtract(Vec2 rhs){
    x -= rhs.x;
    y -= rhs.y;
  }
  
  public Vec2 times(float rhs){
    return new Vec2(x*rhs, y*rhs);
  }
  
  public void mul(float rhs){
    x *= rhs;
    y *= rhs;
  }
  
  public void normalize(){
    float magnitude = sqrt(x*x + y*y);
    x /= magnitude;
    y /= magnitude;
  }
  
  public Vec2 normalized(){
    float magnitude = sqrt(x*x + y*y);
    return new Vec2(x/magnitude, y/magnitude);
  }
  
  public void clampToLength(float maxL){
    float magnitude = sqrt(x*x + y*y);
    if (magnitude > maxL){
      x *= maxL/magnitude;
      y *= maxL/magnitude;
    }
  }
  
  public void setToLength(float newL){
    float magnitude = sqrt(x*x + y*y);
    x *= newL/magnitude;
    y *= newL/magnitude;
  }
  
  public float distanceTo(Vec2 rhs){
    float dx = rhs.x - x;
    float dy = rhs.y - y;
    return sqrt(dx*dx + dy*dy);
  }
  
}

Vec2 interpolate(Vec2 a, Vec2 b, float t){
  return a.plus((b.minus(a)).times(t));
}

float interpolate(float a, float b, float t){
  return a + ((b-a)*t);
}

float dot(Vec2 a, Vec2 b){
  return a.x*b.x + a.y*b.y;
}

Vec2 projAB(Vec2 a, Vec2 b){
  return b.times(a.x*b.x + a.y*b.y);
}
