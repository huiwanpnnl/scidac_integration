
#--------------------------------------------------------------------
## Baseline (before my change)
#------
#test_dir="/compyfs/wanh895/scidac4_int/v3atm_clfx_new_imp/tst.restartBFB.amip.cflx_new.ref/tests"
#------
## Results were
## 6b2f078c266766ab335a216917c1ed60  atm_custom-10_1x10_ndays.txt

#--------------------------------------------------------------------
## Splitting clubb_surface
#------
#test_dir="/compyfs/wanh895/scidac4_int/v3atm_clfx_new_imp/tst.restartBFB.amip.cflx_new.split/tests"
#------
## Results were
## 6b2f078c266766ab335a216917c1ed60  atm_custom-10_1x10_ndays.txt
## 6b2f078c266766ab335a216917c1ed60  atm_custom-10_2x5_ndays.txt
## 6b2f078c266766ab335a216917c1ed60  atm_custom-30_1x10_ndays.txt
#--------------------------------------------------------------------

#----------------------------------------------------------------------
## After implementing cflx_cpl_opt = 1, 2 ; default (cflx_cpl_opt = 1)
#------
test_dir="/compyfs/wanh895/scidac4_int/v3atm_clfx_new_imp/tst.restartBFB.amip.cflx_new.opt1/tests"
#------
## Results were
## 6b2f078c266766ab335a216917c1ed60  atm_custom-10_1x10_ndays.txt
## 6b2f078c266766ab335a216917c1ed60  atm_custom-10_2x5_ndays.txt
## 6b2f078c266766ab335a216917c1ed60  atm_custom-30_1x10_ndays.txt
## 6b2f078c266766ab335a216917c1ed60  atm_custom-30_2x5_ndays.txt
#--------------------------------------------------------------------

#----------------------------------------------------------------------
## After implementing cflx_cpl_opt = 1, 2 ; setting cflx_cpl_opt = 2
#------
## test_dir="/compyfs/wanh895/scidac4_int/v3atm_clfx_new_imp/tst.restartBFB.amip.cflx_new.opt2_nonBFB/tests"
#------
## Results were
## 40afa98083417c4c009a50c912de020b  atm_custom-10_1x10_ndays.txt
## 9e6050f41c4177ac8898c08bbfbd68fe  atm_custom-10_2x5_ndays.txt
## 40afa98083417c4c009a50c912de020b  atm_custom-30_1x10_ndays.txt

#------
#test_dir="/compyfs/wanh895/scidac4_int/v3atm_clfx_new_imp/tst.restartBFB.amip.cflx_new.opt2/tests"
#------
## Results were
## 40afa98083417c4c009a50c912de020b  atm_custom-10_1x10_ndays.txt
## 40afa98083417c4c009a50c912de020b  atm_custom-10_2x5_ndays.txt
## 40afa98083417c4c009a50c912de020b  atm_custom-30_1x10_ndays.txt
## 40afa98083417c4c009a50c912de020b  atm_custom-30_2x5_ndays.txt

cd $test_dir
for test in custom*_*_ndays
do
  gunzip -c ${test}/run/atm.log.*.gz | grep '^ nstep, te ' | uniq > atm_${test}.txt
done

md5sum atm_*_ndays.txt
