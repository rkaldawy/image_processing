function f = connect_objects(r, c, obs_Array, conv_Array)
current_obj = obs_Array(r, c+1);
for i = 1:length(conv_Array)
    if (includes(conv_Array(i), current_obj))
        obs_Array(r, c+1) = get_first(conv_Array(i));
    end
end
f = obs_Array;
end