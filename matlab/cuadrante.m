function [cuadranteActual]=cuadrante(posX, posY)
    % Funcion para hallar el cuadrante en el que nos encontramos
    if(posX >= 0) && (posY >= 0)
        cuadranteActual = 1;
    end
    
    if(posX < 0) && (posY >= 0)
        cuadranteActual = 2;
    end
    
    if(posX < 0) && (posY < 0)
        cuadranteActual = 3;
    end
    
    if(posX >= 0) && (posY < 0)
        cuadranteActual = 4;
    end