function[ax] = plot_marker(data,fig_title)

    streams = fieldnames(data);
    sf_markers_idx = find(strcmp(streams,'marker_sr'));
    streams_markers = streams(sf_markers_idx+1:end);
    sf_markers = data.(streams{sf_markers_idx});
    dt_markers = 1/sf_markers;

    for i = 1:length(streams_markers)
        if streams_markers{i}(1) == 'L'
            val_L = 1:2:length(streams_markers);
        else 
            val_R = 2:2:length(streams_markers);
        end 
    end
    vals = [val_L,val_R];

    for j=1:length(streams_markers)
        sensor = streams_markers{j};
        marker_data = data.(sensor);
        subplot(ceil(length(streams_markers)/2),2,vals(j))

        x = marker_data(:,1,1);
        y = marker_data(:,2,1);

        plot(x,y)
        title(sensor)

        xlabel('X');
        ylabel('Y');
        sgtitle(fig_title);
    end