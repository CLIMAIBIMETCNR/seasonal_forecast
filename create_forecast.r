library(BioQC)
library(raster)
library(sfsmisc)




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

pct9_members=read.table("/home/salute/seasonal/frequenze_MEMBRI-pct9.csv",header=T) 
san9_members=read.table("/home/salute/seasonal/frequenze_MEMBRI-san9.csv",header=T) 


saveRDS(pct9_members,paste0("/home/salute/seasonal/archive/pct9_members_",Sys.Date(),".rds"))
saveRDS(san9_members,paste0("/home/salute/seasonal/archive/san9_members_",Sys.Date(),".rds"))



mon_forecast_rain=names(split(pct9_members,pct9_members$mese))
mon_forecast_thermal=names(split(san9_members,san9_members$mese))
ls_forecast_rain=split(pct9_members,pct9_members$mese)
ls_forecast_thermal=split(san9_members,san9_members$mese)

# indicizza i mesi

indls=order(sapply(1:length(unique(pct9_members$mese)),FUN=function(x) (min(as.numeric(rownames(ls_forecast_rain[[x]]))))))
indlt=order(sapply(1:length(unique(san9_members$mese)),FUN=function(x) (min(as.numeric(rownames(ls_forecast_thermal[[x]]))))))

# indicizza nomi mesi

mon_forecast_rain=as.numeric(mon_forecast_rain[indls])
mon_forecast_thermal=as.numeric(mon_forecast_thermal[indlt])

# indicizza liste

ls_forecast_rain=ls_forecast_rain[indls]
ls_forecast_thermal=ls_forecast_thermal[indlt]


##########################################################################################

list_months_WT=list()
list_months_clim=list()
list_months_stacks=list()

##########################################################################################

vars=c("rr","tg","tx","tn","gp")
nvars=length(vars)

######################################################################################################################

# Indexing the layer of clim wt :  first month, first var, first WT and first param => mean # list_months_WT[[1]][[1]][[1]][[1]] sd # list_months_WT[[1]][[1]][[1]][[2 ]]
 

for ( i in 1:length(mon_forecast_rain)) {
                                        list_months_WT[[i]]=lapply(1:5,function(y) lapply(1:9,function(x) {x=0;list(mean(x),sd(x)) }))
                                        for ( j in 1:length(vars)) {fileswt=list.files(path=dirstatsWTMON,pattern=paste0("*",vars[j],".*wt_",mon_forecast_rain[i],"_"),recursive = T,full.names = T)
                                                           index=estrai_wt(fileswt)
                                                           list_months_WT[[i]][[j]][index]=lapply(fileswt,readRDS)

                                                                  }
}





###########################################################################################################################################################
# all layer available

list_months_stacks_full=list(readRDS(paste0(dir_eobs_stacks,"/stack_rr_81_10.rds")),
                                         readRDS(paste0(dir_eobs_stacks,"/stack_tg_81_10.rds")),
                                         readRDS(paste0(dir_eobs_stacks,"/stack_tx_81_10.rds")),
                                         readRDS(paste0(dir_eobs_stacks,"/stack_tn_81_10.rds")),
                                         readRDS(paste0(dir_eobs_stacks,"/stack_gpm1_81_10.rds")))

list_months_stacks=list()

for ( i in 1:length(mon_forecast_rain)) {

list_months_stacks[[i]]=list(list_months_stacks_full[[1]][[as.numeric(mon_forecast_rain[i])]],
                                         list_months_stacks_full[[2]][[as.numeric(mon_forecast_rain[i])]],
                                         list_months_stacks_full[[3]][[as.numeric(mon_forecast_rain[i])]],
                                         list_months_stacks_full[[4]][[as.numeric(mon_forecast_rain[i])]],
                                         list_months_stacks_full[[5]][[as.numeric(mon_forecast_rain[i])]])


}

#####################################################################################################################################
# Creazione delle previsioni

message("Creo le previsioni....")

parameter_member=list()
month_member=list()
raster_member_mean=list()
raster_member_sd=list()
coef=1

ls_forecast=ls_forecast_thermal

for ( par in 1:nvars) {

for ( mon in 1:3) {

member_prev=nrow(ls_forecast_thermal[[mon]]);

if ( par == 1 || par == 5 )  {member_prev=nrow(ls_forecast_rain[[mon]]);}       

for ( member in 1:member_prev) {
  

if ( par != 1 & par != 5 )  {coef=sum(ls_forecast_thermal[[mon]][member,3:11]);ls_forecast=ls_forecast_thermal;}        
if ( par == 1 || par == 5 )  {coef=1;ls_forecast=ls_forecast_rain;}        

raster_member_mean[[member]]=(ls_forecast[[mon]][member,3]*list_months_WT[[mon]][[par]][[1]][[1]]+
                                                    ls_forecast[[mon]][member,4]*list_months_WT[[mon]][[par]][[2]][[1]]+
                                                    ls_forecast[[mon]][member,5]*list_months_WT[[mon]][[par]][[3]][[1]]+
                                                    ls_forecast[[mon]][member,6]*list_months_WT[[mon]][[par]][[4]][[1]]+
                                                    ls_forecast[[mon]][member,7]*list_months_WT[[mon]][[par]][[5]][[1]]+
                                                    ls_forecast[[mon]][member,8]*list_months_WT[[mon]][[par]][[6]][[1]]+
                                                    ls_forecast[[mon]][member,9]*list_months_WT[[mon]][[par]][[7]][[1]]+
                                                    ls_forecast[[mon]][member,10]*list_months_WT[[mon]][[par]][[8]][[1]]+
                                                    ls_forecast[[mon]][member,11]*list_months_WT[[mon]][[par]][[9]][[1]])/coef;
    
raster_member_sd[[member]]=(ls_forecast_thermal[[mon]][member,3]*list_months_WT[[mon]][[par]][[1]][[2]]+
                                                    ls_forecast[[mon]][member,4]*list_months_WT[[mon]][[par]][[2]][[2]]+
                                                    ls_forecast[[mon]][member,5]*list_months_WT[[mon]][[par]][[3]][[2]]+
                                                    ls_forecast[[mon]][member,6]*list_months_WT[[mon]][[par]][[4]][[2]]+
                                                    ls_forecast[[mon]][member,7]*list_months_WT[[mon]][[par]][[5]][[2]]+
                                                    ls_forecast[[mon]][member,8]*list_months_WT[[mon]][[par]][[6]][[2]]+
                                                    ls_forecast[[mon]][member,9]*list_months_WT[[mon]][[par]][[7]][[2]]+
                                                    ls_forecast[[mon]][member,10]*list_months_WT[[mon]][[par]][[8]][[2]]+
                                                    ls_forecast[[mon]][member,11]*list_months_WT[[mon]][[par]][[9]][[2]])/coef;
  
  
  
}

  month_member$mean[[mon]]=raster_member_mean   
  month_member$sd[[mon]]=raster_member_sd
  month_member$month[[mon]]=mon
  
}
  
  parameter_member$par[[par]]=month_member
  
}
message("...fatto!")

##################################################################################################################à
#  Parametri (1) MeanEns Media forecast (2) MedianEns Mediana (3) SdEns Deviazione (4) AnomEns Anomalia clima (5) plTEns prob lower tercile 
#                 (6) pmTEns prob median tercile (7) puTEns prob  lower tercile (7) mostEnsmax prob tercile (8) puMadEns prob upper median
#                 (9) pvalWeq p.value Wilcoxon Mann Whitney 0.1clim vs forecast ens (10) MeanClim Media climatologica
#

message("Creo le statistiche...")

names_template=c("MeanEns", "MedianEns", "SdEns", "AnomEns","plTEns","pmTEns","puTEns","mostEns","puMadEns","pvalWeq","MeanClim")
end_stacks=member_prev+30


for ( par in 1:nvars) {

for ( mon in 1:3) {
    
    member_prev=nrow(ls_forecast_thermal[[mon]]);

    if ( par == 1 || par == 5 )  {member_prev=nrow(ls_forecast_rain[[mon]]);}     

    raster_temp=readRDS("template_eobs_forecast.rds")

   
    merge_stack=stack(stack(list_months_stacks[[mon]][[par]]), stack(parameter_member$par[[par]]$mean[[mon]]))
    indTest=c(rep(TRUE,30),rep(FALSE,member_prev))
    merge_stack_df=as.data.frame(merge_stack)

    write.csv(merge_stack_df[58671,],file=paste0("/home/salute/seasonal/archive/firenze_",par,"_",mon,"_last",".csv"),row.names=F)

    j=which(!is.na(merge_stack_df[,1])) #excluding NA value
    mean_forecast=as.matrix(apply(merge_stack_df[j,],1,FUN=function(x) mean(as.numeric(x[31:end_stacks]),na.rm=T)))
    median_forecast=as.matrix(apply(merge_stack_df[j,],1,FUN=function(x) quantile(as.numeric(x[31:end_stacks]),0.5,type=8,na.rm=T)))
    sd_forecast=as.matrix(apply(merge_stack_df[j,],1,FUN=function(x) sd(as.numeric(x[31:end_stacks]),na.rm=T)))
    p_equal= as.numeric(BioQC::wmwTest(as.matrix(t(merge_stack_df[j,])),indTest,"p.two.sided"))
   
    tercile_prob=as.matrix(apply(merge_stack_df[j,],1,FUN=function(x) terciles_probs(na.omit(as.numeric(x[31:end_stacks])),na.omit(as.numeric(x[1:30])))*100))
    upmad_prob=as.matrix(apply(merge_stack_df[j,],1,FUN=function(x) up_quantile_probs(as.numeric(x[31:end_stacks]),na.omit(as.numeric(x[1:30])),0.5)*100))
    most_likely=as.numeric(apply(t(tercile_prob),1,function(x) which.max(x)[1]))
    mean_clim=as.matrix(apply(merge_stack_df[j,],1,FUN=function(x) mean(as.numeric(x[1:30]),na.rm=T)))
    anomaly=mean_forecast-mean_clim                                                           
  
    
  
    raster_temp$MeanEns[j]=mean_forecast
    raster_temp$MedianEns[j]=median_forecast
    raster_temp$SdEns[j]=sd_forecast
    raster_temp$AnomEns[j]=as.numeric(anomaly) 
    raster_temp$plTEns[j]=as.numeric(tercile_prob[1,])
    raster_temp$pmTEns[j]=as.numeric(tercile_prob[2,])
    raster_temp$puTEns[j]=as.numeric(tercile_prob[3,])
    raster_temp$mostEns[j]=as.numeric(most_likely)
    raster_temp$puMadEns[j]=as.numeric(upmad_prob)
    raster_temp$pvalWeq[j]=as.numeric(p_equal)
    raster_temp$MeanClim[j]=as.numeric(mean_clim) 

    saveRDS(raster_temp,paste0("forecast_stack_",vars[par],"_",mon,"_ahed.rds"))

  }

}

message("...fatto!")

#############################################################################################
message("Scrivo uscite...")

outdir="/home/salute/data/output/clima/"

setwd(dirwk)

#############################################################################################

e <- extent(-30,30,30,70) # final extent 

vars=c("rr","tg","tx","tn","gp") # predicted vars 

names_template=c("MeanEns", 
                             "MedianEns", 
                              "SdEns", 
                              "AnomEns",
                              "plTEns",
                              "pmTEns",
                              "puTEns",
                              "mostEns",
                              "puMadEns",
                              "pvalWeq",
                              "MeanClim")

blank=c(4,5,6,7,9,10) # layers blanked

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

for ( mon in 1:3) {
  
temp=readRDS(paste0(dirwk,"/forecast_stack_",vars[par],"_",mon,"_ahed.rds"))

mask_p10=calc(temp$pvalWeq,fun=function(x) ifelse(x<0.1,1,NA))

# mask_p1=calc(temp$pvalWeq,fun=function(x) ifelse(x<0.01,1,NA))

p_calc_stack=stack(temp$AnomEns,temp$plTEns,temp$puTEns,temp$mostEns)

temp$mostEns=calc(p_calc_stack,function(x) { ifelse(x[4]!=2,ifelse(x[2]>x[3],-1*x[2],x[3]),NA)})

#masking 

temp_mask=temp*mask_p10 

names(temp_mask) = names(temp)

names_template_var = paste0(names_template,"_",vars[par])


#############################################################################################


for ( z in 1:length(names_template_var)) {
                                                           if ( length(which(blank==z))==1) 
                                                                  { writeRaster(crop(temp_mask[[z]],e),
                                                                                 filename=paste0("forecast_",names_template_var[z],"_",par,"_",mon,".nc"),
                                                                                "CDF", 
                                                                                overwrite=TRUE,
                                                                                varname=names_template_var[z],
                                                                                varunit=unit_list[[par]][[mon]],
                                                                                longname=names_template_var[z],
                                                                                xname="lon",
                                                                                yname="lat")
                                                                 }
                                                           else { writeRaster(crop(temp[[z]],e),
                                                                                    filename=paste0("forecast_",names_template_var[z],"_",par,"_",mon,".nc"),
                                                                                   "CDF", 
                                                                                   overwrite=TRUE,
                                                                                   varname=names_template_var,
                                                                                   varunit=unit_list[[par]][[mon]],
                                                                                   longname=names_template_var[z],
                                                                                   xname="lon",
                                                                                   yname="lat")
                                                                   }
                                                           }

#############################################################################################
                        }
}

#############################################################################################

message("...fatto!")

#############################################################################################
