
// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;      

// Data coming in from the data fields
String [] data;
int switchValue = 0;    // index from data fields
int potValue = 1;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 23;

// animated ball
int minPotValue = 0;
int maxPotValue = 4095;    // will be 1023 on other systems
int minSpeed = 0;
int maxSpeed = 50;
//int ballDiameter = 20;
int hMargin = 40;    // margin for edge of screen
int ximgMin;        // calculate on startup
int ximgMax;  // calc on startup
int yimgMin;        // calculate on startup
int yimgMax;  
float imgX;        // calc on startup, use float b/c speed is float
float imgY;        // calc on startup
int direction = -1;    // 1 or -1
PFont font;
PImage image;
PImage image2;

void setup ( ) {
  size (800,  600);    
  
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  myPort  =  new Serial (this, Serial.list()[serialIndex],  115200); 
  image=loadImage("image1.jpg");
  image2=loadImage("image2.jpg");
  font=createFont("Times New Roman", 32);
  
} 


// We call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  
    
    print(inBuffer);
    
    // This removes the end-of-line from the string AND casts it to an integer
    inBuffer = (trim(inBuffer));
    
    data = split(inBuffer, ',');
 
    // do an error check here?
    switchValue = int(data[0]);
    potValue = int(data[1]);
  }
} 

//-- change background to red if we have a button
void draw ( ) {  
  // every loop, look for serial information
  checkSerial();
  
  drawBackground();
  drawText();
  drawKillua();
  drawGon();
} 
// if input value is 1 (from ESP32, indicating a button has been pressed), change the background
void drawBackground() {
   if( switchValue == 1 )
    background( 30,99,239 );
  else
    background(0); 
}

void drawText(){
  if (switchValue==1){
    textFont(font);
    fill(255);
    text("GON", 600, height/2);
}else{
    textFont(font);
    fill(21,171,237);
    text("KILLUA", 600, height/2);
}
}

//moves the image
void drawKillua() {
    image(image, imgX, imgY);
    float speed = map(potValue, minPotValue, maxPotValue, minSpeed, maxSpeed);
    
    //-- change speed
    imgX = imgX + (speed * direction);
    imgY= imgY + (speed * direction);
    
    //-- make adjustments for boundaries
  if( imgX > ximgMax ) {
    direction = -1;    
    imgX = ximgMax;
  }
  else if( imgY < yimgMin ) {
    direction = 1;   
    imgY = yimgMin;
  }
      if( imgY > yimgMax ) {
    direction = -1;   
    imgY = yimgMax;
  }
  else if(  imgY < yimgMin ) {
    direction = 1;    
    imgY = yimgMin;
  }
}

void drawGon(){
  if (switchValue==1){
    image(image2, width/2, height/2);
}else{
   image(image, imgX,imgY);
}
}
