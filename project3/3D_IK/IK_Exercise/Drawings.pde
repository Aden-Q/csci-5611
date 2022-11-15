void drawer(){
  background(250,250,250);
  lights();
  camera.Update(1.0/frameRate);
  pushMatrix();
  noStroke();
  translate((rootl.x+rootr.x)/2, (rootl.y+rootr.y)/2 - 1.5*sphereRadius,rootl.z);
  shape(ball);
  popMatrix();
  
  fill(200,0,180);
  pushMatrix();
  translate(rootl.x,rootl.y, rootl.z);
  rotateZ(a0);
  box(l0+armW/2, armW/2, armW/2);
  popMatrix();
  
  pushMatrix();
  translate(start_l1.x,start_l1.y, start_l1.z);
  rotateZ(a0+a1);
  box(l1, armW/2, armW/2);
  popMatrix();
  
  pushMatrix();
  translate(start_l2.x,start_l2.y, start_l2.z);
  rotateZ(a0+a1+a2);
  box(l2, armW/2, armW/2);
  popMatrix();
  
  pushMatrix();
  translate(start_l3.x,start_l3.y, start_l3.z);
  rotateZ(a0+a1+a2+a3);
  box(l3, armW/2, armW/2);
  popMatrix();
  
  
  pushMatrix();
  translate(rootr.x,rootr.y, rootr.z);
  rotateZ(ar0);
  box(r0+armW/2, armW/2, armW/2);
  popMatrix();
  
  pushMatrix();
  translate(start_r1.x,start_r1.y, start_r1.z);
  rotateZ(ar0+ar1);
  box(r1, armW/2, armW/2);
  popMatrix();
  
  pushMatrix();
  translate(start_r2.x,start_r2.y, start_r2.z);
  rotateZ(ar0+ar1+ar2);
  box(r2, armW/2, armW/2);
  popMatrix();
  
  pushMatrix();
  translate(start_r3.x,start_r3.y, start_r3.z);
  rotateZ(ar0+ar1+ar2+ar3);
  box(r3, armW/2, armW/2);
  popMatrix();
}
