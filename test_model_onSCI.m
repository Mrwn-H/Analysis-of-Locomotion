close all; clear all; clc;

%% load model
load("model_archive/very_decent_inverted_model.mat")

%% load data
uiwait(msgbox("Select the " + ...
    "file to process"));
path = uigetdir;
[dataset_sci,info] = mount_data(path);

%% format data 
Xsci_1L = [dataset_sci.condition_1.LHIP'; 
    dataset_sci.condition_1.LKNE'; 
    dataset_sci.condition_1.LANK'; 
    dataset_sci.condition_1.LTOE'];
Xsci_1R = [dataset_sci.condition_1.RHIP'; 
    dataset_sci.condition_1.RKNE'; 
    dataset_sci.condition_1.RANK'; 
    dataset_sci.condition_1.RTOE'];

%% predict gait phases on SCI data with loaded model 
Ysci_pred_1.L = classify(net,Xsci_1L);
Ysci_pred_1.R = classify(net,Xsci_1R);

%% animation SCI walk + predictions
plot_locomotion_sci(dataset_sci.condition_1, Ysci_pred_1)
% red = swing, blue = stance
