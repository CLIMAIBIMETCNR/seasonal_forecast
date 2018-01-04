library(raster)
library(sfsmisc)

##########################################################################################
# Setup directories

dirdataWT="/home/salute/seasonal/procedure_data/stack_wt"
dirdataWTstats="/home/salute/seasonal/procedure_data/stats_WT/"


vars=c("pp","tg","tx","tn","gpm1")


##########################################################################################

dir_WT_tg=list.files(path=dirdataWT,pattern="tg",recursive=F,full.names = T)

setwd(dir_WT_tg)
WT_tg=list.files(pattern="all.*san")

for ( i in 1:length(WT_tg)) {
temp=brick(WT_tg[i])
mean_WT=calc(temp,mean,na.rm=T)
sd_WT=calc(temp,sd,na.rm=T)
T_cf_95_WT=qt(.975, df=(as.numeric(nlayers(temp))-1))*(sd_WT/sqrt(as.numeric(nlayers(temp)))) #confidence interval
q_WT=calc(temp,fun=function(x) quantile(x,probs=c(0.33,0.5,0.66),na.rm=T))
q_mad_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.5)],na.rm=T)
q_lter_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.33)],na.rm=T)
q_uter_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.66)],na.rm=T)
res_WT=stack(mean_WT,sd_WT,T_cf_95_WT,q_WT,q_mad_WT,q_lter_WT,q_uter_WT)
fileout=paste0(dirdataWTstats,"stats_tg_wt/",gsub("all_","stats_",WT_tg[i]),".rds")
saveRDS(res_WT,fileout)
}

##########################################################################################
dir_WT_tx=list.files(path=dirdataWT,pattern="tx",recursive=F,full.names = T)
setwd(dir_WT_tx)
WT_tx=list.files(pattern="all.*san")

for ( i in 1:length(WT_tx)) {
  temp=brick(WT_tx[i])
  mean_WT=calc(temp,mean,na.rm=T)
  sd_WT=calc(temp,sd,na.rm=T)
  T_cf_95_WT=qt(.975, df=(as.numeric(nlayers(temp))-1))*(sd_WT/sqrt(as.numeric(nlayers(temp))))
  q_WT=calc(temp,fun=function(x) quantile(x,probs=c(0.33,0.5,0.66),na.rm=T))
  q_mad_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.5)],na.rm=T)
  q_lter_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.33)],na.rm=T)
  q_uter_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.66)],na.rm=T)
  res_WT=stack(mean_WT,sd_WT,T_cf_95_WT,q_WT,q_mad_WT,q_lter_WT,q_uter_WT)
  fileout=paste0(dirdataWTstats,"stats_tx_wt/",gsub("all_","stats_",WT_tx[i]),".rds")
  saveRDS(res_WT,fileout)
}

dir_WT_tn=list.files(path=dirdataWT,pattern="tn",recursive=F,full.names = T)
setwd(dir_WT_tn)
WT_tn=list.files(pattern="all.*san")

for ( i in 1:length(WT_tn)) {
temp=brick(WT_tn[i])
mean_WT=calc(temp,mean,na.rm=T)
sd_WT=calc(temp,sd,na.rm=T)
T_cf_95_WT=qt(.975, df=(as.numeric(nlayers(temp))-1))*(sd_WT/sqrt(as.numeric(nlayers(temp))))
q_WT=calc(temp,fun=function(x) quantile(x,probs=c(0.33,0.5,0.66),na.rm=T))
q_mad_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.5)],na.rm=T)
q_lter_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.33)],na.rm=T)
q_uter_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.66)],na.rm=T)
res_WT=stack(mean_WT,sd_WT,T_cf_95_WT,q_WT,q_mad_WT,q_lter_WT,q_uter_WT)
fileout=paste0(dirdataWTstats,"stats_tn_wt/",gsub("all_","stats_",WT_tn[i]),".rds")
saveRDS(res_WT,fileout)
}

dir_WT_rr=list.files(path=dirdataWT,pattern="rr",recursive=F,full.names = T)
setwd(dir_WT_rr)
WT_rr=list.files(pattern="all.*pct")
for ( i in 75:length(WT_rr)) {
temp=brick(WT_rr[i])
mean_WT=calc(temp,mean,na.rm=T)
sd_WT=calc(temp,sd,na.rm=T)
T_cf_95_WT=qt(.975, df=(as.numeric(nlayers(temp))-1))*(sd_WT/sqrt(as.numeric(nlayers(temp))))
q_WT=calc(temp,fun=function(x) quantile(x,probs=c(0.33,0.5,0.66),na.rm=T))
q_mad_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.5)],na.rm=T)
q_lter_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.33)],na.rm=T)
q_uter_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.66)],na.rm=T)
res_WT=stack(mean_WT,sd_WT,T_cf_95_WT,q_WT,q_mad_WT,q_lter_WT,q_uter_WT)
fileout=paste0(dirdataWTstats,"stats_rr_wt/",gsub("all_","stats_",WT_rr[i]),".rds")
saveRDS(res_WT,fileout)
}

dir_WT_gpm1=list.files(path=dirdataWT,pattern="gpm1",recursive=F,full.names = T)
setwd(dir_WT_gpm1)
WT_gpm1=list.files(pattern="all.*pct")

for ( i in 1:length(WT_gpm1)) {
  temp=brick(WT_gpm1[i])
  mean_WT=calc(temp,mean,na.rm=T)
  sd_WT=calc(temp,sd,na.rm=T)
  T_cf_95_WT=qt(.975, df=(as.numeric(nlayers(temp))-1))*(sd_WT/sqrt(as.numeric(nlayers(temp))))
  q_WT=calc(temp,fun=function(x) quantile(x,probs=c(0.33,0.5,0.66),na.rm=T))
  q_mad_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.5)],na.rm=T)
  q_lter_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.33)],na.rm=T)
  q_uter_WT=calc(temp,fun=function(x,na.rm=T) sort(x)[qbinom(c(.025,.975), length(x), 0.66)],na.rm=T)
  res_WT=stack(mean_WT,sd_WT,T_cf_95_WT,q_WT,q_mad_WT,q_lter_WT,q_uter_WT)
  fileout=paste0(dirdataWTstats,"stats_gpm1_wt/",gsub("all_","stats_",WT_gpm1[i]),".rds")
  saveRDS(res_WT,fileout)
}

#################################################################################################################################
