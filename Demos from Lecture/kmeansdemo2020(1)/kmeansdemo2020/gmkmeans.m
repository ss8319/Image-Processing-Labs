function [class,mu,K]=gmkmeans(experiments,K,Niter,min_dist)
% function [class,mu,nK]=kmeans(experiments,K,Niter,min_dist)
% Function to perform kmeans clustering
% of the vectors in an N-dimensional
% space.  The clustering assigns vectors 
% to the nearest candidate class   
% and recomputes cluster means.
% [M,N]= size (experiments) where M = no of vectors
%				 N = dimension of vector
%
% K initial clusters are selected 
% Updated for better graphics, and easier initial condition
% March 2020
close all

hf = figure;
set(hf,'Color','w');

LARGEDIST = 1E6;
[M,N] = size(experiments);

% First, create a mu vector
% which is set to K vectors of
% the experimental space, provided that
% they are far apart enough 


% Find overall mean
mumost = mean(experiments);

% Idea here is to find K initial clusters.  At
% each iteration, we find the vector that is furthest
% from the means of the other vectors. We perform
% at most K iterations.  Possible Bug: We must really
% exclude a vector once it has been selected as 
% being an initial estimate of the kth cluster mean
% restofdata = experiments;
% Mrest = M;
% mu(1,:)=mumost;
% for k=2:K
% 	for m=1:Mrest
% 		distances(m) = euclid(restofdata(m,:),mumost);
% 	end;
%     	[dmax,idmax] = max(distances);
% 	mu(k,:)=restofdata(idmax,:);
% 	ind=0;
% 	for m=1:M
% 		if m~=idmax
% 			ind=ind+1;
% 			restofdata(ind,:)=restofdata(m,:);
% 		end % 
% 	end % Removal of estimated centre
% 
%     	mumost = (mumost+mu(k,:))/2;
% end;

% Note - this choice is nice because same point
% can't be taken more than once.
whichpointsascentres = randperm(M);
for k=1:K
   mu(k,:)=experiments(whichpointsascentres(k),:);
end;

% Now, assign each vector in experimental space
% to the nearest candidate cluster
% center

for niter=1:Niter
	for i=1:M
		distances=[];
    		for k=1:K
			distances(k) = euclid(experiments(i,:),mu(k,:));
    		end
    		[dmin,index] = min(distances);
		
    		class(i) = index;
       end;
       
if (K==2)
         scatter(experiments(:,1),experiments(:,2),10,class,'filled');
         colormap([0 0 1;0 1 0; 1 0 0]);

         hold on ;
         plot([0 mu(1,1)],[0,mu(1,2)],'b',[0 mu(2,1)],[0,mu(2,2)],'r');
         plot([mu(1,1)],[mu(1,2)],'b-*',[mu(2,1)],[mu(2,2)],'r-*');
         xlabel('Feature 1');
         ylabel('Feature 2');
         set(gca,'FontSize',16);
         disp('Hit a key to run another iteration');
         pause;
         
         hold off ;
end % if K
if (K==3)
         scatter(experiments(:,1),experiments(:,2),10,class,'filled');
         colormap([0 0 1;0 1 0; 1 0 0])
         hold on ;
         plot([0 mu(1,1)],[0,mu(1,2)],'b',[0 mu(2,1)],[0,mu(2,2)],'g',[0 mu(3,1)],[0,mu(3,2)],'r');
         plot([mu(1,1)],[mu(1,2)],'b-*',[mu(2,1)],[mu(2,2)],'g-*',[mu(3,1)],[mu(3,2)],'r-*');
         xlabel('Feature 1');
         ylabel('Feature 2');
         set(gca,'FontSize',16);
         pause;
         hold off ;
end % if K


% Now, recompute cluster centers

	for k=1:K
		members=(class==k);
		if any(members)
			if members*ones([M,1]) > 1
				mu(k,:)=mean(experiments(find(members),:));  
			else 
				mu(k,:)=experiments(find(members),:);
			end % if
		end; %if
	end;

%  First, compute the distances between all cluster pairs	
	dist=LARGEDIST*ones(K);
	for k=1:K-1
		for j=k+1:K
			dist(j,k)=euclid(mu(j,:),mu(k,:));
		end
	end
	
	%  Now, find the the two nearest
	%  cluster centres, and if they are
	%  below a minimum distance, merge them
	[smallest,i]=min(dist);
	[p,q]=min(smallest);
	whos
	if (p<min_dist)
		pair=[q, i(q)];

		oldmu=mu;
		mu=zeros([K-1,N]);

		index=0;
		for i=1:K
			if (i~=q) & (i~=i(q))
				index=index+1;
				mu(index,:)=muold(i,:);
			end;
		end;

		K=K-1

	% Using old class memberships here!  Need to re-write this as it is
	% opaque as mud....
		njs=sum(find(class==q)); 
		nks=sum(find(class==i(q)));
		mu(K,:)=(njs*oldmu(q,:)+nks*oldmu(i(q),:))/(njs+nks);

		mu
	end % Cluster merging

end % Niter
