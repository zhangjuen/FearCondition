function VideoTimer_Callback(~,~,handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
try 
    FrameNow = peekdata(getappdata(0,'vid'),1);    
    flushdata(getappdata(0,'vid'));    
    writeVideo(getappdata(0,'aviObj'),FrameNow);   
catch
    disp('miss one frame');
%     size(FrameNow)
end


end

