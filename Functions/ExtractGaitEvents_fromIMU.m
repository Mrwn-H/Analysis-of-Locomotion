% Add function description
%
% Input(s):
% - 
% 
% Output(s):
% - 

function [Events,posSplit] = ExtractGaitEvents_fromIMU(signal)


vector_time = signal.time; 
dt = round(vector_time(2)-vector_time(1)); % duration between two timepoints
fs = (vector_time(end)-vector_time(1)) / length(vector_time);

f=fieldnames(signal);
posSplit={signal.(f{find(cellfun(@(x) x(1)=='L',f),1)}), ...
    signal.(f{find(cellfun(@(x) x(1)=='R',f),1)})};
Ld = smooth(posSplit{1},round(dt)); %fs ?
Ld=Ld-nanmean(posSplit{1});
Rd = smooth(posSplit{2},round(dt)); % fs ?
Rd=Rd-nanmean(posSplit{2});

%% Initialize Parameters
n = 1;
m = 1;

%% Start Event Detection
% find positive and negative peaks separated by at least 0.1*Fs 
[~,IndR] = findpeaks(abs(Rd),'MinPeakProminence',0.2*nanmean(abs(Rd)),'MinPeakDistance', 0.2*fs); %dt*2
[~,IndL] = findpeaks(abs(Ld),'MinPeakProminence',0.2*nanmean(abs(Ld)),'MinPeakDistance', 0.2*fs);
PPR=IndR(Rd(IndR)>0); PPL=IndL(Ld(IndL)>0);
threhsold=@(x,y) y(x(y)>mean(x(y)));
% identify positive peaks above threshold for right and left sides
PPR=threhsold(Rd,PPR); PPL=threhsold(Ld,PPL);

Events.RFS = [];
Events.RFO = [];
Events.LFS = [];
Events.LFO = [];

% for each identified positive peak, find negative peak before and after
for i = PPL'
    
    [~,IndLvs] = findpeaks(abs(Ld),'MinPeakProminence',0.2*nanmean(abs(Ld)));
    event_before=IndL(find(IndL<i,1,'last'));
    % event after can be closer than 0.1*Fs of positive peak
    event_after=IndLvs(find(IndLvs>i,1,'first'));
    if Ld(event_before)<0 && Ld(event_after)<0
        Events.LFO(n) = vector_time(event_before); n=n+1;
        Events.LFS(n) = vector_time(event_after);
    elseif Ld(event_before)<0
        Events.LFO(n) = vector_time(event_before);
    elseif Ld(event_after)<0
        Events.LFS(n) = vector_time(event_after);
    end
    n = n+1;
    
end

for j = PPR'
    
    [~,IndRvs] = findpeaks(abs(Rd),'MinPeakProminence',0.2*nanmean(abs(Rd)));
    event_before=IndR(find(IndR<j,1,'last'));
    event_after=IndRvs(find(IndRvs>j,1,'first'));
    if Rd(event_before)<0 && Rd(event_after)<0
        Events.RFO(m) = vector_time(event_before); m=m+1;
        Events.RFS(m) = vector_time(event_after);
    elseif Rd(event_before)<0
        Events.RFO(m) = vector_time(event_before);
    elseif Rd(event_after)<0
        Events.RFS(m) = vector_time(event_after);
    
    end
    m = m+1;
    
end

end