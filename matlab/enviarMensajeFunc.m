function [mensaje] = enviarMensajeFunc( codigo, valorq1, velq1, valorq2, velq2, scara )
%Funcion con la que se realiza la transmision del mensaje.
%La estructura del mensaje es la siguiente:

% mensaje = [codigo, valorq1, velq1, valorq2, velq2]
codigoStr = num2str(codigo);
valorq1 = num2str(valorq1);
velq1 = num2str(velq1);
valorq2 = num2str(valorq2);
velq2 = num2str(velq2);

mensaje = [codigoStr ',' valorq1 ',' velq1 ',' valorq2 ',' velq2];
%fprintf(scara, '%s', mensaje) %Send message to Arduino


end

