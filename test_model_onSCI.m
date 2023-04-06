close all; clear all; clc;

%% load model
load("model_archive/quick_1am_test.mat")

%% load data
uiwait(msgbox("Select the " + ...
    "file to process"));
path = uigetdir;
[dataset_sci,info] = mount_data(path);

%% format data 
Xsci_1L = [dataset_sci.condition_2.LHIP'; 
    dataset_sci.condition_2.LKNE'; 
    dataset_sci.condition_2.LANK'; 
    dataset_sci.condition_2.LTOE'];
Xsci_1R = [dataset_sci.condition_2.RHIP'; 
    dataset_sci.condition_2.RKNE'; 
    dataset_sci.condition_2.RANK'; 
    dataset_sci.condition_2.RTOE'];

%% predict gait phases on SCI data with loaded model 
Ysci_pred_1.L = classify(net,Xsci_1L);
Ysci_pred_1.R = classify(net,Xsci_1R);

%% animation SCI walk + predictions
plot_locomotion_sci(dataset_sci.condition_2, Ysci_pred_1)
% red = swing, blue = stance
% works really well with sci cond_1 and 2, 
% where walking is more normal
