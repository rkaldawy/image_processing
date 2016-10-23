%   Mesh creation
%   Outputs node points in mm
%   Use viewer to see your mesh
%   SNM XJJ YJ - WPI 2012-2015

clear all
X = [];                                     % X co-ordinates of the nodes
Y = [];                                     % Y co-ordinates of the nodes
Z = [];                                     % Z co-ordinates of the nodes
inc             = 0.33*3;                   % vertical image spacing in mm
ZERONUMBER      = 1152;                     % image # with z = 0
start           = 1213;                     % initial image #
stop            = 1221;                     % final image #
step            = 2;                        % read images in steps
crop            = 1.0;                      % cropping selected
Nint            = 0;                        % number of interpolation steps - xy plane is 2^Nint
NintZ           = 0;                        % number of interpolation steps - z direction
%expected        = [0 0 255];                % the expected color for the color selector in [R G B]
expected        = [90 60 20];
redTol          = 40;                       % the amount of red tolerance for the selector
blueTol         = 40;                       % the amount of blue tolerance for the selector
greenTol        = 40;                       % the amount of green tolerance for the selector
%   Main loop
for i = start:step:stop                     % read images in the consequtive order
    count = 0;                              % increment for the handle to plot the nodes
    z       = inc*(ZERONUMBER-i);           % Z co-ordinate for each starting slide in mm
    str1    =  num2str(i);
    %name    = 'testpxlline.png';
    name    = strcat('avf', str1, 'b','.png');                      % image name formed as a string
    img     = imread(name, 'png');                                         % read image
    sizex   = size(img, 2);                 % x-size in pixels
    sizey   = size(img, 1);                 % y-size in pixels
    %     img  = img(floor(sizey*(1-crop)/2)+1:floor(sizey*(1+crop)/2),...
    %         floor(sizex*(1-crop)/2)+1:floor(sizex*(1+crop)/2), :);
    Xsize   = (sizex*0.33)*crop;                                 % image x-size, mm
    Ysize   = (sizey*0.33)*crop;                                 % image y-size, mm
    fig     = figure('units','normalized','outerposition',[0 0 1 1],'Name',name);   % full screen figure window for image display
    hold on;
    imagesc([-Xsize/2 Xsize/2], [+Ysize/2 -Ysize/2], img);               % image display with pixels converted into 'mm'
    xmesh = (-Xsize/2):inc*2:(Xsize/2);
    ymesh = (-Ysize/2):inc*2:(Ysize/2);
    [xx,yy,zz] = meshgrid(xmesh,ymesh,z);                                % mesh grid of 2 x 2 mm as a guide for point density to be maintained
    set(gca, 'ydir', 'normal');
    zoom on; % use mouse button to zoom in or out
    % Press Enter to get out of the zoom mode.
    % CurrentCharacter contains the most recent key which was pressed after opening
    % the figure, wait for the most recent key to become the return/enter key
    waitfor(gcf,'CurrentCharacter',char(13))
    zoom reset
    zoom off
    plot(xx,yy,'.w','MarkerSize',1);                            % mesh grid plotted
    X0 = []; Y0 = []; Z0 = [];
    stop_X = [];
    stop_Y = [];
    NL = [];
    % To plot the points from previous' slide segemtation
    if i > start
        layer = (Z == inc*(ZERONUMBER-i+step));
        plot(X(layer),Y(layer),'+m')
    end
    %   For interpolation - arrays for one slice
    while(1)
        [x, y] = ginput(1);
        if isempty(x), break, end;
        ip = get(gcf,'Selectiontype');
        val = double(get(gcf,'CurrentCharacter'));
        % 1. Detect left click to add points on the images - 'normal' mode.
        % 2. Detect points that have been deleted and add new points in the
        % ordered position of the points that were deleted - 'normal' mode.
        % 2. Detect right click to delete the closest point to the cursor
        % and store the point's position to be added back in proper order
        % - 'alt' mode
        % 3. Detect right arrow on image, enable contour/chain which is
        % useful for making minor changes to exisiting point cloud from
        % previous image - 'alt' mode
        % 5. Detect up arrow on image, enable color selector which moves
        % each point towards the closest red dot on the image until the dot
        % is over a certain color in the image, within a specified tolerance.
        % 4. Detect shift+left click to enable line mode to create a line
        % of points that the color selector will move - 'extend' mode.
        % 5. Detect left arrow on image to enable line mode to create a
        % line of red dots. The color selector will move each point on the
        % image towards the closest red dot.
        % For more details, search 'selectiontype' in help.
        
        if val == 120                      % enables center point freehand
            h1 = imfreehand
            pos = getPosition(h1);
            xlist = pos(:,1)';
            ylist = pos(:,2)';
            n = 1;
            for i=1:length(xlist)
                xPos = xlist(i);
                yPos = ylist(i);
                currentDist = sqrt((xPos-xlist(n))^2 + (yPos-ylist(n))^2);
                if (currentDist > 0.25)
                    plot(xPos, yPos, 'r+');
                    n = i;
                    stop_X = [stop_X; xPos];
                    stop_Y = [stop_Y; yPos];
                end
            end
            delete(h1);
            
        elseif val == 122
            
            h2 = imrect
            pos = getPosition(h2);
            delete(h2);
            
            x_min = pos(1); x_max = pos(1) + pos(3);
            y_min = pos(2); y_max = pos(2) + pos(4);
            
            pxl_up = (Ysize - (y_max + Ysize/2))/(0.33*crop);
            pxl_down = (Ysize - (y_min + Ysize/2))/(0.33*crop);
            pxl_left = (x_min + Xsize/2)/(0.33*crop);
            pxl_right = (x_max + Xsize/2)/(0.33*crop);
            
            bounds = [pxl_up, pxl_down, pxl_left, pxl_right]
            
            row_num = 2 * round(pxl_down - pxl_up);
            col_num = 2 * round(pxl_right - pxl_left);
            obs_Array = zeros(row_num, col_num)
            
            %key: top-left node is the x-var
            %     bottom-left node is the y-var
            %     top-right node is the belonging object
            %     botom-right node is the edge piece case

            tolerance = [redTol, greenTol, blueTol];
            colorInfo = [expected; tolerance];
            conv_Array = [];
            count = 1;
            
            for r = 1:2:row_num
                for c = 1:2:col_num
                    if (isequal(obs_Array(r:r+1,c:c+1), zeros(2, 2)))
                        obs_Array = flood_fill(colorInfo, img, bounds, r, c, count, obs_Array);
                        if (obs_Array(r, c+1) ~= 0)
                            conv_Array = check_connections(r, c, obs_Array, conv_Array) %find the connected objects
                        end 
                        if (obs_Array(r, c+1) == count)
                            count = count + 1; %move to next new object
                        end
                    end
                end
            end
                   
%             for r = 1:2:row_num
%                 for c = 1:2:col_num 
%                     if (~isequal(obs_Array(r:r+1,c:c+1), zeros(2, 2)))
%                         obs_Array = 
%                     end
%                 end
%             end

            obs_Array
            conv_Array
            
             for j = 1:size(conv_Array, 2)
                print = conv_Array(1, j).value
             end
            
%             for r = 1:2:row_num
%                 for c = 1:2:col_num
%                     if (isequal(obs_Array(r:r+1,c:c+1), zeros(2, 2)) ~= 1)
%                         x_in = obs_Array(r, c);
%                         x_print = (x_in * (0.33*crop)) - (Xsize/2);
%                         y_in = obs_Array(r+1, c);
%                         y_print = (Ysize/2) - (y_in * (0.33 * crop));
%                         plot (x_print, y_print, 'g+');
%                     end
%                 end
%             end
            
%              xround = round((x + Xsize/2)/(0.33*crop))
%              yround = round((Ysize - (y + Ysize/2))/(0.33*crop))
%             pxl = [xround, yround];
%             pxl_array = [pxl.'];
%             total_pxl = [88];
%             
%             for pCt = 1:size(total_pxl, 2)
%                 hold on;
%                 x_in = total_pxl(1, pCt); y_in = total_pxl(2, pCt);
%                 x = (x_in * (0.33*crop)) - (Xsize/2);
%                 y = (Ysize/2) - (y_in * (0.33 * crop));
%                 plot(x, y , 'g+');
%             end
        end
    end
    %   Interpolation for one slice (inserting intermediate points)
    for m = 1:Nint
        Xtemp = [X0(2:end); X0(1)];
        Ytemp = [Y0(2:end); Y0(1)];
        Ztemp = [Z0(2:end); Z0(1)];
        x = zeros(2*length(X0), 1);
        y = zeros(2*length(Y0), 1);
        z = zeros(2*length(Z0), 1);
        for n = 1:length(X0);
            x(2*n-1) = X0(n);
            x(2*n-0) = (X0(n)+Xtemp(n))/2;
            y(2*n-1) = Y0(n);
            y(2*n-0) = (Y0(n)+Ytemp(n))/2;
            z(2*n-1) = Z0(n);
            z(2*n-0) = (Z0(n)+Ztemp(n))/2;
        end
        X0 = x;
        Y0 = y;
        Z0 = z;
    end
    %   Interpolation for multiple slices (lifting and cloning)
    if NintZ ==1
        X0 = [X0; X0];
        Y0 = [Y0; Y0];
        Z0 = [Z0; Z0+inc*step/2];
    end
    if NintZ ==2
        X0 = [X0; X0; X0];
        Y0 = [Y0; Y0; Y0];
        Z0 = [Z0; Z0+inc*step/3; Z0+2*inc*step/3];
    end
    %   Accumulation of slices
    X = [X; X0];
    Y = [Y; Y0];
    Z = [Z; Z0];
    hold off;
    close(fig);
    save ('temp.mat','X','Y','Z');
    
end
P(:, 1) = X;
P(:, 2) = Y;
P(:, 3) = Z;

[Filename,~] = uiputfile('*.mat','Save Workspace As');
save(Filename,'P');


