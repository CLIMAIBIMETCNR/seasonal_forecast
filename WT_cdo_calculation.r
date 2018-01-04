library(raster)
library(rts)

setwd("/home/alf/Documenti/aa_recent_work/lav_messeri")

source("WT_aux.r")


files_eobs_stack_WT_month=list.files(path="/home/alf/Documenti/aa_recent_work/lav_messeri/WT_data/stack_WT/stack_pct_09",full.names = T)
files_WT_rea=list.files(path="/home/alf/Documenti/aa_recent_work/lav_messeri/WT_data/stack_WT/stack_pct_09",full.names = T)
files_eobs_clim=list.files(path="/home/alf/Documenti/aa_recent_work/lav_messeri/eobs_data/eobs_clim",full.names = T)



######################################################################################################
# setup directory

dir_clim_eobs="/home/alf/Documenti/aa_recent_work/lav_messeri/eobs_data/clim_eobs"
dir_wt_eobs_tg="/home/alf/Documenti/aa_recent_work/lav_messeri/WT_data/stack_WT/eobs_tg_wt"
dir_wt_eobs_tx="/home/alf/Documenti/aa_recent_work/lav_messeri/WT_data/stack_WT/eobs_tx_wt"
dir_wt_eobs_tn="/home/alf/Documenti/aa_recent_work/lav_messeri/WT_data/stack_WT/eobs_tn_wt"
dir_wt_eobs_rr="/home/alf/Documenti/aa_recent_work/lav_messeri/WT_data/stack_WT/eobs_rr_wt"
dir_wt_eobs_gpm1="/home/alf/Documenti/aa_recent_work/lav_messeri/WT_data/stack_WT/eobs_gpm1_wt"

setwd(dir_wt_eobs_tg)
par="tg"
suff_file="_monthly_normal_mean.nc"
filerefs=paste0(dir_clim_eobs,"/",par,suff_file," temp.nc")
sapply(list.files(),FUN=function(x) cdo_clim_summaries(x))
tg_files_month_avg=sapply(paste0("wt_",c(1:12),"_"),function(x) Sys.glob(paste0("avg*",x,"*.nc")))
for ( i in 1:12) {
  system(paste0("cdo selmon,",i," ",filerefs))
  sapply(tg_files_month_avg[,i],FUN=function(x) cdo_anom_clim(x))
  file.remove("temp.nc")
}

setwd(dir_wt_eobs_tx)
par="tx"
suff_file="_monthly_normal_mean.nc"
filerefs=paste0(dir_clim_eobs,"/",par,suff_file," temp.nc")
sapply(list.files(),FUN=function(x) cdo_clim_summaries(x))
tx_files_month_avg=sapply(paste0("wt_",c(1:12),"_"),function(x) Sys.glob(paste0("avg*",x,"*.nc")))
for ( i in 1:12) {
  system(paste0("cdo selmon,",i," ",filerefs))
  sapply(tx_files_month_avg[,i],FUN=function(x) cdo_anom_clim(x))
  file.remove("temp.nc")
}

setwd(dir_wt_eobs_tn)
par="tn"
suff_file="_monthly_normal_mean.nc"
filerefs=paste0(dir_clim_eobs,"/",par,suff_file," temp.nc")
sapply(list.files(),FUN=function(x) cdo_clim_summaries(x))
tn_files_month_avg=sapply(paste0("wt_",c(1:12),"_"),function(x) Sys.glob(paste0("avg*",x,"*.nc")))
for ( i in 1:12) {
  system(paste0("cdo selmon,",i," ",filerefs))
  sapply(tn_files_month_avg[,i],FUN=function(x) cdo_anom_clim(x))
  file.remove("temp.nc")
}

setwd(dir_wt_eobs_rr)
par="rr"
suff_file="_monthly_normal_sum.nc"
filerefs=paste0(dir_clim_eobs,"/",par,suff_file," temp.nc")
sapply(list.files(),FUN=function(x) cdo_clim_summaries(x))

file_rr=list.files(pattern="all*")
sapply(file_rr,FUN=function(x) cdo_fun_gp1m(x))
system(paste0("mv all_gpm1* ", dir_wt_eobs_gpm1))

rr_files_month_avg=sapply(paste0("wt_",c(1:12),"_"),function(x) Sys.glob(paste0("avg*",x,"*.nc")))
for ( i in 1:12) {
  sapply(rr_files_month_avg[,i],FUN=function(x) cdo_day2month(x,i))
}

rr_files_month_monavg=sapply(paste0("wt_",c(1:12),"_"),function(x) Sys.glob(paste0("mon*",x,"*.nc")))

for ( i in 1:12) {
  system(paste0("cdo selmon,",i," ",filerefs))
  sapply(rr_files_month_monavg[,i],FUN=function(x) cdo_anom_clim(x))
  file.remove("temp.nc")
}

setwd(dir_wt_eobs_gpm1)
par="gpm1"
suff_file="_monthly_normal_sum.nc"

filerefs=paste0(dir_clim_eobs,"/",par,suff_file," temp.nc")
sapply(list.files(),FUN=function(x) cdo_clim_summaries(x))

gpm1_files_month_avg=sapply(paste0("wt_",c(1:12),"_"),function(x) Sys.glob(paste0("avg*",x,"*.nc")))

for ( i in 1:12) {
  sapply(gpm1_files_month_avg[,i],FUN=function(x) cdo_day2month(x,i))
}

gpm1_files_month_monavg=sapply(paste0("wt_",c(1:12),"_"),function(x) Sys.glob(paste0("mon*",x,"*.nc")))

for ( i in 1:12) {
  system(paste0("cdo selmon,",i," ",filerefs))
  sapply(gpm1_files_month_monavg[,i],FUN=function(x) cdo_anom_clim(x))
  file.remove("temp.nc")
}
###########################################################################################################################




















#######################################################################################
# references
# http://www.studytrails.com/blog/install-climate-data-operator-cdo-with-netcdf-grib2-and-hdf5-support/
# http://giswerk.org/doku.php?id=wac:dataprocessing:tools:installcdo