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

plot_params.scale = 0; %emg signals scaled according to signal with greatest amplitude
plot_params.gait = 'none'; % 'cycle' = plot beginning of each cycle, 'swing' = plot left and right swings, 'none' = regular plot
plot_params.envelope = 0;
plot_dataset(dataset,plot_params,gait_events);

%% 4 Plot simulation
conditions = fieldnames(dataset);
plot_locomotion(dataset.(conditions{1}),gait_events.(conditions{1}))

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
compute_params_healthy = 0;
compute_params_SCI = 0;
parameters_table = table();
for i=1:length(subjects)
    dataset =  datasets.(subjects{i});
    gait_events = getAllEvents(dataset,subjects{i});
    if strcmp(subjects{i},"Healthy") 
        if isfile(".\healthy_params.mat") && ~compute_params_healthy
            merged_data = load(".\healthy_params.mat");
            merged_data = merged_data.merged_data;
        else
            merged_data = concatenateData(dataset,gait_events);
        end
    else
        if isfile(".\sci_params.mat") && ~compute_params_SCI
            merged_data = load(".\sci_params.mat");
            merged_data = merged_data.merged_data;
        else
            merged_data = concatenateData(dataset,gait_events);
        end
    end
    conditions = fieldnames(merged_data);
    n_cond = length(conditions);
    for k=1:n_cond
        current_table = merged_data.(conditions{k});
        if contains(conditions{k},'TDM')
            if contains(conditions{k},'NoEES')
                label = repmat("SCI NoEES",height(current_table),1);
            else
                label = repmat("SCI EES",height(current_table),1);
            end
        else
            label = repmat("Healthy",height(current_table),1);
        end

        current_table.label = label;
        parameters_table = [parameters_table;current_table];

    end
end


%%
PCA_decomp = norm_params*PCA_i.coeff(:,1:3);
PCA_tbl = array2table(PCA_decomp);
PCA_tbl.label = new_param_table.label;
%2D plot
figure;
gscatter(PCA_tbl.PCA_decomp1,PCA_tbl.PCA_decomp2,PCA_tbl.label)
xlabel('PC 1');
ylabel('PC 2');
title('PCA Representation');
%%
%3D plot
figure;
s = scatter3(PCA_tbl,'PCA_decomp1','PCA_decomp2','PCA_decomp3','filled');

%% Plot without burst parameters
%parameters_table = load(".\parameters_table.mat");
new_param_table = parameters_table(parameters_table.gait_dur>0.,:);
removed_params = new_param_table.Properties.VariableNames(contains(new_param_table.Properties.VariableNames,'burst'));
new_param_table = removevars(new_param_table,removed_params);
new_param_table.label = parameters_table.label;


params_array = table2array(new_param_table(:,1:end-1));

mean_params = mean(params_array);
std_params = std(params_array);
norm_params = normalize(params_array);
[PCA_i.coeff,PCA_i.score,PCA_i.latent,PCA_i.tsquared,PCA_i.explained,PCA_i.mu]=pca(norm_params);

figure;
score = PCA_i.score;
label = new_param_table.label;

pc1=score(:,1);
pc2=score(:,2);
gscatter(pc1,pc2,PCA_tbl.label)
xlabel('PC 1');
ylabel('PC 2');
title('PCA Representation - No EMG parameters');

[out,idx] = sort(PCA_i.coeff(:,1),'descend');
pc1_coeffs = out;
col_names = new_param_table.Properties.VariableNames(1:end-1);
ordered_params = col_names(idx).';
parameter_importance = table(pc1_coeffs,ordered_params);
%% Plot with burst parameters
params_array = table2array(parameters_table(:,1:end-1));

mean_params = mean(params_array);
std_params = std(params_array);
norm_params = normalize(params_array);
[PCA_i.coeff,PCA_i.score,PCA_i.latent,PCA_i.tsquared,PCA_i.explained,PCA_i.mu]=pca(norm_params);

figure;
score = PCA_i.score;
label = parameters_table.label;

pc1=score(:,1);
pc2=score(:,2);
gscatter(pc1,pc2,PCA_tbl.label)
xlabel('PC 1');
ylabel('PC 2');
title('PCA Representation - All parameters');

[out,idx] = sort(PCA_i.coeff(:,1),'descend');
pc1_coeffs = out;
col_names = parameters_table.Properties.VariableNames(1:end-1);
ordered_params = col_names(idx).';
parameter_importance = table(pc1_coeffs,ordered_params);
%% Histo
figure;
data = PCA_i.explained(1:2);
[n,x] = hist(data);
barstrings = ['PC1','PC2'];
% Create text objects at each location
text(x,n,barstrings,'horizontalalignment','center','verticalalignment','bottom')
%%
figure;
% Create random data for the sake of the example
data = 10*rand(1,100);
% Draw the histogram
hist(data);
% Get information about the same 
% histogram by returning arguments
[n,x] = hist(data);
% Create strings for each bar count
barstrings = num2str(n');
% Create text objects at each location
text(x,n,barstrings,'horizontalalignment','center','verticalalignment','bottom')
