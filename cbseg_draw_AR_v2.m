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
f=1; flag=0;
color = [255,255,255];
Z=uint8(zeros(sz));
LM=Z; D=Z; lm=Z;

%%
while 1
    
    % Wait for key press (sec)   
    pause(0.00001)
    % Get character from keyboard
    key = get(gcf,'currentcharacter');
    
    % Break while loop if "SPACE" is pressed
    if key==' '
        % Show Final Canvas "D"
        %D(D==0 & ~(rgb2gray(D)>0))=255; % For white background
        figure(2);imshow(D,'initialmagnification','fit')
        break;
        
    % Fill the shape with color if "f" is pressed
    elseif key=='f'
        [r,g,b]=imsplit(LM);
        r=imfill(r,'holes'); g=imfill(g,'holes'); b=imfill(b,'holes'); 
        dr=uint8(cat(3,r,g,b)); 
        
        D(repmat(rgb2gray(dr)>0,[1,1,3]))=0;    
        D = D+dr;   
        LM=Z;
    
    % Clear the canvas "D", Line Mask "LM" and 
    % Accumulated line mask "lm" if "x" is pressed
    elseif key=='x'; LM=Z ;D=Z; lm=Z;
    end
    
    % Take a snapshot using webcam
    I=snapshot(cam);
    I=fliplr(I);      % Mirrored image
    
    % Applying Guassian filter
    I1=imfilter(I, gaussian_filter);
    
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
        I(repmat(rgb2gray(LM)>0,[1,1,3]))=0;
        I(repmat(rgb2gray(D)>0,[1,1,3]))=0;   
        imshowpair(I+ LM+ D, lm,'montage')       
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
        
        % Drawing line if "d" is pressed
        if key=='d' & flag==0; flag=1; end        
        % Stop drawing line if key is not "d"
        if key~='d' & flag==1; flag=0; end
        
        % Assigning color w.r.t to key pressed 
        if key=='v' ;   color=[143; 0 ;255];    end
        if key=='i' ;   color=[ 76; 0 ;127];    end
        if key=='b' ;   color=[ 0 ; 0 ;255];    end
        if key=='g' ;   color=[ 0 ;255; 0 ];    end
        if key=='y' ;   color=[255;255; 0 ];    end
        if key=='o' ;   color=[255;127; 0 ];    end
        if key=='r' ;   color=[255; 0 ; 0 ];    end
        if key=='l' ;   color=[200;100; 0 ];    end
        if key=='c' ;   color=[ 0 ;255;255];    end
        if key=='w' ;   color=[255;255;255];    end
        
        if key=='e' ;   color=[ 50; 50; 50];    end
        
        % Drawing the line ( Bresenham Algorithm )
        if flag==1
            LM = line_draw('bresenham',LM,round([x_prev y_prev]), round([x y]),color,color);
        end
        
        % assign Current centroid co-ordinates to previous Centroid co-ordinates 
        x_prev=x; y_prev=y;   
        
        % Erasing
        lm(repmat(rgb2gray(D)==50,[1,1,3]))=0;
        D(repmat(rgb2gray(D)==50,[1,1,3]))=0;
        
        % Prevents Adding of values
        I(repmat(rgb2gray(LM)>0,[1,1,3]))=0;        
        I(repmat(rgb2gray(D)>0,[1,1,3]))=0;           
        
        lm=lm+LM;
        
        % Showing two images side by side
        imshowpair(I+ LM+ D, mask_I+ lm,'montage')
    end
end
clear;clc
