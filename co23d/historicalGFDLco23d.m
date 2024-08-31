clear;clc
data=hnc_getall(file_path+"co23D_Emon_GFDL-ESM4_historical_r1i1p1f1_gr1_185001-194912.nc");
CO2_3D = squeeze(data.co23D.data(:,end,:,:));
time = data.time.data-data.time.data(1);
lat = data.lat.data;
lev = data.lev.data;
%%
is_1850=time<365;
CO2_3D_year = squeeze(CO2_3D(is_1850,:,:));
CO2_3D_year = squeeze(sum(CO2_3D_year,1));
CO2_3D_year_lon = sum(CO2_3D_year,2);
CO2_3D_year_lon = CO2_3D_year_lon*1.403*(1e3)/12;
plot(lat,CO2_3D_year_lon-CO2_3D_year_lon(1),'LineWidth',2,'DisplayName','1850')
hold on


is_1900 = time>18263&time<18627;
CO2_3D_year = squeeze(CO2_3D(is_1900,:,:));
CO2_3D_year = squeeze(sum(CO2_3D_year,1));
CO2_3D_year_lon = sum(CO2_3D_year,2);
CO2_3D_year_lon = CO2_3D_year_lon*1.403*(1e3)/12;
plot(lat,CO2_3D_year_lon-CO2_3D_year_lon(1),'LineWidth',2,'DisplayName','1900')
hold on


clear;clc
data=hnc_getall(file_path+"co23D_Emon_GFDL-ESM4_historical_r1i1p1f1_gr1_195001-201412.nc");
CO2_3D = squeeze(data.co23D.data(:,end,:,:));
time = data.time.data-data.time.data(1);
lat = data.lat.data;
lev = data.lev.data;



is_1956 = time>2193&time<2558;
CO2_3D_year = squeeze(CO2_3D(is_1956,:,:));
CO2_3D_year = squeeze(sum(CO2_3D_year,1));
CO2_3D_year_lon = sum(CO2_3D_year,2);
CO2_3D_year_lon = CO2_3D_year_lon*1.403*(1e3)/12;
plot(lat,CO2_3D_year_lon-CO2_3D_year_lon(1),'LineWidth',2,'DisplayName','1956')
hold on


is_2003 = time>19359&time<19723;
CO2_3D_year = squeeze(CO2_3D(is_2003,:,:));
CO2_3D_year = squeeze(sum(CO2_3D_year,1));
CO2_3D_year_lon = sum(CO2_3D_year,2);
CO2_3D_year_lon = CO2_3D_year_lon*1.403*(1e3)/12;
plot(lat,CO2_3D_year_lon-CO2_3D_year_lon(1),'LineWidth',2,'DisplayName','2003')

legend
