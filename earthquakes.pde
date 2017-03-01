import peasy.*;
import processing.opengl.*;
import controlP5.*;
import java.text.DecimalFormat;

ControlP5 cp5;
PeasyCam cam;
Globe globe;
ArrayList<Quake> quakes = new ArrayList<Quake>();
Time time;
PFont tfont;
boolean tick = true;

void setup(){
  fullScreen(OPENGL);
  pixelDensity(displayDensity());
  smooth();
  colorMode(HSB);
  frameRate(30);
  
  cam = new PeasyCam(this, 1400);
  cam.setMaximumDistance(3000);
  cam.setWheelScale(0.3);
  cam.setResetOnDoubleClick(false);
  
  globe = new Globe("equirectangular_projection.jpg");
  
  tfont = createFont("LED.ttf", 35);
  
  loadCsv("query.csv");
  
  cp5 = new ControlP5(this);
  cp5.setFont(new ControlFont(createFont("Arial",5)));
  cp5.addButton("CAMERA RESET").setPosition(15,15).setSize(100, 30);
  cp5.addButton("CHANGE TYPE").setPosition(15,50).setSize(100, 30);
  cp5.addButton("TOGGLE").setPosition(15,85).setSize(100, 30);
  cp5.addSlider("DOT SPACE").setPosition(15,120).setRange(4,12).setValue(8);
  cp5.addSlider("TIME").setPosition(735,50).setSize(500,20).setRange(1,525600).setValue(1).setSliderMode(Slider.FLEXIBLE);
  cp5.addSlider("SPEED").setPosition(1030,75).setSize(205,10).setRange(0.1,100).setValue(10).setSliderMode(Slider.FLEXIBLE);
  cp5.addButton("START").setPosition(1030,90).setSize(100, 30);
  cp5.addButton("STOP").setPosition(1135,90).setSize(100, 30);
  cp5.setAutoDraw(false);
  
  time = new Time();
}

void draw(){
  background(0);
  globe.draw();
  gui();
  handleTransform();
  checkMouseOver();
  
  if(tick) cp5.getController("TIME").setValue(getTime() + getSpeed());
  drawQuakes();
  
  //saveFrame("tif/j####.tif");
}

void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  cp5.draw();
  time.setup(getTime());
  textFont(tfont);
  DecimalFormat df = new DecimalFormat("00");
  text("2011 " + df.format(time.month) + "/" + df.format(time.day) + " " + df.format(time.hour) + ":" + df.format(time.minute) + " UST" /*"Dec 26 16:57:36 JST"*/,735,40);
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void controlEvent(ControlEvent e) {
  switch(e.getController().getName()){
    case "CAMERA RESET":
      cam.reset();
      break;
    case "CHANGE TYPE":
      if (transformState == NOT_TRANSFORMING && isSphere()) {
        transformState = TO_FLAT;
        transformFrame = 0;
      } else if (transformState == NOT_TRANSFORMING && isFlat()) {
        transformState = TO_SPHERE;
        transformFrame = 0;
      }  
      break;
    case "TOGGLE":
      globe.toggleShowThrough();
      break;
    case "DOT SPACE":
      globe.setDotSpace(e.getController().getValue());
      break;
    case "START":
      tick = true;
      break;
    case "STOP":
      tick = false;
      break;
  }
}

void checkMouseOver() {
  if (cp5.isMouseOver()) {
    cam.setActive(false);
  } else {
    cam.setActive(true);
  }
}