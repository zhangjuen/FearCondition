function ShockOnTimer_Callback(~,~,handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

fwrite(handles.serial_1,getappdata(0,'ShockPin'));%Shock on

end

