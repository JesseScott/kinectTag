
//-----------------------------------------------------------------------------------------
/*
 * KinectTag
 * ---------------------------------------------------------------------------
 * Graffiti Research Lab Germany
 * http://www.graffitiresearchlab.de
 * ----------------------------------------------------------------------------
 * License:
 * Attribution-Non-Commercial-Repurcussions 3.0 Unported (CC BY-NC 3.0)
 * as per http://www.graffitiresearchlab.fr/?portfolio=attribution-noncommercial-repercussions-3-0-unported-cc-by-nc-3-0
 * ----------------------------------------------------------------------------
 * Credits
 * _______
 * 
 * Programming:  Jesse Scott
 * 
 * Libraries:
 *  OscP5
 *  ControlP5
 *  GLGraphics
 *  GML4U
 *  ToxiLibs
 *  SimpleOpenNI
 * ----------------------------------------------------------------------------
 */
//-----------------------------------------------------------------------------------------

// IMPORTS
//-----------------------------------------------------------------------------------------

import SimpleOpenNI.*;
import controlP5.*;
import oscP5.*;
import netP5.*;

import gml4u.brushes.*;
import gml4u.drawing.GmlBrushManager;
import gml4u.events.GmlEvent;
import gml4u.model.GmlBrush;
import gml4u.model.GmlConstants;
import gml4u.model.GmlStroke;
import gml4u.model.Gml;
import gml4u.recording.GmlRecorder;
import gml4u.utils.GmlSaver;
import toxi.geom.Vec3D;

import java.util.concurrent.*;

// DECLARATIONS
//-----------------------------------------------------------------------------------------

secondApplet s;
PFrame f;
SimpleOpenNI context;
OscP5 oscP5; 
ControlP5 cP5;
PGraphics monitor, tag;
GmlRecorder recorder;
GmlSaver saver;
GmlBrushManager brushes;
GmlBrushManager brushManager;

// GLOBAL VARIABLES
//-----------------------------------------------------------------------------------------

// Painting
boolean nozzlePressed = false;
float handX, handY, canX, canY;
float pCanX, pCanY;
int gmlCounter = 1;

// Texture
PImage can, shirt, jt, jbr, jbl, cap;

// OpenNI
boolean autoCalib = true;

// Hand
float        rotX = radians(180);
float        rotY = radians(0);
boolean      handsTrackFlag = false;
PVector      handVec = new PVector();
CopyOnWriteArrayList    handVecList = new CopyOnWriteArrayList();
int          handVecListSize = 30;
String       lastGesture = "";

// GUI
int brushR = 255;
int brushG = 255;
int brushB = 255;
int brushA = 255;
color brushColor = color(brushR, brushG, brushB, brushA);
color currColor;
int brushMode = 1;
int brushSize = 15;
boolean saveScreen = false;
boolean dripsIO = false;
boolean clicked = false;
int saveCount = 0;

// Brushes
float diam;

// Drips
Drop [] drips;
int numDrips = 0;

//-----------------------------------------------------------------------------------------
// Setup

void setup() {
  // Screen
  size(788, 788, JAVA2D); 
  background(200);
  smooth();
  //frameRate(30);
  frame.setLocation(0, 0);
  
  // Texture
  monitor = createGraphics(768, 576, P3D);  
  tag = createGraphics(1024, 768, P2D); 
  
  // Second Screen
  f = new PFrame();
  
  // OpenNI
  context = new SimpleOpenNI(this, SimpleOpenNI.RUN_MODE_MULTI_THREADED);
  context.setMirror(true);
  if(context.enableDepth() == false) {
    println("Can't open the depthMap, maybe the camera is not connected!"); 
    exit();
    return;
  }
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  context.enableGesture();
  context.addGesture("Wave");
  context.addGesture("Click");
  context.addGesture("RaiseHand");
  context.enableHands();
  context.setSmoothingHands(.5);
  
  // OSC
  oscP5 = new OscP5(this, "127.0.0.1", 7110);
  
  // CP5
  cP5 = new ControlP5(this);
  cP5.addToggle("HAND", true, 500, height-140, 80, 40).setMode(ControlP5.SWITCH);
  cP5.addToggle("SKEL", true, 600, height-140, 80, 40).setMode(ControlP5.SWITCH);
  
  cP5.addSlider("BRUSH_SIZE", 1, 50, 15, 25, height-40, 100, 20);
  cP5.addSlider("BRUSH_R", 1, 255, 255, 25, height-60, 100, 20);
  cP5.addSlider("BRUSH_G", 1, 255, 255, 25, height-80, 100, 20);
  cP5.addSlider("BRUSH_B", 1, 255, 255, 25, height-100, 100, 20);
  cP5.addSlider("BRUSH_A", 1, 255, 255, 25, height-120, 100, 20);
  cP5.addBang("CR", 200, height-80, 40, 40);
  cP5.addBang("FW", 250, height-80, 40, 40);
  cP5.addBang("LN", 300, height-80, 40, 40);
  cP5.addBang("RB", 350, height-80, 40, 40);  
  cP5.addBang("FC", 400, height-80, 40, 40); 
  cP5.addBang("SP", 450, height-80, 40, 40);
  cP5.addToggle("DRIPS", 500, height-80, 60, 60);
  cP5.addBang("CLEAR", 590, height-80, 60, 60);
  cP5.addBang("SAVE", 680, height-80, 60, 60);
  
  // GML
  Vec3D screen = new Vec3D(1024, 768, 10);
  recorder = new GmlRecorder(screen, 0.015f, 0.01f);
  brushes = new GmlBrushManager();
  brushManager = new GmlBrushManager();
  saver = new GmlSaver(500, "", this);
  saver.start();
  GmlBrush brush = new GmlBrush();
  brush.set(GmlBrush.UNIQUE_STYLE_ID, CurvesDemo.ID);
  recorder.beginStroke(0, 0, brush); 
  
  // Drips
  drips = new Drop[6000];
  
  // Body
  can = loadImage("can.png");
  shirt = loadImage("shirt.png");
  jt = loadImage("jeansTop.png");
  jbr = loadImage("jbr.png");
  jbl = loadImage("jbl.png");
  cap = loadImage("cap.png"); 
  
  // Console
  println();
  println("//------------------");
  println();
  println("SETUP Finished...");
  println();
  println("//------------------");
  println();
  
} 

//-----------------------------------------------------------------------------------------
// Draw

void draw() {
  // Screen
  background(0);
  
  // OpenNI
  context.update();
  //image(context.depthImage(),0,0);
  
  // Monitor Screen
  Monitor();
  image(monitor, 10, 10);
  
  // Second Screen
  Tag();
  
  // Skeleton
  if(context.isTrackingSkeleton(1)) {
    Skeleton();
  }
  
  // GUI
  cP5.draw();
  
  // FPS
  if(frameCount % 300 == 0) {
    int fps = round(frameRate); 
    //println("Program Running @ " + fps + " FPS ");
  }
  
} 

//-----------------------------------------------------------------------------------------



