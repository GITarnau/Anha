clear all
close all

window_width=20;
%% load and segment data
simulate = 1;

if simulate
    % simulate and segment the data
    sizexy = 100;
    ntrajectories = 10;
    %simulates circular trajectories
    circular=1; drift=0; diffusion=0;
    [rx_c, ry_c, rclass_c] = Trajectories (sizexy,ntrajectories,circular,drift,diffusion, window_width);
    %simulates drift trajectories
    circular=0; drift=1; diffusion=0;
    [rx_dr, ry_dr, rclass_dr] = Trajectories (sizexy,ntrajectories,circular,drift,diffusion, window_width);
    %simulates Diffusion trajectories
    circular=0; drift=0; diffusion=1;
    [rx_di, ry_di, rclass_di] = Trajectories (sizexy,ntrajectories,circular,drift,diffusion, window_width);
    %concatenates all the trajectories
    rx=[rx_c;rx_dr;rx_di];
    ry=[ry_c;ry_dr;ry_di];
    rclass=[rclass_c;rclass_dr;rclass_di];
    rtot=[rx ry rclass];
    
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


%% generates the feature table
Feature_matrix=[];
for ind=1:length(feature_vectors)
    F= feature_vectors{ind};
    Feature_matrix=[Feature_matrix, F];
    
end
% have a matrix of column features and row windows
Feature_matrix=Feature_matrix' ;
labels=[];
for ind=1:length(rclass)
    
    full_labels = rclass{ind}; 
    if length(unique(full_labels))==1
        l=full_labels(:,1);
        labels =[labels; l];
    end
end





%% TRAIN ECOC ( error-correcting output codes) SVM-Multiclass

%Training of ECOC, Tbl is a table containing all the feature values for
%pure trajectories. Trajecteries are column and different features are the
%row of the tablle
%Features is a column vector containing the feature names


Mdl = fitcecoc(Feature_matrix,labels);

%% compares prediction and actual features
predicted_labels=Mdl.predict(Feature_matrix);

[con, order] =confusionmat(labels, predicted_labels);
accuracy= sum(diag(con))/sum(con(:));


%% Apply ECOC to real data
