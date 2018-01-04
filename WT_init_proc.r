library(xts)
library(lubridate)
library(raster)
library(ncdf4)


pct09=read.csv("WT_data/pct09.cla",sep="",header=F)
san09=read.csv("WT_data/san09_500HGT.cla",sep="",header=F)

WTS=data.frame(WT_pct09=as.factor(pct09$V5),
               WT_san09=as.factor(san09$V5[1:13545])
               )

rownames(WTS)=ISOdate(pct09$V1,pct09$V2,pct09$V3)

saveRDS(WTS,"data/WTS_df.rds")

WTS_xts=as.xts(WTS)

saveRDS(WTS_xts,"data/WTS_xts.rds")

times_WTS=index(WTS_xts)

saveRDS(times_WTS,"data/times_WTS.rds")

months_WTS=month(times_WTS)

saveRDS(months_WTS,"data/months_WTS.rds")

list_month_f=list()

list_month_f[[1]]=table(months_WTS,WTS$WT_pct09)
list_month_f[[2]]=table(months_WTS,WTS$WT_san09)

write.csv(as.data.frame.array(list_month_f[[1]]),file="WT_data/f_WT_pct09.csv")
write.csv(as.data.frame.array(list_month_f[[2]]),file="WT_data/f_WT_san09.csv")


saveRDS(list_month_f,"data/list_month_f_WTS.rds")

#########################################################################àà
# reading lists

WTS=readRDS("data/WTS_df.rds")
WTS_xts=readRDS("data/WTS_xts.rds")
months_WTS=readRDS("data/months_WTS.rds")
times_WTS=readRDS("data/times_WTS.rds")


###########################################################################################
# list climatological 1980-2010

temp=data.frame(mon=months_WTS[732:11688],wt=WTS$WT_pct09[732:11688])
list_WT_WT_pct09=split(temp,temp[c('mon','wt')])
list_WT_pct09=lapply(list_WT_WT_pct09,function(x) rownames(x))
names(list_WT_pct09)<-gsub("\\.","_",paste0("ind_wt_",names(list_WT_pct09)))
saveRDS(list_WT_pct09,"data/list_WT_pct09.rds")

temp=data.frame(mon=months_WTS[732:11688],wt=WTS$WT_san09[732:11688])
list_WT_WT_san09=split(temp,temp[c('mon','wt')])
list_WT_san09=lapply(list_WT_WT_san09,function(x) rownames(x))
names(list_WT_san09)<-gsub("\\.","_",paste0("ind_wt_",names(list_WT_san09)))
saveRDS(list_WT_san09,"data/list_WT_san09.rds")

###########################################################################################
# list recent full 1979-2016

temp=data.frame(mon=months_WTS,wt=WTS$WT_pct09)
list_WT_WT_pct09=split(temp,temp[c('mon','wt')])
list_WT_pct09=lapply(list_WT_WT_pct09,function(x) rownames(x))
names(list_WT_pct09)<-gsub("\\.","_",paste0("ind_wt_",names(list_WT_pct09)))
saveRDS(list_WT_pct09,"data/list_WT_pct09_full.rds")

temp=data.frame(mon=months_WTS,wt=WTS$WT_san09)
list_WT_WT_san09=split(temp,temp[c('mon','wt')])
list_WT_san09=lapply(list_WT_WT_san09,function(x) rownames(x))
names(list_WT_san09)<-gsub("\\.","_",paste0("ind_wt_",names(list_WT_san09)))
saveRDS(list_WT_san09,"data/list_WT_san09_full.rds")

###########################################################################################
# Questo è il passaggio che crea degli stack WT per ogni mese

##############################################################################################à

list_WT_pct09=readRDS("data/list_WT_pct09.rds")          
list_WT_san09=readRDS("data/list_WT_san09.rds") 

list_WTS=list(list_WT_pct09,list_WT_san09)
names(list_WTS)=c("WT_pct09","WT_san09")


dir.create("all_wt")

############################################################################################################

rr_daily=brick( "stack_eobs/rr_0.25deg_reg_1981-2010_stack.nc",lvar=1)

j=1
  for (i in seq_along(list_WTS[[j]])) {

    days=as.numeric(unlist(list_WTS[[j]][i])) 
    
    if ( length(days) >0) {
            
    rr_temp_clim=subset(rr_daily,as.numeric(unlist(list_WTS[[j]][i])))
    
    writeRaster(rr_temp_clim,paste0("all_wt/all_rr_",names(list_WTS)[j],"_",names(list_WTS[[j]])[[i]]), "CDF", overwrite=TRUE,varname="rr",varunit="mm",longname="thickness_of_rainfall_amount",xname="longitude",yname="latitude")
  }
  } 


rm(rr_daily)

############################################################################################################

pp_daily=brick( "stack_eobs/pp_0.25deg_reg_1981-2010_stack.nc",lvar=1)


for (j in 1:2) {
  for (i in seq_along(list_WTS[[j]])) {
    
    days=as.numeric(unlist(list_WTS[[j]][i])) 
    
    if ( length(days) >0) {
    
    pp_temp_clim=subset(pp_daily,as.numeric(unlist(list_WTS[[j]][i])))
    
    writeRaster(pp_temp_clim,paste0("all_wt/all_pp_",names(list_WTS)[j],"_",names(list_WTS[[j]])[[i]]), "CDF", overwrite=TRUE,varname="pp",varunit="hPa",longname="air_pressure_at_sea_level",xname="longitude",yname="latitude")
  }
}
}


rm(pp_daily)

############################################################################################################


tx_daily=brick( "stack_eobs/tx_0.25deg_reg_1981-2010_stack.nc",lvar=1)


j=2
  for (i in seq_along(list_WTS[[j]])) {

    days=as.numeric(unlist(list_WTS[[j]][i])) 
    
    if ( length(days) >0) {
   
    tx_temp_clim=subset(tx_daily,as.numeric(unlist(list_WTS[[j]][i])))
    
    writeRaster(tx_temp_clim,paste0("all_wt/all_tx_",names(list_WTS)[j],"_",names(list_WTS[[j]])[[i]]), "CDF", overwrite=TRUE,varname="tx",varunit="Celsius",longname="maximum temperature",xname="longitude",yname="latitude")
  }
}


rm(tx_daily)
############################################################################################################


tn_daily=brick( "stack_eobs/tn_0.25deg_reg_1981-2010_stack.nc",lvar=1)

j=2
  for (i in seq_along(list_WTS[[j]])) {

    days=as.numeric(unlist(list_WTS[[j]][i])) 
    
    if ( length(days) >0) {
   
    tn_temp_clim=subset(tn_daily,as.numeric(unlist(list_WTS[[j]][i])))
    
    writeRaster(tn_temp_clim,paste0("all_wt/all_tn_",names(list_WTS)[j],"_",names(list_WTS[[j]])[[i]]), "CDF", overwrite=TRUE,varname="tn",varunit="Celsius",longname="minumum temperature",xname="longitude",yname="latitude")
  }
}


rm(tn_daily)

############################################################################################################

tg_daily=brick( "stack_eobs/tg_0.25deg_reg_1981-2010_stack.nc",lvar=1)


j=2
  for (i in seq_along(list_WTS[[j]])) {

    days=as.numeric(unlist(list_WTS[[j]][i])) 
    
    if ( length(days) >0) {
   
    tg_temp_clim=subset(tg_daily,as.numeric(unlist(list_WTS[[j]][i])))
    
    writeRaster(tg_temp_clim,paste0("all_wt/all_tg_",names(list_WTS)[j],"_",names(list_WTS[[j]])[[i]]), "CDF", overwrite=TRUE,varname="tg",varunit="Celsius",longname="mean temperature",xname="longitude",yname="latitude")
  }
}


rm(tg_daily)

############################################################################################################

gp1m_daily=brick( "stack_eobs/gpm1_0.25deg_reg_1981-2010_stack.nc",lvar=1)


j=1
  for (i in seq_along(list_WTS[[j]])) {

    days=as.numeric(unlist(list_WTS[[j]][i])) 
    
    if ( length(days) >0) {
   
    gp1m_temp_clim=subset(gp1m_daily,as.numeric(unlist(list_WTS[[j]][i])))
    
    writeRaster(gp1m_temp_clim,paste0("all_wt/all_gpm1_",names(list_WTS)[j],"_",names(list_WTS[[j]])[[i]]), "CDF", overwrite=TRUE,varname="gpm1",varunit="days",longname="rainy days over 1 mm",xname="longitude",yname="latitude")
  }
}


rm(gp1m_daily)

############################################################################################################

