function[velocity_params]=getVelocityParams(dataset, events)
    conditions = fieldnames(dataset);
    n_cond = length(conditions);
    for i=1:n_cond
        data = dataset.(conditions{i});
        kinematic_params = getKinematicData(data);
        current_events = events.(conditions{i});
        Fs = dataset.(conditions{i}).marker_sr;
        dt=1/Fs;
        L_hip_angle_velocity = [0];
        R_hip_angle_velocity = [0];
        L_knee_angle_velocity = [0];
        R_knee_angle_velocity = [0];
        L_foot_angle_velocity = [0];
        R_foot_angle_velocity = [0];
        
        for j=2:length(kinematic_params.L_ANK_TOE)
            L_hip_angle_velocity = [L_hip_angle_velocity, (kinematic_params.L_hip_angle(j)-kinematic_params.L_hip_angle(j-1))/dt];
            R_hip_angle_velocity = [R_hip_angle_velocity, (kinematic_params.R_hip_angle(j)-kinematic_params.R_hip_angle(j-1))/dt];
            L_knee_angle_velocity = [L_knee_angle_velocity, (kinematic_params.L_knee_angle(j)-kinematic_params.L_knee_angle(j-1))/dt];
            R_knee_angle_velocity = [R_knee_angle_velocity, (kinematic_params.R_knee_angle(j)-kinematic_params.R_knee_angle(j-1))/dt];
            L_foot_angle_velocity = [L_foot_angle_velocity, (kinematic_params.L_foot_angle(j)-kinematic_params.L_foot_angle(j-1))/dt];
            R_foot_angle_velocity = [R_foot_angle_velocity, (kinematic_params.R_foot_angle(j)-kinematic_params.R_foot_angle(j-1))/dt];
        end
        
        % obtain gait cycle segmentation

        L_events = current_events.L_events;
        R_events = current_events.R_events;

        if height(L_events.idx) < height(R_events.idx)
            ref_events = L_events;
            min_length = height(L_events.idx) - 1;
        else
            ref_events = R_events;
            min_length = height(R_events.idx) - 1;
        end
        events_idx = ref_events.idx;
        velocity_tbl = table();

        % Get joint angle information
        min_max_hip_angle_velocity = double.empty(min_length,0);
        min_max_knee_angle_velocity = double.empty(min_length,0);
        min_max_foot_angle_velocity = double.empty(min_length,0);
        
        for k=1:min_length
            min_max_hip_angle_velocity(k,1) = min(L_hip_angle_velocity(events_idx(k,1):events_idx(k+1,1)));
            min_max_hip_angle_velocity(k,2) = min(R_hip_angle_velocity(events_idx(k,1):events_idx(k+1,1)));
            min_max_hip_angle_velocity(k,3) = max(L_hip_angle_velocity(events_idx(k,1):events_idx(k+1,1)));
            min_max_hip_angle_velocity(k,4) = max(R_hip_angle_velocity(events_idx(k,1):events_idx(k+1,1)));
       
            min_max_knee_angle_velocity(k,1) = min(L_knee_angle_velocity(events_idx(k,1):events_idx(k+1,1)));
            min_max_knee_angle_velocity(k,2) = min(R_knee_angle_velocity(events_idx(k,1):events_idx(k+1,1)));
            min_max_knee_angle_velocity(k,3) = max(L_knee_angle_velocity(events_idx(k,1):events_idx(k+1,1)));
            min_max_knee_angle_velocity(k,4) = max(R_knee_angle_velocity(events_idx(k,1):events_idx(k+1,1)));
            
            min_max_foot_angle_velocity(k,1) = min(L_foot_angle_velocity(events_idx(k,1):events_idx(k+1,1)));
            min_max_foot_angle_velocity(k,2) = min(R_foot_angle_velocity(events_idx(k,1):events_idx(k+1,1)));
            min_max_foot_angle_velocity(k,3) = max(L_foot_angle_velocity(events_idx(k,1):events_idx(k+1,1)));
            min_max_foot_angle_velocity(k,4) = max(R_foot_angle_velocity(events_idx(k,1):events_idx(k+1,1)));

        end
        velocity_tbl.l_min_hip_angle_velocity = min_max_hip_angle_velocity(:,1);
        velocity_tbl.r_min_hip_angle_velocity  = min_max_hip_angle_velocity(:,2);
        velocity_tbl.l_max_hip_angle_velocity  = min_max_hip_angle_velocity(:,3);
        velocity_tbl.r_max_hip_angle_velocity  = min_max_hip_angle_velocity(:,3);
        
        velocity_tbl.l_min_knee_angle_velocity  = min_max_knee_angle_velocity(:,1);
        velocity_tbl.r_min_knee_angle_velocity  = min_max_knee_angle_velocity(:,2);
        velocity_tbl.l_max_knee_angle_velocity  = min_max_knee_angle_velocity(:,3);
        velocity_tbl.r_max_knee_angle_velocity  = min_max_knee_angle_velocity(:,4);
        
        velocity_tbl.l_min_foot_angle_velocity  = min_max_foot_angle_velocity(:,1);
        velocity_tbl.r_min_foot_angle_velocity  = min_max_foot_angle_velocity(:,2);
        velocity_tbl.l_max_foot_angle_velocity  = min_max_foot_angle_velocity(:,3);
        velocity_tbl.r_max_foot_angle_velocity  = min_max_foot_angle_velocity(:,4);
        
        velocity_params.(conditions{i}) = velocity_tbl;
    end
end