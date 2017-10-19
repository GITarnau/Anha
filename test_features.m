function [num_significant] = test_features(feature_vector_array, motion_class)
%TEST_FEATURES Summary of this function goes here
%   Detailed explanation goes here

num_traj = length(feature_vector_array);


fv_size = size(feature_vector_array{1});
num_features = fv_size(1);

for fi = 1:num_features
    feature = [];
    class = [];
    
    for ti=1:num_traj
        to_append = feature_vector_array{ti}(fi, :);
        feature = [feature to_append];
        class = [class mode(motion_class{ti}(:))*ones(1,length(to_append))];  %ti*ones(1, length(to_append))];
    end
    
    % now test each feature
    num_significant = zeros(1, num_features);
%     for fi = 1:num_features
    [p,tbl,stats] = kruskalwallis(feature, class, 'off');
    c = multcompare(stats, 'CType','dunn-sidak', 'Display', 'off');
    num_significant(fi) = sum(c(:, end) < 0.05);
%     end
end




% for ti=1:num_traj
%     fvec = feature_vector_array{ti};
%     fv_size = size(feature_vector_array);
%     num_features = fv_size(1); num_windows = fv_size(2);
%     for fi = 1:num_features
%         [p,tbl,stats] = kruskalwallis(horzcat(feature_vectors{4}(end-1, :), feature_vectors{6}(end-1, :)), horzcat(ones(1, length(feature_vectors{4}(end-1, :))), ...
%             2*ones(1, length(feature_vectors{6}(end-1, :)))));
%     end
% end
end

