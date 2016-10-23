%   Mesh display from a *.mat file
% P2=P;
clear all;
FileName = uigetfile('*.mat','Select the body mesh file to open');
load(FileName, '-mat');
[t, normals]    = MyRobustCrust(P);
Quality         = min(simpqual(P, t))
Center = (P(t(:, 1),:)+P(t(:, 2),:)+P(t(:, 3),:))/3;
PP = P';
tt = t';
Xshape = reshape(PP(1, tt(1:3,:)),[3,size(tt,2)]);
Yshape = reshape(PP(2, tt(1:3,:)),[3,size(tt,2)]);
Zshape = reshape(PP(3, tt(1:3,:)),[3,size(tt,2)]);
patch(Xshape, Yshape, Zshape, [1 0.75 0.65], 'EdgeColor', 'k', 'FaceAlpha', 1.0,'FaceColor', [1 0.75 0.65]);
%   hold on;
%   quiver3(Center(:,1),Center(:,2),Center(:,3), ...
%   normals(:,1),normals(:,2),normals(:,3), 0.5, 'color','r');
axis 'equal'; 
%axis 'tight';
xlabel('x, mm'); ylabel('y, mm'); zlabel('z, mm');
% NewName =  strcat(FileName(1:end-4), '_mod', '.mat');
% save(NewName, 'P', 't');
hold on;
plot3(P(:,1),P(:,2),P(:,3),'.b'); grid on;
% save(FileName,'P','t','normals');






