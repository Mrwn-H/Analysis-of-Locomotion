function [Xtrain, Ytrain, Xtest, Ytest]=split_data(X,Y,train_ratio)

for i = 1:4
    N = length(Y{i}); split_idx = floor(train_ratio*N)
    % fixed partitioning : data until split_idx is training, the rest is testing
    Xtrain{i} = X{i}(:, 1:split_idx); Ytrain{i} = Y{i}(1:split_idx); 
    Xtest{i} = X{i}(:, split_idx:end); Ytest{i} = Y{i}(split_idx:end);
end

%% may be wrong: data loses time dependency if randomly separated
% Xtrain = cell(4,1); Ytrain = cell(4,1);
% Xtest = cell(4,1); Ytest = cell(4,1);
% 
% % Loop over the cells in your cell array
% for i = 1:4
%     % Get the 24-by-N time-series data from this cell
%     time_series = X{i}; events = Y{i};
%     N = length(events);
%     
%     % Create a random partition of the data
%     cvp = cvpartition(N, 'HoldOut', 1 - train_ratio);
%     
%     % Partition the time-series data into training and testing sets
%     Xtrain{i} = time_series(:, cvp.training); Ytrain{i} = events(cvp.training); 
%     Xtest{i} = time_series(:, cvp.test); Ytest{i} = events(cvp.test);
% end
end