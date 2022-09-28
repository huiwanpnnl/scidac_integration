test_dir="/compyfs/wanh895/scidac4_int/v3atm_clfx_new_imp/tst.restartBFB.amip.cflx_new.split/tests"
# Results were
# 6b2f078c266766ab335a216917c1ed60  atm_custom-10_1x10_ndays.txt
# 6b2f078c266766ab335a216917c1ed60  atm_custom-10_2x5_ndays.txt
# 6b2f078c266766ab335a216917c1ed60  atm_custom-30_1x10_ndays.txt

cd $test_dir
for test in custom*_*_ndays
do
  gunzip -c ${test}/run/atm.log.*.gz | grep '^ nstep, te ' | uniq > atm_${test}.txt
done

md5sum atm_*_ndays.txt
