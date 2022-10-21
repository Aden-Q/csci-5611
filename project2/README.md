# Project 2
Team memeber:
Zecheng Qian (qian0102@umn.edu)

## Part 1

+ ![demo_img](demo/img.png)
+ ![demo_video](demo/video.move)

### Demos


### Features
+ Multiple Ropes: The number of (independent) ropes can be adjusted by setting the parameter `numRopes` in the code, currently there are 3 ropes
+ Cloth Simulation
+ 3D Simulation: The camera (view point) orientation can be adjust by commands 'W', 'A', 'S', 'D', 'Q', 'E', $\leftarrow$, $\rightarrow$, $\uparrow$, $\downarrow$
+ High-quality Rendering: I use texturing and 3D lighting for the static ball and the balls on ropes
+ Air Drag for Cloth: The air drag term is introduced into the model by using the formula from the class
+ User Interaction: The user is allowed to click and drag the obstacle with the mouse
+ Realistic Speed: I recorded a video demonstrating the simulation speed of my program

### Code Link


### List of the tools/library you used
+ Skeleton code from `RopeStarter_Vec2.pde`
+ Camera library on Canvas
+ Brief write-up explaining difficulties you encountered: Triangulation of the cloth, in order to apply to air drag, we need to have 3 points to form a triangle, doing triangulation is not very intuitive with such a model. Besides, simulation with more ropes and more balls on each rope can cause the program to run slowly.
+ One or more images/videos showcasing features of your simulation: please check the demo section above.
