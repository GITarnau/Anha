window_width=20;
%% load and segment data
simulate = 1;
if simulate
    % simulate and segment the data
    sizexy = 100;
    ntrajectories = 10;
    circular=1; drift=1; diffusion=1;

    [rx, ry, rclass] = Trajectories (sizexy,ntrajectories,circular,drift,diffusion, window_width);
    
else
    % load in data
    
    % segment the data
    [x_trajectories, y_trajectories, motion_class] = ...
    segment_trajectories(x, y, traj_class, window_width);
end

%% extract features
% loop through trajectories, extract their features
num_traj = length(rx);
feature_vectors = cell(1, num_traj);
for traj_ind = 1:num_traj
    [feature_vector] = generate_feature_vectors(rx{traj_ind}, ry{traj_ind});
end

%% TRAIN ECOC SVM-Multiclass




%% Apply ECOC to real data
