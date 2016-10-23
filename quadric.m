function [P, t] = quadric(H, P0, t0, addbottom)
    %   Create a cylinder (quadric) of height H from any planar mesh using
    %   extrusion. No top and no bottom caps
    %   SNM Summer 2012

    %   Find boundary vertices
    bars0     = freeBoundary(TriRep(t0, P0));
    barvec    = P0(bars0(:, 1), :)-P0(bars0(:, 2),: );    %   List of edge vectors [M, 2]
    Lavg      = mean(sqrt(sum(barvec.^2, 2)));            %   Average edge length
    Pb = P0(bars0', :); Pb(2:2:end, :) = [];              %   Boundary vertices
    pb = size(Pb, 1);   barsb = [1:pb; [2:pb 1]]';        %   Boundary connectivity
   
    %  Determine z-divisions   
    NN      = 1;                               %   Number of intervals along the height
    hsize   = H/NN;                                       %   Size of the z-divisions
    
    %   Replicate the cap mesh and its boundary; establish the connectivity
    P = Pb; p0 = size(P, 1); P(:, 3) = 0;  %   Bottom cap - vertices                                                                              
    t = [];                                %   No bottom triangles
                 
    %   Connectivity: bottom to top
    t1(:, 1:2) = bars0;                     %   Lower nodes        
    t1(:, 3)   = bars0(:, 1) + p0;          %   Upper node
    t2(:, 1:2) = bars0       + p0;          %   Upper nodes
    t2(:, 3)   = bars0(:, 2);               %   Lower node
    t = [t' t1' t2']';
 
    %   Add the top cap nodes but not triangles
     Pb(:, 3) = H; P = [P' Pb']';
end

