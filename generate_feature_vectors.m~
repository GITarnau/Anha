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

% first_feature = extract_msd(x);
% second_feature = extract_msd(y); 
speedconf = speedConfinement(x, y);
aspect_ratio = calc_aspect_ratio(x, y);
cardinality = calc_cardinality(x, y);
moment1 = moments_displacement(x,1);
moment2 = moments_displacement(x,2);
moment3 = moments_displacement(x,3);
moment4 = moments_displacement(x,4);
moment5 = moments_displacement(x,5);
moment6 = moments_displacement(x,6);
ymoment1 = moments_displacement(y,1);
ymoment2 = moments_displacement(y,2);
ymoment3 = moments_displacement(y,3);
ymoment4 = moments_displacement(y,4);
ymoment5 = moments_displacement(y,5);
ymoment6 = moments_displacement(y,6);
% num_intersect = calc_intersection_points(x, y);

feature_vector = vertcat(speedconf, aspect_ratio, cardinality,...
    moment1, moment2, moment3, moment4, moment5, moment6,...
    ymoment1, ymoment2, ymoment3, ymoment4, ymoment5, ymoment6);
end

