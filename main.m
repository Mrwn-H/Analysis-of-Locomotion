clc
close all
clear all

addpath(genpath('Data'));
addpath(genpath('Functions'));

%% 1 Load Data
uiwait(msgbox("Select the " + ...
    "file to process"));
path = uigetdir;

dataset = mount_data(path);
dataset_malade=load("/Users/loic/Documents/EPFL/MA1/Locomotion/Project_1/data/Sci_dataset/DM002_TDM_08_2kmh.mat");
dataset_malade.condition_1=dataset_malade.data;
%% 2 Plot Data
scale = 0; %emg signals scaled according to signal with biggest amplitude
plot_dataset(dataset,scale);

%% 3 Get kinematic params
cnd = dataset.condition_1;
kin_params = getKinematicParams(cnd);
Fs = cnd.marker_sr;
[L_events,R_events] = getEvents(kin_params,Fs);
events.L_events = L_events;
events.R_events = R_events;
L_events_t = L_events/120;
R_events_t = R_events/120;
%% Get kinematic malade
%% 3 Get kinematic params
cnd2 = dataset_malade.condition_1;
kin_params2 = getKinematicParams(cnd2);
Fs2 = cnd2.marker_sr;
[L_events2,R_events2] = getEvents(kin_params2,Fs2);
events2.L_events = L_events2;
events2.R_events = R_events2;
L_events_t2 = L_events2/120;
R_events_t2 = R_events2/120;

%% 4 Plot simulation
%plot_locomotion(cnd2,events2)

%% 5 Correlation
gait_time_correlation=getAngleCorrelation(kin_params2,Fs2);
figure(19)
plot(gait_time_correlation.knee)
figure(20)
plot(gait_time_correlation.ankle)


