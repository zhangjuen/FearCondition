function LaserOffTimer_Callback(~,~,handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
fwrite(handles.serial_1,getappdata(0,'LaserPin')+100);%laser off
end

