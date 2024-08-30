clear;clc
%% define the path of the data
ocean_filename = [...
"fgco2_Omon_CanESM5_historical_r5i1p1f1_gn_185001-201412.nc";
"fgco2_Omon_CESM2_historical_r1i1p1f1_gn_185001-201412.nc";
"fgco2_Omon_CMCC-ESM2_historical_r1i1p1f1_gn_185001-201412.nc";
"fgco2_Omon_CNRM-ESM2-1_historical_r2i1p1f2_gn_185001-201412.nc";
"fgco2_Omon_EC-Earth3-CC_historical_r1i1p1f1_gn_195601-195612.nc";
"fgco2_Omon_GFDL-ESM4_historical_r1i1p1f1_gr_195001-196912.nc";
"fgco2_Omon_MIROC-ES2H_historical_r1i1p4f2_gn_185001-201412.nc";
"fgco2_Omon_MPI-ESM-1-2-HAM_historical_r1i1p1f1_gn_195001-196912.nc";
"fgco2_Omon_UKESM1-0-LL_historical_r1i1p1f2_gn_195001-201412.nc"
 ];

ocean_areacello_filename = [...
"areacello_Ofx_CanESM5_historical_r5i1p1f1_gn.nc";
"areacello_Ofx_CESM2_historical_r1i1p1f1_gn.nc";
"areacello_Ofx_CMCC-ESM2_historical_r1i1p1f1_gn.nc";
"areacello_Ofx_CNRM-ESM2-1_historical_r2i1p1f2_gn.nc";
"areacello_Ofx_EC-Earth3-CC_historical_r1i1p1f1_gn.nc";
"areacello_Ofx_GFDL-ESM4_historical_r1i1p1f1_gr.nc";
"areacello_Ofx_MIROC-ES2H_historical_r1i1p4f2_gn.nc"
"areacello_Ofx_MPI-ESM-1-2-HAM_historical_r1i1p1f1_gn.nc";
"areacello_Ofx_UKESM1-0-LL_piControl_r1i1p1f2_gn.nc"
];

%% load the data and plot the bar and line figure
Marker = [
    [0.85, 0.33, 0.10]; % 红色
    [0.93, 0.69, 0.13]; % 黄色
    [0.47, 0.67, 0.19]; % 浅绿色
    [0.49, 0.18, 0.56]; % 紫色
    [0.30, 0.75, 0.93]; % 青色
    [0.64, 0.08, 0.18]; % 深红
    [0.0, 0.0, 0.55];   % 深蓝色
    [0.5, 0.5, 0.5];    % 深灰
    [0.0, 0.5, 0.0];    % 深绿色
]; 
for i = 1:length(ocean_filename)
    [lat_ocean,CO2_flux_ocean_year_LON,model(i),CO2_flux_ocean_year_areas(:,i)]=plot_CO2_flux_ocean_year(filepath,ocean_filename(i), ocean_areacello_filename(i));
    
    h2=figure(2);
    % 调整图窗大小
    set(h2,'position',[100,100,1200,600])
    plot(lat_ocean,CO2_flux_ocean_year_LON,'color',Marker(i,:),'LineWidth',2,'DisplayName',model(i))
    hold on
    title("ocean CO2 flux in 1956")
    xlabel('Latitude')
    ylabel('CO2 flux (PgC yr^-^1)')
    
end
legend
saveas(gcf, 'ocean_CO2_flux_line1956.png')
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
hold on
xline([1.5 2.5 3.5 4.5],'k--','LineWidth',1.0)
legend(hh,model,'Location','northeastoutside')
saveas(gcf, 'ocean_CO2_flux_Bar1956.png')


%% Functions
function [time_ocean,lat_ocean,lon_ocean,CO2_ocean,model] = select_parameter(filepath,filename)
    ocean=hnc_getall(filepath+filename);
    disp(filename)
    disp("stop")

    if filename=="fgco2_Omon_CESM2_historical_r1i1p1f1_gn_185001-201412.nc"...
            || filename=="fgco2_Omon_CNRM-ESM2-1_historical_r2i1p1f2_gn_185001-201412.nc"
        lat_ocean = ocean.lat.data(:,1);
        lon_ocean = ocean.lon.data;
    elseif filename=="fgco2_Omon_GFDL-ESM4_historical_r1i1p1f1_gr_195001-196912.nc"
        lat_ocean = ocean.lat.data;
        lon_ocean = ocean.lon.data;
    else
        lat_ocean = ocean.latitude.data(:,1);
        lon_ocean = ocean.longitude.data;
    end

    if filename == "fgco2_Omon_CESM2_historical_r1i1p1f1_gn_185001-201412.nc"...
            || filename== "fgco2_Omon_EC-Earth3-CC_historical_r1i1p1f1_gn_195601-195612.nc"...
            || filename== "fgco2_Omon_GFDL-ESM4_historical_r1i1p1f1_gr_195001-196912.nc"...
            || filename== "fgco2_Omon_MPI-ESM-1-2-HAM_historical_r1i1p1f1_gn_195001-196912.nc"...
            || filename== "fgco2_Omon_UKESM1-0-LL_historical_r1i1p1f2_gn_195001-201412.nc"
        time_ocean = ocean.time.data-ocean.time.data(1);
    else
        time_ocean = ocean.time.data;
    end

  if filename== "fgco2_Omon_EC-Earth3-CC_historical_r1i1p1f1_gn_195601-195612.nc"
        is_1956=(time_ocean<365);
   elseif filename== "fgco2_Omon_GFDL-ESM4_historical_r1i1p1f1_gr_195001-196912.nc"...
            || filename==  "fgco2_Omon_MPI-ESM-1-2-HAM_historical_r1i1p1f1_gn_195001-196912.nc"...
            || filename== "fgco2_Omon_UKESM1-0-LL_historical_r1i1p1f2_gn_195001-201412.nc"
            is_1956=(2192<time_ocean)&(time_ocean<2557);
    else
  is_1956=(38352<=time_ocean)&(time_ocean<=38717);
   end

    time_ocean = time_ocean(is_1956);
    CO2_ocean = -ocean.fgco2.data(is_1956,:,:);
    is_error = abs(CO2_ocean)>9.9e19;
    CO2_ocean(is_error)=nan;
    model = string(ocean.source_id);

end


%function sftlf = load_land_fraction(filename)
    %land=hnc_getall(filename);
    %sftlf = land.sftlf.data;
%end

function areacello = load_ocean_areacello(filepath,filename)
    ocean=hnc_getall(filepath+filename);
    areacello = ocean.areacello.data;
end

function [time_ocean,lat_ocean,lon_ocean,CO2_flux_ocean_year,model] = calculate_CO2_flux_ocean_year(filepath,ocean_filename, ocean_areacello_filename)
    [time_ocean,lat_ocean,lon_ocean,CO2_ocean,model] = select_parameter(filepath,ocean_filename);
    areacello = load_ocean_areacello(filepath,ocean_areacello_filename);
    areacello_fix = repmat(areacello,[1,1,size(CO2_ocean,1)]);
    areacello_fix = permute(areacello_fix,[3,1,2]);
    %if ocean_filename == "fgco2_Omon_GFDL-ESM4_historical_r1i1p1f1_gr_185001-186912.nc"
        %keyboard
    %end
    CO2_flux_ocean = CO2_ocean.*areacello_fix;

    CO2_flux_ocean_year = squeeze(sum(CO2_flux_ocean,1,"omitnan"))*365*24*60*60/(12*1e12);
end

function [lat_ocean,CO2_flux_ocean_year_LON,model,CO2_flux_ocean_year_areas]=plot_CO2_flux_ocean_year(filepath,ocean_filename, ocean_areacello_filename)
    [time_ocean,lat_ocean,lon_ocean,CO2_flux_ocean_year,model] = calculate_CO2_flux_ocean_year(filepath,ocean_filename, ocean_areacello_filename);
    CO2_flux_ocean_year_LON=sum(CO2_flux_ocean_year,2);
 
    if ocean_filename=="fgco2_Omon_MPI-ESM-1-2-HAM_historical_r1i1p1f1_gn_195001-196912.nc"
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