Table table;

class Quake {
  
  int year;
  int month;
  int day;
  int hour;
  int minute;
  int second;
  float latitude;
  float longitude;
  float magnitude;
  float visibletime = 0;
  boolean visible = false;
  
  void draw(){
    stroke(192 - this.magnitude * 19.2, 255, 255);
    strokeWeight(this.magnitude / 10.0 + 1.0);
    
    fill(192 - this.magnitude * 19.2, 255, 255, 100);
    
    pushMatrix();
    transformToSphere((this.longitude + 180) * globe.scalePixelsPerLongitude, (-this.latitude + 90) * globe.scalePixelsPerLatitude);

    //line(0, 0, 0, 0, 0, pow(magnitude, 1.1) * 10);
    float size = ((pow(this.magnitude, 1.1) * 10) / 500) * (getTime() - this.visibletime);
    ellipse(0, 0, size, size);
    popMatrix();
  }
  
}

void loadCsv(String csv) {
  table = loadTable(csv, "header");
  
  String time;
  String[] times;
  String[] ymd;
  String[] hms;
  
  for (TableRow row : table.rows()) {
    Quake quake = new Quake();
    
    time = row.getString("time");
    times = time.split(" ",  0);
    ymd = times[0].split("-", 0);
    hms = times[1].split(":", 0);
    
    quake.year = new Integer(ymd[0]).intValue();
    quake.month = new Integer(ymd[1]).intValue();
    quake.day = new Integer(ymd[2]).intValue();
    quake.hour = new Integer(hms[0]).intValue();
    quake.minute = new Integer(hms[1]).intValue();
    quake.second = new Double(hms[2]).intValue();
    quake.latitude = row.getFloat("latitude");
    quake.longitude = row.getFloat("longitude");
    quake.magnitude = row.getFloat("mag");
    
    quakes.add(quake);
  }

}

void drawQuakes() {
  for(Quake q: quakes) {
   if(!q.visible) {
     if(q.month == time.month && q.day == time.day && q.hour == time.hour && q.minute == time.minute) {
       q.visibletime = getTime();
       q.visible = true;
     }
   } else if(q.visible){
     if(getTime() > q.visibletime && getTime() - q.visibletime <= 500) {
       q.draw();
     }else{
       q.visible = false;
       q.visibletime = 0;
     }
   }
  }
}