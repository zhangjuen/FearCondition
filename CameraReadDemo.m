%rmappdata(0,'vid');
delete(imaqfind);
clc;clear;
vid = videoinput('winvideo', 2, 'MJPG_640x480');
    src = getselectedsource(vid);
%     src.FrameRate = 10;
vid.FramesPerTrigger = inf;
    vid.TriggerRepeat = 0;
    vid.FrameGrabInterval  = 2;
    vid.LoggingMode = 'disk&memory';
    vid.ReturnedColorspace = 'rgb';
    DataFolderPath = getappdata(0,'DataFolderPath');
    if isempty(DataFolderPath)
        DataFolderPath = 'G:\data';
    end
    DataFolderPath = uigetdir(DataFolderPath,'Select the folder for data');
    if ~DataFolderPath
        return;
    end
    fileTime = datestr(datetime());
    fileTime(fileTime==':') = '_';
    fileTime(fileTime==' ') = '_';
    videoFileName = [DataFolderPath,'\',fileTime, '.avi'];
    aviObj = VideoWriter(videoFileName);
%     aviObj.FrameRate = 20;
    vid.DiskLogger = aviObj;
    setappdata(0,'vid',vid);
    tic;
    start(vid);