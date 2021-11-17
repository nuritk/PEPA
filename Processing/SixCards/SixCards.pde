import processing.serial.*;
//import processing.video.*;


Card c1, c2, c3, c4, c5, c6;

void setup() {
  size(600, 600);
  
  c1 = new Card(this, "Card1"); 
  c2 = new Card(this, "Card2");
  c3 = new Card(this, "Card3");
  c4 = new Card(this, "Card4");
  c5 = new Card(this, "Card5");
  c6 = new Card(this, "Card6");
}


void draw() {
 background(255);
  // show instructions 
  textSize(16);
  fill(0);
  text("'1' - show logo on all cards", 20, 20);
  text("'2' - show card name  on each card", 20, 40);
  text("'3' - show maze", 20, 60);
  
 
  text("'4' - show cats", 270, 60);
}

void stop() {
  c1.stop();
}

void keyPressed() {
  

  if (key == '1') {
    c1.clearToWhite();
    c1.drawElement(new CImage(0,0,"logo.bmp"));
    c2.clearToWhite();
    c2.drawElement(new CImage(0,0,"logo.bmp"));
    c3.clearToWhite();
    c3.drawElement(new CImage(0,0,"logo.bmp"));
    c4.clearToWhite();
    c4.drawElement(new CImage(0,0,"logo.bmp"));
    c5.clearToWhite();
    c5.drawElement(new CImage(0,0,"logo.bmp"));
    c6.clearToWhite();
    c6.drawElement(new CImage(0,0,"logo.bmp"));
  }
  if (key == '2') {
    c1.clearToWhite();
    c1.drawElement(new CText(30,100,2, color(255,0,0),c1.name));
    c2.clearToWhite();
    c2.drawElement(new CText(30,100,2, color(255,0,0),c2.name));
    c3.clearToWhite();
    c3.drawElement(new CText(30,100,2, color(255,0,0),c3.name));
    c4.clearToWhite();
    c4.drawElement(new CText(30,100,2, color(255,0,0),c4.name));
    c5.clearToWhite();
    c5.drawElement(new CText(30,100,2, color(255,0,0),c5.name));
    c6.clearToWhite();
    c6.drawElement(new CText(30,100,2, color(255,0,0),c6.name));
  }
  if (key == '3') {
    c1.clearToWhite();
    c1.drawElement(new CImage(0,0,"tunnel1.bmp"));
    c2.clearToWhite();
    c2.drawElement(new CImage(0,0,"tunnel3.bmp"));
    c3.clearToWhite();
    c3.drawElement(new CImage(0,0,"tunnel4R.bmp"));
    c4.clearToWhite();
    c4.drawElement(new CImage(0,0,"tunnel1.bmp"));
    c5.clearToWhite();
    c5.drawElement(new CImage(0,0,"tunnel2.bmp"));
    c6.clearToWhite();
    c6.drawElement(new CImage(0,0,"tunnel4.bmp"));
  }
  if (key == '4') {
    c1.clearToWhite();
    c1.drawElement(new CImage(0,0,"animal1.bmp"));
    c1.drawElement(new CImage(10,150,"battle6_small.bmp"));
    c1.drawElement(new CImage(150,150,"shape5.bmp"));
    c2.clearToWhite();
    c2.drawElement(new CImage(0,0,"animal10.bmp"));
    c2.drawElement(new CImage(10,150,"battle6_small.bmp"));
    c2.drawElement(new CImage(150,150,"shape5.bmp"));
    c3.clearToWhite();
    c3.drawElement(new CImage(0,0,"animal3.bmp"));
    c3.drawElement(new CImage(10,150,"battle6_small.bmp"));
    c3.drawElement(new CImage(150,150,"shape5.bmp"));
    c4.clearToWhite();
    c4.drawElement(new CImage(0,0,"animal4.bmp"));
    c4.drawElement(new CImage(10,150,"battle6_small.bmp"));
    c4.drawElement(new CImage(150,150,"shape5.bmp"));
    c5.clearToWhite();
    c5.drawElement(new CImage(0,0,"animal9.bmp"));
    c5.drawElement(new CImage(10,150,"battle6_small.bmp"));
    c5.drawElement(new CImage(150,150,"shape5.bmp"));
    c6.clearToWhite();
    c6.drawElement(new CImage(0,0,"animal6.bmp"));
    c6.drawElement(new CImage(10,150,"battle6_small.bmp"));
    c6.drawElement(new CImage(150,150,"shape5.bmp"));
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

void onPrStart(BendEvent event) {


}
void onPrRising(BendEvent event) {

}
void onPrThreshold(BendEvent event) {

}
void onPrFalling(BendEvent event) {
}
void onPrPeak(BendEvent event) {

}
void onPrPeakRelease(BendEvent event) {
 
}
void onPrEnd(BendEvent event) {
 

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

}
void onScPeakRelease(BendEvent event) {
  
}
void onScEnd(BendEvent event) {

}
void onScFlick(BendEvent event) {
}
