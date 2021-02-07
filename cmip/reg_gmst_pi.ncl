begin

diri = "/glade/work/chenxing/enso/"
  ymstrt= 185001  
  ymlast= 201112

wks = gsn_open_wks("ps", "~/enso/reg_gmst_pi");
plot = new(10,graphic)                ; create graphic array
plot1 = new(10,graphic)                ; create graphic array

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
;ts_Amon_GFDL-ESM2M_historical_rcp85_r8i1p1_195001-210012.nc
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

do im = 1,1;nmo-1


;from read_opendap_e3sm.ncl
if (MODEL(im).eq."E3SM") then 
f_input = diri+"ts_Amon_E3SM-1-0_piControl_000101-050012.nc"
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


; do i =0,nm-1
  f   = addfile(f_input(0), "r")
  ; TIME=f->time;
  ; yyyymm  = cd_calendar(TIME, -1)
  ; ymstrt1 = ind(yyyymm.eq.ymstrt)
  ; ymlast1 = ind(yyyymm.eq.ymlast)
  ; print(yyyymm)
  ; print(ymstrt1)
  ; print(ymlast1)
  x = f->ts;(:(yr_finish+1 - ys(im))*12-1,:,:);(ymstrt1(0):ymlast1(0),{SLAT:NLAT},{WLON:ELON})

if (MODEL(im).eq."E3SM") then ;some problems correctly reading time dim of E3SM
    x@_FillValue = 1e+20
end if 

  xc=clmMonTLL(x)
  xa = calcMonAnomTLL(x, xc)
  xan = month_to_annual(xa, 1)


print(MODEL(im))

printVarSummary(xan)

  lat = xa&lat
  rad    = 4.0*atan(1.0)/180.0
  clat   = cos(lat*rad)
  copy_VarCoords(xa(0,:,0), clat)
  ; go = wgt_areaave_Wrap(x,clat, 1.0, 1)

  NLAT =   90  
  SLAT =  -90
  WLON =  0
  ELON =  360
  gmst = wgt_areaave_Wrap(xa(:,{SLAT:NLAT},{WLON:ELON}),clat({SLAT:NLAT}), 1.0, 1)

delete([/x, xa, xc/])

printVarSummary(gmst)

gmst_annual = month_to_annual(gmst, 1)
delete([/gmst/])
;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr)+1 ;fyr*12*2+1)                            ; odd only
fca   = 1./(fyr);*12)
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

gmst_annual_ft = wgt_runave_n_Wrap( gmst_annual, wgt,  -1, 0 )   ;opt < 0 : utilize cyclic conditions 

rc = regCoef(gmst_annual,xan(lat|:,lon|:,year|:));, tval, df);Y
copy_VarCoords(xan(0,:,:), rc)
printVarSummary(rc)

;--------OBS-----------------------

; f0 = addfile(diri+"ERSSTv5_GMST_index_185401-201912.nc", "r")
f0 = addfile(diri+"GISTEMP_GMST_index_188001-201812.nc", "r")
gmst_obs = f0->gmst(0,:) 
printVarSummary(gmst_obs)
gmst_obs_annual = month_to_annual(gmst_obs, 1)

gmst_obs_ft = wgt_runave_n_Wrap( gmst_obs_annual, wgt,  -1, 0 )   ;opt < 0 : utilize cyclic conditions 


  ; f0   = addfile("/glade/work/chenxing/sst.ersst.v5.185401-201912.nc", "r")
  f0   = addfile("/glade/work/chenxing/air.2x2.250.mon.anom.comb.nc", "r")
  TIME=f0->time;
  yyyymm  = cd_calendar(TIME, -1)
  ymstrt1 = ind(yyyymm.eq.188001) ;for GISTEMP
  ymlast1 = ind(yyyymm.eq.201812)
  x = f0->air(ymstrt1:ymlast1,:,:)
  xc=clmMonTLL(x)
  xa = calcMonAnomTLL(x, xc)
  xan_obs = month_to_annual(xa, 1)
  printVarSummary(xan_obs)

rco = regCoef(gmst_obs_ft,xan_obs(lat|:,lon|:,year|:));, tval, df);Y
copy_VarCoords(xan_obs(0,:,:), rco)

delete([/x, xa, xc/])

;--------------plot-------------------
gsn_define_colormap(wks, "NCV_blu_red"); "BlueDarkRed18");"BrownBlue12");"BlueGreen14");"BlueYellowRed");"sunshine_9lev")"BrownBlue12";
res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""

res2@mpCenterLonF = 180.
res2@mpFillOn = False
res2@mpFillDrawOrder = "PostDraw"
;  res2@mpMaxLatF                   = NLAT         ; choose subregion           
;  res2@mpMinLatF                   = SLAT
;  res2@mpMaxLonF                   = ELON
;  res2@mpMinLonF                   = WLON
res2@gsnAddCyclic = True ;False         
res2@cnFillOn = True;False ;
res2@cnLinesOn = False;True ;
res2@cnLineLabelsOn = False

res2@gsnLeftStringFontHeightF = 0.03
res2@gsnRightStringFontHeightF = 0.03
res2@lbLabelBarOn = True ;False;
res2@lbOrientation = "vertical"
res2@lbTitleOn        =  True                ; turn on title
res2@lbLabelStride    = 2
res2@lbTitleString    = "K"                ; title string
res2@lbTitlePosition  = "Top"              ; title position
res2@lbTitleFontHeightF= .01                ; make title smaller
; res2@lbTitleDirection = "Across"             
res2@lbTitleExtentF   = 0.01 ;Default: 0.15
res2@lbLabelFontHeightF = 0.01  ;Default: 0.02
res2@pmLabelBarWidthF = 0.05

i = 0

res2@cnLevelSelectionMode  = "ManualLevels"    
res2@cnMinLevelValF        = -1.0
res2@cnMaxLevelValF        =  3.0 
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.


res2@gsnLeftString = "OBS"
plot(0) = gsn_csm_contour_map_ce(wks,rco , res2)


res2@gsnLeftString = MODEL(im)
plot(im) = gsn_csm_contour_map_ce(wks, rc, res2)

res2@cnMinLevelValF        =  0.;
res2@cnMaxLevelValF        =  0.2; 
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.
res2@gsnLeftString = "ensemble STD (EOF"+(i+1)+")"
; plot(1) = gsn_csm_contour_map_ce(wks, std_rc(i,:,:), res2)


;*******************************************
; time series (principal component) plot
;*******************************************

; these four resources allow the user to stretch the plot size, and
; decide exactly where on the page to draw it.

  res = True
  res@gsnDraw = False        ;dont draw
  res@gsnFrame = False        ;dont advance frame
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@vpHeightF = 0.40        ; Changes the aspect ratio
  res@vpWidthF  = 0.85
 
  res@tmXTOn    = False

  ;res2@gsnScale  = True        ; force text scaling               
  ;res@gsnXYBarChart            = True              ; Create bar plot
  ;res@gsnXYBarChartOutlineOnly = True


  res@gsnYRefLine           = 0.0             ; reference line   
  ; res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  ; res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  res@gsnLeftStringFontHeightF  = 0.03
  res@gsnRightStringFontHeightF = 0.03
   res@trYMinF               = -0.8
   res@trYMaxF               =  1.2
   res@trXMinF               = 1850
   res@trXMaxF               = 2018

    ndim  = dimsizes(gmst_annual)
    ndimo = dimsizes(gmst_obs_annual)
  x_axis1 = fspan(1880, 2018, ndimo(0))
  x_axis2 = fspan(1, ndim(0), ndim(0))
  ;res@tmXBMode   = "Explicit"                                                
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
res@tiYAxisString = ""

res@xyLineThicknessF = 1.0
res@xyLineColor = "grey40"
res@gsnLeftString = MODEL(im)
res@gsnRightString = ""
res@xyLineThicknessF = 4.0
res@xyLineColor = "black"
plot1(im) = gsn_csm_xy (wks,x_axis2,gmst_annual,res)

res@gsnLeftString = "OBS"
plot1(0) = gsn_csm_xy (wks,x_axis1,gmst_obs_annual,res)

res@gsnLeftString = ""
res@xyLineColor = "blue"
; plota = gsn_csm_xy (wks,x_axis2,gmst_annual_ft,res)
; overlay(plot1(im), plota)
; plota = gsn_csm_xy (wks,x_axis1,gmst_obs_ft,res)
; overlay(plot1(0), plota)

delete([/ndim,ndimo, gmst_annual, rc, gmst_annual_ft,xan, x_axis1, x_axis2, res, res2/])

print(MODEL(im)+" is done")
end do 

resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@lbBoxEndCapStyle = "TriangleBothEnds"
;resk@lbOrientation = "vertical"
resk@lbBoxLinesOn = False
;resk@lbBoxMinorExtentF = 0.2
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02

; gsn_panel(wks,plot,(/2,1/),resk)    
resk@txString = "ensemble mean GMST regressed on ts";8-yr lowpass 
gsn_panel(wks,plot,(/4,2/),resk);(without removing nearby annual cycle)
resk@txString = "GMST"
gsn_panel(wks,plot1,(/4,2/),resk)    

end