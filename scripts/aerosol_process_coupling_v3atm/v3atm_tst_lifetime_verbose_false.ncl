;-- results ---
;(0)	                Burden     SF            DDF            SFWET            Lifetime
;(0)	     case 1: 1527121.3 Tg, 1216446.3 Tg/year, 906965.8 Tg/year, 136741.1 Tg/year, 458.22 day
;(0)	     case 2: 2218099.0 Tg, 1231374.0 Tg/year, 609086.0 Tg/year, 200417.4 Tg/year, 657.48 day
;(0)	 rel. diff.:  45%,          1%,           -33%,            47%,            43%  
;--------------------------------------------------------------------------------------------

  ; this script works only for simulations with history_verbose = .false.

  rsrtFile = (/"/compyfs/wanh895/scidac4_int/v3atm_clfx_new_imp/tst.restartBFB.amip.cflx_new.opt1/tests/custom-10_1x10_ndays/run/tst.restartBFB.amip.cflx_new.opt1.eam.r.2000-01-11-00000.nc", \
              "/compyfs/wanh895/scidac4_int/v3atm_clfx_new_imp/tst.restartBFB.amip.cflx_new.opt2/tests/custom-10_1x10_ndays/run/tst.restartBFB.amip.cflx_new.opt2.eam.r.2000-01-11-00000.nc"/)

  h0rsrtFile = (/"/compyfs/wanh895/scidac4_int/v3atm_clfx_new_imp/tst.restartBFB.amip.cflx_new.opt1/tests/custom-10_1x10_ndays/run/tst.restartBFB.amip.cflx_new.opt1.eam.rh0.2000-01-11-00000.nc", \
              "/compyfs/wanh895/scidac4_int/v3atm_clfx_new_imp/tst.restartBFB.amip.cflx_new.opt2/tests/custom-10_1x10_ndays/run/tst.restartBFB.amip.cflx_new.opt2.eam.rh0.2000-01-11-00000.nc"/)

  ncase = dimsizes(rsrtFile)

  SFName = (/"SF","DDF","SFWET"/)
  SFFctr = (/1,1,-1/)
  nSF    = dimsizes(SFName)

  burden = new( (/ncase/), "double" )
  SFlux  = new( (/ncase,nSF/), "double" )
  lifet  = new( (/ncase/), "double" )

 ;------------------------
 ; species
 ;------------------------
 ;mixingRatioName = "Mass_dst"
 ;modeName = (/"dst_a1","dst_a3"/)

  mixingRatioName = "Mass_ncl"
  modeName = (/"ncl_a1","ncl_a2","ncl_a3"/)

  nmode = dimsizes(modeName)
 ;------------------------

  gravit = 9.80616
  rEarth = 6371000.

  do icase = 0,ncase-1

     File = addfile(rsrtFile(icase),"r")
     area = File->area
    ;P0   = File->P0
     P0   = 1e5 
     hyai = File->hyai
     hybi = File->hybi
     nlev = dimsizes(hyai) - 1

     File = addfile(h0rsrtFile(icase),"r")
     ;------------------------
     ; Mixing ratio
     ;------------------------
     qq   = File->$mixingRatioName$(:,:)  ; (nlev,ncol)

     ;------------------------
     ; Burden 
     ;------------------------
     ps   = conform( qq, File->PS(:), (/1/) )
     da   = conform( qq, hyai(1:nlev) - hyai(0:nlev-1), 0 )
     db   = conform( qq, hybi(1:nlev) - hybi(0:nlev-1), 0 )

     dp   = P0 * da + ps * db

     qq_vint = dim_sum_n( qq * dp, 0 )/gravit

     ; global mean

     burden(icase) = sum(qq_vint*area) * rEarth^2

     ;------------------------
     ; Surface fluxes
     ;------------------------
     do iSF = 0,nSF-1

        varname = modeName(0)+SFName(iSF)
        SF  = File->$varname$(:)
        do ii = 1,nmode-1
           varname = modeName(ii)+SFName(iSF)
           SF = SF + File->$varname$(:)
        end do
        SFlux (icase,iSF) = sum(SF*area) * rEarth^2 * SFFctr(iSF)

     end do

     ;================================
     ; global mean
     ;================================
     lifet (icase) = burden(icase)/SFlux(icase,0)/86400.

     ;-- sanity check ---
     ;ps_glbavg = sum( dim_sum_n( dp, 0 ) *area)/sum(area) 
     ;print(ps_glbavg)
     ;--------------------

 end do

 print("                Burden     "+SFName(0)+"            "\
                                    +SFName(1)+"            "\
                                    +SFName(2)+"            "\
                                    +"Lifetime")

 do icase = 0,ncase-1
     print("     case "+(icase+1)+": "+sprintf("%5.1f",burden(icase)/1e9)+" Tg, "\
                                      +sprintf("%7.1f",SFlux(icase,0)/1e9*86400*365)+" Tg/year, "\
                                      +sprintf("%7.1f",SFlux(icase,1)/1e9*86400*365)+" Tg/year, "\
                                      +sprintf("%7.1f",SFlux(icase,2)/1e9*86400*365)+" Tg/year, "\
                                      +sprintf("%4.2f",lifet(icase))+" day")
 end do

     print(" rel. diff.: "+sprintf("%3.0f",(burden(1)/burden(0)-1.)*100.)+"%, "  \
                          +sprintf("%10.0f",(SFlux(1,0)/SFlux(0,0)-1.)*100.)+"%, "  \
                          +sprintf("%13.0f",(SFlux(1,1)/SFlux(0,1)-1.)*100.)+"%, "  \
                          +sprintf("%13.0f",(SFlux(1,2)/SFlux(0,2)-1.)*100.)+"%, "  \
                          +sprintf("%13.0f",(lifet (1)/lifet (0)-1.)*100.)+"%  "  )

