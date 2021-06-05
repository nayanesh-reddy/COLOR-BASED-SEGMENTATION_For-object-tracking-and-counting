function [X,Y]=Centroid(I)

% k=0; y=0; x=0;
% for r=1:size(I,1)
%     for c=1:size(I,2)
%         if I(r,c)==1
%             k=k+1;
%             y=y+r;
%             x=x+c;
%         end
%     end
% end
% X=x/k;
% Y=y/k;

% Equivalent code for above code
[r,c] = find(I==1); Y=sum(r)/sum(I(:)); X=sum(c)/sum(I(:));

end