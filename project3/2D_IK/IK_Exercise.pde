//Inverse Kinematics
//CSCI 5611 IK [Solution]
// Stephen J. Guy <sjguy@umn.edu>

/*
INTRODUCTION:
Rather than making an artist control every aspect of a characters animation, we will often specify 
key points (e.g., center of mass and hand position) and let an optimizer find the right angles for 
all of the joints in the character's skelton. This is called Inverse Kinematics (IK). Here, we start 
with some simple IK code and try to improve the results a bit to get better motion.

TODO:
Step 1. Change the joint lengths and colors to look more like a human arm. Try to match 
        the length ratios of your own arm/hand, and try to match your own skin tone in the rendering.

Step 2: Add an angle limit to the wrist joint, and limit it to be within +/- 90 degrees relative
        to the lower arm.
        -Be careful to put the joint limits for the wrist *before* you compute the new end effoctor
         position for the next link in CCD

Step 3: Add an angle limit to the shoulder joint to limit the joint to be between 0 and 90 degrees, 
        this should stop the top of the arm from moving off screen.

Step 4: Cap the acceleration of each joint so the joints can only update slowly. Try to tweak the 
        acceleration cap to be different for each joint to get a good effect on the arm motion.

Step 5: Try adding a 4th limb to the IK chain.


CHALLENGE:

1. Go back to the 3-limb arm, can you make it look more human-like. Try adding a simple body to 
   the scene using circles and rectangles. Can you make a scene where the character picks up 
   something and moves it somewhere?
2. Create a more full skeleton. How do you handle the torso having two different arms?

*/

void setup(){
  size(1000,800);
  surface.setTitle("Inverse Kinematics [CSCI 5611 Example]");
}

void fk(){
  start_l1 = new Vec2(cos(a0)*l0,sin(a0)*l0).plus(rootl);
  start_l2 = new Vec2(cos(a0+a1)*l1,sin(a0+a1)*l1).plus(start_l1);
  start_l3 = new Vec2(cos(a0+a1 +a2)*l2,sin(a0+a1+a2)*l2).plus(start_l2);
  endPointL = new Vec2(cos(a0+a1+a2+a3)*l3,sin(a0+a1+a2+a3)*l3).plus(start_l3);
  start_r1 = new Vec2(cos(ar0)*r0,sin(ar0)*r0).plus(rootr);
  start_r2 = new Vec2(cos(ar0+ar1)*r1,sin(ar0+ar1)*r1).plus(start_r1);
  start_r3 = new Vec2(cos(ar0+ar1 +ar2)*r2,sin(ar0+ar1+ar2)*r2).plus(start_r2);
  endPointR = new Vec2(cos(ar0+ar1+ar2+ar3)*r3,sin(ar0+ar1+ar2+ar3)*r3).plus(start_r3);
}

void initScene(){
  rootl = new Vec2(50,375);
  rootr = new Vec2(100,375);
  fk();
}

float armW = 20;
boolean paused = false;
boolean walk = false;
float step_size = 1;
float culmu_steps = 0;
void draw(){
  if (!paused) {
    if (!walk) {
      fk();
      solveL(new Vec2(mouseX, mouseY));
      solveR(new Vec2(mouseX, mouseY));
    } else {
      update(frameRate);
    }
  }
  drawer();
}

void update(float dt) {
  culmu_steps += step_size;
  if (culmu_steps < 40) {
    updateL(dt);
  } else if (culmu_steps < 80) {
     updateR(dt);
  } else {
     // reset
     culmu_steps = 0;
  }
}

void updateL(float dt) {
  dt = 1;
  rootl.add(new Vec2(step_size * 3 * dt, 0));
  rootr.add(new Vec2(step_size * 3 * dt, 0));
  float target_x = endPointL.x + step_size * dt * 4;
  float target_y = ground_y;
  float old_endPointRx = endPointR.x;
  float old_endPointRy = endPointR.y;
  fk();
  solveL(new Vec2(target_x, target_y));
  solveR(new Vec2(old_endPointRx, old_endPointRy));
}

void updateR(float dt) {
  dt = 1;
  rootl.add(new Vec2(step_size * 3 * dt, 0));
  rootr.add(new Vec2(step_size * 3 * dt, 0));
  float target_x = endPointR.x + step_size * dt * 4;
  float target_y = ground_y;
  float old_endPointLx = endPointL.x;
  float old_endPointLy = endPointL.y;
  fk();
  solveL(new Vec2(old_endPointLx, old_endPointLy));
  solveR(new Vec2(target_x, target_y));
}

void keyPressed(){
  if (key == ' ')
    // stop or resume the animation
    paused = !paused;
  else if (key == 'T' || key == 't')
    // switch to walking mode
    walk = !walk;
  else if (key == 'R' || key == 'r')
    // reset
    initScene();
}
