//-----------------------------------------------------------------------------------------
// HAND EVENTS

void onCreateHands(int handId,PVector pos,float time) {
  //println("onCreateHands - handId: " + handId + ", pos: " + pos + ", time:" + time);
  handsTrackFlag = true;
  handVec = pos;
  handVecList.clear();
  handVecList.add(pos);
}

void onUpdateHands(int handId,PVector pos,float time) {
  //println("onUpdateHandsCb - handId: " + handId + ", pos: " + pos + ", time:" + time);
  handVec = pos;
  handVecList.add(0,pos);
  if(handVecList.size() >= handVecListSize) { 
    // remove the last point 
    handVecList.remove(handVecList.size()-1); 
  }
}

void onDestroyHands(int handId,float time) {
  //println("onDestroyHandsCb - handId: " + handId + ", time:" + time);
  handsTrackFlag = false;
  //handVecList.clear(); // erase list to avoid ConcurrentModificationException
  context.addGesture(lastGesture);
}

//-----------------------------------------------------------------------------------------
// GESTURE EVENTS

void onRecognizeGesture(String strGesture, PVector idPosition, PVector endPosition) {
  //println("onRecognizeGesture - strGesture: " + strGesture + ", idPosition: " + idPosition + ", endPosition:" + endPosition);
  lastGesture = strGesture;
  context.removeGesture(strGesture); 
  context.startTrackingHands(endPosition);
}

void onProgressGesture(String strGesture, PVector position,float progress) {
  //println("onProgressGesture - strGesture: " + strGesture + ", position: " + position + ", progress:" + progress);
}

//-----------------------------------------------------------------------------------------


