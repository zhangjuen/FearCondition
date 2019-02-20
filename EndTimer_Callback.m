function EndTimer_Callback(~,~,handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
display('Well done, experiment end, press stop');
stop(timerfind); delete(timerfind);
if get(handles.checkbox_VidRed,'Value')
    stop(getappdata(0,'vid'));
    close(getappdata(0,'aviObj'));
end
display('stop recording');
end

