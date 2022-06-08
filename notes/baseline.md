# Baseline

## Code 

Starting point is hash `4b21b5` from May 19, 2022.

```
ssh wan895@compy
cd codes/scidac4_int
git clone --recursive git@github.com:E3SM-Project/E3SM.git master
```

## Test run: XS 2x5 days

* Minimal changes made to run_e3sm.template.sh:
  - Set proper machine and project names, paths;
  - Use compset `F2010` and resolution `ne30pg2_oECv3`;
  - Initial run;
  - Case name: `baseline_short`
* Output under `/compyfs/wanh895/scidac4_int/master/baseline_short/tests/XS_2x5_ndays/run`
  - 11 min/5 days (-> 2 min/day, 1 h/month, 12 h/year)
  - SYPD reported in `atm.log`: 2.05655157554886


## Test run: 5-year atmosphere simulation

### Case setup

* Compset: `F2010`
* Resolution: `ne30pg2_EC30to60E2r2`
* `CASE_GROUP`: `v2.LR.SciDAC4-PNNL`
* Hybrid run with an AMIP reference case:

```
readonly MODEL_START_TYPE="hybrid"  
readonly START_DATE="0001-01-01"

readonly GET_REFCASE=TRUE
readonly RUN_REFDIR="/compyfs/linw288/E3SMv2/v2.LR.amip_0101/rest/2010-01-01-00000"
readonly RUN_REFCASE="v2.LR.amip_0101"
readonly RUN_REFDATE="2010-01-01"
```
 * PE layout: 640 tasks (640/40 = 16 nodes)

### Paths

* Case name: `baseline_4b21b5_F2010`
* Run script: [`run_baseline_F2010_climate.sh`](https://github.com/huiwanpnnl/scidac_integration/blob/main/scripts/baseline/run_baseline_F2010_climate.sh)
* Run dir: `/compyfs/wanh895/scidac4_int/master/baseline_4b21b5_F2010/run/`
* Climo files: `/compyfs/wanh895/scidac4_int/master/baseline_4b21b5_F2010/climo/`
