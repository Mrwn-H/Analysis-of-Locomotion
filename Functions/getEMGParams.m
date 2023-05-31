function[emg_params] = getEMGParams(dataset,events_tbl)

    extensors_name = ["VLat","RF"];
    flexors_name = ["TA","RF","ST","MG","Sol"];
    
    conditions = fieldnames(dataset);
    
    for i=1:length(conditions)
        events = events_tbl.(conditions{i});
        data = dataset.(conditions{i});
        sensors = fieldnames(data);
        flexors_idx = contains(sensors,flexors_name);
        extensors_idx = contains(sensors,extensors_name);
        flexors = sensors(flexors_idx);
        flexors(contains(flexors,'EMG')) = [];
        extensors = sensors(extensors_idx);

        n_flex = length(flexors);
        n_ext = length(extensors);
        
        L_events = events.L_events;
        R_events = events.R_events;

        if height(L_events.idx) < height(R_events.idx)
            ref_events = L_events;
            min_length = height(L_events.idx) - 1;
        else
            ref_events = R_events;
            min_length = height(R_events.idx) - 1;
        end

        emg_tbl = table();
        % Get joint angle information
        mean_burst_flex = zeros(min_length,2);
        max_burst_flex = zeros(min_length,2);
        burst_dur_flex = zeros(min_length,2);
        mean_burst_ext = zeros(min_length,2);
        max_burst_ext = zeros(min_length,2);
        burst_dur_ext = zeros(min_length,2);

        events_times = ref_events.time; 

        for k=1:min_length
            mean_burst = zeros(n_flex,1);
            max_burst = zeros(n_flex,1);
            burst_dur = zeros(n_flex,1);
            emg_dir = cell(n_flex,1);
            for j=1:n_flex
                emg_data = data.(flexors{j});
                envelope = getEnv(emg_data,data.EMG_sr,0);
                emg_mean = mean(emg_data);
                emg_std = std(emg_data);
                threshold = emg_mean+2*emg_std;
                envelope = envelope(round(events_times(k,1)*data.EMG_sr):round(events_times(k+1,1)*data.EMG_sr));
                burst = envelope(envelope>threshold);
                
                if isempty(burst)
                    mean_burst(j) = 0;
                    max_burst(j) = 0;
                    burst_dur(j) = 0;
                else
                    mean_burst(j) = mean(burst);
                    max_burst(j) = max(burst);
                    burst_dur(j) = length(burst)/data.EMG_sr;
                end

                if flexors{j}(1) == 'L'
                    emg_dir{j} = 'Left';
                else
                    emg_dir{j} = 'Right';  
                end

            end
            mean_burst_flex(k,1) = mean(mean_burst(contains(emg_dir,'Left')));
            mean_burst_flex(k,2) = mean(mean_burst(contains(emg_dir,'Right')));
            max_burst_flex(k,1) = mean(max_burst(contains(emg_dir,'Left')));
            max_burst_flex(k,2) = mean(max_burst(contains(emg_dir,'Right')));
            burst_dur_flex(k,1) = mean(burst_dur(contains(emg_dir,'Left')));
            burst_dur_flex(k,2) = mean(burst_dur(contains(emg_dir,'Right')));

            mean_burst = zeros(n_ext,1);
            max_burst = zeros(n_ext,1);
            burst_dur = zeros(n_ext,1);
            emg_dir = cell(n_ext,1);

            for j=1:n_ext
                emg_data = data.(extensors{j});
                envelope = getEnv(emg_data,data.EMG_sr,0);
                emg_mean = mean(emg_data);
                emg_std = std(emg_data);
                threshold = emg_mean+2*emg_std;
                envelope = envelope(round(events_times(k,1)*data.EMG_sr):round(events_times(k+1,1)*data.EMG_sr));
                burst = envelope(envelope>threshold);

                if isempty(burst)
                    mean_burst(j) = 0;
                    max_burst(j) = 0;
                    burst_dur(j) = 0;
                else
                    mean_burst(j) = mean(burst);
                    max_burst(j) = max(burst);
                    burst_dur(j) = length(burst)/data.EMG_sr;
                end

                if extensors{j}(1) == 'L'
                    emg_dir{j} = 'Left';
                else
                    emg_dir{j} = 'Right';  
                end

            end

            mean_burst_ext(k,1) = mean(mean_burst(contains(emg_dir,'Left')));
            mean_burst_ext(k,2) = mean(mean_burst(contains(emg_dir,'Right')));
            max_burst_ext(k,1) = mean(max_burst(contains(emg_dir,'Left')));
            max_burst_ext(k,2) = mean(max_burst(contains(emg_dir,'Right')));
            burst_dur_ext(k,1) = mean(burst_dur(contains(emg_dir,'Left')));
            burst_dur_ext(k,2) = mean(burst_dur(contains(emg_dir,'Right')));
        end

        emg_tbl.mean_burst_ext_l = mean_burst_ext(:,1);
        emg_tbl.mean_burst_ext_r = mean_burst_ext(:,2);
        emg_tbl.max_burst_ext_l = max_burst_ext(:,1);
        emg_tbl.max_burst_ext_r = max_burst_ext(:,2);
        emg_tbl.burst_dur_ext_l = burst_dur_ext(:,1);
        emg_tbl.burst_dur_ext_r = burst_dur_ext(:,2);
        emg_tbl.mean_burst_flex_l = mean_burst_flex(:,1);
        emg_tbl.mean_burst_flex_r = mean_burst_flex(:,2);
        emg_tbl.max_burst_flex_l = max_burst_flex(:,1);
        emg_tbl.max_burst_flex_r = max_burst_flex(:,2);
        emg_tbl.burst_dur_flex_l = burst_dur_flex(:,1);
        emg_tbl.burst_dur_flex_r = burst_dur_flex(:,2);

        emg_params.(conditions{i}) = emg_tbl; 
    end

end