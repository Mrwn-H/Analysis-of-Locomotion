function [data,labels] = process_data_for_LSTMNN(dataset,all_events)

% ------ construct data cell array ------

% create a 8-by-1 cell where for each condition (4) and each foot (x2=8)
% is stored a 12-by-experiment_time time series of kinematic sensor data
% 12 = 3D*4markers
data = cell(8,1);
marker_names = fieldnames(dataset.condition_1); 
kin_marker_names = marker_names(16:end-1);
kin_marker_names_L = kin_marker_names(5:end); kin_marker_names_R = kin_marker_names(1:4);

experiment_lengths = [];

% Loop over the fields of the structure and concatenate their data to the data matrix
i=1;
for condition = fieldnames(dataset)'
    for marker_L = kin_marker_names_L'
        data{i} = [data{i}; dataset.(condition{1}).(marker_L{1})'];
    end
    i=i+1; % new foot
    for marker_R = kin_marker_names_R'
        data{i} = [data{i}; dataset.(condition{1}).(marker_R{1})'];
    end
    experiment_lengths = [experiment_lengths length(data{i}) length(data{i})];
    i=i+1; % new condition
end

%% construct cell array of label arrays using all_events structure
% all_events stores arrays like [heel strike column, toe off column]
% 0 for stance, 1 swing
labels = cell(8,1); i=1;
for condition = fieldnames(all_events)'
    for side = fieldnames(all_events.(condition{1}))'
%         current_labels_storage = all_events.(condition{1}).(side{1}).idx;
%         max_idx = length(current_labels_storage(:,1));
%         current_labels = zeros(1,max_idx);
%         % updating labels
%         current_labels( current_labels_storage(:,1) ) = 1;
%         current_labels( current_labels_storage(:,2) ) = -1;
        current_labels_storage = all_events.(condition{1}).(side{1}).idx;
        N = experiment_lengths(i); M = length(current_labels_storage);
        current_labels = zeros(1,N);

%         size(current_labels) % DEBUGGING DEBUGGING DEBUGGING DEBUGGING
        
        % turning event labels into phase labels
        for j = 1:M-1
            % Get the index of the current toe off event and the next heel strike event
            toe_off_idx = current_labels_storage(j, 2);
            heel_strike_idx = current_labels_storage(j+1, 1);
            % Update the labels for the swing phase
            current_labels(toe_off_idx:heel_strike_idx-1) = 1;
        end

%         size(current_labels) % DEBUGGING DEBUGGING DEBUGGING DEBUGGING
    
        % framework requires label array to be in categorical form
        labels{i} = categorical(current_labels,[0 1],{'stance' 'swing'});
        i=i+1; 

%         size(labels{i}) % DEBUGGING DEBUGGING DEBUGGING DEBUGGING
%         keyboard % DEBUGGING DEBUGGING DEBUGGING DEBUGGING
    end
end

end