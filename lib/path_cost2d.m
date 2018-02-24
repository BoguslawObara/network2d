function cost = path_cost2d(im,vx,vy,x1,y1,x2,y2,gamma)
%   
%   REFERENCE:
%       E. Meijering et al. Design and Validation of a Tool for Neurite 
%       Tracing and Analysis in Fluorescence Microscopy Images
%       Cytometry Part A, 58A, 167-176, 2004
%
%   INPUT:
%       im      - gray image
%       vx,vy   - vector field
%       x1,y1   - coordinates of first pixel
%       x2,y2   - coordinates of secong pixel
%
%   OUTPUT:
%       cost    - cost map
%
%
%   AUTHOR:
%       Boguslaw Obara

%% cost
cost = gamma*im_cost2d(im,x1,y1) + (1-gamma)*vf_cost2d(vx,vy,x1,y1,x2,y2);
%% End
end

%% sub-functions
function cv = vf_cost2d(vx,vy,x1,y1,x2,y2)
    cv = phi(vx,vy,x2,y2,x1,y1);
    % cv = 1/2*(sqrt(phi(vx,vy,x1,y1,x2,y2))+sqrt(phi(vx,vy,x2,y2,x1,y1)));
end

function  p = phi(vx,vy,x1,y1,x2,y2)
    vx1 = vx(x1,y1);
    vy1 = vy(x1,y1);
    vx2 = vx(x2,y2);
    vy2 = vy(x2,y2);    
    % A*B = ||A|| ||B|| cos(alpha) where alpha is and angle between A and B
    n = norm([vx1 vy1],2)*norm([vx2 vy2],2);
    d = dot([vx1 vy1],[vx2 vy2]);
    p = d/n;
    p = abs(p);
    % p = abs(([vx1 vy1])*([vx2 vy2])'); 
end

% function  d = dxy(x1,y1,x2,y2)
%    d = (([x2 y2]-[x1 y1])/norm([x2 y2]-[x1 y1]));% 1 or sqrt(2)
% end

function cl = im_cost2d(im,x2,y2)
    cl = im(x2,y2); %1 - im(x2,y2);
end