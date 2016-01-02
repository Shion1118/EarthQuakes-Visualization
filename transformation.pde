final int NOT_TRANSFORMING = 0;
final int TO_SPHERE = 1;
final int TO_FLAT = 2;

int transformState = NOT_TRANSFORMING;
float transformFactor = 1.0;
int transformFrame = 0;
int framesToTransform = 20;

int sphereRadius = 500;


void transformToSphere(float x, float y){
  float theta = radians((x - MAP_WIDTH / 2) / MAP_WIDTH * 360);
  float phi = radians((y - MAP_HEIGHT / 2) / MAP_HEIGHT * 180);
  
  float xt = sphereRadius * cos(theta) * cos(phi);
  float yt = sphereRadius * sin(theta) * cos(phi);
  float zt = sphereRadius * sin(phi);
  
  float flatFactor = 1.0 - transformFactor;
  
  // Centers the map during the transition.
  translate(flatFactor * -MAP_WIDTH / 2, flatFactor * -MAP_HEIGHT / 2);
  translate(
      xt * transformFactor + flatFactor * x, 
      yt * transformFactor + flatFactor * y, 
      zt * transformFactor
      );
  rotateZ((theta + HALF_PI) * transformFactor);
  rotateX((-phi + HALF_PI) * transformFactor);
}

boolean isSphere(){
  return transformFactor >= 0.9999;
}

boolean isFlat(){
  return transformFactor <= 0.0001;
}

void stepToSphere(){
  transformFactor += 1.0 / framesToTransform;
  transformFrame++;
}

void stepToFlat(){
  transformFactor -= 1.0 / framesToTransform;
  transformFrame++;
}

void handleTransform(){
  if (transformState == TO_SPHERE){
    stepToSphere();
  } else if (transformState == TO_FLAT) {
    stepToFlat();
  }
  
  if (transformFrame >= framesToTransform) {
    if (transformState == TO_FLAT) {
      transformFactor = 0.0;
    } else if (transformState == TO_SPHERE) {
      transformFactor = 1.0;
    }
    transformState = NOT_TRANSFORMING;
  }
}