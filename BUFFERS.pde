
//-----------------------------------------------------------------------------------------
// GRAPHICS BUFFERS

void Monitor() {
  monitor.beginDraw();
    //Screen
    monitor.background(255);
    monitor.smooth();
  
    // World
    monitor.translate(monitor.width/2, monitor.height/2, -10);
    monitor.rotateX(rotX);
    monitor.rotateY(rotY);
    
    // Floor
    monitor.pushMatrix();
    monitor.pushStyle();
      monitor.scale(180);
      monitor.rotateX(rotX);
      monitor.beginShape(QUADS);
        monitor.stroke(0, 255, 255);
        monitor.fill(0, 255, 255, 128);
        monitor.vertex(-1,  1, -1);
        monitor.vertex( 1,  1, -1);
        monitor.vertex( 1,  1,  1);
        monitor.vertex(-1,  1,  1);
      monitor.endShape();
    monitor.popStyle();  
    monitor.popMatrix();  
    
    // Hand
    if(handsTrackFlag) {
      monitor.pushStyle();
        monitor.stroke(255,0,0,200);
        monitor.noFill();
        Iterator itr = handVecList.iterator(); 
        monitor.beginShape();
          while( itr.hasNext() ) { 
            PVector p = (PVector) itr.next(); 
            monitor.vertex(p.x,p.y);
          }
        monitor.endShape();
        monitor.stroke(255,0,0);
        monitor.strokeWeight(4);
        monitor.point(handVec.x,handVec.y);
      monitor.popStyle(); 
      pCanX = handX;
      pCanY = handY;
      handX = handVec.x;
      handY = handVec.y;
    }
  monitor.endDraw();
}

//-----------------------------------------

void Tag() {
  tag.beginDraw();  
    tag.smooth();
    // World
    tag.translate(tag.width/2, tag.height/2);
    tag.scale(1, -1);
    //tag.rotateX(rotX);
    //tag.rotateY(rotY);
    
    // Hand
    if(handsTrackFlag) {
      brushModes(handX, handY);
      // Draw Drips
      if(dripsIO == true) {
        drips();
      }
    }
  tag.endDraw();
} 

//-----------------------------------------------------------------------------------------
