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

%% 4 Plot simulation
plot_locomotion(cnd,events)

%%

z = dataset.condition_2.LANK(:,3);
figure
plot(z)