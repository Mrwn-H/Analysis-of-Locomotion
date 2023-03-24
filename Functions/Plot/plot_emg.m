function[ax] = plot_emg(data,fig_title,scale)

    streams = fieldnames(data);
    sf_emg_idx = find(strcmp(streams,'EMG_sr'));
    streams_emg = streams(1:sf_emg_idx-1);
    sf_emg = data.(streams{sf_emg_idx});
    dt_emg = 1/sf_emg;
    
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
    
    figure;
    for i = 1:length(streams_emg)
        sensor = streams_emg{i};
        emg_data = data.(sensor);
        n_samples = length(emg_data);
        time = dt_emg:dt_emg:n_samples*dt_emg;

        subplot(ceil(length(streams_emg)/2),2,vals(i))
        plot(time,emg_data)
        title(sensor)

        if scale
            ylim([val_std(1,1) val_std(1,2)]);
        end

        xlabel('Time [ms]');
        ylabel('EMG [V]');
        sgtitle(fig_title);

    end
end