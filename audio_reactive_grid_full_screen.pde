import processing.sound.*;
import processing.video.*;

FFT fft;
AudioIn in;
Amplitude analyzer;
Movie video;
PImage img;

int bands = 512;
float[] spectrum = new float[bands];


int cols, rows;
int scl = 16;
int w = 3400;
int h = 1800;

float flying = 0;

float[][] terrain;

void setup() {
  size(1920, 1080, P3D);
  
  video = new Movie(this, "/Users/alexanderroberts/Downloads/MOV_0022.mp4");
  //img = loadImage("Users/alexanderroberts/Desktop/PROCBACK.png");
  video.play();
  
  cols = w / scl;
  rows = h/ scl;
  terrain = new float[cols][rows];
  
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  
  // create a new Amplitude analyzer
  analyzer = new Amplitude(this);

  // Patch the input to an volume analyzer
  analyzer.input(in);

  
  // patch the AudioIn
  fft.input(in);
}


void draw() {

  flying -= 0.5;
  
  if (video.available()) {    
    video.read();  
  }
  
  video.loadPixels();

  fft.analyze(spectrum);
  float yoff = flying;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(spectrum[x], 0, 1, -2000, 6000);
      
      xoff += 0.5;
    }
    yoff += 0.5;
  }



  //background(video);
  //background(vol);
  
  float vol = analyzer.analyze();
  float vol2 = vol*2;
  float vol3 = vol + 0.8;
  
  background(vol * 2550, vol3 * 2550, (vol2 + vol)*100);
  stroke(10, 10, 10);
  print(vol);
  noFill();

  translate(-w/2, -h/2);
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      //texture(video);
      vertex(x*scl, y*scl, terrain[x][y]);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
      //rect(x*scl, y*scl, scl, scl);
    }
    endShape();
  }
  
}