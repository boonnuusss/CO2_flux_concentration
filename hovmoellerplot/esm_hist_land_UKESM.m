clear;clc
%% define the path of the data
land_filename = ["netAtmosLandCO2Flux_Emon_UKESM1-0-LL_esm-hist_r1i1p1f2_gn_185001-194912.nc";
                 "netAtmosLandCO2Flux_Emon_UKESM1-0-LL_esm-hist_r1i1p1f2_gn_195001-201412.nc"];
land_fraction_filename = "sftlf_fx_UKESM1-0-LL_piControl_r1i1p1f2_gn.nc";
land_areacella_filename = "areacella_fx_UKESM1-0-LL_piControl_r1i1p1f2_gn.nc";
%% load the data and plot the bar and line figure
time_land = [];
CO2_flux_land = [];
for i = 1:length(land_filename)
    [time_land_i,lat_land,lon_land,CO2_flux_land_i,model] = ...
        calculate_CO2_flux_land_year(filepath,land_filename(i),land_fraction_filename,land_areacella_filename);
    time_land = [time_land, time_land_i];
    CO2_flux_land = cat(1,CO2_flux_land,CO2_flux_land_i);
end

CO2_flux_land = double(CO2_flux_land);
CO2_flux_land_lon = sum(CO2_flux_land,3,"omitnan");

avg_year = 1850:2014;
CO2_flux_land_lon_year_avg = zeros(length(avg_year),length(lat_land));
for i = 1:length(avg_year)
    CO2_flux_land_lon_year_avg(i,:) = -sum(CO2_flux_land_lon((i-1)*12+1:i*12,:),1); % 单位：PgC year^-1
end

figure
[X,Y] = meshgrid(avg_year, lat_land);
pcolor(X', Y', CO2_flux_land_lon_year_avg);
shading flat
colorbar;
colormap("jet")
clim([-5e-2 5e-2])
% x tick outside
set(gca,'TickDir','out')
xticks(1850:20:2014)
xlabel('Year')



%% Functions
function [time_land,lat_land,lon_land,CO2_land,model] = select_parameter(filepath,filename,target_year)
    disp("Working on: "+filename)
    land=hnc_getall(filepath+filename);
    if filename == "netAtmosLandCO2Flux_Emon_CESM2_historical_r11i1p1f1_gn_185001-189912.nc"
        time_land = land.time.data-land.time.data(1);
    else
        time_land = land.time.data;
    end
    lat_land = land.lat.data;
    lon_land = land.lon.data;
    CO2_land = land.netAtmosLandCO2Flux.data;%(is_year,:,:);
    is_error = abs(CO2_land)>9.9e19;
    CO2_land(is_error)=nan;
    model = string(land.source_id);

end


function [lat_sftlf,lon_sftlf,sftlf] = load_land_fraction(filepath,filename)
    land=hnc_getall(filepath+filename);
    sftlf = land.sftlf.data;
    lat_sftlf = land.lat.data;
    lon_sftlf = land.lon.data;
end

function [lat_areacella,lon_areacella,areacella] = load_land_areacella(filepath,filename)
    land=hnc_getall(filepath+filename);
    areacella = land.areacella.data;
    lat_areacella = land.lat.data;
    lon_areacella = land.lon.data;
end 

function [time_land,lat_land,lon_land,CO2_flux_land,model] = ...
    calculate_CO2_flux_land_year(filepath,land_filename,land_fraction_filename,land_areacella_filename)
    [time_land,lat_land,lon_land,CO2_land,model] = select_parameter(filepath,land_filename);
    [lat_sftlf,lon_sftlf,sftlf] = load_land_fraction(filepath,land_fraction_filename);
    [lat_areacella,lon_areacella,areacella] = load_land_areacella(filepath,land_areacella_filename);
    if land_filename=="netAtmosLandCO2Flux_Emon_MIROC-ES2H_historical_r1i1p4f2_gn_185001-201412.nc"
        [sftlf,areacella]=fix_grid(lat_sftlf,lon_sftlf,sftlf,lat_areacella,lon_areacella,areacella,lon_land,lat_land);
    end
    time_size = length(time_land);
    sftlf_fix = repmat(sftlf,[1,1,time_size]);
    sftlf_fix = permute(sftlf_fix,[3,1,2]);
    areacella_fix = repmat(areacella,[1,1,time_size]);
    areacella_fix = permute(areacella_fix,[3,1,2]);
    CO2_flux_land = CO2_land.*sftlf_fix/100.*areacella_fix*30*24*60*60/(1e12); % 单位：PgC Month^-1
end

function [time_land,lat_land,CO2_flux_land_year_LON,CO2_flux_land_year_areas,model]=...
    plot_CO2_flux_land_year(filepath,land_filename,land_fraction_filename,land_areacella_filename,target_year)

    [time_land,lat_land,~,CO2_flux_land_year,model]=...
        calculate_CO2_flux_land_year(filepath,land_filename, land_fraction_filename,land_areacella_filename,target_year);

    CO2_flux_land_year_LON=sum(CO2_flux_land_year,2);
    CO2_flux_land_year_area1=sum(CO2_flux_land_year_LON(1:find(lat_land<-47,1,'last')));
    CO2_flux_land_year_area2=sum(CO2_flux_land_year_LON(find(lat_land<-47,1,'last')+1:find(lat_land<-23.5,1,'last')));
    CO2_flux_land_year_area3=sum(CO2_flux_land_year_LON(find(lat_land<-23.5,1,'last')+1:find(lat_land<23.5,1,'last')));
    CO2_flux_land_year_area4=sum(CO2_flux_land_year_LON(find(lat_land<23.5,1,'last')+1:find(lat_land<47,1,'last')));
    CO2_flux_land_year_area5=sum(CO2_flux_land_year_LON(find(lat_land<47,1,'last')+1:end));

    CO2_flux_land_year_areas = [CO2_flux_land_year_area1;CO2_flux_land_year_area2;CO2_flux_land_year_area3;CO2_flux_land_year_area4;CO2_flux_land_year_area5];
end

function [sftlf_interpolated,areacella_interpolated]=fix_grid(lat_sftlf,lon_sftlf,sftlf,lat_areacella,lon_areacella,areacella,lon_land,lat_land)
        [lon_sftlf_grid, lat_sftlf_grid] = meshgrid(lon_sftlf, lat_sftlf);
        [lon_land_grid, lat_land_grid] = meshgrid(lon_land, lat_land);
        sftlf_interpolated = interp2(lon_sftlf_grid, lat_sftlf_grid, sftlf, lon_land_grid, lat_land_grid, 'linear');
        [lon_areacella_grid, lat_areacella_grid] = meshgrid(lon_areacella, lat_areacella);
        areacella_interpolated = interp2(lon_areacella_grid, lat_areacella_grid, areacella, lon_land_grid, lat_land_grid, 'linear')/4;
end