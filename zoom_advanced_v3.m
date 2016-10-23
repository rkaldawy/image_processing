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
expected        = [60 35 5];                % the expected color for the color selector in [R G B]
redTol          = 45;                       % the amount of red tolerance for the selector
blueTol         = 45;                       % the amount of blue tolerance for the selector
greenTol        = 45;                       % the amount of green tolerance for the selector
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
    CX0 = [];
    CY0 = [];
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
        if val == 114                       % enables center point freehand
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
                    CX0 = [CX0; xPos];
                    CY0 = [CY0; yPos];
                end
            end
            delete(h1);
            
            %h1 = imline
            %pos = h1.getPosition();
            %dist = sqrt((pos(2)-pos(1))^2 + (pos(4) - pos(3))^2);
            %dotnum = dist/0.5;
            %c = 0;
            %hold on;
            %while (c<dotnum)
            %    a = pos(1) + c*((pos(2) - pos(1))/dotnum);
            %    b = pos(3) + c*((pos(4) - pos(3))/dotnum);
            %    count = count+1;
            %    plot(a, b, 'r+');
            %    CX0 = [CX0; a];
            %    CY0 = [CY0; b];
            %    c = c+1;
            %end
            %delete(h1);
            %set(gcf,'CurrentCharacter',char(1));
            
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
            lineArray = [pxlLine filler];
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
                
            
            %pxlLine = lineCheck(pxl, colorInfo, img);
            %pxlQueue = addElt(pxlQueue, pxlLine);
            %pxlQueue.Array
            
            %newQueue = aboveLineCheck(colorInfo, img, pxlQueue);
            %newQueue.Array
            
            
            % add code that creates a new array that holds the information
            % for that pixel
            % link to the helper function that checks the array
            
            
        elseif val == 113                       %point center mode
            d = length(X0);
            AC = d;
            while (AC>=1)
                currentbest = 0;
                CX = 0;
                CY = 0;
                j = 1;
                i = size(CX0, 1);
                while j<=i
                    cdist = sqrt((CX0(j) - X0(AC))^2 + (CY0(j) - Y0(AC))^2);
                    if (cdist<currentbest || currentbest == 0)
                        currentbest = cdist;
                        CX = CX0(j);
                        CY = CY0(j);
                    end
                    j = j+1;
                end
                dist = sqrt((CX - X0(AC))^2 + (CY - Y0(AC))^2);
                distX = (X0(AC) - CX)/(2*dist);
                distY = (Y0(AC) - CY)/(2*dist);
                while(1)
                    xround = round((X0(AC) + Xsize/2)/(0.33*crop));
                    yround = round((Ysize-(Y0(AC) + Ysize/2))/(0.33*crop));
                    color = squeeze(img(yround,xround,:));
                    colA = abs(color(1)-expected(1));
                    colB = abs(color(2)-expected(2));
                    colC = abs(color(3)-expected(3));
                    if(colA<redTol && colB<blueTol && colC<greenTol);
                        hold on;
                        delete(h(AC));
                        h(AC) = plot(X0(AC), Y0(AC), 'g+');
                        AC = AC-1;
                        break;
                    else
                        newX = X0(AC) - distX;
                        newY = Y0(AC) - distY;
                        X0(AC)=newX;
                        Y0(AC)=newY;
                    end
                end
            end
            set(gcf,'CurrentCharacter',char(1));
        elseif val == 119                               %poly mode
            if ~length(X0)
                h1 = impoly(gca, [X(layer) Y(layer)])             %  Enable contour/chain mode; if no are points exisiting.
                pos = wait(h1);
                X0 = [X0; pos(:,1)];
                Y0 = [Y0; pos(:,2)];
                Z0 = [Z0; z*ones(length(pos(:,1)),1)];
                break
            end
            X0(length(X0),:)=[];                                    % Delete the node triggered by the right mouse click
            Y0(length(Y0),:)=[];
            Z0(length(Z0),:)=[];
            delete(h(count));                                     % Delete the corresponding plot handle
            count = count -1;
        elseif val == 101                       %enables point freehand
            h2 = imfreehand
            pos = getPosition(h2);
            xlist = pos(:,1)';
            ylist = pos(:,2)';
            n = 1;
            for i=1:length(xlist)
                xPos = xlist(i);
                yPos = ylist(i);
                currentDist = sqrt((xPos-xlist(n))^2 + (yPos-ylist(n))^2);
                if (currentDist > 1)
                    count = count+1;
                    h(count) = plot(xPos, yPos, 'g+');
                    n = i;
                    X0 = [X0; xPos];
                    Y0 = [Y0; yPos];
                    Z0 = [Z0; z];
                end
            end
            
            %pos = h2.getPosition();
            %dist = sqrt((pos(2)-pos(1))^2 + (pos(4) - pos(3))^2);
            %dotnum = dist/1;
            %c = 0;
            %hold on;
            %while (c<dotnum)
            %    a = pos(1) + c*((pos(2) - pos(1))/dotnum);
            %    b = pos(3) + c*((pos(4) - pos(3))/dotnum);
            %    count = count+1;
            %    h(count) = plot(a, b, 'g+');
            %    X0 = [X0; a];
            %    Y0 = [Y0; b];
            %    Z0 = [Z0; z];
            %    c = c+1;
            %end
            delete(h2);
        elseif strcmpi(ip, 'alt')                       %ordered point deletion
            if length(X0)>0
                currentX = 400; currentY = 400; pointNum = 1; i = 1;
                while (i<=length(X0))
                    elmX = X0(i);
                    elmY = Y0(i);
                    dist = sqrt((elmX - x)^2 + (elmY - y)^2);
                    if (dist < sqrt((currentX - x)^2 + (currentY - y)^2))
                        currentX = elmX;
                        currentY = elmY;
                        pointNum = i;
                    end
                    i = i+1;
                end
                X0(pointNum)=[];
                Y0(pointNum)=[];
                Z0(pointNum)=[];
                delete(h(pointNum));
                h(pointNum) = [];
                count = count-1;
                NL = [NL; pointNum];
            end
        elseif strcmpi(ip,'normal')                     %single point addition
            if length(NL) ~= 0
                hold on;
                count = count+1;
                if NL(1) <= 1
                    h= [plot(x, y, 'g+') h(NL(1)+1:end)];
                    X0 = [x; X0(NL(1)+1:end)];
                    Y0 = [y; Y0(NL(1)+1:end)];
                    Z0 = [z; Z0(NL(1)+1:end)];
                    NL(1) = [];
                elseif NL(1)>length(X0)
                    h= [h(1:NL(1)-1) plot(x, y, 'g+')];
                    X0 = [X0(1:NL(1)-1); x];
                    Y0 = [Y0(1:NL(1)-1); y];
                    Z0 = [Z0(1:NL(1)-1); z];
                    NL(1) = [];
                else
                    h= [h(1:NL(1)-1) plot(x, y, 'g+') h(NL(1):end)];
                    X0 = [X0(1:NL(1)-1); x; X0(NL(1):end)];
                    Y0 = [Y0(1:NL(1)-1); y; Y0(NL(1):end)];
                    Z0 = [Z0(1:NL(1)-1); z; Z0(NL(1):end)];
                    NL(1) = [];
                end
            else
                hold on;
                count = count+1;
                h(count)= plot(x, y, 'g+');                           % input of nodes from via mouse left click
                X0 = [X0; x];
                Y0 = [Y0; y];
                Z0 = [Z0; z];
            end
            zx = X0
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


