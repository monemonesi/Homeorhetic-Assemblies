/*--------------------------------------------------------------------------------
***physical behaviors***
 ---------------------------------------------------------------------------------*/

void addSprings(){
    for (int i = 0; i < tempPart.size(); ++i) {
        Vec3D p = tempPart.get(i);
        //create Particles
        VerletParticle vp = new VerletParticle(p.copy());
        physics.addParticle(vp);
        //physics.addBehavior(new AttractionBehavior(vp, depth, -5));
        Vec3D force = field.evalFlow(vp);
        //force.scaleSelf(2);
        vp.addForce(force);
        //////// Connect with ground level
        if (vp.z<=depth) vp.z=0;

        //lock particles
        if ((vp.x==0 || vp.x == DIMX || vp.y==0 || vp.y==DIMY || vp.z==0 || vp.z==DIMZ) && 
            field.evalTemp(vp)>=(idealTemp-thresTemp) && field.evalTemp(vp)<=(idealTemp+thresTemp)) {
            vp.lock();
        }
        //cross refference with other particles
        int spP = 0;
        //int maxspP = 5;
        for (int j = 0; j < physics.particles.size(); ++j) {
            VerletParticle vpOther =(VerletParticle) physics.particles.get(j);
            float distance =p.distanceTo(vpOther);
            if (distance>0 && distance<minSpringsLength){
                physics.removeParticle(vp);
            }
            //Create new Springs
            else if (distance>=minSpringsLength && distance<=maxSpringsLength && spP<maxspP) {
                //Evaluate rlFactor
                //if (vpOther.z<=DIMZ*.5) rlFactor = map(vpOther.z, 0, DIMZ*.5, minRLFactor, 0.99);
                //if (vpOther.z>DIMZ*.5) rlFactor = map(vpOther.z, DIMZ*.5, DIMZ, 1.01, maxRLFactor);
                rlFactor = map(vpOther.z, 0, DIMZ, minRLFactor, maxRLFactor);
                if (distance*rlFactor <= minSpringsLength) rlFactor=(minSpringsLength/distance);
                if (distance*rlFactor >= maxSpringsLength) rlFactor=(maxSpringsLength/distance);
            
                VerletSpring sp = new VerletSpring(vp,vpOther,distance*rlFactor,stiffness);
                physics.addSpring(sp);
                spP++;
                //count++;
            }  
        }
    }

}//____End addSprings

void addSpringsSlice(){
    for (int i = 0; i < tempPart.size(); ++i) {
        Vec3D p = tempPart.get(i);
        //create Particles
        VerletParticle vp = new VerletParticle(p.copy());
        physics.addParticle(vp);
        //lock particles
        if ((vp.x==0 || vp.x == DIMX || vp.y==0 || vp.y==DIMY || vp.z==0 || vp.z==DIMZ) && 
            field.evalTemp(vp)>=(idealTemp-thresTemp) && field.evalTemp(vp)<=(idealTemp+thresTemp)) {
            vp.lock();
        }
        if (vp.isLocked()==false) {
            //_______________________________________________________Use constraint
            for (int k = 0; k < lNum; ++k) {
                Vec3D zero = lOrigins[k];
                if (abs(vp.z-zero.z)<(lStep/2)) {
                    Vec3D force = new Vec3D (vp.x, vp.y, zero.z);
                    force.subSelf(vp);
                    //force.scaleSelf(1);
                    vp.addForce(force);
                } 
            }
        }
        //cross refference with otherr particles
        for (int j = 0; j < physics.particles.size(); ++j) {
            VerletParticle vpOther =(VerletParticle) physics.particles.get(j);
            //if are in similar layers
            if (vpOther.z>=(vp.z-lStep)&&vpOther.z<=(vp.z+lStep)) {
                float distance =p.distanceTo(vpOther);
                if (distance>0 && distance<minSpringsLength){
                    physics.removeParticle(vp);
                }
                //Create new Springs
                else if (distance>=minSpringsLength && distance<=maxSpringsLength) {
                    //Evaluate rlFactor
                    //if (vpOther.z<=DIMZ*.5) rlFactor = map(vpOther.z, 0, DIMZ*.5, minRLFactor, 0.99);
                    //if (vpOther.z>DIMZ*.5) rlFactor = map(vpOther.z, DIMZ*.5, DIMZ, 1.01, maxRLFactor);
                    rlFactor = map(vpOther.z, 0, DIMZ, minRLFactor, maxRLFactor);
                    if (distance*rlFactor <= minSpringsLength) rlFactor=(minSpringsLength/distance);
                    if (distance*rlFactor >= maxSpringsLength) rlFactor=(maxSpringsLength/distance);
                    VerletSpring sp = new VerletSpring(vp,vpOther,distance*rlFactor,stiffness);
                    physics.addSpring(sp);
                    //count++;
                }
            }//if are in similar layers  
        }
    }

}//____End addSpringsSlice

void checkSprings(){
    //float rlThres = 0.01;
    //float rlThres=0;
    //float rlThresMax = .005;
    //float rlThresMin = .001;
    //float stiffening = .01;
    
    for (int i = 0; i < physics.springs.size(); ++i) {
        VerletSpring sp = (VerletSpring) physics.springs.get(i);
        float s = sp.getStrength();
          if (s<1) {
            float newS = constrain(s+stiffening, stiffness, 1);
            sp.setStrength(newS);
          }


        /*
        float getRL = sp.getRestLength();
        float distance = sp.a.distanceTo(sp.b);
        float RLratio= (getRL/distance);
        if (sp.a.z<=DIMZ/2) rlThres = map(sp.a.z, 0, DIMZ/2, rlThresMax, rlThresMin);
        if (sp.a.z>DIMZ/2) rlThres = map(sp.a.z, DIMZ/2, DIMZ, rlThresMin, rlThresMax);
        //rlThres = rlThresMin;
        //remove if are not useful
        if (RLratio >= 1-rlThres && RLratio <= 1+rlThres && s < .95) {
            physics.removeSpring(sp);
        }
        */
        
    }
}//____End checkSprings2


void checkSpringsF(){
    //float rlThres = 0.01;
    //float rlThres=0;
    //float rlThresMax = .01;
    //float rlThresMin = .001;
    //float stiffening = .01;
    
    for (int i = 0; i < physics.springs.size(); ++i) {
        VerletSpring sp = (VerletSpring) physics.springs.get(i);
        float s = sp.getStrength();
          if (s<1) {
            float newS = constrain(s+stiffening, stiffness, 1);
            sp.setStrength(newS);
          }


        ///*
        float getRL = sp.getRestLength();
        float distance = sp.a.distanceTo(sp.b);
        float RLratio= (getRL/distance);
        //if (sp.a.z<=DIMZ/2) rlThres = map(sp.a.z, 0, DIMZ/2, rlThresMax, rlThresMin);
        //if (sp.a.z>DIMZ/2) rlThres = map(sp.a.z, DIMZ/2, DIMZ, rlThresMin, rlThresMax);
        rlThres = map(sp.a.z, 0, DIMZ, rlThresMin, rlThresMax);
        //rlThres = rlThresMin;
        //remove if are not useful
        if (RLratio >= 1-rlThres && RLratio <= 1+rlThres && s < .98 /*(s>=1)*/) {
            physics.removeSpring(sp);
        }
        //*/
        //if (distance>1.5*depth) physics.removeSpring(sp);
        
    }
}//____End checkSpringsF

void slicing(){
    for (int i = 0; i < physics.particles.size(); ++i) {
        VerletParticle vp =(VerletParticle) physics.particles.get(i);
        if (vp.isLocked()==false) {
            ////_______________________________________________________add Force to particle
            for (int k = 1; k < lNum; ++k) {
                Vec3D zero = lOrigins[k];
                if (abs(vp.z-zero.z)<(lStep/2)) {
                    vp.z=zero.z;
                    vp.lock();
                } 
            }
        }
    }
}//____End slicing