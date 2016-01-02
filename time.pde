int[] month_day = {31,28,31,30,31,30,31,31,30,31,30,31};
String[] month_name = {"Jan.","Feb.","Mar.","Apr.","May","June","July","Aug.","Sept.","Oct.","Nov.","Dec."};

class Time {
  
  int month = 0;
  int day = 0;
  int hour = 0;
  int minute = 0;
  int second = 0;
  
  void setup(float t){
    int i = 0;
    int day;
    
    this.minute = (int)t%60;
    this.hour = (((int)t - this.minute) / 60) % 24;
    day = ((((int)t - this.minute) / 60) - this.hour) / 24;
    while(i < 12) {
      if(day - month_day[i] > 0) {
        day -= month_day[i] ;
        i++;
      } else {
        break;
      }
    }
    this.day = day + 1;
    this.month = i + 1;
  }
}

float getTime() {
  return cp5.getController("TIME").getValue();
}

float getSpeed() {
  return cp5.getController("SPEED").getValue();
}