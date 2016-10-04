function varargout = vi(varargin)
% VI MATLAB code for vi.fig
%      VI, by itself, creates a new VI or raises the existing
%      singleton*.
%
%      H = VI returns the handle to a new VI or the handle to
%      the existing singleton*.
%
%      VI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VI.M with the given input arguments.
%
%      VI('Property','Value',...) creates a new VI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vi_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vi_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vi

% Last Modified by GUIDE v2.5 06-Sep-2016 15:35:19

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
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vi (see VARARGIN)
    set(handles.q1textFieldConsigna, 'Visible', 'on');
    set(handles.q2textFieldConsigna, 'Visible', 'on');
    set(handles.q1InputConsigna, 'Visible', 'on');
    set(handles.q2InputConsigna, 'Visible', 'on');
    
    set(handles.xPosTextFieldConsigna, 'Visible', 'off');
    set(handles.yPosTextFieldConsigna, 'Visible', 'off');
    set(handles.xPosInputConsigna, 'Visible', 'off');
    set(handles.yPosInputConsigna, 'Visible', 'off');
    
    set(handles.simulateButton, 'visible', 'off');
% Choose default command line output for vi
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vi wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = vi_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function serialPortField_Callback(hObject, eventdata, handles)
% hObject    handle to serialPortField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of serialPortField as text
%        str2double(get(hObject,'String')) returns contents of serialPortField as a double


% --- Executes during object creation, after setting all properties.
function serialPortField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to serialPortField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
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
%display(estadoConsigna)

% Modificamos la visualizacion segun la opcion escogida
if (estadoConsigna == 1)
    set(handles.q1textFieldConsigna, 'Visible', 'on');
    set(handles.q2textFieldConsigna, 'Visible', 'on');
    set(handles.q1InputConsigna, 'Visible', 'on');
    set(handles.q2InputConsigna, 'Visible', 'on');
    
    set(handles.xPosTextFieldConsigna, 'Visible', 'off');
    set(handles.yPosTextFieldConsigna, 'Visible', 'off');
    set(handles.xPosInputConsigna, 'Visible', 'off');
    set(handles.yPosInputConsigna, 'Visible', 'off');
    
else
    set(handles.q1textFieldConsigna, 'Visible', 'off');
    set(handles.q2textFieldConsigna, 'Visible', 'off');
    set(handles.q1InputConsigna, 'Visible', 'off');
    set(handles.q2InputConsigna, 'Visible', 'off');
    
    set(handles.xPosTextFieldConsigna, 'Visible', 'on');
    set(handles.yPosTextFieldConsigna, 'Visible', 'on');
    set(handles.xPosInputConsigna, 'Visible', 'on');
    set(handles.yPosInputConsigna, 'Visible', 'on');
    
end
 


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


% --- Executes during object creation, after setting all properties.
function uibuttongroup1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in articularButton.
function articularButton_Callback(hObject, eventdata, handles)



% --- Executes on button press in simulateButton.
function simulateButton_Callback(hObject, eventdata, handles)
%Comprobacion de que se ha introducido un valor numerico en las cosignas
estadoConsigna = get(handles.articularButton,'Value');

%ExtremoDelRobot
if(estadoConsigna ~= 1)
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
else
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
    [valorq1, valorq2] = controlArticularFunc(valor1, valor2);
    velq1 = 100; velq2 = 100;
    codigo = 2;
    mensaje = enviarMensajeFunc(codigo, valorq1, velq1, valorq2, velq2);
    %mensaje = [codigo, valorq1, velq1, valorq2, velq2]
    %mensaje = ['2,' num2str(valor1) ',' num2str(vel1) ',' num2str(valor2) ',' num2str(vel2)];
    fprintf(robot, '%s', mensaje) %Send message to Arduino
    
end

%Actualizamos las
