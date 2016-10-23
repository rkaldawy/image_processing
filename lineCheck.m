
%pxl is some pixel
%colorInfo is a matrix with color information; 1st row expected
%img is the current image handle
%currLine


function pxlLine = lineCheck(pxl, colorInfo, img)
% subtracts the current and expected color values

color = (double(squeeze(img(pxl(2),pxl(1),:))).');
colorTol = color - (colorInfo(1,:)); 

if (colorTol < colorInfo(2,:))
    A = lineCheckLeft(pxl, colorInfo, img);
    B = lineCheckRight(pxl, colorInfo, img);
    pxlLine = [A, [pxl(1) ; pxl(2)], B];   
else 
        pxlLine = [];
end

end

function pxlLine = lineCheckLeft(pxl, colorInfo, img)
 
pxl(1) = pxl(1) - 1; %modifier here

color = (double(squeeze(img(pxl(2),pxl(1),:))).');
colorTol = color - (colorInfo(1,:)); 

if (colorTol < colorInfo(2,:))
    A = lineCheckLeft(pxl, colorInfo, img);
    pxlLine = [A, [pxl(1) ; pxl(2)]];   
else 
        pxlLine = [];
end

end

function pxlLine = lineCheckRight(pxl, colorInfo, img)

pxl(1) = pxl(1) + 1; %modifier here

color = (double(squeeze(img(pxl(2),pxl(1),:))).');
colorTol = color - (colorInfo(1,:)); 

if (colorTol < colorInfo(2,:))
    B = lineCheckRight(pxl, colorInfo, img);
    pxlLine = [[pxl(1) ; pxl(2)], B];   
else 
        pxlLine = [];
end

end


    
    