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


ntimes = (/ 2011-1850, 2100-1920, 2100-1950, 2100-1850, 2100-1920, 2100-1950, 2099-1850/)+1 ;length of time
ys = (/ 1850, 1920, 1950, 1850, 1920, 1950, 1850/) ;start year of datasets
yl = (/ 2011, 2100, 2100, 2100, 2100, 2100, 2099/) ;end year of datasets
re_lat = (/ 180, 192, 64, 96, 90, 90, 96/)
re_lon = (/ 360, 288, 128, 192, 144, 144, 192/)
nens = (/ 11, 40, 50, 30, 20, 30, 100 /) ;ensemble number
nens_all = 100
yr_finish = 2011

MODEL = (/"E3SM","CESM","CanESM2", "CSIRO-Mk3-6-0","GFDL-CM3","GFDL-ESM2M","MPI-ESM" /)
nmo = dimsizes(MODEL)

;----------read index------------------
;--------------OBS---------------------------------
;from nino_index.ncl
f0 = addfile(diri+"ERSSTv5_ENSO_index_185401-201912.nc", "r")
epi_obs = f0->epi 
cpi_obs = f0->cpi 
mxi_obs = f0->nino34 

epi_obs_sea = month_to_season(epi_obs, "DJF")
cpi_obs_sea = month_to_season(cpi_obs, "DJF")
mxi_obs_sea = month_to_season(mxi_obs, "DJF")
printVarSummary(epi_obs_sea)


;from lens_ipo.ncl
f0   = addfile(diri+"obs_ipo_1854-2019.nc", "r")
pco  = f0->pc(0,:)
printVarSummary(pco)



    ; do i =0,nm-1
      f   = addfile("/glade/work/chenxing/sst.ersst.v5.185401-201912.nc", "r")

    ;only do historical part here first
    TIME2=f->time
    yyyymm2=cd_calendar(TIME2, -1)
    printMinMax(yyyymm2, True)
    ymstrts = ind(yyyymm2.eq.197001)
    ymlasts = ind(yyyymm2.eq.201012)

        var  = f->sst;(:ymlasts,:,:);
     
    vclm = clmMonTLL(var(ymstrts:ymlasts,:,:))
    vano = rmMonAnnCycTLL(var);(var, vclm)
    va_sea = month_to_seasonN(vano, SEASON)
    vc_sea = month_to_seasonN(vclm, SEASON)
    printVarSummary(va_sea)

    ;global mean ts
    lat = var&lat
    rad    = 4.0*atan(1.0)/180.0
    clat   = cos(lat*rad)
    vgm = wgt_areaave_Wrap(var,clat, 1.0, 1) ;global mean
    vgm_annual = month_to_annual(vgm, 1) ;annual mean
    printVarSummary(vgm_annual)
    vgm_annual&year = ispan(1854, 2019, 1)
    delete([/lat,clat/])


    ;------------select El Nino year based on Nino index----------------------

    BINDS = mxi_obs_sea
    BIND  = mxi_obs

    nino_std = stddev(BINDS)
    print(nino_std)
    iel05 = ind(BINDS.gt.0.5*nino_std);.and.pc.ge.0 )
    iel1  = ind(BINDS.gt.1.0*nino_std )

    yr_el0 = iel05+1854
    print("El Nino cases is ") ;
    print(""+yr_el0)
    yr_el = yr_el0 - 1854
    print(yr_el+"")

    nel = dimsizes(yr_el)
    ;-----------------------------------------
    ndim = dimsizes(var)
    vsea_el = new((/nel,4,2,ndim(1),ndim(2)/),float,var@_FillValue)
    nino_el = new((/ 60,24/),float)
    do ie = 0,nel-1 
      if(yr_el0(ie).gt.1854.and.yr_el0(ie).lt.2019)

        kk = yr_el(ie)
        aa = kk*12-1*12
        bb = kk*12+1*12-1
        ; print(yr_el0(ie))
        ; print(aa+"-"+bb)

        nino_el(ie,:)    =  BIND(aa:bb)

        aa = kk-1
        bb = kk+1-1

        vsea_el(ie,:,:,:,:)    =  va_sea(:,aa:bb,:,:)
      end if 
    end do 


    ;El Nino years composite
    vsea_el_obs = dim_avg_n_Wrap(vsea_el, 0)

    ; ;just some check for the whole data series
    ; nyr = ndim(0)/12
    ; nino_all = new((/nyr,24/),float,var@_FillValue)
    ; do ie = 1,nyr-2

    ;     aa = ie*12-1*12
    ;     bb = ie*12+1*12-1

    ;   nino_all(ie,:)    =  BIND(aa:bb)

    ; end do 
    ; nino_all_avg = dim_avg_n_Wrap(nino_all, 0)


ndim = dimsizes(var)
vc_model = new((/nmo,ndim(1),ndim(2)/), "float",var@_FillValue)
enso_model = new((/nmo,ndim(1),ndim(2)/), "float",var@_FillValue)
dvc = vc_model
denso = enso_model

vo = vc_sea(0,0,:,:)
eo = vsea_el_obs(0,1,:,:)

do im = 0,nmo-1
  ;from enso_spatial.ncl
  f0   = addfile(diri+MODEL(im)+"_clim_enso34_ts.nc", "r")
    vc0  = f0->ts ;vc_sea
    enso0  = f0->enso ;vsea_el_obs

if (MODEL(im).eq."E3SM") then ;some problems correctly reading time dim of E3SM
    vc0@_FillValue = 1e+20
    enso0@_FillValue = 1e+20
end if 

    vc = vc0(0,0,:,:)
    vc = vc-273.15
    enso = enso0(0,1,:,:)
    print(""+vc(30,30))
    print(""+enso(30,30))
    ndim0 = dimsizes(vc)
  ;----------resolution-------------
  ;original resolution
  ; newlat = vc&lat
  ; lona = vc&lon 
  ;target resolution
  ; lat = (var&lat)
  ; lon = (var&lon)
  ;   printVarSummary(lat)
  ; var&lat := lat 
  ; var&lon := lon
  ; printVarSummary(lat)

lon = fspan(0, 358.5, ndim0(1))   ;target dimension 
lat = fspan(-90, 90, ndim0(0))  ;target dimension
newlon = fspan(0, 358.5, ndim(2))   
newlat = fspan(-90, 90, ndim(1)) 
  newlat@units = "degrees_north"
  newlon@units = "degrees_east"
  lat@units = "degrees_north"
  lon@units = "degrees_east"

  vc_model(im,:,:)   = linint2_Wrap(lon, lat, vc, True, newlon, newlat, 0) 
  enso_model(im,:,:) = linint2_Wrap(lon, lat, enso, True, newlon, newlat, 0) 
  ; vc_model(im,:,:) = vc_model(im,::-1,:)
  ; enso_model(im,:,:) = enso_model(im,::-1,:)
  delete([/vc,enso,vc0,enso0,lon,lat/])

  ; vco   = linint2_Wrap(lon, lat, vo, True, newlon, newlat, 0) 
  ; ensoo = linint2_Wrap(lon, lat, eo, True, newlon, newlat, 0) 
  ; dvo = vc - vco(::-1,:)
  ; deo = enso - ensoo(::-1,:)
  
  ; dvo!0   ="lat"
  ; dvo!1   = "lon"
  ; dvo&lat = newlat
  ; dvo&lon = newlon
  ; copy_VarCoords(dvo, deo)
  ; delete([/newlon,newlat/])

  print(""+MODEL(im))

end do 


do im = 1,nmo-1
  dvc(im,:,:) = vc_model(im,:,:) - vo(::-1,:)
  denso(im,:,:) = enso_model(im,:,:) - eo(::-1,:)
end do 
    print(""+vc_model(0,30,30))
    print(""+enso_model(0,30,30))
    print(""+dvc(0,30,30))
    print(""+denso(0,30,30))
    print(""+vo(30,30))
    print(""+eo(30,30))


vc_model!0 = "model"
vc_model!1 = "lat"
vc_model!2 = "lon"
vc_model&lat = newlat
vc_model&lon = newlon

printVarSummary(vc_model&lat)
printVarSummary(var&lat)
copy_VarCoords(vc_model, dvc)
copy_VarCoords(vc_model, denso)
copy_VarCoords(vc_model, enso_model)
printVarSummary(dvc)
printVarSummary(denso)


  ;=========plot=========================
    wks         = gsn_open_wks("ps",diri0+"model_bias_enso_clim") 
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

    res@lbLabelBarOn = True ;False;
    res@lbOrientation = "vertical"
    res@lbTitleOn        =  True                ; turn on title
    res@lbLabelStride    = 2
    res@lbBoxLinesOn     = False
    res@lbTitleString     = "K"
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

        res@gsnRightString = "ERSSTv5"
        res@cnMinLevelValF        =   0.;-3.
        res@cnMaxLevelValF        =   28.; 3.
        res@cnLevelSpacingF       =   2.;res@cnMaxLevelValF/10.
        plot3(0)   = gsn_csm_contour_map_ce(wks,vc_sea(0,0,:,:),res)
        res@cnMinLevelValF        =   -1.
        res@cnMaxLevelValF        =    1.
        res@cnLevelSpacingF       =  res@cnMaxLevelValF/10.
        plot4(0)   = gsn_csm_contour_map_ce(wks,vsea_el_obs(0,1,:,:),res)

  ;;ensemble mean

      do im = 0,nmo-1
        res@cnMinLevelValF        =   -3.;0.; 
        res@cnMaxLevelValF        =    3.;28.;
        res@cnLevelSpacingF       =   res@cnMaxLevelValF/10.;2.;

        res@gsnLeftString = ""
        res@gsnRightString = MODEL(im)+" - ERSSTv5"
        plot3(im+1)   = gsn_csm_contour_map_ce(wks,dvc(im,:,:),res);vc_model ;dvc

        res@cnMinLevelValF        =   -0.5;-1.0;
        res@cnMaxLevelValF        =   0.5 ;1.0; 
        res@cnLevelSpacingF       =  res@cnMaxLevelValF/10.

        res@gsnLeftString = ""
        res@gsnRightString = MODEL(im)+" - ERSSTv5"
        plot4(im+1)   = gsn_csm_contour_map_ce(wks,denso(im,:,:),res);enso_model ;denso

  ; delete([/vc,enso,vc0,enso0, dvo,deo, ensoo, vco, res/])

    end do 



      resk = True
      resk@txFontHeightF = 0.02
      resk@gsnMaximize = True
      resk@gsnPaperOrientation = "portrait"   ; force portrait
      resk@gsnPanelLabelBar    = False         ; add common colorbar
      resk@lbTitleString     = "K"
      resk@lbTitlePosition  = "Right"              ; title position
      resk@lbTitleFontHeightF= .01                ; make title smaller
      ; resk@lbTitleDirection = "Across"             
      resk@lbTitleExtentF   = 0.01 ;Default: 0.15

      resk@txString  = "climatology in DJF"
      gsn_panel(wks,plot3,(/4,2/),resk);
      resk@txString  = "composite of El Ninos"
      gsn_panel(wks,plot4,(/4,2/),resk);
      

end