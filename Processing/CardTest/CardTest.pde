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
void setup() {
  size(displayWidth, 600);
  
  c1 = new Card(this, "Card 1");  
  myCircle = new CCircle(100, 0, 20, color(140, 26, 110));
  myRect = new CRectangle (0, 150, 30, 20, color(49, 180, 90));
  c1.addObject(myCircle);
  c1.addObject(myRect);
}

boolean show_unfiltered = false;
boolean show_startend = false;
boolean show_threshold = false;
boolean show_animation = false;

boolean big = false;
int drawn_steps = 0;

void draw() {
  background(255);
  strokeWeight(1);
  c1.readBendValue();
  
  //  draw stuff in here
  times = c1.getTimes();
  bend1s = c1.getValues();
  unfiltered = c1.getUnfiltered();
  if (times.size() > 23) {
    
    // show last 1000 values
    int base_time = times.get(0);
    int end_time = times.get(times.size()-1);
    int i = 0;
    int start_i = 0;
    //float x_step = (float)width/(end_time - base_time);
    float x_step = (float)width/times.size();
    if (times.size() > 1000) {
      base_time = times.get(times.size()-1001);
      start_i = times.size()-1001;
      i = times.size()-1000;
      x_step = (float)width/1000;
    }
    
    int y0 = 100;
    int y1 = 500;
    int b = c1.em.base;
    stroke(30);
    line(0, map(b, -250, 250, y0, y1),width, map(b, -250, 250, y0, y1));
    line(0, map(b+27, -250, 250, y0, y1),width, map(b+27, -250, 250, y0, y1));
    line(0, map(b-27, -250, 250, y0, y1),width, map(b-27, -250, 250, y0, y1));
    noStroke();
    for (; i< bend1s.size(); i++) {
      float x = x_step*(i-start_i);
      float y = map(unfiltered.get(i), -150, 150, y0, y1);
      noStroke();
      if (show_unfiltered) {
        fill(240, 163, 0);
        ellipse(x, y, 4, 4);
      }
      fill(0, 163, 240);
      y = map(bend1s.get(i), -250, 250, y0, y1);
      ellipse(x, y, 4, 4);
    }
  }
  
  // show instructions 
  textSize(16);
  fill(0);
  text("'1' - show logo on card", 20, 20);
  text("'2' - show text on card", 20, 40);
  text("'3' - toggle unfiltered values", 20, 60);
  
  text("'4' - show start/end bend on card", 270, 20);
  text("'5' - show threshold bend on card", 270, 40);
  text("'6' - show peak bend on card", 270, 60);
}

void stop() {
  c1.stop();
}

void keyPressed() {
  

  if (key == '1') {
    c1.clearToWhite();
    c1.drawElement(new CImage(0,0,"logo.bmp"));
  
  }
  if (key == '2') {
    c1.clearToWhite();
    c1.drawElement(new CText(30,100,0, color(255,0,0),"HELLO"));
    
  }
  if (key == '3') {
    show_unfiltered = !show_unfiltered;
  }
  if (key == '4') {
    c1.clearToWhite();   
    show_startend = !show_startend;
  }
  if (key == '5') {
    c1.clearToWhite();   
    show_threshold = !show_threshold;
  }
  if (key == '6') {
    c1.clearToWhite();   
    show_animation = !show_animation;
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

 if (show_startend) {
   c1.drawElement(new CCircle(20, 20, 20, color(140, 26, 110)));
   c1.drawElement(new CCircle(20, 220, 20, color(140, 26, 110)));
   c1.drawElement(new CCircle(220, 20, 20, color(140, 26, 110)));
   c1.drawElement(new CCircle(220, 220, 20, color(140, 26, 110)));
 }
}
void onPrRising(BendEvent event) {

}
void onPrThreshold(BendEvent event) {
  if (show_threshold) {
    if (event.step_value > drawn_steps){
      for (int i=drawn_steps; i <= event.step_value; i++) {
        c1.drawElement(new CRectangle(100, 120+i*8, 40, 4, color(0)));
      }
    }
    if (event.step_value < drawn_steps){
      for (int i=event.step_value; i <=drawn_steps ; i++) {
        c1.drawElement(new CRectangle(100, 120+i*8, 40, 4, color(255)));
      }
    }
    drawn_steps = event.step_value;
  }
}
void onPrFalling(BendEvent event) {
}
void onPrPeak(BendEvent event) {
  if (show_animation) {
    if (big) {
      c1.drawElement(new CCircle(120, 120, 30, color(240, 163, 0)));
    } else {
      c1.drawElement(new CCircle(120, 120, 30, color(255)));
      c1.drawElement(new CCircle(120, 120, 20, color(240, 163, 0)));
    }
    big = !big;
  }
}
void onPrPeakRelease(BendEvent event) {
 
}
void onPrEnd(BendEvent event) {
  if (show_startend) {
    c1.drawElement(new CCircle(20, 20, 20, color(255)));
    c1.drawElement(new CCircle(20, 220, 20, color(255)));
    c1.drawElement(new CCircle(220, 20, 20, color(255)));
    c1.drawElement(new CCircle(220, 220, 20, color(255)));
  }
  if (show_threshold) {
    if (event.step_value < drawn_steps){
      for (int i=event.step_value; i <=drawn_steps ; i++) {
        c1.drawElement(new CRectangle(100, 120-i*8, 40, 4, color(255)));
      }
    }
    drawn_steps = event.step_value;
  }

}
void onPrFlick(BendEvent event) {
}

void onScStart(BendEvent event) {
  if (show_startend) {
    c1.drawElement(new CCircle(20, 20, 20, color(49, 180, 90)));
    c1.drawElement(new CCircle(20, 220, 20, color(49, 180, 90)));
    c1.drawElement(new CCircle(220, 20, 20, color(49, 180, 90)));
    c1.drawElement(new CCircle(220, 220, 20, color(49, 180, 90)));
  }
}
void onScRising(BendEvent event) {
}
void onScThreshold(BendEvent event) {
    if (show_threshold) {
    if (event.step_value < drawn_steps){
      for (int i=abs(drawn_steps); i <= abs(event.step_value); i++) {
        c1.drawElement(new CRectangle(100, 120-i*8, 40, 4, color(0)));
      }
    }
    if (event.step_value > drawn_steps){
      for (int i=abs(event.step_value); i <=abs(drawn_steps) ; i++) {
        c1.drawElement(new CRectangle(100, 120-i*8, 40, 4, color(255)));
      }
    }
    drawn_steps = event.step_value;
  }
  
}
void onScFalling(BendEvent event) {
}
void onScPeak(BendEvent event) {
  if (show_animation) {
    if (big) {
      c1.drawElement(new CCircle(120, 120, 30, color(240, 163, 0)));
    } else {
      c1.drawElement(new CCircle(120, 120, 30, color(255)));
      c1.drawElement(new CCircle(120, 120, 20, color(240, 163, 0)));
    }
    big = !big;
  }
}
void onScPeakRelease(BendEvent event) {
  
}
void onScEnd(BendEvent event) {
   if (show_startend) {
    c1.drawElement(new CCircle(20, 20, 20, color(255)));
    c1.drawElement(new CCircle(20, 220, 20, color(255)));
    c1.drawElement(new CCircle(220, 20, 20, color(255)));
    c1.drawElement(new CCircle(220, 220, 20, color(255)));
  }
  if (show_threshold) {
    if (event.step_value > drawn_steps){
      for (int i=abs(event.step_value); i <=abs(drawn_steps) ; i++) {
        c1.drawElement(new CRectangle(100, 120-i*8, 40, 4, color(255)));
      }
    }
    drawn_steps = event.step_value;
  }

}
void onScFlick(BendEvent event) {
}
