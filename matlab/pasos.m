% Funcion que recibe el angulo que debe moverse q1 y lo convierte en el
% numero de pasos que debe de dar el motor.
function [pasos] = pasos(alpha)
% El motor gira por cada paso 1.8? pero dependiendo de como esten los pines
% en el driver podemos obtener los siguientes multiplicadores:
% L-L-L 1/1
% H-L-L 1/2
% L-H-L 1/4
% H-H-L 1/8
% H-H-H 1/16
multiplicador = 16;
pasos = rad2deg(alpha) / 1.8 * (multiplicador);
end