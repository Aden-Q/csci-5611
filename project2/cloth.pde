// skeleton code from RopeStarter.pde by the professor and the 3D camera library provided on canvas 

import java.lang.Math.*;

//Create Window
String windowTitle = "Swinging Rope";
void setup() {
  size(600, 600, P3D);
  surface.setTitle(windowTitle);
  goldy = loadImage("Big-Goldy-Face.jpg"); //What image to load, experiment with transparent images
  elderRing = loadImage("ElderRing.jpg");
  noStroke();
  globe = createShape(SPHERE,radius);
  globe.setTexture(elderRing);
  ball = createShape(SPHERE,sphereRadius);
  ball.setTexture(goldy);
  initScene();
}

//Simulation Parameters
PImage goldy, elderRing;  //Will store the texture/image we are drawing
PShape globe, ball;
float floor = 500;
Vec3 gravity = new Vec3(0,100,0);
float radius = 1.5;
//float initTheta = (float)Math.PI / 3;
float initTheta = 0;
float distAjd = 2.2;
Vec3 stringTop = new Vec3(-50,-20,-400);
float restLen = 1.5;
float mass = 1.0; //TRY-IT: How does changing mass affect resting length of the rope?
float k = 300; //TRY-IT: How does changing k affect resting length of the rope?
float kv = 50 ; //TRY-IT: How big can you make kv?
float cd = 0.8; // drag coefficient
float COR = 0.3;
float rho = 1; // substance density 

Vec3 spherePos = new Vec3(-20,50,-370);
float sphereRadius = 30;

//Initial positions and velocities of masses
static int maxNodes = 100;
static int numRopes = 30;
Vec3 pos[][] = new Vec3[numRopes][maxNodes];
Vec3 vel[][] = new Vec3[numRopes][maxNodes];
Vec3 acc[][] = new Vec3[numRopes][maxNodes];

int numNodes = 20;  // number of nodes on each rope

Camera camera;

void initScene(){
  for (int ropeIdx = 0; ropeIdx < numRopes; ropeIdx++) {
    for (int i = 0; i < numNodes; i++){
      pos[ropeIdx][i] = new Vec3(0,0,0);
      pos[ropeIdx][i].x = stringTop.x + 2*distAjd*i*cos(initTheta);
      pos[ropeIdx][i].y = stringTop.y;
      pos[ropeIdx][i].z = stringTop.z + ropeIdx*distAjd + distAjd*i*sin(initTheta);
      vel[ropeIdx][i] = new Vec3(0,0,0);
    }
  }
  camera = new Camera();
}

void update(float dt){
  //Reset accelerations each timestep (momenum only applies to velocity)
  for (int ropeIdx = 0; ropeIdx < numRopes; ropeIdx++) {
    for (int i = 0; i < numNodes; i++){
      acc[ropeIdx][i] = new Vec3(0,0,0);
      acc[ropeIdx][i].add(gravity);
    }
  }
  
  //Compute (damped) Hooke's law for each spring
  for (int ropeIdx = 0; ropeIdx < numRopes; ropeIdx++) {
    for (int i = 0; i < numNodes-1; i++){
      Vec3 diff = pos[ropeIdx][i+1].minus(pos[ropeIdx][i]);
      float stringF = -k*(diff.length() - restLen);
      
      Vec3 stringDir = diff.normalized();
      float projVbot = dot(vel[ropeIdx][i], stringDir);
      float projVtop = dot(vel[ropeIdx][i+1], stringDir);
      float dampF = -kv*(projVtop - projVbot);
      
      Vec3 drag = new Vec3(0,0,0); // air drag
      if (ropeIdx < numRopes-1) {
        Vec3 vt = (vel[ropeIdx][i].plus(vel[ropeIdx][i+1]).plus(vel[ropeIdx+1][i])).times(1/3);
        Vec3 diff2 = pos[ropeIdx+1][i].minus(pos[ropeIdx][i]);
        Vec3 normal = cross(diff2, diff);
        drag = normal.times(vt.length()*dot(vt, normal)/(2*normal.length())).times(-1/2*rho*cd).times(1/3);
      }
      Vec3 force = stringDir.times(stringF+dampF).plus(drag);
      acc[ropeIdx][i].add(force.times(-1.0/mass));
      acc[ropeIdx][i+1].add(force.times(1.0/mass));
    }
  }
  // In the other direction
  for (int i = 0; i < numNodes; i++){
    for (int ropeIdx = 0; ropeIdx < numRopes-1; ropeIdx++){
      Vec3 diff = pos[ropeIdx+1][i].minus(pos[ropeIdx][i]);
      float stringF = -k*(diff.length() - restLen);
      
      Vec3 stringDir = diff.normalized();
      float projVbot = dot(vel[ropeIdx][i], stringDir);
      float projVtop = dot(vel[ropeIdx+1][i], stringDir);
      float dampF = -kv*(projVtop - projVbot);
      
      Vec3 force = stringDir.times(stringF+dampF);
      acc[ropeIdx][i].add(force.times(-1.0/mass));
      acc[ropeIdx+1][i].add(force.times(1.0/mass));
    }
  }

  //Eulerian integration
  for (int ropeIdx = 0; ropeIdx < numRopes; ropeIdx++) {
    for (int i = 1; i < numNodes; i++){
      vel[ropeIdx][i].add(acc[ropeIdx][i].times(dt));
      pos[ropeIdx][i].add(vel[ropeIdx][i].times(dt));
    }
  }

  for (int ropeIdx = 0; ropeIdx < numRopes; ropeIdx++) {
    //Collision detection and response
    for (int i = 0; i < numNodes; i++){
      // Colliding with the static ball
      if (pos[ropeIdx][i].distanceTo(spherePos) < (sphereRadius+radius)){
        Vec3 normal = (pos[ropeIdx][i].minus(spherePos)).normalized();
        pos[ropeIdx][i] = spherePos.plus(normal.times(sphereRadius+radius).times(1.005));
        Vec3 velNormal = normal.times(dot(vel[ropeIdx][i],normal));
        vel[ropeIdx][i].subtract(velNormal.times(1 + COR));
      }
      // colliding with other balls on the rope
      // Complecated cases
    }
  }
}

//Draw the scene: one sphere per mass, one line connecting each pair
boolean paused = true;
void draw() {
  background(255,255,255);
  lights();
  camera.Update(1.0/frameRate);
  
  // A static 3D ball in the scene
  fill(255,255,255);
  pushMatrix();
  noStroke();
  translate(spherePos.x, spherePos.y, spherePos.z);
  //println(spherePos.x, spherePos.y, spherePos.z);
  shape(ball);
  popMatrix();
  
  for (int i = 0; i < 20; i++) {
    if (!paused){
      update(1/(20*frameRate));
    }
  }
  
  fill(255,255,0);
  for (int ropeIdx = 0; ropeIdx < numRopes; ropeIdx++) {
    for (int i = 0; i < numNodes-1; i++){
      pushMatrix();
      stroke(10);
      line(pos[ropeIdx][i].x,pos[ropeIdx][i].y,pos[ropeIdx][i].z,pos[ropeIdx][i+1].x,pos[ropeIdx][i+1].y,pos[ropeIdx][i+1].z);
      if (ropeIdx != numRopes - 1) {
        line(pos[ropeIdx][i].x,pos[ropeIdx][i].y,pos[ropeIdx][i].z,pos[ropeIdx+1][i].x,pos[ropeIdx+1][i].y,pos[ropeIdx+1][i].z);
      }
      translate(pos[ropeIdx][i+1].x,pos[ropeIdx][i+1].y,pos[ropeIdx][i+1].z);
      shape(globe);
      popMatrix();
    }
  }
  
  if (paused)
    surface.setTitle(windowTitle + " [PAUSED]");
  else
    surface.setTitle(windowTitle + " "+ nf(frameRate,0,2) + "FPS");
}

void keyPressed(){
  if (key == ' ')
    paused = !paused;
  if (key == 'r' || key == 'R')
    initScene();
  camera.HandleKeyPressed();
}

void keyReleased(){
  camera.HandleKeyReleased();
}

///////////////////
// Vec3D Library
///////////////////

public class Vec3 {
  public float x, y, z;
  
  public Vec3(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public String toString(){
    return "(" + x+ ", " + y + ", " + z+")";
  }
  
  public float length(){
    return sqrt(x*x+y*y+z*z);
  }
  
  public float lengthSqr(){
    return x*x+y*y+z*z;
  }
  
  public Vec3 plus(Vec3 rhs){
    return new Vec3(x+rhs.x, y+rhs.y, z+rhs.z);
  }
  
  public void add(Vec3 rhs){
    x += rhs.x;
    y += rhs.y;
    z += rhs.z;
  }
  
  public Vec3 minus(Vec3 rhs){
    return new Vec3(x-rhs.x, y-rhs.y, z-rhs.z);
  }
  
  public void subtract(Vec3 rhs){
    x -= rhs.x;
    y -= rhs.y;
    z -= rhs.z;
  }
  
  public Vec3 times(float rhs){
    return new Vec3(x*rhs, y*rhs, z*rhs);
  }
  
  public void mul(float rhs){
    x *= rhs;
    y *= rhs;
    z *= rhs;
  }
  
  public void normalize(){
    float magnitude = sqrt(x*x + y*y+z*z);
    x /= magnitude;
    y /= magnitude;
    z /= magnitude;
  }
  
  public Vec3 normalized(){
    float magnitude = sqrt(x*x + y*y+z*z);
    return new Vec3(x/magnitude, y/magnitude, z/magnitude);
  }
  
  public void clampToLength(float maxL){
    float magnitude = sqrt(x*x + y*y+ + z*z);
    if (magnitude > maxL){
      x *= maxL/magnitude;
      y *= maxL/magnitude;
      z *= maxL/magnitude;
    }
  }
  
  public void setToLength(float newL){
    float magnitude = sqrt(x*x + y*y + z*z);
    x *= newL/magnitude;
    y *= newL/magnitude;
    z *= newL/magnitude;
  }
  
  public float distanceTo(Vec3 rhs){
    float dx = rhs.x - x;
    float dy = rhs.y - y;
    float dz = rhs.z - z;
    return sqrt(dx*dx + dy*dy + dz*dz);
  }
  
}

Vec3 interpolate(Vec3 a, Vec3 b, float t){
  return a.plus((b.minus(a)).times(t));
}

float interpolate(float a, float b, float t){
  return a + ((b-a)*t);
}

float dot(Vec3 a, Vec3 b){
  return a.x*b.x + a.y*b.y + a.z*b.z;
}

Vec3 cross(Vec3 a, Vec3 b){
  return new Vec3(a.y*b.z-a.z*b.y, a.z*b.x-a.x*b.z, a.x*b.y-a.y*b.x);
}

Vec3 projAB(Vec3 a, Vec3 b){
  return b.times(a.x*b.x + a.y*b.y + a.z*b.z);
}

// Created for CSCI 5611 by Liam Tyler

// WASD keys move the camera relative to its current orientation
// Arrow keys rotate the camera's orientation
// Holding shift boosts the move speed

class Camera
{
  Camera()
  {
    position      = new PVector( 0, 0, 0 ); // initial position
    theta         = 0; // rotation around Y axis. Starts with forward direction as ( 0, 0, -1 )
    phi           = 0; // rotation around X axis. Starts with up direction as ( 0, 1, 0 )
    moveSpeed     = 50;
    turnSpeed     = 1.57; // radians/sec
    boostSpeed    = 10;  // extra speed boost for when you press shift
    
    // dont need to change these
    shiftPressed = false;
    negativeMovement = new PVector( 0, 0, 0 );
    positiveMovement = new PVector( 0, 0, 0 );
    negativeTurn     = new PVector( 0, 0 ); // .x for theta, .y for phi
    positiveTurn     = new PVector( 0, 0 );
    fovy             = PI / 4;
    aspectRatio      = width / (float) height;
    nearPlane        = 0.1;
    farPlane         = 10000;
  }
  
  void Update(float dt)
  {
    theta += turnSpeed * ( negativeTurn.x + positiveTurn.x)*dt;
    
    // cap the rotation about the X axis to be less than 90 degrees to avoid gimble lock
    float maxAngleInRadians = 85 * PI / 180;
    phi = min( maxAngleInRadians, max( -maxAngleInRadians, phi + turnSpeed * ( negativeTurn.y + positiveTurn.y ) * dt ) );
    
    // re-orienting the angles to match the wikipedia formulas: https://en.wikipedia.org/wiki/Spherical_coordinate_system
    // except that their theta and phi are named opposite
    float t = theta + PI / 2;
    float p = phi + PI / 2;
    PVector forwardDir = new PVector( sin( p ) * cos( t ),   cos( p ),   -sin( p ) * sin ( t ) );
    PVector upDir      = new PVector( sin( phi ) * cos( t ), cos( phi ), -sin( t ) * sin( phi ) );
    PVector rightDir   = new PVector( cos( theta ), 0, -sin( theta ) );
    PVector velocity   = new PVector( negativeMovement.x + positiveMovement.x, negativeMovement.y + positiveMovement.y, negativeMovement.z + positiveMovement.z );
    position.add( PVector.mult( forwardDir, moveSpeed * velocity.z * dt ) );
    position.add( PVector.mult( upDir,      moveSpeed * velocity.y * dt ) );
    position.add( PVector.mult( rightDir,   moveSpeed * velocity.x * dt ) );
    
    aspectRatio = width / (float) height;
    perspective( fovy, aspectRatio, nearPlane, farPlane );
    camera( position.x, position.y, position.z,
            position.x + forwardDir.x, position.y + forwardDir.y, position.z + forwardDir.z,
            upDir.x, upDir.y, upDir.z );
  }
  
  // only need to change if you want difrent keys for the controls
  void HandleKeyPressed()
  {
    if ( key == 'w' || key == 'W' ) positiveMovement.z = 1;
    if ( key == 's' || key == 'S' ) negativeMovement.z = -1;
    if ( key == 'a' || key == 'A' ) negativeMovement.x = -1;
    if ( key == 'd' || key == 'D' ) positiveMovement.x = 1;
    if ( key == 'q' || key == 'Q' ) positiveMovement.y = 1;
    if ( key == 'e' || key == 'E' ) negativeMovement.y = -1;
    
    if ( key == 'r' || key == 'R' ){
      Camera defaults = new Camera();
      position = defaults.position;
      theta = defaults.theta;
      phi = defaults.phi;
    }
    
    if ( keyCode == LEFT )  negativeTurn.x = 1;
    if ( keyCode == RIGHT ) positiveTurn.x = -0.5;
    if ( keyCode == UP )    positiveTurn.y = 0.5;
    if ( keyCode == DOWN )  negativeTurn.y = -1;
    
    if ( keyCode == SHIFT ) shiftPressed = true; 
    if (shiftPressed){
      positiveMovement.mult(boostSpeed);
      negativeMovement.mult(boostSpeed);
    }
    
  }
  
  // only need to change if you want difrent keys for the controls
  void HandleKeyReleased()
  {
    if ( key == 'w' || key == 'W' ) positiveMovement.z = 0;
    if ( key == 'q' || key == 'Q' ) positiveMovement.y = 0;
    if ( key == 'd' || key == 'D' ) positiveMovement.x = 0;
    if ( key == 'a' || key == 'A' ) negativeMovement.x = 0;
    if ( key == 's' || key == 'S' ) negativeMovement.z = 0;
    if ( key == 'e' || key == 'E' ) negativeMovement.y = 0;
    
    if ( keyCode == LEFT  ) negativeTurn.x = 0;
    if ( keyCode == RIGHT ) positiveTurn.x = 0;
    if ( keyCode == UP    ) positiveTurn.y = 0;
    if ( keyCode == DOWN  ) negativeTurn.y = 0;
    
    if ( keyCode == SHIFT ){
      shiftPressed = false;
      positiveMovement.mult(1.0/boostSpeed);
      negativeMovement.mult(1.0/boostSpeed);
    }
  }
  
  // only necessary to change if you want different start position, orientation, or speeds
  PVector position;
  float theta;
  float phi;
  float moveSpeed;
  float turnSpeed;
  float boostSpeed;
  
  // probably don't need / want to change any of the below variables
  float fovy;
  float aspectRatio;
  float nearPlane;
  float farPlane;  
  PVector negativeMovement;
  PVector positiveMovement;
  PVector negativeTurn;
  PVector positiveTurn;
  boolean shiftPressed;
};
