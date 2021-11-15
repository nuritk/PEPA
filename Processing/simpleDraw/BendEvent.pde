     // Action types
    final static int PR_START = 0;
    final static int PR_RISING = 1;
    final static int PR_THRESHOLD = 2;
    final static int PR_FALLING = 3;
    final static int PR_PEAK = 4;
    final static int PR_PEAK_RELEASE = 5;
    final static int PR_END = 6;
    final static int PR_FLICK = 7;

    final static int SC_START = 8;
    final static int SC_RISING = 9;
    final static int SC_THRESHOLD = 10;
    final static int SC_FALLING = 11;
    final static int SC_PEAK = 12;
    final static int SC_PEAK_RELEASE = 13;
    final static int SC_END = 14;
    final static int SC_FLICK = 15;
  
  // * * * Event class * * * //
  public class BendEvent {
    long millis;
    int action;
    int step_value;
    Card target;
    int dt;



    BendEvent(long _millis, int _action, int _step_value, Card _target) {
      millis = _millis;
      action = _action;
      step_value = _step_value;
      target = _target;
    }
  }


  public class BendEndEvent extends BendEvent {
    int duration;
    int max_threshold;
    int count;

    BendEndEvent(long _millis, int _action, int _step_value, Card _target) {
      super( _millis, _action, _step_value, _target);
    }
  }