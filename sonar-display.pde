import processing.serial.*;

Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port

IntDict data;
String[] pair = new String[2];
int tangle, tdist;
//int x, y;
int maxim = 1000;

ArrayList<Ping> pings = new ArrayList<Ping>();

class Ping {
  int angle, dist, x, y, life;
  Ping(int _angle, int _dist) {
    angle = _angle;
    dist = _dist;
    x = round((((cos(radians(angle)) * dist) / maxim) * 500) + 500);
    y = round(map((((sin(radians(angle)) * dist) / maxim) * 500), 0, 1000, 1000, 0));
    life = 255;
  }
  void display() {
    fill(0, life, 0);
    ellipse(x, y, 10, 10);
    life--;
  }
}


void setup()
{
  background(0, 0, 0);
  noStroke();
  size(1000, 1000);
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
  data = new IntDict();
  data.set("90", 500);
  delay(200);
}

void drawCircles() {
  fill(0, 150, 0);
  textSize(50);
  text("IR Rangefinder", 25, 62);
  textSize(14);
  text("0", 520, 997);
  text("250", 631, 997);
  text("500", 756, 997);
  text("750", 880, 997);
  stroke(0, 150, 0);
  ellipse(500, 1000, 30, 30);
  noFill();
  ellipse(500, 1000, 250, 250);
  ellipse(500, 1000, 500, 500);
  ellipse(500, 1000, 750, 750);
  ellipse(500, 1000, 1000, 1000);
  line(500, 1000, (cos(radians(tangle))*500)+500, map((sin(radians(tangle))*500), 0, 1000, 1000, 0)); 
  noStroke();
}



void draw()
{
  background(0, 0, 0);
  drawCircles();

  if ( myPort.available() > 0) 
  {
    val = myPort.readStringUntil('\n');  
    if (val != null) {
      pair = split(val, "$");
      //if(pair.length < 2) {pair={"0","0"}}
      tangle = int(pair[0]);
      tdist = int(map(float(trim(pair[1])), 400, 600, 600, 400));
      pings.add(new Ping(tangle, tdist));
    }
  }
  for (int i = 0; i<pings.size(); i++) {
    Ping thisping = pings.get(i);
    thisping.display();
    if (thisping.life < 0) {
      pings.remove(i);
    }
  }
}
