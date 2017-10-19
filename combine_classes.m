function class = combine_classes(classwindow,stepsize)
% this function calculate our accuracy compared to the ground truth

%input: 
% 1. 
% 1 cell array for trajectories
% each element of the cell array is a matrix with motion type for
% each sliding window for one trajectory
% the first cell array is prediction
% the second cell array is ground_truth
% 2.
% stepsize = the number of frames the window moves;

% output: classes a long the frames
ntraject = size(classwindow,2);
class = {};
%disp('ntraject');
%disp(ntraject);
for n = 1:ntraject
%disp(size(classwindow));
windown = size(classwindow{n},1);
tclass = [];
for t = 1:windown
%      disp('t');
%      disp(t);
    if t<windown
        classtmp = classwindow{n}(t,1:stepsize);
        tclass = horzcat(tclass,classtmp);
    end
    if t ==windown
        tclass = horzcat(tclass,classwindow{n}(t,:));
    end
end
class{n} = tclass;
end



            
            
         





