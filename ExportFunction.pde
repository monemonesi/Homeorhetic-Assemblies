/*--------------------------------------------------------------------------------
***ALL EXPORT FUNCTION ARE HERE***
 ---------------------------------------------------------------------------------*/

void ExportFunction(){
	
  //export springs in OBJ (Thanks Co-de-iT)////////////////////////////////
    if (exportSprings==true) {
      exportAsOBJ("HA_exported_Springs");
      exportSprings=false;
    }
  //Export OBJ////////////////////////////////////////
    if (endSimulation==true) {
      println("END SIMULATION!!!!!");
      saveFrame("FINALSTATE/HA_100_#####.tiff");
      exportAsOBJ("100_100");
      endSimulation=false;
    }
}

void exportAsOBJ(String fileName){
  String dir = "export_data/"+fileName+ "springs.obj";
  // export springs
  PrintWriter output = createWriter(dir); 
  println("creating", "springs.obj file");
  output.println("# exported from Processing");
  output.println("# based on code (c) Co-de-iT 2014");
  output.println("o Curve_0");
  for (int i = 0; i < physics.springs.size(); ++i) {
    VerletSpring sp = (VerletSpring) physics.springs.get(i);
    output.println("v " + sp.a.x + " " + sp.a.z + " " + -sp.a.y);
    output.println("v " + sp.b.x + " " + sp.b.z + " " + -sp.b.y);
    output.println("l "+ (-2)+ " " + (-1));
  }
  output.flush();
  output.close();
  println(dir + " created.");
}



void RecordingFunction(){
	//recordingVideo//////////////////////////////////////
  	if (recording) {
      println("Video Recording");
      saveFrame("outputVid/HA_video_#####.tiff");
    }

  //Take a picture/////////////////////////////////////
    if (screenshot) {
        println("screenshot");
        saveFrame("outputPNG/HA_#####.tiff");
        screenshot=false;
    }
 

    
}