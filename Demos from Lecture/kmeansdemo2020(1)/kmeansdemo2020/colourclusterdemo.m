% Script to demonstrate feature space segmentation
% using a k-means algorithm.  The chosen features are
% colour-space coordinates.
load bloodcells;
close all; figure (1);
imagesc(bc1);

disp('First Image');
disp('Any key to continue....');
pause;

R1 = double(bc1(:,:,1));
G1 = double(bc1(:,:,2));
B1 = double(bc1(:,:,3));

X = R1./(R1+G1+B1);
Y = G1./(R1+G1+B1);
Z = B1./(R1+G1+B1);

disp('Feature Space: Trichromatic coefficients');
disp('1/10th of all pixels used (for speed)');
disp('Any key to continue....');
scatter3(X(1:10:end),Y(1:10:end),Z(1:10:end));
pause;

C = [X(1:10:end);Y(1:10:end);Z(1:10:end)]';

[class,mu]=dkmeans(C,2,50);

disp('Feature Space: After 50 iterations of k-means');
disp('Any key to continue....');
scatter3(C(:,1),C(:,2),C(:,3),5,class);
pause;

% Repeat classification with full data set (don't actually need to re-run
% cluster finding....)
C = [X(1:end);Y(1:end);Z(1:end)]';
class = mineudistclassifier(C,mu);


disp('Minimum distance classification based on k-means clusters');
disp('Any key to continue....');
figure(3);
subplot(1,2,1);imagesc(bc1);
subplot(1,2,2);imagesc(-reshape(class,[size(bc2,1),size(bc1,2)]));
pause;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; figure(1);
imagesc(bc2);
disp('Second Image');
disp('Any key to continue....');
pause;


R1 = double(bc2(:,:,1));
G1 = double(bc2(:,:,2));
B1 = double(bc2(:,:,3));

X = R1./(R1+G1+B1);
Y = G1./(R1+G1+B1);
Z = B1./(R1+G1+B1);

disp('Feature Space: Trichromatic coefficients');
disp('1/10th of all pixels used (for speed)');
disp('Any key to continue....');
scatter3(X(1:10:end),Y(1:10:end),Z(1:10:end));
pause;

C = [X(1:10:end);Y(1:10:end);Z(1:10:end)]';

[class,mu]=dkmeans(C,3,50);

disp('Feature Space: After 50 iterations of k-means');
disp('Any key to continue....');
scatter3(C(:,1),C(:,2),C(:,3),5,class);
pause;

% Repeat with full data set (don't actually need to re-run
% cluster finding....)
C = [X(1:end);Y(1:end);Z(1:end)]';
class = mineudistclassifier(C,mu);

figure(2);
subplot(1,2,1);imagesc(bc2);
subplot(1,2,2);imagesc(reshape(class,[size(bc2,1),size(bc1,2)]));
