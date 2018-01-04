library(raster)

setwd("/home/salute/seasonal/procedure_data/stack_eobs/montly")

############################################################################################

clim_tx=list.files(pattern=".*tx.*nc")
clim_tx=clim_tx[c(1,5:12,2:4)]
stack_tx=sapply(clim_tx,brick)
stack_tx=lapply(stack_tx,readAll)
saveRDS(stack_tx,"/home/salute/seasonal/procedure_data/stack_eobs/stacks_R/stack_tx_81_10.rds")

clim_tn=list.files(pattern=".*tn.*nc")
clim_tn=clim_tn[c(1,5:12,2:4)]
stack_tn=sapply(clim_tn,brick)
stack_tn=lapply(stack_tn,readAll)
saveRDS(stack_tn,"/home/salute/seasonal/procedure_data/stack_eobs/stacks_R/stack_tn_81_10.rds")

clim_tg=list.files(pattern=".*tg.*nc")
clim_tg=clim_tg[c(1,5:12,2:4)]
stack_tg=sapply(clim_tg,brick)
stack_tg=lapply(stack_tg,readAll)
saveRDS(stack_tg,"/home/salute/seasonal/procedure_data/stack_eobs/stacks_R/stack_tg_81_10.rds")

clim_rr=list.files(pattern=".*rr.*nc")
clim_rr=clim_rr[c(1,5:12,2:4)]
stack_rr=sapply(clim_rr,brick)
stack_rr=lapply(stack_rr,readAll)
saveRDS(stack_rr,"/home/salute/seasonal/procedure_data/stack_eobs/stacks_R/stack_rr_81_10.rds")

clim_gpm1=list.files(pattern=".*gpm1.*nc")
clim_gpm1=clim_gpm1[c(1,5:12,2:4)]
stack_gpm1=sapply(clim_gpm1,brick)
stack_gpm1=lapply(stack_gpm1,readAll)
saveRDS(stack_gpm1,"/home/salute/seasonal/procedure_data/stack_eobs/stacks_R/stack_gpm1_81_10.rds")

############################################################################################




