clear all
close all

window_width=20;
%% load and segment data
simulate = 1;
training = 0;
compare = 1;

if simulate
    % simulate and segment the data
    sizexy = 100;
    ntrajectories = 2;
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

%% normalize features
% calculate mean and standard deviation for each feature
% feature_vectors = normalize_features(feature_vectors, rclass);
%% Determine which parameters are useful
% goodness = test_features(feature_vectors, rclass);
% figure()
% scatter(1:length(goodness), goodness)

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
if training
    predicted_labels=Mdl.predict(Feature_matrix);

    [con, order] =confusionmat(labels, predicted_labels);
    accuracy= sum(diag(con))/sum(con(:));
elseif compare
    % load data, x, y, and ground_truth
    load('testDataRearranged4Students.mat')
    [drx, dry] = ...
    segment_only_trajectories(xCoordMat, yCoordMat, window_width);
    % REMOVE NEXT LINE
% %     [drx, dry, dgt] = Trajectories (sizexy,ntrajectories,circular,drift,diffusion, window_width);
%     dgt = dgt(~cellfun('isempty',drx));
%     dry = dry(~cellfun('isempty',drx));
%     drx = drx(~cellfun('isempty',drx));
    num_traj = length(drx);
    

    % loop through trajectories, extract their features
    feature_vectors = cell(1, num_traj);
    for traj_ind = 1:num_traj
        [feature_vectors{traj_ind}] = generate_feature_vectors(drx{traj_ind}, dry{traj_ind});
    end
    % calculate features
    % generates the feature table
    Feature_matrix=[];
    for ind=1:length(feature_vectors)
        F= feature_vectors{ind};
        Feature_matrix=[Feature_matrix, F];

    end
    % have a matrix of column features and row windows
    Feature_matrix=Feature_matrix' ;
%     labels=[];
%     for ind=1:length(dgt)
% 
%         full_labels = dgt{ind}; 
%         if length(unique(full_labels))==1
%             l=full_labels(:,1);
%             labels =[labels; l];
%         end
%     end
    predicted_labels=Mdl.predict(Feature_matrix);
    % need to go from per window ground truth out to full time series
%     merged = {}
%     for ti=1:num_traj
%         num_windows = length(series_class{ti});
% %         merged{ti} = zeros(
%     end
    %% LOAD GROUND TRUTH HERE
    
    [drx, dry, dgt] = ...
    segment_trajectories(x, y, ground_truth, window_width);
    series_class = combine_classes(dgt,1);
    % now need to go from length trajectories out to full time series
    predicted = {};
    % first, package labels into cell array
    t_start = 1;
    for ti=1:num_traj
        num_tpoints = length(series_class{ti});
        num_windows = num_tpoints - window_width + 1;
        ptraj = zeros(1, num_tpoints);
        ptraj(1:num_windows) = predicted_labels(t_start:t_start+num_windows-1);
        ptraj(num_windows + 1:end) = ptraj(num_windows);
        
        % now expand this out, start with begining and end windows
%         plabs = zeros(1, num_windows);
%         plabs(1) = ptraj(1);
%         plabs(end) = ptraj(end);
%         for pi=2:num_windows-1
%             plabels(pi) = ptraj(
%         end
        predicted{ti} = ptraj;
        
        t_start = t_start + num_windows;
    end
    accuracy = success_comparison(predicted, series_class, window_width)
else
    predicted_labels=Mdl.predict(Feature_matrix);
    merged = combine_classes(rclass',1);
    
    accuracy = success_comparison(predicted_labels, ground_truth, window_width)
end


%% Apply ECOC to real data
