
//-----------------------------------------------------------------------------------------
// GUI

 // COLOR + SIZE
 
 void BRUSH_SIZE(int BrushSize) {
    brushSize = (BrushSize);
  }
  
 void BRUSH_R(int BrushR) {
    brushR = (BrushR);
  }

 void BRUSH_G(int BrushG) {
    brushG = (BrushG);
  }
  
 void BRUSH_B(int BrushB) {
    brushB = (BrushB);
  } 
  
 void BRUSH_A(int BrushA) {
    brushA = (BrushA);
  } 
 
 // STYLES
 
 void CR(boolean theFlag) {
  if(theFlag == true) {
    brushMode = 1;
  }
 } 

 void FW(boolean theFlag) {
  if(theFlag == true) {
    brushMode = 2;
  }
 } 

 void LN(boolean theFlag) {
  if(theFlag == true) {
    brushMode = 3;
  }
 }

 void RB(boolean theFlag) {
  if(theFlag == true) {
    brushMode = 4;
  }
 }

 void FC(boolean theFlag) {
  if(theFlag == true) {
    brushMode = 5;
  }
 }
 
void SP(boolean theFlag) {
  if(theFlag == true) {
    brushMode = 6;
  }
 }
 
 void DRIPS(boolean theFlag) {
    if(theFlag == true) {
      dripsIO = true;
    } else if (theFlag == false) {
      dripsIO = false;
    }
 }

 // CLEAR
 void CLEAR(boolean theFlag) {
  if(theFlag == true) {
    println("ERASING");
    eraseAll();
  }
 }  
 
 // SAVE OPTIONS
  
 void SAVE(boolean theFlag) {
  if(theFlag == true) {
    saveScreen = true;
  }
 } 

//-----------------------------------------------------------------------------------------
