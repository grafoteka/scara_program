% Programa principal de la interfaz, registra lo que se selecciona en ella
% y desvia a la funciones externas para que los alumnos modifiquen lo menos
% posible la interfaz.
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% La funcion: controlArticularFunc.m se debe utilizar para el desarrollo
% del control articular del robot.

% La funcion: controlExtremoFunc.m se debe utilizar para el desarrollo de
% la cinematica inversa del robot, es decir, la del posicionamiento del
% extremo del robot.

% La comunicacion con Arduino se realiza mediante la funcion
% enviarMensajeFunc.m en ella se debe de formalizar el mensaje para Arduino
% con la siguiente estructura:

% mensaje = [codigo, valorq1, velocidadq1, valorq2, velocidadq2] % string

% ademas, cada valor del string tiene que tener unos determinados
% caracteres para que la comunicacion sea mas robusta.

% mensaje = [X, XXX, XXX, XXX, XXX]

% Seleccion del puerto: Si el programa no se ha podido conectar
% correctamente con el Arduino no permitira el envio de ningun comando al
% mismo.

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = vi(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vi_OpeningFcn, ...
                   'gui_OutputFcn',  @vi_OutputFcn, ...
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


% --- Executes just before vi is made visible.
function vi_OpeningFcn(hObject, eventdata, handles, varargin)
global orden;
orden = 1;

set(handles.q1textFieldConsigna, 'Visible', 'on');
set(handles.q2textFieldConsigna, 'Visible', 'on');
set(handles.q1InputConsigna, 'Visible', 'on');
set(handles.q2InputConsigna, 'Visible', 'on');

set(handles.xPosTextFieldConsigna, 'Visible', 'off');
set(handles.yPosTextFieldConsigna, 'Visible', 'off');
set(handles.xPosInputConsigna, 'Visible', 'off');
set(handles.yPosInputConsigna, 'Visible', 'off');

set(handles.xPosTextFieldJacobiana, 'Visible', 'off');
set(handles.yPosTextFieldJacobiana, 'Visible', 'off');
set(handles.xPosInputJacobiana, 'Visible', 'off');
set(handles.yPosInputJacobiana, 'Visible', 'off');
set(handles.timeField, 'Visible', 'off');
set(handles.timeInput, 'Visible', 'off');

%set(handles.simulateButton, 'visible', 'off');
set(handles.disconnectButton, 'visible', 'off');
% Choose default command line output for vi
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vi wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = vi_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function serialPortField_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function serialPortField_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% Comprobamos que opcion se ha escogido 
% Valor de la varible:
%   1 = control articular del robot
%   0 = control de la posicion del extremo del robot
estadoConsigna = get(handles.articularButton,'Value');
display(estadoConsigna)

% --- Funcion para el boton conectar
function connectButton_Callback(hObject, eventdata, handles)
clc;
global robot;
puerto = get(handles.serialPortField, 'String');
if isempty(puerto)
   errordlg('Error: Introduzca un puerto');
   set(handles.simulateButton, 'visible', 'off');
   return; 
end
%Creamos un objeto con el puerto serial
robot = serial(puerto);
%Conectamos el objeto al puerto serial
fopen(robot);
set(handles.simulateButton, 'visible', 'on');
set(handles.disconnectButton, 'visible', 'on');
set(handles.connectButton, 'visible', 'off');



% --- Executes during object creation, after setting all properties.
function uibuttongroup1_CreateFcn(hObject, eventdata, handles)

% --- Executes on button press in articularButton.
function articularButton_Callback(hObject, eventdata, handles)

% --- Executes on button press in simulateButton.
function simulateButton_Callback(hObject, eventdata, handles)
%Comprobacion de que se ha introducido un valor numerico en las cosignas
global orden; global robot;
%estadoConsigna = get(handles.articularButton,'Value');
%disp(estadoConsigna);

%ExtremoDelRobot
if(orden == 2)
    valor1 = get(handles.xPosInputConsigna, 'String');
    if isempty(str2num(valor1))
        %set(valor1,'string','0');
        warndlg('Input q1 must be numerical');
    end
    valor2 = get(handles.yPosInputConsigna, 'String');
    if isempty(str2num(valor1))
        %set(valor2,'string','0');
        warndlg('Input q2 must be numerical');
    end
    
    %Llamamos a la funcion para el control del extremo
    [valor1, valor2] = controlExtremoFunc(valor1, valor2);
    vel1 = 100; vel2 = 100;
    codigo = 3;
    mensaje = enviarMensajeFunc(codigo, valor1, vel1, valor2, vel2);
    %mensaje = [codigo, valorq1, velq1, valorq2, velq2]
    %mensaje = ['3,' num2str(valor1) ',' num2str(vel1) ',' num2str(valor2) ',' num2str(vel2)];
    fprintf(robot, '%s', mensaje) %Send message to Arduino
    
%Movimiento articular   
elseif (orden == 1)
    % Comprobacion de si hay valores numericos en las consignas
    valor1 = get(handles.q1InputConsigna, 'String');
    if isempty(str2num(valor1))
        %set(valor1,'string','0');
        warndlg('Input Xpos must be numerical');
    end
    valor2 = get(handles.q2InputConsigna, 'String');
    if isempty(str2num(valor1))
        %set(valor2,'string','0');
        warndlg('Input Ypos must be numerical');
    end
    
    %Llamamos a la funcion set_xy_actual
    [valorq1, valorq2, velq1, velq2] = controlArticularFunc(valor1, valor2);
    % velq1 = 100; velq2 = 100;
    
    %%
    %Condiciones de seguridad para q1
    if((valorq1 > 180) || (valorq1 < 0))
        warndlg('El valor de q1 debe estar entre 0 y 180');
        return;
    end
    %Condiciones de seguridad para q2
    if((valorq2 > 90) || (valorq2 < -90))
        warndlg('El valor de q2 debe estar entre -90 y 90');
        return;
    end
    
    %%
    codigo = 3;
    mensaje = enviarMensajeFunc(codigo, valorq1, velq1, valorq2, velq2);
    %mensaje = [codigo, valorq1, velq1, valorq2, velq2]
    %mensaje = ['2,' num2str(valor1) ',' num2str(vel1) ',' num2str(valor2) ',' num2str(vel2)];
    fprintf(robot, '%s', mensaje) %Send message to Arduino
    
end
set(handles.mensajeField, 'string', mensaje);
flag = 0; exit = 0; s1 = 'OK';
%mensaje = '2,000,000,000,000';
fprintf(robot, '%s', mensaje); %Send message to Arduino
mensaje = fscanf(robot) 
encodersEscritura(hObject, eventdata, handles, mensaje);


% --- Executes on button press in controlArticularButton.
function controlArticularButton_Callback(hObject, eventdata, handles)

% --- Executes on button press in controlExtremoButton.
function controlExtremoButton_Callback(hObject, eventdata, handles)

% --- Executes on button press in jacobianaButton12.
function jacobianaButton12_Callback(hObject, eventdata, handles)

% --- Executes when selected object is changed in consignasGroup.
function consignasGroup_SelectionChangedFcn(hObject, eventdata, handles)
global orden;
if hObject == handles.controlArticularButton
    orden = 1;
    
    % Modificamos la visualizacion segun la opcion escogida
    set(handles.q1textFieldConsigna, 'Visible', 'on');
    set(handles.q2textFieldConsigna, 'Visible', 'on');
    set(handles.q1InputConsigna, 'Visible', 'on');
    set(handles.q2InputConsigna, 'Visible', 'on');
    
    set(handles.xPosTextFieldConsigna, 'Visible', 'off');
    set(handles.yPosTextFieldConsigna, 'Visible', 'off');
    set(handles.xPosInputConsigna, 'Visible', 'off');
    set(handles.yPosInputConsigna, 'Visible', 'off');
    
    set(handles.xPosTextFieldJacobiana, 'Visible', 'off');
    set(handles.yPosTextFieldJacobiana, 'Visible', 'off');
    set(handles.xPosInputJacobiana, 'Visible', 'off');
    set(handles.yPosInputJacobiana, 'Visible', 'off');
    set(handles.timeField, 'Visible', 'off');
    set(handles.timeInput, 'Visible', 'off');

elseif hObject == handles.controlExtremoButton
    orden = 2;
    set(handles.q1textFieldConsigna, 'Visible', 'off');
    set(handles.q2textFieldConsigna, 'Visible', 'off');
    set(handles.q1InputConsigna, 'Visible', 'off');
    set(handles.q2InputConsigna, 'Visible', 'off');
    
    set(handles.xPosTextFieldConsigna, 'Visible', 'on');
    set(handles.yPosTextFieldConsigna, 'Visible', 'on');
    set(handles.xPosInputConsigna, 'Visible', 'on');
    set(handles.yPosInputConsigna, 'Visible', 'on');
    
    set(handles.xPosTextFieldJacobiana, 'Visible', 'off');
    set(handles.yPosTextFieldJacobiana, 'Visible', 'off');
    set(handles.xPosInputJacobiana, 'Visible', 'off');
    set(handles.yPosInputJacobiana, 'Visible', 'off');
    set(handles.timeField, 'Visible', 'off');
    set(handles.timeInput, 'Visible', 'off');
    
else 
    orden = 3;
    set(handles.q1textFieldConsigna, 'Visible', 'off');
    set(handles.q2textFieldConsigna, 'Visible', 'off');
    set(handles.q1InputConsigna, 'Visible', 'off');
    set(handles.q2InputConsigna, 'Visible', 'off');
    
    set(handles.xPosTextFieldConsigna, 'Visible', 'off');
    set(handles.yPosTextFieldConsigna, 'Visible', 'off');
    set(handles.xPosInputConsigna, 'Visible', 'off');
    set(handles.yPosInputConsigna, 'Visible', 'off');
    
    set(handles.xPosTextFieldJacobiana, 'Visible', 'on');
    set(handles.yPosTextFieldJacobiana, 'Visible', 'on');
    set(handles.xPosInputJacobiana, 'Visible', 'on');
    set(handles.yPosInputJacobiana, 'Visible', 'on');
    set(handles.timeField, 'Visible', 'on');
    set(handles.timeInput, 'Visible', 'on');
    
end
disp(orden)

function xPosInputJacobiana_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function xPosInputJacobiana_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function yPosInputJacobiana_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function yPosInputJacobiana_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function timeInput_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function timeInput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in disconnectButton.
function disconnectButton_Callback(hObject, eventdata, handles)
global robot;
fclose(robot);
msgbox('Conexion cerrada');
set(handles.connectButton, 'visible', 'on');
set(handles.simulateButton, 'visible', 'off');
set(handles.disconnectButton, 'visible', 'off');


% --- Executes on button press in encodersButton.
function encodersButton_Callback(hObject, eventdata, handles)
global robot;
mensaje = '2,000,000,000,000';
set(handles.mensajeField, 'string', mensaje);
fprintf(robot, '%s', mensaje); %Send message to Arduino
mensaje = fscanf(robot)
encodersEscritura(hObject, eventdata, handles, mensaje);


function encodersEscritura(hObject, eventdata, handles, mensaje)
recepcion = strsplit(mensaje)
set(handles.q1gradsText, 'string', recepcion(1));
set(handles.q2gradsText, 'string', recepcion(2));
posExtremo(hObject, eventdata, handles, mensaje)

%Funcion para convertir las coordenadas articulares en la posicion del
%extremo del robot
function posExtremo(hObject, eventdata, handles, mensaje)
%Separamos el mensaje
mensaje = strsplit(mensaje)
%Posicion de cada motor
q1 = str2double(mensaje(1)); q2 = str2double(mensaje(2));
%Longitudes de los brazos del robot
l1 = 110; l2 = 60;
x = l1*cos(deg2rad(q1)) + l2*cos(deg2rad(q1+q2));
x = round((x*100))/100
y = l1*sin(deg2rad(q1)) + l2*sin(deg2rad(q1+q2));
y = round((y*100))/100
set(handles.xPosText, 'string', num2str(x));
set(handles.yPosText, 'string', num2str(y));
