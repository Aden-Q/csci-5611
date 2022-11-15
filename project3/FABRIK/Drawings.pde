void drawer(){
  background(250,250,250);
  lights();
  camera.Update(1.0/frameRate);
  fill(200,0,180);
  pushMatrix();
  translate(rootl.x,rootl.y);
  rect(0,0, 50, -50);
  popMatrix();
  
  pushMatrix();
  translate(rootl.x,rootl.y);
  rotate(a0);
  rect(0, -armW/2, l0, armW);
  popMatrix();
  
  pushMatrix();
  translate(start_l1.x,start_l1.y);
  rotate(a0+a1);
  rect(0, -armW/2, l1, armW);
  popMatrix();
  
  pushMatrix();
  translate(start_l2.x,start_l2.y);
  rotate(a0+a1+a2);
  rect(0, -armW/2, l2, armW);
  popMatrix();
  
  pushMatrix();
  translate(start_l3.x,start_l3.y);
  rotate(a0+a1+a2+a3);
  rect(0, -armW/2, l3, armW);
  popMatrix();
  
  
  pushMatrix();
  translate(rootr.x,rootr.y);
  rotate(ar0);
  rect(0, -armW/2, r0, armW);
  popMatrix();
  
  pushMatrix();
  translate(start_r1.x,start_r1.y);
  rotate(ar0+ar1);
  rect(0, -armW/2, r1, armW);
  popMatrix();
  
  pushMatrix();
  translate(start_r2.x,start_r2.y);
  rotate(ar0+ar1+ar2);
  rect(0, -armW/2, r2, armW);
  popMatrix();
  
  pushMatrix();
  translate(start_r3.x,start_r3.y);
  rotate(ar0+ar1+ar2+ar3);
  rect(0, -armW/2, r3, armW);
  popMatrix();
}
