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
% first check that all trajectories are still valid, remove those that
% aren't
rclass = rclass(~cellfun('isempty',rx));
ry = ry(~cellfun('isempty',rx));
rx = rx(~cellfun('isempty',rx));
num_traj = length(rx);


% loop through trajectories, extract their features
feature_vectors = cell(1, num_traj);
for traj_ind = 1:num_traj
    [feature_vectors{traj_ind}] = generate_feature_vectors(rx{traj_ind}, ry{traj_ind});
end

%% Determine which parameters are useful
goodness = test_features(feature_vectors);
figure()
scatter(1:length(goodness), goodness)
%% TRAIN ECOC SVM-Multiclass




%% Apply ECOC to real data
