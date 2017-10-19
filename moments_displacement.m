function md = moments_displacement(traject,k)
% this function calculate kth moment of displacement

%input: a cell array of trajectories
% x_traject{i} = window#i x window size
% all widows have the same size
% k is order of moment, k can be 1 to 6

% output: 
% MSD = u(Tau) = (1/T-tau) * sum((x_i+tau - x_i)^k) i to T-tau
%   for T = total time frames, tau is time lag from [1 2 3 4 5];
%output size: #Tau x #windows

% size of trajectory
nwind = size(traject,1); % number of windows
%disp('number of windows');
%length(traject{1});
taus_num = floor(length(traject(1,:))/4); % length of frame/4
taus = 1:1:taus_num; 
md = [];
% disp('nwind, tausnum, taus');
% nwind
% taus_num
% taus
for t = 1:taus_num;
    tau = taus(t);% tau
    disp_sum = 0;
    u_disp = zeros(1,nwind);
    for w = 1:nwind
        T = size(traject(w,:),2);% window size
        for ii = 1:T - tau
            pos = ii;
            pos_tau = ii+tau;
            dispn = (abs(traject(w,pos_tau)- traject(w,pos)))^k;
%             disp('disp');
%             disp(dispn);
            disp_sum = disp_sum + dispn;
        end
        u_disp(w) = disp_sum/(T-tau);
    end
    md = vertcat(md,u_disp);
end
end


            
            
         





