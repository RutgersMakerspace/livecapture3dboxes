import processing.dxf.*;

/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */

import processing.video.*;
import peasy.*;

PeasyCam pcam;
Capture cam;
boolean record;
boolean reset = false;
int  mode = 0;
int modes = 4; //starting at 0
boolean snap = false;
int num = 0;

PImage img;  // The source image
int cellsize = 2; // Dimensions of each cell in the grid
float fcellsize = float(cellsize);
int columns, rows;   // Number of columns and rows in our system


void setup() {
  size(1200, 800, P3D);

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
  }


  // If no device is specified, will just use the default.  
  cam = new Capture(this, 320, 240);
  // cam = new Capture(this, 320, 240, "Logitech Camera", 15);

  pcam = new PeasyCam(this, width);
  pcam.setMinimumDistance(100);
  pcam.setMaximumDistance(500);
  // To use another device (i.e. if the default device causes an error),  
  // list all available capture devices to the console to find your camera.
  //String[] devices = Capture.list();
  //println(devices);

  // Change devices[0] to the proper index for your camera.
  //cam = new Capture(this, width, height, devices[0]);

  // Opens the settings page for this capture device.
  //camera.settings();

  img = loadImage("moo.jpg"); 
  img.resize(320, 240);

  //img = cam.read();
  columns = cam.width / cellsize;  // Calculate # of columns
  rows = cam.height / cellsize;  // Calculate # of rows
  cam.start();
}


void draw() {
  background(0);
  if (record) {
    beginRaw(DXF, "output.dxf");
  }
  if (cam.available())
  {
    cam.read();
    cam.loadPixels();
    //***chunck

    // Begin loop for columns
    for ( int i = 0; i < columns; i++) {
      // Begin loop for rows
      for ( int j = 0; j < rows; j++) {
        int x = i*cellsize + cellsize/2;  // x position
        int y = j*cellsize + cellsize/2;  // y position
        int loc = x + y*cam.width;  // Pixel array location
        color c = cam.pixels[loc];  // Grab the color

        //float z = grayscale(c);
        float z = grayscale(img.pixels[loc]);
        // Calculate a z position as a function of mouseX and pixel brightness
        //float z = (1000 / float(width)) * brightness(cam.pixels[loc]) - 20.0;
        //  float z = (mouseY / float(width)) * brightness(cam.pixels[loc]) - 20.0;
        // Translate to the location, set fill and stroke, and draw the rect
        pushMatrix();
        // translate(x + 200, y + 100);
        // rectMode(CENTER);
        //rect(0, 0, cellsize, cellsize);
        //ellipseMode(CENTER);
        //ellipse(0, 0, cellsize, cellsize);
        //box(cellsize, cellsize, cellsize);
        switch  (mode) {
        case 0:
          translate(x-160, y-120, z );
          fill(c, 204);
          noStroke();
          box(cellsize, cellsize, cellsize);
          break;
        case 1:
          translate(x-160, y-120, cellsize );
          fill(c, 204);
          noStroke();
          box(cellsize, cellsize, z);
          break;
        case 2:
          translate(x-160, y-120, z );
          fill(c, 204);
          noStroke();
          box(cellsize, cellsize, z);
          break;
        case 3:
          translate(x-160, y-120, z );
          fill(c, 204);
          noStroke();
          box(cellsize, cellsize, 0);
          break;
        case 4:
          translate(x-160, y-120, z );
          fill(c, 204);
          noStroke();
          ellipse(0, 0, cellsize, cellsize);
          break;
        default: 
          translate(x-160, y-120, cellsize );
          fill(c, 204);
          noStroke();
          box(cellsize, cellsize, cellsize);
          break;
        }
        //sphere(fcellsize);
        popMatrix();
      }
    }
  }


  //image(cam, 140, 0);
  if (record) {
    endRaw();
    record = false;
  }
  if (snap) {
    snap = false;
  }
  if (reset) {
    pcam.reset();
    reset = false;
  }
} 

//convert RGB to grayscale
int grayscale(color _c) {  
  //extract RGB values
  int r = (_c >> 16) & 0xFF;
  int g = (_c >> 8) & 0xFF;
  int b = _c & 0xFF;

  //typical NTSC color to luminosity conversion
  int intensity = int(0.2989*r + 0.5870*g + 0.1140*b);
  if (intensity> 0) intensity=int(map(intensity, 0, 255, 0, 100));
  return intensity;
}

void keyPressed() {
  // use a key press so that it doesn't make a million files
  if (key == 'r') record = true;
  if (key == TAB) 
  {
    if (mode < modes) 
    {
      mode++;
    } else
    {
      mode = 0;
    }
  }

  if (key == ESC) {
    key = 0;
    reset = true;
  }
  if (key == ' ') {
    num++;
    save("bgphoto" + num + ".png" );
    img = loadImage("bgphoto" + num + ".png"); 
    img.resize(cam.width, cam.height);
  }
}

