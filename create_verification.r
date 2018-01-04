
args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least 4 arguments must be supplied!\n a) name pct09 \n b) name san09 \n c) numerical year integer \n d) numerical month \n")}


##########################################################################################


library(raster)
library(sfsmisc)
library(ncdf4)



##########################################################################################
# Setup directories

dirwk="/home/salute/seasonal/outcomes"

dirstatsWTMON="/home/salute/seasonal/procedure_data/stats_eobs/stats_eobs_wt"
dir_eobs_stacks="/home/salute/seasonal/procedure_data/stack_eobs/stacks_R"


##########################################################################################

vars=c("rr","tg","tx","tn","gpm1")

terciles_probs=function(x,xclim){breaks_clim = quantile(xclim,probs=seq(0,1,1/3),type = 8);
                                 diff(sapply(as.numeric(breaks_clim),function(y) sum(ifelse(x<as.numeric(y),1,0))))/length(x);
                                 }
terciles_count=function(x,xclim){breaks_clim = quantile(xclim,probs=seq(0,1,1/3),type = 8); 
                                 diff(sapply(as.numeric(breaks_clim),function(y) sum(ifelse(x<as.numeric(y),1,0))));
                                 }
up_quantile_probs=function(x,xclim,q){breaks_clim = quantile(xclim,probs=q,type = 8); 
                                      return(sum(ifelse(x>as.numeric(breaks_clim),1,0))/length(x));
}

up_quantile_count=function(x,xclim,q){breaks_clim = quantile(xclim,probs=q,type = 8); 
                                      newx=sum(ifelse(x>as.numeric(breaks_clim),1,0));
                                      return(newx) }

estrai_wt=function(x) as.numeric(sub(".nc.rds","",sub(".*wt.*_","",x)))

##########################################################################################

setwd(dirwk)

##########################################################################################
pct09file=paste0("/home/salute/seasonal/tests/",args[1])
san09file=paste0("/home/salute/seasonal/tests/",args[2])


message(pct09file)

pct9_freq=read.table(pct09file,header=F) 
san9_freq=read.table(san09file,header=F) 

n_month_p=as.numeric(args[4])
year_p=as.numeric(args[3])

saveRDS(pct9_freq,paste0("/home/salute/data/output/clima/observed/archive_obs/obs_pct9_freq_",n_month_p,"_",year_p,".rds"))
saveRDS(san9_freq,paste0("/home/salute/data/output/clima/observed/archive_obs/obs_san9_freq_",n_month_p,"_",year_p,".rds"))

#################################################################################################################

list_months_WT=list()
list_months_clim=list()

##########################################################################################

vars=c("rr","tg","tx","tn","gp")
nvars=length(vars)

######################################################################################################################

# Indexing the layer of clim wt :  first month, first var, first WT and first param => mean # list_months_WT[[1]][[1]][[1]][[1]] sd # list_months_WT[[1]][[1]][[1]][[2 ]]
 
list_months_WT[[1]]=lapply(1:5,function(y) lapply(1:9,function(x) {x=0;list(mean(x),sd(x)) }))

for ( j in 1:length(vars)) {fileswt=list.files(path=dirstatsWTMON,pattern=paste0("*",vars[j],".*wt_",n_month_p,"_"),recursive = T,full.names = T)
                            index=estrai_wt(fileswt)
                            list_months_WT[[1]][[j]][index]=lapply(fileswt,readRDS)

                           }

###########################################################################################################################################################
# all layer available

list_months_stacks_full=list(readRDS(paste0(dir_eobs_stacks,"/stack_rr_81_10.rds")),
                                         readRDS(paste0(dir_eobs_stacks,"/stack_tg_81_10.rds")),
                                         readRDS(paste0(dir_eobs_stacks,"/stack_tx_81_10.rds")),
                                         readRDS(paste0(dir_eobs_stacks,"/stack_tn_81_10.rds")),
                                         readRDS(paste0(dir_eobs_stacks,"/stack_gpm1_81_10.rds")))

list_months_stacks=list()

list_months_stacks[[1]]=list(list_months_stacks_full[[1]][[as.numeric(n_month_p)]],
                             list_months_stacks_full[[2]][[as.numeric(n_month_p)]],
                             list_months_stacks_full[[3]][[as.numeric(n_month_p)]],
                             list_months_stacks_full[[4]][[as.numeric(n_month_p)]],
                             list_months_stacks_full[[5]][[as.numeric(n_month_p)]])




#####################################################################################################################################
# Creazione delle osservazioni.

message("Creo le osservazioni....")

meanparameter=list()
sdparameter=list()
p33parameter=list()
p66parameter=list()

coef=1
mon=1

for ( par in 1:nvars) {

if ( par != 1 & par != 5 )  {ls_obs=as.numeric(san9_freq);coef=sum(ls_obs);}        
if ( par == 1 || par == 5 )  {coef=1;ls_obs=as.numeric(pct9_freq)}        

raster_mean=(ls_obs[1]*list_months_WT[[mon]][[par]][[1]][[1]]+
  ls_obs[2]*list_months_WT[[mon]][[par]][[2]][[1]]+
  ls_obs[3]*list_months_WT[[mon]][[par]][[3]][[1]]+
  ls_obs[4]*list_months_WT[[mon]][[par]][[4]][[1]]+
  ls_obs[5]*list_months_WT[[mon]][[par]][[5]][[1]]+
  ls_obs[6]*list_months_WT[[mon]][[par]][[6]][[1]]+
  ls_obs[7]*list_months_WT[[mon]][[par]][[7]][[1]]+
  ls_obs[8]*list_months_WT[[mon]][[par]][[8]][[1]]+
  ls_obs[9]*list_months_WT[[mon]][[par]][[9]][[1]])/coef;


raster_sd=(ls_obs[1]*list_months_WT[[mon]][[par]][[1]][[2]]+
  ls_obs[2]*list_months_WT[[mon]][[par]][[2]][[2]]+
  ls_obs[3]*list_months_WT[[mon]][[par]][[3]][[2]]+
  ls_obs[4]*list_months_WT[[mon]][[par]][[4]][[2]]+
  ls_obs[5]*list_months_WT[[mon]][[par]][[5]][[2]]+
  ls_obs[6]*list_months_WT[[mon]][[par]][[6]][[2]]+
  ls_obs[7]*list_months_WT[[mon]][[par]][[7]][[2]]+
  ls_obs[8]*list_months_WT[[mon]][[par]][[8]][[2]]+
  ls_obs[9]*list_months_WT[[mon]][[par]][[9]][[2]])/coef;
  
raster_p33=(ls_obs[1]*list_months_WT[[mon]][[par]][[1]][[3]]+
  ls_obs[2]*list_months_WT[[mon]][[par]][[2]][[3]]+
  ls_obs[3]*list_months_WT[[mon]][[par]][[3]][[3]]+
  ls_obs[4]*list_months_WT[[mon]][[par]][[4]][[3]]+
  ls_obs[5]*list_months_WT[[mon]][[par]][[5]][[3]]+
  ls_obs[6]*list_months_WT[[mon]][[par]][[6]][[3]]+
  ls_obs[7]*list_months_WT[[mon]][[par]][[7]][[3]]+
  ls_obs[8]*list_months_WT[[mon]][[par]][[8]][[3]]+
  ls_obs[9]*list_months_WT[[mon]][[par]][[9]][[3]])/coef;
  
raster_p66=(ls_obs[1]*list_months_WT[[mon]][[par]][[1]][[5]]+
  ls_obs[2]*list_months_WT[[mon]][[par]][[2]][[5]]+
  ls_obs[3]*list_months_WT[[mon]][[par]][[3]][[5]]+
  ls_obs[4]*list_months_WT[[mon]][[par]][[4]][[5]]+
  ls_obs[5]*list_months_WT[[mon]][[par]][[5]][[5]]+
  ls_obs[6]*list_months_WT[[mon]][[par]][[6]][[5]]+
  ls_obs[7]*list_months_WT[[mon]][[par]][[7]][[5]]+
  ls_obs[8]*list_months_WT[[mon]][[par]][[8]][[5]]+
  ls_obs[9]*list_months_WT[[mon]][[par]][[9]][[5]])/coef;


meanparameter[[par]]=raster_mean
sdparameter[[par]]=raster_sd
p33parameter[[par]]=raster_p33
p66parameter[[par]]=raster_p66

}


message("...fatto!")

##################################################################################################################à
#  Parametri (1) MeanEns Media forecast (2) MedianEns Mediana (3) SdEns Deviazione (4) AnomEns Anomalia clima (5) plTEns prob lower tercile 
#                 (6) pmTEns prob median tercile (7) puTEns prob  lower tercile (7) mostEnsmax prob tercile (8) puMadEns prob upper median
#                 (9) pvalWeq p.value Wilcoxon Mann Whitney 0.1clim vs forecast ens (10) MeanClim Media climatologica
#

message("Creo le statistiche...")

names_template=c("MeanObs", 
                             "SdObs", 
                             "P33_obs",
                             "P66_obs",
                              "AnomObs",
                              "MeanClim",
                              "Anom_P33_obs",
                              "Anom_P66_obs"
                              )

mon=1

for ( par in 1:nvars) {

    raster_temp=readRDS("template_eobs_observed.rds")
    merge_stack=stack(list_months_stacks[[mon]][[par]], meanparameter[[par]],sdparameter[[par]],p33parameter[[par]],p66parameter[[par]])
    indTest=c(rep(TRUE,30),rep(FALSE,2))
    merge_stack_df=as.data.frame(merge_stack)
    write.csv(merge_stack_df[58671,],file=paste0("/home/salute/data/output/clima/observed/archive_obs/",par,"_",n_month_p,"_",year_p,"_observed",".csv"),row.names=F)
    j=which(!is.na(merge_stack_df[,1])) #excluding NA value
    mean_clim=as.matrix(apply(merge_stack_df[j,],1,FUN=function(x) mean(as.numeric(x[1:30]),na.rm=T)))
    mean_obs=merge_stack_df[j,31]
    sd_obs=merge_stack_df[j,32]
    p33_obs=merge_stack_df[j,33]
    p66_obs=merge_stack_df[j,34]

    anomaly_obs= mean_obs-mean_clim                                                           
    anomaly_p33= p33_obs-mean_clim                                                           
    anomaly_p66= p66_obs-mean_clim                                                           
    
    raster_temp$MeanObs[j]=as.numeric(mean_obs)
    raster_temp$SdObs[j]=as.numeric(sd_obs)
    raster_temp$P33_obs[j]=as.numeric(p33_obs)
    raster_temp$P66_obs[j]=as.numeric(p66_obs) 
    raster_temp$AnomObs[j]=as.numeric(anomaly_obs) 
    raster_temp$MeanClim[j]=as.numeric(mean_clim) 
    raster_temp$AnomObs[j]=as.numeric(anomaly_p33) 
    raster_temp$MeanClim[j]=as.numeric(anomaly_p66) 

    saveRDS(raster_temp,paste0("observed_stack_",vars[par],"_",n_month_p,"_",year_p,".rds"))

  }



message("...fatto!")

#############################################################################################
message("Scrivo uscite...")

outdir="/home/salute/data/output/clima/observed"

setwd(dirwk)

#############################################################################################

e <- extent(-30,30,30,70) # final extent 

vars=c("rr","tg","tx","tn","gp") # predicted vars 

names_template=c("MeanObs", 
                             "SdObs", 
                             "P33_obs",
                             "P66_obs",
                              "AnomObs",
                              "MeanClim",
                              "Anom_P33_obs",
                              "Anom_P66_obs"
                              )



unit_list=list(var_units_rr=c("millimeters","millimeters","millimeters","millimeters","probability","probability","probability","cat","probability","probability","millimeters"),
                   var_units_tg=c("celsius degrees","celsius degree","celsius degree","celsius degree","probability","probability","probability","cat","probability","probability","celsius degree"),
                   var_units_tx=c("celsius degree","celsius degree","celsius degree","celsius degree","probability","probability","probability","cat","probability","probability","celsius degree"),
                   var_units_tn=c("celsius degree","celsius degree","celsius degree","celsius degree","probability","probability","probability","cat","probability","probability","celsius degree"),
                   var_units_gpm1=c("days","days","days","days","probability","probability","probability","cat","probability","probability","days"),
                   var_units_pppct09=c("hPa","hPa","hPa","hPa","probability","probability","probability","cat","probability","probability","hPa"),
                   var_units_ppsan09=c("hPa","hPa","hPa","hPa","probability","probability","probability","cat","probability","probability","hPa")
)


#############################################################################################

setwd(outdir)

for ( par in 1:nvars) {

temp=readRDS(paste0(dirwk,"/observed_stack_",vars[par],"_",n_month_p,"_",year_p,".rds"))

names_template_var = paste0(names_template,"_",vars[par])


#############################################################################################

mon=1

for ( z in 1:length(names_template_var)) {  writeRaster(crop(temp[[z]],e),
                                                                        filename=paste0("observed_",names_template_var[z],"_",n_month_p,"_",year_p,".nc"),
                                                                        "CDF", 
                                                                         overwrite=TRUE,
                                                                         varname=names_template_var[z],
                                                                         varunit=unit_list[[par]][[mon]],
                                                                         longname=names_template_var[z],
                                                                         xname="lon",
                                                                         yname="lat")
                                                        
                                           }

#############################################################################################

                        }


#############################################################################################
   

message("...fatto!")

#############################################################################################
