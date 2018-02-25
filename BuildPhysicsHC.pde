//___________________________________________________________________import libraries
import peasy.*;
import controlP5.*;
import processing.opengl.*;
import java.util.Iterator;
import toxi.physics.*;
import toxi.physics.constraints.*;
import toxi.physics.behaviors.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;


//_______________________________________________________________global color variables
PImage bg;
color bgCol = color(225, 229, 232);
color sCol = color(200);  // stroke color22
color fCol = color(216, 220, 223);//bgCol;
color txtCol = color(10); // text fill color
color baseBlue = color (89, 128, 167);
color baseMag = color (254, 63, 165);
color baseCyan = color(112, 242, 243);
//______________________________________________________________________physics Graphics
color PartCol =color(75, 75, 75);
color SpringCol = color(135);
float PtSize = 2;
float LineSize = 0.2;
//__________________________________________________________________declare used classes
PeasyCam cam;                // camera
ControlP5 c5;                // GUI for controllers
PMatrix3D currCameraMatrix;  // camera matrix for overlay will be stored here
PGraphics3D g3;              // the graphic GL system for overlay
//_________________________________________________________________declare GUI variables
int buttonLength = 60;//125;
int buttonHeight = 8;
int buttonXStart = 10;
int buttonYStart = 460; //440;
int buttonSpace = 6;
//________________________________________________________________________________Pause
boolean pause = false;
//______________________________________________declare environment variables & classes
Field field;
int DIMX=250;
int DIMY=250;
int DIMZ= 75;//90; 
Vec3D world;
int gridSize=5;
//FlowField variables
float flowMag = .4;// .3;//.5;//.4;
//Temp variables
float flowTempMag = .05;//.05;
int idealTemp = 25;
int thresTemp = 15;
//displayField
boolean showTemp = false;
boolean showFlowField = false;
//______________________________________declare Variables & classes for environment & MESH
ToxiclibsSupport gfx;
TriangleMesh spaces;
float seekMeshMag2 = 10;//2;
float seekMeshRange2 = 7; //10
int seekMeshRadious2 = 5; //5
boolean showSpaces = false;
//Setup octree FOR MESH REPULSOR
PointOctree octree;
//_____________________________________________________declare Agents variables & classes
boolean runSketch = false;
boolean endSimulation = false;
boolean appWander = true;
ArrayList <Agent> agents;
ArrayList <Vec3D> startLocTot;
int startPop = 10; ////////////////////////////////////////////////
int maxPop = 200;
//Wander variables
float wanderMag = .001; //.005
int countGrowth=0;
int stopGrowth=350; //400;
//_________________________________________________________________declare Agents' tails
ArrayList <Vec3D> totTail;
//____________________________________________________________declare stigmergy variables
//Stigmergy variables
float tCohRange = 100;//70;//120;
float tCohMaxAngle = 60;
float tCohMag = .5; //.5;1
float tSepRange = 10; //10;//5;
float tSepMaxAngle = 360;
float tSepMag = 2;//2;//5;//3; //1.2;
//Angle detection
float tCohAngle;
float tCohAngleRad;
Vec3D tCohPerip = new Vec3D();
float tSepAngle;
float tSepAngleRad;
Vec3D tSepPerip = new Vec3D();

//___________________________________________________declare physics variables & classes
boolean runPhysics = false;
boolean deformationSP = false;
VerletPhysics physics;
ArrayList <RepAgent> repAgents;///////////Class for create space between honeybee
boolean showRepAgents = false;
ArrayList <Vec3D> totDepPart;
ArrayList <Vec3D> tempPart;
int depth = 5;
//SetGravity
Vec3D grav = new Vec3D(0,0,-1);
//springs variables
float minSpringsLength= depth-1;//2;//depth*0.7;//0.98;
float maxSpringsLength= depth*1.8;//1.7;//1.8;//2.2;//2.5;
float stiffness = .85; //0.85;
float rlFactor;
float minRLFactor = 1.1; // 1.05; 1.01
float maxRLFactor = 1.1; //1.1
int maxspP = 8;//5
int maxSpringsNum = 300000;

float rlThres=0;
float rlThresMax = .01;
float rlThresMin = .001;
float stiffening = .015; //.01;
//______________________________________setup values for approximate RealTime simulation
int simulPhysStep = 5;//2; //intervall for each simulation
int simulTime;// = 7;//duration of each simulation
int startSimulTime=20;
int finalsimulTime=50;//30;//duration of final simulation
boolean expGrowth = true;
//_______________________________________________________________Setup repulsor&attractor
int repulsNumber = 14;
Vec3D [] repulsors = new Vec3D [repulsNumber];
float [] rangeRepulsors = new float [repulsNumber];
float rep;// = 0.2;
float minRepel = .1;
float maxRepel = 2;//2; //0.5;
float repSize =2;
float repRangeSize = 0.7;
color repColor = color(255, 49, 159);
//_________________________________________________setup values for particles's layer(l)
boolean layered = false;
boolean showLayers  = false;
float lStep = 5;//5
int lNum = round(DIMZ/lStep);
Vec3D [] lOrigins = new Vec3D [lNum];
//________________________________________________declare variables & classes for export
boolean exportSprings = false;
//_______________________________________________________________________Video variables
boolean recording = false;
boolean screenshot = false;
//____________________________________________________________________________________2D 
boolean infographics = false;
float scaleFac = .6;//.6;//.77 ;//0.82; 
float space2D = 10;
int maxCol = 255;
int minCol = 180; //170
int otherCol= 70;
int maxColDel = 60;
int minColDel = 10;
int end2D= int(DIMX/scaleFac)-1;
int lineY=-30;
int gDepth = 4;


/*--------------------------------------------------------------------------------
  ********************
  *** GLOBAL SETUP ***
  ********************
 ---------------------------------------------------------------------------------*/
void setup() {
	//size(1280, 720, OPENGL);
  fullScreen(P3D);
  //pixelDensity(2);
  world = new Vec3D (DIMX, DIMY, DIMZ);
  textFont(createFont("Roboto-Regular",12, true));
  bg=loadImage("BG_Mon.png");
  smooth();

  g3 = (PGraphics3D)g;                          // new graphic GL system

  c5 = new ControlP5(this);                     // new set of GUI controls

  cam = new PeasyCam(this, 420);       // new cam:  distance
  cam.rotateX(-.930);  //95 rotate around the x-axis passing through the subject
  cam.rotateY(.744);  // rotate around the y-axis passing through the subject
  cam.rotateZ(-.342);  // rotate around the z-axis passing through the subject
  cam.lookAt(-16.369, 197.676, 2.318); //lookAtX, lookAtY, lookAtZ

  c5.setAutoDraw(false);                      // update maually to control the refresh sequence
  //setup new reference coordinates
  pushMatrix();
  scale(1,-1,1);
  translate(0,-DIMY,0); // translate origin (0,0,0)

  //initialize Physics///////////////////////////
  physics = new VerletPhysics();

  //initialize Particles for space///////////////////////////
  repAgents = new ArrayList<RepAgent>();

  //initialize Environment///////////////////////
  field = new Field(gridSize);

  //initialize Agents////////////////////////////
  //import Start Points
  String[] xStartLoc = loadStrings("04x_LocSTP.txt");
  String[] yStartLoc = loadStrings("04y_LocSTP.txt");
  String[] zStartLoc = loadStrings("04z_LocSTP.txt");

  agents = new ArrayList<Agent>();
  startLocTot = new ArrayList <Vec3D>();

  for (int i=0; i < startPop; i++) {
    float xSP= float (xStartLoc[i]);
    float ySP= float (yStartLoc[i]);
    float zSP= float (zStartLoc[i]);
    Vec3D origin = new Vec3D (xSP, ySP, zSP);
    Agent myAgent = new Agent (origin, world);   
    agents.add(myAgent);
  }


  //deposited particles/////////////////////////
  totDepPart = new ArrayList <Vec3D>();
  tempPart = new ArrayList <Vec3D>();

  //tail////////////////////////////////////////
  totTail = new ArrayList <Vec3D>();

  //init Mesh context
  gfx = new ToxiclibsSupport(this);
  spaces = new TriangleMesh();
  spaces.addMesh(new STLReader().loadBinary(createInput("Spaces.stl"), "N", STLReader.TRIANGLEMESH));
  //setup octree
  //octree= new PointOctree(new Vec3D(-1, -1, -1).scaleSelf(DIM2), DIM);
  octree= new PointOctree(new Vec3D(0,0,0),DIMZ);
  for (Vertex v: spaces.vertices.values()) {
    Vec3D p0 = new Vec3D(v.x, v.y, v.z);
    if (v.z>=1) {
      octree.addPoint(p0);
    }
    
  }
  ///*
  //init Repulsor
  String[] xLocRepulsor = loadStrings("03x_LocRepulsor.txt");
  String[] yLocRepulsor = loadStrings("03y_LocRepulsor.txt");
  String[] zLocRepulsor = loadStrings("03z_LocRepulsor.txt");
  String[] repulsorRange = loadStrings("03_RangeRepulsor.txt");
  for (int i = 0; i < repulsNumber; ++i) {
    float xRep= float (xLocRepulsor[i]);
    float yRep= float (yLocRepulsor[i]);
    float zRep= float (zLocRepulsor[i]);
    Vec3D repLoc = new Vec3D(xRep, yRep, zRep);
    repulsors[i] = repLoc ;
    float repRange = float(repulsorRange[i]);
    rangeRepulsors[i] = repRange*2;   
  }
  //*/

  //set particles' layer
  if (layered) {
    for (int i = 0; i < lNum; ++i) {
      Vec3D zero = new Vec3D (0, 0, (i*lStep));
      lOrigins[i] = zero;
    }
  }
  


  ////set GravityBehavior
  GravityBehavior g = new GravityBehavior(grav);
  physics.addBehavior(g);                         //add Gravity to solver for calculate  
  //SET BOUND WORLD//////////////////////////////////////////
  translate(DIMX/2, DIMY/2, DIMZ/2);
  physics.setWorldBounds(new AABB(new Vec3D(DIMX/2,DIMY/2,DIMZ/2),new Vec3D(DIMX/2,DIMY/2,DIMZ/2)));
  
  popMatrix();
}


/*--------------------------------------------------------------------------------
  ******************
  *** GLOBAL RUN ***
  ******************
 ---------------------------------------------------------------------------------*/
void draw() {
	//background(bg);
  background(bgCol);
  stroke(200);
  fill(250);  
  lights();
  
  // DO YOUR 3D-stuff here ////////////////////////////////////
  pushMatrix();
  //from Rhyno
  scale(1,-1,1);
  translate(0,-DIMY,0); // translate origin (0,0,0)



  ////////////////////////////////// Draw 3D graphics in other TAB
  Graphicsdraw();

  ////////////////////////////////// RUN
  if (runSketch) {

    if (!pause && countGrowth<stopGrowth && physics.springs.size()<maxSpringsNum) {
      if (physics.particles.size()>0) countGrowth++;
      totDepPart.addAll(physics.particles);
      for (Agent Ag : agents) {
        Ag.run();
        //Ag.depositTemp(totDepPart);
        Ag.depositTempREP(totDepPart, repAgents);
        Ag.tailSeek(totDepPart);
      }
      println("RepAG: "+repAgents.size());
      for (RepAgent rP : repAgents) rP.run();
      killRepAg();
      if (agents.size()<= maxPop) {
        newAgents();  //function for create newAgents
      }
      totDepPart.clear();
      totTail.clear();
      ///*
      if (countGrowth%simulPhysStep==0) {
        println("addSprings;");
        if (layered) {
          addSpringsSlice();
        }
        else addSprings();

        tempPart.clear();
        //Slicing
        if (layered) {
          if (countGrowth%(simulPhysStep*5)==0) {
            slicing();
          }
        }
        println("physics_simulation;");
        simulTime= (int)map(countGrowth, 0, stopGrowth, startSimulTime, finalsimulTime);
        for (int countSim = 0; countSim < simulTime; ++countSim) {
          physics.update();
        }
        println("simulTime: "+(simulTime)+"/"+(finalsimulTime));
        checkSprings();
        //export obj & tiff for show growth//
        if (expGrowth && countGrowth%simulPhysStep==0/*(simulPhysStep*2)==0*/) {
          int index = int(map(physics.springs.size(), 0, maxSpringsNum, 0, 100));
          println("HA_"+(index)+"_100");
          exportAsOBJ("HA_"+(index)+"_100");
        }
        /////////////////////////////////////
        countGrowth++;
      }
      //*/
      
    }
    ///*
    else if (countGrowth==stopGrowth || (physics.springs.size()>=maxSpringsNum && countGrowth<=stopGrowth) || (agents.size()<15 && countGrowth > 100 && countGrowth < stopGrowth)) {
      for (int i = 0; i < finalsimulTime; ++i) {
        physics.update();
      }

      if(layered) slicing();
      println("CheckSprings();");
      checkSpringsF();
      //endSimulation=true;
      countGrowth=stopGrowth;
      countGrowth++;
    }
    if (countGrowth==stopGrowth+1) {  
      endSimulation=true;
      countGrowth++; 
    }
    //*/
    if (runPhysics==true) {
      physics.update();
    }


    
    
  }

  if (deformationSP) {
    println("deformations");
    drawDeformation();
  }
  else if (!deformationSP) {
    drawSprings();
    //drawParticles();
  }

  if (showRepAgents) {
    for (RepAgent rP : repAgents) {
      rP.display();
    }
  }

  if (pause) {
    drawSprings();
    for (Agent Ag : agents) {
        Ag.display();
    }
  }
  


  

  popMatrix();
  ///// Ok, enough 3D /////////////////////////////////
  hint(DISABLE_DEPTH_TEST);
  /////////////////////////////////////////////////////Draw PerpView
  cam.setActive(true);

  GUIDraw();                         //draw the 2D stuff in this function
  OrthoView2D();

  ExportFunction();
  RecordingFunction();

}

void keyPressed() { 
  if(key == 'p' || key == 'P'){
    pause =!pause;    // On/off of pause
    if (pause) println("PAUSE");
    if (!pause) println("no pause");
  } 
  if (key == 'w'|| key == 'W') appWander=!appWander;
  if (key == 'r'|| key == 'R') runSketch=!runSketch;
  if (key == 's'|| key == 'S') exportSprings=!exportSprings;
  if (key == 'v'|| key == 'V') recording=!recording;
  if (key == 'd'|| key == 'D') deformationSP=!deformationSP;
  if (key == 'i'|| key == 'I') infographics=!infographics;
  if (key == 'c'|| key == 'C') showSpaces=!showSpaces;
  if (key == 't'|| key == 'T') showTemp=!showTemp;
  if (key == 'f'|| key == 'F') showFlowField=!showFlowField;
  if (key == 'j'|| key == 'J') screenshot=!screenshot;
  if (key == 'u'|| key == 'U') runPhysics=!runPhysics;
  if (key == 'l'|| key == 'L') showLayers=!showLayers;
  if (key == 'a'|| key == 'A') showRepAgents=!showRepAgents;
  
}