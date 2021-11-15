import processing.serial.*;
//import processing.video.*;

// The serial port:
Serial myPort;  
EventManager em;
Card c1;

IntList times = new IntList();
IntList bend1s = new IntList();
IntList unfiltered = new IntList();
IntDict eventTypes;


CCircle myCircle;
CRectangle myRect;

  // rects
  Button rect1,rect2,rect3 ,rect4 ,rect5 ;
  // circs
  Button circ1,circ2 ,circ3,circ4 ;
  
  
  // colosr
  Button color1 ,color2 ,color3 ,color4 ,color5 ,color6,color7 ,color8, color9;
  

int pixelSize;
int penSize;
String penType;
color penColor;

boolean animate = true;

void setup() {
  size(600, 600, P2D);
  frameRate(30);
  //em = new EventManager(this);
  //em.initEventManager(2, false);  // start with port 1
  
  c1 = new Card(this, "Card 1",2);  
  myCircle = new CCircle(100, 0, 20, color(140, 26, 110));
  myRect = new CRectangle (0, 150, 30, 20, color(49, 180, 90));
  CText text = new CText(0,100,0, color(255,0,0),"HELLO");
  CImage img = new CImage(0,0,"logo.bmp");
  c1.addObject(text);
  c1.addObject(img);
  c1.drawFrame();
//  c1.addObject(myCircle);
//  c1.addObject(myRect);
 


  // rects
   rect1 = new Button(500, 0*50+15, 50, 50,"rect 2px");
   rect2 = new Button(500, 1*50+15, 50, 50,"rect 4px");
   rect3 = new Button(500, 2*50+15, 50, 50,"rect 6px");
   rect4 = new Button(500, 3*50+15, 50, 50,"rect 8px");
   rect5 = new Button(500, 4*50+15, 50, 50,"rect 10px");
  // circs
   circ1 = new Button(500, 5*50+15, 50, 50,"circ 4px");
   circ2 = new Button(500, 6*50+15, 50, 50,"circ 6px");
   circ3 = new Button(500, 7*50+15, 50, 50,"circ 8px");
   circ4 = new Button(500, 8*50+15, 50, 50,"circ 10px");
  
  
  // colosr
   color1 = new Button(0*50+15, 500, 50, 50,"color1");
   color2 = new Button(1*50+15,500,  50, 50,"color2");
   color3 = new Button(2*50+15, 500, 50, 50,"color3");
   color4 = new Button(3*50+15, 500, 50, 50,"color4");
   color5 = new Button(4*50+15, 500, 50, 50,"color5");
   color6 = new Button(5*50+15, 500, 50, 50,"color6");
   color7 = new Button(6*50+15, 500, 50, 50,"color7");
   color8 = new Button(7*50+15, 500, 50, 50,"color8");
   color9 = new Button(8*50+15, 500, 50, 50,"color9");

 pixelSize = 2;
 penSize = 10;
 penType = "circ";
 penColor = color(203, 13, 76);

 animate = true;

     redrawGrid();
}


  
void redrawGrid(){
   background(255);
   strokeWeight(1);
  stroke(200);
  for (int i = 0; i<=480 ; i+=2) {
   line(0, i, 480, i);
   line(i, 0, i, 480);
  }
  
  stroke(0);
  //noFill();
  for (int i = 0; i < 9; i++) {
    rect(500, i*50+15, 50, 50);
  }
  for (int i = 0; i < 9; i++) {
    rect(i*50+15, 500, 50, 50);
  }
  // draw brushes

  // draw colors
  fill(0);
  textSize(14);
  text("'1' - clear to black\n'2' - clear to white", 40, height-40);
}


void draw() {
  rect1.updateState();
  rect1.drawButton();
  rect2.updateState();
  rect2.drawButton();
  rect3.updateState();
  rect3.drawButton();
  rect4.updateState();
  rect4.drawButton();
  rect5.updateState();
  rect5.drawButton();
  circ1.updateState();
  circ1.drawButton();
  circ2.updateState();
  circ2.drawButton();
  circ3.updateState();
  circ3.drawButton();
  circ4.updateState();
  circ4.drawButton();
  
  color1.updateState();
  color1.drawButton();
  color2.updateState();
  color2.drawButton();
  color3.updateState();
  color3.drawButton();
  color4.updateState();
  color4.drawButton();
  color5.updateState();
  color5.drawButton();
  color6.updateState();
  color6.drawButton();
  color7.updateState();
  color7.drawButton();
  color8.updateState();
  color8.drawButton();
  color9.updateState();
  color9.drawButton();
  
  if (rect1.isClicked()) {
    penType="rect";
    penSize=2;
  }
  if (rect2.isClicked()) {
    penType="rect";
    penSize=4;
  }
  if (rect3.isClicked()) {
    penType="rect";
    penSize=6;
  }
  if (rect4.isClicked()) {
    penType="rect";
    penSize=8;
  }
  if (rect5.isClicked()) {
    penType="rect";
    penSize=10;
  }
  if (circ1.isClicked()) {
    penType="circ";
    penSize=4;
  }
  if (circ2.isClicked()) {
    penType="circ";
    penSize=6;
  }
  if (circ3.isClicked()) {
    penType="circ";
    penSize=8;
  }
  if (circ4.isClicked()) {
    penType="circ";
    penSize=10;
  }
  
  if (color1.isClicked()) {
    penColor = color(236, 219, 83);
  }
  if (color2.isClicked()) {
    penColor = color(227, 65, 50);
  }
  if (color3.isClicked()) {
    penColor = color(108, 160, 220);
  }
  if (color4.isClicked()) {
    penColor = color(147, 71, 66);
  }
  if (color5.isClicked()) {
    penColor = color(219, 178, 209);
  }
  if (color6.isClicked()) {
    penColor = color(235, 150, 135);
  }
  if (color7.isClicked()) {
    penColor = color(0, 166, 140);
  }
  if (color8.isClicked()) {
    penColor = color(100, 83, 148);
  }
  if (color9.isClicked()) {
    penColor = color(191, 216, 51);
  }
  
  //if (mousePressed == true) {
  //  int pixel_x = int(mouseX/pixelSize);
  //  int pixel_y = int(mouseY/pixelSize);
  //  noStroke();
  //  fill(penColor);
  //  if (penType == "rect") {
  //    rect((pixel_x - penSize/2)*pixelSize, (pixel_y - penSize/2)*pixelSize, penSize*pixelSize, penSize*pixelSize);
  //    CRectangle tempRect;
  //    tempRect = new CRectangle (pixel_x - penSize/2, pixel_y - penSize/2, penSize, penSize, penColor);
  //    c1.addObject(tempRect);
  //  } else {
  //    ellipse((pixel_x - penSize/2)*pixelSize, (pixel_y - penSize/2)*pixelSize, penSize*pixelSize*2, penSize*pixelSize*2);
  //    CCircle tempCircle;
  //    tempCircle = new CCircle (pixel_x - penSize/2, pixel_y - penSize/2, penSize, penColor);
  //    c1.addObject(tempCircle);
  //  }
  //}
 // c1.drawFrame();
  c1.readBendValue();
  
  
}

void stop() {
  c1.stop();
}

void mousePressed() {
    int pixel_x = int(mouseX/pixelSize);
    int pixel_y = int(mouseY/pixelSize);
    if (mouseX > 480 || mouseY > 480) return;
    noStroke();
    fill(penColor);
    if (penType == "rect") {
      rect((pixel_x - penSize/2)*pixelSize, (pixel_y - penSize/2)*pixelSize, penSize*pixelSize, penSize*pixelSize);
      CRectangle tempRect;
      tempRect = new CRectangle (pixel_x - penSize/2, pixel_y - penSize/2, penSize, penSize, penColor);
      c1.addObject(tempRect);
      c1.drawFrame();
    } else {
      ellipse((pixel_x - penSize/2)*pixelSize, (pixel_y - penSize/2)*pixelSize, penSize*pixelSize*2, penSize*pixelSize*2);
      CCircle tempCircle;
      tempCircle = new CCircle (pixel_x - penSize/2, pixel_y - penSize/2, penSize, penColor);
      c1.addObject(tempCircle);
      c1.drawFrame();
    }
}

void keyPressed() {


  if (key == '1') {
    println("1");
    redrawGrid();
    c1.clearAllObjects();
    c1.clearToBlack();
    c1.drawFrame();
  }
  if (key == '2') {
    println("2");
    redrawGrid();
    c1.clearAllObjects();
    c1.clearToWhite();
    c1.drawFrame();
  }
}

/* 
 Implement event handlers
 void onPrStart(BendEvent event) {}
 void onPrRising(BendEvent event) {}
 void onPrThreshold(BendEvent event) {}
 void onPrFalling(BendEvent event) {}
 void onPrPeak(BendEvent event) {}
 void onPrPeakRelease(BendEvent event) {}
 void onPrEnd(BendEvent event) {}
 void onPrFlick(BendEvent event) {}
 
 void onScStart(BendEvent event) {}
 void onScRising(BendEvent event) {}
 void onScThreshold(BendEvent event) {}
 void onScFalling(BendEvent event) {}
 void onScPeak(BendEvent event) {}
 void onScPeakRelease(BendEvent event) {}
 void onScEnd(BendEvent event) {}
 void onScFlick(BendEvent event) {}
 
 Write the code for thw ones you need */

int x = 15; int y = 15;
void onPrStart(BendEvent event) {
 //c1.gm.clearToWhite();
 //c1.gm.drawCircle(100,100,(int)random(70)+50, color(100, 100,255));
}
void onPrRising(BendEvent event) {
}
void onPrThreshold(BendEvent event) {
  
  
}
void onPrFalling(BendEvent event) {
}
void onPrPeak(BendEvent event) {
  //println("pr peak  ");
  animate = !animate;
}
void onPrPeakRelease(BendEvent event) {
  //c1.gm.clearToWhite();
   //c1.gm.drawCircle(100,100,(int)random(70)+50, color(255, 0,0));
}
void onPrEnd(BendEvent event) {
  //c1.gm.clearToWhite();
 //c1.gm.drawCircle(100,100,(int)random(70)+50, color(0, 255,0));
}
void onPrFlick(BendEvent event) {
}

void onScStart(BendEvent event) {
}
void onScRising(BendEvent event) {
}
void onScThreshold(BendEvent event) {
  
  
}
void onScFalling(BendEvent event) {
}
void onScPeak(BendEvent event) {
 // println("sc peak  ");
}
void onScPeakRelease(BendEvent event) {
  
}
void onScEnd(BendEvent event) {
}
void onScFlick(BendEvent event) {
}

//Button class
/////////////////////////////////////////////////

boolean mouseReleased;

void mouseReleased(){
 mouseReleased = true; 
}

class Button {
  int posx;
  int posy;
  int bw;
  int bh;
  color border = color(0);
  //color fill = color(255, 255, 51);
  color fill= color(230);
  int text_size = 10;
  
  String text;
  
  final static int IDLE = 1;
  final static int HOVER = 2;
  final static int CLICKED = 3;
  final static int SELECTED = 4;
  
  int state = IDLE;
  boolean is_active = true;
  
  Button(int x, int y, int w, int h, String t) {
    posx = x;
    posy = y;
    bw = w;
    bh = h;
    text = t;    
  }
  
  boolean isInside(int x, int y) {
     return (x > posx && x < posx+bw && y> posy && y < posy+bh); 
  }
  
  boolean isClicked() {
    return (state == CLICKED);
  }
  
  void updateState() {
    if (state==SELECTED) return;
     if (isInside(mouseX, mouseY)) {
       if (mouseReleased) {state = CLICKED; mouseReleased = false;}
       else state = HOVER;
     }
      else state = IDLE; 
  }
  
  void drawButton() {
    if (!is_active) return;
    if (state == IDLE) {
      noStroke();
      fill(fill);
      rect(posx, posy, bw, bh, 10);
      stroke(border);
      strokeWeight(1);
      noFill();
      rect(posx, posy, bw, bh, 10);
    } else if (state == HOVER) {
      noStroke();
      fill(color(fill,120));
      rect(posx, posy, bw, bh, 10);
      stroke(border);
      strokeWeight(1);
      noFill();
      rect(posx, posy, bw, bh, 10);
      
    } else if (state == CLICKED) {
      noStroke();
      fill(color(255, 255, 51, 120));
      rect(posx, posy, bw, bh, 10);
      stroke(border);
      strokeWeight(2);
      noFill();
      rect(posx, posy, bw, bh, 10);
    } else if (state == SELECTED) {
      noStroke();
      fill(color(255, 255, 51));
      rect(posx, posy, bw, bh, 10);
      stroke(border);
      strokeWeight(2);
      noFill();
      rect(posx, posy, bw, bh, 10);
    }
    //textAlign(CENTER, CENTER);
    textSize(text_size);
    noStroke();
    fill(0);
    text(text, posx+5, posy+5, bw-10, bh-10);    
    
    
  }
  
}
