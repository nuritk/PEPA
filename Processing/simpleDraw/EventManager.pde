
class EventManager {
  PApplet app;
  Card parent;
  EventManager(PApplet theapp, Card p) {
    app = theapp;
    parent = p;
  }

  int[] eventIndicator = new int[16];

  BendEvent createEvent(long millis, int action, int step) {
    BendEvent e = new BendEvent(millis, action, step, parent);
    //parent.eventTypes.set(str(millis), action);
    eventIndicator[action] = 1;
    //println(parent.eventTypes);
    return e;
  } 
  void resetIndicators() {
    for (int i = 0; i < eventIndicator.length; i++) { 
      eventIndicator[i] = 0;
    }
  }
  boolean isConnected() {
    return connected;
  }
  int getBendValue() {
    return last_value;
  }
  boolean isPrRising() {
    return current_state == PR_RISING;
  }
  boolean isScRising() {
    return current_state == SC_RISING;
  }
  boolean isPrFalling() {
    return current_state == PR_FALLING;
  }
  boolean isScFalling() {
    return current_state == SC_FALLING;
  }
  boolean isPrPeak() {
    return current_state == PR_PEAK;
  }
  boolean isScPeak() {
    return current_state == SC_PEAK;
  }


  // * * * Algorithm Parameters * * * //

  int e0 = 27;  // noise from idle
  int es = 5;  // noise within step
  int sh = 10;  // step size
  int c = 30;   // number of cycles for peak

  boolean reverse_pm_sc = false;  // flip this boolean to change the direction of primary and secondary directions
  boolean dynamic_base = false;    // flip this boolean if the base value should remain constant

  // * * * Algorithm States * * * //
  final static int IDLE = 0;
  final static int PR_RISING = 1;
  final static int PR_FALLING = 2;
  final static int PR_PEAK = 4;
  final static int SC_RISING = 5;
  final static int SC_FALLING = 6;
  final static int SC_PEAK = 12;

  int current_state = IDLE;
  int last_value = -1;
  int base=-1;
  int last_base = -1;
  int last_step = 0;
  int c_count = 0;
  int cc = 0;
  int step = 0;


  ArrayList<BendEvent> eventStack = new ArrayList<BendEvent>();

  // * * * Additional variables * * * //
  Serial port1;
  String input = "";
  boolean connected = false;


  // * * * Init function (call once) * * * //
  /*  void initEventManager(int port, boolean reverse) {
   reverse_pm_sc = reverse;
   if (port < Serial.list().length) {
   String portName = Serial.list()[port];
   port1 = createSerial(portName);
   //port1 = new Serial(this, portName, 9600);
   port1.clear();
   connected = true;
   } else {
   println("EventManager: can't find port "+port+". Cannot connect");
   }
   //return new EventManager();
   }
   */



  // * * * State Machine functions * * * //
  /*int getStep(int value) {
   if (base == -1 || (value <= base + e_0 && value >= base - e_0)) return 0;
   if (value > base + e_0) {
   //println("------>"+value +" "+ceil((value - (base + e_0))/ (float)h));
   return ceil((value - (base + e_0))/ (float)h);
   }
   if (value < base - e_0) {
   //println("*********" + (base - e_0 - value) +" "+ ((base - e_0 - value) / (float)h) + " "+ceil((base - e_0 - value) / (float)h));
   //println("------>"+value +" "+ceil((base - e_0 - value) / (float)h));
   return ceil((base - e_0 - value) / (float)h);
   }
   return 0;
   }*/
  void triggerEvent(String event) {
    BendEvent e;
    println(event + " step:"+ step+" lastStep:" + last_step+" lastValue:"+last_value);
    switch(event) {
    case "pr_start":
      e = createEvent(millis(), PR_START, step);
      eventStack.add(e);
      onPrStart(e);
      break;
    case "pr_threshold":
      e = createEvent(millis(), PR_THRESHOLD, step);
      eventStack.add(e);
      onPrThreshold(e);
      break;
    case "pr_peak":
      e = createEvent(millis(), PR_PEAK, step);
      eventStack.add(e);
      onPrPeak(e);
      break;
    case "pr_peak_release":
      e = createEvent(millis(), PR_PEAK_RELEASE, step);
      eventStack.add(e);
      onPrPeakRelease(e);
      break;
    case "pr_end":
      e = createEvent(millis(), PR_END, step);
      eventStack.add(e);
      onPrEnd(e);
      println("---");
      break;
   case "sc_start":
      e = createEvent(millis(), SC_START, step);
      eventStack.add(e);
      onScStart(e);
      break;
    case "sc_threshold":
      e = createEvent(millis(), SC_THRESHOLD, step);
      eventStack.add(e);
      onScThreshold(e);
      break;
    case "sc_peak":
      e = createEvent(millis(), SC_PEAK, step);
      eventStack.add(e);
      onScPeak(e);
      break;
    case "sc_peak_release":
      e = createEvent(millis(), SC_PEAK_RELEASE, step);
      eventStack.add(e);
      onScPeakRelease(e);
      break;
    case "sc_end":
      e = createEvent(millis(), SC_END, step);
      eventStack.add(e);
      onScEnd(e);
      println("---");
      break;
    }
  }
  void processStates(int value) {
    resetIndicators();
    if (last_base == -1) {
      c_count++;
      if (c_count == 100) {
        base= value;
        last_base = value;
        last_value = value; 
        c_count = 0;
      }
      return;
    }
    value = value - base;

    if (reverse_pm_sc) value = -value;
    switch(current_state) {
    case IDLE:
      if (dynamic_base) {
        println("hhhhhhhhhhhhhhhhhhhh");
        // readjust the base line a little
        c_count++;
        if (c_count == c) {
          base = (3*base + value)/4;
          c_count = 0;
        }
      }
      cc = 0;
      if (abs(0 - value) >= e0) {
        step = ceil( value/ (float)sh );
        cc = 0;
        last_value = value;
        if (step > 0) {
          triggerEvent("pr_start");
          current_state = PR_RISING;
        } else if (step < 0) {
          triggerEvent("sc_start");
          current_state = SC_RISING;
        }
      }
      last_value = value;
      break;
    case PR_RISING:
      last_step = step;
      if (abs(value - last_value) <= es) {
        // step stays the same
      } else {
        step = ceil( value/ (float)sh );
      }
      last_value = value;
      if (step == 0  || abs(value) <= e0) {
        triggerEvent("pr_peak");
        triggerEvent("pr_peak_release");
        triggerEvent("pr_end");
        cc = 0;
        current_state = IDLE;
      } else if (step > last_step) {
        triggerEvent("pr_threshold");
        cc = 0;
      } else if (step == last_step) {
        cc++;
        if (cc == c) {
          triggerEvent("pr_peak");
          cc = 0;
          current_state = PR_PEAK;
        }
      } else if (step < last_step) {
        triggerEvent("pr_peak");
        triggerEvent("pr_peak_release");
        cc = 0;
        current_state = PR_FALLING;
      }
      break;

    case PR_PEAK:
      last_step = this.step;
      if (abs(value - last_value) <= es) {
        // step stays the same
      } else {
        step = ceil( value/ (float)sh );
      }
      last_value = value;
      if (step == 0  || abs(value) <= e0) {
        triggerEvent("pr_peak_release");
        triggerEvent("pr_end");
        current_state = IDLE;
      } else if (step > last_step) {
        triggerEvent("pr_threshold");
        current_state = PR_RISING;
        cc = 0;
      } else if (step < last_step) {
        triggerEvent("pr_peak_release");
        current_state = PR_FALLING;
        cc = 0;
      } else if (step == last_step) {
        //console.log("PR_PEAK");
        //this.triggerEvent('pr_peak');   // DO I WANT THIS?
      }

      break;
    case PR_FALLING:
      last_step = step;

      if (abs(value - last_value) <= es) {
        // step stays the same
      } else {
        step = ceil( value/ (float)sh );
      }
      last_value = value;
      if (step == 0  || abs(value) <= e0) {
        triggerEvent("pr_end");
        cc = 0;
        current_state = IDLE;
      } else if (step > last_step) {
        triggerEvent("pr_end");
        triggerEvent("pr_start");
        cc = 0;
        current_state = PR_RISING;
      } else if (step == last_step) {
        cc++;
        if (cc == c) {
          triggerEvent("pr_peak");
          cc = 0;
          current_state = PR_PEAK;
        }
      } else if (step < last_step) {
        triggerEvent("pr_threshold");
        cc = 0;
      } 
      break;
    case SC_RISING:
      last_step = step;
      if (abs(value - last_value) <= es) {
        // step stays the same
      } else {
        step = ceil( value/ (float)sh );
      }
      last_value = value;
      if (step == 0  || abs(value) <= e0) {
        triggerEvent("sc_peak");
        triggerEvent("sc_peak_release");
        triggerEvent("sc_end");
        cc = 0;
        current_state = IDLE;
      } else if (step > last_step) {
        triggerEvent("sc_threshold");
        cc = 0;
      } else if (step == last_step) {
        cc++;
        if (cc == c) {
          triggerEvent("sc_peak");
          cc = 0;
          current_state = SC_PEAK;
        }
      } else if (step < last_step) {
        triggerEvent("sc_peak");
        triggerEvent("sc_peak_release");
        cc = 0;
        current_state = SC_FALLING;
      }
      break;
    case SC_PEAK:
      last_step = step;
      if (abs(value - last_value) <= es) {
        // step stays the same
      } else {
        step = ceil( value/ (float)sh );
      }
      last_value = value;
      if (step == 0  || abs(value) <= e0 ) {
        triggerEvent("sc_peak_release");
        triggerEvent("sc_end");
        current_state = IDLE;
      } else if (step < last_step) {
        triggerEvent("sc_threshold");
        current_state = SC_RISING;
        cc = 0;
      } else if (step > last_step) {
        triggerEvent("sc_peak_release");
        current_state = SC_FALLING;
        cc = 0;
      } else if (step == last_step) {
        //console.log("SC_PEAK");
        //this.triggerEvent('sc_peak');  // DO I WANT THIS?
      }
      break;

    case SC_FALLING:
      last_step = step;

      if (abs(value - last_value) <= es) {
        // step stays the same
      } else {
        step = ceil( value/ (float)sh );
      }
      last_value = value;
      if (step == 0  || abs(value) <= e0) {
        triggerEvent("sc_end");
        cc = 0;
        current_state = IDLE;
      } else if (step > last_step) {
        triggerEvent("sc_end");
        triggerEvent("sc_start");
        cc = 0;
        current_state = SC_RISING;
      } else if (step == last_step) {
        cc++;
        if (cc == c) {
          triggerEvent("sc_peak");
          cc = 0;
          current_state = SC_PEAK;
        }
      } else if (step < last_step) {
        triggerEvent("sc_threshold");
        cc = 0;
      } 
      break;
    }
  }
 
}