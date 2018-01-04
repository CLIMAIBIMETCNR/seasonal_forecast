wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/tg_0.25deg_reg_1950-1964_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/tg_0.25deg_reg_1965-1979_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/tg_0.25deg_reg_1980-1994_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/tg_0.25deg_reg_1995-2016_v14.0.nc.gz

wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/tn_0.25deg_reg_1950-1964_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/tn_0.25deg_reg_1965-1979_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/tn_0.25deg_reg_1980-1994_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/tn_0.25deg_reg_1995-2016_v14.0.nc.gz

wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/tx_0.25deg_reg_1950-1964_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/tx_0.25deg_reg_1965-1979_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/tx_0.25deg_reg_1980-1994_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/tx_0.25deg_reg_1995-2016_v14.0.nc.gz

wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/rr_0.25deg_reg_1950-1964_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/rr_0.25deg_reg_1965-1979_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/rr_0.25deg_reg_1980-1994_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/rr_0.25deg_reg_1995-2016_v14.0.nc.gz


wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/pp_0.25deg_reg_1950-1964_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/pp_0.25deg_reg_1965-1979_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/pp_0.25deg_reg_1980-1994_v14.0.nc.gz
wget http://www.ecad.eu/download/ensembles/data/Grid_0.25deg_reg/pp_0.25deg_reg_1995-2016_v14.0.nc.gz


gzip -d pp_0.25deg_reg_1995-2016_v14.0.nc.gz
gzip -d pp_0.25deg_reg_1980-1994_v14.0.nc.gz

gzip -d tg_0.25deg_reg_1980-1994_v14.0.nc.gz
gzip -d tg_0.25deg_reg_1995-2016_v14.0.nc.gz

gzip -d tn_0.25deg_reg_1980-1994_v14.0.nc.gz
gzip -d tn_0.25deg_reg_1995-2016_v14.0.nc.gz

gzip -d tx_0.25deg_reg_1980-1994_v14.0.nc.gz
gzip -d tx_0.25deg_reg_1995-2016_v14.0.nc.gz

gzip -d rr_0.25deg_reg_1980-1994_v14.0.nc.gz
gzip -d rr_0.25deg_reg_1995-2016_v14.0.nc.gz


gzip -d pp_0.25deg_reg_1950-1964_v14.0.nc.gz
gzip -d pp_0.25deg_reg_1965-1979_v14.0.nc.gz

gzip -d rr_0.25deg_reg_1950-1964_v14.0.nc.gz
gzip -d rr_0.25deg_reg_1965-1979_v14.0.nc.gz

gzip -d tg_0.25deg_reg_1950-1964_v14.0.nc.gz
gzip -d tg_0.25deg_reg_1965-1979_v14.0.nc.gz

gzip -d tx_0.25deg_reg_1950-1964_v14.0.nc.gz
gzip -d tx_0.25deg_reg_1965-1979_v14.0.nc.gz

gzip -d tn_0.25deg_reg_1950-1964_v14.0.nc.gz
gzip -d tn_0.25deg_reg_1965-1979_v14.0.nc.gz





cdo cat pp_0.25deg_reg_1950-1964_v14.0.nc pp_0.25deg_reg_1965-1979_v14.0.nc  pp_0.25deg_reg_1980-1994_v14.0.nc pp_0.25deg_reg_1995-2016_v14.0.nc  pp_0.25deg_reg_1950-2016_v14.0.nc
cdo cat rr_0.25deg_reg_1950-1964_v14.0.nc rr_0.25deg_reg_1965-1979_v14.0.nc  rr_0.25deg_reg_1980-1994_v14.0.nc rr_0.25deg_reg_1995-2016_v14.0.nc  rr_0.25deg_reg_1950-2016_v14.0.nc
cdo cat tg_0.25deg_reg_1950-1964_v14.0.nc tg_0.25deg_reg_1965-1979_v14.0.nc  tg_0.25deg_reg_1980-1994_v14.0.nc tg_0.25deg_reg_1995-2016_v14.0.nc  tg_0.25deg_reg_1950-2016_v14.0.nc
cdo cat tx_0.25deg_reg_1950-1964_v14.0.nc tx_0.25deg_reg_1965-1979_v14.0.nc  tx_0.25deg_reg_1980-1994_v14.0.nc tx_0.25deg_reg_1995-2016_v14.0.nc  tx_0.25deg_reg_1950-2016_v14.0.nc 
cdo cat tn_0.25deg_reg_1950-1964_v14.0.nc tn_0.25deg_reg_1965-1979_v14.0.nc  tn_0.25deg_reg_1980-1994_v14.0.nc tn_0.25deg_reg_1995-2016_v14.0.nc  tn_0.25deg_reg_1950-2016_v14.0.nc


cdo seldate,1981-01-01,2010-12-31 pp_0.25deg_reg_1950-2016_v14.0.nc pp_0.25deg_reg_1981-2010_v14.0.nc
cdo seldate,1981-01-01,2010-12-31 rr_0.25deg_reg_1950-2016_v14.0.nc rr_0.25deg_reg_1981-2010_v14.0.nc
cdo seldate,1981-01-01,2010-12-31 tg_0.25deg_reg_1950-2016_v14.0.nc tg_0.25deg_reg_1981-2010_v14.0.nc
cdo seldate,1981-01-01,2010-12-31 tx_0.25deg_reg_1950-2016_v14.0.nc tx_0.25deg_reg_1981-2010_v14.0.nc
cdo seldate,1981-01-01,2010-12-31 tn_0.25deg_reg_1950-2016_v14.0.nc tn_0.25deg_reg_1981-2010_v14.0.nc

cdo gtc,1 rr_0.25deg_reg_1981-2016_v14.0.nc gp1m_0.25deg_reg_1981-2010_v14.0.nc



cdo monsum rr_0.25deg_reg_1981-2010_v14.0.nc rr_monthly_normal_sum_1981-2010.nc
cdo monsum gp1m_0.25deg_reg_1981-2010_v14.0.nc gp1m_monthly_normal_sum_1981-2010.nc


cdo ymonpctl,50 rr_monthly_normal_sum_1981-2010.nc -ymonmin rr_monthly_normal_sum_1981-2010.nc -ymonmax rr_monthly_normal_sum_1981-2010.nc rr_monthly_normal_pctl50.nc
cdo ymonpctl,25 rr_monthly_normal_sum_1981-2010.nc -ymonmin rr_monthly_normal_sum_1981-2010.nc -ymonmax rr_monthly_normal_sum_1981-2010.nc rr_monthly_normal_pctl25.nc
cdo ymonpctl,75 rr_monthly_normal_sum_1981-2010.nc -ymonmin rr_monthly_normal_sum_1981-2010.nc -ymonmax rr_monthly_normal_sum_1981-2010.nc rr_monthly_normal_pctl75.nc
cdo ymonmean rr_monthly_normal_sum_1981-2010.nc  rr_monthly_normal_mean.nc


cdo ymonmean gp1m_monthly_normal_sum_1981-2010.nc gp1m_monthly_normal_mean.nc
cdo ymonpctl,50 gp1m_monthly_normal_sum_1981-2010.nc -ymonmin gp1m_monthly_normal_sum_1981-2010.nc -ymonmax gp1m_monthly_normal_sum_1981-2010.nc gp1m_monthly_normal_pctl50.nc
cdo ymonpctl,25 gp1m_monthly_normal_sum_1981-2010.nc -ymonmin gp1m_monthly_normal_sum_1981-2010.nc -ymonmax gp1m_monthly_normal_sum_1981-2010.nc  gp1m_monthly_normal_pctl25.nc
cdo ymonpctl,75 gp1m_monthly_normal_sum_1981-2010.nc -ymonmin gp1m_monthly_normal_sum_1981-2010.nc -ymonmax gp1m_monthly_normal_sum_1981-2010.nc gp1m_monthly_normal_pctl75.nc


cdo ymonmean  tg_0.25deg_reg_1981-2010_v14.0.nc tg_monthly_normal_mean.nc
cdo ymonpctl,50 tg_0.25deg_reg_1981-2010_v14.0.nc -ymonmin tg_0.25deg_reg_1981-2010_v14.0.nc -ymonmax tg_0.25deg_reg_1981-2010_v14.0.nc tg_monthly_normal_pctl50.nc
cdo ymonpctl,25 tg_0.25deg_reg_1981-2010_v14.0.nc -ymonmin tg_0.25deg_reg_1981-2010_v14.0.nc -ymonmax tg_0.25deg_reg_1981-2010_v14.0.nc  tg_monthly_normal_pctl25.nc
cdo ymonpctl,75 tg_0.25deg_reg_1981-2010_v14.0.nc -ymonmin tg_0.25deg_reg_1981-2010_v14.0.nc -ymonmax tg_0.25deg_reg_1981-2010_v14.0.nc tg_monthly_normal_pctl75.nc

cdo ymonmean  tx_0.25deg_reg_1981-2010_v14.0.nc tx_monthly_normal_mean.nc
cdo ymonpctl,50 tx_0.25deg_reg_1981-2010_v14.0.nc -ymonmin tx_0.25deg_reg_1981-2010_v14.0.nc -ymonmax tx_0.25deg_reg_1981-2010_v14.0.nc tx_monthly_normal_pctl50.nc
cdo ymonpctl,25 tx_0.25deg_reg_1981-2010_v14.0.nc -ymonmin tx_0.25deg_reg_1981-2010_v14.0.nc -ymonmax tx_0.25deg_reg_1981-2010_v14.0.nc  tx_monthly_normal_pctl25.nc
cdo ymonpctl,75 tx_0.25deg_reg_1981-2010_v14.0.nc -ymonmin tx_0.25deg_reg_1981-2010_v14.0.nc -ymonmax tx_0.25deg_reg_1981-2010_v14.0.nc tx_monthly_normal_pctl75.nc

cdo ymonmean  tn_0.25deg_reg_1981-2010_v14.0.nc tn_monthly_normal_mean.nc
cdo ymonpctl,50 tn_0.25deg_reg_1981-2010_v14.0.nc -ymonmin tn_0.25deg_reg_1981-2010_v14.0.nc -ymonmax tn_0.25deg_reg_1981-2010_v14.0.nc tn_monthly_normal_pctl50.nc
cdo ymonpctl,25 tn_0.25deg_reg_1981-2010_v14.0.nc -ymonmin tn_0.25deg_reg_1981-2010_v14.0.nc -ymonmax tn_0.25deg_reg_1981-2010_v14.0.nc  tn_monthly_normal_pctl25.nc
cdo ymonpctl,75 tn_0.25deg_reg_1981-2010_v14.0.nc -ymonmin tn_0.25deg_reg_1981-2010_v14.0.nc -ymonmax tn_0.25deg_reg_1981-2010_v14.0.nc tn_monthly_normal_pctl75.nc

cdo ymonmean  pp_0.25deg_reg_1981-2010_v14.0.nc pp_monthly_normal_mean.nc
cdo ymonpctl,50 pp_0.25deg_reg_1981-2010_v14.0.nc -ymonmin pp_0.25deg_reg_1981-2010_v14.0.nc -ymonmax pp_0.25deg_reg_1981-2010_v14.0.nc pp_monthly_normal_pctl50.nc
cdo ymonpctl,25 pp_0.25deg_reg_1981-2010_v14.0.nc -ymonmin pp_0.25deg_reg_1981-2010_v14.0.nc -ymonmax pp_0.25deg_reg_1981-2010_v14.0.nc  pp_monthly_normal_pctl25.nc
cdo ymonpctl,75 pp_0.25deg_reg_1981-2010_v14.0.nc -ymonmin pp_0.25deg_reg_1981-2010_v14.0.nc -ymonmax pp_0.25deg_reg_1981-2010_v14.0.nc pp_monthly_normal_pctl75.nc
