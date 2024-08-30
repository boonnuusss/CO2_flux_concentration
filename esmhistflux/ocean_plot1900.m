clear;clc
%% define the path of the data
filepath = "D:\summer project\data\data2\";
ocean_filename = [...
"fgco2_Omon_CNRM-ESM2-1_esm-hist_r1i1p1f2_gn_185001-201412.nc";
"fgco2_Omon_GFDL-ESM4_esm-hist_r1i1p1f1_gr_189001-190912.nc";
"fgco2_Omon_MPI-ESM1-2-LR_esm-hist_r1i1p1f1_gn_189001-190912.nc";
"fgco2_Omon_UKESM1-0-LL_esm-hist_r1i1p1f2_gn_185001-194912.nc"

 ];

ocean_areacello_filename = [...

"areacello_Ofx_CNRM-ESM2-1_historical_r2i1p1f2_gn.nc";

"areacello_Ofx_GFDL-ESM4_historical_r1i1p1f1_gr.nc";
"areacello_Ofx_MPI-ESM-1-2-HAM_historical_r1i1p1f1_gn.nc";
"areacello_Ofx_UKESM1-0-LL_piControl_r1i1p1f2_gn.nc"
];
%% load the data and plot the bar and line figure
Marker =  [ [0.0, 0.45, 0.74];  % 蓝色
    [0.85, 0.33, 0.10]; % 红色
   
    [0.49, 0.18, 0.56]; % 紫色
 
    [0.0, 0.5, 0.0];    % 深绿色
     [0.0, 0.0, 0.0];
    ];
for i = 1:length(ocean_filename)
    [lat_ocean,CO2_flux_ocean_year_LON,model(i),CO2_flux_ocean_year_areas(:,i)]=plot_CO2_flux_ocean_year(filepath,ocean_filename(i), ocean_areacello_filename(i));
    
    h2=figure(2);
    % 调整图窗大小
    set(h2,'position',[100,100,1200,600])
    plot(lat_ocean,CO2_flux_ocean_year_LON,'color',Marker(i,:),'LineWidth',2,'DisplayName',model(i))
    ylim([-0.15 0.15])
    hold on
    title("ocean CO2 flux in 1900")
    xlabel('Latitude')
    ylabel('CO2 flux (PgC yr^-^1)')
    % if i==6
    %     keyboard
    % end
end
legend
saveas(gcf, 'ocean_CO2_flux_line1900.png')
% 对CO2_flux_ocean_year_area数据画柱状图，使用Bar函数
h=figure(1);
% 调整图窗大小
set(h,'position',[100,100,1200,600])
hh = bar(CO2_flux_ocean_year_areas);
for j = 1:length(hh)
    hh(1,j).FaceColor = Marker(j,:);
end
category={'47°S-90°S','23.5°S-47°S','23.5°S-23.5N','23.5°N-47°N','47°N-90°N'};
set(gca,'xticklabel',category)
ylim([-2 2])
hold on
xline([1.5 2.5 3.5 4.5],'k--','LineWidth',1.0)
legend(hh,model,'Location','northeastoutside')
saveas(gcf, 'ocean_CO2_flux_Bar1900.png')


%% Functions
function [time_ocean,lat_ocean,lon_ocean,CO2_ocean,model] = select_parameter(filepath,filename)
    ocean=hnc_getall(filepath+filename);
    disp(filename)
    disp("stop")

    if filename=="fgco2_Omon_CNRM-ESM2-1_esm-hist_r1i1p1f2_gn_185001-201412.nc"
        lat_ocean = ocean.lat.data(:,1);
        lon_ocean = ocean.lon.data;
    elseif filename=="fgco2_Omon_GFDL-ESM4_esm-hist_r1i1p1f1_gr_189001-190912.nc"
        lat_ocean = ocean.lat.data;
        lon_ocean = ocean.lon.data;
    else
        lat_ocean = ocean.latitude.data(:,1);
        lon_ocean = ocean.longitude.data;
    end

    if filename ==  "fgco2_Omon_MPI-ESM1-2-LR_esm-hist_r1i1p1f1_gn_189001-190912.nc"...
            || filename== "fgco2_Omon_GFDL-ESM4_esm-hist_r1i1p1f1_gr_189001-190912.nc"
        time_ocean = ocean.time.data-ocean.time.data(1);
    else
        time_ocean = ocean.time.data;
    end

    if filename== "fgco2_Omon_GFDL-ESM4_esm-hist_r1i1p1f1_gr_189001-190912.nc"...
            || filename== "fgco2_Omon_MPI-ESM1-2-LR_esm-hist_r1i1p1f1_gn_189001-190912.nc"
        is_1900=(3653<=time_ocean)&(time_ocean<=4017);
    else
        is_1900=(18263<=time_ocean)&(time_ocean<=18627);
    end

    % is_1900 = (0<=time_ocean)&(time_ocean<365);
    time_ocean = time_ocean(is_1900);
    CO2_ocean = -ocean.fgco2.data(is_1900,:,:);
    is_error = abs(CO2_ocean)>9.9e19;
    CO2_ocean(is_error)=nan;
    model = string(ocean.source_id);




end

function areacello = load_ocean_areacello(filepath,filename)
    ocean=hnc_getall(filepath+filename);
    areacello = ocean.areacello.data;
end

function [time_ocean,lat_ocean,lon_ocean,CO2_flux_ocean_year,model] = calculate_CO2_flux_ocean_year(filepath,ocean_filename, ocean_areacello_filename)
    [time_ocean,lat_ocean,lon_ocean,CO2_ocean,model] = select_parameter(filepath,ocean_filename);
    areacello = load_ocean_areacello(filepath,ocean_areacello_filename);
    areacello_fix = repmat(areacello,[1,1,size(CO2_ocean,1)]);
    areacello_fix = permute(areacello_fix,[3,1,2]);

    CO2_flux_ocean = CO2_ocean.*areacello_fix;

    CO2_flux_ocean_year = squeeze(sum(CO2_flux_ocean,1,"omitnan"))*365*24*60*60/(12*1e12);
end

function [lat_ocean,CO2_flux_ocean_year_LON,model,CO2_flux_ocean_year_areas]=plot_CO2_flux_ocean_year(filepath,ocean_filename, ocean_areacello_filename)
    [time_ocean,lat_ocean,lon_ocean,CO2_flux_ocean_year,model] = calculate_CO2_flux_ocean_year(filepath,ocean_filename, ocean_areacello_filename);
    CO2_flux_ocean_year_LON=sum(CO2_flux_ocean_year,2);
 
    if ocean_filename=="fgco2_Omon_MPI-ESM1-2-LR_esm-hist_r1i1p1f1_gn_189001-190912.nc"
        CO2_flux_ocean_year_area5=sum(CO2_flux_ocean_year_LON(1:find(lat_ocean<47,1,'first')));
        CO2_flux_ocean_year_area4=sum(CO2_flux_ocean_year_LON(find(lat_ocean<47,1,'first')+1:find(lat_ocean<23.5,1,'first')));
        CO2_flux_ocean_year_area3=sum(CO2_flux_ocean_year_LON(find(lat_ocean<23.5,1,'first')+1:find(lat_ocean<-23.5,1,'first')));
        CO2_flux_ocean_year_area2=sum(CO2_flux_ocean_year_LON(find(lat_ocean<-23.5,1,'first')+1:find(lat_ocean<-47,1,'first')));
        CO2_flux_ocean_year_area1=sum(CO2_flux_ocean_year_LON(find(lat_ocean<-47,1,'first'):end));        
    else
        CO2_flux_ocean_year_area1=sum(CO2_flux_ocean_year_LON(1:find(lat_ocean<-47,1,'last')));
        CO2_flux_ocean_year_area2=sum(CO2_flux_ocean_year_LON(find(lat_ocean<-47,1,'last')+1:find(lat_ocean<-23.5,1,'last')));
        CO2_flux_ocean_year_area3=sum(CO2_flux_ocean_year_LON(find(lat_ocean<-23.5,1,'last')+1:find(lat_ocean<23.5,1,'last')));
        CO2_flux_ocean_year_area4=sum(CO2_flux_ocean_year_LON(find(lat_ocean<23.5,1,'last')+1:find(lat_ocean<47,1,'last')));
        CO2_flux_ocean_year_area5=sum(CO2_flux_ocean_year_LON(find(lat_ocean<47,1,'last')+1:end));
    end


    CO2_flux_ocean_year_areas = [CO2_flux_ocean_year_area1;CO2_flux_ocean_year_area2;CO2_flux_ocean_year_area3;CO2_flux_ocean_year_area4;CO2_flux_ocean_year_area5];
end