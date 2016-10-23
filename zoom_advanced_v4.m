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
expected        = [68 48 7];                % the expected color for the color selector in [R G B]
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
            
            %pxlQueue = makeQueue([]);
            lineArray = [];
            
            tolerance = [redTol, greenTol, blueTol];
            colorInfo = [expected; tolerance];
            
            xround = round((x + Xsize/2)/(0.33*crop));
            yround = round((Ysize - (y + Ysize/2))/(0.33*crop));
            pxl = [xround, yround];
            
            pxlLine = PXL_ARRAY;
            pxlLine.Array = lineCheck(pxl, colorInfo, img);
            filler = PXL_ARRAY;
            filler.Array = [];
            lineArray = [pxlLine, filler];
            lineArraySize = size(lineArray,2);
            
            %need to make an array class 
            
            lineCounter = 1;
            while(lineCounter <= lineArraySize)
                lineArray = aboveLineCheck(colorInfo, img, lineArray(lineCounter), lineArray);
                lineArray = belowLineCheck(colorInfo, img, lineArray(lineCounter), lineArray);
                lineArraySize = size(lineArray,2);
                lineCounter = lineCounter + 1;
            end
            
            lineArray
            
            pointsArray = [];
            for lineCount = 1:size(lineArray, 2)
                pointArray = lineArray(lineCount).Array
                pointsArray = [pointsArray, pointArray];
            end
            
            for pCt = 1:size(pointsArray, 2)
                hold on;
                x_in = pointsArray(1, pCt); y_in = pointsArray(2, pCt);
                x = (x_in * (0.33*crop)) - (Xsize/2);
                y = (Ysize/2) - (y_in * (0.33 * crop));
                plot(x, y , 'g+');
            end
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


