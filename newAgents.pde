/*--------------------------------------------------------------------------------
***HERE I ADD NEW AG***
---------------------------------------------------------------------------------*/

void newAgents(){
	float yAge = 8;
	float ySpacing = depth*1.9;
	float minDistBridge = maxSpringsLength;
	float maxDistBridge = 40;
	float thresBridge = 1;
	int minAgeBridge = 20;
	for (int i = 0; i < agents.size(); ++i) {
		Agent Ag = (Agent) agents.get(i);
        if (Ag.startLoc.x==0||Ag.startLoc.x==DIMX||Ag.startLoc.z==0||Ag.startLoc.z==DIMZ) {
            
        
		//__________________________Add new Agent for Vertical Growth (new)

        ///*
    	if (Ag.age==yAge) {
    		//add Biological error for the location of new Ag (in both direction)
    		float factor = constrain(map(flowMag, 0, 1, 0.05, 2000), 0, 1);
            Vec3D orizzGrowth = new Vec3D();
    		if (Ag.startLoc.z==0 || Ag.startLoc.z==DIMZ) orizzGrowth.set(random(-1, 1), ySpacing, 0);
            else if (Ag.startLoc.x==0 || Ag.startLoc.x==DIMX) orizzGrowth.set(0, ySpacing, random(-1, 1));
    		orizzGrowth.normalizeTo(ySpacing);
    		Vec3D orizzGrowthNeg = new Vec3D(orizzGrowth.copy().invert());
    		//_______________________________________________add Y+ AG
    		Vec3D neworigin= new Vec3D(Ag.startLoc.copy());
    		boolean nw = false;
    		//evaluate flow
    		Vec3D flowComp2D = field.evalFlow(Ag.startLoc);
            if (Ag.startLoc.z==0 || Ag.startLoc.z==DIMZ) flowComp2D.set(flowComp2D.x, flowComp2D.y, 0);
    		else if (Ag.startLoc.x==0 || Ag.startLoc.x==DIMX) flowComp2D.set(0, flowComp2D.y, flowComp2D.z);
    		//check direction
    		Vec3D ref = new Vec3D (orizzGrowth.normalize());
    		float evalAngle = flowComp2D.angleBetween(ref, true);
    		if (evalAngle>(0.5*PI) && evalAngle<(1.5*PI)) flowComp2D.invert();
    		//"add" flow to Ygrowth
    		Vec3D diff = new Vec3D (flowComp2D.copy());
    	    diff.subSelf(orizzGrowth);
    	    //found new origin
    	    Vec3D addFac = new Vec3D(orizzGrowth.copy());
    	    addFac.addSelf(diff.scaleSelf(factor));
    	    addFac.normalizeTo(ySpacing);
    	    neworigin.addSelf(addFac);
    	    //check env condition
    	    if (field.evalTemp(neworigin)>=(idealTemp-thresTemp) &&
                field.evalTemp(neworigin)<=(idealTemp+thresTemp)) nw=true;
    	    //check in neworigin is in the bounding box
    	    if (neworigin.x<0 || neworigin.x>DIMX ||
    	        neworigin.y<0 || neworigin.y>DIMY ||
                neworigin.z<0 || neworigin.z>DIMZ) {
    	          nw = false;
    	    }
    	    //check distance form other Particles
    	    for (int j = 0; j < startLocTot.size(); ++j) {
    	       Vec3D startLocOther = startLocTot.get(j);
    	       float distance = neworigin.distanceTo(startLocOther);
    	       if (distance>=0 && distance<depth ) nw=false;
    	    }
    	    //create new AG
    	    if (nw) {
    	       Agent newAg = new Agent (neworigin, world);   
    	       agents.add(newAg);
    	       //println("++++++++++++++++++++++++++++++++++++++++++++++AddPosAG");
    	    }
    	    //_______________________________________________add Y- AG
    	    Vec3D neworigin2 = new Vec3D(Ag.startLoc.copy()); 
    	    boolean nw2 = false;
    	    //evaluate flow
    	    Vec3D flowComp2D2 = field.evalFlow(Ag.startLoc);
            if (Ag.startLoc.z==0 || Ag.startLoc.z==DIMZ) flowComp2D2.set(flowComp2D2.x, flowComp2D2.y, 0);
            else if (Ag.startLoc.x==0 || Ag.startLoc.x==DIMX) flowComp2D2.set(0, flowComp2D2.y, flowComp2D2.z);
    	    //check direction
    	    Vec3D ref2 = new Vec3D (orizzGrowthNeg.normalize());
    	    float evalAngle2 = flowComp2D2.angleBetween(ref2, true);
    	    if (evalAngle2>(0.5*PI) && evalAngle2<(1.5*PI)) flowComp2D2.invert();
    	    //"add" flow to Y-growth
    	    Vec3D diff2 = new Vec3D (flowComp2D2.copy());
    	    diff2.subSelf(orizzGrowthNeg);
    	    //found new origin
    	    Vec3D addFac2 = new Vec3D(orizzGrowthNeg.copy());
    	    addFac2.addSelf(diff2.scaleSelf(factor));
    	    addFac2.normalizeTo(ySpacing);
    	    neworigin2.addSelf(addFac2);
    	    //check env condition
    	    if (field.evalTemp(neworigin)>=(idealTemp-thresTemp) &&
                field.evalTemp(neworigin)<=(idealTemp+thresTemp)) nw2=true;
    	    //check in neworigin2 is in the bounding box
    	    if (neworigin2.x<0 || neworigin2.x>DIMX ||
    	        neworigin2.y<0 || neworigin2.y>DIMY ||
                neworigin2.z<0 || neworigin2.z>DIMZ) {
    	          nw2 = false;
    	    }
    	    //check distance form other Particles
    	    for (int j = 0; j < startLocTot.size(); ++j) {
    	       Vec3D startLocOther = startLocTot.get(j);
    	       float distance = neworigin2.distanceTo(startLocOther);
    	       if (distance>=0 && distance<depth) {
    	          nw2=false;
    	       }
    	    }
    	    //create new AG
    	    if (nw2) {
    	       Agent newAg = new Agent (neworigin2, world);   
    	       agents.add(newAg);
    	       //println("-----------------------------------------------AddNegAG");
    	    }
    	}//____if(Ag.age == yAge)
        //*/
        }//if start loc is in border

        //Kill agent if touch the ground
        if (Ag.loc.z <0) agents.remove(Ag);

    }//___for each agent
}


