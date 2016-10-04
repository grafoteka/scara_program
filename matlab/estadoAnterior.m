function[] = estadoAnterior(a1, a2, extremo, piniOld)
%% Grafica
hold on
% Articulaciones
plot(a1(1),a1(2),'g.','MarkerSize',20)
plot(a2(1),a2(2),'g.','MarkerSize',20)
% Brazos
plot([a1(1), a2(1)],[a1(2), a2(2)], 'g')
plot([a2(1), extremo(1)],[a2(2), extremo(2)], 'm')
% Extremo
plot(extremo(1),extremo(2),'k','MarkerSize',10)
% Recta que describe el movimiento del extremo
%plot([piniOld(1), pini(1)], [piniOld(2), pini(2)])

end