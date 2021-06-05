function I=line_draw(str,I,initial_pos,final_pos,color1,color2)

I=flipud(I);
x1=initial_pos(1); y1=initial_pos(2); 
x2=final_pos(1); y2=final_pos(2);

switch(str)
    case 'DDA'
        %% "Digital Differential Analyzer (DDA)" Algorithm (use floating-point values)
        
        dx=x2-x1; dy=y2-y1;             % Calc. dx and dy
        
        step = max(abs(dx),abs(dy));    % Find step value
        
        xinc=dx/step; yinc=dy/step;     % Calc. increment values 
                                        % floating-point due to division
        for i=1:step
            % Assigning the pixel value at (x1, y1) with color
            % Color can interpolate from color1 to color2
            I(size(I,1)-round(y1),round(x1),:)=((step-i)/step)*color1 +(i/step)*color2;
            
            x1=x1+xinc;                 % floating-point addition
            y1=y1+yinc;
        end
       
    case 'bresenham'
        %% Bresenham Algorithm (use only integer values)
        
        dx=abs(x2-x1); dy=abs(y2-y1);       % Calc. dx and dy
        
        step= dy > dx;               
        if step; t=dx;dx=dy;dy=t; end       % swap dx and dy values if |dy| > |dx|   
        
        if dy==0
            q=zeros(dx+1,1);
        else
            q=[0; diff(mod(( bitshift(dx,-1): -dy: -dy*dx+bitshift(dx,-1) ).', dx))>=0];
        end
        
        % if dy > dx
        if step                            
            if y1<=y2; y=(y1:y2).';     else; y=(y1:-1:y2).'; end
            if x1<=x2; x=x1+cumsum(q);  else; x=x1-cumsum(q); end
            
        % if dx > dy
        else
            if x1<=x2; x=(x1:x2).';     else; x=(x1:-1:x2).'; end
            if y1<=y2; y=y1+cumsum(q);  else; y=y1-cumsum(q); end
        end
        
        step=size(x,1);
        for i=1:step
            % Assigning the pixel value at (x(i), y(i)) with color
            % Color can interpolate from color1 to color2
            I(size(I,1)- y(i), x(i),:)=((step-i)/step)*color1+(i/step)*color2;
        end
end  
I=flipud(I);
end