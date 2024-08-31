clear;clc
%% define the path of the data
land_filename = [...
"netAtmosLandCO2Flux_Emon_CNRM-ESM2-1_esm-hist_r1i1p1f2_gr_185001-201412.nc";
"netAtmosLandCO2Flux_Emon_MPI-ESM1-2-LR_esm-hist_r1i1p1f1_gn_199001-200912.nc";
"netAtmosLandCO2Flux_Emon_UKESM1-0-LL_esm-hist_r1i1p1f2_gn_195001-201412.nc"];
land_fraction_filename = [...

"sftlf_fx_CNRM-ESM2-1_historical_r3i1p1f2_gr.nc";

"sftlf_fx_MPI-ESM-1-2-HAM_historical_r1i1p1f1_gn.nc";
"sftlf_fx_UKESM1-0-LL_piControl_r1i1p1f2_gn.nc"];

land_areacella_filename = [...
"areacella_fx_CNRM-ESM2-1_historical_r2i1p1f2_gr.nc";

"areacella_fx_MPI-ESM-1-2-HAM_historical_r1i1p1f1_gn.nc";
"areacella_fx_UKESM1-0-LL_piControl_r1i1p1f2_gn.nc"
];
add_data = [0;0.13;1.23;-1.74;0.083];
%% load the data and plot the bar and line figure
Marker =  [ [0.0, 0.45, 0.74];  % 蓝色
    [0.85, 0.33, 0.10]; % 红色
   
    %[0.49, 0.18, 0.56]; % 紫色
 
    [0.0, 0.5, 0.0];    % 深绿色
     [0.0, 0.0, 0.0];
    ];
for i = 1:length(land_filename)
    [lat_land,CO2_flux_land_year_LON,model(i),CO2_flux_land_year_areas(:,i)]=plot_CO2_flux_land_year(filepath,land_filename(i), land_fraction_filename(i), land_areacella_filename(i));
    
    h2=figure(2);
    % 调整图窗大小
    set(h2,'position',[100,100,1200,600])
    plot(lat_land,CO2_flux_land_year_LON,'color',Marker(i,:),'LineWidth',2,'DisplayName',model(i))
    ylim([-0.15 0.15])
    hold on
    title("land CO2 flux in 2003")
    xlabel('Latitude')
    ylabel('CO2 flux (PgC yr^-^1)')
    
end
legend
saveas(gcf, 'land_CO2_flux_line2003.png')
% 对CO2_flux_land_year_area数据画柱状图，使用Bar函数
h=figure(1);
% 调整图窗大小
set(h,'position',[100,100,1200,600])
CO2_flux_land_year_areas = [CO2_flux_land_year_areas,add_data];
model = [model,"Keeling"];
hh = bar(CO2_flux_land_year_areas);
for j = 1:length(hh)
    hh(1,j).FaceColor = Marker(j,:);
end
category={'47°S-90°S','23.5°S-47°S','23.5°S-23.5N','23.5°N-47°N','47°N-90°N'};
set(gca,'xticklabel',category)
ylim([-2 2])
hold on
xline([1.5 2.5 3.5 4.5],'k--','LineWidth',1.0)
legend(hh,model,'Location','northeastoutside')
saveas(gcf, 'land_CO2_flux_Bar2003.png')


%% Functions
function [time_land,lat_land,lon_land,CO2_land,model] = select_parameter(filepath,filename)
    disp("Working on: "+filename)
    land=hnc_getall(filepath+filename);
    if filename== "netAtmosLandCO2Flux_Emon_MPI-ESM1-2-LR_esm-hist_r1i1p1f1_gn_199001-200912.nc"...
            || filename== "netAtmosLandCO2Flux_Emon_UKESM1-0-LL_esm-hist_r1i1p1f2_gn_195001-201412.nc"
           
        time_land = land.time.data-land.time.data(1);
   else 
       time_land = land.time.data;
   end
   
   if filename==   "netAtmosLandCO2Flux_Emon_UKESM1-0-LL_esm-hist_r1i1p1f2_gn_195001-201412.nc"
          
            is_2003=(19359<time_land)&(time_land<19723);

   elseif filename== "netAtmosLandCO2Flux_Emon_MPI-ESM1-2-LR_esm-hist_r1i1p1f1_gn_199001-200912.nc"
       is_2003=(4745<time_land)&(time_land<5109);
    else
        is_2003=(55519<time_land)&(time_land<55883);
   end

    time_land = time_land(is_2003);
    lat_land = land.lat.data;
    lon_land = land.lon.data;
    CO2_land = -land.netAtmosLandCO2Flux.data(is_2003,:,:);
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

function [time_land,lat_land,lon_land,CO2_flux_land_year,model] = calculate_CO2_flux_land_year(filepath,land_filename, land_fraction_filename, land_areacella_filename)
    [time_land,lat_land,lon_land,CO2_land,model] = select_parameter(filepath,land_filename);
    [lat_sftlf,lon_sftlf,sftlf] = load_land_fraction(filepath,land_fraction_filename);
    [lat_areacella,lon_areacella,areacella] = load_land_areacella(filepath,land_areacella_filename);
    if land_filename=="netAtmosLandCO2Flux_Emon_MIROC-ES2H_historical_r1i1p4f2_gn_185001-201412.nc"
        [sftlf,areacella]=fix_grid(lat_sftlf,lon_sftlf,sftlf,lat_areacella,lon_areacella,areacella,lon_land,lat_land);
    end
    sftlf_fix = repmat(sftlf,[1,1,12]);
    sftlf_fix = permute(sftlf_fix,[3,1,2]);
    areacella_fix = repmat(areacella,[1,1,12]);
    areacella_fix = permute(areacella_fix,[3,1,2]);
    % mydisp(size(sftlf_fix))
    % disp(size(CO2_land))
    CO2_flux_land = CO2_land.*sftlf_fix/100.*areacella_fix;
    CO2_flux_land_year = squeeze(sum(CO2_flux_land,1,"omitnan"))*365*24*60*60/(12*1e12);
end

function [lat_land,CO2_flux_land_year_LON,model,CO2_flux_land_year_areas]=plot_CO2_flux_land_year(filepath,land_filename, land_fraction_filename, land_areacella_filename)
    [~,lat_land,~,CO2_flux_land_year,model] = calculate_CO2_flux_land_year(filepath,land_filename, land_fraction_filename,land_areacella_filename);
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