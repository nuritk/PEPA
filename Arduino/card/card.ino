#include <Adafruit_GFX.h>    // Core graphics library
#include <Adafruit_ST7735.h> // Hardware-specific library for ST7735
#include <Adafruit_ST7789.h> // Hardware-specific library for ST7789
#include <SPI.h>
#include <SdFat.h>                // SD card & FAT filesystem library
#include <Adafruit_SPIFlash.h>    // SPI / QSPI flash library
#include <Adafruit_ImageReader.h> // Image-reading functions


//FreeSans12pt7b.h  FreeSerifBoldItalic12pt7b.hFreeSans18pt7b.h  //FreeSerifBoldItalic18pt7b.hFreeSans24pt7b.h  FreeSerifBoldItalic24pt7b.hFreeSans9pt7b.h   //FreeSerifBoldItalic9pt7b.h
 #include <Fonts/FreeSans12pt7b.h>

#define TFT_CS        10
#define TFT_RST        9 // Or set to -1 and connect to Arduino RESET pin
#define TFT_DC         7
#define SD_CS         13

const int FLEX_PIN0 = A0;
const int FLEX_PIN1 = A1;


Adafruit_ST7789 tft = Adafruit_ST7789(TFT_CS, TFT_DC, TFT_RST);


SdFat                SD;         // SD card filesystem
Adafruit_ImageReader reader(SD); // Image-reader object, pass in SD filesys
Adafruit_Image       img;        // An image loaded into RAM

const byte numChars = 250;
char receivedChars[numChars];
char tempChars[numChars];        // temporary array for use when parsing


boolean newData = false;

// drawing to offscreen canvas
// In global declarations:
//GFXcanvas1 canvas(128, 32); // 128x32 pixel canvas
// In code later:
//canvas.println("I like cake");
//tft.drawBitmap(x, y, canvas, 128, 32, foreground, background); // Copy to screen

//////////////////////////////
// Code starts
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.print(F("Hello! ST77xx TFT Test"));
delay(500);
  pinMode(FLEX_PIN0, INPUT);
  pinMode(FLEX_PIN1, INPUT);

  tft.init(240, 240);
  tft.fillScreen(ST77XX_BLACK);

  //tft.setFont(&FreeSerif9pt7b);
  Serial.println("hello");
  testdrawtext("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur adipiscing ante sed nibh tincidunt feugiat. Maecenas enim massa, fringilla sed malesuada et, malesuada sit amet turpis. Sed porttitor neque ut ante pretium vitae malesuada nunc bibendum. Nullam aliquet ultrices massa eu hendrerit. Ut sed nisi lorem. In vestibulum purus a tortor imperdiet posuere. ", ST77XX_WHITE);
  tft.setFont(&FreeSans12pt7b);
  if (!SD.begin(SD_CS, SD_SCK_MHZ(10))) {
    Serial.println("SD begin() fsailed");
  } else {
    Serial.println("SD success");
  }
  //delay(500);
  //drawImage("logo.bmp", 0, 0);
  delay(1000);
 
}
//============
void loop() {
  // put your main code here, to run repeatedly:
  int val0 = analogRead(FLEX_PIN0);
  int val1 = analogRead(FLEX_PIN1);

  //Serial.println("<dt:"+String(millis())+";b1:"+String(val0)+";b2:"+String(val1)+";>");
  Serial.println("<" + String(val0 - val1) + ">");

  recvWithStartEndMarkers();
  if (newData == true) {
    strcpy(tempChars, receivedChars);
    // this temporary copy is necessary to protect the original data
    //   because strtok() used in parseData() replaces the commas with \0
    //parseData();
    processMessages();
    newData = false;
  }
  delay(20);
}
//============
void recvWithStartEndMarkers() {
  static boolean recvInProgress = false;
  static byte ndx = 0;
  char startMarker = '<';
  char endMarker = '>';
  char rc;

  while (Serial.available() > 0 && newData == false) {
    rc = Serial.read();

    if (recvInProgress == true) {
      if (rc != endMarker) {
        receivedChars[ndx] = rc;
        ndx++;
        if (ndx >= numChars) {
          ndx = numChars - 1;
        }
      }
      else {
        receivedChars[ndx] = '\0'; // terminate the string
        recvInProgress = false;
        ndx = 0;
        newData = true;
      }
    }

    else if (rc == startMarker) {
      recvInProgress = true;
    }
  }
}

//============



void processMessages() {
  // read messages from controller
  // first char should be the code for the action
  // 'T' - draw text
  // 't' - draw
  // 'R' - draw filled rect
  // 'r' - draw outline rect
  // 'C' - draw filled circle
  // 'c' - draw outline circle
  // 'I' - draw image from SD card
  // 'b' - background
  // variables to hold the parsed data
  char type[1] = {'e'};
  int x = 0;
  int y = 0;
  int w = 0;
  int h = 0;
  int r = 0;
  char imgfile[numChars] = {0};
  uint16_t color = ST77XX_RED;
  uint8_t red = 0;
  uint8_t green = 0;
  uint8_t blue = 0;
 
  char * strtokIndx; // this is used by strtok() as an index

  strtokIndx = strtok(tempChars, ",");     // get the first part - the string
  strcpy(type, strtokIndx); // copy it to messageFromPC

  // second char will be x
  strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
  x = atoi(strtokIndx);     // convert this part to an integer

  // third char will be y
  strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
  y = atoi(strtokIndx);     // convert this part to an integer

  // additional chars depend on the code for the action
  switch (type[0]) {
    case 'T':
      strtokIndx = strtok(NULL, ","); // height of text
      h = atoi(strtokIndx);     // convert this part to an integer
      strtokIndx = strtok(NULL, ",");     // the string
      tft.setCursor(x, y);
      tft.setTextSize(h);
      tft.print(strtokIndx);
      break;
    case 'b':
       strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      red = atoi(strtokIndx);     // convert this part to an integer
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      green = atoi(strtokIndx);     // convert this part to an integer
       strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      blue = atoi(strtokIndx);     // convert this part to an integer
      color = tft.color565(red, green, blue);
      tft.fillScreen(color);
      break;
    case 'R' :
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      w = atoi(strtokIndx);     // convert this part to an integer
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      h = atoi(strtokIndx);     // convert this part to an integer
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      red = atoi(strtokIndx);     // convert this part to an integer
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      green = atoi(strtokIndx);     // convert this part to an integer
       strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      blue = atoi(strtokIndx);     // convert this part to an integer
      color = tft.color565(red, green, blue);
      drawRect(x, y, w, h, color, true);
      break;
    case 'r' :
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      w = atoi(strtokIndx);     // convert this part to an integer
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      h = atoi(strtokIndx);     // convert this part to an integer
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      red = atoi(strtokIndx);     // convert this part to an integer
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      green = atoi(strtokIndx);     // convert this part to an integer
       strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      blue = atoi(strtokIndx);     // convert this part to an integer
      color = tft.color565(red, green, blue);
      drawRect(x, y, w, h, color, false);
      break;
    case 'C':
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      r = atoi(strtokIndx);     // convert this part to an integer
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      red = atoi(strtokIndx);     // convert this part to an integer
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      green = atoi(strtokIndx);     // convert this part to an integer
       strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      blue = atoi(strtokIndx);     // convert this part to an integer
      color = tft.color565(red, green, blue);
      drawCircle(x, y, r, color, true);
      break;
    case 'c':
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      r = atoi(strtokIndx);     // convert this part to an integer
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      red = atoi(strtokIndx);     // convert this part to an integer
      strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      green = atoi(strtokIndx);     // convert this part to an integer
       strtokIndx = strtok(NULL, ","); // this continues where the previous call left off
      blue = atoi(strtokIndx);     // convert this part to an integer
      color = tft.color565(red, green, blue);
      drawCircle(x, y, r, color, false);
      break;
    case 'I':
      strtokIndx = strtok(NULL, ",");     // get the first part - the string
      strcpy(imgfile, strtokIndx); // copy it to messageFromPC
      drawImage(imgfile, x, y);
  }

}
//============
void testdrawtext(char *text, uint16_t color) {
  tft.setCursor(0, 0);
  tft.setTextColor(color);
  tft.setTextWrap(true);
  tft.print(text);
}
//============
void drawImage(char *filename, int16_t x, int16_t y ) {
  ImageReturnCode stat;
  //stat = reader.drawBMP(filename, tft, x, y);
  stat = reader.loadBMP(filename, img);
//Serial.print(filename);
//Serial.println((stat == IMAGE_SUCCESS));
  if (stat == IMAGE_SUCCESS) {
    img.draw(tft, x, y);
  }
  //  reader.printStatus(stat);   // How'd we do?

}
//============
void drawRect(int16_t x, int16_t y, int16_t width, int16_t height, uint16_t color, boolean filled) {
  if (filled) {
    tft.fillRect(x, y, width, height, color);
  } else {
    tft.drawRect(x, y, width, height, color);
  }
}
//============
void drawRoundRect(int16_t x, int16_t y, int16_t width, int16_t height, uint16_t radius, uint16_t color, boolean filled) {
  if (filled) {
    //tft.fillRoundRect(x, y, width, height, color);
  } else {
    //tft.drawRoundRect(x, y, width, height, color);
  }
}
//============
void drawCircle(int16_t x, int16_t y, int16_t radius, uint16_t color, boolean filled) {
  if (filled) {
    tft.fillCircle(x, y, radius, color);
  } else {
    tft.drawCircle(x, y, radius, color);
  }
}
