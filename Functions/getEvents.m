function[L_events,R_events] = getEvents(kin_params,Fs,info)
    if strcmp(info,"Healthy")
        
        %% Left
        dz = diff(kin_params.L_ANK_TOE(:,3))*120;
        dz(abs(dz)>2000) = [];
        [pks,locs] = findpeaks(dz,'MinPeakProminence',1.2*nanmean(abs(dz)),'MinPeakDistance',0.3*Fs,'MinPeakHeight',nanmean(abs(dz)));
        
        [pks_min,locs_min] = findpeaks(-dz,'MinPeakProminence',1.2*nanmean(abs(dz)),'MinPeakDistance',0.3*Fs,'MinPeakHeight',1.5*nanmean(abs(dz)));
        %findpeaks(-1*dz,'MinPeakProminence',0.2*nanmean(abs(dz)),'Annotate','extents');
        L_events = [];
        for i=1:length(locs_min)-1
            min_bound = locs_min(i);
            max_bound = locs_min(i+1);
            if i==62
                a = 0;
            end
            if sum(locs>min_bound & locs<max_bound) == 2
                L_events = [L_events; reshape(locs(locs>min_bound & locs<max_bound),1,2)];
            end
        end
    
        %% Right
        dz = diff(kin_params.R_ANK_TOE(:,3))*120;
        dz(abs(dz)>2000) = [];
        [pks,locs] = findpeaks(dz,'MinPeakProminence',1.2*nanmean(abs(dz)),'MinPeakDistance',0.3*Fs,'MinPeakHeight',nanmean(abs(dz)));
        
        [pks_min,locs_min] = findpeaks(-dz,'MinPeakProminence',1.2*nanmean(abs(dz)),'MinPeakDistance',0.3*Fs,'MinPeakHeight',1.5*nanmean(abs(dz)));
        %findpeaks(-1*dz,'MinPeakProminence',0.2*nanmean(abs(dz)),'Annotate','extents');
        R_events = [];
    
        for i=1:length(locs_min)-1
            min_bound = locs_min(i);
            max_bound = locs_min(i+1);
            if sum(locs>min_bound & locs<max_bound) == 2
                R_events = [R_events; reshape(locs(locs>min_bound & locs<max_bound),1,2)];
            end
        end
    else
        %% Left
        dz = diff(kin_params.LANK(:,3))*120;
        dz(abs(dz)>2000) = [];
        [pks,locs] = findpeaks(dz,'MinPeakProminence',3*nanmean(abs(dz)),'MinPeakDistance',1.2*Fs,'MinPeakHeight',1.2*nanmean(abs(dz)));
        
        [pks_min,locs_min] = findpeaks(-dz ,'MinPeakProminence',3*nanmean(abs(dz)),'MinPeakDistance',1.2*Fs);
        %findpeaks(-1*dz,'MinPeakProminence',0.2*nanmean(abs(dz)),'Annotate','extents');
        L_events = [];
        for i=1:length(locs_min)-1
            min_bound = locs_min(i);
            max_bound = locs_min(i+1);
            if sum(locs>min_bound & locs<max_bound) == 1
                L_events = [L_events; reshape([locs_min(i),locs(locs>min_bound & locs<max_bound)],1,2)];
            end
        end
    
        %% Right
        dz = diff(kin_params.RANK(:,3))*120;
        dz(abs(dz)>2000) = [];
        [pks,locs] = findpeaks(dz,'MinPeakProminence',3*nanmean(abs(dz)),'MinPeakDistance',1.2*Fs,'MinPeakHeight',1.2*nanmean(abs(dz)));
        
        [pks_min,locs_min] = findpeaks(-dz ,'MinPeakProminence',3*nanmean(abs(dz)),'MinPeakDistance',1.2*Fs);
        %findpeaks(-1*dz,'MinPeakProminence',0.2*nanmean(abs(dz)),'Annotate','extents');
        R_events = [];
    
        for i=1:length(locs_min)-1
            min_bound = locs_min(i);
            max_bound = locs_min(i+1);
            if sum(locs>min_bound & locs<max_bound) == 1
                R_events = [R_events; reshape([locs_min(i),locs(locs>min_bound & locs<max_bound)],1,2)];
            end
        end
    end
end