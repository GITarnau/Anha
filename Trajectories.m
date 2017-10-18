function [rx, ry, rclass]= Trajectories (sizexy,ntrajectories,circular,drift,diffusion, window_width)

%% set circular/drift/diffusion to 1 or 0
%%
% this function will create simple trajectories by calling that can be used for
% classification and testing  simMultiMotionTypeTrajCIAN
% (numParticles,volumeEdges,totalTime,timeStep,diffCoefRange,
% confRadRange,driftVelRange,durationRange,strictSwitch)


%       volumeEdges  : Edges of volume in which particles reside. A row
%                      vector with number of entries = system
%                      dimensionality.
%       totalTime    : Total time of simulation [time units].
%       timeStep     : Simulation time step [time units].
%       diffCoefRange: Row vector with 2 entries indicating diffusion
%                      coefficient range [(space units)^2/(unit time)].
%       confRadRange : Row vector with 2 entries indicating confinement
%                      radius range [space units].
%       driftVelRange: Row vector with 2 entries indicating drift speed
%                      range [space units/unit time]. Direction chosen
%                      randomly by algorithm.
%       durationRange: 3-by-2 array indicating range of time spent in each
%                      motion category. 1st row: confined diffusion; 2nd
%                      row: free diffusion; 3rd row: drift. 1st column:
%                      shortest duration per category; 2nd column: longest
%                      duration per category. To exclude a category, put
%                      zeros in its row.
%       strictSwitch : 1 to force switching to a different motion type
%                      between segments, 0 to allow switching to the same
%                      motion type but possibly with different parameters.

%defines the type of trajecteries
a=circular;
b=drift;
c=diffusion;


%Defines the confinment of the particles
volumeEdges=[sizexy sizexy];

%defines the range of the total time T, how long the particles travel
t_range=10:190;

%randomly sample from t_range to get a trajectory length
%true allows you to pick the same value
t_length= randsample(t_range,ntrajectories,true);

%Timestep
t_step=1;

%diffusion coeff
D=[1 10];
%confinement range
R=[0.5 5];

%Drift speed
D_s=[1 10];

%Defines an empty cell array
rx={};ry={};rclass={};

%simulate one particale trajectorie
for ind=1: length(t_length)
  t=t_length(ind);
    %duration range of the trajectories
    durationRange=[a*t*0.4 a*0.6*t;b*t*0.4 b*0.6*t;c*t*0.4 c*0.6*t];
 [xCoordMat,yCoordMat,trajClass,errFlag]=simMultiMotionTypeTrajCIAN(1,volumeEdges,t,t_step,D,R,D_s,durationRange,0);
   %r{ind}=[xCoordMat,yCoordMat,trajClass,errFlag];
   [x_trajectories, y_trajectories, motion_class] = ...
    segment_trajectories(xCoordMat, yCoordMat, trajClass, window_width);
    rx{ind} = x_trajectories;
    ry{ind} = y_trajectories;
    rclass{ind} = motion_class;
end
end