begin
diri = "/glade/work/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/data/" ;
dirip = "/glade/u/home/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/pic/" ;

setfileoption("nc","SuppressClose",False)

sign = (/"a","b","c","d","e","f","g" /)
VAR1 = "ts";"rsds";"ts";"clt" ;"od550aer" ;"cloudeffect";"ts" ; "rsds" "va" ;"psl" ;
VAR2 = "pr"; "FSNS" ;"ts"; SWCF exactly the same as cloudeffect result; LWCF represent covective cloud effect the most, around the tropics
EXP = "historical"

yrs = (/1950,1991/)
yrl = (/1990,2014/)

wks = gsn_open_wks("png", "./clim_cesm");dirip+
plot = new(10,graphic)                ; create graphic array
plot2 = new(10,graphic)                ; create graphic array

do i = 0,dimsizes(yrs)-1
;---------read output---------------

;;;;;;;;;;;;;;;LENS;;;;;;;;;;;;;;;;;;;;
;from clim_lens5.ncl
;;;CMIP5 LENS;;;;;;;;;;;;;;
;CESM1-CAM5_r4i1p1_clim_historical_ts_1950-1990.nc
fils = systemfunc("ls "+diri+"lens5/CESM1-CAM5*_clim_historical_"+VAR1+"_"+yrs(i)+"-"+yrl(i)+".nc")
print(fils)
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
x1  =  dim_avg_n_Wrap(f[:]->aclim, 0) ;clim
delete([/fils,f/])
printVarSummary(x1)

fils = systemfunc("ls "+diri+"lens5/CESM1-CAM5*_clim_historical_"+VAR2+"_"+yrs(i)+"-"+yrl(i)+".nc")
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
y1  =  dim_avg_n_Wrap(f[:]->aclim, 0) ;clim
delete([/fils,f/])

;;;CESM2 with CMIP5 forcing;;;;;;;;;;;;;;
;cesm2_cmip5_forcing_001_clim_PDI_TS_1850-2014
;from clim_cesm.ncl

fils = systemfunc("ls "+diri+"lens5/cesm2_cmip5_forcing*_clim_"+VAR1+"_"+yrs(i)+"-"+yrl(i)+".nc")
print(fils)
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
x3  = dim_avg_n_Wrap(f[:]->aclim, 0)
delete([/fils,f/])
printVarSummary(x3)

fils = systemfunc("ls "+diri+"lens5/cesm2_cmip5_forcing*_clim_"+VAR2+"_"+yrs(i)+"-"+yrl(i)+".nc")
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
y3  = dim_avg_n_Wrap(f[:]->aclim, 0)
delete([/fils,f/])


;;;;;;;;;;;;;;;CMIP6 LE;;;;;;;;;;;;;;;;;;;;
fils = systemfunc("ls "+diri+"lens6/CESM2*_clim_historical_"+VAR1+"_"+yrs(i)+"-"+yrl(i)+".nc")
print(fils)
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
x2  = dim_avg_n_Wrap(f[:]->aclim, 0)
delete([/fils,f/])
printVarSummary(x2)

fils = systemfunc("ls "+diri+"lens6/CESM2*_clim_historical_"+VAR2+"_"+yrs(i)+"-"+yrl(i)+".nc")
print(fils)
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
y2  = dim_avg_n_Wrap(f[:]->aclim, 0)
delete([/fils,f/])

;--------for Pr---------------------------------
    if (VAR2.eq."pr") then
      y2 = y2 * 3600 *24
      y3 = y3 * 3600 *24
      y1 = y1 * 3600 *24
      y1@units = "mm/day"
      y2@units = "mm/day"
      y3@units = "mm/day"
    end if
;---------interpolate---------------------
;change resolution for MODELS to the same 144*72
    lat1 = x1&lat
    lon1 = x1&lon
    nlat = dimsizes(x2&lat) ;target dimension size
    nlon = dimsizes(x2&lon) ;target dimension size
    klon = fspan(0, 360, nlon) ;target dimension
    klat = fspan(-90, 90, nlat) ;target dimension
    x1_r= linint2_Wrap(lon1, lat1, x1, True, klon, klat, 0)
    y1_r= linint2_Wrap(lon1, lat1, y1, True, klon, klat, 0)
    x1_r&LAT@units="degrees_north"
    x1_r&LON@units="degrees_east"
    printVarSummary(x1_r)
    delete([/lat1,lon1/]);xa0
    x1_r!0 = "lat"
    x1_r!1 = "lon"

    copy_VarMeta(x1_r, x2)
    copy_VarCoords(x1_r,y1_r)

    lat3 = x3&lat
    lon3 = x3&lon
    x3_r= linint2_Wrap(lon3, lat3, x3, True, klon, klat, 0)
    y3_r= linint2_Wrap(lon3, lat3, y3, True, klon, klat, 0)
    x3_r&LAT@units="degrees_north"
    x3_r&LON@units="degrees_east"
    printVarSummary(x3_r)
    delete([/lat3,lon3/]);xa0
    x3_r!0 = "lat"
    x3_r!1 = "lon"

    copy_VarMeta(x1_r, x2)
    copy_VarCoords(x1_r,y3_r)


; ;-------difference---------------------------------

dx1 = x1_r
dx1 = x2 - x1_r
dx2 = x2
dx2 = x2 - x3_r
dy1 = y1_r
dy1 = y2 - y1_r
dy2 = y2
dy2 = y2 - y3_r
if (i.eq.1) then
  dtx1 = dx1 - dtx1
  dty1 = dy1 - dty1
  dtx2 = dx2 - dtx2
  dty2 = dy2 - dty2
else
  dtx1 = dx1
  dty1 = dy1
  dtx2 = dx2
  dty2 = dy2
end if

; ;-------t-test---------------------------------
; pra_std = dim_stddev_n_Wrap(rc, 0)

; df = pra_avg_p1
; df = nens(im)
; b = pra_avg_p1
; b = 0.5
; pr_tval = pra_avg_p1
; pr_tval = (pra_avg_p1-0)*sqrt(40)/pra_std
; pr_prob = (1.-betainc( df/(df+pr_tval^2), df/2.0, b))*100.  ; probability in %
; printMinMax(pr_prob, 0)

; delete([/df,b/])

; sig_pra1 = pra_avg_p1
; sig_pra1 = where(pr_prob.ge.90., abs(pra_avg_p1), pra_avg_p1@_FillValue)

;--------------plot-------------------
gsn_define_colormap(wks, "NCV_blu_red")
; gsn_define_colormap(wks, "MPL_BrBG")


res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""

res3 = res2

res2@mpCenterLonF = 180.
res2@mpFillOn = False
res2@mpFillDrawOrder = "PostDraw"
 ; res2@mpMaxLatF                   = NLAT         ; choose subregion
 ; res2@mpMinLatF                   = SLAT
 ; res2@mpMaxLonF                   = ELON
 ; res2@mpMinLonF                   = WLON
res2@gsnAddCyclic = True ;False
res2@cnFillOn = True;False ;
res2@cnLinesOn = False;True ;
res2@cnLineLabelsOn = False
res2@cnInfoLabelOn = False

res2@gsnLeftStringFontHeightF = 0.03
res2@gsnRightStringFontHeightF = res2@gsnLeftStringFontHeightF
res2@lbLabelBarOn = False;
res2@lbOrientation = "Horizontal"
res2@lbBoxLinesOn  = False
res2@lbTitleOn        =  True                ; turn on title
res2@lbLabelStride    = 2
res2@lbTitleString    = "K"                ; title string
res2@lbTitlePosition  = "Right"              ; title position
res2@lbTitleFontHeightF= .015                ; make title smaller
; res2@lbTitleDirection = "Across"
res2@lbTitleExtentF   = 0.01 ;Default: 0.15
res2@lbLabelFontHeightF = 0.01  ;Default: 0.02
; res2@pmLabelBarWidthF = 0.05

;level@units = "hPa"
res3@cnFillOn  = False
res3@cnInfoLabelOn            = False
;res3@cnLinesOn = True
;res3@cnLineLabelsOn = True ;
res3@cnLevelFlags = "LineAndLabel" ;control over whether a line and/or a line label is to appear at each contour level
res3@cnLineLabelBackgroundColor = -1
res3@cnLineLabelInterval = 1
res3@cnLineLabelPlacementMode = "constant"
res3@cnLineThicknessF = 2.0
res3@cnLineLabelFontHeightF = 0.01
res3@cnLevelSpacingF = 0.2
; res3@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
; res3@cnLevels = (/-6.,-4.,-2.,2.,4.,6.,8.,10./)


res2@cnLevelSelectionMode  = "ManualLevels"
res2@cnMinLevelValF        = -1.0
res2@cnMaxLevelValF        =  1.0
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.

res2@gsnRightString = yrs(i)+"-"+yrl(i)

  res2@gsnLeftString = sign(i)+" CESM2-CESM1"
  plot2(i+0) = gsn_csm_contour_map_ce(wks, dx1, res2)

  res2@gsnLeftString =  sign(i+3)+" CMIP6-CMIP5 forcing (CESM2)"
  plot2(i+3) = gsn_csm_contour_map_ce(wks, dx2, res2)

  plota = gsn_csm_contour(wks, dy1, res3)
  plota = ColorNegDashZeroPosContour(plota,"brown",-1,"green")
  overlay(plot2(i), plota)

  plota = gsn_csm_contour(wks, dy2, res3)
  plota = ColorNegDashZeroPosContour(plota,"brown",-1,"green")
  overlay(plot2(i+3), plota)

  res2@gsnRightString = ""
  res2@gsnLeftString = sign(2)+" (b)-(a)"
  plot2(2) = gsn_csm_contour_map_ce(wks, dtx1, res2)
  res2@gsnLeftString = sign(5)+" (e)-(d)"
  plot2(5) = gsn_csm_contour_map_ce(wks, dtx2, res2)

  plota = gsn_csm_contour(wks, dty1, res3)
  plota = ColorNegDashZeroPosContour(plota,"brown",-1,"green")
  overlay(plot2(2), plota)
  plota = gsn_csm_contour(wks, dty2, res3)
  plota = ColorNegDashZeroPosContour(plota,"brown",-1,"green")
  overlay(plot2(5), plota)

delete([/res2,res3/])
end do



resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = True                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@lbBoxEndCapStyle = "TriangleBothEnds"
resk@lbOrientation = "Horizontal"
resk@lbBoxLinesOn = False
resk@lbTitleString    = "K"                ; title string
resk@lbTitlePosition  = "Right"              ; title position
resk@lbLabelStride    = 2
resk@lbTitleDirection = "Across"
;resk@lbBoxMinorExtentF = 0.2
resk@lbTitleFontHeightF= .015                ; make title smaller
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02
resk@txString = " period changes"
gsn_panel(wks,plot2,(/2,3/),resk)

end
