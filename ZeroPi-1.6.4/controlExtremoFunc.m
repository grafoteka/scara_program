function [ output_args ] = controlExtremoFunc(posX, posY )
% Funcion para calcular la cinematica inversa del robot
disp('Posicion del extremo');

%conversion a numeros
posX = str2num(posX); posY = str2num(posY);
%longitudes de los brazos
l1 = 10; l2 = 15;
%posicion final
pini = [0, 0];
pfin = [posX, posY];

%Comprobacion si el punto esta en el area de trabajo del robot
distancia = dist(pfin, pini);

if (distancia > 200) && (distancia < 375)
    disp('Punto valido');
    cuadranteCalculado = cuadrante(posX, posY)
    signo = 1;
    [q1, q2] = inverseKinematic(pini(1), pini(2), l1, l2, signo);   % Llamamos a la funcion para obtener los valores articulares
    
    if ((cuadranteCalculado == 4) && (q1 > -2) && (q1 < 0))
        signo = -1;
        [q1, q2] = inverseKinematic(pini(1), pini(2), l1, l2, signo);
        if((-135 < rad2deg(q1)) && (rad2deg(q1) < -45))
            disp ('Error de posicion')
            cla;
            msgbox('Por favor, introduzca un punto inicial valido',' Error punto inicial ');
            return;
        end
        %                 q1Disp = rad2deg(q1)
    end
    
    
    
else
    disp('Punto fuera del area de trabajo');
    return;
    
end
    

end

