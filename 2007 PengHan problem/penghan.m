%penghan.m
%2007-04-12 Peng Han's cell count problem: solved by MATLAB image processing toolbox.

clear
close all
imview close all

I=imread('50-2_c2.jpg');	%set file name(1a.jpg) here.
Ix=I(:,:,3);    %convert to mono color figure--using dimension one.
figure, imshow(Ix);	%Fig.1

background = imopen(Ix,strel('disk',30)); %the radius value(30) can be adjusted here.
figure, surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
set(gca,'ydir','reverse');	%Fig.2

I2=imsubtract(Ix,background);
I3=imadjust(I2);
figure, imshow(I3);	%Fig.3

level = graythresh(I3)
bw = im2bw(I3,level);	%the threshold can be adjusted here.
figure, imshow(bw);	%Fig.4. generate binary figure.

[labeled,numObjects] = bwlabel(bw,4);   %using 4-conncetion (not 8-connection)
numObjects	%the original identified cell number.

celldata = regionprops(labeled,'basic');
imview(labeled) 	%for manual check
area=[celldata.Area];
figure, hist(area,50)	%Fig.5. the bin number(50) can be adjusted here.
sizer=size(area);
for i=1:sizer(2)
areas(i,1)=i;
areas(i,2)=area(i);
end
sorted=sortrows(areas,2)	%for manual check

areaThreshold=30;	%set threshold for valid cell area(>=200) here.
i=1;
while sorted(i,2)<areaThreshold
i=i+1;
end
numObjects_corrected=sizer(2)-i+1	%the corrected cell number
