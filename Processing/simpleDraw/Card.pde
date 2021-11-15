import static javax.swing.JOptionPane.*;

class Card {
  PApplet app;
  EventManager em;
  CommManager cm;
  GraphicsManager gm;
  String name;

  IntList getTimes() { 
    return times;
  }
  IntList getValues() { 
    return bendValues;
  }
  IntList getUnfiltered() { 
    return unfiltered;
  }
  //IntDict getEventTypes() { return eventTypes; }
  void stop() {
    cm.stop();
  }  

  IntList times = new IntList();
  IntList bendValues = new IntList();
  IntList unfiltered = new IntList();

  IntList startEvents = new IntList();
  IntList peakEvents = new IntList();
  IntList peakReleaseEvents = new IntList();
  IntList endEvents = new IntList();
  //IntDict eventTypes = new IntDict(); // time will be the key and the event type will be a value

  int triangle_length = 11; // should be odd number
  IntList coefficients;
  IntList valueWindow = new IntList();

  int total_weight = 0;

  Card(PApplet p, String n) {
     app = p;
    name = n;
    em = new EventManager(app, this);
    cm = new CommManager(app, this, false, -1);
    gm = new GraphicsManager(app, this);

    coefficients = new IntList();
    int c = 1; 
    int c_increment = 1;
    for (int i=0; i<triangle_length; i++) {
      valueWindow.append(0);
      coefficients.append(c);
      if (c == (triangle_length +1)/2) c_increment = -1;
      total_weight += c;
      c += c_increment;
    } 
  }

  Card(PApplet p, String n, int port) {
    app = p;
    name = n;
    em = new EventManager(app, this);
    cm = new CommManager(app, this, true, port);
    gm = new GraphicsManager(app, this);

    coefficients = new IntList();
    int c = 1; 
    int c_increment = 1;
    for (int i=0; i<triangle_length; i++) {
      valueWindow.append(0);
      coefficients.append(c);
      if (c == (triangle_length +1)/2) c_increment = -1;
      total_weight += c;
      c += c_increment;
    }
    //println(coefficients);
  }

  int readBendValue() {
    return cm.readBendValue();
  }

  void drawFrame() {
    gm.drawFrame();
  }
  void addObject(CGraphicsObject o) {
    gm.addObject(o);
  }
  void removeObject(CGraphicsObject o) {
    gm.removeObject(o);
  }
  void clearToBlack() {
    gm.clearToBlack();
  }
  void clearToWhite() {
    gm.clearToWhite();
  }
  void clearAllObjects() {
    gm.clearAllObjects();
  }
  void processStates(int bend) {
    //if (em.base == -1) {
    //  em.base = bend;
    //}
    // filtering
    valueWindow.remove(0);
    valueWindow.append(bend);
    int filteredSignal = 0;
    for (int i=0; i<triangle_length; i++) {
      filteredSignal += valueWindow.get(i) * coefficients.get(i);
    }
    filteredSignal = filteredSignal/total_weight;

    bendValues.append(filteredSignal);
    // do we need to change this value in the window?
    em.processStates(filteredSignal); 
    if (em.eventIndicator[PR_START] == 1 || em.eventIndicator[SC_START] == 1) {
      //println("+++++++++++++++++");
      startEvents.append(1);
    } else 
    startEvents.append(0);

    if (em.eventIndicator[PR_PEAK] == 1 || em.eventIndicator[SC_PEAK] == 1) {
      //println(">>>>>>>>>>>>>>>>>");
      peakEvents.append(1);
    } else 
    peakEvents.append(0);  
    if (em.eventIndicator[PR_PEAK_RELEASE] == 1 || em.eventIndicator[SC_PEAK_RELEASE] == 1) {
      peakReleaseEvents.append(1);
      //println("^^^^^^^^^^^^^^^^^^^^");
    } else 
    peakReleaseEvents.append(0);  

    if (em.eventIndicator[PR_END] == 1 || em.eventIndicator[SC_END] == 1) {
      endEvents.append(1);
      //println("*******************");
    } else 
    endEvents.append(0);
  }

  void sendMessage(String msg) {
    cm.sendMessage(msg);
  }
}
