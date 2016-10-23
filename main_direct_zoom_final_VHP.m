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
start           = 1191;                     % initial image #
stop            = 1211;                     % final image #
step            = 2;                        % read images in steps
crop   = 1.0;                               % cropping selected
Nint            = 0;                        % number of interpolation steps - xy plane is 2^Nint
NintZ           = 0;                        % number of interpolation steps - z direction

%   Main loop
for i = start:step:stop                     % read images in the consequtive order
    count = 0;                              % increment for the handle to plot the nodes
    z       = inc*(ZERONUMBER-i);           % Z co-ordinate for each starting slide in mm
    str1    =  num2str(i);
    name    = strcat('avf', str1, 'b','.png');                      % image name formed as a string
    img     = imread(name);                                         % read image
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
    %IMPORTANT
    waitfor(gcf,'CurrentCharacter',char(13))
    zoom reset
    zoom off
    plot(xx,yy,'.w','MarkerSize',1);                            % mesh grid plotted
    X0 = []; Y0 = []; Z0 = [];
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
        % 1. Detect left click to add points on the images - 'normal' mode
        % 2. Detect right click to delete points one at a time from the
        % exisiting point cloud - 'alt' mode
        % 3. Detect right click on image, if no points to delete; enable
        % contour/chain which is useful for making minor changes to
        % exisiting point cloud from previous image - 'alt' mode
        % 4. Detect shift+left click to enable rectangle mode to select
        % area for the points to be retained within it - 'extend' mode. Default 'normal'
        % mode continous.
        % For more details, search 'selectiontype' in help.
        if strcmpi(ip,'normal')
            hold on;
            count = count+1;
            h(count)= plot(x, y, 'g+');                           % input of nodes from via mouse left click
            X0 = [X0; x];
            Y0 = [Y0; y];
            Z0 = [Z0; z];
        elseif strcmpi(ip,'alt')                                  % 'alt mode' triggered by right mouse click 
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
        elseif strcmpi(ip,'Extend')                                 % Enable rectangular area mode for retaining selected points                            
            h2 = imrect
            pos1 = wait(h2);
            x1 = pos1(1);
            y1 = pos1(2);
            x2 = pos1(3)+x1;
            y2 = pos1(4)+y1;
            layer1 = X(layer) > min(x1,x2) & X(layer) <max(x1,x2);
            layer2 = Y(layer) > min(y1,y2) & Y(layer) <max(y1,y2);
            index = layer1 & layer2;
            X01 = X(layer);
            Y01 = Y(layer);
            X0 = [X0; X01(index)];
            Y0 = [Y0; Y01(index)];
            Z0 = [Z0; z*ones(length(X0),1)];
            hold on;
            count = count+1;
            delete(h2);
            h(count)= plot(X01(index), Y01(index), 'g+');                           % highlight retained points in green         
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


