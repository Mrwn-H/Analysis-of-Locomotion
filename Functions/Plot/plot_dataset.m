function[ax] = plot_dataset(dataset,plot_params,all_events)

    N_data = length(fieldnames(dataset));
    conditions = fieldnames(dataset);
    for i=1:N_data
        title = ['Condition ' num2str(i)];
        gaits = all_events.(conditions{i});
        %% Plot gait cycles
        %plot_data_cycle(dataset.(conditions{i}),title,scale,gaits)
        %% Plot right and left swing phases 
        plot_data(dataset.(conditions{i}),title,plot_params,gaits)
        
    end

end