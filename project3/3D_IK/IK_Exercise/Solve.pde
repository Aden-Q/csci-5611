Vec3 rootl = new Vec3(50,375,0);
import java.lang.Math.*;

//Upper Arm
float l0 = 60;
float a0 = PI/2; //Shoulder joint

//Lower Arm
float l1 = 50;
float a1 = 0.2; //Elbow joint

//Hand
float l2 = 50;
float a2 = 0.2; //Wrist joint

//extra?
float l3 = 60;
float a3 = 0.2; //extra joint

Vec3 start_l1,start_l2,start_l3,endPointL;

float ground_y = rootl.y + l0 + l1 + l2 + l3;

void solveL(Vec3 goal){
  Vec3 startToGoal, startToEndEffector;
  float dotProd, angleDiff;

  //extra
  startToGoal = goal.minus(start_l3);
  startToEndEffector = endPointL.minus(start_l3);
  dotProd = dot3d(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if (cross3d(startToGoal,startToEndEffector) < 0)
    a3 += angleDiff/4;
  else
    a3 -= angleDiff/4;

  /* Wrist joint limits*/
  if(a3 > Math.PI/4){
    a3 = (float)Math.PI/4;
  }
  else if(a3 < -Math.PI/4)
    a3 = (float)-Math.PI/4;
//
  fk(); //Update link positions with fk (e.g. end effector changed)

  //Update wrist joint
  startToGoal = goal.minus(start_l2);
  startToEndEffector = endPointL.minus(start_l2);
  dotProd = dot3d(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if (cross3d(startToGoal,startToEndEffector) < 0)
    a2 += angleDiff/1.4;
  else
    a2 -= angleDiff/1.4;

  if(a2 > Math.PI/4)
    a2 = (float)Math.PI/4;
  else if(a2 < -Math.PI/4)
    a2 = (float)-Math.PI/4;

  fk(); //Update link positions with fk (e.g. end effector changed)

  //Update elbow joint
  startToGoal = goal.minus(start_l1);
  startToEndEffector = endPointL.minus(start_l1);
  dotProd = dot3d(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if (cross3d(startToGoal,startToEndEffector) < 0)
    a1 += angleDiff;
  else
    a1 -= angleDiff;

  if(a1 > Math.PI/4)
    a1 = (float)Math.PI/4;
  else if(a1 < -Math.PI/4)
    a1 = (float)-Math.PI/4;

  fk(); //Update link positions with fk (e.g. end effector changed)

  //Update shoulder joint
  startToGoal = goal.minus(rootl);
  if (startToGoal.length() < .0001) return;
  startToEndEffector = endPointL.minus(rootl);
  dotProd = dot3d(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if (cross3d(startToGoal,startToEndEffector) < 0)
    a0 += angleDiff;
  else
    a0 -= angleDiff;

  /*TODO: Shoulder joint limits here*/
  if (a0 < Math.PI/2)
    a0 = (float)Math.PI/2;
  else if (a0 > 3*Math.PI/2)
    a0 = (float)(3*Math.PI/2);

  fk(); //Update link positions with fk (e.g. end effector changed)

  println("Left Angle 0:",a0,"Left Angle 1:",a1,"Left Angle 2:",a2, "left 3: ", a3);
}

Vec3 rootr = new Vec3(100,375,0);

//Upper Arm
float r0 = 60;
float ar0 = PI/2; //Shoulder joint

//Lower Arm
float r1 = 50;
float ar1 = 0.1; //Elbow joint

//Hand
float r2 = 50;
float ar2 = 0.1; //Wrist joint

//extra hand?
float r3 = 60;
float ar3 = 0.1; //extra joint

Vec3 start_r1,start_r2,start_r3,endPointR;


void solveR(Vec3 goal){
  Vec3 startToGoal, startToEndEffector;
  float dotProd, angleDiff;

  //extra joint
  startToGoal = goal.minus(start_r3);
  startToEndEffector = endPointR.minus(start_r3);
  dotProd = dot3d(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if (cross3d(startToGoal,startToEndEffector) < 0)
    ar3 += angleDiff/4;
  else
    ar3 -= angleDiff/4;

  if(ar3 > Math.PI/4)
    ar3 = (float)Math.PI/4;
  else if(ar3 < -Math.PI/4)
    ar3 = (float)-Math.PI/4;

  fk(); //Update link positions with fk (e.g. end effector changed)

  //Update wrist joint
  startToGoal = goal.minus(start_r2);
  startToEndEffector = endPointR.minus(start_r2);
  dotProd = dot3d(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if (cross3d(startToGoal,startToEndEffector) < 0)
    ar2 += angleDiff/1.4;
  else
    ar2 -= angleDiff/1.4;

  if(ar2 > Math.PI/4)
    ar2 = (float)Math.PI/4;
  else if(ar2 < -Math.PI/4)
    ar2 = (float)-Math.PI/4;

  fk(); //Update link positions with fk (e.g. end effector changed)

  //Update elbow joint
  startToGoal = goal.minus(start_r1);
  startToEndEffector = endPointR.minus(start_r1);
  dotProd = dot3d(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if (cross3d(startToGoal,startToEndEffector) < 0)
    ar1 += angleDiff;
  else
    ar1 -= angleDiff;

  fk(); //Update link positions with fk (e.g. end effector changed)

  //Update shoulder joint
  startToGoal = goal.minus(rootr);
  if (startToGoal.length() < .0001) return;
  startToEndEffector = endPointR.minus(rootr);
  dotProd = dot3d(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if (cross3d(startToGoal,startToEndEffector) < 0)
    ar0 += angleDiff;
  else
    ar0 -= angleDiff;

  if(ar0 < - Math.PI/2)
    ar0 = (float)(-Math.PI/2);
  else if (ar0 > Math.PI/2)
    ar0 = (float)Math.PI/2;

  fk(); //Update link positions with fk (e.g. end effector changed)

  //println("Right Angle 0:",ar0,"Right Angle 1:",ar1,"Right Angle 2:",ar2, "3:", ar3);
}
