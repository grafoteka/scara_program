/*
 * Programa para el control de un robot scara desde matlab mediante comunicacion Serial
 * 
 * Incorpora tres modos de funcionamiento: control articular, cinematica inversa y jacobiana inversa
 * 
 * Autor: Jorge De Leon Rivas
 * mail: jorge.deleon@upm.es
 * September 2016
 */

/* --- LIBRERIAS --- */
// Controladora de motores
#include "MeOrion.h"
#include <Wire.h>
#include <SoftwareSerial.h>

/* --- VARIABLES --- */
// I2C
MeEncoderMotor motor1(0x09, SLOT1);   //  Motor at slot1
MeEncoderMotor motor2(0x09, SLOT2);   //  motor at slot2

float motor2posOld = 0.0;

//Serial
String cadena = "mensaje: ";
String first, second, third, fourth, fifth;
int modoFunc;

/* --- SETUP --- */
// the setup routine runs once when you press reset:
void setup() {
  motor1.begin();
  motor2.begin();

  Serial.begin(9600);

}

/* --- MAIN --- */
// the loop routine runs over and over again forever:
void loop() {
  delay(50);
  // send data only when you receive data:
  while (Serial.available()) {
    if (Serial.available()){// >= 17) {
      first  = Serial.readStringUntil(',');
      //Serial.read(); //next character is comma, so skip it using this
      second = Serial.readStringUntil(',');
      //Serial.read();
      third = Serial.readStringUntil(',');
      fourth = Serial.readStringUntil(',');
      fifth = Serial.readStringUntil('\n');

      modo(first);
      //Serial.println("OK");
    }
  }

}

