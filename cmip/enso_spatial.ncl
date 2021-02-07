load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
begin

SEASON = (/"DJF","MAM","JJA","SON" /)

diri = "/glade/work/chenxing/enso/"
diri0 = "/glade/u/home/chenxing/enso/"

diri1 = "/glade/work/chenxing/enso/E3SM/"
diri2 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/cesm_lens/Amon/ts/"
;ts_Amon_CESM1-CAM5_historical_rcp85_r40i1p1_192001-210012.nc
diri3 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/canesm2_lens/Amon/ts/"
;ts_Amon_CanESM2_historical_rcp85_r50i1p1_195001-210012.nc
diri4 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/csiro_mk36_lens/Amon/ts/"
;ts_Amon_CSIRO-Mk3-6-0_historical_rcp85_r30i1p1_185001-210012.nc
diri5 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/gfdl_cm3_lens/Amon/ts/"
;ts_Amon_GFDL-CM3_historical_rcp85_r20i1p1_192001-210012.nc
diri6 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/gfdl_esm2m_lens/Amon/ts/"
;ts_Amon_GFDL-ESM2M_historical_rcp85_r30i1p1_195001-210012.nc
diri7 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/mpi_lens/Amon/ts/"
;ts_Amon_MPI-ESM_historical_rcp85_r100i1p1_185001-209912.nc


ntimes = (/2019-1854, 2011-1850, 2100-1920, 2100-1950, 2100-1850, 2100-1920, 2100-1950, 2099-1850/)+1 ;length of time
ys = (/1854, 1850, 1920, 1950, 1850, 1920, 1950, 1850/) ;start year of datasets
yl = (/2019, 2011, 2100, 2100, 2100, 2100, 2100, 2099/) ;end year of datasets
re_lat = (/ 89, 180, 192, 64, 96, 90, 90, 96/)
re_lon = (/ 180, 360, 288, 128, 192, 144, 144, 192/)
nens = (/1, 11, 40, 50, 30, 20, 30, 100 /) ;ensemble number
nens_all = 100
yr_finish = 2011

MODEL = (/"OBS", "E3SM","CESM","CanESM2", "CSIRO-Mk3-6-0","GFDL-CM3","GFDL-ESM2M","MPI-ESM" /)
nmo = dimsizes(MODEL)

do im = 1,nmo-1

  ;----------read index------------------
  f0   = addfile(diri+MODEL(im)+"_ipo_"+yr_finish+".nc", "r")
  pc  = f0->pc(:,0,:)
  printVarSummary(pc)

  f0 = addfile(diri+MODEL(im)+"_ENSO_index.nc", "r")
  epi = f0->epi(:,:(yr_finish+1 - ys(im))*12-1) ;extract historical only
  cpi = f0->cpi(:,:(yr_finish+1 - ys(im))*12-1) 
  mxi = f0->nino34(:,:(yr_finish +1- ys(im))*12-1) 
  printVarSummary(mxi)

  epi_sea = epi(:,::12)
  cpi_sea = cpi(:,::12)
  mxi_sea = mxi(:,::12)

  do ia = 0,nens_all-1
    epi_sea(ia,:) = dim_rmvmean_n_Wrap( month_to_season(epi(ia,:), "DJF"), 0)
    cpi_sea(ia,:) = dim_rmvmean_n_Wrap( month_to_season(cpi(ia,:), "DJF"), 0)
    mxi_sea(ia,:) = dim_rmvmean_n_Wrap( month_to_season(mxi(ia,:), "DJF"), 0)
  end do 

    epi = dim_rmvmean_n_Wrap(epi, 1)
    cpi = dim_rmvmean_n_Wrap(cpi, 1)
    mxi = dim_rmvmean_n_Wrap(mxi, 1)


  vsea_el_avg = new((/nens_all,4,2,re_lat(im), re_lon(im)/), "float")
  vc_sea = new((/nens_all,4,1,re_lat(im), re_lon(im)/), "float")
  vclm = new((/nens_all,12,re_lat(im), re_lon(im)/), "float")
  nino_el = new((/nens_all, 60,24/),float)

  do ia = 0,nens_all-1;dimsizes(f_input)-1 ;nens(im)-1

    ib = ia+1

    ea = sprinti("%0.2i", ib)


    if (MODEL(im).eq."E3SM") then 
    f_input = systemfunc(" ls -1 "+diri1+"E3SM_en"+ea+"_TS_185001-201112.nc") 
    else if (MODEL(im).eq."CESM") then  
    f_input = systemfunc(" ls -1 "+diri2+"ts_Amon_CESM1-CAM5_historical_rcp85_r"+ib+"i1p1_192001-210012.nc") 
    else if (MODEL(im).eq."CanESM2") then  
    f_input = systemfunc(" ls -1 "+diri3+"ts_Amon_CanESM2_historical_rcp85_r"+ib+"i1p1_195001-210012.nc") 
    else if (MODEL(im).eq."CSIRO-Mk3-6-0") then  
    f_input = systemfunc(" ls -1 "+diri4+"ts_Amon_CSIRO-Mk3-6-0_historical_rcp85_r"+ib+"i1p1_185001-210012.nc") 
    else if (MODEL(im).eq."GFDL-CM3") then  
    f_input = systemfunc(" ls -1 "+diri5+"ts_Amon_GFDL-CM3_historical_rcp85_r"+ib+"i1p1_192001-210012.nc") 
    else if (MODEL(im).eq."GFDL-ESM2M") then  
    f_input = systemfunc(" ls -1 "+diri6+"ts_Amon_GFDL-ESM2M_historical_rcp85_r"+ib+"i1p1_195001-210012.nc") 
    else if (MODEL(im).eq."MPI-ESM") then  
    f_input = systemfunc(" ls -1 "+diri7+"ts_Amon_MPI-ESM_historical_rcp85_r"+ib+"i1p1_185001-209912.nc") 
    end if 
    end if 
    end if 
    end if 
    end if 
    end if 
    end if 

        print(f_input(0))
      exists = isfilepresent(f_input(0))
      if(.not.exists) then
        print("file doesn't exist, keep on to the next cycle")
        continue
      end if
      
    ; do i =0,nm-1
      f   = addfile(f_input(0), "r")

    ;only do historical part here first
    TIME2=f->time
    yyyymm2=cd_calendar(TIME2, -1)
    printMinMax(yyyymm2, True)
    ; ymstrts = ind(yyyymm2.eq.ymstrt)
    ymlasts = ind(yyyymm2.eq.201112)

    if (MODEL(im).eq."E3SM") then ;some problems correctly reading time dim of E3SM
        var  = f->ts;(:ymlasts,:,:);
        var@_FillValue = 1e+20
        var@missing_value = 1e+20
    else 
        var  = f->ts(:ymlasts,:,:);
    end if 
    delete([/f,TIME2,yyyymm2/]);,lat,lon
     
    ndd = dimsizes(var)

    vclm(ia,:,:,:) = clmMonTLL(var(ndd(0)-40*12:,:,:))
    vano = rmMonAnnCycTLL(var);(var, vclm(ia,:,:,:))
    va_sea = month_to_seasonN(vano, SEASON)
    vc_sea(ia,:,:,:,:) = month_to_seasonN(vclm(ia,:,:,:), SEASON)
    printVarSummary(va_sea)

    ;global mean ts
    lat = var&lat
    rad    = 4.0*atan(1.0)/180.0
    clat   = cos(lat*rad)
    vgm = wgt_areaave_Wrap(var,clat, 1.0, 1) ;global mean
    vgm_annual = month_to_annual(vgm, 1) ;annual mean
    printVarSummary(vgm_annual)
    vgm_annual&year = ispan(ys(im), yr_finish, 1)
    delete([/lat,clat/])


    ;------------select El Nino year based on Nino index----------------------
    BINDS = mxi_sea(ia,:) ;cpi; epi; mxi
    BIND  = mxi(ia,:)

    nino_std = stddev(BINDS)
    print(nino_std)
    iel05 = ind(BINDS.gt.0.5*nino_std);.and.pc(ia,:).ge.0 )
    iel1  = ind(BINDS.gt.1.0*nino_std )

    yr_el0 = iel05+ys(im)
    print("El Nino cases is ") ;
    print(""+yr_el0)
    yr_el = yr_el0 - ys(im)
    print(yr_el+"")

    nel = dimsizes(yr_el)
    ;-----------------------------------------
    ndim = dimsizes(var)
    vsea_el = new((/nel,4,2,ndim(1),ndim(2)/),float,var@_FillValue)
    do ie = 0,nel-1 
      if(yr_el0(ie).gt.ys(im).and.yr_el0(ie).lt.yr_finish)

        kk = yr_el(ie)
        aa = kk*12-1*12
        bb = kk*12+1*12-1
        ; print(yr_el0(ie))
        ; print(aa+"-"+bb)

        nino_el(ia,ie,:)    =  BIND(aa:bb)

        aa = kk-1
        bb = kk+1-1

        vsea_el(ie,:,:,:,:)    =  va_sea(:,aa:bb,:,:)
      end if 
    end do 


    ;El Nino years composite
    vsea_el_avg(ia,:,:,:,:) = dim_avg_n_Wrap(vsea_el, 0)

    delete([/yr_el,iel05,iel1,yr_el0,vsea_el,BIND,BINDS/])

    ; ;just some check for the whole data series
    ; nyr = ndim(0)/12
    ; nino_all = new((/nyr,24/),float,var@_FillValue)
    ; do ie = 1,nyr-2

    ;     aa = ie*12-1*12
    ;     bb = ie*12+1*12-1

    ;   nino_all(ie,:)    =  BIND(aa:bb)

    ; end do 
    ; nino_all_avg = dim_avg_n_Wrap(nino_all, 0)

    print(MODEL(im)+" en"+ea+" is done!")
  end do 

  vel_mean = dim_avg_n_Wrap(vsea_el_avg, 0)
  vc_mean = dim_avg_n_Wrap(vc_sea, 0)
  vclm_mean = dim_avg_n_Wrap(vclm, 0)
  nino_el_avg = dim_avg_n_Wrap(nino_el, (/0,1/))

  vel_mean&season := ispan(1, 4, 1)
  vc_mean&season := ispan(1, 4, 1)
  printVarSummary(vel_mean)

  ;------output--------------
  fon=diri+MODEL(im)+"_clim_enso34_ts.nc";
  system("rm -f "+fon)
  fo=addfile(fon,"c")
  fo->ts = vc_mean;(0,:,:)
  fo->enso = vel_mean;(1,0,:,:)

  delete([/var,vano,va_sea,vgm/])

  ;=========plot=========================
    wks         = gsn_open_wks("ps",diri0+"enso_spatial_"+MODEL(im)) 
    plot3 = new(12, graphic)
    plot4 = new(12, graphic)
    plot5 = new(12, graphic)

    res          = True
    res@gsnFrame = False
    res@gsnDraw  = False

    res@mpMinLonF            =  0               
    res@mpMaxLonF            =  360             
    res@mpMinLatF            =  -90             
    res@mpMaxLatF            =   90

    res@cnFillPalette         = "BlueWhiteOrangeRed"; "MPL_BrBG"

    res@gsnAddCyclic         = True
    res@gsnLeftString = ""
    res@gsnRightString = ""

    res@mpCenterLonF         = 180.         ; default is 0 [GM]
    res@gsnLeftStringFontHeightF = 0.02
    ; res@tiMainFontHeightF = 0.03
   res@tmXBLabelFontHeightF = 0.015
   res@tmYLLabelFontHeightF = 0.015

  sdres = res
    opt = res

  sdres@cnFillOn = False
  sdres@cnLinesOn = False
  sdres@cnLineLabelsOn        = False   
  sdres@cnSmoothingOn = True
  sdres@cnSmoothingTensionF = 1
  sdres@cnInfoLabelOn = False
  sdres@gsnLeftString = ""

    opt@gsnShadeFillType = "pattern"      ; pattern fill
    opt@gsnShadeHigh = 17          ; 高于95的use pattern #17
    opt@gsnShadeLow = -1       ;低于95为空白  
    opt@cnLineLabelsOn        = False   
    opt@cnInfoLabelOn  = False
    opt@lbLabelBarOn = False
    opt@gsnLeftString  = ""



    resc = res 
    resc@cnFillOn             = False         ; turn on color fill
    resc@cnInfoLabelOn        = False
    resc@cnLinesOn            = True         ; True is default
    resc@cnLineLabelsOn       = False
    resc@cnLineColor   = "red"
    resc@cnLevelSelectionMode  = "ManualLevels"
    resc@cnLevelSpacingF = 2.0
    resc@cnLineThicknessF = 2.0

    res@cnFillOn             = True         ; turn on color fill
    res@cnLinesOn            = False         ; True is default
    res@cnLineLabelsOn       = False

    
    res@mpFillOn      = False  
    res@mpOutlineOn                 = True
    res@mpGeophysicalLineColor    ="gray40"         ;地图边界线颜色
    res@mpGeophysicalLineThicknessF      = 1

    res@lbLabelBarOn = False;True ;
    res@lbOrientation = "vertical"
    res@lbTitleOn        =  True                ; turn on title
    res@lbTitleString     = vel_mean@units
    ; res@lbTitleString    = "K"                ; title string
    res@lbTitlePosition  = "Top"              ; title position
    res@lbTitleFontHeightF= .01                ; make title smaller
    ; res@lbTitleDirection = "Across"             
    res@lbTitleExtentF   = 0.01 ;Default: 0.15
    res@lbLabelFontHeightF = 0.01  ;Default: 0.02
    res@pmLabelBarWidthF = 0.05

    vcres = res 
      vcres@gsnScalarContour= True                  ; vectors over contours

    vcres@vcGlyphStyle            = "FillArrow"    ; turn on curly vectors
    vcres@vcMinFracLengthF        = 0.25 
    vcres@vcMinDistanceF          = 0.015
    vcres@vcRefLengthF            = 0.04             ; define length of vec ref
    ; vcres@vcLineArrowThicknessF   = 1.1

    vcres@vcRefAnnoOn             = True
    vcres@vcRefAnnoPerimOn          = False          ;参考矢量的边框
    vcres@vcRefAnnoString2          = "m/s"           ;not draw the word"reference vector"
    vcres@vcRefAnnoOrthogonalPosF = -0.1            ; move ref vector up

    vcres@vcRefMagnitudeF         = 8.0;           ; define vector ref mag

    res@cnLevelSelectionMode  = "ManualLevels"


  ;;ensemble mean
        ; res@cnMinLevelValF        =   290.0-273.
        ; res@cnMaxLevelValF        =   305.-273.
        ; res@cnLevelSpacingF       =  1.

      do ia = 0,3
        res@gsnLeftString = SEASON(ia)
        res@gsnRightString = "climatology"
        plot3(ia)   = gsn_csm_contour_map_ce(wks,vc_mean(ia,0,:,:),res)
      end do 

        res@cnMinLevelValF        =   -1.5
        res@cnMaxLevelValF        =    1.5 
        res@cnLevelSpacingF       =  res@cnMaxLevelValF/15.

    do iy = 0,1
      do ia = 0,3
        res@gsnLeftString = SEASON(ia)+" yr"+iy
        res@gsnRightString = "composite of El Ninos"
        plot4(ia+iy*4)   = gsn_csm_contour_map_ce(wks,vel_mean(ia,iy,:,:),res)
      end do 
    end do 

  delete(res)


  ;------------XY--------------------
    res                    = True              ; plot mods desired
    res@gsnDraw            = False             ; don't draw yet
    res@gsnFrame           = False             ; don't advance frame yet
    ;res@gsnMaximize        = True
    res@vpWidthF  = 0.85
    res@vpHeightF = 0.4
    
    res@gsnScale = True               

    
    res@tmXTOn              = False   ; Turn off top tickmarks
    res@tmYROn              = False
    res@tmYLMinorOn         = False   ; Turn off left minor tickmarks
    res@tmXBMinorOn         = False

    res@tiXAxisString = ""             
    res@tiYAxisString = vel_mean@units    
    res@tiXAxisFontHeightF = 0.02
    res@tiYAxisFontHeightF = 0.02
    res@tiYAxisOffsetXF = 0.005  ; Ìí¼ÓYÖáÃû³Æ 
    ;res@tmXTOn = False
    res@gsnLeftStringFontHeightF = 0.022

    res@trYMaxF   = 3 
    res@trYMinF   = -3 
    ; res@trXMinF = 0
    ; res@trXMaxF = 57


    res@gsnYRefLine = 0
    ; res@tmXBMode     = "Explicit"        
    ; res@tmXBValues   = ispan(0,nt(0)-1,8)   
    ; res@tmXBLabels   = "day"+ ispan(0,nt(0)-1,8)
    ; res@tmXBMinorValues = ispan(ys(im),yr_finish+1,1)
    res@gsnLeftString = ""  


    res@xyLineThicknessF = 1.0
    res@xyLineColor = "cyan"
    x_axis1 = ispan(1, 24, 1) ;
    nino_el1 = reshape(nino_el, (/nens_all*60,24/))
    plot5(0) = gsn_csm_xy(wks,x_axis1,nino_el1,res)   ;
    ; res@xyLineColor = "grey40"
    ; plota = gsn_csm_xy(wks,x_axis1,nino_all,res)   ;
    ; overlay(plot5(0), plota)
    res@xyLineThicknessF = 5.0
    ; res@xyLineColor = "black"
    ; plota = gsn_csm_xy(wks,x_axis1,nino_all_avg,res)   ;
    ; overlay(plot5(0), plota)
    res@xyLineColor = "blue"  
    plota = gsn_csm_xy(wks,x_axis1,nino_el_avg,res)   ;
    overlay(plot5(0), plota)

    res@xyLineThicknessF = 2.0

  ; Set special resources for the time axis
    resTick                = True
    resTick@ttmFormat      = "%Y";%d 
    resTick@ttmAxis        = "XB" ;
    ; resTick@ttmNumTicks = 8          ; 12 tick marks on X axis


    x_axis2 = vgm_annual&year ;ispan(0, nt(0)-1, 1) ;
    copy_VarCoords(vgm_annual, x_axis2)
    printVarSummary(x_axis2)
    time_axis_labels( vgm_annual&year,  res, resTick )


     rc = regline (x_axis2,vgm_annual)                  ; linear regression
     print(rc)
     print("======")
     yregr = rc*x_axis2 + rc@yintercept                               ; regression

  delete(res@trYMinF)
  delete(res@trYMaxF)
    plot5(1) = gsn_csm_xy(wks,x_axis2,(/vgm_annual,yregr/),res)   ;

  delete([/res,x_axis2,vgm_annual,yregr,nino_el,nino_el1,nino_el_avg/])

      resk = True
      resk@txFontHeightF = 0.02
      resk@gsnMaximize = True
      resk@gsnPaperOrientation = "portrait"   ; force portrait
      resk@gsnPanelLabelBar    = True         ; add common colorbar
      resk@lbTitleString     = vel_mean@units
      resk@lbTitlePosition  = "Right"              ; title position
      resk@lbTitleFontHeightF= .01                ; make title smaller
      ; resk@lbTitleDirection = "Across"             
      resk@lbTitleExtentF   = 0.01 ;Default: 0.15

      resk@txString  = MODEL(im)
      gsn_panel(wks,plot3,(/4,1/),resk);
      gsn_panel(wks,plot4,(/4,2/),resk);
      
      ; resk@gsnPanelLabelBar    = False         ; add common colorbar
      ; gsn_panel(wks,plot5,(/2,1/),resk);

  delete([/epi, cpi, mxi, epi_sea, cpi_sea, mxi_sea, pc, vel_mean,vsea_el_avg,\
         vc_mean,vc_sea,vclm_mean,vclm /])
end do 
end