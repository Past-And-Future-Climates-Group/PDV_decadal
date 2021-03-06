begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/"
SEASON = (/"DJF(-1)","MAM(-1)","JJA(-1)","SON(-1)","DJF(0)" /)


EXP  = "historical"
IND  = "nino34"; "PDI" ;
LEV  = "850"
VAR  = "ts" ;"psl" "ts"
VAR2 = "ts"
LR = "regLag" ;"reg"

yrs = (/1950,1991/)
yrl = (/1990,2014/)

wks = gsn_open_wks("png", dirip+"reg_lag_lens");
plot = new(30,graphic)                ; create graphic array
plot1 = new(30,graphic)                ; create graphic array
plot2 = new(30,graphic)                ; create graphic array
plot3 = new(30,graphic)                ; create graphic array

do i = 0,1
;---------read output---------------
; from reg_cmip5.ncl reg_cmip6.ncl
;CESM1-CAM5_r6i1p1_reg_PDI_historical_ts_1920-2014.nc
fils = systemfunc("ls "+diri+"lens5/CESM1-CAM5*_"+LR+"_"+IND+"_historical_"+VAR+"_"+yrs(i)+"-"+yrl(i)+".nc");
print(fils)
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
t1 = dim_avg_n_Wrap(f1[:]->rc ,0)
;
; fils = systemfunc("ls "+diri+"lens5/CESM1-CAM5*_"+LR+"_"+IND+"_historical_ua"+LEV+"_"+yrs(i)+"-"+yrl(i)+".nc");
; f1   = addfiles(fils, "r")
; ListSetType (f1, "join")
; u1 = dim_avg_n_Wrap(f1[:]->rc ,0)
;
; fils = systemfunc("ls "+diri+"lens5/CESM1-CAM5*_"+LR+"_"+IND+"_historical_va"+LEV+"_"+yrs(i)+"-"+yrl(i)+".nc");
; f1   = addfiles(fils, "r")
; ListSetType (f1, "join")
; v1 = dim_avg_n_Wrap(f1[:]->rc ,0)

delete([/fils,f1/])
;CESM2_r4i1p1f1_reg_PDI_historical_va200_1991-2014.nc
fils = systemfunc("ls "+diri+"lens6/CESM2*_"+LR+"_"+IND+"_historical_"+VAR+"_"+yrs(i)+"-"+yrl(i)+".nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
t2 = dim_avg_n_Wrap(f1[:]->rc ,0)

; fils = systemfunc("ls "+diri+"lens6/CESM2*_"+LR+"_"+IND+"_historical_ua"+LEV+"_"+yrs(i)+"-"+yrl(i)+".nc");
; f1   = addfiles(fils, "r")
; ListSetType (f1, "join")
; u2 = dim_avg_n_Wrap(f1[:]->rc ,0)
;
; fils = systemfunc("ls "+diri+"lens6/CESM2*_"+LR+"_"+IND+"_historical_va"+LEV+"_"+yrs(i)+"-"+yrl(i)+".nc");
; f1   = addfiles(fils, "r")
; ListSetType (f1, "join")
; v2 = dim_avg_n_Wrap(f1[:]->rc ,0)

delete([/fils,f1/])

;cesm2_cmip5_forcing_007_reg_PDI_ua850_1991-2014.nc
fils = systemfunc("ls "+diri+"lens5/cesm2_cmip5_forcing_*_"+LR+"_"+IND+"_"+VAR2+"_"+yrs(i)+"-"+yrl(i)+".nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
t0 = dim_avg_n_Wrap(f1[:]->rc ,0)

; fils = systemfunc("ls "+diri+"lens5/cesm2_cmip5_forcing*_"+LR+"_"+IND+"_ua"+LEV+"_"+yrs(i)+"-"+yrl(i)+".nc");
; f1   = addfiles(fils, "r")
; ListSetType (f1, "join")
; u0 = dim_avg_n_Wrap(f1[:]->rc ,0)
;
; fils = systemfunc("ls "+diri+"lens5/cesm2_cmip5_forcing*_"+LR+"_"+IND+"_va"+LEV+"_"+yrs(i)+"-"+yrl(i)+".nc");
; f1   = addfiles(fils, "r")
; ListSetType (f1, "join")
; v0 = dim_avg_n_Wrap(f1[:]->rc ,0)

delete([/fils,f1/])

; printMinMax(u1,0)
; printMinMax(v1,0)
; printMinMax(u2,0)

; ;there are some extreme points (maybe distortion calculation)
; u1 = where(u1.ge.5,u1@_FillValue,u1)
; v1 = where(v1.ge.5,v1@_FillValue,v1)

; printVarSummary(t1)
; printVarSummary(t2)
; printVarSummary(u1)
; printVarSummary(u2)
; printVarSummary(v1)
; printVarSummary(v2)

; period difference P2-P1
if (i.eq.0) then
  dt1 = t1
  ; du1 = u1
  ; dv1 = v1
  dt2 = t2
  ; du2 = u2
  ; dv2 = v2
  dt0 = t0
  ; du0 = u0
  ; dv0 = v0
else
  dt1 = t1 - dt1
  ; du1 = u1 - du1
  ; dv1 = v1 - dv1
  dt2 = t2 - dt2
  ; du2 = u2 - du2
  ; dv2 = v2 - dv2
  dt0 = t0 - dt0
  ; du0 = u0 - du0
  ; dv0 = v0 - dv0
end if

; ;-------t-test---------------------------------
; pra_std = dim_stddev_n_Wrap(ccr, 0)

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


res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""
res2@vpWidthF  = 0.6

vcres = res2

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

res2@gsnLeftStringFontHeightF = 0.02
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

res2@cnLevelSelectionMode  = "ManualLevels"
res2@cnMinLevelValF        = -0.6 ;100.
res2@cnMaxLevelValF        =  0.6 ;100.
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.

; vcres@vcGlyphStyle            = "Fillarrow"    ; turn on curly vectors
vcres@vcMinFracLengthF        = 0.2
vcres@vcMinDistanceF          = 0.02
vcres@vcRefMagnitudeF         = 1.0             ; define vector ref mag
vcres@vcRefLengthF            = 0.04             ; define length of vec ref

vcres@vcRefAnnoOn             = True
vcres@vcRefAnnoPerimOn          = False          ;参考矢量的边框
vcres@vcRefAnnoString2          = "m/s"            ;not draw the word"reference vector"
vcres@vcRefAnnoOrthogonalPosF = -.15            ; move ref vector up


vcres@lbLabelBarOn = False
vcres@vcFillArrowFillColor = "black"

res2@gsnLeftString = yrs(i)+"-"+yrl(i)
do is = 0,dimsizes(SEASON)-1
    res2@gsnRightString = SEASON(is)
    plot1(is*3+i) = gsn_csm_contour_map_ce(wks, t1(is,:,:), res2)
    plot2(is*3+i) = gsn_csm_contour_map_ce(wks, t2(is,:,:), res2)
    plot3(is*3+i) = gsn_csm_contour_map_ce(wks, t0(is,:,:), res2)
    ; vector= gsn_csm_vector(wks,u1(is,:,:),v1(is,:,:),vcres)
    ; overlay(plot1(is*2),vector)
    ; vector= gsn_csm_vector(wks,u2(is,:,:),v2(is,:,:),vcres)
    ; overlay(plot2(is*2),vector)
    ; vector= gsn_csm_vector(wks,u0(is,:,:),v0(is,:,:),vcres)
    ; overlay(plot3(is*2),vector)
end do


if (i.eq.1) then
  do is = 0,dimsizes(SEASON)-1
      res2@gsnRightString = SEASON(is)
  res2@gsnLeftString = "P2 - P1"
    plot1(is*3+2) = gsn_csm_contour_map_ce(wks, dt1(is,:,:), res2)
    plot2(is*3+2) = gsn_csm_contour_map_ce(wks, dt2(is,:,:), res2)
    plot3(is*3+2) = gsn_csm_contour_map_ce(wks, dt0(is,:,:), res2)

    ; vector= gsn_csm_vector(wks,du1(is,:,:),dv1(is,:,:),vcres)
    ; overlay(plot1(is*2+1),vector)
    ; vector= gsn_csm_vector(wks,du2(is,:,:),dv2(is,:,:),vcres)
    ; overlay(plot2(is*2+1),vector)
    ; vector= gsn_csm_vector(wks,du0(is,:,:),dv0(is,:,:),vcres)
    ; overlay(plot3(is*2+1),vector)
  end do
end if

  delete([/res2,vcres/])
end do



resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = True                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@lbBoxEndCapStyle = "TriangleBothEnds"
resk@lbOrientation = "Horizontal"
resk@lbBoxLinesOn = False
;resk@lbBoxMinorExtentF = 0.2
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02
resk@txString = " regression onto "+IND+ " in CESM1"
gsn_panel(wks,plot1,(/5,3/),resk)
resk@txString = " regression onto "+IND+ " in CESM2"
gsn_panel(wks,plot2,(/5,3/),resk)
resk@txString = " regression onto "+IND+ " in CESM2 with CMIP5 forcing"
gsn_panel(wks,plot3,(/5,3/),resk)


end
