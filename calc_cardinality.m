function [num_nodes] = calc_cardinality(x, y)
%CALC_CARDINALITY Summary of this function goes here
%   Detailed explanation goes here
%  [(anything x num_windows)] = calculation(x, y)
%---------- INPUT
%       x : #window x window_width array
%           Contains the x coordinates for a single trajectory. No NaNs.
%       y : #window x window_width array
%           Contains the y coordinates for a single trajectory. No NaNs.
%
%---------- OUTPUT
%       aspect_ratio : 1 x #window array
%           Contains the aspect ratio of the square root of covariance 
%           eigenvalues, where the covariance matrix is formed using the x
%           and y values from each window. Range is [0,1].
% loop through each window
x_size = size(x); num_windows = x_size(1); window_width = x_size(2);
num_nodes = zeros(1, num_windows);
%window_width = x_size(2);
adjacency = zeros(num_windows, num_windows);
for wi=1:num_windows
    xx = x(wi, :);
    yy = y(wi, :);
    for ii=1:window_width
        for jj=1:window_width
            adjacency(ii, jj) = sqrt((xx(ii) - xx(jj))^2 + (yy(ii) - yy(jj))^2);
        end
    end
    % generate graph
    g = graph(adjacency);
    thresh = min(g.Edges.Weight) + 1.5*std(g.Edges.Weight);
    num_nodes(wi) = sum(g.Edges.Weight >= thresh);  %numnodes(g);
end
end

