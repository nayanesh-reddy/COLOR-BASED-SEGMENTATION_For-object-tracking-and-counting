clear; clc; close

%% Threshold values
h_Min = 194; h_Max = 212; 
s_Min = 0.5; v_Min = 0.3;

%% Accessing webcam
cam=webcam;
I=snapshot(cam);
sz=size(I);

%% Gaussian Low-pass filter for blurring (Frequency domain)

% Creating a shift matrix to center the transform
for r=1:sz(1)
for c=1:sz(2)
    shift(r,c)=(-1)^((r-1)+(c-1));
end
end
shift = repmat(shift,[1,1,3]);

% Calc. centre of the filter
cu=(sz(1))/2;
cv=(sz(2))/2;

% Calc. Distance matrix
for u=1:sz(1)
for v=1:sz(2)
D(u,v)=sqrt(((u-1)-cu)^2+((v-1)-cv)^2);
end
end

% Calc. Guassian low-pass filter
D0=15;
H = exp(-(D.^2)/(2*(D0^2)));

%% Structing Element
se=load('se.mat');
se=se.se;

%% Initial variables
f=1;
LM=zeros(sz);
scale=0.1;

%% 
while 1
    
    % Wait for key press (sec)
    pause(0.0001)
    % Get character from keyboard
    key = get(gcf,'currentcharacter');
    
    % Break while loop if "SPACE" is pressed
    if key==' '; break; end
    
    % Take a snapshot using webcam
    I=snapshot(cam);
    I=fliplr(I);        % Mirrored image
    
    % Applying Guassian Low-pass filter    
    F = fft2(double(I).*shift);
    I1 = uint8(abs(ifft2(F.*H)));  
    
    % Converting RGB to HSV colorspace
    [h,s,v]=RGB2HSV(I1);
    
    % creating mask by "intersection" of hue channel masks using h_Min and h_Max
    m=( (h >= h_Min/360) & (h <= h_Max/360) ) & (s >= s_Min ) & (v >= v_Min );

    % creating mask by "union" of hue channel masks using h_Min and h_Max
    %m=( (h >= h_Min/360) | (h <= h_Max/360) ) & (s >= s_Min ) & (v >= v_Min );

    % Morphological opening with structing element 'se'
    m=morph('dilate',morph('erode',m,se),se);
    
    % Find Centroid of object with max Area
    m1=logical(imresize(m,scale));
    [label_img, numobj]=connected4(m1);
    
    if numobj>1
        for j=1:numobj
            area(j)=sum(label_img==j,'all');
        end
        idx=find(area==max(area));
        m1=label_img==idx(1);
        [X,Y]=Centroid(m1);
        X=round((1/scale)*X); Y=round((1/scale)*Y);
    else
        [X,Y]=Centroid(m);
    end
    
    %% Drawing the tracked path
    
    if isnan(X)
       imshowpair(I,uint8(m),'montage')
       LM=zeros(sz);       
       f=1;
       
    elseif ~isnan(X) && f==1
        x_prev=X; y_prev=Y;        
        f=0;
        
    else 
        % Current centroid co-ordinates
        x=X; y=Y;
        
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
clear; clc