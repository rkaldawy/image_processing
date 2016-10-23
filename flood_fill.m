function f = flood_fill(colorInfo, img, bounds, r, c, count, obs_Array)
% MAKE THIS SHIT NON RECURSIVE
y_min = round(bounds(1));
x_min = round(bounds(3));

pxl = [x_min + (c+1)/2 - 1, y_min + (r+1)/2 - 1];

if (color_checker(colorInfo, img, pxl))
    obs_Array(r, c) = x_min + (c+1)/2 - 1;
    obs_Array(r+1, c) = y_min + (r+1)/2 - 1;

if (r ~= 1)
    up_object = obs_Array(r-2, c+1);
end
%down_object = obs_Array(r+2, c+1);
if (c ~= 1)
    left_object = obs_Array(r, c-1);
end
%right_object = obs_Array(r, c+3);

%no_surrounding_objects = up_object == 0 && left_object == 0;

if (r ~= 1 && up_object ~= 0)
    obs_Array(r, c+1) = up_object;
elseif (c ~= 1 && left_object ~= 0)
    obs_Array(r, c+1) = left_object;
else
    obs_Array(r, c+1) = count;
end

% if (obs_Array(r, c+1) ~= up_object && ~no_surrounding_objects)
%     conversion = [up_object, obs_Array(r, c+1)].';
%     conversions = [conversions, conversion];
% end    

pxl_up = [x_min + (c+1)/2 - 1, y_min + (r+1)/2 - 2];
pxl_down = [x_min + (c+1)/2 - 1, y_min + (r+1)/2];
pxl_left = [x_min + (c+1)/2 - 2, y_min + (r+1)/2 - 1];
pxl_right = [x_min + (c+1)/2, y_min + (r+1)/2 - 1];

check_up = color_checker(colorInfo, img, pxl_up);
check_down = color_checker(colorInfo, img, pxl_down);
check_left = color_checker(colorInfo, img, pxl_left);
check_right = color_checker(colorInfo, img, pxl_right);

boundsCheck = (r == 1 || r == size(obs_Array, 1) - 1 || c == 1 || c == size(obs_Array, 2) - 1);

if (boundsCheck || ~check_up || ~check_down || ~check_left || ~check_right)    
    obs_Array(r+1, c+1) = 1;
end

end

f = obs_Array;
end


% function f = flood_fill(colorInfo, img, bounds, r, c, count, obs_Array)
% % MAKE THIS SHIT NON RECURSIVE
% y_min = round(bounds(1));
% x_min = round(bounds(3));
% 
% pxl = [x_min + (c+1)/2 - 1, y_min + (r+1)/2 - 1]
% pxl_up = [x_min + (c+1)/2 - 1, y_min + (r+1)/2 - 2];
% pxl_down = [x_min + (c+1)/2 - 1, y_min + (r+1)/2];
% pxl_left = [x_min + (c+1)/2 - 2, y_min + (r+1)/2 - 1]
% pxl_right = [x_min + (c+1)/2, y_min + (r+1)/2 - 1]
% 
% check_up = color_checker(colorInfo, img, pxl_up);
% check_down = color_checker(colorInfo, img, pxl_down);
% check_left = color_checker(colorInfo, img, pxl_left)
% check_right = color_checker(colorInfo, img, pxl_right)
% 
% if (color_checker(colorInfo, img, pxl))
%     obs_Array(r, c) = x_min + (c+1)/2 - 1;
%     obs_Array(r+1, c) = y_min + (r+1)/2 - 1;
%     obs_Array(r, c+1) = count;
% 
%     obs_Array
%     
% if (r ~= 1)
%     isEmpty(obs_Array(r-2:r-1, c:c+1))
% if (check_up && isEmpty(obs_Array(r-2:r-1, c:c+1)))
%     55.555
%     obs_Array = flood_fill(colorInfo, img, bounds, r-2, c, count, obs_Array);
% end
% end
% 
% if (r ~= size(obs_Array, 1) - 1)
%      isEmpty(obs_Array(r+2:r+3, c:c+1))
% if (check_down && isEmpty(obs_Array(r+2:r+3, c:c+1)))   
%     obs_Array = flood_fill(colorInfo, img, bounds, r+2, c, count, obs_Array);
% end
% end
% 
% if (c ~= 1)
%     isEmpty(obs_Array(r:r+1, c-2:c-1))
% if (check_left && isEmpty(obs_Array(r:r+1, c-2:c-1)))    
%     obs_Array = flood_fill(colorInfo, img, bounds, r, c-2, count, obs_Array);
% end
% end
% 
% if (c ~= size(obs_Array, 2) - 1)
%     isEmpty(obs_Array(r:r+1, c+2:c+3))
% if (check_right && isEmpty(obs_Array(r:r+1, c+2:c+3)))   
%     obs_Array = flood_fill(colorInfo, img, bounds, r, c+2, count, obs_Array);
% end
% end
% % 
% % boundsCheck = (r == 1 || r == round(bounds(2) - bounds(1)) || c == 1 || c == round(bounds(4) - bounds(3)));
% % 
% % if (boundsCheck || ~check_up || ~check_down || ~check_left || ~check_right)    
% %     obs_Array(r+1, c+1) = 1;
% % end
% end
% 
% f = obs_Array;
% end



% function f = flood_fill(colorInfo, img, start_pxl, pxl_array)
% 
% pxlT = start_pxl.'; %verical pixel
% pxl_array = [pxl_array, pxlT];
% pxl_array_size = size(pxl_array, 2);
% final_array = [];
% i = 1;
% 
% while(i <= pxl_array_size)
% pxl = pxl_array(:, i).';
% pxl_up = [pxl(1) + 1, pxl(2)];
% pxl_down = [pxl(1) - 1, pxl(2)];
% pxl_left = [pxl(1), pxl(2) - 1];
% pxl_right = [pxl(1), pxl(2) + 1];
% 
% check_up = color_checker(colorInfo, img, pxl_up);
% check_down = color_checker(colorInfo, img, pxl_down);
% check_left = color_checker(colorInfo, img, pxl_left);
% check_right = color_checker(colorInfo, img, pxl_right);
% 
% if (check_up && pxlCheck_FF(pxl_up, pxl_array))
%     pxl_array = [pxl_array, pxl_up.'];
% end
% if (check_down && pxlCheck_FF(pxl_down, pxl_array))
%     pxl_array = [pxl_array, pxl_down.'];
% end
% if (check_left && pxlCheck_FF(pxl_left, pxl_array))
%     pxl_array = [pxl_array, pxl_left.'];  
% end
% if (check_right && pxlCheck_FF(pxl_right, pxl_array))
%     pxl_array = [pxl_array, pxl_right.'];  
% end
% if (~check_up || ~check_down || ~check_left || ~check_right)    
%     final_array = [final_array, pxl.'];
% end
% 
% i = i+1;
% pxl_array_size = size(pxl_array, 2);
% end
% 
% f = final_array;
% end


function checkA = color_checker(colorInfo, img, pxl)

color = (double(squeeze(img(pxl(2),pxl(1),:))).');
colorTol = color - (colorInfo(1,:)); 

if (colorTol < colorInfo(2,:))
    checkA = 1;
else
    checkA = 0;
end
end

function checkB = isEmpty(node)
if (isequal(node, zeros(2,2)))
    checkB = 1;
else
    checkB = 0;
end
end

% function checkC = pxlCheck_FF(pxl, pxlArray)
% testB = 1;
% pxlT = pxl.';
% for j = 1:size(pxlArray, 2)
%     currentPxl = pxlArray(:, j);
%     if (isequal(currentPxl, pxlT))
%        testC = 0;
%     end
% end
% checkC = testC;
% end



