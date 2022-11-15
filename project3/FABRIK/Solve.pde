

Vec2 rootl = new Vec2(50,375);

//Upper Arm
float l0 = 60; 
float a0 = 0.3; //Shoulder joint

//Lower Arm
float l1 = 50;
float a1 = 0.3; //Elbow joint

//Hand
float l2 = 50;
float a2 = 0.3; //Wrist joint

//extra?
float l3 = 80;
float a3 = 0.3; //extra joint

Vec2 start_l1,start_l2,start_l3,endPointL;

float ground_y = rootl.y + l0 + l1 + l2 + l3;

void solveL(Vec2 goal){
  Vec2 startToGoal, startToEndEffector;
  float dotProd, angleDiff;
  
  //extra
  startToGoal = goal.minus(start_l3);
  startToEndEffector = endPointL.minus(start_l3);
  dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if (cross(startToGoal,startToEndEffector) < 0)
    a3 += angleDiff;
  else
    a3 -= angleDiff;
    
  /* Wrist joint limits*/    
  if(a3 > Math.PI/4)
    a3 = (float)Math.PI/4;
  else if(a3 < -Math.PI/4)
    a3 = (float)-Math.PI/4;

  fk(); //Update link positions with fk (e.g. end effector changed)
  
  //Update wrist joint
  startToGoal = goal.minus(start_l2);
  startToEndEffector = endPointL.minus(start_l2);
  dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if (cross(startToGoal,startToEndEffector) < 0)
    a2 += angleDiff;
  else
    a2 -= angleDiff;
    
  if(a2 > Math.PI/2)
    a2 = (float)Math.PI/2;
  else if(a2 < -Math.PI/2)
    a2 = (float)-Math.PI/2;
    
  fk(); //Update link positions with fk (e.g. end effector changed)
  
  //Update elbow joint
  startToGoal = goal.minus(start_l1);
  startToEndEffector = endPointL.minus(start_l1);
  dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if (cross(startToGoal,startToEndEffector) < 0)
    a1 += angleDiff;
  else
    a1 -= angleDiff;
 
  if(a1 > Math.PI/2)
    a1 = (float)Math.PI/2;
  else if(a1 < -Math.PI/2)
    a1 = (float)-Math.PI/2;
   
  fk(); //Update link positions with fk (e.g. end effector changed)
  
  //Update shoulder joint
  startToGoal = goal.minus(rootl);
  if (startToGoal.length() < .0001) return;
  startToEndEffector = endPointL.minus(rootl);
  dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if (cross(startToGoal,startToEndEffector) < 0)
    a0 += angleDiff;
  else
    a0 -= angleDiff;

  /*TODO: Shoulder joint limits here*/
  if (a0 < Math.PI/2)
    a0 = (float)Math.PI/2;
  else if (a0 > 3*Math.PI/2)
    a0 = (float)(3*Math.PI/2);

  fk(); //Update link positions with fk (e.g. end effector changed)
 
  //println("Left Angle 0:",a0,"Left Angle 1:",a1,"Left Angle 2:",a2);
}

Vec2 rootr = new Vec2(100,375);

//Upper Arm
float r0 = 60; 
float ar0 = 0.3; //Shoulder joint

//Lower Arm
float r1 = 50;
float ar1 = 0.3; //Elbow joint

//Hand
float r2 = 50;
float ar2 = 0.3; //Wrist joint

//extra hand?
float r3 = 80;
float ar3 = 0.3; //extra joint

float totalLength = r0 + r1 + r2 + r3;
Vec2 start_r1,start_r2,start_r3,endPointR;


ArrayList<Vec2> list = new ArrayList<Vec2>();
ArrayList<Float> lengths = new ArrayList<Float>();
ArrayList<Float> rotations = new ArrayList<Float>();

void arrayInit(){
  list.clear();
  list.add(start_r1);
  list.add(start_r2);
  list.add(start_r3);
  list.add(endPointR);
  lengths.clear();
  lengths.add(r0);
  lengths.add(r1);
  lengths.add(r2);
  lengths.add(r3);
  rotations.clear();
  rotations.add(0.0);
  rotations.add(0.0);
  rotations.add(0.0);
  rotations.add(0.0);

};

void rotationCalculator(){
  for(int i = 0; i < rotations.size() - 2; i++) {
    Vec2 direction = list.get(i + 1).minus(list.get(i));
    direction.normalize();
    Vec2 uDirection = new Vec2(1,0);
    float worldRot = acos(dot(direction,uDirection));
    if (cross(direction, uDirection) < 0) {
      rotations.set(i,worldRot);
    }
    else {
      rotations.set(i,-worldRot);
    }
  }
}

void backwards(Vec2 goal) {
  arrayInit();
  endPointR = goal;
  for(int i = list.size() - 2; i > 0; i--) {
    Vec2 r = list.get(i + 1).minus(list.get(i));
    float l = lengths.get(i) / r.magnitude();
    Vec2 pos = list.get(i + 1).times(l - 1);
    pos.add(list.get(i).times(l));
    list.set(i,pos);
  }
}

void forwards(Vec2 goal) {
  arrayInit();
  start_r1 = rootr;
  for(int i = 0; i < list.size() - 2; i++) {
    Vec2 r = list.get(i + 1).minus(list.get(i));
    float l = lengths.get(i) / r.magnitude();
    Vec2 pos = list.get(i + 1).times(l - 1);
    pos.add(list.get(i).times(l));
    list.set(i,pos);
  }
}

void solveR(Vec2 goal){
   Vec2 startToGoal = goal.minus(rootr);
   fk();
   rotationCalculator();
   if(startToGoal.magnitude() > totalLength) {
     println("too far");
   }
   else {
     int counter = 0;
     float dif = endPointR.minus(goal).magnitude();
     while(dif > .01) {
       backwards(goal);
       forwards(goal);
       counter += 1;
       if (counter > 10) break;
       print(list);
     }
   }
   
  
  
  
  
  //Vec2 startToGoal, startToEndEffector;
  //float dotProd, angleDiff;
  
  ////extra joint
  //startToGoal = goal.minus(start_r3);
  //startToEndEffector = endPointR.minus(start_r3);
  //dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
  //dotProd = clamp(dotProd,-1,1);
  //angleDiff = acos(dotProd);
  //if (cross(startToGoal,startToEndEffector) < 0)
  //  ar3 += angleDiff;
  //else
  //  ar3 -= angleDiff;
    
  //if(ar3 > Math.PI/4)
  //  ar3 = (float)Math.PI/4;
  //else if(ar3 < -Math.PI/4)
  //  ar3 = (float)-Math.PI/4;
    
  //fk(); //Update link positions with fk (e.g. end effector changed)
  
  ////Update wrist joint
  //startToGoal = goal.minus(start_r2);
  //startToEndEffector = endPointR.minus(start_r2);
  //dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
  //dotProd = clamp(dotProd,-1,1);
  //angleDiff = acos(dotProd);
  //if (cross(startToGoal,startToEndEffector) < 0)
  //  ar2 += angleDiff;
  //else
  //  ar2 -= angleDiff;
    
  //if(ar2 > Math.PI/2)
  //  ar2 = (float)Math.PI/2;
  //else if(ar2 < -Math.PI/2)
  //  ar2 = (float)-Math.PI/2;
    
  //fk(); //Update link positions with fk (e.g. end effector changed)
  
  ////Update elbow joint
  //startToGoal = goal.minus(start_r1);
  //startToEndEffector = endPointR.minus(start_r1);
  //dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
  //dotProd = clamp(dotProd,-1,1);
  //angleDiff = acos(dotProd);
  //if (cross(startToGoal,startToEndEffector) < 0)
  //  ar1 += angleDiff;
  //else
  //  ar1 -= angleDiff;
     
  //fk(); //Update link positions with fk (e.g. end effector changed)
  
  ////Update shoulder joint
  //startToGoal = goal.minus(rootr);
  //if (startToGoal.length() < .0001) return;
  //startToEndEffector = endPointR.minus(rootr);
  //dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
  //dotProd = clamp(dotProd,-1,1);
  //angleDiff = acos(dotProd);
  //if (cross(startToGoal,startToEndEffector) < 0)
  //  ar0 += angleDiff;
  //else
  //  ar0 -= angleDiff;
   
  //if(ar0 < - Math.PI/2)
  //  ar0 = (float)(-Math.PI/2);
  //else if (ar0 > Math.PI/2)
  //  ar0 = (float)Math.PI/2;
 
  //fk(); //Update link positions with fk (e.g. end effector changed)
 
  //println("Right Angle 0:",ar0,"Right Angle 1:",ar1,"Right Angle 2:",ar2);
}
