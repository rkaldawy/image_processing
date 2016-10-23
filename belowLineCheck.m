function newArray = belowLineCheck(colorInfo, img, arrayobj, lineArray)
i = 1; 
pxlArray = arrayobj.Array;
arraySize = size(pxlArray, 2);
while (i <= arraySize)
    
    pxl = pxlArray(:, i); 
    downPxl = pxl;
    downPxl(2, 1) = downPxl(2, 1) - 1; %modifier here
    pxlT = downPxl.';
   
    if (pxlAlreadyExists(downPxl, lineArray))
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
