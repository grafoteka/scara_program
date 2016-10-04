function [ valorQ1, valorQ2 ] = controlArticularFunc( valorQ1, valorQ2 )
% Funcion para el control articular del robot
% Las consignas se dan en grados absolutos de cada una

disp('Control articular')

valorQ1 = str2num(valorQ1);
valorQ2 = str2num(valorQ2);

if(valorQ1 > 360)
    disp('Inserte un valor de Q1 más pequeño')
    valorQ1 = 1000;
    return
else  
end

if(valorQ2 > 360)
    disp('Inserte un valor de Q2 más pequeño')
    valorQ2 = 1000;
    return
else
end

end

