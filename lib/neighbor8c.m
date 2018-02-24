function [xn,yn,idx] = neighbor8c(m,n,x,y)
%% image indexes
%[m,n] = size(im);

%% index
xn = zeros(3,3);
yn = zeros(3,3);
% [ NW N NE ]
% [  W X  E ]
% [ SW S SE ]

xn(1,1) = x-1;
yn(1,1) = y-1;
xn(1,2) = x;
yn(1,2) = y-1;
xn(1,3) = x+1;
yn(1,3) = y-1;

xn(2,1) = x-1;
yn(2,1) = y;
xn(2,2) = x;
yn(2,2) = y;
xn(2,3) = x+1;
yn(2,3) = y;

xn(3,1) = x-1;
yn(3,1) = y+1;
xn(3,2) = x;
yn(3,2) = y+1;
xn(3,3) = x+1;
yn(3,3) = y+1;

%% remove pixels outside of the image 
idx1 = find(xn<1);
idx2 = find(yn<1);
% idx3 = find(xn>m);
% idx4 = find(yn>n);
idx3 = find(xn>n);
idx4 = find(yn>m);
idx = [idx1;idx2;idx3;idx4];
xn(idx) = -1;
yn(idx) = -1;

%% index
idx = sub2ind([m,n],yn(yn>0),xn(xn>0));

end