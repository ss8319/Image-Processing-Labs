function [class,mu]=kmeans(experiments,K,Niter)
% function class=kmeans(experiments,K,Niter)
% Function to perform kmeans clustering
% of the vectors in an N-dimensional
% space.  The clustering assigns vectors 
% to the nearest candidate class   
% and recomputes cluster means.
% [M,N]= size (experiments) where M = no of vectors
%				 N = dimension of vector 

[M,N] = size(experiments);

% First, create a mu vector
% which is set to K vectors of
% the experimental space, provided that
% they are far apart enough 

if K==1 
	disp('Classes all set to 1');
	for i=1:M
		class(i)=1;
	end
	return;
end % if

% Find overall mean
mumost = mean(experiments);

% Idea here is to find K initial clusters.  At
% each iteration, we find the vector that is furthest
% from the means of the other vectors. We perform
% at most K iterations.  Possible Bug: We really
% exclude a vector once it has been selected as 
% being an initial estimate of the kth cluster mean
restofdata = experiments;

for k=1:K
	for m=1:M
		distances(m) = euclid(experiments(m,:),mumost);
	end;
    	[dmax,idmax] = max(distances);
	mu(k,:)=experiments(idmax,:);
    	mumost = (mumost+mu(k,:))/2;
end;
disp('mu =');
mu

% Now, assign each vector in experiemtal space
% to the nearest candidate cluster
% center

for niter=1:Niter
	for i=1:M
		distances=[];
    		for k=1:K
			distances(k) = euclid(experiments(i,:),mu(k,:));
    		end
    		[dmin,k] = min(distances);
		
    		class(i) = k;
	end;

% Now, recompute cluster centers

	for k=1:K
		members=(class==k);
		if any(members)
                        if sum(members) > 1
				mu(k,:)=mean(experiments(find(members),:));  
			else 
				mu(k,:)=experiments(find(members),:);
			end % if
		end; %if
	end;

end % Niter
