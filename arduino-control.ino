#include <Servo.h>

Servo myservo;

int dist;
int res = 180;
int maxim = 1;
int steps = round(180 / res);

void setup() {
  myservo.attach(9);
  Serial.begin(9600);
  myservo.write(0);
  delay(1000);
}

void loop() {
    for (int angle = 0; angle < 180; angle = angle+steps) {
      myservo.write(angle);
      delay(40);
      dist = analogRead(0);
      if (dist > maxim) {
        maxim = dist;
      }
      Serial.print(angle);
      Serial.print("$");
      Serial.println(dist);
    }
    for (int angle = 180; angle > 0; angle = angle-steps) {
      myservo.write(angle);
      delay(40);
      dist = analogRead(0);
      if (dist > maxim) {
        maxim = dist;
      }
      Serial.print(angle);
      Serial.print("$");
      Serial.println(dist);
    }
}
