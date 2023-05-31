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
gait_events = getAllEvents(dataset,info);

%% 3 Plot Data

plot_params.scale = 1; %emg signals scaled according to signal with biggest amplitude
plot_params.gait = 'none'; % 'cycle' = plot beginning of each cycle, 'swing' = plot left and right swings, 'none' = regular plot
plot_params.envelope = 1;
plot_dataset(dataset,plot_params,gait_events);

%% 4 Plot simulation
plot_locomotion(dataset.condition_2,gait_events.condition_2)

%% 5 Correlation - A remanier pour la mise à jour
gait_time_correlation=getAngleCorrelation(kin_params2,Fs2);
figure(19)
plot(gait_time_correlation.knee)
figure(20)
plot(gait_time_correlation.ankle)

%% 6 Extract gait parameters

kinematic_params = getKinematicParams(dataset,gait_events);
emg_params = getEMGParams(dataset,gait_events);

%% Perform for every condition and both subjects
path_healthy = ".\Data\Healthy Dataset\01";
path_sci= ".\Data\SCI Human";
paths = [path_healthy,path_sci];

datasets = struct();
for i=1:length(paths)
    [dataset,info] = mount_data(paths(i));
    datasets.(info) = dataset;
end

subjects = fieldnames(datasets);

parameters_table = table();
for i=1:length(subjects)
    dataset =  datasets.(subjects{i});
    gait_events = getAllEvents(dataset,subjects{i});
    if strcmp(subjects{i},"Healthy")
        merged_data = load(".\healthy_params.mat");
        merged_data = merged_data.merged_data;
    else
        merged_data = concatenateData(dataset,gait_events);
    end
    conditions = fieldnames(merged_data);
    n_cond = length(conditions);
    for k=1:n_cond
        current_table = merged_data.(conditions{k});
        if contains(conditions{k},'TDM')
            if contains(conditions{k},'NoEES')
                label = repmat("SCI_NoEES",height(current_table),1);
            else
                label = repmat("SCI_EES",height(current_table),1);
            end
        else
            label = repmat("Healthy",height(current_table),1);
        end

        current_table.label = label;
        parameters_table = [parameters_table;current_table];

    end
end
%%
params_array = table2array(parameters_table(:,1:end-1));
mean_params = mean(params_array);
std_params = std(params_array);
norm_params = normalize(params_array);
[PCA_i.coeff,PCA_i.score,PCA_i.latent,PCA_i.tsquared,PCA_i.explained,PCA_i.mu]=pca(norm_params);

%%
PCA_decomp = params_array*PCA_i.coeff(:,1:3);
PCA_tbl = array2table(PCA_decomp);
PCA_tbl.label = parameters_table.label;
%2D plot
figure;
gscatter(PCA_tbl.PCA_decomp1,PCA_tbl.PCA_decomp2,PCA_tbl.label)
%%
%3D plot
figure;
s = scatter3(PCA_tbl,'PCA_decomp1','PCA_decomp2','PCA_decomp3','filled');