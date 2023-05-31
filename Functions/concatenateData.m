function[parameters] = concatenateData(dataset, all_events)
    %Different type parameters
    velocity_params=getVelocityParams(dataset, all_events);
    kinematic_params=getKinematicParams(dataset, all_events);
    emg_params=getEMGParams(dataset, all_events);
    conditions = fieldnames(dataset);
    n_cond = length(conditions);
    for i=1:n_cond
        parameters.(conditions{i})=[kinematic_params.(conditions{i}), velocity_params.(conditions{i}), emg_params.(conditions{i})];
    end
end