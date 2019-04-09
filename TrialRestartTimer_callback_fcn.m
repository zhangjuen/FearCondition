function [ output_args ] = TrialRestartTimer_callback_fcn(~,~, handles )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

fwrite(handles.serial_1,getappdata(0,'LEDCuePin')+100);

if str2double(get(handles.edit_TrialNum,'string'))>str2double(get(handles.text_trialNow,'string'))
    MinInterval = str2double(get(handles.edit_MinInterval,'string'));
    MaxInterval = str2double(get(handles.edit_MaxInterval,'string')); 
    
    DelayNow = round(rand(1)*(MaxInterval-MinInterval))+MinInterval;
    set(getappdata(0,'TrialStartTimer'),'StartDelay',DelayNow);
    start(getappdata(0,'TrialStartTimer'));   
    NextTrial = str2double(get(handles.text_trialNow,'string'))+1;
    disp(['Next Trial: ',num2str(NextTrial), '   Start Delay:', num2str(DelayNow)]);
    set(handles.text_timeLeft,'string',DelayNow);
else
    display('Well done, wait for end 60s delay');
    start(getappdata(0,'EndTimer'));
end

end

