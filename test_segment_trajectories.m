
traj = 1:20;
ground_truth = {[1, 10, 1;
    11, 20, 2]};

[x_trajectories, y_trajectories, motion_class] = ...
    segment_trajectories(traj, traj, ground_truth, 5);