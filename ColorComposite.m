function [RGB ]= ColorComposite(stIN,vDims,tol,bNorm)
if nargin==1,
    vDims=[4 6 1];
end
if ~exist('tol'),
    tol=0.05;
end
if ~exist('bNorm'),
bNorm=0;
end

A= sqrt(abs(stIN.data(:,:,vDims(1))));
if bNorm,
    A= A-min(A(:));
A= A./(max(A(:))-min(A(:)));
end
if tol
R = imadjust(A, stretchlim(A,tol),[]);
else
   R=A; 
end
A= sqrt(abs(stIN.data(:,:,vDims(2))));
if bNorm,
     A= A-min(A(:));
A= A./(max(A(:))-min(A(:)));
end
if tol
G = imadjust(A, stretchlim(A,tol),[]);
else
   G=A; 
end
A= sqrt(abs(stIN.data(:,:,vDims(3))));
if bNorm,
     A= A-min(A(:));
A= A./(max(A(:))-min(A(:)));
end
if tol
B = imadjust(A, stretchlim(A,tol),[]);
else
   B=A; 
end
RGB(:,:,1)= R;
RGB(:,:,2)= G;
RGB(:,:,3)= B;

