class Field{
	Vec3D[][][] field;
	float[][][] temp; 
	//int xCoord, yCoord, zCoord;
	int gridSize,iMax, jMax, kMax;
	int envCond, envTag;
	float startX, startY, startZ, newX, newY, newZ;

	Field(int gridSize){
		this.gridSize=gridSize;
		this.iMax=iMax;
		this.jMax=jMax;
		this.kMax=kMax;

		iMax = (int)(DIMX/gridSize);
		jMax = (int)(DIMY/gridSize);
		kMax = (int)(DIMZ/gridSize);


		field = new Vec3D[iMax][jMax][kMax];
		temp = new float [iMax][jMax][kMax];
		initField();
	}

	void initField(){
		//import txt files/////////////////////////////////////////////////////////////////////////////
    	//Start Grid
    	String[] xCoordStartLoc = loadStrings("01xCoordStartLoc.txt");
    	String[] yCoordStartLoc = loadStrings("01yCoordStartLoc.txt");
    	String[] zCoordStartLoc = loadStrings("01zCoordStartLoc.txt");
    	//EnvValues
    	String[] EnvValues = loadStrings("02EnvValues.txt");
    	//newLoc
    	String[] xCoordnewLoc = loadStrings("02xCoordnewLoc.txt");
    	String[] yCoordnewLoc = loadStrings("02yCoordnewLoc.txt");
    	String[] zCoordnewLoc = loadStrings("02zCoordnewLoc.txt"); //for 3D VectorField


		//init Environment
  		for (int i = 0; i < iMax ; i++) {
  		  for (int j = 0; j < jMax ; j++) {
  		    for (int k = 0; k < kMax ; k++) {
  		      //import starLoc
  		      float startX = float(xCoordStartLoc[envTag]);
  		      float startY = float(yCoordStartLoc[envTag]);
  		      float startZ = float(zCoordStartLoc[envTag]);
  		      Vec3D ptStartLoc= new Vec3D(startX,startY,startZ);
  		      //import EnvCondition
  		      envCond = int(EnvValues[envTag]);
  		      //import NewLoc
  		      float newX = float(xCoordnewLoc[envTag]);
  		      float newY = float(yCoordnewLoc[envTag]);
  		      float newZ = float(zCoordnewLoc[envTag]);
  		      Vec3D ptNewLoc= new Vec3D(newX,newY,newZ);
  		      //start EnvGrid
  		      field[i][j][k] = new Vec3D(ptNewLoc.copy().subSelf(ptStartLoc.copy()));
  		      temp[i][j][k] = envCond;
  		      envTag ++;
  		    }
  		  }
  		}
	}

	//_____________________________________________evaluate Temperature
	float evalTemp(Vec3D loc){
		float t = 0.0;
		int xLoc = round(constrain(loc.x/gridSize, 0, iMax-1));
		int yLoc = round(constrain(loc.y/gridSize, 0, jMax-1));
		int zLoc = round(constrain(loc.z/gridSize, 0, kMax-1));
		return t = temp[xLoc][yLoc][zLoc];
	}

	//_____________________________________________udpate Temperature
	void updateTemp(Vec3D loc, float sVal){
		int xLoc = round(constrain(loc.x/gridSize, 0, iMax-1));
		int yLoc = round(constrain(loc.y/gridSize, 0, jMax-1));
		int zLoc = round(constrain(loc.z/gridSize, 0, kMax-1));
		temp[xLoc][yLoc][zLoc]= constrain(temp[xLoc][yLoc][zLoc]+sVal, 0, 50);
	}

	//_____________________________________________evaluate vectorfield
	//faccio subito tutti i calcoli per sveltire il processo
	Vec3D evalFlow(Vec3D loc){
		int xLoc = round(constrain(loc.x/gridSize, 0, iMax-1));
		int yLoc = round(constrain(loc.y/gridSize, 0, jMax-1));
		int zLoc = round(constrain(loc.z/gridSize, 0, kMax-1));
		return new Vec3D(field[xLoc][yLoc][zLoc]);
	}


	//_________________________________________________display Function
	void displayFlow(float len){
		pushStyle();
		stroke(150,150,150);
		strokeWeight(.5);
		for (int i = 0; i < iMax; ++i) {
			for (int j = 0; j < jMax; ++j) {
				for (int k = 0; k < kMax; ++k) {
					pushMatrix();
					translate(gridSize*(i+.5), gridSize*(j+.5), gridSize*(k+.5));
					line(0, 0, 0, field[i][j][k].x*len, field[i][j][k].y*len, field[i][j][k].z*len);
					popMatrix();	
				}
			}
		}
		popStyle();	
	}

	void displayTemp(){
		for (int i = 0; i < iMax; ++i) {
			for (int j = 0; j < jMax; ++j) {
				for (int k = 0; k < kMax; ++k) {
					pushStyle();
					pushMatrix();
					translate(gridSize*(i+.5), gridSize*(j+.5), gridSize*(k+.5));
					float colRed = map(temp[i][j][k], 0, 50, 0, 255);
					float colGreen = map(temp[i][j][k], 0, 50, 255, 0);
					float PTsize = map(temp[i][j][k], 0, 50, 0, 10);
					stroke(colRed, colGreen, 0);
					strokeWeight(PTsize);
					//if ((temp[i][j][k])<=(idealTemp+thresTemp)&&(temp[i][j][k])>=(idealTemp-thresTemp)&& k==kMax-1) {
						point(0, 0, 0);
					//}
					popMatrix();
					popStyle();
				}
			}
		}
	}

}//___________End Class