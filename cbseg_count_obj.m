clear ;clc ;close all

% Read the image
I=imread('color_balls1.jpg'); 

tic;
% Converting RGB to HSV colorspace
[h,s,v]=imsplit(rgb2hsv(I));

% Threshold values
h_Min = 67; h_Max = 138; 
s_Min = 0.4; v_Min = 0.8;

% creating mask by "intersection" of hue channel masks using h_Min and h_Max
m=( (h >= h_Min/360) & (h <= h_Max/360) ) & (s >= s_Min ) & (v >= v_Min );

% creating mask by "union" of hue channel masks using h_Min and h_Max
%m=( (h >= h_Min/360) | (h <= h_Max/360) ) & (s >= s_Min ) & (v >= v_Min );

% Morphological openning of mask "m"
m=imopen(m,strel('disk',8));

% Object's Area smaller than 1000 pixels are removed
Area = 1000;
Mask = bwareaopen(m,Area);

% Connected-component labeling
cc=bwconncomp(Mask,4);
L1=labelmatrix(cc);
C1=label2rgb(L1);

% Creating a masked color image
J=I; J(~repmat(Mask,[1,1,3]))=0;
toc;

% Creating String for title
str = sprintf('Masked color Image\n No. of objects : %d',cc.NumObjects);

% Visualizations
colorcloud(I,'rgb');
colorcloud(I,'hsv');
colorcloud(J,'rgb');
colorcloud(J,'hsv');

figure;
subplot(221); imshow(I);    title('Original Image')
subplot(222); imagesc(L1);  title('Connected-component labeled Image'); colorbar
subplot(223); imshow(J);    title(str)
subplot(224); imshow(Mask); title('Binary Mask Image')
clear