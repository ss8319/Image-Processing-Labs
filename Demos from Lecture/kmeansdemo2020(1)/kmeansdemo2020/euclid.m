function d2 = euclid(x1,x2)
% Function to compute euclidean distance between
% two N-dimensional vectors, x1 and x2
% Updated March 2020 to get rid of pointless check

N = max(size(x1));
if (N ~= max(size(x2)))
	disp('Error in euclid()');
	return;
end % if

% Compute signed distance
d=x1-x2;

% Sqr of sum of square distance
d2=sqrt(sum(d.^2));
