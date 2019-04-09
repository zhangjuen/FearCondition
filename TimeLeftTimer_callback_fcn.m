function TimeLeftTimer_callback_fcn(~, ~, handles)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
set(handles.text_timeLeft,'string',max(0,str2double(get(handles.text_timeLeft,'string'))-1));

end

