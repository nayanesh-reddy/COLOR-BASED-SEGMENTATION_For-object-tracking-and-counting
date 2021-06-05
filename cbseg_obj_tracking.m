clear; clc; close

%% Threshold values
h_Min = 194; h_Max = 212; 
s_Min = 0.5; v_Min = 0.3;

%% Accessing webcam
cam=webcam;
I=snapshot(cam);
sz=size(I);

%% Gaussian filter for blurring (Spatial domain)
gaussian_filter = fspecial('gaussian',20,5);

%% Structing Element
se=strel('disk',8);

%% Initial variables
f=1;
LM=zeros(sz);

%%
while 1
    
    % Wait for key press (sec)   
    pause(0.00001)
    % Get character from keyboard
    key = get(gcf,'currentcharacter');
    
    % Break while loop if "SPACE" is pressed
    if key==' '; break; end
    
    % Take a snapshot using webcam
    I=snapshot(cam);
    I=fliplr(I);      % Mirrored image
    
    % Applying Guassian filter
    I1=imfilter(I, gaussian_filter, 'same');
    
    % Converting RGB to HSV colorspace
    [h,s,v]=imsplit(rgb2hsv(I1));

    % creating mask by "intersection" of hue channel masks using h_Min and h_Max
    m=( (h >= h_Min/360) & (h <= h_Max/360) ) & (s >= s_Min ) & (v >= v_Min );

    % creating mask by "union" of hue channel masks using h_Min and h_Max
    %m=( (h >= h_Min/360) | (h <= h_Max/360) ) & (s >= s_Min ) & (v >= v_Min );

    % Morphological opening with structing element 'se'
    m=imopen(m,se);
    
    % Find Centroid of object with max Area
    rprops=regionprops(m,'Centroid','Area');
    rprops=struct2cell(rprops);
    area=cell2mat(rprops(1,:));
    idx=find(area==max(area));
    centroid=cell2struct(rprops(2,idx),'Centroid');
    
    %% Drawing the tracked path
    
    if isempty(centroid)
       imshowpair(I,uint8(m),'montage')
       LM=zeros(sz);       
       f=1;
       
    elseif ~isempty(centroid) && f==1
        pts(1,:)=centroid.Centroid;
        x_prev=pts(1); y_prev=pts(2);        
        f=0;
        
    else   
        % Current centroid co-ordinates
        pts(1,:)=centroid.Centroid;
        x=pts(1); y=pts(2);         
        
        % Masked Color Image 
        mask_I=I;
        mask_I(repmat(m==0,[1,1,3]))=0;
        
        % Drawing the line ( Bresenham Algorithm )
        LM = line_draw('bresenham',LM,round([x_prev y_prev]), round([x y]),[255;0;0],[255;0;0]);
        
        % assign Current centroid co-ordinates to previous Centroid co-ordinates 
        x_prev=x; y_prev=y;   
        
        I(repmat(rgb2gray(LM)>0,[1,1,3]))=0;
        
        % Showing two images side by side
        imshowpair(I+uint8(LM), mask_I+uint8(LM),'montage')
    end
end
clear;clc