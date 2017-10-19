function sc = speedConfinement(x_traject, y_traject)
% this function calculate features of the trajectory

%input: 2 cell arrays of trajectories
% x_traject{i} = window#i x window size
% all widows have the same size
% same as y_traject

% output: 
% sc = average speed/area of the window 

% size of trajectory
nwind = size(x_traject,1); % number of windows

sc = []; %speedConfinement
% disp('number of windows');
% disp(nwind);
% disp('xtraject');
% disp(x_traject);
for w = 1:nwind
    T = size(x_traject(w,:),2);% frame size
    sctmp = 0;
    for frame = 1:T-1 %  acrross frames
        yt_t = y_traject(w,frame+1) - y_traject(w,frame);
        xt_t = x_traject(w,frame+1) - x_traject(w,frame);
        %disp(yt_t1);
        %disp(xt_t1);
        speedi = sqrt(xt_t^2 + yt_t^2); % speed from frame t to t+1
        sctmp = sctmp + speedi; % sum of speed
    end
    yt_t1 = max(y_traject(w,:)) - min(y_traject(w,:));
    xt_t1 = max(x_traject(w,:)) - min(x_traject(w,:));
    area = yt_t1 *xt_t1;
    sci = sctmp/((T-1)*area);
    sc = vertcat(sc,sci);
end
sc = sc';
end




            
            
         





