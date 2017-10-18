function [MSD] = extract_msd(traject)
% this function calculate features of the trajectory

%input: a cell array of trajectories
% x_traject{i} = window#i x window size
% all widows have the same size

% output: 
% MSD = u(Tau) = (1/T-tau) * sum((x_i+tau - x_i)^2) i to T-tau
%   for T = total time frames, tau is time lag from [1 2 3 4 5];
%output size: #Tau x #windows

% size of trajectory
nwind = size(traject,1); % number of windows
%disp('number of windows');
%length(traject{1});
taus_num = floor(length(traject(1))/4); % length of frame/4
taus = 1:1:taus_num; 
MSD = [];
%disp('nwind, tausnum, taus');
%nwind
%taus_num
%taus
for t = 1:taus_num;
    tau = taus(t);% tau
    u_tau_sum = 0;
    u_taus = zeros(1,nwind);
    for w = 1:nwind
        T = size(traject(w),2);% window size
        for ii = 1:T - tau
            pos = ii;
            pos_tau = ii+tau;
            ssquare = (traject(w,pos_tau)- traject(w,pos))^2;
            u_tau_sum = u_tau_sum + ssquare;
        end
        u_taus(w) = u_tau_sum/(T-tau);
    end
    MSD = vertcat(MSD,u_taus);
end


            
            
         





