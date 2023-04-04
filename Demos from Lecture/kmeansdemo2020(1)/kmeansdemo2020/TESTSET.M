function y=testset(N,mu,sigma)

% Function to generate an ensemble
% of N random vectors.  Each vector
% will have dimensionality of size(mu)
% and size(sigma).  Gaussian distribution
% Result is a matrix, with each row being
% a random vector from a new
% experiment 
% Repeated calls are necessary for each class of data
% one has

[mmu,nmu]=size(mu);
if (mmu==1)
	mmu=nmu;
end % if

[msigma,nsigma]=size(sigma);
if (msigma==1)
	msigma=nsigma;
end % if

if (msigma~=nmu)
	disp('Error in Mu, Sigma sizes');
	return;
end %if

for n=1:mmu
	y(:,n)=mu(n)+(randn([N,1]))*sigma(n);
end;

