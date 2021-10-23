%22nd June 2020
%This program will take a kymograph and split each line and convert into a
%movie. Currently the program is setup for time on the y axis
%This allows for subsequent analysis using trackmate to thread catastrophic
%collapse data.
%--Defaults for setup--
clearvars; %clear workspace
cmap = gray(256); %this is the colormap used to create the movie frames
%--Loadfile--
[filename,pathname,FilterIndex] = uigetfile('*.txt', 'MultiSelect', 'on'); %Open get file dialog
cd(pathname); %move to file path, this will drop the written file into the same folder
delimiter = ' '; %no significance in this program
Q=single(importdata(filename)); %Insert file name here for vertical kymograph
%--Check orientation of kymograph--
%If needed a checkbox could be used to set up two different scenarios
%--Measure kymograph--
wdth = size(Q,2); % array size in x
lngth = size(Q,1); % array size in y
%--Save each line as a new movie frame--
conv = waitbar(0,'Converting data...'); %display timebar
for slice=1:lngth; %change to wdth if time is on the x-axis
img = Q(slice,1:wdth);%Q(1:lngth,slice); For time on x axis
waitbar(slice/lngth,conv); %display timebar
I = uint16(img); %Convert the slice into an unsigned 16-bit integer
F(:,:,1,slice) = I; %For the output format (MJ2), the colons mean each frame has the contents of I, 
%the 1 is format and slice is the frame number. This produces a 4D array that appears as a list   
end
%--Write movie to disk--
close(conv); %close timebar
bar = waitbar(0.9,'Saving data...'); %open new timebar
filename =  [pathname filename '_kymograph.mj2']; %create filename for output
    v = VideoWriter(filename,'Archival'); %setup videoname
    open(v); %open file for writing
    writeVideo(v,F); %write to file 'v' data 'F'
    close(v); %close file
close(bar); %close timebar