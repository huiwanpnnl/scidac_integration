# Implementing CondiDiag1.0 in EAMv2

## References

* [Paper published in GMD](https://gmd.copernicus.org/articles/15/3205/2022/gmd-15-3205-2022.html)
* [EAMv1 implementation shared on Zenodo](https://zenodo.org/record/6325126)


## Code branch 

`huiwanpnnl/atm/CondiDiag1.0_in_v2`
(branched off from master at hash `4b21b5` from May 19, 2022)


## Work environment

All simulations mentioned below were performed on Compy.

## Implementation

Started from `CondiDiag1.0_in_EAMv1.tar.gz` shared on [Zenodo](https://zenodo.org/record/6325126).

* New files
  * Copied all files in `CondiDiag1.0_in_EAMv1/new_files/` to v2's `components/eam/src/physics/cam/`.
  * In `conditional_diag_main:get_values`, updated the name of the 3rd argument of `cnst_get_ind` from `abort` to `abrtf`.
  * Increased `conditional_diag:nchkpt_max` from 99 to 250, so that one can monitor more checkpoints (e.g., mac-mic substeps). 
  * Subroutine`zm_conv:buoyan_dilute` has a new input arguement `iclosure`. Set to `.true.` in `misc_diagnostics:compute_cape` for the standard CAPE calculation.

  
* Revised CIME file
  * `components/eam/bld/namelist_files/namelist_definition.xml`. Set array `hist_tape_with_all_output` to size 10 to be consistent with other history-tape-related variables.

* Revised Fortran files
  * `components/eam/src/control/cam_comp.F90`
  * `components/eam/src/control/cam_history_support.F90`
  * `components/eam/src/control/cam_restart.F90`
  * `components/eam/src/control/runtime_opts.F90`
  * `components/eam/src/physics/cam/restart_physics.F90`
  * `components/eam/src/physics/cam/zm_conv.F90`

## Short BFB testing

### Simulations

Common setup was taken from `run_e3sm.template.sh` except:

* `XS_2x5_ndays`, i.e., two 5-day runs with a restart in between.
* Compset `F2010`
* Resolution `ne30pg2_oECv3`
* Initial run starting from 0001-01-01

Three simulations were run and compared:

* `baseline_short`: master (hash `4b21b5` from May 19, 2022)
* `CondiDiag_off_short`: CondiDiag implemented but turned off.
* `CondiDiag_on_short`: Instantaneous CondiDiag output in h1 and h2. 
   * Addition to `user_nl_eam`:

```
! CondiDiag

 metric_name = 'ALL',
 qoi_chkpt = 'PBCINI','DEEPCU','STCLD','MCTCPL','AERDRYRM'

 qoi_name = 'Q', 'Q',
 qoi_nver =  72,  72,
 qoi_x_dp =   0,   1,

 l_output_state = .true.
 l_output_incrm = .true.

 hist_tape_with_all_output = 2,3
```

  * Output in `atm.log` indicating CondiDiag was turned on:


```
 ===============================================================================
                *** Conditional diagnostics requested ***
 ===============================================================================

          metric  nlev   cmpr_type   threshold   tolerance   cnd_eval_chkpt    cnd_end_chkpt
 001         ALL     -           -           -           -                -          PBCDIAG

 --------------------------------------------------
       qoi_chkpt     mult_by_dp
 001      PBCINI             -1
 002      DEEPCU             -1
 003       STCLD             -1
 004      MCTCPL             -1
 005    AERDRYRM             -1

 --------------------------------------------------
        QoI_name    nlev     mult_by_dp   nlev_save
 001           Q      72              0          72
 002           Q      72              1           1

 --------------------------------------------------
  l_output_state =  T
  l_output_incrm =  T

 hist_tape_with_all_output =     2    3
 --------------------------------------------------

       "multiply by dp" selections, final

                   Q         Q
    PBCINI         0         1
    DEEPCU         0         1
     STCLD         0         1
    MCTCPL         0         1
  AERDRYRM         0         1
 ===============================================================================
```

### BFB and timing check using `atm.log`

* `baseline_short` 
  * `/compyfs/wanh895/scidac4_int/master/baseline_short/tests/XS_2x5_ndays/run/`
  * `nstep, te      481   0.26201811523625607E+10   0.26201826682369900E+10   0.83831016650550192E-04   0.98521053591103759E+05`
  
  ```
  Total run time (sec) :    658.407609234098
  Time Step Loop run time(sec) :    578.973211449571
  SYPD :    2.04284062994686
  ```
  
  ```
  Total run time (sec) :    639.211111476179
  Time Step Loop run time(sec) :    572.716915541328
  SYPD :    2.05655157554886
  ```
  
* `CondiDiag_off_short`
   * `/compyfs/wanh895/scidac4_int/CondiDiag_impl/CondiDiag_off_short/tests/XS_2x5_ndays/run/`
   * `nstep, te      481   0.26201811523625607E+10   0.26201826682369900E+10   0.83831016650550192E-04   0.98521053591103759E+05`

   ```
   Total run time (sec) :    669.395321153104
  Time Step Loop run time(sec) :    598.112766389735
  SYPD :    1.97746991280455

   ```
   ```
  Total run time (sec) :    694.750744990073
  Time Step Loop run time(sec) :    586.652033488732
  SYPD :    2.00770100121476
   ```
   
* `CondiDiag_on_short`
   * `/compyfs/wanh895/scidac4_int/CondiDiag_impl/CondiDiag_on_short/tests/XS_2x5_ndays/run/`
   * `nstep, te      481   0.26201811523625607E+10   0.26201826682369900E+10   0.83831016650550192E-04   0.98521053591103759E+05`

  ```
  Total run time (sec) :    677.240542617626
  Time Step Loop run time(sec) :    575.349273167085
  SYPD :    2.05570781985940
  ```

   ```
  Total run time (sec) :    690.054864298087
  Time Step Loop run time(sec) :    587.455025480129
  SYPD :    2.00495667568315

   ```


### BFB check using history files

The following files were compared using `cdo diffv` and were found to have the same contents:

* `/compyfs/wanh895/scidac4_int/master/baseline_short/tests/XS_2x5_ndays/run/baseline_short.eam.h4.0001-01-01-00000.nc`
* `/compyfs/wanh895/scidac4_int/CondiDiag_impl/CondiDiag_off_short/tests/XS_2x5_ndays/run/CondiDiag_off_short.eam.h4.0001-01-01-00000.nc`
* `/compyfs/wanh895/scidac4_int/CondiDiag_impl/CondiDiag_on_short/tests/XS_2x5_ndays/run/CondiDiag_on_short.eam.h4.0001-01-01-00000.nc`

## Testing the functionality

Four 1-month simulations were performed. The first 3 were the use cases shown in [the GMD paper](https://gmd.copernicus.org/articles/15/3205/2022/gmd-15-3205-2022.html). The last one was a CAPE budget analysis. Note that simulations in the GMD paper were performed with EAMv1 and for October, while the test simulations here were use EAMv2 and for January, so the plotted results showed some differences in the details although the key features were the same.

The run scripts (`.sh` files), postprocessing scripts (`.ncl` files), and plots (PDF files) can be found in [a GitHub repo](https://github.com/huiwanpnnl/scidac_integration/tree/main/scripts/CondiDiag).
