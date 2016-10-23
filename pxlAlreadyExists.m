function checkA = pxlAlreadyExists(pxl, lineArray)
testA = 0;
for k = 1:size(lineArray, 2)
    if (pxlCheck(pxl, lineArray(k)))
        testA = 1;
    end
end
checkA = testA;
end

function checkB = pxlCheck(pxl, arrayObj)
pxlArray = arrayObj.Array;
testB = 0;
for j = 1:size(pxlArray, 2)
    currentPxl = pxlArray(:, j);
    if (isequal(currentPxl, pxl))
       testB = 1;
    end
end
checkB = testB;
end