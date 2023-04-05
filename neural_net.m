close all; clear all; clc;
addpath(genpath('Data'));
addpath(genpath('Functions'));
%% loading data
uiwait(msgbox("Select the " + ...
    "file to process"));
path = uigetdir;
[dataset,info] = mount_data(path);
EMG_sr = 6000;
marker_sr = 120;
all_events = getAllEvents(dataset,info); % Get kinematic params

%% data processing 

[X, Y] = process_data_for_LSTMNN(dataset, all_events); 
train_ratio = 0.8;
[Xtrain, Ytrain, Xtest, Ytest] = split_data(X,Y,train_ratio);

%% defining the neural net

numFeatures = 3*4; % 12 features
numClasses = 2; % the number of classes (swing/stance phase)
numHiddenUnits_lstm = 200;
numHiddenUnits_fcl = 10;

layers = [ ...
    sequenceInputLayer(numFeatures)
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
    'MaxEpochs', 15, ...
    'MiniBatchSize', 32, ...
    'InitialLearnRate', 0.001, ...
    'L2Regularization', 0.01, ...
    'Plots', 'training-progress');

net = trainNetwork(Xtrain, Ytrain, layers, options);

%% testing

Ypred = cell(1,4); acc = []; 
for i=1:4
    Ypred{i} = classify(net,Xtest{i});
    acc = [acc sum(Ypred{i} == Ytest{i})./numel(Ytest{i})];
end

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

save("model_archive/quick_2am_test", "net", "layers", "options", "acc", "Ypred", "Xtest", "Ytest")