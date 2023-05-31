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
        thresh = 230;
        %% Left
        dz = kin_params.LTOE(:,3);
        stance = dz<thresh;
        edges = diff(stance);
        locs_off = find(edges==-1);
        locs_strike = find(edges==1);
        L_events = [];
        for i=1:length(locs_strike)
            new_event = [locs_strike(i),locs_off(find(locs_off>locs_strike(i),1))];
            if length(new_event)==2
                L_events = [L_events; new_event];
            end
        end
%         dz(abs(dz)>2000) = [];
%         [pks,locs] = findpeaks(dz,'MinPeakProminence',3.2*nanmean(abs(dz)),'MinPeakDistance',1.4*Fs,'MinPeakHeight',1.6*nanmean(abs(dz)));
%         [pks_min,locs_min] = findpeaks(-dz ,'MinPeakProminence',2.5*nanmean(abs(dz)),'MinPeakDistance',1.4*Fs);
%         %findpeaks(-1*dz,'MinPeakProminence',0.2*nanmean(abs(dz)),'Annotate','extents');
%         L_events = [];
%         
%         min_bound = 0;
%         for i=1:length(locs)-1
%             %min_bound = locs(i);
%             max_bound = locs(i);
%             if sum(locs_min>min_bound & locs_min<max_bound) == 1
%                 L_events = [L_events; reshape([locs_min(locs_min>min_bound & locs_min<max_bound),locs(i)],1,2)];
%             end
%             min_bound = max_bound;
%         end
    
        %% Right
        dz = kin_params.RTOE(:,3);
        stance = dz<thresh;
        edges = diff(stance);
        locs_off = find(edges==-1);
        locs_strike = find(edges==1);
        R_events = [];
        for i=1:length(locs_strike)
            new_event = [locs_strike(i),locs_off(find(locs_off>locs_strike(i),1))];
            if length(new_event)==2
                R_events = [R_events; [locs_strike(i),locs_off(find(locs_off>locs_strike(i),1))]];
            end
        end
%         dz = diff(kin_params.RANK(:,3))*120;
%         dz = kin_params.RTOE(:,3);
%         dz(abs(dz)>2000) = [];
%         [pks,locs] = findpeaks(dz,'MinPeakProminence',3.2*nanmean(abs(dz)),'MinPeakDistance',1.4*Fs,'MinPeakHeight',1.6*nanmean(abs(dz)));
%         [pks_min,locs_min] = findpeaks(-dz ,'MinPeakProminence',2.5*nanmean(abs(dz)),'MinPeakDistance',1.4*Fs);
%         %findpeaks(-1*dz,'MinPeakProminence',0.2*nanmean(abs(dz)),'Annotate','extents');
%         R_events = [];
%         
%         min_bound = 0;
%         for i=1:length(locs)-1
%             %min_bound = locs(i);
%             max_bound = locs(i);
%             if sum(locs_min>min_bound & locs_min<max_bound) == 1
%                 R_events = [R_events; reshape([locs_min(locs_min>min_bound & locs_min<max_bound),locs(i)],1,2)];
%             end
%             min_bound = max_bound;
%         end
    end
end