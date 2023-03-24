function[L_events,R_events] = getEvents(kin_params,Fs)
    
    %% Left
    dz = diff(kin_params.L_ANK_TOE(:,3))*120;
    [pks,locs] = findpeaks(dz,'MinPeakHeight',nanmean(abs(dz)),'MinPeakDistance',0.3*Fs);
    %findpeaks(-1*dz,'MinPeakProminence',0.2*nanmean(abs(dz)),'Annotate','extents');
    L_events = [];
    if pks(1) < pks(2)
        i_start = 1;
    else
        i_start = 2;
    end

    locs = locs(pks>0);
    N_events = length(locs(i_start:end));
    for i=i_start:2:N_events
        if i <N_events
            new_first = find( dz(locs(i):locs(i+1)) < 0.25*pks(2), 1 );
            new_second = find( dz(locs(i)+new_first:locs(i+1)) > 0.60*pks(2), 1 );
            L_events = [L_events;[locs(i),locs(i+1)]];
        end
    end

    %% Right
    dz = diff(kin_params.R_ANK_TOE(:,3))*120;
    [pks,locs] = findpeaks(dz,'MinPeakHeight',nanmean(abs(dz)),'MinPeakDistance',0.3*Fs);
    %findpeaks(-1*dz,'MinPeakProminence',0.2*nanmean(abs(dz)),'Annotate','extents');
    R_events = [];
    if pks(1) < pks(2)
        i_start = 1;
    else
        i_start = 2;
    end

    locs = locs(pks>0);
    N_events = length(locs(i_start:end));

    for i=i_start:2:N_events
        if i <N_events
            new_first = find( dz(locs(i):locs(i+1)) < 0.25*pks(2), 1 );
            new_second = find( dz(locs(i)+new_first:locs(i+1)) > 0.60*pks(2), 1 );
            R_events = [R_events;[locs(i),locs(i+1)]];
        end
    end

end