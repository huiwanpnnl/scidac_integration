# Revised cloud process coupling

## Motivation

In [Wan et al. (2021)](https://gmd.copernicus.org/articles/14/1921/2021/), it was found that more frequent coupling between the cloud macro-microphysics subcycles and the rest of EAMv1 would reduce the time-step sensitivities associated with the subtropical marine stratocumulus.

## Code 

New branch: [`huiwanpnnl/atm/cloud_process_coupling`](https://github.com/E3SM-Project/E3SM/tree/huiwanpnnl/atm/cloud_process_coupling)

Starting point is hash `4b21b5` on master from May 19, 2022.

```
ssh wanh895@compy
cd codes/scidac4_int
git clone --recursive git@github.com:E3SM-Project/E3SM.git clouds
cd clouds
git checkout -b huiwanpnnl/atm/cloud_process_coupling 4b21b54
git submodule update --init
```

### Modifications to v2 for implementing dribbling (see [this commit](https://github.com/E3SM-Project/E3SM/commit/d47976c3588573566312475cd6fe8f00a5bc2fda)):

* A new namelist variable `cld_cpl_opt` was added.
  * 1 = standard v2 (default)
  * integer larger than 1 = dribbling

* A new module file `cld_cpl_utils.F90` was added.

* Subroutine `tphysbc` in `physpkg.F90` was revised.


## BFB testing

Short 2x5-day simulations with a restart after day 5.

* Run script: [`run_cld_cpl_opt_1.sh`](https://github.com/huiwanpnnl/scidac_integration/blob/main/scripts/cloud_process_coupling/run_cld_cpl_opt_1.sh)

* Run directory on Compy: `/compyfs/wanh895/scidac4_int/clouds/cld_cpl_opt_1/tests/XS_2x5_ndays/run/`

* The following text in `atm.log` indicates that the original coupling scheme in EAMv2 was used:
`phys_ctl_readnl: cld_cpl_opt =            1`

* The following line in `atm.log` indicates that the results are BFB identical to those from the master: `nstep, te      481   0.26201811523625607E+10   0.26201826682369900E+10   0.83831016650550192E-04   0.98521053591103759E+05`

* For reference, the corresponding line from the baseline (hash `4b21b5` from May 19, 2022) is `nstep, te      481   0.26201811523625607E+10   0.26201826682369900E+10   0.83831016650550192E-04   0.98521053591103759E+05`

* If `cld_cpl_opt = 2` (see run script [`run_cld_cpl_opt_2.sh`](https://github.com/huiwanpnnl/scidac_integration/blob/main/scripts/cloud_process_coupling/run_cld_cpl_opt_2.sh)), the line becomes `nstep, te      481   0.26191913248362279E+10   0.26191929957203937E+10   0.92403964195646003E-04   0.98520428960411489E+05` 

## Five-year atmosphere simulation

### Case setup shared with the reference simulation

* Compset: `F2010`
* Resolution: `ne30pg2_EC30to60E2r2`
* `CASE_GROUP = v2.LR.SciDAC4-PNNL`
* Hybrid run starting from an AMIP reference case provided by Wuyin Lin:

```
readonly MODEL_START_TYPE="hybrid"  
readonly START_DATE="0001-01-01"

readonly GET_REFCASE=TRUE
readonly RUN_REFDIR="/compyfs/linw288/E3SMv2/v2.LR.amip_0101/rest/2010-01-01-00000"
readonly RUN_REFCASE="v2.LR.amip_0101"
readonly RUN_REFDATE="2010-01-01"
```
 * PE layout: 640 tasks (640/40 = 16 nodes)

### Simulation with dribbling

* Case name: `dribble_F2010`
* Revised coupling turned on using `cld_cpl_opt = 2` in `user_nl_eam`
* Run script: [`run_dribble_F2010_climate.sh`](https://github.com/huiwanpnnl/scidac_integration/blob/main/scripts/cloud_process_coupling/run_dribble_F2010_climate.sh)
* Run dir: `/compyfs/wanh895/scidac4_int/clouds/dribble_F2010/run/`



