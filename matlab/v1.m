function varargout = v1(varargin)
% V1 MATLAB code for v1.fig
%      V1, by itself, creates a new V1 or raises the existing
%      singleton*.
%
%      H = V1 returns the handle to a new V1 or the handle to
%      the existing singleton*.
%
%      V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in V1.M with the given input arguments.
%
%      V1('Property','Value',...) creates a new V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help v1

% Last Modified by GUIDE v2.5 16-Sep-2016 12:37:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @v1_OpeningFcn, ...
                   'gui_OutputFcn',  @v1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before v1 is made visible.
function v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to v1 (see VARARGIN)

% Choose default command line output for v1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.disconnectButton, 'visible', 'off');
set(handles.sincronizeButton, 'visible', 'off');
set(handles.getpositionButton, 'visible', 'off');
set(handles.playButton, 'visible', 'off');
set(handles.getPositionField, 'visible', 'off');
% Iniciamos el robot en su posicion extendida
global piniOld; global a1; global a2; global extremo; 
global l1; global l2; global q1; global q2; global q1Old; global q2Old;
l1 = 168; l2 = 206;
piniOld = [374; 0];
a1 = [0, 0]; a2 = [l1 * cos(0), l1 * sin(0)]; extremo = [piniOld(1), piniOld(2)];

signo = 1;
[q1, q2] = inverseKinematic(extremo(1), extremo(2), l1, l2, signo);
q1Old = q1; q2Old = q2;

% UIWAIT makes v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = v1_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function serialportField_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function serialportField_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function baudrateField_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function baudrateField_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in getpositionButton.
function getpositionButton_Callback(hObject, eventdata, handles)
clc;
global scara; flag = 0; exit = 0;
s1 = 'OK';
messageMA = '2,000,000,000,000';
fprintf(scara, '%s', messageMA) %Send message to Arduino
[mensaje, count] = fscanf(scara) %Receive message from Arduino

% Sabemos la longitud del mensaje a recibir, si es correcta lo mostramos en
% la GUI
while(exit == 0)
    if(length(mensaje) >= 11)
        %     disp('11');
        %     messageAM = strsplit(mensaje,' ')
        set(handles.getPositionField, 'visible', 'on');
        set(handles.getPositionField, 'String', mensaje);
        mensaje = fscanf(scara);
        flag = 1;
    elseif((strcmp(s1,strcat(mensaje)) == 1) && (flag == 1))
        exit = 1;
        flag = 0;
        return;
    else
        mensaje = fscanf(scara);
    end
end


% --- Executes on button press in playButton.
function playButton_Callback(hObject, eventdata, handles)
global q1Disp; global q2Disp; global deltaQ1; global deltaQ2; global scara;
pasosQ1 = num2str(deltaQ1);
pasosQ2 = num2str(pasos(deltaQ2));
codigoStr = num2str(3);
%mensaje = [codigoStr ',' pasosQ1 ',200,' pasosQ2 ',' num2str(sentidoQ2)]
mensaje = [codigoStr ',000,000,' num2str(q1Disp) ',100']
fprintf(scara, '%s', mensaje) %Send message to Arduino

% --- Executes on button press in simulateButton.
function simulateButton_Callback(hObject, eventdata, handles)
global piniOld; global a1; global a2; global extremo; global l1; global l2; 
global q1; global q2; global q1Old; global q2Old;
global sentidoQ1; global sentidoQ2; global deltaQ1; global deltaQ2;
global q1Disp; global q2Disp;

%% Preparar grafica
cla;    % Limpiar grafica anterior
% Fijar ejes de la grafica
%set(handles.grafica(axis([-11 11 -11 11])));       % axis limits
xmin = -400; xmax = 400;
xlim = ([xmin xmax]);

ymin = -400; ymax = 400;
ylim = ([ymin ymax]);

% Dibujar grid
grid on;
hold on;

% Dibujar area de trabajo
xc=0; yc=0; r=[375, 200];  % Centro del circulo y radios exterior e interior
%i = 0;
%n = 360; %angExterior=15:225; 
%angExterior= 270:225; angInterior=0:360; angulos=[angExterior angInterior];

ang=deg2rad(315):0.01:5*pi/4;
% Circunferencia exterior
angExterior=deg2rad(0):0.01:deg2rad(360);
xp=(l1+l2)*cos(angExterior);
yp=(l1+l2)*sin(angExterior);
hold on
plot(xp,yp, 'r');   % Circunferencia exterior
plot(l1*cos(ang),l1*sin(ang), 'r'); % Circunferencia interior

%% Rectas limite
% q1 min
hold on
plot([0, 400*cos(deg2rad(315))]  ,[0, 400*sin(deg2rad(315))], 'r-')
% q1 max
hold on
plot([0, 400*cos(deg2rad(225))],[0, 400*sin(deg2rad(225))], 'r-')
%% Rectas l2
% Recta superior
q1 = deg2rad(20); q2 = deg2rad(270);
angLimiteSuperior = (q1+q2):0.01:(2*pi+deg2rad(20));
px = l1*cos(q1)+(l2)*cos(angLimiteSuperior);
py = l1*sin(q1)+(l2)*sin(angLimiteSuperior);
hold on 
%plot([l1*cos(deg2rad(20)), px],[l1*sin(deg2rad(20)), py], 'b')
% Recta inferior

% Dibujamos el robot en el estado inicial o anterior

estadoAnterior(a1, a2, extremo, piniOld)

%% Introducir primer punto
msgbox('Presione una tecla e inserte el punto inicial',' Punto inicial ');
pause();
[xini,yini] = ginput(1);
pini = [xini, yini];
hold on
plot(pini(1), pini(2), '+');

%% Comprobar primer punto
p0 = [0; 0];    % Punto para medir desde el origen
distancia = dist(pini, p0);

if (distancia > 200) && (distancia < 375)
    disp('Punto valido');
    cuadranteCalculado = cuadrante(pini(1), pini(2))
    signo = 1;
    [q1, q2] = inverseKinematic(pini(1), pini(2), l1, l2, signo);   % Llamamos a la funcion para obtener los valores articulares
    
%     q1Disp = rad2deg(q1) 
%     deltaQ1 = q1Disp;
%     q2Disp = rad2deg(q2)
    % Condicion para que en el cuadrante 1 el motor 1 no se
            % posicione por debajo de 20 grados
            % Si el punto en el cuadrante 1 o cuadrante 4 es inalcanzable
            % cambiamos el signo de la operacion, codo abajo o codo arriba
%             if ((cuadranteCalculado == 1) && (q1 < deg2rad(20)))
%                 signo = -1;
%                 [q1, q2] = inverseKinematic(pini(1), pini(2), l1, l2, signo);
%             end
%
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
%             
%             if((q1 < -2.3562) && (cuadranteCalculado == 3)) || ((cuadranteCalculado == 2) && (q2 > -2.3562)) || ((cuadranteCalculado == 1) && (q1 > 0.349)) || ((q1 < -2.35) && (cuadranteCalculado == 4)) || ((q1 > deg2rad(20)) && (cuadranteCalculado == 4))
%                 %% Dibujar robot
                a1 = [0, 0]; a2 = [l1 * cos(q1), l1 * sin(q1)]; extremo = [pini(1), pini(2)];
                
                % Grafica
                hold on
                % Articulaciones
                plot(a1(1),a1(2),'g.','MarkerSize',20)
                plot(a2(1),a2(2),'g.','MarkerSize',20)
                % Brazos
                plot([a1(1), a2(1)],[a1(2), a2(2)], 'g')
                plot([a2(1), extremo(1)],[a2(2), extremo(2)], 'm')
                % Extremo
                plot(extremo(1),extremo(2),'k*','MarkerSize',10)
                % Recta que describe el movimiento del extremo
                plot([piniOld(1), pini(1)], [piniOld(2), pini(2)], '--')
%                 
%                 
%               q1Disp = rad2deg(q1)
              if(rad2deg(q1) < -135)
                  q1Disp = 180 + (rad2deg(q1) + 180)
              else
                  q1Disp = rad2deg(q1)
              end
              q2Disp = rad2deg(q2)
%                 %% Ahora verificamos si las articulaciones del robot se han desplazado en sentido CW o CCW y cuanto lo han hecho.
%                 % CW  =  1
%                 % CCW = -1
%                 if(q1 > q1Old)
%                     deltaQ1 = q1 - q1Old;
%                     sentidoQ1 = -1;
%                 else
%                     deltaQ1 = q1Old - q1;
%                     sentidoQ1 = 1;
%                 end
%                 
%                 if(abs(q2) > abs(q2Old))
%                     deltaQ2 = q2 - q2Old;
%                     sentidoQ2 = 1;
%                 else
%                     deltaQ2 = q2Old - q2;
%                     sentidoQ2 = -1;
%                 end
%                 
%                 %% Actualizamos las variables
                %p0 = pini;
                piniOld = pini;
                q1Old = q1;
                q2Old = q2;
                
%             else
%                 cla;
%                 msgbox('Por favor, introduzca un punto inicial valido',' Error punto inicial ');
%                 return;
%             end
end

% --- Executes on button press in connectButton.
function connectButton_Callback(hObject, eventdata, handles)
global scara
puerto = get(handles.serialportField, 'String');
if isempty(puerto)
   errordlg('Error: Introduzca un puerto');
   return;
end
scara = serial(puerto);
fopen(scara);
set(handles.connectButton, 'visible', 'off');
pause(10);
disp('Fin pasua');
set(handles.disconnectButton, 'visible', 'on');
set(handles.sincronizeButton, 'visible', 'on');
set(handles.getpositionButton, 'visible', 'on');
set(handles.playButton, 'visible', 'on');

% --- Executes on button press in disconnectButton.
function disconnectButton_Callback(hObject, eventdata, handles)
global scara;
fclose(scara);
msgbox('Conexion cerrada');
set(handles.connectButton, 'visible', 'on');
set(handles.disconnectButton, 'visible', 'off');
set(handles.sincronizeButton, 'visible', 'off');
set(handles.getpositionButton, 'visible', 'off');
set(handles.playButton, 'visible', 'off');


% --- Executes on button press in sincronizeButton.
function sincronizeButton_Callback(hObject, eventdata, handles)
global scara
messageMA = '1,000,000,000,000';
s1 = 'OK';
fprintf(scara, '%s', messageMA); %Send message to Arduino
[mensaje, count] = fscanf(scara);
mensaje

if (strcmp(s1,mensaje) == 0)
    [mensaje, count] = fscanf(scara);
    mensaje
else
    return;
end
