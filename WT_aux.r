require(raster)

month_days=c(31,28,31,30,31,30,31,31,30,31,30,31)

month2season=function(x,mseq="DJF",label=F){
  result=x
  res=list()
  
  for ( i in 1:12) {
    res[[i]]=which(x==i)
  }
  
  labels=c(1,2,3,4)
  if(label==T) {labels=c("DJF","MAM","JJA","SON")}
  if((label==T) & (mseq=="JFM")) {labels=c("JFM","AMJ","JAS","OND")}
  
  if ( mseq=="DJF") {
    result[c(res[[12]],res[[1]],res[[2]])]=labels[1]
    result[c(res[[3]],res[[4]],res[[5]])]=labels[2]
    result[c(res[[6]],res[[7]],res[[8]])]=labels[3]
    result[c(res[[9]],res[[10]],res[[11]])]=labels[4]
  } 
  
  if ( mseq=="JFM") {
    result[c(res[[1]],res[[2]],res[[12]])]=labels[1]
    result[c(res[[3]],res[[4]],res[[5]])]=labels[2]
    result[c(res[[6]],res[[7]],res[[8]])]=labels[3]
    result[c(res[[9]],res[[10]],res[[11]])]=labels[4]
    
  }   
  
  return(result)
  
}




cdo_anom_clim=function(file,climref="temp.nc") {
     cdo_cmd=Sys.which("cdo")
     if (cdo_cmd=="") {stop("Cdo must be available!")}
     outname=paste0("anom_",file)
     system(paste(cdo_cmd,"-b 64 sub", file,climref,outname))
}

cdo_day2month=function(infile,index_month=1,outfile="") {
  cdo_cmd=Sys.which("cdo")
  
  if (cdo_cmd=="") {stop("Cdo must be available!")}
 
   month_days=c(31,28,31,30,31,30,31,31,30,31,30,31)
  
  if (outfile =="") { outfile=paste0("mon_",infile)}
  system(paste0(cdo_cmd,"  -b 64 mulc,",as.character(month_days[index_month])," ", infile," ",outfile))
}





cdo_clim_summaries=function(file) {
  
  cdo_cmd=Sys.which("cdo")
  
  if (cdo_cmd=="") {stop("CDO climate operators must be available!")}
  
  outnamemean=paste0("avg_",file)
  outnamemax=paste0("max_",file)
  outnamemin=paste0("min_",file)
  outnamestd=paste0("std_",file)
  outname_p75=paste0("p75_",file)
  outname_p25=paste0("p25_",file)
  outname_p10=paste0("p10_",file)
  outname_p90=paste0("p90_",file)
  
  system(paste(cdo_cmd,"timavg", file,outnamemean))
  system(paste(cdo_cmd,"timmax", file,outnamemax))
  system(paste(cdo_cmd,"timmin", file,outnamemin))
  system(paste(cdo_cmd,"timstd", file,outnamestd))
  system(paste(cdo_cmd,"timpctl,90",file,"-timmin",file,"-timmax",file,outname_p90))
  system(paste(cdo_cmd,"timpctl,10",file,"-timmin",file,"-timmax",file,outname_p10))
  system(paste(cdo_cmd,"timpctl,25",file,"-timmin",file,"-timmax",file,outname_p25))
  system(paste(cdo_cmd,"timpctl,75",file,"-timmin",file,"-timmax",file,outname_p75))
}



cdo_fun_gp1m=function(filename,fun="gtc",tresh=",1",inpar="rr",outpar="gp1m") {
  cdo_cmd=Sys.which("cdo")
  
  if (cdo_cmd=="") {stop("CDO climate operators must be available!")}
  
  outname=gsub(inpar,outpar,filename)
  system(paste0(cdo_cmd," ",fun,tresh," ", filename," ", outname))
}

anom_calc_raster=function(xname,refname="temp.nc",varname="tg",varunit="Celsius",longname="Anom Air Temprature") {
  temp=raster("temp.nc");
  temp2=raster(as.character(xname));
  anom=temp2-temp;
  writeRaster(anom,paste0("anom_",xname),"CDF", overwrite=TRUE,varname=varname,varunit=varunit,longname=longname,xname="longitude",yname="latitude")
  
}

median_deriv_stack=function(xname,write.nc=FALSE,varname="tg",varunit="Celsius",longname="Average Air temperature",prefix="all/",outdir="") { 
  x=stack(brick(paste0(prefix,xname),lvar=1))
  madstack=calc(x, fun = function(x) { quantile(x,probs = c(0.25, 0.50, 0.75),na.rm=TRUE) });
  
  xname_median=paste0(outdir,gsub("all","median",xname))
  xname_p75=paste0(outdir,gsub("all","p75",xname))
  xname_p25=paste0(outdir,gsub("all","p25",xname))
  
  if (write.nc==TRUE)  { 
    
    writeRaster(madstack[[2]],xname_median, "CDF", overwrite=TRUE,varname=varname,varunit=varunit,longname=paste0(prefix," median ",longname),xname="longitude",yname="latitude")
    writeRaster(madstack[[3]],xname_p75,"CDF", overwrite=TRUE,varname=varname,varunit=varunit,longname=paste0(prefix," plussd ",longname),xname="longitude",yname="latitude")
    writeRaster(madstack[[1]],xname_p25,"CDF", overwrite=TRUE,varname=varname,varunit=varunit,longname=paste0(prefix," minussd ",longname),xname="longitude",yname="latitude")
    
  }
  if (write.nc==F)  { 
    return(madstack) 
  }
}




mean_deriv_stack=function(xname,write.nc=FALSE,varname="rr",varunit="mm",longname="thickness_of_rainfall_amount",factor=1,prefix="",outdir="") { 
  x=stack(brick(xname,lvar=1))
  mean=calc(x, fun = function(x) mean(x,na.rm=TRUE));
  sd=calc(x, fun = function(x)  sd(x,na.rm=TRUE));
  mean=mean*factor;
  meanplussd=mean+sd
  meanminussd=mean+sd
  
  xname_mean=paste0(outdir,gsub("all","mean",xname))
  xname_plussd=paste0(outdir,gsub("all","plussd",xname))
  xname_minussd=paste0(outdir,gsub("all","minusd",xname))
  xname_sd=paste0(outdir,gsub("all","sd",xname))
  
  if (write.nc==TRUE)  { 
    writeRaster(mean,xname_mean, "CDF", overwrite=TRUE,varname=varname,varunit=varunit,longname=paste0(prefix," mean ",longname),xname="longitude",yname="latitude")
    writeRaster(sd,xname_sd,"CDF", overwrite=TRUE,varname=varname,varunit=varunit,longname=paste0(prefix," sdev ",longname),xname="longitude",yname="latitude")
    writeRaster(meanplussd,xname_plussd,"CDF", overwrite=TRUE,varname=varname,varunit=varunit,longname=paste0(prefix," plussd ",longname),xname="longitude",yname="latitude")
    writeRaster(meanminussd,xname_minussd,"CDF", overwrite=TRUE,varname=varname,varunit=varunit,longname=paste0(prefix," minussd ",longname),xname="longitude",yname="latitude")
    
  }
  if (write.nc==FALSE)  { 
    return(stack(mean,sd,meanplussd,meanminussd)) 
  }
  
}



t.test.stack=function(xname.nc,yname.nc) {
  require(foreach)
  require(doParallel)
  require(raster)
  registerDoParallel(detectCores())  
  
  x=stack(brick(xname.nc,lvar=1))
  y=stack(brick(yname.nc,lvar=1))
  
  xmat=as.matrix(x);
  ymat=as.matrix(y);
  
  if (dim(x)[1]*dim(x)[2] ==  dim(y)[1]*dim(y)[2]) {len=dim(x)[1]*dim(x)[2]} else {stop("matrix o image dimensions doesn't fit!")};
  
  res=foreach (j=1:len) %dopar% { 
    if(!is.na(xmat[j,1])) {
      ifelse(t.test(xmat[j,], ymat[j,])$p.value<0.05,sign(mean(xmat[j,])-mean(ymat[j,])),0)
    }
    
  }
  
  t.test.raster=raster(x[[1]]);
  
  t.test.raster=setValues(t.test.raster,unlist(lapply(res, function(x) ifelse(is.null(x), NA, x))));         
  
  return(t.test.raster)
}


# https://publicwiki.deltares.nl/display/OET/Creating+a+netCDF+file+with+R
# http://gis.stackexchange.com/questions/67012/using-netcdf-for-point-time-series-observations


#library(ncdf4)

# Define data
#dataset = list(1:18250)

# Define the dimensions
#dimT = ncdim_def("Time", "days", 1:18250)

# Define missing value
#mv = -9999

# Define the data
#var1d = ncvar_def( "var1d", "units", dimT, mv, prec="double")

# Create the NetCDF file
# If you want a NetCDF4 file, explicitly add force_v4=T
#nc = nc_create("prova.nc", list(var1d))

# Write data to the NetCDF file
#ncvar_put(nc, var1d, dataset[[1]], start=c(1),
#          count=c(length(dataset[[1]])))

# Close your new file to finish writing
#nc_close(nc)

# reference

# https://gist.github.com/hakimabdi/7308bbd6d9d94cf0a1b8
# http://stackoverflow.com/questions/10573656/creating-multi-dimensional-netcdf-in-r
