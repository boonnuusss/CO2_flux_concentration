load('output_land_plot1850.mat')
CO2_flux_land_year1850_areas = CO2_flux_land_year_areas;
CO2_flux_land_year1850_LON = CO2_flux_land_year_LON;
load('output_land_plot1851.mat')
CO2_flux_land_year1851_areas = CO2_flux_land_year_areas;
CO2_flux_land_year1851_LON = CO2_flux_land_year_LON;
load('output_land_plot1852.mat')
CO2_flux_land_year1852_areas = CO2_flux_land_year_areas;
CO2_flux_land_year1852_LON = CO2_flux_land_year_LON;

h2=figure(1);
% 调整图窗大小
set(h2,'position',[100,100,1200,600])
Marker =  [ [0.0, 0.45, 0.74];  % 蓝色
    [0.85, 0.33, 0.10]; % 红色
    [0.93, 0.69, 0.13]; % 黄色
    [0.47, 0.67, 0.19]; % 浅绿色
    [0.49, 0.18, 0.56]; % 紫色
    [0.30, 0.75, 0.93]; % 青色
    [0.64, 0.08, 0.18]; % 深红
    [0.0, 0.0, 0.55];   % 深蓝色
    [0.5, 0.5, 0.5];    % 深灰
    [0.0, 0.5, 0.0];    % 深绿色
     [0.0, 0.0, 0.0];
    ]; %12种颜色
CO2_flux_land_year_LON_avg = cell(size(CO2_flux_land_year_LON));
for i = 1:length(lat_land)
    CO2_flux_land_year_LON_avg{i} = mean([CO2_flux_land_year1850_LON{i},CO2_flux_land_year1851_LON{i},CO2_flux_land_year1852_LON{i}],2);
  %smooth 
    plot(lat_land{i},smooth(CO2_flux_land_year_LON_avg{i}),'color',Marker(i,:),'LineWidth',2,'DisplayName',model(i))
    hold on
end
legend

for i  = 1:length(model)
    CO2_flux_land_year_area_avg(:,i) = mean([CO2_flux_land_year1850_areas(:,i),CO2_flux_land_year1851_areas(:,i),CO2_flux_land_year1852_areas(:,i)],2);
end
h=figure(2);
% 调整图窗大小
set(h,'position',[100,100,1200,600])
hh = bar(CO2_flux_land_year_area_avg);
for j = 1:length(hh)
    hh(1,j).FaceColor = Marker(j,:);
end
category={'47°S-90°S','23.5°S-47°S','23.5°S-23.5N','23.5°N-47°N','47°N-90°N'};
set(gca,'xticklabel',category)
hold on
xline([1.5 2.5 3.5 4.5],'k--','LineWidth',1.0)
legend(hh,model,'Location','northeastoutside')