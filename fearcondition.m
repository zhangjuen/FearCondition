function varargout = fearcondition(varargin)
% FEARCONDITION M-file for fearcondition.fig
%      FEARCONDITION, by itself, creates a new FEARCONDITION or raises the existing
%      singleton*.
%
%      H = FEARCONDITION returns the handle to a new FEARCONDITION or the handle to
%      the existing singleton*.
%
%      FEARCONDITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FEARCONDITION.M with the given input arguments.
%
%      FEARCONDITION('Property','Value',...) creates a new FEARCONDITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fearcondition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fearcondition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fearcondition

% Last Modified by GUIDE v2.5 19-Feb-2019 14:40:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fearcondition_OpeningFcn, ...
                   'gui_OutputFcn',  @fearcondition_OutputFcn, ...
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


% --- Executes just before fearcondition is made visible.
function fearcondition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fearcondition (see VARARGIN)


%%%delete all previous appdata
% appdata = get(0,'ApplicationData');
% fns = fieldnames(appdata);
% for ii = 1:numel(fns)
%   rmappdata(0,fns{ii});
% end
setappdata(0,'SoundPin',11);
setappdata(0,'LEDCuePin',49);
setappdata(0,'LaserPin',52);
setappdata(0,'ShockPin',50);
% Choose default command line output for fearcondition
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fearcondition wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fearcondition_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;


% --- Executes on button press in pushbutton_start.
function pushbutton_start_Callback(hObject, eventdata, handles)
 display('start');
 set(handles.pushbutton_stop,'Visible','on');
 set(handles.pushbutton_start,'Visible','off');
 ts = timerfind;
if ~isempty(ts)
stop(timerfind);
delete(timerfind);
end
set(handles.text_trialNow,'string',0)
%arduino Pin define
setappdata(0,'SoundPin',11);
setappdata(0,'LEDCuePin',49);
setappdata(0,'LaserPin',52);
setappdata(0,'ShockPin',50);

setappdata(0,'SoundFrame',zeros(str2double(get(handles.edit_TrialNum,'string')),2));


TrialEnd =  str2double(get(handles.edit_TrialEnd,'string'));
handles.SoundD =  str2double(get(handles.edit_SoundDuration,'string'));
handles.ShockD =  str2double(get(handles.edit_ShockDuration,'string'));
handles.shockDelay =  str2double(get(handles.edit_shockDelay,'string'));
LaserPreSound = str2double(get(handles.edit_LaserPreSound,'string'));
StartDelay = str2double(get(handles.edit_startDelay,'string'));

videoFR = 20;
handles.videoFR = videoFR;
%timer define
TrialStartTimer = timer('TimerFcn',{@TrialStartTimer_callback_fcn,handles},'Period',0.1,'StartDelay',StartDelay*get(handles.radiobutton_startDelay,'Value'));
setappdata(0,'TrialStartTimer',TrialStartTimer);
TrialRestartTimer = timer('TimerFcn',{@TrialRestartTimer_callback_fcn,handles},'Period',0.1,'StartDelay',TrialEnd);
setappdata(0,'TrialRestartTimer',TrialRestartTimer);
LaserOnTimer = timer('TimerFcn',{@LaserOnTimer_Callback,handles},'Period',0.1,'StartDelay',0);
setappdata(0,'LaserOnTimer',LaserOnTimer);
LaserOffTimer = timer('TimerFcn',{@LaserOffTimer_Callback,handles},'Period',0.1,'StartDelay',handles.SoundD+LaserPreSound);%sound off; laser off;
setappdata(0,'LaserOffTimer',LaserOffTimer);
SoundOnTimer = timer('TimerFcn',{@SoundOnTimer_Callback,handles},'Period',0.1,'StartDelay',LaserPreSound);
setappdata(0,'SoundOnTimer',SoundOnTimer);
SoundOffTimer = timer('TimerFcn',{@SoundOffTimer_Callback,handles},'Period',0.1,'StartDelay',handles.SoundD+LaserPreSound);
setappdata(0,'SoundOffTimer',SoundOffTimer);
ShockOnTimer = timer('TimerFcn',{@ShockOnTimer_Callback,handles},'Period',0.1,'StartDelay',handles.SoundD+LaserPreSound+handles.shockDelay);
setappdata(0,'ShockOnTimer',ShockOnTimer);
ShockOffTimer = timer('TimerFcn',{@ShockOffTimer_Callback,handles},'Period',0.1,'StartDelay',handles.SoundD+LaserPreSound+handles.shockDelay+handles.ShockD);
setappdata(0,'ShockOffTimer',ShockOffTimer);
VideoTimer = timer('TimerFcn',{@VideoTimer_Callback,handles},'Period',1/videoFR,'StartDelay',0,'ExecutionMode','fixedRate');
setappdata(0,'VideoTimer',VideoTimer);
EndTimer = timer('TimerFcn',{@EndTimer_Callback,handles},'Period',0.1,'StartDelay',60);
setappdata(0,'EndTimer',EndTimer);



if get(handles.checkbox_VidRed,'Value')    
    start(getappdata(0,'vid'));      
%     src = getselectedsource(vid);
%     src.FrameRate = videoFR;    
   
    DataFolderPath = getappdata(0,'DataFolderPath');
    if isempty(DataFolderPath)
        DataFolderPath = 'G:\data';
    end
    DataFolderPath = uigetdir(DataFolderPath,'Select the folder for data');
    if ~DataFolderPath
        return;
    end
    fileTime = datestr(datetime());
    fileTime(fileTime==':') = '_';
    fileTime(fileTime==' ') = '_';
    videoFileName = [DataFolderPath,'\',fileTime, '.avi'];
    aviObj = VideoWriter(videoFileName);
    aviObj.FrameRate = videoFR;
    open(aviObj);
    setappdata(0,'aviObj',aviObj);    
    start(getappdata(0,'VideoTimer'));
    setappdata(0,'DataFolderPath',DataFolderPath);
end

start(TrialStartTimer);

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% hObject    handle to pushbutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_TrialNum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TrialNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TrialNum as text
%        str2double(get(hObject,'String')) returns contents of edit_TrialNum as a double


% --- Executes during object creation, after setting all properties.
function edit_TrialNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TrialNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_TrialEnd_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TrialEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TrialEnd as text
%        str2double(get(hObject,'String')) returns contents of edit_TrialEnd as a double


% --- Executes during object creation, after setting all properties.
function edit_TrialEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TrialEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MinInterval_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MinInterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MinInterval as text
%        str2double(get(hObject,'String')) returns contents of edit_MinInterval as a double


% --- Executes during object creation, after setting all properties.
function edit_MinInterval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MinInterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ShockDuration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ShockDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ShockDuration as text
%        str2double(get(hObject,'String')) returns contents of edit_ShockDuration as a double


% --- Executes during object creation, after setting all properties.
function edit_ShockDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ShockDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_SoundDuration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_SoundDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_SoundDuration as text
%        str2double(get(hObject,'String')) returns contents of edit_SoundDuration as a double


% --- Executes during object creation, after setting all properties.
function edit_SoundDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_SoundDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_stop.
function pushbutton_stop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.pushbutton_stop,'Visible','off');
set(handles.pushbutton_start,'Visible','on');
ts = timerfind;
if ~isempty(ts)
stop(timerfind); 
delete(timerfind);
end

Config.FCtrialData = get(handles.uitable_trialData,'Data');
% whos('FCtrialData')
Config.ShockMode = get(handles.checkbox_shockMode,'value');
Config.LaserMode = get(handles.checkbox_laserMode,'value');
Config.VidRed = get(handles.checkbox_VidRed,'value');
matlabData.Config = Config;
matlabData.SoundFrame = getappdata(0,'SoundFrame');
matlabData.videoFR = handles.videoFR;

DataFolderPath = getappdata(0,'DataFolderPath');
if ~isempty(DataFolderPath)
    fileTime = datestr(datetime());
    fileTime(fileTime==':') = '_';
    fileTime(fileTime==' ') = '_';
    str = [DataFolderPath,'\',fileTime, '.mat'];    
    save(str,'matlabData');    
end

try
fwrite(handles.serial_1,getappdata(0,'LaserPin')+100);%laser off
fwrite(handles.serial_1,getappdata(0,'SoundPin')+4+100);%buzzer off mode
fwrite(handles.serial_1,getappdata(0,'ShockPin')+100);%Shock off
fwrite(handles.serial_1,getappdata(0,'LEDCuePin')+100);
catch
end
display('stopped');

if get(handles.checkbox_VidRed,'Value')
    stop(getappdata(0,'vid'));
    close(getappdata(0,'aviObj'));
end

guidata(hObject, handles);



function edit_MaxInterval_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MaxInterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MaxInterval as text
%        str2double(get(hObject,'String')) returns contents of edit_MaxInterval as a double


% --- Executes during object creation, after setting all properties.
function edit_MaxInterval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MaxInterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







function edit_shockDelay_Callback(hObject, eventdata, handles)
% hObject    handle to edit_shockDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_shockDelay as text
%        str2double(get(hObject,'String')) returns contents of edit_shockDelay as a double


% --- Executes during object creation, after setting all properties.
function edit_shockDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_shockDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_com.
function radiobutton_com_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')    
    com = ['COM',get(handles.edit_com,'string')];
    try
        delete(instrfind('Port',com));
        handles.serial_1 = serial(com);
        set(handles.serial_1,'BaudRate',9600);
        fopen(handles.serial_1);
        str = [com,':Connected!'];
        disp(str);
    catch
        msgbox('Check Arduino');
        set(hObject,'value',0)
        return;
    end
else
    try
    com = ['COM',get(handles.edit_com,'string')];
    fclose(handles.serial_1);
    delete(handles.serial_1);
    str = [com,':Disconnected!'];
    disp(str);
    catch
    end
end


handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


function edit_com_Callback(hObject, eventdata, handles)
% hObject    handle to edit_com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_com as text
%        str2double(get(hObject,'String')) returns contents of edit_com as a double


% --- Executes during object creation, after setting all properties.
function edit_com_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_startDelay.
function radiobutton_startDelay_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_startDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_startDelay



function edit_startDelay_Callback(hObject, eventdata, handles)
% hObject    handle to edit_startDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_startDelay as text
%        str2double(get(hObject,'String')) returns contents of edit_startDelay as a double


% --- Executes during object creation, after setting all properties.
function edit_startDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_startDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_laserMode.
function checkbox_laserMode_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_laserMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_laserMode


% --- Executes on button press in checkbox_shockMode.
function checkbox_shockMode_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_shockMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_shockMode


% --- Executes on button press in checkbox_VidPre.
function checkbox_VidPre_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_VidPre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_VidPre
if get(hObject,'Value')
    if ~get(handles.checkbox_VidRed,'Value')    
        vid = videoinput('winvideo', 1, 'MJPG_640x480');
        setappdata(0,'vid',vid);
    end
    preview(getappdata(0,'vid'));
else
    stoppreview(getappdata(0,'vid'));
    if ~get(handles.checkbox_VidRed,'Value') 
        delete(getappdata(0,'vid'));
        delete(imaqfind);
    end
end


% --- Executes on button press in checkbox_VidRed.
function checkbox_VidRed_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_VidRed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_VidRed
if get(handles.checkbox_VidRed,'Value')
    if ~get(handles.checkbox_VidPre,'Value')
        vid = videoinput('winvideo', 1, 'MJPG_640x480');
    else
        vid = getappdata(0,'vid');
    end    
    vid.FramesPerTrigger = inf;
    vid.ReturnedColorspace = 'rgb';
    vid.LoggingMode = 'memory';
%     vid.DiskLogger = aviObj;
    setappdata(0,'vid',vid);
elseif ~get(handles.checkbox_VidPre,'Value')
    stop(getappdata(0,'vid'));
    delete(getappdata(0,'vid'));
    delete(imaqfind);
end


% --- Executes when entered data in editable cell(s) in uitable_trialData.
function uitable_trialData_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_trialData (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
% FCtrialData = getappdata(0,'FCtrialData');
% FCtrialData(eventdata.Indices(1),eventdata.Indices(2)) = eventdata.NewData;
% setappdata(0,'FCtrialData',FCtrialData);


% --- Executes on button press in pushbutton_load.
function pushbutton_load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ConfigName,ConfigFolderPath,index] = uigetfile('Select the Config File');
if index  
    try
    Config = importdata([ConfigFolderPath,ConfigName]);
    set(handles.uitable_trialData,'Data',Config.FCtrialData);
    set(handles.checkbox_shockMode,'value',Config.ShockMode);
    set(handles.checkbox_laserMode,'value',Config.LaserMode);
    set(handles.checkbox_VidRed,'value',Config.VidRed);
    set(handles.checkbox_toneMode,'value',Config.ToneMode);
    set(handles.edit_TrialEnd,'string',Config.TrialEnd);
    set(handles.edit_SoundDuration,'string',Config.SoundD);
    set(handles.edit_ShockDuration,'string',Config.ShockD);
    set(handles.edit_shockDelay,'string',Config.shockDelay);
    set(handles.edit_LaserPreSound,'string',Config.LaserPreSound);
    set(handles.edit_startDelay,'string',Config.StartDelay);
    set(handles.radiobutton_startDelay,'Value',Config.StartDelayMode);
    set(handles.edit_TrialNum,'string',Config.TrialNum);
    set(handles.edit_MinInterval,'string',Config.MinInterval);
    set(handles.edit_MaxInterval,'string',Config.MaxInterval);
    catch 
        display('Part of the configs are not assigned, probably is because they are not exist in the saved config. Edit manually, then save again.')
    end
end
setappdata(0,'FC_config',Config);

% --- Executes on button press in pushbutton_saveConfig.
function pushbutton_saveConfig_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_saveConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Config.FCtrialData = get(handles.uitable_trialData,'Data');
% whos('FCtrialData')
Config.ShockMode = get(handles.checkbox_shockMode,'value');
Config.LaserMode = get(handles.checkbox_laserMode,'value');
Config.VidRed = get(handles.checkbox_VidRed,'value');
Config.ToneMode = get(handles.checkbox_toneMode,'value');
Config.TrialEnd =  str2double(get(handles.edit_TrialEnd,'string'));
Config.SoundD =  str2double(get(handles.edit_SoundDuration,'string'));
Config.ShockD =  str2double(get(handles.edit_ShockDuration,'string'));
Config.shockDelay =  str2double(get(handles.edit_shockDelay,'string'));
Config.LaserPreSound = str2double(get(handles.edit_LaserPreSound,'string'));
Config.StartDelay = str2double(get(handles.edit_startDelay,'string'));
Config.StartDelayMode = get(handles.radiobutton_startDelay,'Value');

Config.TrialNum = str2double(get(handles.edit_TrialNum,'string'));
Config.MinInterval = str2double(get(handles.edit_MinInterval,'string'));
Config.MaxInterval = str2double(get(handles.edit_MaxInterval,'string')); 

setappdata(0,'FC_config',Config);
[FileName,PathName,Index] = uiputfile('*.mat');
if Index
    str = [PathName, FileName];
    save(str,'Config');
    display('Config read and saved!');
end


% --- Executes during object creation, after setting all properties.
function pushbutton_load_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pushbutton_saveConfig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_saveConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in radiobutton_laserTest.
function radiobutton_laserTest_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_laserTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_laserTest
if get(hObject,'Value') 
fwrite(handles.serial_1,getappdata(0,'LaserPin')+200);%laser on, flash mode
else
    fwrite(handles.serial_1,getappdata(0,'LaserPin')+100);%laser on, flash mode
end


% --- Executes on button press in checkbox_toneMode.
function checkbox_toneMode_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_toneMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_toneMode



function edit_LaserPreSound_Callback(hObject, eventdata, handles)
% hObject    handle to edit_LaserPreSound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_LaserPreSound as text
%        str2double(get(hObject,'String')) returns contents of edit_LaserPreSound as a double


% --- Executes during object creation, after setting all properties.
function edit_LaserPreSound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_LaserPreSound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
