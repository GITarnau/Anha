function accuracy = success_comparison(prediction,ground_truth,wsize)
% this function calculate our accuracy compared to the ground truth

%input: 2 cell array of motion classes
% the first cell array is prediction
% the second cell array is ground_truth
% wsize = window size;

% output:

% size of trajectory
traject_num = size(prediction,2);
accuracy = [];% accuracy vs length
eps = wsize/4;

for t = 1:traject_num
    % for each trajectory, compare between prediction and ground truth
    traject_length = length(prediction{t});
    correct = 0;
    correctswitch = 0;
    nswitch = 0;
    for f = 1:traject_length
        pred = prediction{t}(f);
        truth = ground_truth{t}(f);
        if pred==truth
            correct = correct+1;
        end
        if f>eps && f < traject_length - eps % check for switch
            predt = prediction{t}(f-1);
            trutht = ground_truth{t}(f-1);
            if truth ~= trutht
                nswitch = nswitch+1;
            end
            
            %unique
                
            %if abs(f - )<  % right prediction
            if isequal(unique(prediction{t}(f-eps:f+eps)), unique(ground_truth{t}(f-eps:f+eps)))
%                 if predt==trutht
                correctswitch = correctswitch+1;
                disp('f');
                disp(f);
%                 end
            end
        end
    end

end
acctmp = correct/traject_length;
accswitch = -1;
if nswitch ~= 0
    accswitch = correctswitch/nswitch;
end
accuracy = acctmp;%vertcat([acctmp,accswitch, traject_length]);
end















