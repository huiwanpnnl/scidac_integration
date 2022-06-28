


  climoFile = (/"/compyfs/wanh895/scidac4_int/master/baseline_4b21b5_F2010/climo/baseline_4b21b5_F2010_ANN_201001_201412_climo.nc", \
                "/compyfs/wanh895/scidac4_int/aerosol/aerosol_F2010/climo/aerosol_F2010_ANN_201001_201412_climo.nc"/)

  ncase = dimsizes(climoFile)
  burden = new( ncase, "double" )
  SFlux  = new( ncase, "double" )
  lifet  = new( ncase, "double" )

 ;mixingRatioName = "Mass_dst"
 ;SFName = (/"SFdst_a1","SFdst_a3"/)

  mixingRatioName = "Mass_ncl"
  SFName = (/"SFncl_a1","SFncl_a2","SFncl_a3"/)

  gravit = 9.80616
  rEarth = 6371000.

  do icase = 0,ncase-1

     File = addfile(climoFile(icase),"r")
     area = File->area

     ;------------------------
     ; Mixing ratio
     ;------------------------
     qq   = File->$mixingRatioName$(0,:,:,:)

     ;------------------------
     ; Burden 
     ;------------------------
     P0   = File->P0
     hyai = File->hyai
     hybi = File->hybi
     nlev = dimsizes(hyai) - 1

     ps   = conform( qq, File->PS(0,:,:), (/1,2/) )
     da   = conform( qq, hyai(1:nlev) - hyai(0:nlev-1), 0 )
     db   = conform( qq, hybi(1:nlev) - hybi(0:nlev-1), 0 )

     dp   = P0 * da + ps * db

     qq_vint = dim_sum_n( qq * dp, 0 )/gravit

     ;------------------------
     ; Surface flux
     ;------------------------
     nSF = dimsizes(SFName)
     SF  = File->$SFName(0)$(0,:,:)
     do ii = 1,nSF-1
        SF = SF + File->$SFName(ii)$(0,:,:)
     end do

     ;================================
     ; global mean
     ;================================
     burden(icase) = sum(qq_vint*area) * rEarth^2
     SFlux (icase) = sum(SF*area) * rEarth^2
     lifet (icase) = burden(icase)/SFlux (icase)/86400.

     ;-- sanity check ---
     ;ps_glbavg = sum( dim_sum_n( dp, 0 ) *area)/sum(area) 
     ;print(ps_glbavg)
     ;--------------------

 end do

 print("           Burden     Sfc Flux      Lifetime")

 do icase = 0,ncase-1
     print("     case "+(icase+1)+": "+sprintf("%5.1f",burden(icase)/1e9)+" Tg, "\
                                      +sprintf("%7.1f",SFlux(icase)/1e9*86400*365)+" Tg/year, "\
                                      +sprintf("%3.1f",lifet(icase))+" day")
 end do

     print(" rel. diff.: "+sprintf("%3.0f",(burden(1)/burden(0)-1.)*100.)+"%, "  \
                          +sprintf("%11.0f",(SFlux (1)/SFlux (0)-1.)*100.)+"%, "  \
                          +sprintf("%9.0f",(lifet (1)/lifet (0)-1.)*100.)+"%  "  )

