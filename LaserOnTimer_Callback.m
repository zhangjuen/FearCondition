function LaserOnTimer_Callback(~,~,handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
fwrite(handles.serial_1,getappdata(0,'LaserPin')+200);%laser on, flash mode
end

