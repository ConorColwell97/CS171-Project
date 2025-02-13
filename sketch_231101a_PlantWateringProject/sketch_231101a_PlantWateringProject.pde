/*Audio tracks were found here:
 https://freesound.org/people/Nokta/sounds/625061/
 https://freesound.org/people/grakshay/sounds/614205/
 https://www.wavsource.com/sfx/sfx.htm
 
 Images were found on these websites:
 https://creazilla.com/
 https://icons8.com/
 
 Tutorial used for collision detection:
 https://www.youtube.com/watch?v=QyvxYS1RATA
 
 Code used for spawning multiple plants is similar to the code used for the multiple bouncing balls game from lab session 6
 Minim sound library was used for lab2 part2
 */

//Import libraries for audio
import ddf.minim.analysis.*;
import ddf.minim.*;

//Create instances of Minim & Audioplayer
Minim minim;
AudioPlayer splash;
AudioPlayer bloop;
AudioPlayer blip;
AudioPlayer refill;

PImage waterCan1, waterCan2;
PImage[] plants = new PImage[7];

float growthRate = 0.4;  //Default growth rate for watering plants
int multiplier = 1;  //Default score multiplier
int waterLevel = 500;  //Maximum water inside the watering can
int waterRate = 1;  //The rate at which the watering can empties
float wellPos = 60;  //Position of the water well
float wellSize = 40;  //Size of the well
int count = 0;  //Default score counter value
int timer = 60;  //Timer set to 60
int countDown;
int myBackgroundColor = color(95, 52, 18);

Plant [] p;

void setup()
{
  size(1000, 750);
  frameRate(30);  //Set the game to 30fps

  p = new Plant[20];  //Create instance of Plant class

  for (int x = 0; x < 20; x++)
  {
    p[x] = new Plant();  //Add 20 plants
  }

  //Load watering can images
  waterCan1 = loadImage("WaterCan1.png");
  waterCan1.resize(100, 100);
  waterCan2 = loadImage("WaterCan2.png");
  waterCan2.resize(100, 100);

  //Load plant images
  plants[0] = loadImage("plant1.png");
  plants[1] = loadImage("plant2.png");
  plants[2] = loadImage("plant3.png");
  plants[3] = loadImage("plant4.png");
  plants[4] = loadImage("plant5.png");
  plants[5] = loadImage("plant6.png");
  plants[6] = loadImage("flowers.png");

  //Load soundfiles
  minim = new Minim(this);
  splash = minim.loadFile("PouringWater.mp3");
  bloop = minim.loadFile("bloop.wav");
  blip = minim.loadFile("blip.wav");
  refill = minim.loadFile("Refill.wav");
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void draw()
{
  background(myBackgroundColor); //Set the background color to brown

  //Draw the water well for refilling the watering can
  fill(128, 128, 128);
  circle(wellPos, wellPos, 60);
  fill(0, 255, 255);
  circle(wellPos, wellPos, wellSize);

  for (int x = 0; x < 20; x++)
  {
    p[x].addPlant();  //Draw plants
  }

  if (!mousePressed)
  {
    splash.close();
    image(waterCan1, mouseX-70, mouseY-50);  //Add the watering can

    //Reload the soundfiles while the mouse is not being pressed
    splash = minim.loadFile("PouringWater.mp3");
    bloop = minim.loadFile("bloop.wav");
    blip = minim.loadFile("blip.wav");

    if (dist(wellPos, wellPos, mouseX-70, mouseY-50) <= wellSize && waterLevel >= 0 && waterLevel < 1000)
    {
      waterLevel += 1;  //If the watering can is close to the water well, refill the can with water
      refill.play();
    } else
    {
      refill.close();
      refill = minim.loadFile("Refill.wav");
    }
  } else
  {
    if (countDown > 0 && count < 20)
    {
      if (waterLevel > 0)
      {
        image(waterCan2, mouseX-70, mouseY-30);  //Switch watering can images so that it looks like it is pouring water
        waterLevel -= waterRate;  //Decrease the amount of water in the can while the mouse is being pressed
        splash.play();
      } else
      {
        image(waterCan1, mouseX-70, mouseY-30);  //If the can is empty, the original water can is added instead
        blip.play();
      }
    }
  }

  textSize(30);
  fill(0, 255, 0);
  text("Plants watered: "+count, 25, 25); //A score counter that shows how many plants the player has currently watered

  textSize(30);
  fill(0, 255, 0);
  text("Score Multiplier: "+multiplier+"x", 375, 25);  //Show the current score multiplier. The larger the multiplier, the faster the plants will grow when watered

  textSize(30);
  fill(0, 255, 255);
  text("Water level: "+waterLevel, 25, 725);  //Show the current amount of water remaining in the water can

  int millis = millis()/1000;
  countDown = timer - millis;
  textSize(30);
  fill(0, 255, 0);
  text("Time remaining: "+countDown, 750, 25); //Display the coundown timer, set to 60 seconds

  if (countDown <= 0 || count == 20)
  {
    //Stop the game and close all soundfiles once the countdown reaches 0
    splash.close();
    bloop.close();
    blip.close();
    refill.close();
    background(myBackgroundColor);

    //Display game over text
    textSize(100);
    fill(0, 255, 255);
    text("Game over!", 250, 375);
    textSize(50);
    text("Plants watered: "+count, 300, 425);  //Display how many plants that the player managed to water

    //Display appropriate message to the player based on how well they performed
    if (count == 20)
    {
      fill(0, 255, 255);
      textSize(50);
      text("All plants watered! Well done!", 200, 475);
      text("Press E to exit", 335, 530);
    }
    if (count > 15 && count <= 19)
    {
      fill(0, 255, 255);
      textSize(50);
      text("Very good!", 375, 475);
      text("Press E to exit", 335, 530);
    }
    if (count > 10 && count <= 15)
    {
      fill(0, 255, 255);
      textSize(50);
      text("Good!", 425, 475);
      text("Press E to exit", 335, 530);
    }
    if (count > 5 && count <= 10)
    {
      fill(0, 255, 255);
      textSize(50);
      text("Poor!", 425, 475);
      text("Press E to exit", 335, 530);
    }
    if (count > 0 && count <= 5)
    {
      fill(0, 255, 255);
      textSize(50);
      text("Very poor!", 375, 475);
      text("Press E to exit", 335, 530);
    }
    if (count == 0)
    {
      fill(0, 255, 255);
      textSize(50);
      text("You didn't water any plants", 200, 475);
      text("Press E to exit", 335, 530);
    }
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Plant  //A class that represents a plant. Plants spawn randomly in a set boundary on the screen. Watering them increases their size
{
  float plantSize = 30;  //Set the plant size
  float posX = random(150, 900);     //Give the plant a random X coordinate between 150 & 900
  float posY = random(150, 650);     //Give the plant a random Y coordinate between 150 & 650
  int randomPlant = int(random(0, 7));  //This random number determines which of the 7 plants will be added

  void addPlant()
  {
    image(plants[randomPlant], posX, posY, plantSize, plantSize); //Add a random plant to the world

    if (mousePressed)
    {
      if (dist(posX, posY, mouseX-50, mouseY+50) <= plantSize && plantSize < 100 && waterLevel > 0)
      {
        plantSize += growthRate;  //If the mouse has been pressed and the watering can is near a plant, increase the size of the plant

        if (plantSize >= 100 && plantSize <= 101)  //Plant is fully grown when it's size reaches 100
        {
          bloop.play();
          bloop = minim.loadFile("bloop.wav");
          count++;  //Increase the score counter by 1 whenever a plant is watered

          if (count == 2)
          {
            growthRate = 0.8; //Add a multiplier that makes plants grow twice as fast
            multiplier = 2;
          }
          if (count == 6)
          {
            growthRate = 1.2;  //Add a multiplier that makes plants grow three times faster
            multiplier = 3;
          }
          if (count == 10)
          {
            growthRate = 1.6;  //Add a multiplier that makes plants grow four times faster
            multiplier = 4;
          }
        }
      }
    }
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void keyTyped()
{
  if ((key == 'e') || (key == 'E'))  //Press 'e' or 'E' to exit the game at any stage
  {
    exit();
  }
}
