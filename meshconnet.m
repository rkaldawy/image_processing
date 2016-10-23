function [AttachedTriangles] = meshconnet(t, edges, flag)
%   Find triangles attached to every edge of a triangular mesh
%   Inputs: array of nodes P, triangulation t
%   Output: numerical (manifold meshes) or cell (presumably non-manifold meshes) 
%   array of triangles attached to each edge. Array size is (N, 2) for manifolds
%   SNM Winter 2015            
    EDGES = size(edges, 1);  temp = cell(EDGES, 1); 
    for m = 1:EDGES
        ind1 = (t(:, 1)==edges(m, 1));    
        ind2 = (t(:, 2)==edges(m, 1));
        ind3 = (t(:, 3)==edges(m, 1));    
        IND1 = ind1|ind2|ind3;          % Index into trianges that include the first edge vertex
        ind1 = (t(:, 1)==edges(m, 2));    
        ind2 = (t(:, 2)==edges(m, 2));
        ind3 = (t(:, 3)==edges(m, 2));    
        IND2 = ind1|ind2|ind3;         % Index into trianges that include the second edge vertex
        IND  = find(IND1&IND2);        % Index into triangles that include the given edge   
        temp{m}    = IND;
    end
    if strcmp(flag, 'manifold')
        AttachedTriangles = cell2mat(temp')';
    else
       AttachedTriangles = temp; 
    end
end