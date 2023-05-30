function[all_events] = getAllEvents(dataset,info)
    
    conditions = fieldnames(dataset);
    all_events = struct();
    for i=1:length(conditions)
        cnd = dataset.(conditions{i});
        kin_params = getKinematicData(cnd);
        Fs = cnd.marker_sr;
        [L_events,R_events] = getEvents(kin_params,Fs,info);
        events.L_events.idx = L_events;
        events.R_events.idx = R_events;
        L_events_t = L_events/Fs;
        R_events_t = R_events/Fs;
        events.L_events.time = L_events_t;
        events.R_events.time = R_events_t;
        all_events.(conditions{i}) = events;
    end

end