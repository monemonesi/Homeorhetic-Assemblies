/*--------------------------------------------------------------------------------
***3D GRAPHICS***
 ---------------------------------------------------------------------------------*/

void Graphicsdraw(){

    //draw world axes//////////////////////////////////////////////////////////
    pushStyle();
    pushMatrix();
    translate(-2, -2, -2);
    strokeWeight(1.5);
    stroke(255, 0, 0);
    line(0, 0, 0, 20, 0, 0);
    stroke(0, 255, 0);
    line(0, 0, 0, 0, 20, 0);
    stroke(0, 0, 255);
    line(0, 0, 0, 0, 0, 20);
    popStyle();
    popMatrix();
    
    //Draw Bounding Box//////////////////////////////////////////////////////////
    if (!showSpaces) { 
      pushMatrix();
      //from Rhyno
      scale(1,-1,1);
      translate(0,-DIMY,0);
      pushStyle();
      stroke(sCol);
      strokeWeight(0);
      fill(fCol,10);
      rect(0, 0, DIMX, DIMY);
      popStyle();
      translate(DIMX/2, DIMY/2, DIMZ/2);
      pushStyle();
      stroke(sCol);
      strokeWeight(1);
      noFill();
      box(DIMX, DIMY, DIMZ);
      popStyle();
      popMatrix();
    }
    
    //draw mesh for context//////////////////////////////////////////
    if (showSpaces) {
      println("showSpace");
      pushStyle();
      stroke(sCol);
      strokeWeight(1);
      fill(fCol,30);
      gfx.mesh(spaces, true);
      popStyle();
    }

    //draw particles' layer
    if (showLayers) {
      for (int i = 0; i < lNum; ++i) {
        pushMatrix();
        pushStyle();
        Vec3D zero = lOrigins[i];
        translate(0, 0, zero.z);
        fill(150, 20);
        rect(0, 0, DIMX, DIMY);
        popStyle();
        popMatrix();
      }
    }

    /*
    //draw repulsor/////////////////////////////////////////////////////////////
    pushStyle();
    for (int i = 0; i < repulsNumber; ++i) {
      int amplitude=5;
      Vec3D repLoc = repulsors[i];
      float repRange = rangeRepulsors[i];
      stroke(repColor);
      strokeWeight(repSize);
      point(repLoc.x, repLoc.y, repLoc.z);

      pushMatrix();
      translate(repLoc.x, repLoc.y, repLoc.z);
      for (int j = 0; j < repRange; j=j+amplitude) {
        stroke(repColor, map(j, 0, repRange, 255, 10)); 
        strokeWeight(repRangeSize);
        noFill(); 
        ellipse(0, 0, j,  j);
        
      }
      popMatrix();

    }
    popStyle();
    */

    //draw flow//////////////////////////////////////////////////////
    if (showFlowField) {
      println("showFlowField");
      field.displayFlow(3);
    }
    //draw temp//////////////////////////////////////////////////////
    if (showTemp) {
      println("showTemp");
      field.displayTemp();
    }

    //display temporary parts
    for (int i = 0; i < tempPart.size(); ++i) {
      Vec3D p = tempPart.get(i);
      strokeWeight(1);
      stroke(255,0,0);
      point(p.x, p.y, p.z);
    }

}

void drawParticles(){
  //for (int i = (physics.particles.size()-1); i >=0; --i) {
  for (int i = 0; i < physics.particles.size(); ++i) {
    VerletParticle vpDraw =(VerletParticle) physics.particles.get(i);
    strokeWeight(PtSize);
    if (vpDraw.isLocked()) {
      strokeWeight(3);
      stroke(0,255,0);
    }
    else {
      strokeWeight(PtSize);
      stroke(PartCol);
    }
    point(vpDraw.x, vpDraw.y, vpDraw.z);
  }   
}


void drawSprings(){
  //for (int i = (physics.springs.size()-1); i >=0; --i) {
  for (int i = 0; i < physics.springs.size(); ++i) {
    VerletSpring sp = (VerletSpring) physics.springs.get(i);
    if (sp.a.x>=0 && sp.a.x<=DIMX && sp.a.y>=0 && sp.a.y<=DIMY && sp.a.z>=0 && sp.a.z<=DIMZ &&
      sp.b.x>=0 && sp.b.x<=DIMX && sp.b.y>=0 && sp.b.y<=DIMY && sp.b.z>=0 && sp.b.z<=DIMZ) {

      float s = constrain(sp.getStrength(), stiffness, 1); 

      float spColRed = map(s, stiffness, 1, 252, 10);        // 
      float spColGreen = map(s, stiffness, 1, 53, 191);      // MIAKA
      float spColBlue = map(s, stiffness, 1, 76, 188);      // 
      stroke(spColRed, spColGreen, spColBlue);
      strokeWeight(map(s, stiffness, 1, .2, .4)); //.3,.4
      //strokeWeight(1);
      line(sp.a.x,sp.a.y,sp.a.z, sp.b.x,sp.b.y,sp.b.z);  //all springs starts from a and it ends to b

    }
  }

}


void drawDeformation(){
  for (int i = 0; i < physics.springs.size(); ++i) {
    VerletSpring sp = (VerletSpring) physics.springs.get(i);
    if (sp.a.x>=0 && sp.a.x<=DIMX && sp.a.y>=0 && sp.a.y<=DIMY && sp.a.z>=0 && sp.a.z<=DIMZ &&
      sp.b.x>=0 && sp.b.x<=DIMX && sp.b.y>=0 && sp.b.y<=DIMY && sp.b.z>=0 && sp.b.z<=DIMZ) {
        float getRL = sp.getRestLength();
        float distance = sp.a.distanceTo(sp.b);
        float RLratio= (getRL/distance);

        //if (sp.a.z<=DIMZ/2) rlThres = map(sp.a.z, 0, DIMZ/2, rlThresMax, rlThresMin);
        //if (sp.a.z>DIMZ/2) rlThres = map(sp.a.z, DIMZ/2, DIMZ, rlThresMin, rlThresMax);
        rlThres = map(sp.a.z, 0, DIMZ, rlThresMin, rlThresMax);

        strokeWeight(.4); //.4
        if (RLratio <= (1-rlThres)) {
          float spColRed = map(RLratio, .9, 1, maxCol, minCol);
          stroke(spColRed, otherCol, 0, 200);
          line(sp.a.x,sp.a.y,sp.a.z, sp.b.x,sp.b.y,sp.b.z);  
        }
        else if (RLratio >= (1+rlThres)) {
          float spColGreen = map(RLratio, 1, 1.1, minCol, maxCol); 
          stroke(otherCol, spColGreen, 0, 200);
          line(sp.a.x,sp.a.y,sp.a.z, sp.b.x,sp.b.y,sp.b.z);
        }
        else if (RLratio > (1-rlThres) && RLratio < (1+rlThres)) {
          float spColRed = map(RLratio, .9, 1, maxColDel, minColDel);
          float spColGreen = map(RLratio, 1, 1.1, minColDel, maxColDel); 
          stroke(spColRed, spColGreen, 0, 200);
          line(sp.a.x,sp.a.y,sp.a.z, sp.b.x,sp.b.y,sp.b.z);
        }
        
    }
  }
}


