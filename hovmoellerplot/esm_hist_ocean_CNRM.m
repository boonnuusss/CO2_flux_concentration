clear;
clc;

%% define the path of the data
ocean_filename = "fgco2_Omon_CNRM-ESM2-1_esm-hist_r1i1p1f2_gn_185001-201412.nc";
ocean_areacello_filename = "areacello_Ofx_CNRM-ESM2-1_historical_r2i1p1f2_gn.nc";

%% load the data and plot the bar and line figure
[time_ocean,lat_ocean,lon_ocean,CO2_flux_ocean,model] = ...
    calculate_CO2_flux_ocean_year(filepath,ocean_filename,ocean_areacello_filename);

CO2_flux_ocean = double(CO2_flux_ocean);
CO2_flux_ocean_lon = sum(CO2_flux_ocean,3,"omitnan");

avg_year = 1850:2014;
CO2_flux_ocean_lon_year_avg = zeros(length(avg_year),length(lat_ocean));
for i = 1:length(avg_year)
    CO2_flux_ocean_lon_year_avg(i,:) = sum(CO2_flux_ocean_lon((i-1)*12+1:i*12,:),1); % 单位：PgC year^-1
end

[X,Y] = meshgrid(avg_year, lat_ocean);
pcolor(X', Y', CO2_flux_ocean_lon_year_avg);
shading flat
colorbar;
colormap("jet")
clim([-5e-2 5e-2])
% x tick outside
set(gca,'TickDir','out')
xticks(1850:20:2014)
xlabel('Year')


%% Functions
function [time_ocean,lat_ocean,lon_ocean,CO2_ocean,model] = select_parameter(filepath,filename)
    ocean=hnc_getall(filepath+filename);
    disp(filename)
    disp("stop")

  
        lat_ocean = ocean.lat.data(:,1);
        lon_ocean = ocean.lon.data(1,:);
   
        time_ocean = ocean.time.data;
  
    
    CO2_ocean = -ocean.fgco2.data;
    is_error = abs(CO2_ocean)>9.9e19;
    CO2_ocean(is_error)=nan;
    model = string(ocean.source_id);

end

function areacello = load_ocean_areacello(filepath,filename)
    ocean=hnc_getall(filepath+filename);
    areacello = ocean.areacello.data;
end

function [time_ocean,lat_ocean,lon_ocean,CO2_flux_ocean,model] = calculate_CO2_flux_ocean_year(filepath,ocean_filename, ocean_areacello_filename)
    [time_ocean,lat_ocean,lon_ocean,CO2_ocean,model] = select_parameter(filepath,ocean_filename);
    areacello = load_ocean_areacello(filepath,ocean_areacello_filename);
    areacello_fix = repmat(areacello,[1,1,size(CO2_ocean,1)]);
    areacello_fix = permute(areacello_fix,[3,1,2]);

    CO2_flux_ocean = CO2_ocean.*areacello_fix*30*24*60*60/(1e12); % 单位：PgC Month^-1
end