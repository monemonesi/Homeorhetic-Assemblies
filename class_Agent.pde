class Agent{
	//General Agents Variables
	Vec3D loc, vel, acc, world, futVec, futLoc, startLoc;
	float futLocMag = 3;
	float maxSpeed = .5;
	float maxForce = .2;//.3; // misura dell'inverso dell'inerzia

	//tail variables
	ArrayList <Vec3D> tail = new ArrayList <Vec3D> ();//
  int tCount = 0;
  int tLen = 50;
  int tStep = 1;
  int repCount = 0;
  int repStep = 8; 
  float repDist= 2*depth;
  boolean repTest1 = true;
  boolean repTest2 = true;



  //set age for each agent
  int age=0;



  Vec3D zRef = new Vec3D (0,0,1);



	//__________________________________CONSTRUCTORS
	 Agent(Vec3D loc, Vec3D world) {
    	this.loc = loc;
    	this.world= world;
      //record the start Loc
      startLoc= new Vec3D(loc.copy());
      vel = new Vec3D();
      float mag = map(flowMag, 0, .1, 0, 1);
      if(startLoc.z==0||startLoc.z==world.z || startLoc.x==0 || startLoc.x==world.x) {
        startLocTot.add(startLoc);
        //set start velocity 
        vel = followField(field);
        vel.normalizeTo(mag);
        //if (startLoc.z==0) vel.set(0,0,1);
        //if (startLoc.z==world.z) vel.set(0,0,-1);
        //if (startLoc.x==0) vel.set(1,0,0);
        //else if (startLoc.x==world.x) vel.set(-1,0,0);
        //if (startLoc.z==0) vel.addSelf(0,0,1);
        //if (startLoc.z==world.z) vel.addSelf(0,0,-1);
        //if (startLoc.x==0) vel.addSelf(1,0,0);
        //else if (startLoc.x==world.x) vel.addSelf(-1,0,0);
      }
      else vel = followField(field).normalizeTo(mag);
      //vel.normalizeTo(mag);
    	acc = new Vec3D();
    	tCohAngleRad = radians(tCohMaxAngle);
    	tSepAngleRad = radians(tSepMaxAngle);
      ///*
      //create first particles
      if ((startLoc.z==0||startLoc.z==world.z) && field.evalTemp(loc)>=(idealTemp-thresTemp)
        && field.evalTemp(loc)<=(idealTemp+thresTemp)) {
          //Create double depth (follow flowfield)//////////////////////////////////////
          Vec3D fl2D = field.evalFlow(startLoc);
          fl2D.set(fl2D.x, fl2D.y, 0);
          fl2D.normalizeTo(depth);
          Vec3D flCross = new Vec3D(fl2D.copy().normalize().cross(zRef));
          flCross.normalizeTo(depth);
          //_______________create p0 particle
          VerletParticle p0 = new VerletParticle(startLoc.copy());
          physics.addParticle(p0);
          p0.lock();
          //_______________create p1 particle
          VerletParticle p1 = new VerletParticle(startLoc.copy().addSelf(flCross));
          physics.addParticle(p1);
          p1.lock();
          //_______________create p2 particle
          VerletParticle p2 = new VerletParticle(startLoc.copy().addSelf(flCross.invert()));
          physics.addParticle(p2);
          p2.lock();
          //_______________create p4 particle
          VerletParticle p4 = new VerletParticle(startLoc.copy().addSelf(fl2D));
          physics.addParticle(p4);
          p4.lock();
          //_______________create p3 particle
          VerletParticle p3 = new VerletParticle(p4.copy().addSelf(flCross));
          physics.addParticle(p3);
          p3.lock();
          //_______________create p5 particle
          VerletParticle p5 = new VerletParticle(p4.copy().addSelf(flCross.invert()));
          physics.addParticle(p5);
          p5.lock();
      }
      else if ((startLoc.x==0||startLoc.x==world.x) && field.evalTemp(loc)>=(idealTemp-thresTemp)
        && field.evalTemp(loc)<=(idealTemp+thresTemp)) {
        //_______________create p0 particle
        VerletParticle p0 = new VerletParticle(startLoc.copy());
        physics.addParticle(p0);
        p0.lock();
        //_______________create p1 particle
        VerletParticle p1 = new VerletParticle(startLoc.copy().addSelf(0,0,-depth));
        physics.addParticle(p1);
        p1.lock();
        //_______________create p4 particle
        VerletParticle p4 = new VerletParticle(startLoc.copy().addSelf(0,-depth,0));
        physics.addParticle(p4);
        p4.lock();
        //_______________create p3 particle
        VerletParticle p3 = new VerletParticle(startLoc.copy().addSelf(0,-depth,-depth));
        physics.addParticle(p3);
        p3.lock();
      }
      //*/
    }

  //__________________________________METHOD or BEHAVIORS
    void run(){
      age++;


  		//_____________________biological error
  		if (appWander) {
  			Vec3D w = wander();
  			w.scaleSelf(wanderMag);
  			addForce(w);
  		}
  		//_____________________vector field
  		Vec3D fF = followField(field);
  		fF.scaleSelf(flowMag);
  		addForce(fF);
      //_____________________evaluateTemp
      Vec3D eT = isoVal(field, 20, 20, 100);
      eT.scaleSelf(flowTempMag);
      addForce(eT);
      //_________________________seekMesh
      Vec3D sM = seekMesh(seekMeshRange2, seekMeshRadious2);
      sM.scaleSelf(seekMeshMag2);
      addForce(sM);
    
      //_____________________repulsor
      for (int i = 0; i < repulsNumber; ++i) {
        Vec3D repLoc = repulsors[i];
        float repRange = rangeRepulsors[i];
        Vec3D r = repel(repLoc, repRange);
        addForce(r);
      }
    /*
      //_____________________repulsor
      //for (RepAgent rP : repAgents) {

      for (int i = 0; i < repAgents.size(); ++i) {
        Vec3D repLoc = repAgents.get(i);
        //float repRange = depth;
        Vec3D r = repel(repLoc, repRange);
        addForce(r);
      }
    */
  		//_____________________Update position & display
  		updateVel();
  		move();
      //verticalSteer(.25);//.3
      verticalSteerK(.1);//.1; //.075
  		bounce();
  		//wrap();
      display();
  	}

  //_____________________________________________________physics deposit  
    void depositTemp(ArrayList<Vec3D> deposit){
      tCount++;
      int nCount = 0;
      //Check distance from deposited particles
      for (int i = 0; i < deposit.size(); ++i) {
        Vec3D part = deposit.get(i);
        float distance = loc.distanceTo(part);
        if (distance<maxSpringsLength) nCount++;
      }

      /*  direction: x=tailDir (uscente dallo schermo)
          P0---->P4: flow comp
          P0---->P1: perp (tailDir+flowComp)
          P0---->P2: perp (tailDir+flowComp).invert()
            P1__p1v___P0(ag)____P2
            |           |       |
            |p4v        |p4v    |
            |           |       |
            P3___p1v___P4_______P5
      */
      
      if ((tCount>tStep && nCount>4 && field.evalTemp(loc)>=(idealTemp-thresTemp)
        && field.evalTemp(loc)<=(idealTemp+thresTemp)) || 
        ((loc.x==0 || loc.x==world.x || loc.y==0 || loc.y==world.y || loc.z==0 || loc.z==world.z) 
          && field.evalTemp(loc)>=(idealTemp-thresTemp) && field.evalTemp(loc)<=(idealTemp+thresTemp))) { 
          //_______________create P0 particle
          //VerletParticle p0 = new VerletParticle(loc.copy());
          //physics.addParticle(p0);
          tempPart.add(loc.copy());
          tCount = 0;
          //_______________create P1 particle
          Vec3D p1V = (vel.copy().cross(zRef));
          p1V.normalizeTo(depth);
          Vec3D p1Loc = new Vec3D(p1V.copy().addSelf(loc.copy()));
          //VerletParticle p1 = new VerletParticle(p1Loc);
          //physics.addParticle(p1);
          tempPart.add(p1Loc);
          //_______________create P4 particle
          Vec3D p4V = (vel.copy().cross(p1V));
          p4V.normalizeTo(depth);
          Vec3D p4Loc = new Vec3D(p4V.copy().addSelf(loc.copy()));
          //VerletParticle p4 = new VerletParticle(p4Loc);
          //physics.addParticle(p4);
          tempPart.add(p4Loc);
          //_______________create P3 particle
          Vec3D p3Loc = new Vec3D(p4V.copy().addSelf(p1Loc.copy()));
          //VerletParticle p3 = new VerletParticle(p3Loc);
          //physics.addParticle(p3);
          tempPart.add(p3Loc);
          ///////////////////////////////////
          //_______________create P1__p1v___P0 particle
          //Vec3D p1V = (vel.copy().cross(zRef));
          //p1V.normalizeTo(depth);
          Vec3D p2Loc = new Vec3D(p1V.copy().invert().addSelf(loc.copy()));
          //VerletParticle p1 = new VerletParticle(p1Loc);
          //physics.addParticle(p1);
          tempPart.add(p2Loc);
          //_______________create P5 particle
          //Vec3D p4V = (vel.copy().cross(p1V));
          //p4V.normalizeTo(depth);
          Vec3D p5Loc = new Vec3D(p4V.copy().invert().addSelf(p4Loc.copy()));
          //VerletParticle p4 = new VerletParticle(p4Loc);
          //physics.addParticle(p4);
          tempPart.add(p5Loc);
    
      }
    }

 
    //////////////////////////////////////////////////////////depositTempREP
  //_____________________________________________________physics deposit  
    void depositTempREP(ArrayList<Vec3D> deposit , ArrayList<RepAgent> repAs){
      tCount++;
      repCount++;
      int nCount = 0;
      //Check distance from deposited particles
      for (int i = 0; i < deposit.size(); ++i) {
        Vec3D part = deposit.get(i);
        float distance = loc.distanceTo(part);
        if (distance<maxSpringsLength) nCount++;
      }

      /*  direction: x=tailDir (uscente dallo schermo)
          P0---->P4: flow comp
          P0---->P1: perp (tailDir+flowComp)
          P0---->P2: perp (tailDir+flowComp).invert()
                  P1__p1v___P0(ag)____P2
                  |           |       |
            R1----|p4v        |p4v    | ----R2
                  |           |       |
                  P3___p1v___P4_______P5
      */
      
      if ((tCount>tStep && nCount>4 && field.evalTemp(loc)>=(idealTemp-thresTemp)
        && field.evalTemp(loc)<=(idealTemp+thresTemp)) || 
        ((loc.x==0 || loc.x==world.x || loc.y==0 || loc.y==world.y || loc.z==0 || loc.z==world.z) 
          && field.evalTemp(loc)>=(idealTemp-thresTemp) && field.evalTemp(loc)<=(idealTemp+thresTemp))) { 
          //_______________create P0 particle
          tempPart.add(loc.copy());
          tCount = 0;
          //_______________create P1 particle
          Vec3D p1V = (vel.copy().cross(zRef));
          p1V.normalizeTo(depth);
          Vec3D p1Loc = new Vec3D(p1V.copy().addSelf(loc.copy()));
          tempPart.add(p1Loc);
          //_______________create P4 particle
          Vec3D p4V = (vel.copy().cross(p1V));
          p4V.normalizeTo(depth);
          Vec3D p4Loc = new Vec3D(p4V.copy().addSelf(loc.copy()));
          tempPart.add(p4Loc);
          //_______________create P3 particle
          Vec3D p3Loc = new Vec3D(p4V.copy().addSelf(p1Loc.copy()));
          tempPart.add(p3Loc);
          ///////////////////////////////////
          //_______________create P1__p1v___P0 particle
          Vec3D p2Loc = new Vec3D(p1V.copy().invert().addSelf(loc.copy()));
          tempPart.add(p2Loc);
          //_______________create P5 particle
          Vec3D p5Loc = new Vec3D(p4V.copy().invert().addSelf(p4Loc.copy()));
          tempPart.add(p5Loc);
          ///////////////////////////////////
          if (repCount>repStep) {
            //_______________R1
            Vec3D r1Loc = new Vec3D(p1V.copy().normalizeTo(repDist).addSelf(p1Loc.copy()).addSelf(p4V.copy().scaleSelf(.5)));
            for (int i = 0; i < repAs.size(); ++i) {
              RepAgent oRP =(RepAgent) repAs.get(i);
              float distance = r1Loc.distanceTo(oRP);
              if (distance<1.5*depth) repTest1=false;             
            }
            if (repTest1) {
              RepAgent newRepAG1 = new RepAgent (r1Loc);
              repAgents.add(newRepAG1);
            }
            repTest1=true;
            //RepAgent newRepAG1 = new RepAgent (r1Loc);
            //repAgents.add(newRepAG1);
            ////_______________R2
            Vec3D r2Loc = new Vec3D(p1V.copy().invert().normalizeTo(repDist).addSelf(p2Loc.copy()).addSelf(p4V.copy().scaleSelf(.5)));
            for (int i = 0; i < repAs.size(); ++i) {
              RepAgent oRP =(RepAgent) repAs.get(i);
              float distance = r2Loc.distanceTo(oRP);
              if (distance<1.5*depth) repTest2=false;             
            }
            if (repTest2) {
              RepAgent newRepAG2 = new RepAgent (r2Loc);
              repAgents.add(newRepAG2);
            }
            repTest2=true;

            //Vec3D r2Loc = new Vec3D(p1V.copy().invert().normalizeTo(repDist).addSelf(p2Loc.copy()).addSelf(p4V.copy().scaleSelf(.5)));
            //RepAgent newRepAG2 = new RepAgent (r2Loc);
            //repAgents.add(newRepAG2);
            repCount=0;
          } 
      }
    }
  ///////////////////////////////////////////////////////////////////////////

  ///*
  //________________________________________________________________tail
    void tail(){
      tCount++;
      if (tCount>tStep) {
        tail.add(loc.copy());
          tCount = 0;
      }
      if (tail.size() > tLen) {
          tail.remove(0);
      }

      for ( int i = 1; i < tail.size();i++ ) {   
        Vec3D a = tail.get(i-1);
        Vec3D b = tail.get(i);
        if (a.distanceTo(b) < 30) {
          stroke(0, 0, 0, map(i, 0, tail.size(), 0, 100));
          //strokeWeight(map(i, 0, tail.size(), 0.2, 1));
          //float spColRed = map(i, 0, tail.size(), 10, 252);        // 
          //float spColGreen = map(i, 0, tail.size(), 191, 53);      // MIAKA
          //float spColBlue = map(i, 0, tail.size(), 188, 76);      // 
          //stroke(spColRed, spColGreen, spColBlue, 200);
          line(a.x, a.y, a.z, b.x, b.y, b.z);
        }
      }

    }
  //*/
  //________________________________________________stigmergic behaviors
  	void tailSeek(ArrayList<Vec3D> deposit){
      Vec3D futLoc = new Vec3D(vel).normalizeTo(futLocMag).addSelf(loc);
  		Vec3D sumCoh = new Vec3D();
  		Vec3D steerCoh = new Vec3D();
  		int countCoh = 0;
  		Vec3D steerSep = new Vec3D();
  		int countSep = 0;

  		for (int i = 0; i < deposit.size();i++) {
        
  			float distance = futLoc.distanceTo(deposit.get(i));
  			//if distance < tCohRange >>>> cohesion
  			if (distance > 0 && distance < tCohRange) {
  				tCohPerip = (deposit.get(i)).sub(loc);
  				tCohAngle = tCohPerip.angleBetween(vel, true);
  				if (tCohAngle < 0) tCohAngle += TWO_PI;
  				if (abs(tCohAngle) < tCohAngleRad ) {
          		sumCoh.addSelf(deposit.get(i));
          		countCoh++;
        	}
  				//if distance < tSepRange >>>>>>> separation
  				if (distance > 0 && distance < tSepRange) {
  					tSepPerip = (deposit.get(i)).sub(loc);
  					tSepAngle = tSepPerip.angleBetween(vel, true);
  					if (tSepAngle < 0) tSepAngle += TWO_PI;
        			if (abs(tSepAngle) < tSepAngleRad ) {
        			  Vec3D diff = loc.sub(deposit.get(i));
        			  diff.normalizeTo(1.0/distance);
        			  steerSep.addSelf(diff);
        			  countSep++;
        			}
  				}	
  			}

  		}

  		//add cohesion
  		if (countCoh>0) {
    	  	sumCoh.scaleSelf(1.0/countCoh);
    	  	steerCoh = sumCoh.sub(loc);
    	  	steerCoh.limit(maxForce);
    	  	steerCoh.scaleSelf(tCohMag);
    	  	acc.addSelf(steerCoh);
    	}
    	//add separation
    	if (countSep > 0) {
    	  	steerSep.scaleSelf(1.0/countSep);
          steerSep.limit(maxForce);
          steerSep.scaleSelf(tSepMag);
          acc.addSelf(steerSep);
    	}
    	
  	}

  //______________________________________________________read FlowField
    Vec3D followField(Field field){
      Vec3D f = field.evalFlow(loc);
      f.normalizeTo(maxSpeed);// desired
      f.limit(maxForce);
      //if (age>1) {
      //  float angle=f.angleBetween(vel, true);
      //  if (angle>HALF_PI && angle<(HALF_PI+PI)) f.invert();
      //}
      
      return f;
    }

  //____________________________________________________evaluateTemp
    Vec3D isoVal(Field field, float fut, float rad, int ns) {
      Vec3D s = new Vec3D();
      Vec3D sample;
      int count = 0;
      float st;
      //calcolo futLoctemp
      Vec3D futLoctemp = new Vec3D(vel).normalizeTo(fut).addSelf(loc);
      //if futLoctemp is in bounds....
      if (checkBounds(futLoctemp)) {
        for (int i = 0; i < ns; ++i) {
          sample = new Vec3D(random(-rad,rad), random(-rad,rad), random(-rad,rad));
          //if sample is in bounds....
          if (checkBounds(futLoctemp.add(sample))) {
            //read temp
            st = field.evalTemp(futLoctemp.add(sample));
            //if values are similar
            if (st>=idealTemp-thresTemp && st<=idealTemp+thresTemp) {
              count++;
              //set sample proportional to field
              sample.normalizeTo(st);
              //add to the global vector
              s.addSelf(sample);
            }//end evalTemp
          }// end if check bounds
        }//end sampling
        if (count>0) {
          s.scaleSelf(1/(float)count);//desired direction
          s.normalizeTo(maxSpeed);// desired
          s.limit(maxForce);//
        }

      }
      return s;
    }

  //___________________________________________________________seek Mesh
    Vec3D seekMesh(float range, int maxAngle){
      Vec3D futLoc = new Vec3D(vel).normalizeTo(range).addSelf(loc);
      Vec3D vec = new Vec3D();
      Vec3D sum = new Vec3D();

      ArrayList points = null;
      points = octree.getPointsWithinSphere( futLoc, maxAngle);

      if (points!=null) {
        Iterator iter = points.iterator();
        while (iter.hasNext()) {
          Vec3D p =(Vec3D) iter.next();

          sum.addSelf(p); 
        }
        sum.scaleSelf(1.0/points.size());
        sum.subSelf(loc);
        vec.set(sum.copy());
        vec.normalizeTo(maxSpeed);//(desired);
        vec.limit(maxForce);
      }

      return vec;
    }

 
  ///*
  //_________________________________________________________REPEL AGENTS
    Vec3D repel(Vec3D target, float range) {
      float distToRep = target.distanceTo(futLoc);
      Vec3D r = new Vec3D();
      //if (abs(distToRep)*2 <= range) {
      if (distToRep>=0 && distToRep <= range) {
        r.set(target.sub(loc));      
        r.normalize();
        r.invert();
        rep = map(distToRep, 0, range, maxRepel, minRepel);
        //r.scaleSelf(rep);
        //r.limit(maxRepel);
        r.limit(rep);
        //acc.addSelf(r);
      }
      return r;
    }
  //*/  
  
  //_______________________________________________________check bounds
    boolean checkBounds(Vec3D fLoc){
      boolean  check = true;
      if (fLoc.x<0 || fLoc.x>world.x) check = false;
      if (fLoc.y<0 || fLoc.y>world.y) check = false;
      if (fLoc.z<0 || fLoc.z>world.z) check = false;
      return check;
    }

  //____________________________________________________biological error
  	Vec3D wander() {
	    float wanderX = random(-1, 1);
	    float wanderY = random(-1, 1);
	    float wanderZ = random(-1, 1);
	    Vec3D wander = new Vec3D (wanderX, wanderY, wanderZ);
	    wander.limit(maxForce);
	    return wander;
    }

  //__________________________________________________update acceleration
    void addForce(Vec3D force){
    	acc.addSelf(force);
    }

  //________________________________________________bounce or wrapBoundary
  	void bounce(){
  		if (loc.x<0 || loc.x>world.x) {
        vel.x*=-1;
        vel.normalizeTo(1);
      }
		  if (loc.y<0 || loc.y>world.y) {
        vel.y*=-1;
        vel.normalizeTo(1);
      }
		  if (/*loc.z<0 ||*/ loc.z>world.z) {
        vel.z*=-1;
        vel.normalizeTo(1);
      }
  	}

  	void wrap(){
  		if(loc.x<0) loc.x = world.x;
		  if(loc.x>world.x) loc.x = 0;
		  if(loc.y<0) loc.y = world.y;
		  if(loc.y>world.y) loc.y = 0;
		  if(loc.z<0) loc.z = world.z;
		  if(loc.z>world.z) loc.z = 0;
  	}

  //_______________________________________________________vertical Steer
    void verticalSteer(float mag){
      float steerMag = 0;
      //if (loc.z<=DIMZ/2) {
      //  steerMag = map(loc.z, 0, DIMZ, mag, -mag);
      //}
      //else steerMag=-mag;
      steerMag = map(loc.z, 0, DIMZ, -.1, -mag); // .1 //.18
      Vec3D steer = new Vec3D(0,0,steerMag);
      //if (loc.z==0) steer.set(0,0,1);
      //if (loc.z==world.z) steer.set(0,0,-1);
      //steerMag = map(loc.z, 0, DIMZ, mag, 0);
      //Vec3D steer = new Vec3D(0,0,-mag);
      steer.limit(maxForce);
      acc.addSelf(steer);
    }

  //_______________________________________________________vertical SteerK
    void verticalSteerK(float mag){
      //Vec3D futLoc = new Vec3D(vel).normalizeTo(futLocMag).addSelf(loc);
      //if (age>1) {
      //  if (loc.z>= futLoc.z) {
          Vec3D steer = new Vec3D(0,0,-mag);
          steer.limit(maxForce);
          acc.addSelf(steer);
      //  }
      //  else if (loc.z< futLoc.z) {
      //    Vec3D steer = new Vec3D(0,0,mag);
      //    steer.limit(maxForce);
      //    acc.addSelf(steer);
      //  }
      //}
    }

  //_______________________________________________________update Velocity
  	void updateVel(){
  		vel.addSelf(acc);
		  vel.limit(maxSpeed);
		  acc = new Vec3D();
  	}

  //__________________________________________________________________move
  	void move(){
  		loc.addSelf(vel);
  	}

  	//_______________________________________________________________display
  	void display(){
  		strokeWeight(PtSize+1);
      stroke(baseMag);
      point(loc.x, loc.y, loc.z);
      strokeWeight(1);
      Vec3D futLoc = new Vec3D(vel).normalizeTo(futLocMag).addSelf(loc);
      line(loc.x, loc.y, loc.z, futLoc.x, futLoc.y, futLoc.z);
  	}



	



}//____End Class