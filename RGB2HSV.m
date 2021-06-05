function [H,S,V]=RGB2HSV(i)

i=double(i);
i=i./255;

[R,G,B]=imsplit(i);

cmax=max(i,[],[3]);
cmin=min(i,[],[3]);
delta=cmax-cmin;

H=zeros(size(R)); S=H;

H(cmax==R) = 60*mod(((G(cmax==R)-B(cmax==R))./delta(cmax==R)),6);
H(cmax==G) = 60*(((B(cmax==G)-R(cmax==G))./delta(cmax==G))+2);
H(cmax==B) = 60*(((R(cmax==B)-G(cmax==B))./delta(cmax==B))+4);

S(cmax~=0)=delta(cmax~=0)./cmax(cmax~=0);

V=cmax;

H=H./360;
end