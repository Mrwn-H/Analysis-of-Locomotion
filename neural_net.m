close all; clear all; clc;
addpath(genpath('Data'));
addpath(genpath('Functions'));
%% loading data
% uiwait(msgbox("Select the " + ...
%     "file to process"));
path = "data/Healthy Dataset/01";
[dataset1,info] = mount_data(path);
EMG_sr = 6000;
marker_sr = 120;
all_events1 = getAllEvents(dataset1,info); % Get kinematic params

path = "data/Healthy Dataset/02";
[dataset2,info] = mount_data(path);
EMG_sr = 6000;
marker_sr = 120;
all_events2 = getAllEvents(dataset2,info); % Get kinematic params
%% data processing 

[X1, Y1] = process_data_for_LSTMNN(dataset1, all_events1); 
[X2, Y2] = process_data_for_LSTMNN(dataset2, all_events2); 
X = [X1; X2]; Y = [Y1; Y2];
train_ratio = 0.8;
[Xtrain, Ytrain, Xtest, Ytest] = split_data(X,Y,train_ratio,"both");

%% defining the neural net

numFeatures = 3*4; % 12 features
numClasses = 2; % the number of classes (swing/stance phase)
numHiddenUnits_lstm = 100;
numHiddenUnits_fcl = 10;
filterSize = 35; numFilters = 10;

layers = [ ...
    sequenceInputLayer(numFeatures,'Normalization','rescale-zero-one')

    convolution1dLayer(filterSize,numFilters,'Padding','same',NumChannels=12)
    batchNormalizationLayer

    lstmLayer(numHiddenUnits_lstm,'OutputMode','sequence')
    batchNormalizationLayer

    fullyConnectedLayer(numHiddenUnits_fcl)
    batchNormalizationLayer
    reluLayer

    fullyConnectedLayer(numClasses)
    sigmoidLayer
    classificationLayer];

%% training

% Specify training options
options = trainingOptions('adam', ...
    'MaxEpochs', 20, ...
    'MiniBatchSize', 100, ...
    'InitialLearnRate', 0.01, ...
    'L2Regularization', 0.01, ...
    'ExecutionEnvironment', 'parallel',...
    'Plots', 'training-progress');

net = trainNetwork(Xtrain, Ytrain, layers, options);

%% testing

Ypred = cell(1,4); acc = []; 
for i=1:4
    Ypred{i} = classify(net,Xtest{i});
    acc = [acc sum(Ypred{i} == Ytest{i})./numel(Ytest{i})];
end
acc
%% testing on healthy patient 2

uiwait(msgbox("Select the " + ...
    "file to process"));
path = uigetdir;
[dataset_sci,info] = mount_data(path);
all_events = getAllEvents(dataset_sci,info); % Get kinematic params

[X_sci, Y_sci] = process_data_for_LSTMNN(dataset, all_events); 

Ypred_sci = cell(1,4); acc = []; 
for i=1:4
    Ypred_sci{i} = classify(net,X_sci{i});
    acc = [acc sum(Ypred_sci{i} == Ytest{i})./numel(Ytest{i})];
end

%% save model

save("model_archive/first_LSTMplusCNN", "net", "layers", "options", "acc", "Ypred", "Xtest", "Ytest")