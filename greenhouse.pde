//initialise libaries.
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

//set the LCD address to 0x27 for a 20 chars and 4 line display
LiquidCrystal_I2C lcd(0x27,20,4); 

//initialise variables
float temp1c = 0, temp2c=0, tempavc=0;// temp2f=0, temp1f=0, tempavf=0; // temperature variables
float samples1[8]; // variables to make a better precision
float samples2[8]; // variables to make a better precision
float div1,div2,div3,div4,div5,div6,div7,div8, minin =0, maxin =0; // to start max/min temperature
unsigned int i, val, acti1,acti2,acti3,acti4,acto1min,acto2min,acto3min,acto4min,acto1max,acto2max,acto3max,acto4max, pos,mode=1;
boolean lastbutton,currentbutton;// for button input

//initial laoding function
void setup()
{
  Serial.begin (9600);
  lcd.init(); 
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("TEMP:");
  lcd.setCursor(7, 0);
  lcd.print(0xdf, BYTE);
  lcd.print("C");
  lcd.setCursor(12, 0);
  lcd.print("POS:");
  lcd.setCursor(0, 1);
  lcd.print("MIN:");
  lcd.setCursor(7, 1);
  lcd.print("MAX:");
  lcd.setCursor(0, 2);
  lcd.print("Mode:");
  pinMode(50,INPUT); //button in
  pinMode(32,OUTPUT); //act4
  pinMode(33,OUTPUT);
  pinMode(36,OUTPUT); //act3
  pinMode(37,OUTPUT); 
  pinMode(40,OUTPUT); //act2
  pinMode(41,OUTPUT);
  pinMode(44,OUTPUT); //act1
  pinMode(45,OUTPUT);
}

//debouncing function
boolean debounce (boolean last){
boolean current = digitalRead (50);
if (last!=current)
{delay(5);
current=digitalRead(50);}
return current;
}

//runtime finction
void loop()
{
  //mode input out of three
  currentbutton = debounce(lastbutton);
  if (lastbutton==LOW && currentbutton==HIGH){
  mode=mode+1;
  
//testing mode
//Serial.println(mode);
//Serial.println(digitalRead(50));

  if (mode=4){mode=1;}
  }
  lastbutton = digitalRead(50);
//bellow code to get the inputs.
//Serial.println(mode);
//Serial.println(digitalRead(50));

//actuator inputs
acti1 = analogRead(12);
acti2 = analogRead(13);
acti3 = analogRead(14);
acti4 = analogRead(15);
  
  //thermistor inputs
  for(i = 0;i<=7;i++){ // gets 8 samples of temperature

    samples1[i] = ( 5.0 * analogRead(2) * 100.0) / 1024.0;
    temp1c = temp1c + samples1[i];
    delay(10);

    samples2[i] = ( 5.0 * analogRead(3) * 100.0) / 1024.0;
    temp2c = temp2c + samples2[i];
    delay(10);
  }
//divides through the sum that was previously taken to get a precise reading of temperature (not really neccesary)
  temp1c = temp1c/8.0; // better precision
  temp2c = temp2c/8.0; // better precision

//  temp1f = (temp1c * 9)/ 5 + 32; // converts to fahrenheit
//  temp2f = (temp2c * 9)/ 5 + 32; // converts to fahrenheit

//average of the 2 thermistors. 
  tempavc = (temp1c + temp2c)/2;

//maximum temp is 41 degrees. analogue read 0 and 1 are the potentiometers to set these values. maybe replace with digital buttons.
minin = 41 * analogRead(0);
maxin = 41 * analogRead(1);
minin = minin/1024;
maxin = maxin/1024;

//if the max set is smaller than the min set, set the highest value to the minimum value. 
if (maxin < minin) {
  maxin = minin;}

//calculate the temperature positions
div1 = minin+(((maxin-minin)*1)/9);
div2 = minin+(((maxin-minin)*2)/9);
div3 = minin+(((maxin-minin)*3)/9);
div4 = minin+(((maxin-minin)*4)/9);
div5 = minin+(((maxin-minin)*5)/9);
div6 = minin+(((maxin-minin)*6)/9);
div7 = minin+(((maxin-minin)*7)/9);
div8 = minin+(((maxin-minin)*8)/9);

//set the position the actuators should be at.
if (tempavc<div1) {
pos=9;} 
else if (div1<tempavc && tempavc<=div2) {
pos=8;}
else if (div2<tempavc && tempavc<=div3) {
pos=7;}
else if (div3<tempavc && tempavc<=div4) {
pos=6;}
else if (div4<tempavc && tempavc<=div5) {
pos=5;}
else if (div5<tempavc && tempavc<=div6) {
pos=4;}
else if (div6<tempavc && tempavc<=div7) {
pos=3;}
else if (div7<tempavc && tempavc<=div8) {
pos=2;}
else if (div8<tempavc) {
pos=1;}
else{pos=10;}

//depending on the position set min and max values for each actuator.
if (pos==9) {
acto1min = 0;
acto1max = 3;
acto2min = 0;
acto2max = 3;
acto3min = 0;
acto3max = 3;
acto4min = 0;
acto4max = 3;
;} 
else if (pos==8) {
acto1min = 0;
acto1max = 3;
acto2min = 0;
acto2max = 3;
acto3min = 0;
acto3max = 3;
acto4min = 202;
acto4max = 208;
;}
else if (pos==7) {
acto1min = 0;
acto1max = 3;
acto2min = 0;
acto2max = 3;
acto3min = 202;
acto3max = 208;
acto4min = 407;
acto4max = 413;
;}
else if (pos==6) {
acto1min = 0;
acto1max = 3;
acto2min = 202;
acto2max = 208;
acto3min = 407;
acto3max = 413;
acto4min = 611;
acto4max = 617;
;}
else if (pos==5) {
acto1min = 202;
acto1max = 208;
acto2min = 407;
acto2max = 413;
acto3min = 611;
acto3max = 617;
acto4min = 816;
acto4max = 822;
;}
else if (pos==4) {
acto1min = 407;
acto1max = 413;
acto2min = 611;
acto2max = 617;
acto3min = 816;
acto3max = 822;
acto4min = 1020;
acto4max = 1023;
;}
else if (pos==3) {
acto1min = 611;
acto1max = 617;
acto2min = 816;
acto2max = 822;
acto3min = 1020;
acto3max = 1023;
acto4min = 1020;
acto4max = 1023;
;}
else if (pos==2) {
acto1min = 816;
acto1max = 822;
acto2min = 1020;
acto2max = 1023;
acto3min = 1020;
acto3max = 1023;
acto4min = 1020;
acto4max = 1023;
;}
else if (pos==1) {
acto1min = 1020;
acto1max = 1023;
acto2min = 1020;
acto2max = 1023;
acto3min = 1020;
acto3max = 1023;
acto4min = 1020;
acto4max = 1023;
;}
else{pos==10;}

//check the actuator position and change to what it should be acording to above limits. for act1
if (acti1<acto1min){
 digitalWrite(44, HIGH);
 digitalWrite(45, LOW); 
}
else if (acto1min<acti1 && acti1<acto1max){
 digitalWrite(44, HIGH);
 digitalWrite(45, HIGH); 
}
else if (acto1max<acti1){
 digitalWrite(44, LOW);
 digitalWrite(45, HIGH); 
}


//for act2
if (acti2<acto2min){
 digitalWrite(40, HIGH);
 digitalWrite(41, LOW); 
}
else if (acto2min<acti2 && acti2<acto2max){
 digitalWrite(40, HIGH);
 digitalWrite(41, HIGH); 
}
else if (acto2max<acti2){
 digitalWrite(40, LOW);
 digitalWrite(41, HIGH); 
}

//for act3
if (acti3<acto3min){
 digitalWrite(36, HIGH);
 digitalWrite(37, LOW); 
}
else if (acto3min<acti1 && acti3<acto3max){
 digitalWrite(36, HIGH);
 digitalWrite(37, HIGH); 
}
else if (acto3max<acti3){
 digitalWrite(36, LOW);
 digitalWrite(37, HIGH); 
}

//for act4
if (acti4<acto4min){
 digitalWrite(32, HIGH);
 digitalWrite(33, LOW); 
}
else if (acto4min<acti4 && acti4<acto4max){
 digitalWrite(32, HIGH);
 digitalWrite(33, HIGH); 
}
else if (acto4max<acti4){
 digitalWrite(32, LOW);
 digitalWrite(33, HIGH); 
}


//display the temp
  val=(int)tempavc;
  lcd.setCursor(5, 0);
  //lcd.print(0x30+val/100,BYTE); 
  lcd.print(0x30+(val%100)/10,BYTE);
  lcd.print(0x30+val%10,BYTE);

//display the position value
//val=(int)pos;
//  lcd.setCursor(15, 0);
//  //lcd.print(0x30+val/100,BYTE); 
//   lcd.print(0x30+(val%100)/10,BYTE);
//  lcd.print(0x30+val%10,BYTE);

//display the min value
  val=(int)minin;
  lcd.setCursor(4, 1);
  //lcd.print(0x30+val/100,BYTE); 
  lcd.print(0x30+(val%100)/10,BYTE);
  lcd.print(0x30+val%10,BYTE);
  
//display the max value
  val=(int)maxin;
  lcd.setCursor(11, 1);
  //lcd.print(0x30+val/100,BYTE); 
  lcd.print(0x30+(val%100)/10,BYTE);
  lcd.print(0x30+val%10,BYTE);

//display the mode value
  lcd.setCursor(16, 0);
  lcd.print(pos);
  
//display the mode value
  lcd.setCursor(6, 2);
  lcd.print(mode); 
   
//reset the temperature values.
  temp1c = 0;
  temp2c = 0;
  tempavc = 0;

  delay(1000); // delay before loop
}

