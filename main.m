clc
close all
clear all

addpath(genpath('Data'));
addpath(genpath('Functions'));

%% 1 Load Data
uiwait(msgbox("Select the " + ...
    "file to process"));
path = uigetdir;

[dataset,info] = mount_data(path);

%% 2 Get kinematic params
all_events = getAllEvents(dataset,info);

%% 3 Plot Data

plot_params.scale = 1; %emg signals scaled according to signal with biggest amplitude
plot_params.gait = 'none'; % 'cycle' = plot beginning of each cycle, 'swing' = plot left and right swings, 'none' = regular plot
plot_params.envelope = 1;
plot_dataset(dataset,plot_params,all_events);

%% 4 Plot simulation
plot_locomotion(dataset.condition_2,all_events.condition_2)

%% 5 Correlation - A remanier pour la mise à jour
gait_time_correlation=getAngleCorrelation(kin_params2,Fs2);
figure(19)
plot(gait_time_correlation.knee)
figure(20)
plot(gait_time_correlation.ankle)

%% 6 Extract gait parameters

kinematic_params = getKinematicParams(dataset,all_events);
emg_params = getEMGParams(dataset,all_events);

%%
data = dataset.condition_1.LVLat;
figure;
plot(data);
envelope(data,150,'peak');
