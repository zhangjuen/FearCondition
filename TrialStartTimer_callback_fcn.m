function TrialStartTimer_callback_fcn(~, ~, handles)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if str2double(get(handles.edit_TrialNum,'string'))>str2double(get(handles.text_trialNow,'string'))
    trialNow = str2double(get(handles.text_trialNow,'string'))+1;
    set(handles.text_trialNow,'string',trialNow);
    
    FCtrialData = get(handles.uitable_trialData,'Data');
    fwrite(handles.serial_1,getappdata(0,'LEDCuePin'));

    
    if get(handles.checkbox_toneMode,'value')
        start(getappdata(0,'SoundOnTimer'));
        start(getappdata(0,'SoundOffTimer'));
    end
    start(getappdata(0,'TrialRestartTimer'));
    if get(handles.checkbox_laserMode,'value')&&FCtrialData(trialNow,2)
        start(getappdata(0,'LaserOnTimer'));
        start(getappdata(0,'LaserOffTimer'));
    end    
    if get(handles.checkbox_shockMode,'value')&&FCtrialData(trialNow,1)
        start(getappdata(0,'ShockOnTimer'));
        start(getappdata(0,'ShockOffTimer'));
    end   
end%trial end
end

