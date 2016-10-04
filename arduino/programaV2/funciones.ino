/*
    La funcion modo se encarga de identificar la orden que se ha enviado desde Matlab
    Orden 1: setPosition -> Establece a 0 los contadores de los encoders
    Orden 2: getPosition -> Obtiene la posición en la que encuentran los encoders
    Orden 3: movement -> Envía las consignas de movimiento a los motores.
*/

void modo(String first) {
  float motor1pos, motor2pos, motor1vel, motor2vel, motor2posActual, motor2error, motor2velError;
  int i = 0, iteraciones = 100;
  modoFunc = first.toInt();
  switch (modoFunc) {
    // setPosition
    case 1:
      motor1.reset();
      motor2.reset();
      motor1pos = motor1.getCurrentPosition(); motor1pos = motor1.getCurrentPosition();
      motor2pos = motor2.getCurrentPosition(); motor2pos = motor2.getCurrentPosition();
      Serial.print(motor1pos); Serial.print(" "); Serial.println(motor2pos);
      break;

    // getPosition
    case 2:
      motor1pos = motor1.getCurrentPosition(); motor1pos = motor1.getCurrentPosition();
      motor2pos = motor2.getCurrentPosition(); motor2pos = motor2.getCurrentPosition();
      while ((abs(motor2pos - motor2posOld)) > 20) {
        Serial.println("Leyendo de nuevo");
        motor2pos = motor2.getCurrentPosition();
        delay(100);
      }
      Serial.print(motor1pos); Serial.print(" "); Serial.println(motor2pos);
      break;

    //movement
    case 3:
      motor1vel = third.toInt(); motor1pos = second.toInt();
      //motor1pos = map(motor1pos,0,360,360,0);
      motor1.moveTo(motor1pos, motor1vel);
      motor2vel = fifth.toInt(); motor2pos = fourth.toInt();
      motor2posActual = motor2posOld;
      motor2error = abs(motor2pos - motor2posActual);
      while (motor2error >= 0.1) {
        motor2.moveTo(motor2pos, motor2velError);
        motor2posActual = motor2.getCurrentPosition(); //motor2posActual = motor2.getCurrentPosition();
        motor2error = abs(motor2pos - motor2posActual);
        Serial.print("Posicion motor2: ");   Serial.print(motor2posActual); Serial.print(" ");
        Serial.print("Error motor 2: ");     Serial.print(motor2error);     Serial.print(" ");
        Serial.print("Velocidad motor 2: "); Serial.println(motor2velError);
        i++;
        if (i > iteraciones) {
          Serial.println("Posicion no alcanzada");
          break;
        }
        motor2velError = motor2vel * motor2error;
        if (motor2velError > 255) {
          motor2velError = 255;
        }
      }

      motor2pos = motor2lecturaEncoder(motor2posActual, motor2pos);
      Serial.print(motor1pos); Serial.print(" "); Serial.println(motor2pos); //Indicar la posicion en que se encuentra
      motor2posOld = motor2pos;
      break;

    // Poner a mano el robot en el origen
    case 4:
      motor1.runSpeed(0);
      motor2.runSpeed(0);
      break;

    case 5:
      Serial.println("Modo 5");
      break;

    default:
      Serial.println("Error");
  }
  //Serial.println("OK");
  //return modoFunc;
}

// Funcion para la lectura del encoder, para intentar evitar la lectura de 0.0 aleatoria, se incluye la variable posDeseada
// Con ella se intenta dar un margen de seguridad a la medida. En ella se debe enviar el valor de la posicion deseada.
float motor1lecturaEncoder(int motor1pos, int posDeseada) {
  while ((abs(motor1pos - posDeseada)) > 20) {
    Serial.println("Leyendo de nuevo");
    motor1pos = motor1.getCurrentPosition();
    delay(100);
  }
  return motor1pos;
}
float motor2lecturaEncoder(int motor2pos, int posDeseada) {
  while ((abs(motor2pos - posDeseada)) > 20) {
    Serial.println("Leyendo de nuevo");
    motor2pos = motor2.getCurrentPosition();
    delay(100);
  }
  return motor2pos;
}


