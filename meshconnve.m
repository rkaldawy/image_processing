function [sv] = meshconnve(t, edges)
%   Find edges (indexes) attached to every vertex (cell array)
%   SNM Winter 2015
    se = cell(N, 1);
    for m = 1:N
        temp  = (edges(:, 1)==m)|(edges(:, 2)==m);
        se{m} = find(temp>0);
    end
end

