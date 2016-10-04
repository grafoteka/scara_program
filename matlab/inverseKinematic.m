function [q1,q2] = inverseKinematic(posX, posY, brazo1, brazo2, signo)
%% Motor 2
c2 = (posX^2 + posY^2 - brazo1^2 - brazo2^2) / (2 * brazo1 * brazo2);
s2 = -(sqrt(1 - c2^2));
q2 = atan2(real(s2),c2);
q2_grados = q2*180/pi;

%% Motor 1
beta = atan2(posY,posX);
alfa = atan2((brazo2 * real(s2)),(brazo1 + brazo2 * c2));
q1 = beta + alfa * signo;
q1_grados = rad2deg(q1);
