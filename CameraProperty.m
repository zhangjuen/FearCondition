function varargout = CameraProperty(varargin)
% CAMERAPROPERTY MATLAB code for CameraProperty.fig
%      CAMERAPROPERTY, by itself, creates a new CAMERAPROPERTY or raises the existing
%      singleton*.
%
%      H = CAMERAPROPERTY returns the handle to a new CAMERAPROPERTY or the handle to
%      the existing singleton*.
%
%      CAMERAPROPERTY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAMERAPROPERTY.M with the given input arguments.
%
%      CAMERAPROPERTY('Property','Value',...) creates a new CAMERAPROPERTY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CameraProperty_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CameraProperty_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CameraProperty

% Last Modified by GUIDE v2.5 10-Jul-2019 12:20:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CameraProperty_OpeningFcn, ...
                   'gui_OutputFcn',  @CameraProperty_OutputFcn, ...
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


% --- Executes just before CameraProperty is made visible.
function CameraProperty_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CameraProperty (see VARARGIN)

% Choose default command line output for CameraProperty
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CameraProperty wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CameraProperty_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
function [ output_args ] = CameraPropertySet( src,vid,Action )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
switch Action
    case 'FocusIncre'
        src.FocusMode = 'manual'; 
        try
            src.Focus = src.Focus+1;
        catch
            display('Maximum Focus');
        end
    case 'FocusDecre'
        src.FocusMode = 'manual'; 
        if src.Focus>0
            src.Focus = src.Focus-1;
        else
            display('Minimum Focus');
        end
    case 'ZoomIncre'
        try
            src.Zoom = src.Zoom+1;
        catch
            display('Maximum Zoom');
        end
    case 'ZoomDecre'
        try
        src.Zoom = src.Zoom-1;
        catch
            display('Minimum Zoom');
        end
    case 'MoveLeft'
        ROIPosition = vid.ROIPosition;
        ROIPosition(1) = ROIPosition(1)-5;
        try
        vid.ROIPosition = ROIPosition;
        catch
            display('Left Limit');
        end
    case 'MoveRight'
        ROIPosition = vid.ROIPosition;
        ROIPosition(1) = ROIPosition(1)+5;
        try
        vid.ROIPosition = ROIPosition;
        catch
            display('Right Limit');
        end
    case 'MoveUp'
        ROIPosition = vid.ROIPosition;
        ROIPosition(2) = ROIPosition(2)-5;
        try
        vid.ROIPosition = ROIPosition;
        catch
            display('Up Limit');
        end
    case 'MoveDown'
        ROIPosition = vid.ROIPosition;
        ROIPosition(2) = ROIPosition(2)+5;
        try
        vid.ROIPosition = ROIPosition;
        catch
            display('Bottom Limit');
        end
    case 'SelectROI'
%         stoppreview(vid);
        frame = getsnapshot(vid);
        f = figure;
        imshow(frame);
        h = imrect();
        position = wait(h);
        vid.ROIPosition = floor(position);
        close(f)
%         preview(vid);  
    case 'ResetROI'
        VideoFormat = vid.VideoFormat;
        p = strfind(VideoFormat,'_');
        q = strfind(VideoFormat,'x');
        Width = str2num(VideoFormat(p+1:q-1));
        Height = str2num(VideoFormat(q+1:end));
        vid.ROIPosition = [0 0 Width Height];
end
% ROIPosition = vid.ROIPosition



% --- Executes on button press in pushbutton_FocusIncre.
function pushbutton_FocusIncre_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FocusIncre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CameraPropertySet( getappdata(0,'src'),getappdata(0,'vid'), 'FocusIncre');

% --- Executes on button press in pushbutton_FocusDecr.
function pushbutton_FocusDecr_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FocusDecr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CameraPropertySet( getappdata(0,'src'),getappdata(0,'vid'), 'FocusDecre');

% --- Executes on button press in pushbutton_ZoomIncr.
function pushbutton_ZoomIncr_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ZoomIncr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CameraPropertySet( getappdata(0,'src'),getappdata(0,'vid'), 'ZoomIncre');

% --- Executes on button press in pushbutton_ZoomDecre.
function pushbutton_ZoomDecre_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ZoomDecre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CameraPropertySet( getappdata(0,'src'),getappdata(0,'vid'), 'ZoomDecre');

% --- Executes on button press in pushbutton_MoveLeft.
function pushbutton_MoveLeft_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MoveLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CameraPropertySet( getappdata(0,'src'),getappdata(0,'vid'), 'MoveLeft');


% --- Executes on button press in pushbutton_MoveRight.
function pushbutton_MoveRight_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MoveRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CameraPropertySet( getappdata(0,'src'),getappdata(0,'vid'), 'MoveRight');


% --- Executes on button press in pushbutton_MoveUp.
function pushbutton_MoveUp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MoveUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CameraPropertySet( getappdata(0,'src'),getappdata(0,'vid'), 'MoveUp');


% --- Executes on button press in pushbutton_MoveDown.
function pushbutton_MoveDown_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MoveDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CameraPropertySet( getappdata(0,'src'),getappdata(0,'vid'), 'MoveDown');


% --- Executes on button press in pushbutton_SelectROI.
function pushbutton_SelectROI_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_SelectROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CameraPropertySet( getappdata(0,'src'),getappdata(0,'vid'), 'SelectROI');


% --- Executes on button press in pushbutton_ResetROI.
function pushbutton_ResetROI_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ResetROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CameraPropertySet( getappdata(0,'src'),getappdata(0,'vid'), 'ResetROI');
