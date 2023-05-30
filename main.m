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

plot_params.scale = 0; %emg signals scaled according to signal with biggest amplitude
plot_params.gait = 'cycle'; % 'cycle' = plot beginning of each cycle, 'swing' = plot left and right swings, 'none' = regular plot
plot_dataset(dataset,plot_params,all_events);

%% 4 Plot simulation
plot_locomotion(dataset.condition_1,all_events.condition_1)

%% 5 Correlation - A remanier pour la mise à jour
gait_time_correlation=getAngleCorrelation(kin_params2,Fs2);
figure(19)
plot(gait_time_correlation.knee)
figure(20)
plot(gait_time_correlation.ankle)

%% 6 Extract gait parameters

kinematic_params = getKinematicParams(dataset,all_events);
