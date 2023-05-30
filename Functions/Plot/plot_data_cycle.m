function[ax] = plot_data_cycle(data,fig_title,scale,gaits)

    streams = fieldnames(data);
    streams_emg = {};
    streams_markers = {};
    
    for j=1:length(streams)
        if width(data.(streams{j})) == 3
            streams_markers = [streams_markers;streams{j}];
        elseif height(data.(streams{j})) > 1
            streams_emg = [streams_emg;streams{j}];  
        end
    end
    
    sf_emg = data.EMG_sr;
    sf_markers = data.marker_sr;
    
    dt_emg = 1/sf_emg;
    dt_markers = 1/sf_markers;
    
    
    for i = 1:length(streams_emg)
        if streams_emg{i}(1) == 'L'
            val_L = 1:2:length(streams_emg);
        else 
            val_R = 2:2:length(streams_emg);
        end 
    end
    vals = [val_L,val_R];


    val_std = zeros(1,2);
    for j = 1:length(vals)

        max_ = max(data.(streams_emg{j})); 
        min_ = min(data.(streams_emg{j}));

        if min_ < val_std(1,1)
            val_std(1,1) = min_;
        end
        if max_ > val_std(1,2)
            val_std(1,2) = max_;
        end
        
    end
    
    fig = figure;
    [ha, pos] = tight_subplot(ceil(length(streams_emg)/2),2,[.05 .03],[.1 .1],[.05 .05]);
    for i = 1:length(streams_emg)
        current_axis = ha(i);
        sensor = streams_emg{i};
        emg_data = data.(sensor);
        emg_data = preprocess_signal(emg_data);
        n_samples = length(emg_data);
        time = dt_emg:dt_emg:n_samples*dt_emg;
        env = envelope(emg_data,1000);
        %subplot(ceil(length(streams_emg)/2),2,vals(i))
        plot(current_axis,time,emg_data)
        title(current_axis,sensor)

        if scale
            ylim([val_std(1,1) val_std(1,2)]);
        end

        xlabel('Time [ms]');
        ylabel('EMG [V]');
        sgtitle(fig_title);
        
        if ~isempty(gaits)
            hold on
            
            gaits_leftS = gaits.L_events.time(:,1); %Left Foot Strike
            
            y_min = val_std(1);
            y_max = val_std(2);
            %Plotting of left foot strike
            for k1 = 1:length(gaits_leftS)
                xline(current_axis,gaits_leftS(k1),'--r') 
            end  
            
        end
    end
    
    
    %% TO DO: PLOTTING OF MARKERS
    fig = figure;
    for j=1:length(streams_markers)
        sensor = streams_markers{j};
        marker_data = data.(sensor);
        subplot(ceil(length(streams_markers)/2),2,j)

        x = marker_data(:,2);
        x(x==0) = [];
        y = marker_data(:,3);
        y(y==0) = [];

        plot(x,y)
        title(sensor)

        xlabel('axis 1');
        ylabel('axis 2');
        sgtitle(fig_title);
    end

end