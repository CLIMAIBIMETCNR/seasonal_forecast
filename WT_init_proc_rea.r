library(xts)
library(lubridate)
library(raster)
library(ncdf4)

setwd("data")


list_WT_pct09=readRDS("list_WT_pct09.rds")          
list_WT_san09=readRDS("list_WT_san09.rds") 


list_WTS=list(list_WT_pct09,list_WT_san09)
names(list_WTS)=c("WT_pct09","WT_san09")

files_grib=list.files(path="stack_WT",pattern="*.grb")

dates_rea_2=seq(as.Date("1979-01-01"),as.Date("2016-12-31"),by=1)
dates_rea_1980_2010=seq(as.Date("1981-01-01"),as.Date("2010-12-31"),by=1)

ABS_daily=brick( paste0("rea_data/stack_rea/",files_grib[[1]]),lvar=1)
HGT_daily=brick( paste0("rea_data/stack_rea/",files_grib[[2]]),lvar=1)
PRATE_daily=brick( paste0("rea_data/stack_rea/",files_grib[[3]]),lvar=1)
PRES_daily=brick( paste0("rea_data/stack_rea/",files_grib[[4]]),lvar=1)
T850_daily=brick( paste0("rea_data/stack_rea/",files_grib[[5]]),lvar=1)
UGRD700_daily=brick( paste0("rea_data/stack_rea/",files_grib[[6]]),lvar=1)
VGRD700_daily=brick( paste0("rea_data/stack_rea/",files_grib[[7]]),lvar=1)

setZ(ABS_daily, dates_rea_2, name='time')
setZ(HGT_daily, dates_rea_2, name='time')
setZ(PRES_daily, dates_rea_2, name='time')
setZ(PRATE_daily, dates_rea_2, name='time')
setZ(T850_daily, dates_rea_2, name='time')
setZ(VGRD700_daily, dates_rea_2, name='time')
setZ(UGRD700_daily, dates_rea_2, name='time')


writeRaster(ABS_daily,"ABS_daily_1979_2016_noT.nc", "CDF", overwrite=TRUE)
system("cdo -settaxis,1979-01-01,00:00:00,1day ABS_daily_1979_2016_noT.nc ABS_daily_1979_2016.nc")

writeRaster(HGT_daily,"HGT_daily_1979_2016_noT.nc", "CDF", overwrite=TRUE)
system("cdo -settaxis,1979-01-01,00:00:00,1day HGT_daily_1979_2016_noT.nc HGT_daily_1979_2016.nc")

writeRaster(PRATE_daily,"PRATE_daily_1979_2016_noT.nc","CDF",overwrite=TRUE)
system("cdo -settaxis,1979-01-01,00:00:00,1day PRATE_daily_1979_2016_noT.nc PRATE_daily_1979_2016.nc")

writeRaster(PRES_daily,"PRES_daily_1979_2016_noT.nc","CDF",overwrite=TRUE)
system("cdo -settaxis,1979-01-01,00:00:00,1day PRES_daily_1979_2016_noT.nc PRES_daily_1979_2016.nc")

writeRaster(T850_daily,"T850_daily_1979_2016_noT.nc","CDF",overwrite=TRUE)
system("cdo -settaxis,1979-01-01,00:00:00,1day T850_daily_1979_2016_noT.nc T850_daily_1979_2016.nc")

writeRaster(UGRD700_daily,"UGRD700_daily_1979_2016_noT.nc","CDF",overwrite=TRUE)
system("cdo -settaxis,1979-01-01,00:00:00,1day UGRD700_daily_1979_2016_noT.nc UGRD700_daily_1979_2016.nc")

writeRaster(VGRD700_daily,"VGRD700_daily_1979_2016_noT.nc","CDF",overwrite=TRUE)
system("cdo -settaxis,1979-01-01,00:00:00,1day VGRD700_daily_1979_2016_noT.nc VGRD700_daily_1979_2016.nc")


system("cdo -seldate,1979-01-01,2010-12-31 ABS_daily_1979_2016.nc ABS_daily_1981_2010.nc")
system("cdo -seldate,1979-01-01,2010-12-31 HGT_daily_1979_2016.nc HGT_daily_1981_2010.nc")
system("cdo -seldate,1979-01-01,2010-12-31 PRATE_daily_1979_2016.nc PRATE_daily_1981_2010.nc")
system("cdo -seldate,1979-01-01,2010-12-31 PRES_daily_1979_2016.nc  PRES_daily_1981_2010.nc")
system("cdo -seldate,1979-01-01,2010-12-31 T850_daily_1979_2016.nc T850_daily_1981_2010.nc")
system("cdo -seldate,1979-01-01,2010-12-31 UGRD700_daily_1979_2016.nc UGRD700_daily_1981_2010.nc")
system("cdo -seldate,1979-01-01,2010-12-31 VGRD700_daily_1979_2016.nc VGRD700_daily_1981_2010.nc")


setwd("/home/alf/Documenti/aa_recent_work/lav_messeri")

#setwd("/home/salute/seasonal/procedure_data")

list_WT_pct09=readRDS("list_WT_pct09.rds")          
list_WT_san09=readRDS("list_WT_san09.rds") 


list_WTS=list(list_WT_pct09,list_WT_san09)
names(list_WTS)=c("WT_pct09","WT_san09")

setwd("/home/alf/Documenti/aa_recent_work/lav_messeri/rea_data/rea_2_81_00")

dir.create("all_wt")

ABS_daily=brick( "ABS_daily_1981_2010.nc",lvar=1)

j=2;
#for (j in 1:2) {
  for (i in seq_along(list_WTS[[j]])) {
                                      days=as.numeric(unlist(list_WTS[[j]][i])) 
                                      if ( length(days) >0) {
                                      ABS_temp_clim=subset(ABS_daily,as.numeric(unlist(list_WTS[[j]][i])))
                                      writeRaster(ABS_temp_clim,paste0("all_wt/all_ABS_",names(list_WTS)[j],"_",names(list_WTS[[j]])[[i]]), "CDF", overwrite=TRUE,varname="ABS",varunit="XX",longname="absolute vorticity",xname="longitude",yname="latitude")
  }
}
#}


rm(ABS_daily)

PRES_daily=brick( "PRES_daily_1981_2010.nc",lvar=1)

j=2;
#for (j in 1:2) {
  for (i in seq_along(list_WTS[[j]])) {
days=as.numeric(unlist(list_WTS[[j]][i])) 
 if ( length(days) >0) {
    PRES_temp_clim=subset(PRES_daily,as.numeric(unlist(list_WTS[[j]][i])))
    writeRaster(PRES_temp_clim,paste0("all_wt/all_PRES_",names(list_WTS)[j],"_",names(list_WTS[[j]])[[i]]), "CDF", overwrite=TRUE,varname="PRES",varunit="hPa",longname="sea level pressure",xname="longitude",yname="latitude")
  }
}
#}

rm(PRES_daily)


PRATE_daily=brick( "PRATE_daily_1981_2010.nc",lvar=1)

j=2;
#for (j in 1:2) {
  for (i in seq_along(list_WTS[[j]])) {
days=as.numeric(unlist(list_WTS[[j]][i])) 
 if ( length(days) >0) {
    PRATE_temp_clim=subset(PRATE_daily,as.numeric(unlist(list_WTS[[j]][i])))
    writeRaster(PRATE_temp_clim,paste0("all_wt/all_PRATE_",names(list_WTS)[j],"_",names(list_WTS[[j]])[[i]]), "CDF", overwrite=TRUE,varname="PRATE",varunit="XX",longname="rainfall rate",xname="longitude",yname="latitude")
  }
}
#}

rm(PRATE_daily)

T850_daily=brick( "T850_daily_1981_2010.nc",lvar=1)

j=2;
#for (j in 1:2) {
  for (i in seq_along(list_WTS[[j]])) {
days=as.numeric(unlist(list_WTS[[j]][i])) 
 if ( length(days) >0) {
    T850_temp_clim=subset(T850_daily,as.numeric(unlist(list_WTS[[j]][i])))
    writeRaster(T850_temp_clim,paste0("all_wt/all_T850_",names(list_WTS)[j],"_",names(list_WTS[[j]])[[i]]), "CDF", overwrite=TRUE,varname="T850",varunit="K",longname="air temperature 850 hpa",xname="longitude",yname="latitude")
  }
}
#}

rm(T850_daily)

HGT500_daily=brick( "HGT_daily_1981_2010.nc",lvar=1)

j=2;
#for (j in 1:2) {
  for (i in seq_along(list_WTS[[j]])) {
days=as.numeric(unlist(list_WTS[[j]][i])) 
 if ( length(days) >0) {
    HGT500_temp_clim=subset(HGT500_daily,as.numeric(unlist(list_WTS[[j]][i])))
    writeRaster(HGT500_temp_clim,paste0("all_wt/all_HGT500_",names(list_WTS)[j],"_",names(list_WTS[[j]])[[i]]), "CDF", overwrite=TRUE,varname="HGT500",varunit="K",longname="geopotential height 500 hPa",xname="longitude",yname="latitude")
  }
}
#}

rm(HGT500_daily)

UGRD700_daily=brick( "UGRD700_daily_1981_2010.nc",lvar=1)

j=2;
#for (j in 1:2) {
  for (i in seq_along(list_WTS[[j]])) {
days=as.numeric(unlist(list_WTS[[j]][i])) 
 if ( length(days) >0) {
    UGRD700_temp_clim=subset(UGRD700_daily,as.numeric(unlist(list_WTS[[j]][i])))
    writeRaster(UGRD700_temp_clim,paste0("all_wt/all_UGRD700_",names(list_WTS)[j],"_",names(list_WTS[[j]])[[i]]), "CDF", overwrite=TRUE,varname="UGRD700",varunit="m/sec",longname="zonal component wind",xname="longitude",yname="latitude")
  }
}
#}

rm(UGRD700_daily)

VGRD700_daily=brick( "VGRD700_daily_1981_2010.nc",lvar=1)

j=2;
#for (j in 1:2) {
  for (i in seq_along(list_WTS[[j]])) {

days=as.numeric(unlist(list_WTS[[j]][i])) 
 if ( length(days) >0) {
    VGRD700_temp_clim=subset(VGRD700_daily,as.numeric(unlist(list_WTS[[j]][i])))
    writeRaster(VGRD700_temp_clim,paste0("all_wt/all_VGRD700_",names(list_WTS)[j],"_",names(list_WTS[[j]])[[i]]), "CDF", overwrite=TRUE,varname="VGRD700",varunit="m/sec",longname="vertical component wind",xname="longitude",yname="latitude")
  }
}
#}

rm(VGRD700_daily)

################################################################################################################################################

#system("cdo ymonmean HGT_daily_1981_2010.nc  HGT500_monthly_normal_mean.nc")
#system("cdo ymonmean ABS_daily_1981_2010.nc  ABS_monthly_normal_mean.nc")
#system("cdo ymonmean PRATE_daily_1981_2010.nc  PRATE_monthly_normal_mean.nc")
#system("cdo ymonmean PRES_daily_1981_2010.nc  PRES_monthly_normal_mean.nc")
#system("cdo ymonmean T850_daily_1981_2010.nc  T850_monthly_normal_mean.nc")
#system("cdo ymonmean HGT_daily_1981_2010.nc  HGT500_monthly_normal_mean.nc")
#system("cdo ymonmean UGRD700_daily_1981_2010.nc  UGRD700_monthly_normal_mean.nc")
#system("cdo ymonmean VGRD700_daily_1981_2010.nc  VGRD700_monthly_normal_mean.nc")

info_file=function(x) {cdo=Sys.which("cdo");if ( cdo=="") (stop("CDO climate must be installed") else(system(paste0(cdo,"  -infov ",x,intern=T))))

################################################################################################################################################


