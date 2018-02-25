class RepAgent extends VerletParticle { 
  //General variables
  //float repRange= depth;
  float repMag = 10;//5;
  float repRange= 1.5*depth;//2*depth;
  int repAgentAge  = 0;

  //__________________________________CONSTRUCTORS
  RepAgent(Vec3D loc){
    super(loc);
    physics.addBehavior(new AttractionBehavior(this, repRange, -repMag));
  }


  //__________________________________METHOD or BEHAVIORS

  void run(){
    repAgentAge++;
    //change condition temp
    //field.updateTemp(this, -5);
  }

  void display (){
  	float weight = map(repAgentAge, 0, 60, 5, .1);
  	strokeWeight(weight);
    stroke(150,150,150,150);
    point(this.x, this.y, this.z);
    strokeWeight(.5);
    pushMatrix();
    translate(this.x, this.y, this.z);
    noFill();
    ellipse(0, 0, repRange*2, repRange*2);
    popMatrix();

  }


}

void killRepAg(){
    for (int i = 0; i < repAgents.size(); ++i) {
    	RepAgent rP = (RepAgent) repAgents.get(i);
    	if (rP.repAgentAge >= 60) {
    		repAgents.remove(rP);
    	}
    }
}

