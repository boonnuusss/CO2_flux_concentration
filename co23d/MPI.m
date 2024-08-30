clear;clc
file = file_path+"co23D_Emon_MPI-ESM1-2-LR_esm-hist_r1i1p1f1_gn_185001-186912.nc";
data=hnc_getall(file);
CO2_3D = squeeze(data.co23D.data(:,1,:,:));
time = data.time.data-data.time.data(1);
lat = data.lat.data;
%%
is_1850=time<365;
CO2_3D_year = squeeze(CO2_3D(is_1850,:,:));
CO2_3D_year = squeeze(sum(CO2_3D_year,1));
CO2_3D_year_lon = sum(CO2_3D_year,2);
CO2_3D_year_lon = CO2_3D_year_lon*(29/44)*1e6/12;

  
plot(lat,CO2_3D_year_lon-CO2_3D_year_lon(1),'LineWidth',2,'DisplayName','1850')
hold on

clear;clc
data=hnc_getall("D:\summer project\data\data2\co23D_Emon_MPI-ESM1-2-LR_esm-hist_r1i1p1f1_gn_189001-190912.nc");
CO2_3D = squeeze(data.co23D.data(:,1,:,:));
time = data.time.data-data.time.data(1);
lat = data.lat.data;
is_1900 = time>3653&time<4017;
CO2_3D_year = squeeze(CO2_3D(is_1900,:,:));
CO2_3D_year = squeeze(sum(CO2_3D_year,1));
CO2_3D_year_lon = sum(CO2_3D_year,2);
CO2_3D_year_lon = CO2_3D_year_lon*(29/44)*1e6/12;
plot(lat,CO2_3D_year_lon-CO2_3D_year_lon(1),'LineWidth',2,'DisplayName','1900')
hold on




clear;clc
data=hnc_getall("D:\summer project\data\data2\co23D_Emon_MPI-ESM1-2-LR_esm-hist_r1i1p1f1_gn_195001-196912.nc");
CO2_3D = squeeze(data.co23D.data(:,1,:,:));
time = data.time.data-data.time.data(1);
lat = data.lat.data;

is_1956 = time>2192&time<2557;
CO2_3D_year = squeeze(CO2_3D(is_1956,:,:));
CO2_3D_year = squeeze(sum(CO2_3D_year,1));
CO2_3D_year_lon = sum(CO2_3D_year,2);
CO2_3D_year_lon = CO2_3D_year_lon*(29/44)*1e6/12;
plot(lat,CO2_3D_year_lon-CO2_3D_year_lon(1),'LineWidth',2,'DisplayName','1956')
hold on


clear;clc
data=hnc_getall("D:\summer project\data\data2\co23D_Emon_MPI-ESM1-2-LR_esm-hist_r1i1p1f1_gn_199001-200912.nc");
CO2_3D = squeeze(data.co23D.data(:,1,:,:));
time = data.time.data-data.time.data(1);
lat = data.lat.data;

is_2003 = time>4745&time<5109;
CO2_3D_year = squeeze(CO2_3D(is_2003,:,:));
CO2_3D_year = squeeze(sum(CO2_3D_year,1));
CO2_3D_year_lon = sum(CO2_3D_year,2);
CO2_3D_year_lon = CO2_3D_year_lon*(29/44)*1e6/12;
plot(lat,CO2_3D_year_lon-CO2_3D_year_lon(1),'LineWidth',2,'DisplayName','2003')

legend
