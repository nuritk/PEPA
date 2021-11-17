
class CommManager{
  
  PApplet app;
  Card parent;
  Serial port;
  int last_value = 0;
  String input = "";
  boolean connected = false;
  
  CommManager(PApplet theapp, Card p, boolean bypass, int port_number) {
    app = theapp;
    parent = p;
   
    if (bypass) {
      Serial port = new Serial(app, Serial.list()[port_number] , 115200);
      setPort(port);
      return;
    }
    
    // retreiving a serial port from the user
    String[] empty = {""};
    String[] choices = concat(empty, Serial.list());
    String input = (String) showInputDialog(null, "Choose now...", 
      "Serial Port for "+parent.name, QUESTION_MESSAGE, null, 
      choices, // Array of choices
      choices[0]); // Initial choice

    if (input == "") {
      showMessageDialog(null, "No port specified", 
        "Info", INFORMATION_MESSAGE);
    } else {
      showMessageDialog(null, "Port "+ input + " specified. Attempting connection", 
        "Info", INFORMATION_MESSAGE);
        Serial port = new Serial(app, input, 115200);
        setPort(port);
    }
  }
  
  void setPort(Serial p) {
     port = p; 
     p.clear();
     connected = true;
  }
  
  void stop() {
    port.stop();
  }
  
  void sendMessage(String msg) {
    port.write(msg);
    
  }
  
    // * * * Read function (call in draw) * * * //
  int readBendValue() {
    int bend1 = last_value;
    if (connected && port.available()>0) {
      input += port.readString();

      String[] m = match(input, "<(.*?)>");
      while (m != null) {
        bend1 = parseInt(m[1]);
        parent.times.append(millis());
        parent.unfiltered.append(bend1);
        parent.processStates(bend1);
        int i = input.indexOf(">");
        input = input.substring(i+1, input.length());
        //input = "";
        m = match(input, "<(.*?)>");
      }
    }
    return bend1;
  }
}
