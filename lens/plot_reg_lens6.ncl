begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/"
SEASON = (/"DJF(-1)","MAM(-1)","JJA(-1)","SON(-1)","DJF(0)" /)

MODEL = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
  "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR"/);,"MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",

EXP  = "historical"
IND  = "PDI" ;"nino34";
LEV  = "200";"200" ;
VAR  = "psl" ;"pr" ; "zg300" ;"psl" "ts"
units = "Pa"
LR =  "reg_mme" ;"regLag" ;"reg"

yrs = 1950 ; (/1950,1991/)
yrl = 2014 ; (/1990,2014/)

wks = gsn_open_wks("png", dirip+"reg_lens");
plot = new(30,graphic)                ; create graphic array
plot1 = new(30,graphic)                ; create graphic array
plot2 = new(30,graphic)                ; create graphic array
plot3 = new(30,graphic)                ; create graphic array

do i = 0,dimsizes(yrs)-1
  do im = 0,dimsizes(MODEL)-1
    print(MODEL(im)+"")
;---------read output---------------

; from reg_pdi_lens6.ncl
;CESM2_r4i1p1f1_reg_PDI_historical_va200_1991-2014.nc
file_name1 = diri+"lens6/"+MODEL(im)+"_r1i1p1f1_"+LR+"_"+IND+"_historical_"+VAR+"_"+yrs(i)+"-"+yrl(i)+".nc"
; exists1 = isfilepresent(file_name1)
; if(.not.exists1) then
;   continue
; else
fils = systemfunc("ls "+diri+"lens6/"+MODEL(im)+"_*_"+LR+"_"+IND+"_historical_"+VAR+"_"+yrs(i)+"-"+yrl(i)+".nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
t2 = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])

; fils = systemfunc("ls "+diri+"lens6/"+MODEL(im)+"_*_"+LR+"_"+IND+"_historical_ua"+LEV+"_"+yrs(i)+"-"+yrl(i)+".nc");
; f1   = addfiles(fils, "r")
; ListSetType (f1, "join")
; u2 = dim_avg_n_Wrap(f1[:]->rc ,0)
;
; fils = systemfunc("ls "+diri+"lens6/"+MODEL(im)+"_*_"+LR+"_"+IND+"_historical_va"+LEV+"_"+yrs(i)+"-"+yrl(i)+".nc");
; f1   = addfiles(fils, "r")
; ListSetType (f1, "join")
; v2 = dim_avg_n_Wrap(f1[:]->rc ,0)
; delete([/fils,f1/])

; ;there are some extreme points (maybe distortion calculation)
; u1 = where(u1.ge.5,u1@_FillValue,u1)
; v1 = where(v1.ge.5,v1@_FillValue,v1)

if (VAR.eq."pr") then
  t2 = t2 * 3600 *24
  t2@units = "mm/day"
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
; gsn_define_colormap(wks, "MPL_BrBG")


res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""
res2@vpWidthF  = 0.6

vcres = res2
res3  = res2

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
res2@cnMinLevelValF        = -50;50.;20.;0.5;
res2@cnMaxLevelValF        =  50;50.;20.;0.5;
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.

; vcres@vcGlyphStyle            = "Fillarrow"    ; turn on curly vectors
vcres@vcMinFracLengthF        = 0.2
vcres@vcMinDistanceF          = 0.02
vcres@vcRefMagnitudeF         = 0.8;1.5 ;0.8;             ; define vector ref mag
vcres@vcRefLengthF            = 0.04             ; define length of vec ref

vcres@vcRefAnnoOn             = True
vcres@vcRefAnnoPerimOn          = False          ;参考矢量的边框
vcres@vcRefAnnoString2          = "m/s"            ;not draw the word"reference vector"
vcres@vcRefAnnoOrthogonalPosF = -.15            ; move ref vector up

vcres@lbLabelBarOn = False
vcres@vcFillArrowFillColor = "black"

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


res2@gsnLeftString = "300hPa Zg"
    res2@gsnRightString = ""+MODEL(im)
    plot(im) = gsn_csm_contour_map_ce(wks, t2, res2)

;contour

    ; plota = gsn_csm_contour(wks, u2, res3)
    ; plota = ColorNegDashZeroPosContour(plota,"brown",-1,"green")
    ; overlay(plot(im), plota)

;vector

  ; vector= gsn_csm_vector(wks,u2,v2,vcres)
;   overlay(plot(im),vector)


  delete([/res2,vcres/])
; end if
end do
end do



resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = True                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@lbBoxEndCapStyle = "TriangleBothEnds"
resk@lbOrientation = "Horizontal"
resk@lbBoxLinesOn = False
resk@lbTitleString    = units               ; title string
resk@lbTitlePosition  = "Right"              ; title position
resk@lbTitleDirection = "Across"
resk@lbTitleFontHeightF= .015                ; make title smaller
;resk@lbBoxMinorExtentF = 0.2
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02
resk@txString = " regression onto "+IND+" "+yrs+"-"+yrl
gsn_panel(wks,plot,(/5,2/),resk)


end
