function [x_trajectories, y_trajectories, motion_class] = ...
    segment_trajectories(x, y, traj_class, window_width)
%SEGMENT_TRAJECTORIES segments trajectories and ground truth motion classes
% into sliding windows
% ----------- INPUT: 
%       from simMultiMotionTypeTrajCIAN, by Khuloud Jaqaman, May 2009
%       x  : (Number of particles) - by - (number of time points)
%                     matrix of particle x-coordinates. NaN indicates that
%                     particle does not exist at particular time point.
%       y  : (Number of particles) - by - (number of time points)
%                     matrix of particle y-coordinates. NaN indicates that
%                     particle does not exist at particular time point.
%       traj_class  : (Number of particles) - by - 1 cell array. Each entry
%                    is an M-by-3 matrix where M is number of motion types
%                    exhibited by the particle, and the columns store the
%                    start time, end time and motion type of each segment
%                    exhibiting a different motion type. The motion types
%                    are 1 for confined, 2 for free and 3 for drift. 
%                    Examples: 
%                    (1) Particle exhibits free diffusion from
%                    beginning (frame 1) to end (say frame 100). Its
%                    trajClass = [1 100 2].
%                    (2) Particle exhibits free diffusion from beginning
%                    (frame 1) to frame 50, then switches to confined until
%                    the end (say frame 100). Its trajClass = [1 50 2; 51 
%                    100 1].
% ------------ OUPUT:
%       x_trajectories : 1 x (Number of trajectories) cell array
%           Each cell contains a #windows x #trajectories matrix of x
%           positions.
%       y_trajectories : 1 x (Number of trajectories) cell array
%           Each cell contains a #windows x #trajectories matrix of y
%           positions.
%       motion_class : 1 x (Number of trajectories) cell array
%           Each cell contains a #windows x #trajectories matrix of motion
%           class ground-truths.

x_size = size(x);
num_traj = x_size(1);
%traj_length = x_size(2);

% preallocate outputs
x_trajectories = cell(1, num_traj);
y_trajectories = cell(1, num_traj);
motion_class = cell(1, num_traj);

for ti = 1:num_traj
    % calculate number of windows, dropping NaNs where the track ends
    traj_length = sum(~isnan(x(ti, :)));
    num_windows = 1 + (traj_length - window_width);
    segmented_size = [num_windows, window_width];
    
    % first, expand out ground truth
    num_class_seg = size(traj_class{ti}); num_class_seg = num_class_seg(1);
    ground_truth = zeros(1, traj_length);
    % loop through segments of different motion types
    for ci=1:num_class_seg
        segment_class_info = traj_class{ti}(ci, :);
        mot_class_start = segment_class_info(1);
        mot_class_end = segment_class_info(2);
        ground_truth(mot_class_start:mot_class_end) = segment_class_info(3);
    end
    
    % chop up x, y, and ground_truth
    x_traj = zeros(segmented_size);
    y_traj = zeros(segmented_size);
    mot_class = zeros(segmented_size);
    w_start = 1;
    for wi=1:num_windows
        % recall, x  : (Number of particles) - by - (number of time points)
        x_traj(wi, :) = x(ti, w_start:w_start + window_width - 1);
        y_traj(wi, :) = y(ti, w_start:w_start + window_width - 1);
        mot_class(wi, :) = ground_truth(w_start:w_start + window_width - 1);
        
        % update start position for next window
        w_start = w_start + 1;
    end
    x_trajectories{ti} = x_traj;
    y_trajectories{ti} = y_traj;
    motion_class{ti} = mot_class;
end
end

