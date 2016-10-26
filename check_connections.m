function f = check_connections(r, c, obs_Array, conv_Array)

current_obj = obs_Array(r, c+1);

if (c ~= 1)
left_obj = obs_Array(r, c-1);
end
if (r ~= 1)
up_obj = obs_Array(r-2, c+1);
end

conv = [];
if (c ~= 1 && left_obj ~=0 && left_obj ~= current_obj)
    conv = [left_obj, current_obj];
elseif (r ~= 1 && up_obj ~= 0 && up_obj ~= current_obj)
    conv = [up_obj, current_obj];
else
    f = conv_Array;
    return;
end

eltA = conv(1,1); eltB = conv(1,2);
combine_A = 0; combine_B = 0;

for i = 1:size(conv_Array, 2)
    if (combine_A ~= 0 && combine_B ~= 0)
        break;
    elseif (includes(conv_Array(i), eltA) && includes(conv_Array(i), eltB))
        combine_A = -1; combine_B = -1;
        break;
    elseif (includes(conv_Array(i), eltA) && ~includes(conv_Array(i), eltB))
        combine_B = i;
    elseif (includes(conv_Array(i), eltB) && ~includes(conv_Array(i), eltA))
        combine_A = i;
    end
end

if (combine_A > 0 && combine_B > 0)
    size(conv_Array, 2)
    new_array = conv_Array(1, combine_A).combine(conv_Array(1, combine_B));
    if (combine_B < combine_A)
        conv_Array(combine_A) = []; conv_Array(combine_B) = [];
    elseif (combine_A < combine_B)
        conv_Array(combine_B) = []; conv_Array(combine_A) = [];
    end
    conv_Array = [conv_Array, new_array];
elseif (combine_A == 0 && combine_B > 0)
    2
    conv_Array(combine_B).value
    conv_Array(combine_B) = conv_Array(combine_B).add(eltB); %reversed
elseif (combine_B == 0 && combine_A > 0)
    3
    conv_Array(combine_A).value
    conv_Array(combine_A) = conv_Array(combine_A).add(eltA);
elseif (combine_A == -1 && combine_B == -1)
    4
else
    5
    new_array = Array; new_array.value = [];
    new_array = new_array.add(eltA); 
    new_array = new_array.add(eltB);
    conv_Array = [conv_Array, new_array];
end

f = conv_Array;

end

% function f = check_connections(r, c, obs_Array, conv_Array)
% 
% current_obj = obs_Array(r, c+1);
% 
% if (c ~= 1)
% left_obj = obs_Array(r, c-1);
% end
% if (r ~= 1)
% up_obj = obs_Array(r-2, c+1);
% end
% 
% conv = [];
% if (c ~= 1 && left_obj ~=0 && left_obj ~= current_obj)
%     conv = [left_obj, current_obj].';
% elseif (r ~= 1 && up_obj ~= 0 && up_obj ~= current_obj)
%     conv = [up_obj, current_obj].';
% end
% 
% already_there = true;
% i = 1;
% 
% while (i <= size(conv_Array, 2))
%     if (isequal(conv_Array(:, i), conv) || isequal([conv_Array(2, i); conv_Array(1, i)], conv))
%         already_there = false;
%     end
%     i = i + 1;
% end
% 
% if (already_there)
%     conv_Array = [conv_Array, conv];
% end
% f = conv_Array;
% 
% end


% function f = check_connections(r, c, obs_Array, conv_Array)
% 
% current_obj = obs_Array(r, c+1);
% 
% if (c ~= 1)
% left_obj = obs_Array(r, c-1);
% end
% if (r ~= 1)
% up_obj = obs_Array(r-2, c+1);
% end
% 
% conv = [];
% if (c ~= 1 && left_obj ~=0 && left_obj ~= current_obj)
%     conv = [left_obj, current_obj].';
% elseif (r ~= 1 && up_obj ~= 0 && up_obj ~= current_obj)
%     conv = [up_obj, current_obj].';
% end
% 
% already_there = true;
% i = 1;
% 
% while (i <= size(conv_Array, 2))
%     if (isequal(conv_Array(:, i), conv) || isequal([conv_Array(2, i); conv_Array(1, i)], conv))
%         already_there = false;
%     end
%     i = i + 1;
% end
% 
% if (already_there)
%     conv_Array = [conv_Array, conv];
% end
% f = conv_Array;
% 
% end
% 
% function f = check_connections(r, c, obs_Array, conv_Array)
% 
% current_obj = obs_Array(r, c+1);
% 
% if (c ~= 1)
% left_obj = obs_Array(r, c-1);
% end
% if (r ~= 1)
% up_obj = obs_Array(r-2, c+1);
% end
% 
% conv = [];
% if (c ~= 1 && left_obj ~=0 && left_obj ~= current_obj)
%     conv = [left_obj, current_obj].';
% elseif (r ~= 1 && up_obj ~= 0 && up_obj ~= current_obj)
%     conv = [up_obj, current_obj].';
% end
% 
% already_there = true;
% i = 1;
% 
% while (i <= size(conv_Array, 2))
%     if (isequal(conv_Array(:, i), conv) || isequal([conv_Array(2, i); conv_Array(1, i)], conv))
%         already_there = false;
%     end
%     i = i + 1;
% end
% 
% if (already_there)
%     conv_Array = [conv_Array, conv];
% end
% f = conv_Array;
% 
% end