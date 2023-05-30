%%
clc;
clear all;
close all;
AML01_2kmh=load('C:\Users\haiou\Documents\Analysis of locomotion\Data\Healthy Dataset\01\1_AML01_2kmh.mat');
%% Loading Datas
marker_raw_datas=struct2cell(AML01_2kmh.data);
marker_raw_datas=marker_raw_datas(16:23);

marker_datas=zeros(length(marker_raw_datas{1}(:,1)),3,8);
for i=1:8
    marker_datas(:,:,i)=marker_raw_datas{i};
end
%% Setting up Simulation
Ts_marker=1/AML01_2kmh.data.marker_sr;
t_marker=linspace(0,Ts_marker*length(marker_datas(:,:,1)),length(marker_datas(:,:,1)));
figure; hold on
title(sprintf('Trajectory\nTime: %0.2f sec', t_marker(1)), 'Interpreter', 'Latex');
xlabel('x', 'Interpreter', 'Latex')
ylabel('y', 'Interpreter', 'Latex')
zlabel('z', 'Interpreter', 'Latex')

grid minor  % Adding grid lines
axis equal  % Equal axis aspect ratio
view(-37.5,30);  % Setting viewing angle

minx=min(squeeze(min(marker_datas(:,1,:))-3));
miny=min(squeeze(min(marker_datas(:,2,:))-3));
minz=min(squeeze(min(marker_datas(:,3,:))-3));

maxx=max(squeeze(max(marker_datas(:,1,:))-3));
maxy=max(squeeze(max(marker_datas(:,2,:))-3));
maxz=max(squeeze(max(marker_datas(:,3,:))-3));

plot1=scatter3(squeeze(marker_datas(1,1,:)),squeeze(marker_datas(1,2,:)),squeeze(marker_datas(1,3,:)),'b','filled');




%% Simulation
for k=2:length(t_marker)-1
    axis([minx maxx miny maxy minz maxz]);
    
    plot1.XData=marker_datas(k,1,:);
    plot1.YData=marker_datas(k,2,:);
    plot1.ZData=marker_datas(k,3,:);
    
    pause(0.001);
    title(sprintf('Trajectory\nTime: %0.2f sec', t_marker(k)),...
    'Interpreter','Latex');
end
