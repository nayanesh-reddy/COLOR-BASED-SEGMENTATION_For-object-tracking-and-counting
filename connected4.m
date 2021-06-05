%% Connected-component labeling Algorithm ( Two-pass Hoshen–Kopelman(HK)algorithm)
% I(p) => Pixel value at position p in image I
% 
%             | t |
%         | b | p |
% 
% If I(p) = 0, move to next scanning position.
% 
% If I(p) = 1 and I(b) = I(t) = 0
%     then assign a new label to position p
% 
% If I(p) = 1 and only one of the two neighbor is ( > 0 )
%     then assign its label to p.
% 
% If I(p) = 1 and both I(b) and I(t) are ( > 0 )'s, 
%     then
%     If I(b) ≠ I(t) 
%         then assign one of the labels to p either I(b) or I(t) 
%         and make a note that the two labels are equivalent
% 
%     If I(b) = I(t)
%         then I(p)=I(b)

%% 
function [L,numobj]=connected4(I) % connectivity is 4

I=double(I);
I=padarray(I,[1,1]);
I(end,:)=[]; I(:,end)=[];

d=0;
[R,C]=find(I==1);

% Assigning labels to pixels
for p=1:numel(R)
    r=R(p); c=C(p);
    
    if I(r,c-1)>0 && I(r-1,c)>0
        if I(r,c-1)~=I(r-1,c)
            I(r,c)=I(r,c-1);
            I(I==I(r-1,c))=I(r,c-1);
        else
            I(r,c)=I(r,c-1);
        end
    elseif I(r,c-1)>0
        I(r,c)=I(r,c-1);
    elseif I(r-1,c)>0
        I(r,c)=I(r-1,c);
    else
        d=d+1;
        I(r,c)=d;
    end  
        
end

% Reassigning labels in ascending order
M=max(I(:)); 
j=0;
for m=1:M
    if sum(I(I==m),'all')>0
        j=j+1;
        I(I==m)=j;
    end
end

L(:,:)=uint8(I(2:end,2:end));

% Finding no.of objects
numobj=j;

end


        