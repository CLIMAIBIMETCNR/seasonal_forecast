library(raster)
library(ncdf4)

e <- extent(-30,30,30,70) # final extent 
vars=c("rr","tg","tx","tn","gpm1") 
outcomes_clim=c("mean","sd","T_cf_95_mean","q33","q50","q66","lw_cf_q50","up_cf_q50","lw_cf_q33","up_cf_q33","lw_cf_q66","up_cf_q66")

calc_climatology_stack=function(temp) {
  stopifnot(class(temp)=="RasterStack") 
  res=list()
  res$mean=calc(temp,mean,na.rm=T);
  res$sd=calc(temp,sd,na.rm=T);
  res$q33=calc(temp,fun=function(x) quantile(x,probs=c(0.33),na.rm=T));
  res$median=calc(temp,fun=function(x) quantile(x,probs=c(0.5),na.rm=T));
  res$q66=calc(temp,fun=function(x) quantile(x,probs=c(0.66),na.rm=T));
  return(res)
}

setwd("/home/alf/Documenti/aa_recent_work/lav_messeri/stats_WT")

dir_eobs_stacks="/home/alf/Documenti/aa_recent_work/lav_messeri/stats_WT/stack_months"
dirstatsWTMON="/home/alf/Documenti/aa_recent_work/lav_messeri/stats_WT"

##################################################################################################################

list_months_stacks_full=list(readRDS(paste0(dir_eobs_stacks,"/stack_rr_81_10.rds")),
                             readRDS(paste0(dir_eobs_stacks,"/stack_tg_81_10.rds")),
                             readRDS(paste0(dir_eobs_stacks,"/stack_tx_81_10.rds")),
                             readRDS(paste0(dir_eobs_stacks,"/stack_tn_81_10.rds")),
                             readRDS(paste0(dir_eobs_stacks,"/stack_gpm1_81_10.rds")))

saveRDS(list_months_stacks_full,"list_months_stacks_full.rds")

# index var & mese
##################################################################################################################

list_rr_WT=list();

for ( jj in 1:12) {
  list_rr_WT[[jj]]=list(lapply(list.files(path=dirstatsWTMON,pattern=paste0("*rr.*wt_",jj,"_"),recursive = T,full.names = T),readRDS))
}

saveRDS(list_rr_WT,"list_rr_WT.rds")

list_gp_WT=list();
for ( jj in 1:12){
  list_gp_WT[[jj]]=list(lapply(list.files(path=dirstatsWTMON,pattern=paste0("*gp.*wt_",jj,"_"),recursive = T,full.names = T),readRDS))
}
saveRDS(list_gp_WT,"list_gp_WT.rds")

list_tx_WT=list();
for ( jj in 1:12){
  list_tx_WT[[jj]]=list(lapply(list.files(path=dirstatsWTMON,pattern=paste0("*tx.*wt_",jj,"_"),recursive = T,full.names = T),readRDS))
}
saveRDS(list_tx_WT,"list_tx_WT.rds")

list_tg_WT=list();
for ( jj in 1:12){
  list_tg_WT[[jj]]=list(lapply(list.files(path=dirstatsWTMON,pattern=paste0("*tg.*wt_",jj,"_"),recursive = T,full.names = T),readRDS))
}
saveRDS(list_tg_WT,"list_tg_WT.rds")

list_tn_WT=list();
for ( jj in 1:12) {
  list_tn_WT[[jj]]=list(lapply(list.files(path=dirstatsWTMON,pattern=paste0("*tn.*wt_",jj,"_"),recursive = T,full.names = T),readRDS))
}
saveRDS(list_tn_WT,"list_tn_WT.rds")

# index mese e WT

##################################################################################################################
