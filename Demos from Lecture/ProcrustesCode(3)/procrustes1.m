% Script to demo Method of Procrustes for Image Processing Lectures
% Created 2007
% AAB
close all;
% Comments: Script is meant to also demonstrate how to turn an algorithm
% description into a piece of Matlab code...

% Start off with a few points describing a geometric object
xA = [10 20 30 40 30 20 10]; 
yA = [20 40 40 20 0 0 20]; 

h=line(xA,yA);axis([-20 60 -20 60]);set(h,'LineWidth',2);text(xA(1:end-1),yA(1:end-1),{'1','2','3','4','5','6'});

% Now, let us transform this 2D shape by applying a RANDOM transformation
% to the shape: Rotation will be between -pi and pi, translation will be
% between -10 and 10 pixels in the x direction, -20 and 10 in the y
% direction. 

theta = rand; % generates a random number between 0 and 1
theta = theta - 0.5; % scales random number so it lies between -1/2 and 1/2
theta = 2*theta*pi; % scales random number so it lies between -pi and pi

A = [cos(theta) sin(theta);
     -sin(theta) cos(theta)];  % makes rotation matrix

% Make translation vector
Tx = (rand-0.5)*20;  % See above pattern for rotation: same idea
Ty = (rand-0.5)*20;  % See above pattern for rotation: same idea

 % Makes 2xN a matrix containing all N 2D points...
 OriginalCoords = [xA;yA] - [mean(xA);mean(yA)]*ones(1,7) 
                        % ...shifted to origin for rotation

NewCoords = A*OriginalCoords + [Tx Tx Tx Tx Tx Tx Tx;Ty Ty Ty Ty Ty Ty Ty];% Rotate and translate
% Note, could also write the above as A*OriginalCoords + [Tx;Ty]*ones(1,7)
% OR could express the whole process in HOMOGENOUS coordinate system as ONE
% Matrix Operation like this:
% NewCoords = A_h*OriginalCoords_h where 
%             A_h = [cos(theta    sin(theta)   Tx;
%                   -sin(theta)   cos(theta)   Ty;
%                    0              0          1]
%   and OriginalCoords_h =  [OriginalCoords;
%                             ones(1,7);  ] % (See lecture notes)


% extract points into x1 and y1 vectors for plotting

xB = NewCoords(1,:) + mean(xA)*ones(1,7);
yB = NewCoords(2,:) + mean(yA)*ones(1,7);
axis equal

% let's add nose to make this more difficult
xB = xB+randn(size(xB));xB(end)=xB(1);
yB = yB+randn(size(yB));yB(end)=yB(1);

h=line(xB,yB);axis([-20 60 -20 60]);set(h,'LineWidth',2);set(h,'Color','r');
text(xB(1:end-1),yB(1:end-1),{'1','2','3','4','5','6'});

title(['Rotation: ',num2str(theta*180/pi),', Translation: ',num2str([Tx,Ty])]);
legend('Orignal Shape','After Transformation');

disp('Any key to continue');
pause
% method of Procrustes begins here
% We now have two points sets, with known correspondences.  In
% a real situation, we would have just these point sets, with
% correspondence (perhaps determined by a person), and wish to estimate
% Tx and Ty, and the rotation theta that maps one shape onto the other.

%Following the notes (page 134), remove the centroids from each set of
%points (some steps are repeated from above so that things match the notes):
XA = [xA;yA];
muA = mean(XA,2);
XAdash = XA - muA*ones(1,7);


XB = [xB;yB]; 
muB = mean(XB,2);
XBdash = XB - muB*ones(1,7);

% Order these as Nx2 matrices (N points, 2D):
PA = XAdash';
PB = XBdash';

% Compute DxD correlation matrix:
K = PA'*PB;

% Perfrom SVD:
[U,D,V]=svd(K);

% Compute rotation matrix estimate:
R_est = U*V'; % Note this rotates B to A, not A to B; to compare with original

t_est = muA - R_est*muB;   % Note that this gives rotation + translation
                            %WITHOUT shifting A back to the origin.
                            %However, it still registers B points back to A
                            
%%%%%%%%%%%%%%%%%%%%%% END OF COMPUTATION %%%%%%%
                            
% Apply to B points and plot:
XAtest = R_est*(XB) + t_est*ones(1,7)

xAtest = [XAtest(1,:)];
yAtest = [XAtest(2,:)];

% To compare with original transformation


figure;
h=line(xA,yA);axis([-20 60 -20 60]);set(h,'LineWidth',2);text(xA(1:end-1),yA(1:end-1),{'1','2','3','4','5','6'});
h=line(xB,yB);axis([-20 60 -20 60]);set(h,'LineWidth',2);set(h,'Color','r');
text(xB(1:end-1),yB(1:end-1),{'1','2','3','4','5','6'});

h=line(xAtest,yAtest);axis([-20 60 -20 60]);set(h,'LineWidth',2);set(h,'Color','g');
text(xAtest(1:end-1),yAtest(1:end-1),{'1','2','3','4','5','6'});


legend('Orignal Shape','After Transformation','Realignment');
