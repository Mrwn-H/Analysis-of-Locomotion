function[ax] = plot_locomotion_sci(data, phases)

marker_raw_datas=struct2cell(data);
marker_raw_datas=marker_raw_datas(find(cellfun(@width,marker_raw_datas)==3));

marker_datas=zeros(length(marker_raw_datas{1}(:,1)),3,8);
for i=1:8
    marker_datas(:,:,i)=marker_raw_datas{i};
end
%% Setting up Simulation
Ts_marker=1/data.marker_sr;
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

plot_L=scatter3(squeeze(marker_datas(1,1,1:4)),squeeze(marker_datas(1,2,1:4)),squeeze(marker_datas(1,3,1:4)),'b','filled');
plot_R=scatter3(squeeze(marker_datas(1,1,5:8)),squeeze(marker_datas(1,2,5:8)),squeeze(marker_datas(1,3,5:8)),'b','filled');




%% Simulation
% for k=2:length(t_marker)-1
for k=2500:length(t_marker)-1

    axis([minx maxx miny maxy minz maxz]);
    
    if phases.L(k) == "swing"
        plot_L.MarkerFaceColor ='b';
    else
        plot_L.MarkerFaceColor ='r';
    end

    if phases.R(k) == "swing"
        plot_R.MarkerFaceColor = 'b';
    else
        plot_R.MarkerFaceColor ='r';
    end


    plot_L.XData=marker_datas(k,1,1:4);
    plot_L.YData=marker_datas(k,2,1:4);
    plot_L.ZData=marker_datas(k,3,1:4);
    plot_R.XData=marker_datas(k,1,5:8);
    plot_R.YData=marker_datas(k,2,5:8);
    plot_R.ZData=marker_datas(k,3,5:8);
    
    %pause(0.001); original
    pause(0.001);
    title(sprintf('Trajectory\nTime: %0.2f sec', t_marker(k)),...
    'Interpreter','Latex');
end

end