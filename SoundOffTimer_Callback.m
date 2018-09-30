function SoundOffTimer_Callback(~,~,handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
fwrite(handles.serial_1,getappdata(0,'SoundPin')+4+100);%buzzer off mode

if get(handles.checkbox_VidRed,'value')
    aviObj = getappdata(0,'aviObj');
    SoundFrame = getappdata(0,'SoundFrame');
    SoundFrame(str2double(get(handles.text_trialNow,'string')),2) = aviObj.FrameCount;
    setappdata(0,'SoundFrame',SoundFrame);
end
end

