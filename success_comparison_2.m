function accuracy = success_comparison_2(prediction,ground_truth,wsize)
% this function calculate our accuracy compared to the ground truth

%input: 2 cell array of motion classes
% the first cell array is prediction
% the second cell array is ground_truth
% wsize = window size;

% output:
%accuracy = vertcat([acctmp,accswitch, traject_length]);

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
        %         if f>eps && f < traject_length - eps % check for switch
        %             predt = prediction{t}(f-1);
        %             trutht = ground_truth{t}(f-1);
        %             if truth ~= trutht
        %                 nswitch = nswitch+1;
        %             end
        %
        %             %unique
        %
        %             %if abs(f - )<  % right prediction
        %             if isequal(unique(prediction{t}(f-eps:f+eps)), unique(ground_truth{t}(f-eps:f+eps)))
        % %                 if predt==trutht
        %                 correctswitch = correctswitch+1;
        %                 disp('f');
        %                 disp(f);
        % %                 end
        %             end
        %         end
    end
    
end
acctmp = correct/traject_length;
% accswitch = -1;
% if nswitch ~= 0
%     accswitch = correctswitch/nswitch;
% end

%for t = 1:traject_num
traject_length = length(prediction{t});
pred = prediction{t};
truth = ground_truth{t};
sw_true = 0;
swtruth = switch_check(truth); % cell array 3 element
swpred = switch_check(pred);% cell array 3 element
sw_total = swtruth{1};
%disp('sw_total'); 
% disp('sw_total, swtruth,swtruth{1},swtruth{2}');
% disp(sw_total);
% disp(swtruth);
% disp(swtruth{1});
% disp(swtruth{2});



% disp(swtruth);
% disp(swpred);
if swtruth{1}>0
    if swpred{1}>0 % predict switch
        for pos = 1:length(swpred{2})
            post = swpred{2}(pos);
            
            
            left = max(1,post-eps);
            if post+eps>=traject_length
                right = post;
            end
            right = post+eps;
%             disp('left right');
%             disp(left);
%             disp(right);
            %windows = [left:1:right];
            for pos_truth = 1:length(swtruth{2});
                pos_truthi = swtruth{2}(pos_truth);
%                 disp('pos_truthi');
%                 disp(pos_truthi);
                if pos_truthi>=left && pos_truthi <=right
                    if (swtruth{3}(pos_truth,1) == (swtruth{3}(pos_truth,1)) && swtruth{3}(pos_truth,2) == swtruth{3}(pos_truth,2))
% disp('found right swithc');

                        sw_true = sw_true+1;
                        disp(sw_true);
                        break
                    end
                end
            end
        end
    end
end
accswitch = -1;
if sw_total>0
    accswitch = sw_true/sw_total;
end

accuracy = vertcat([acctmp,accswitch, traject_length]);

end















