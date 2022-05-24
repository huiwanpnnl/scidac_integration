# Baseline

## Code 

Starting point is hash `4b21b5` from May 19, 2022.

```
ssh wan895@compy
cd codes/scidac4_int
git clone --recursive https://github.com/E3SM-Project/E3SM.git master
```

## Test run 1: XS 2x5 days

* Minimal changes made to run_e3sm.template.sh:
  - Set proper machine and project names, paths;
  - Use F case and resolution as noted above;
  - Initial run;
  - Case name: `baseline_short`
* Output under `/compyfs/wanh895/scidac4_int/master/baseline_short/tests/XS_2x5_ndays/run`
  - 11 min/5 days (-> 2 min/day, 1 h/month, 12 h/year)
  - SYPD reported in `atm.log`: 2.05655157554886


## Test run 2: 5-year atmosphere simulation

