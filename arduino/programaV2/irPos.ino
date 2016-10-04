int irPos(String q1sentido, String q1delta, String q2sentido, String q2delta, int posQ1, int posQ2) {
  int q1sentidoInt = q1sentido.toInt();
  int q1deltaInt   = q1delta.toInt();
  int q2sentidoInt = q2sentido.toInt();
  int q2deltaInt   = q2delta.toInt();
  //Serial.println("OK");

  // Redondeo los pasos porque no puedo lograr porcentajes de paso
  // q1deltaInt = q1deltaInt.toInt();
  // q2deltaInt = q1deltaInt.toInt();

  // Ahora compruebo el orden de los pasos para cada motor
  //  float q1orden = 0;
  //  if ((q1deltaInt % 1000) == 1){
  //    q1orden = 0.001;}
  //  else if ((q1deltaInt % 100) == 1){
  //    q1orden = 0.01;}
  //  else if ((q1deltaInt % 10) == 1){
  //    q1orden = 0.1;}
  //  else{
  //    q1orden = 1;}


 // Serial.print(q1sentidoInt); Serial.print("\t"); Serial.print(q1deltaInt); Serial.print("\t"); Serial.print(q2sentidoInt); Serial.print("\t"); Serial.print(q2deltaInt);

  // Definimos los sentidos
  digitalWrite(DIR1, q1sentidoInt);
  digitalWrite(DIR2, q2sentidoInt);

  //int cuentaQ1 = 0, cuentaQ2 = 0;

  //Serial.print(posQ1); Serial.print("\t"); Serial.print(posQ2);
  /*
    for(int cuentaQ1 = 0; cuentaQ1 < q1deltaInt; cuentaQ1++){
    Serial.println("bucle1");
    digitalWrite(VEL1, HIGH);  // This LOW to HIGH change is what creates the
    delayMicroseconds(100);  // Regula la velocidad, cuanto mas bajo mas velocidad.
    digitalWrite(VEL1, LOW); // al A4988 de avanzar una vez por cada pulso de energia.
    delayMicroseconds(100);
    //cuentaQ1++;
    }

    for(int cuentaQ2 = 0; cuentaQ2 < q2deltaInt; cuentaQ2++){
    digitalWrite(VEL2, HIGH);  // This LOW to HIGH change is what creates the
    delayMicroseconds(100);  // Regula la velocidad, cuanto mas bajo mas velocidad.
    digitalWrite(VEL2, LOW); // al A4988 de avanzar una vez por cada pulso de energia.
    delayMicroseconds(100);
    //cuentaQ2++;
    }*/
  
  int posQ1ini = posQ1, posQ2ini = posQ2;
  int iteracionesQ1 = 1, iteracionesQ2 = 1;
  if (q1deltaInt > q2deltaInt) {
    iteracionesQ1 = round(q1deltaInt / q2deltaInt);
    iteracionesQ2 = 1;
  }
  else {
    iteracionesQ2 = round(q2deltaInt / q1deltaInt);
    iteracionesQ1 = 1;
  }
  
  int q1pFinal = 4000, q2pFinal = 4000;
  if (q1sentidoInt == 0) {
    q1pFinal = posQ1 - q1deltaInt;
  }
  else {
    q1pFinal = q1deltaInt - posQ1;
  }



  // Serial.print(iteracionesQ1); Serial.print("\t"); Serial.print(iteracionesQ2); Serial.print("\t");

  for (int i = 0; (posQ1 != q1pFinal) || (posQ2 != q2pFinal); i++) {
    //motor1
    for (int j = 0; j <= iteracionesQ1; j++) {
      if (posQ1 != q1pFinal) {
        digitalWrite(VEL1, HIGH);  // This LOW to HIGH change is what creates the
        delayMicroseconds(150);  // Regula la velocidad, cuanto mas bajo mas velocidad.
        digitalWrite(VEL1, LOW); // al A4988 de avanzar una vez por cada pulso de energia.
        delayMicroseconds(150);
        if (q1sentidoInt == 0)
          posQ1--;
        else
          posQ1++;
      }
    }
    
    //motor2
    for (int k = 0; k <= iteracionesQ2; k++) {
      if (posQ2 != (posQ2ini + q2deltaInt)) {
        digitalWrite(VEL2, HIGH);  // This LOW to HIGH change is what creates the
        delayMicroseconds(150);  // Regula la velocidad, cuanto mas bajo mas velocidad.
        digitalWrite(VEL2, LOW); // al A4988 de avanzar una vez por cada pulso de energia.
        delayMicroseconds(150);
        posQ2++;
      }
    }
    //delay(10);
    //Serial.println("caca");
  } //end for
  

  //Serial.print(posQ1); Serial.print("\t"); Serial.print(posQ2);
  cuentaQ1 = posQ1; cuentaQ2 = posQ2;

//Serial.println("OK");

}

