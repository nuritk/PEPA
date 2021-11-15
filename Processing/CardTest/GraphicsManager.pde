// I am going to mimic a slower frame count
class GraphicsManager{
  PApplet app;
  Card parent;
  long last_time;
  ArrayList<CGraphicsObject> objects = new ArrayList<CGraphicsObject>();
  
  GraphicsManager(PApplet theapp, Card p) {
    app = theapp;
    parent = p;
    last_time = millis();
  }
  
  void clearToBlack() {
    parent.sendMessage("<b,0,0,0,0,0>");
  }
  void clearToWhite() {
    parent.sendMessage("<b,0,0,255,255,255>");
  }
  void clearAllObjects() {
    objects = new ArrayList<CGraphicsObject>();
  }
  
  void drawFrame(){
    //if (millis()-last_time >= 50) {
      //clearToWhite();
      for (int i=0; i<objects.size(); i++) {
          parent.sendMessage(objects.get(i).createDrawMessage());
      }
      //last_time = millis();
    //}
  }
  
  void addObject(CGraphicsObject o) {
    objects.add(o);
  }
  void removeObject(CGraphicsObject o) {
    objects.remove(o);
  }
  
  // drawing elements without using the frame to store objects
  void drawElement(CGraphicsObject o) {
    parent.sendMessage(o.createDrawMessage());
  }
}

class CGraphicsObject{
    String createDrawMessage() {
      return "";
    }
}
class CCircle extends CGraphicsObject {
  int cx;
  int cy;
  int r;
  color c;
  CCircle(int cx, int cy, int r, color c){
    this.cx = cx;
    this.cy = cy;
    this.r = r;
    this.c = c;
  }
  String createDrawMessage() {
    return "<C,"+str(cx)+","+str(cy)+", "+str(r)+","+red(c)+","+green(c)+","+blue(c)+">";
  }
}

class CRectangle extends CGraphicsObject {
  int cx;
  int cy;
  int w;
  int h;
  color c;
  CRectangle(int cx, int cy, int w, int h, color c){
    this.cx = cx;
    this.cy = cy;
    this.w = w;
    this.h = h;
    this.c = c;
  }
  String createDrawMessage() {
    return "<R,"+str(cx)+","+str(cy)+", "+str(w)+","+str(h)+","+red(c)+","+green(c)+","+blue(c)+">";
  }
}

class CImage extends CGraphicsObject {
  int cx;
  int cy;
  String name;
  CImage(int cx, int cy, String n){
    this.cx = cx;
    this.cy = cy;
    this.name = n;
  }
  String createDrawMessage() {
    return "<I,"+str(cx)+","+str(cy)+","+name+">";
  }
}

class CText extends CGraphicsObject {
  int cx;
  int cy;
  int h;
  String str;
  color c;

  CText(int cx, int cy, int h, String n){
    this.cx = cx;
    this.cy = cy;
    this.h = h;
    this.c = color(255,255,255);
    this.str = n;
  }
  
  CText(int cx, int cy, int h, color c, String n){
    this.cx = cx;
    this.cy = cy;
    this.h = h;
    this.c = c;
    this.str = n;
  }
  
  void setString(String str){
    this.str = str;  
  }
  String createDrawMessage() {
    return "<T,"+str(cx)+","+str(cy)+","+str(h)+","+red(c)+","+green(c)+","+blue(c)+","+str+">";
  }
}
