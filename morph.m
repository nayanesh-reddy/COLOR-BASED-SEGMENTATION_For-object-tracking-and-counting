function I=morph(str,I,se)

I=double(I);
str=string(str);
if str=="dilate"
    e=0;
elseif str=="erode"
    e=1;
end
%%
mr=floor(size(se,1)/2);
mc=floor(size(se,2)/2);

[R,C]=find(I==1);

I=padarray(I,[mr,mc],'replicate');
J=I;

p=cat(2,R,C);

for i=1:size(p,1)
    r=p(i,1)+mr; c=p(i,2)+mc;
    i=I(r-mr:r+mr,c-mc:c+mc);
    
    % Erosion
    if e==1 
        if sum(i(se==1)==1)==sum(se,'all') 
            J(r,c)=2;
        end
        
    % Dilation
    else  
        i(se==1)=2;
        if i(mr+1,mc+1)==1
            i(mr+1,mc+1)=se(mr+1,mc+1);            
        end
        I(r-mr:r+mr,c-mc:c+mc)=i;
    end 
end

% Reassigning the labels to 1 or 0
if e==1
    I(J~=2)=0; I(J==2)=1;
else
    I(I==2)=1;
end

I=I(mr+1:size(I,1)-mr,mc+1:size(I,2)-mc);
end