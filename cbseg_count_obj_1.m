clear ;clc ;close all

% Read the image
I=imread('color_balls1.jpg');

se=load('se.mat');
se=se.se;

tic;
% Converting RGB to HSV colorspace
[h,s,v]=RGB2HSV(I);

% Threshold values
h_Min = 67; h_Max = 138; 
s_Min = 0.4; v_Min = 0.8;

% creating mask by "intersection" of hue channel masks using h_Min and h_Max
m=( (h >= h_Min/360) & (h <= h_Max/360) ) & (s >= s_Min ) & (v >= v_Min );

% creating mask by "union" of hue channel masks using h_Min and h_Max
%m=( (h >= h_Min/360) | (h <= h_Max/360) ) & (s >= s_Min ) & (v >= v_Min );

% Morphological openning of mask "m"
m=morph('dilate',morph('erode',m,se),se);

% Connected-component labeling
[L, Numobjects] = connected4(m);

% Object's Area smaller than 1000 pixels are removed
Area = 1000;
N=0; Mask=zeros(size(m));

for k=1:Numobjects
    h=L==k;
    if sum(h,'all')>Area
        N=N+1;
        Mask=Mask|h;
    end
end

% Creating a masked color image
J=I; J(~repmat(Mask,[1,1,3]))=0;
toc;

% Creating String for title
str = sprintf('Masked color Image\n No. of objects : %d',N);

% Visualizations
colorcloud(I,'rgb');
colorcloud(I,'hsv');
colorcloud(J,'rgb');
colorcloud(J,'hsv');

figure;
subplot(221); imshow(I);    title('Original Image')
subplot(222); imagesc(L);   title('Connected-component labeled Image'); colorbar
subplot(223); imshow(J);    title(str)
subplot(224); imshow(Mask); title('Binary Mask Image')
clear