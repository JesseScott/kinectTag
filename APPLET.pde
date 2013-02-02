

//-----------------------------------------------------------------------------------------
// SECOND SCREEN

public class PFrame extends Frame {
    public PFrame() {
        setBounds(screenWidth - 100, 0, 1024, 768);
        s = new secondApplet();
        add(s);
        removeNotify(); 
        setUndecorated(false);   
        setResizable(false);
        addNotify(); 
        setLocation(screenWidth - 1024, 0);
        s.init();
        //show();
        setVisible(true);
    }
}

//-----------------------------------------

public void init() {
  frame.removeNotify(); 
  frame.setUndecorated(false);   
  frame.setResizable(false);
  frame.addNotify(); 
  super.init();
}


//-----------------------------------------

public class secondApplet extends PApplet {
    public void setup() {
        size(1024, 768);
        background(0);
    }
 
    public void draw() {
      image(tag, 0, 0);
    }
}

//-----------------------------------------------------------------------------------------

