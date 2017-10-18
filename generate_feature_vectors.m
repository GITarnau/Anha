function [feature_vector] = generate_feature_vectors(x, y)
%GENERATE_FEATURE_VECTORS Calculates various metrics for a single particle
%trajectory.
%   Detailed explanation goes here
%---------- INPUT
%       x : #window x window_width array
%           Contains the x coordinates for a single trajectory. No NaNs.
%       y : #window x window_width array
%           Contains the y coordinates for a single trajectory. No NaNs.
%
%---------- OUTPUT
%       feature_vector : 
%
%--------------------------------------------------------------------------

%num_windows = size(x); num_windows = num_windows(1);

% CALCULATE FEATURES HERE
% model:
% [(anything x num_windows)] = calculation(x, y)
% step 2 - append to feature array
% vertcat(feature0, feature1, ...);
%first_feature = first_feature_calculation(x,y);

first_feature = extract_msd(x);
second_feature = extract_msd(y); 
speedconf = speedConfinement(x, y);
aspect_ratio = calc_aspect_ratio(x, y);

feature_vector = vertcat(first_feature, second_feature, speedconf,aspect_ratio);
end

