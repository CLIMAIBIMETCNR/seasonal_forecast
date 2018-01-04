library(raster)
library(ncdf4)

##########################################################################################
# Setup directories

dirdataeobs="/home/alf/Documenti/aa_recent_work/lav_messeri/eobs_data/"
dirdataWTstats="/home/alf/Documenti/aa_recent_work/lav_messeri/eobs_data/stats_eobs_wt/"
dirstatsWTMON="/home/alf/Documenti/aa_recent_work/lav_messeri/eobs_data/stats_eobs_monthly/"

setwd(dirdataeobs)
##########################################################################################


calc_climatology_basic=function(temp) {
  res=list()
  names_template_month=c("mean","sd","q33","q50","q66")
  if (nlayers(temp) == 1 ) {res[[1]]=stack(temp)*1;
                            res[[2]]=stack(temp)*0;
                            res[[3]]=stack(temp)*NA;
                            res[[4]]=stack(temp)*NA;
                            res[[5]]=stack(temp)*NA;
                            res=stack(res)
                            names(res)=names_template_month
                            return(stack(res))
                  }
  res[[1]]=calc(temp,mean,na.rm=T);
  res[[2]]=calc(temp,sd,na.rm=T);
  res[[3]]=calc(temp,fun=function(x) quantile(x,probs=c(0.33),na.rm=T));
  res[[4]]=calc(temp,fun=function(x) quantile(x,probs=c(0.5),na.rm=T));
  res[[5]]=calc(temp,fun=function(x) quantile(x,probs=c(0.66),na.rm=T));
  res=stack(res)
  names(res)=names_template_month
  return(stack(res))
}

clim_normalize_day=function(temp,monthnumber) {
  res=list()
  names_template_month=c("mean","sd","q33","q50","q66")
  
  daysM=c(31,28,31,
       30,31,30,
       31,31,30,
       31,30,31)

  res[[1]]=temp[[1]]*daysM[monthnumber]
  res[[2]]=temp[[2]]*daysM[monthnumber]
  res[[3]]=temp[[3]]*daysM[monthnumber]
  res[[4]]=temp[[4]]*daysM[monthnumber]
  res[[5]]=temp[[5]]*daysM[monthnumber]
  res=stack(res)
  names(res)=names_template_month
  return(stack(res))
}
  
                                                                                                      


##########################################################################################
# define parameters

e <- extent(-30,30,30,70) # final extent 
vars=c("rr","tg","tx","tn","gp","pppct09","ppsan09") 
outcomes_n_clim=c("mean","sd","q33","q50","q66","anom")
names_template_month=c("MeanClim","SdClim","LT33Clim","MedianClim","UT66Clim")
names_template_WT=c("MeanClim_WT","SdClim_WT","LT33Clim_WT","MedianClim_WT","UT66Clim_WT","AnomClim_WT")

daysM=c(31,28,31,
       30,31,30,
       31,31,30,
       31,30,31)


unit_list=list(var_units_rr=c("millimeters","millimeters","millimeters","millimeters","probability","probability","probability","cat","probability","probability","millimeters"),
               var_units_tg=c("celsius degree","celsius degree","celsius degree","celsius degree","probability","probability","probability","cat","probability","probability","celsius degree"),
               var_units_tx=c("celsius degree","celsius degree","celsius degree","celsius degree","probability","probability","probability","cat","probability","probability","celsius degree"),
               var_units_tn=c("celsius degree","celsius degree","celsius degree","celsius degree","probability","probability","probability","cat","probability","probability","celsius degree"),
               var_units_gpm1=c("days","days","days","days","probability","probability","probability","cat","probability","probability","days"),
var_units_pppct09=c("hPa","hPa","hPa","hPa","probability","probability","probability","cat","probability","probability","hPa"),
var_units_ppsan09=c("hPa","hPa","hPa","hPa","probability","probability","probability","cat","probability","probability","hPa")
)


##########################################################################################
# create output dir for netcdf

if ( !dir.exists("climate_nc")) { dir.create("climate_nc") }

setwd("climate_nc")
if ( !dir.exists("stats_monthly")) { dir.create("stats_monthly") }
if ( !dir.exists("stats_wt")) { dir.create("stats_wt") }

##########################################################################################

for ( i in 1:length(vars)) {
    for ( j in 1:12) {
                       namem=list.files(path=dirstatsWTMON,pattern=paste0(vars[i],".*_",j,".nc.rds"),recursive = T,full.names = T)
                       nameoutm=list.files(path=dirstatsWTMON,pattern=paste0(vars[i],".*_",j,".nc.rds"),recursive = T,full.names = F)
                       res_calc=readRDS(namem)          
                       temp_month=crop(res_calc,e)
                       if ( i==1 || i==5) {temp_month=clim_normalize_day(temp_month,j)};
                       if ( i==1 || i==5) {res_calc=clim_normalize_day(res_calc,j)};
                       
                       for ( zz in 1:5) {
                       writeRaster(temp_month,
                                filename=paste0(names_template_month[zz],"_",vars[i],"_",j,".nc"),
                                "CDF", 
                                overwrite=TRUE,
                                varname=outcomes_n_clim[zz],
                                varunit=unit_list[[i]][[1]],
                                longname=paste0(names_template_month[zz],"_",vars[i]),
                                xname="lon",
                                yname="lat");
                       }
                       fileout=paste0("stats_monthly/",gsub("stats_","stats_def_",nameoutm))
                       saveRDS(temp_month,fileout)
                       rm(temp_month)
                    
                       for ( z in 1:9) {
                                  name=list.files(path=dirdataWTstats,pattern=paste0("*",vars[i],".*_",j,"_",z),recursive = T,full.names = T)
                                  nameout=list.files(path=dirdataWTstats,pattern=paste0("*",vars[i],".*_",j,"_",z),recursive = T,full.names = F)
                                  if ( length(name)==0) {next};
                                  if ( grepl(paste0("*",vars[i],".*_",j,"_",z),name)) {tempWT=readRDS(name)
                                                                                            if ( nlayers(tempWT)==1) {next};
                                
                                                                                               if ( i==1 || i==5) {
                                                                                                          mean=tempWT[[1]]*daysM[j]            
                                                                                                          anom=tempWT[[1]]*daysM[j]-res_calc[[1]]
                                                                                                          sd=tempWT[[2]]*daysM[j]
                                                                                                          q33=tempWT[[3]]*daysM[j]
                                                                                                          median=tempWT[[4]]*daysM[j]
                                                                                                          q66=tempWT[[5]]*daysM[j]  
                                                                                                          }
                                                                                       else               {
                                                                                                          mean=tempWT[[1]]*1            
                                                                                                          anom=tempWT[[1]]*1-res_calc[[1]]
                                                                                                          sd=tempWT[[2]]*1
                                                                                                          q33=tempWT[[3]]*1
                                                                                                          median=tempWT[[4]]*1
                                                                                                          q66=tempWT[[5]]*1 
                                                                                                          }
                                                                                         WT_stack=stack(mean,sd,q33,median,q66,anom);
                                                                                         names(WT_stack)=outcomes_n_clim;
                                                                                         for (zz in 1:nlayers(WT_stack)) { 
                                                                                                          temp_month_WT=crop(WT_stack[[zz]],e)
                                                                                                          writeRaster(temp_month_WT,
                                                                                                                      filename=paste0(names_template_WT[zz],"_",z,"_",vars[i],"_",j,".nc"),
                                                                                                                      "CDF", 
                                                                                                                      overwrite=TRUE,
                                                                                                                      varname=outcomes_n_clim[zz],
                                                                                                                      varunit=unit_list[[i]][[1]],
                                                                                                                      longname=paste0(names_template_WT[zz],"_",z,"_",vars[i],"_",j),
                                                                                                                      xname="lon",
                                                                                                                      yname="lat");
                                                                                         }
                                                                                         
                                                                                         
fileout=paste0("stats_wt/",gsub("stats_","stats_def_",nameout))

                       saveRDS(crop(WT_stack,e),fileout)
                       message(paste0("Fatto ","..vars ",i,"..mese ",j," wt ",z," ", fileout)) 
                                                                                         rm(temp_month_WT);
                                                                                        }
                                                                                         
                                                                                        }
                                  
                  
                
                                    
       }
   }



#################################################################################################
