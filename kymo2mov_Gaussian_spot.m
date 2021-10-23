%22nd June 2020
%This program will take a kymograph as a text image and split each line and convert into a
%movie. Currently the program is setup for time on the y axis
%This allows for subsequent analysis using trackmate to thread catastrophic
%collapse data. 
%23 Oct 2021
%I've changed this version to create a Gaussian spot representation instead
%of a single pixel
%--Defaults for setup--
clearvars; %clear workspace
cmap = gray(256); %this is the colormap used to create the movie frames
%--Loadfile--
[filename,pathname,FilterIndex] = uigetfile('*.txt', 'MultiSelect', 'on'); %Open get file dialog
cd(pathname); %move to file path, this will drop the written file into the same folder
delimiterIn = ' '; %ImageJ log output puts spaces between columns 
headerlinesIn = 1; %This tells the importer that the top line is a header
data=(importdata(filename,delimiterIn,headerlinesIn)); %Insert file name here for vertical kymograph
Q = data.data(:,1);
%--Check orientation of kymograph--
%If needed a checkbox could be used to set up two different scenarios
%--Measure kymograph and position data towards centre--
Q = Q-mean(Q);
Q = Q+abs(min(Q))+mean(Q);

min_val = min(Q);
max_val = max(Q);
lngth = length(Q);
wdth = (1:max_val - min_val+20);

%---Setup video write---
filename =  [pathname filename '_kymograph.avi']; %create filename for output
    v = VideoWriter(filename,'Uncompressed AVI'); %setup videoname
    open(v); %open file for writing
    colormap(gray);%grayscale image is preferred
    
%--Save each line as a new movie frame--
conv = waitbar(0,'Converting data...'); %display timebar
for slice=1:lngth; %change to wdth if time is on the x-axis
waitbar(slice/lngth,conv); %display timebar
framestep =1;
while framestep < size(wdth,2);
    I(:,framestep)= 1*exp(-0.5*((framestep-Q(slice))/1).^2-0.5*((wdth-10)/1).^2); %This constructs a line of a calculated Gaussian 
    %centred on the value of Q and puts it in the middle of the frame (i.e. 10)
    framestep = framestep +1;
end

writeVideo(v,mat2gray(I)); %Write each frame to video

end
%--Write movie to disk--
close(conv); %close timebar
bar = waitbar(0.9,'Saving data...'); %open new timebar
    close(v); %close file
close(bar); %close timebar