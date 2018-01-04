#!/bin/bash -l
############################################################################
#
# Project : WRF forecast system
# Author  : Gianni Messeri (LaMMA Regione Toscana)
# Date    : Thu Jun 20 07:03:07 GMT 2015
# RCS     : $Id$
#
############################################################################
############################################################################

echo "procedura x previsioni stagional con WT osservati" 

cd /home/salute/seasonal/ens_procedure


giorno=`date +%d --date='10 day ago'`
mese=`date +%-m --date='10 day ago'`
MESE=`date +%B --date='10 day ago'`
anno=`date +%Y --date='10 day ago'`


echo $giorno $mese $anno $MESE

NOME_PCT="OBS"$MESE"_"$anno"PCT9.txt"
NOME_SAN="OBS"$MESE"_"$anno"SAN9.txt"


cp /home/salute/seasonal/$NOME_PCT /home/salute/seasonal/tests/
cp /home/salute/seasonal/$NOME_SAN /home/salute/seasonal/tests/

echo $NOME_PCT $NOME_SAN


echo "Rscript create_verification.r $NOME_PCT $NOME_SAN $anno $mese"
Rscript create_verification.r $NOME_PCT $NOME_SAN $anno $mese

exit







