function [aspect_ratio] = calc_aspect_ratio(x, y)
%CALC_ASPECT_RATIO Calculates aspect ratio of a trajectory using covariance
%eigenvalues
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
x_size = size(x); num_windows = x_size(1);
aspect_ratio = zeros(1, num_windows);
%window_width = x_size(2);
for wi=1:num_windows
    covariance_mat = cov(x(wi, :), y(wi, :));
    e = eig(covariance_mat); e = sort(e);
    aspect_ratio(wi) = sqrt(e(1))/sqrt(e(2));
end

