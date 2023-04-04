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

LARGEDIST = 1E6;
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
% at most K iterations.  Possible Bug: We must really
% exclude a vector once it has been selected as 
% being an initial estimate of the kth cluster mean
restofdata = experiments;
Mrest = M;
mu(1,:)=mumost;
for k=2:K
	for m=1:Mrest
		distances(m) = euclid(restofdata(m,:),mumost);
	end;
    	[dmax,idmax] = max(distances);
	mu(k,:)=restofdata(idmax,:);
	ind=0;
	for m=1:M
		if m~=idmax
			ind=ind+1;
			restofdata(ind,:)=restofdata(m,:);
		end % 
	end % Removal of estimated centre

    	mumost = (mumost+mu(k,:))/2;
end;

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
       
if (K==2)
         scatter(experiments(:,1),experiments(:,2),5,class,'filled');
         hold on ;
         plot([0 mu(1,1)],[0,mu(1,2)],'b-*',[0 mu(2,1)],[0,mu(2,2)],'r-*');
         pause;
         hold off ;
end % if K
if (K==3)
         scatter(experiments(:,1),experiments(:,2),5,class,'filled');
         hold on ;
         plot([0 mu(1,1)],[0,mu(1,2)],'b-*',[0 mu(2,1)],[0,mu(2,2)],'r-*',[0 mu(3,1)],[0,mu(3,2)],'g-*');
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

	% Using old class memberships here!
		njs=sum(find(class==q)); 
		nks=sum(find(class==i(q)));
		mu(K,:)=(njs*oldmu(q,:)+nks*oldmu(i(q),:))/(njs+nks);

		mu
	end % Cluster merging

end % Niter
