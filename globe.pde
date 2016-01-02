final int MAP_WIDTH = 2048;
final int MAP_HEIGHT = 1024;

final color OCEAN_COLOR = color(54, 140, 173);

class GlobeDot {
  float x;
  float y;
  float colorOffset;
  
  int dotSize = 4;
  
  GlobeDot(float x, float y){
    this.x = x;
    this.y = y;
    this.colorOffset = random(0, 180);
  }
  
  void draw(){
    noStroke();
    //fill(128 + 64 * cos(this.colorOffset));
    fill(255);
    
    pushMatrix();
    transformToSphere(this.x, this.y);
    ellipse(0, 0, this.dotSize, this.dotSize);
    popMatrix();
  }
}

class Globe {
  
  int colorThreshold = 20;
  float dotSpacing = 8;
  
  boolean showThrough = false;

  PImage worldMap;
  ArrayList<GlobeDot> mapDots;
  
  float scalePixelsPerLongitude, scalePixelsPerLatitude;
  
  Globe(String mapFile) {
    this.worldMap = loadImage(mapFile);
    this.mapDots = new ArrayList();
    
    this.scalePixelsPerLongitude = MAP_WIDTH / 360.0;
    this.scalePixelsPerLatitude = MAP_HEIGHT / 180.0;
    
    build();
  }
  

  void build(){
    mapDots.clear();
    
    for (float y = this.dotSpacing / 2.0; y < MAP_HEIGHT; y += this.dotSpacing){
      
      float lat = (y / MAP_HEIGHT) * 180.0 - 90.0;
      float xSpacing = int(abs(this.dotSpacing / cos(radians(abs(lat)))));
      
      for (float x = xSpacing / 2.0; x < MAP_WIDTH; x += xSpacing){
      
        if (!this.isColorClose(worldMap.get(int(x), int(y)))){
          mapDots.add(new GlobeDot(x, y));
        }
      }
    }
  }
  
  void draw(){
        
    if (!this.showThrough && isSphere()){
      noStroke();
      fill(0);
      sphere(sphereRadius - 1);
    }
    
    for (int i=0; i < mapDots.size(); i++){
      GlobeDot gDot = mapDots.get(i);
      gDot.draw();
    }
    
  }
  
  boolean isInInterval(float x, float interval){
    return -interval < x && x < interval;
  }
  
  boolean isColorClose( color c ){
    return (
      isInInterval(red(c) - red(OCEAN_COLOR), colorThreshold) &&
      isInInterval(blue(c) - blue(OCEAN_COLOR), colorThreshold) &&
      isInInterval(green(c) - green(OCEAN_COLOR), colorThreshold)
      );
  }
  
  void toggleShowThrough(){
    this.showThrough = !this.showThrough;
  }
  
  void setDotSpace(float s) {
    this.dotSpacing = s;
    build();
  }

}