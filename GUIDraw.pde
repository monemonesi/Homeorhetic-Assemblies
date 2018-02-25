/*--------------------------------------------------------------------------------
***2D GRAPHICS***
 ---------------------------------------------------------------------------------*/


void GUIDraw() {

  currCameraMatrix = new PMatrix3D(g3.camera);                         // 1. stores current camera matrix

  float d = (float)cam.getDistance();                                  // 1.1 get some camera data
  float[] pos = cam.getLookAt();
  String camPos = ". camera position: x."+pos[0]+" | y."+pos[1]+" | z."+pos[2];
  float[] rot = cam.getRotations();
  String camRot = ". camera rotation: x."+rot[0]+" | y."+rot[1]+" | z."+rot[2];
  camera();                                                            // 2. resets camera to 2D plan view
  pushStyle();
  noStroke();
  strokeWeight(1);


  //stroke(baseMag);
  //line(270,0,270,height);
  
  //_______________________________________________________________________TITLE
  textSize(18);                                                        
  fill(txtCol);
  if (!layered) {
    text("HOMEORHETIC ASSEMBLIES_frameCount: "
      +(countGrowth)+" / "+(stopGrowth), 10, 30);
  }
  else if (layered) {
    text("HOMEORHETIC ASSEMBLIES_Layered_frameCount: "
      +(countGrowth)+" / "+(stopGrowth), 10, 30);
  }
  
  
  //_________________________________________________________________2D GRAPHICS
  strokeWeight(0.8);
  stroke(baseBlue);
  line(10,60,
    (10+DIMY/scaleFac+space2D*.5)-60,60);
  line((10+DIMY/scaleFac+space2D*.5)+60,60,
    (10+(DIMY/scaleFac)*2+space2D),60);
  textSize(14);
  fill(txtCol);
  text("ORTHO VIEW", (10+DIMY/scaleFac+space2D*.5)-45, 60);
  
  if (! infographics) {
    //________________________________________________________________PROJECT INFO
      strokeWeight(0.8);
      stroke(baseBlue);
      line(10,height-85,
        (10+DIMY/scaleFac+space2D*.5)-70,height-85);
      line((10+DIMY/scaleFac+space2D*.5)+60,height-85,
        (10+(DIMY/scaleFac)*2+space2D),height-85);
      textSize(14);
      fill(txtCol);
      text("PROJECT INFO", (10+DIMY/scaleFac+space2D*.5)-55, height-85);
      textSize(10);
      fill(txtCol);  
      text("_ AGENTS: "+(agents.size()),buttonXStart,height-65);
      text("_ PARTICLES: "+(physics.particles.size()),buttonXStart,height-50);
      text("_ SPRINGS: "+physics.springs.size(),buttonXStart,height-35);
      text("_ SPRINGS LENGTH: ["+(minSpringsLength)+";"+(maxSpringsLength)+"]",buttonXStart,height-20);
  }
  if (infographics) {

    //___________________________________________________________USER MENU GRAPHICS
      strokeWeight(0.8);
      stroke(baseBlue);
      line(10,buttonYStart-15,197,buttonYStart-15);
      textSize(10);
      fill(txtCol);
      text("USER MENU",207,buttonYStart-15);
      textSize(9);                                                        
      fill(txtCol);                                                        
      // USER MENU TEXT
      text("_ R = RUN SKETCH.",buttonXStart,buttonYStart);
      text("_ P = PAUSE.",buttonXStart+115,buttonYStart);
      text("_ S = SAVE SPRINGS.",buttonXStart,buttonYStart+10);
      text("_ V = VIDEO RECORDING.",buttonXStart+115,buttonYStart+10);
      text("_ D = DEFORMATION.",buttonXStart,buttonYStart+20);
      text("_ A = ANCHOR PT.",buttonXStart+115,buttonYStart+20);
      //text("_ V = VIDEO RECORDING.",buttonXStart,buttonYStart+30);

    //________________________________________________________________PROJECT INFO
      strokeWeight(0.8);
      stroke(baseBlue);
      line(10,height-85,185,height-85);
      textSize(10);
      fill(txtCol);
      text("PROJECT INFO",195,height-85);
      textSize(10);
      fill(txtCol);  
      text("_ AGENTS: "+(agents.size()),buttonXStart,height-50);
      text("_ PARTICLES: "+(physics.particles.size()),buttonXStart,height-40);
      text("_ SPRINGS: "+physics.springs.size(),buttonXStart,height-30);
      text("_ SPRINGS LENGTH: ["+(minSpringsLength)+";"+(maxSpringsLength)+"]",buttonXStart,height-20);
    
    

    //camera info
    textSize(15);
    text(". camera current distance: "+ round(d), 600, 500); //active for set camera!!!!!  
    text(camPos, 600, 450);                                       //active for set camera!!!!!       
    text(camRot, 600, 400);                                       //active for set camera!!!!!

    c5.draw();                                                             // 4. draws 2D ControlP5 interface
  }
  
  g3.camera = currCameraMatrix;                                        // 5. restores current camera matrix

  popStyle();
} 




//////////////////////////////////////////////////////////////////////Function for draw 2D

void OrthoView2D(){
  //_____________________________TopView Bounds
  pushMatrix();
  translate(10, 70);
  scale(1,-1,1);
  translate(0,-DIMY/scaleFac,0);

  stroke(150);
  strokeWeight(.5);
  fill(fCol,20);
  
  rect(0, 0, DIMX/scaleFac, DIMY/scaleFac);
  
  translate(DIMX/scaleFac+space2D,0,0);
  rect(0, 0, DIMX/scaleFac, DIMY/scaleFac);
  
  popMatrix();
  //_________________________LateralView Bounds
  pushMatrix();

  translate(10, 70+DIMY/scaleFac+space2D);
  scale(1,-1,1);
  translate(0,-DIMZ/scaleFac,0);
  rect(0, 0, DIMX/scaleFac, DIMZ/scaleFac);
  //design stiffnes scale///////////////////////////////////////
  for (int i = 1; i < end2D; ++i) {
    float spColRed = map(i, 10, end2D, 252, 10);        // 
    float spColGreen = map(i, 10, end2D, 53, 191);      // MIAKA
    float spColBlue = map(i, 10, end2D, 76, 188);
    stroke(spColRed, spColGreen, spColBlue);      // 
    strokeWeight(1);
    line(i, lineY-gDepth, i, lineY+gDepth);
  }
  stroke(150);
  strokeWeight(1);
  fill(fCol,20);
  line(0, lineY-10, 0, lineY+10);
  line(end2D, lineY-10, end2D, lineY+10);
  scale(1,-1,1); //ONLY FOR TEXT
  textSize(12);
  fill(txtCol);
  text("STIFFNESS",(end2D*.5)-27, lineY+80);
  textSize(10);
  text((stiffness), -4, lineY+45);
  text("1,000", end2D-25, lineY+45);
  ////////////////////////////////////////////////////////////////
  stroke(150);
  strokeWeight(0.5);
  fill(fCol,20);
  scale(1,-1,1);
  translate(DIMX/scaleFac+space2D,0,0);
  rect(0, 0, DIMX/scaleFac, DIMZ/scaleFac);
  //design deformed scale///////////////////////////////////////
  int th = 15;
  strokeWeight(1);
  for (int i = 1; i <= (end2D*.5)-th; ++i) {
    float spColRed = map(i, 1, (end2D*.5)-th, maxCol, minCol); 
    stroke(spColRed, otherCol, 0);
    line(i, lineY-gDepth, i, lineY+gDepth);
  }
  for (int i = int((end2D*.5)-th+1); i < int((end2D*.5)+th); ++i) {
    float spColRed = map(i, int((end2D*.5)-th), int((end2D*.5)+th), maxColDel, minColDel); 
    float spColGreen = map(i, int((end2D*.5)-th), int((end2D*.5)+th), minColDel, maxColDel);
    stroke(spColRed, spColGreen, 0);
    line(i, lineY-gDepth, i, lineY+gDepth);
  }
  for (int i = int((end2D*.5)+th); i <= end2D; ++i) {
    float spColGreen = map(i, int((end2D*.5)+th), end2D, minCol, maxCol);
    stroke(otherCol, spColGreen, 0);
    line(i, lineY-gDepth, i, lineY+gDepth);
  }

  stroke(150);
  strokeWeight(1);
  fill(fCol,20);
  line(0, lineY-10, 0, lineY+10);
  line(int((end2D*.5)-th+1), lineY-10, int((end2D*.5)-th+1), lineY+10);
  line(end2D*.5, lineY-10, end2D*.5, lineY+10);
  line(int((end2D*.5)+th-1), lineY-10, int((end2D*.5)+th-1), lineY+10);
  line(end2D, lineY-10, end2D, lineY+10);
  scale(1,-1,1); //ONLY FOR TEXT
  textSize(12);
  fill(txtCol);
  text("DEFORMATION",(end2D*.5)-38, lineY+80);
  textSize(10);
  text("50%", 0, lineY+45);
  text("CULL RANGE",(end2D*.5)-34, lineY+45);
  text("150%", end2D-25, lineY+45);
  ////////////////////////////////////////////////////////////////
  popMatrix();
  ///*
  //_______________________________Draw Springs
  if (physics.springs!=null) {
    for (int i = 0; i < physics.springs.size(); ++i) {
      VerletSpring sp = (VerletSpring) physics.springs.get(i);
      if (sp.a.x>=0 && sp.a.x<=DIMX && sp.a.y>=0 && sp.a.y<=DIMY && sp.a.z>=0 && sp.a.z<=DIMZ &&
        sp.b.x>=0 && sp.b.x<=DIMX && sp.b.y>=0 && sp.b.y<=DIMY && sp.b.z>=0 && sp.b.z<=DIMZ) {
          //_________________________________________________________________________Stiffness Style
            pushStyle();
            float s = constrain(sp.getStrength(), stiffness, 1); 
            strokeWeight(map(s, stiffness, 1, .2, .4));
            float spColRed = map(s, stiffness, 1, 252, 10);        // 
            float spColGreen = map(s, stiffness, 1, 53, 191);      // MIAKA
            float spColBlue = map(s, stiffness, 1, 76, 188);      // 
            stroke(spColRed, spColGreen, spColBlue);
            //_________________________________________________________________TopView
            pushMatrix();
            translate(10, 70);
            scale(1,-1,1);
            translate(0,-DIMY/scaleFac,0);
            line(sp.a.x/scaleFac,sp.a.y/scaleFac,0, sp.b.x/scaleFac,sp.b.y/scaleFac,0);
            popMatrix();
            //_____________________________________________________________LateralView
            pushMatrix();
            translate(10, 70+DIMY/scaleFac+space2D);
            scale(1,-1,1);
            translate(0,-DIMZ/scaleFac,0);
            line(sp.a.x/scaleFac,sp.a.z/scaleFac,0, sp.b.x/scaleFac,sp.b.z/scaleFac,0);
            popMatrix();
            popStyle();
          //_________________________________________________________________________deformed Style
            ///*
            pushStyle();
            float getRL = sp.getRestLength();
            float distance = sp.a.distanceTo(sp.b);
            float RLratio= (getRL/distance);
            //if (sp.a.z<=DIMZ/2) rlThres = map(sp.a.z, 0, DIMZ/2, rlThresMax, rlThresMin);
            //if (sp.a.z>DIMZ/2) rlThres = map(sp.a.z, DIMZ/2, DIMZ, rlThresMin, rlThresMax);
            rlThres = map(sp.a.z, 0, DIMZ, rlThresMin, rlThresMax);
            strokeWeight(.3); //.4
            //_______________________________________________________TopView
            pushMatrix();
            translate(10, 70);
            scale(1,-1,1);
            translate(0,-DIMY/scaleFac,0);
            translate(DIMX/scaleFac+space2D,0,0);
            if (RLratio <= (1-rlThres)) {
              float spColRedD = map(RLratio, .9, 1, maxCol, minCol);
              stroke(spColRedD, otherCol, 0, 200);
              line(sp.a.x/scaleFac,sp.a.y/scaleFac,0, sp.b.x/scaleFac,sp.b.y/scaleFac,0);  
            }
            else if (RLratio >= (1+rlThres)) {
              float spColGreenD = map(RLratio, 1, 1.1, minCol, maxCol); 
              stroke(otherCol, spColGreenD, 0, 200);
              line(sp.a.x/scaleFac,sp.a.y/scaleFac,0, sp.b.x/scaleFac,sp.b.y/scaleFac,0);
            }
            else if (RLratio > (1-rlThres) && RLratio < (1+rlThres)) {
              float spColRedD = map(RLratio, .9, 1, maxColDel, minColDel);
              float spColGreenD = map(RLratio, 1, 1.1, minColDel, maxColDel); 
              stroke(spColRedD, spColGreenD, 0, 200);
              line(sp.a.x/scaleFac,sp.a.y/scaleFac,0, sp.b.x/scaleFac,sp.b.y/scaleFac,0);
            }
            popMatrix();
            //___________________________________________________LateralView
            pushMatrix();
            translate(10, 70+DIMY/scaleFac+space2D);
            scale(1,-1,1);
            translate(0,-DIMZ/scaleFac,0);
            translate(DIMX/scaleFac+space2D,0,0);
            if (RLratio <= (1-rlThres)) {
              float spColRedD = map(RLratio, .9, 1, maxCol, minCol);
              stroke(spColRedD, otherCol, 0, 200);
              line(sp.a.x/scaleFac,sp.a.z/scaleFac,0, sp.b.x/scaleFac,sp.b.z/scaleFac,0);  
            }
            else if (RLratio >= (1+rlThres)) {
              float spColGreenD = map(RLratio, 1, 1.1, minCol, maxCol); 
              stroke(otherCol, spColGreenD, 0, 200);
              line(sp.a.x/scaleFac,sp.a.z/scaleFac,0, sp.b.x/scaleFac,sp.b.z/scaleFac,0);
            }
            else if (RLratio > (1-rlThres) && RLratio < (1+rlThres)) {
              float spColRedD = map(RLratio, .9, 1, maxColDel, minColDel);
              float spColGreenD = map(RLratio, 1, 1.1, minColDel, maxColDel); 
              stroke(spColRedD, spColGreenD, 0, 200);
              line(sp.a.x/scaleFac,sp.a.z/scaleFac,0, sp.b.x/scaleFac,sp.b.z/scaleFac,0);
            }
            popMatrix();
            popStyle();
            //*/
      }

    }
  } 
  //*/
  
}