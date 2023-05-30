function[dataset,info] = mount_data(path)

    files = dir(path);
    
    if contains(path,'Healthy')
        data_files = files(3:6);
        info = "Healthy";
    else
        data_files = files(3:5);
        info = "SCI";
    end

    N_files = length(data_files);
    dataset = struct();
    for i=1:N_files
        data = load([data_files(i).folder '\' data_files(i).name]);
        dataset.(['condition_' num2str(i)]) = data.data;
    end

end