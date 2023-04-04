function class = mineudistclassifier(experiments,mu);
[M,N1] = size(experiments);
[K,N2] = size(mu);

% Sanity check: dimensionality of cluster centres should be the same
% as that of each observation vectors...
if (N1 ~= N2) 
    error('mineudistclassifier: Something wrong in dimensions...');
end

for i=1:M
	distances=[];
    for k=1:K
    	distances(k) = euclid(experiments(i,:),mu(k,:));
    end
    [dmin,k] = min(distances);
    class(i) = k;
end;