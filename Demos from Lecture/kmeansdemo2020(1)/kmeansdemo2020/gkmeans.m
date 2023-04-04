function [class,mu] = gkmeans(experiments,K,Niter,icond)
% function class=kmeans(experiments,K,Niter)
% Function to perform kmeans clustering of the vectors in an N-dimensional
% space.  The clustering assigns vectors to the nearest candidate class   
% and recomputes cluster means.
% [M,N]= size (experiments) where M = no of vectors
%				 N = dimension of vector 
%            icond =  changes the condition used for inital cluster
% centres. icond=1 uses the maximum datapoint from the 
% centroid of all data, then the maximum data point 
% from that, an so on...
%
% The only convergence criterion is number of iters, Niter!
% NOTE: this code has some other deficiencies, but it has been written
% to make it accessible rather than to perform rigourous checking (which
% tends to expand the number of lines, obscuring understanding)
% 
% Updated March 2020 to remove display bug and graphics improvements
%
% Clean up my windows
close all

% Set up new figure window
hf = figure(1);
set(hf,'Color','w');

% Get data dimensions
[M,N] = size(experiments);

% First, create a "mu" vector which is set to K vectors of
% the experimental space, provided that they are far apart enough 

if K==1 
	disp('Kind of pointless to seek one cluster');
    mu = [];
    class = [];
    return
end % if

if icond>3
    disp('Unknown initial condition; setting icond to 1')
    icond = 1;
end

% For all initial conditions, idea is to *assume* locations of 
% initial cluster centres; then interations proceed as normal
% i.e. assign points to nearest centre, re-estimate centroids
% etc.

% icond sets initial means to 
   				 % one of FOUR cases for demonstration purposes
                 % Don't worry too much about these - they are not that
                 % relevant - mostly for demo purposes.
                 % Find overall mean
                 
if (icond==1)  % Choose k random *data* points as initial cluster centroids !
   whichpointsascentres = randperm(M);
   for k=1:K
      mu(k,:)=experiments(whichpointsascentres(k),:);
   end;
end; %icond


if (icond==2)  % Choose *really* silly initial cluster centroids !
   for k=1:K
      % The coordinate of the cluster is along the line f_1 = f_2
      % 
      mu(k,:)= k*ones(1,N);
   end;
end; %icond

if (icond==3)    
    % Initialisation option 3: Do a bit of a search process:
    % at each iteration, we find the vector that is furthest
    % from the means of the other vectors. We perform
    % at most K iterations. We then take our second cluster 
    % centre to be shifted relative to the one already
    % taken. Possible Bug: We really
    % should exclude a vector once it has been selected as 
    % being an initial estimate of the kth cluster mean

    mumost = mean(experiments,1);
    for k=1:K
        for m=1:M
            distances(m) = euclid(experiments(m,:),mumost);
        end;
        
        [dmax,idmax] = max(distances);
        mu(k,:) = experiments(idmax,:);
        mumost = (mumost+mu(k,:))/2;
    end;
end %icond == 3

% Now, assign each vector in experimental space to the nearest candidate 
% cluster center
for niter=1:Niter
    [class,distances] = assignpoints(experiments,mu);
 
   % Graphical stuff for demos; only plotted for two-class problem, 2D
   if (K==2)
         dographicsstuff(experiments,class,mu);
   end
        
% Now, recompute cluster centers
    mu=recomputeclustercentres(experiments,class,K);
	
end % Niter
end

function [class,distances] = assignpoints(experiments,mu);
[M,N] = size(experiments);
K = size(mu,1);
for i=1:M
    distances=[];
        for k=1:K
            distances(k) = euclid(experiments(i,:),mu(k,:));
        end
        [dmin,index] = min(distances);

        class(i) = index; % There was a bug here in earlier versions.
end;
end

function  dographicsstuff(experiments,class,mu)
h1 = []; h2 = []; % for graphics handles (pointers to lines)
%Find points of class 1
class1points=experiments(find(class==1),:);
class2points=experiments(find(class==2),:);

% Show the assumed mean, using a fairly largish circle
hm1=plot(mu(1,1),mu(1,2),'o','markersize',10); 
set(hm1,'MarkerFaceColor','b');
hold on

% Now, plot the points themselves
plot(class1points(:,1),class1points(:,2),'bo');

for dp = 1:size(class1points,1)
    h1(dp)=line([class1points(dp,1),mu(1,1)],[class1points(dp,2),mu(1,2)]);
    set(h1(dp),'LineStyle',':','Color','b');
end

hm2=plot(mu(2,1),mu(2,2),'o','markersize',10); 
set(hm2,'MarkerFaceColor','r');

plot(class2points(:,1),class2points(:,2),'rx');
% plot([0 mu(1,1)],[0,mu(1,2)],'b',[0 mu(2,1)],[0,mu(2,2)],'r');
% plot([mu(1,1)],[mu(1,2)],'b-*',[mu(2,1)],[mu(2,2)],'r-*');
for dp = 1:size(class2points,1)
    h2(dp)=line([class2points(dp,1),mu(2,1)],[class2points(dp,2),mu(2,2)]);
end
disp('Hit a key to run another iteration');
xlabel('Feature 1');
ylabel('Feature 2');
set(gca,'FontSize',16);

pause;

hold off ;

for dp = 1:length(h1)
    delete(h1(dp));
end
for dp = 1:length(h2)
    delete(h2(dp));
end
delete(hm1);
delete(hm2);
end % if K
% End of graphical stuff 

function mu=recomputeclustercentres(experiments,class,K);
for k=1:K
    members=(class==k);
    if any(members)
        if sum(members) > 1 % if we have >1 member for this class
            mu(k,:)=mean(experiments(find(members),:));  
        else 
            mu(k,:)=experiments(find(members),:); % NOTE: we don't handle no members....
        end % if
    end; %if
end;
end

