function[PCA]=computePCA(dataset,all_events)
    dataset=concatenateData(dataset,all_events);
    conditions = fieldnames(dataset);
    n_cond = length(conditions);
    for i=1:n_cond
        parameters=dataset.(conditions{i});
        %PCA=transpose(table2array(parameters));
        [PCA_i.coeff,PCA_i.score,PCA_i.latent,PCA_i.tsquared,PCA_i.explained,PCA_i.mu]=pca(table2array(parameters));
        PCA.(conditions{i})=PCA_i;

        
    end

end