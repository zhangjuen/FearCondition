saveVideoTag = 1;
videoRIO = [0 0 300 300];
vid = videoinput('winvideo', 1, 'MJPG_640x480');
src = getselectedsource(vid);
vid.FramesPerTrigger = inf;
if saveVideoTag == 1
    vid.LoggingMode = 'disk&memory';
    videoFileName = 'test.avi';
    aviObj = VideoWriter(videoFileName);
    aviObj.FrameRate = 10;
    vid.DiskLogger = aviObj;    
end
vid.ROIPosition = videoRIO;   
start(vid);
FrameNow = peekdata(vid,1);
flushdata(vid);
stop(vid);