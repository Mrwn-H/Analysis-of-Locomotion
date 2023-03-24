function[gaitParams] = getGaitParams(gait_events,fs)

    dt = 1/fs;
    L_events = gait_events.L_events;
    R_events = gait_events.R_events;

    L_cycle_dur = diff(L_events)*dt;
    R_cycle_dur = diff(R_events)*dt;

    L_stance_dur = diff(L_events,1,2)*dt;
    R_stance_dur = diff(R_events,1,2)*dt;

    L_swing_dur = [];
    R_swing_dur = [];

    for i=1:length(L_events)-1
        L_dur = L_events(i+1,1) - L_events(i,2);
        L_swing_dur = [L_swing_dur;L_dur*dt];
    end

    for i=1:length(R_events)-1
        R_dur = R_events(i+1,1) - R_events(i,2);
        R_swing_dur = [R_swing_dur;R_dur*dt];
    end

end