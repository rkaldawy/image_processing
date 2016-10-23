function newArray = aboveLineCheck(colorInfo, img, arrayobj, lineArray)
i = 1; 
pxlArray = arrayobj.Array;
arraySize = size(pxlArray, 2);
while (i <= arraySize)
    
    pxl = pxlArray(:, i); 
    upPxl = pxl;
    upPxl(2, 1) = upPxl(2, 1) + 1; %modifier here
    pxlT = upPxl.';
   
    if (pxlAlreadyExists(upPxl, lineArray)) % || bounds_hit(upPxl)
        i = i + 1; 
    else
        A = PXL_ARRAY;
        A.Array = lineCheck(pxlT, colorInfo, img);
        lineArray = [lineArray, A];
        i = i + 1; 
    end
end
newArray = lineArray;
end
