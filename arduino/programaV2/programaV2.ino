
/* --- LIBRERIAS --- */
// Controladora de motores
#include "MeOrion.h"
#include <Wire.h>
#include <SoftwareSerial.h>
// EEPROM
#include <EEPROM.h>

/* --- VARIABLES --- */
// I2C
MeEncoderMotor motor1(0x09, SLOT1);   //  Motor at slot1
MeEncoderMotor motor2(0x09, SLOT2);   //  motor at slot2

float motor2posOld = 0.0;

const int VEL1 = 10;
const int DIR1 = 11;
const int VEL2 = 9;
const int DIR2 = 3;
int reset = 9;
int pasos = 3500;
const int FDC1 = 8;
const int FDC2 = 12;
bool FDC1estado = LOW;
bool FDC2estado = LOW;

//EEPROM
int addressQ1 = 0;
int addressQ2 = 10;

//Serial
String cadena = "mensaje: ";
String first, second, third, fourth, fifth;
int modoFunc;

// Cuentas
int cuentaQ1 = 4000, cuentaQ2 = 4000;
int posRobot[] = {cuentaQ1, cuentaQ2};



/* --- SETUP --- */
// the setup routine runs once when you press reset:
void setup() {
  motor1.begin();
  motor2.begin();

  Serial.begin(9600);
  // initialize the digital pin as an output.
  pinMode(VEL1, OUTPUT);
  pinMode(DIR1, OUTPUT);
  pinMode(VEL2, OUTPUT);
  pinMode(DIR2, OUTPUT);
  pinMode(reset, OUTPUT);
  //calibracionFabrica();
}

/* --- MAIN --- */
// the loop routine runs over and over again forever:
void loop() {
  delay(50);
  // send data only when you receive data:
  while (Serial.available()) {
    if (Serial.available() >= 17) {
      first  = Serial.readStringUntil(',');
      //Serial.read(); //next character is comma, so skip it using this
      second = Serial.readStringUntil(',');
      //Serial.read();
      third = Serial.readStringUntil(',');
      fourth = Serial.readStringUntil(',');
      fifth = Serial.readStringUntil('\n');

      modo(first);
      Serial.println("OK");
    }
  }

}

