function[ax] = plot_dataset(dataset,scale)

    N_data = length(fieldnames(dataset));
    conditions = fieldnames(dataset);
    for i=1:N_data
        title = ['Condition ' num2str(i)];
        plot_data(dataset.(conditions{i}),title,scale)
    end

end