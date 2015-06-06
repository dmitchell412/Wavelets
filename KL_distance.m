function result = KL_distance( p,q )
% KL_distance - calculates relative entropy, or Kullback-Liebler distance
%               between input distributions p and q using the KL distance
%               definition:
%                   d_KL=sum(p.*log(p./q))
%
% format:   result = KL_distance( p,q )
%
% input:    p - first probability distribution
%           q - second probability distribution
%
% output:   result - double, Kullback-Liebler distance or relative entropy
%                       between variables p and q
%

p(q==0) = 0;
q(p==0) = 0;
p(p==0) = [];
q(q==0) = [];
result = sum(p.*log(p./q));