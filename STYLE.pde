
//-----------------------------------------------------------------------------------------
// BRUSH MODES

void brushModes(float _x, float _y) {
  // Coordinates
  canX = _x;
  canY = _y;
  
  // Current Colour
  tag.stroke(brushR, brushG, brushB, brushA);
  tag.fill(brushR, brushG, brushB, brushA);
  tag.strokeWeight(brushSize);
  tag.strokeJoin(ROUND);
  
  // BRUSH MODES
  if(brushMode == 1) { // Circle Brush
    tag.ellipse(canX, canY, brushSize, brushSize);
  }
  
  if (brushMode == 2) { // FWD SLASH
    tag.line(canX + brushSize, canY - brushSize, canX - brushSize, canY + brushSize);
  }
  
  if (brushMode == 3) { // SIMPLE LINE
    tag.line(canX, canY, pCanX, pCanY);
  }
  
  if (brushMode == 4) { // NATZKE RIBBON
    //ribbonManager.update(canX, canY);
  }
  
  if (brushMode == 5) { // FAT CAP, from http://www.openprocessing.org/visuals/?visualID=19923, by USER http://www.openprocessing.org/portal/?userID=9333
    diam = abs(canY - height/2)*.18;
    tag.strokeWeight(diam);
    tag.ellipse(canX, canY, diam, diam);
    tag.line(canX, canY, pCanX, pCanY);    
  }    
  
  if (brushMode == 6) { // GHETTO PAINT, from http://www.openprocessing.org/visuals/?visualID=2369, by USER http://www.openprocessing.org/portal/?userID=1641
    for(int i = 0; i < 15; i++) {
      float theta = random(0, 4 * PI);
      int radius = int(random(0, 30));
      int x = int(canX) + int(cos(theta)*radius);
      int y = int(canY) + int(sin(theta)*radius);
      tag.ellipse(x,y,0.5,0.5);
    }
  }  
  
}

//-----------------------------------------------------------------------------------------
// ERASE

void eraseBuffer() {
  color c = color(0,0);
  tag.beginDraw();
    tag.loadPixels();
    for (int x = 0; x < tag.width; x++) {
      for (int y = 0; y < tag.height; y++ ) {
        int loc = x + y * tag.width;
        tag.pixels[loc] = c;
      }
    }
    tag.updatePixels();
  tag.endDraw();
}

//-----------------------

void eraseAll() {
  tag.beginDraw();
    tag.background(0); // reset background
  tag.endDraw();
  eraseBuffer(); // set buffer pixels to black 
  recorder.clear(); // clear gml 
  numDrips = 0; // delete drips
}

//-----------------------------------------------------------------------------------------
// DRIPS

class Drop {
  int x, y, size,r,red,green,blue;
  boolean isMoving;
  Drop(int theX, int theY, int theRed, int theGreen, int theBlue) {
    x = theX;
    y = theY;
    brushR = theRed;
    brushG = theGreen;
    brushB = theBlue;
    r = int(random(399,600));
    size = 5;
    isMoving = true;
  }
  void drip(){
    if(size > 1 && random(1) < .3) {
      size--;
    }
    if(isMoving == true){
      if(frameCount % 2 == 1) {
        y++;
      }
    }
  }
  void stopping(){
    if(int(random(100)) == 0){
      isMoving = false;
    }
  }
  void show(){
    tag.fill(brushR,brushG,brushB,brushA);
    tag.stroke(brushR,brushG,brushB,brushA);
    tag.strokeWeight(2);
    tag.ellipse(x,y,size,size);
  }
}

//-----------------------

void drips() {
  if(numDrips < 999 && random(1) < .2) {
    drips[numDrips] = new Drop(int(canX), int(canY), brushR, brushG, brushB);
    numDrips++;
  }   
  for(int i = 0; i < numDrips; i++) {
    drips[i].drip();
    drips[i].show();
    drips[i].stopping();
  }
}
