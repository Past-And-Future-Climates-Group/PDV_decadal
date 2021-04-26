load "/Users/xingchen/Documents/project/PDV/program/function_bootstrap_mme.ncl"
begin

diri = "/Users/xingchen/Documents/project/PDV/data/" ;"/glade/work/chenxing/enso/";
dirip = "/Users/xingchen/Documents/project/PDV/pic/" ;"/glade/u/home/chenxing/enso/";

neof = 1


; MODEL6_ESM = (/"CanESM5","CESM2","E3SM-1-0",\
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0"/)
; MODEL6_CM = (/"GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MIROC6","NorCPM1" /)

; nens6_esm = (/25,11,5,7,10, 5/)
; nens6_cm = (/12,10,32,10,30/)

yrs5 = 1861
yrl5 = 2004
nyr5 = yrl5 - yrs5 +1
yrs6 = 1850
yrl6 = 2014
nyr6 = yrl6 - yrs6 +1

;;;;touch here;;;;;;;;;;;;
EXP5 = "historical";"historicalNat" ;"historicalGHG" ;
EXP6 = "historical";"hist-aer";"hist-Nat" ;"hist-GHG" ;

;don't filter pdv pc, it's already filtered, double filter will shortern data...

yrs = 1861;
yrl = 2004; 2014;


;--------read-------------
; f1 = addfile(diri+"cmip6_historical_PDI2_mme.nc" , "r" )
; pdi6 = f1->cp6_a
f1 = addfile(diri+"cmip6/cmip6_historical_mme.eof_1850-2014.nc" , "r" )
pdi6 = f1->pc(1,:)


;"EACSS" ;"EAS" ;"PDI2" ; "NPCSS" ;"NPC" ;"NPS" ;"NPAOD" ;"PDI2";"TPI" ;"NPI" ;"AMO" ;"pdo" ;"nh-sh" ;"GMAOD" ;"GMSW" ;
IND1 = "SWHD"
IND1_fullname = "SW of Hemisphere difference (surface"
f1 = addfile(diri+"cmip5_"+EXP5+"_"+IND1+"_mme.nc" , "r" )
e51 = f1->cp5_a
s51 = f1->std_5

f1 = addfile(diri+"cmip6_"+EXP6+"_"+IND1+"_mme.nc" , "r" )
e61 = f1->cp6_a
s61 = f1->std_6

IND2 = "ASRHD"
IND2_fullname = "SW of Hemisphere difference (TOA"
f2 = addfile(diri+"cmip5_"+EXP5+"_"+IND2+"_mme.nc" , "r" )
e52 = f2->cp5_a
s52 = f2->std_5

f2 = addfile(diri+"cmip6_"+EXP6+"_"+IND2+"_mme.nc" , "r" )
e62 = f2->cp6_a
s62 = f2->std_6

IND3 = "NPC"
IND3_fullname = "cloud effect over the North Pacific"
f3 = addfile(diri+"cmip5_"+EXP5+"_"+IND3+"_mme.nc" , "r" )
e53 = f3->cp5_a
s53 = f3->std_5

f3 = addfile(diri+"cmip6_"+EXP6+"_"+IND3+"_mme.nc" , "r" )
e63 = f3->cp6_a
s63 = f3->std_6

printVarSummary(e53)
printVarSummary(pdi6)
printVarSummary(pdi6((1861-1850)*12:(2005-1850)*12-1))

c51 = escorc(pdi6((1861-1850)*12:(2005-1850)*12-1) , e51)
c52 = escorc(pdi6((1861-1850)*12:(2005-1850)*12-1) , e52)
c53 = escorc(pdi6((1861-1850)*12:(2005-1850)*12-1) , e53)
c61 = escorc(pdi6, e61)
c62 = escorc(pdi6, e62)
c63 = escorc(pdi6, e63)
print("correlation with PDI in CMIP6")
print(IND1+" CMIP5 is "+ c51)
print(IND2+" CMIP5 is "+ c52)
print(IND3+" CMIP5 is "+ c53)
print(IND1+" CMIP6 is "+ c61)
print(IND2+" CMIP6 is "+ c62)
print(IND3+" CMIP6 is "+ c63)

; start as 0
; maybe use cmip6 in 1861+3 for CMIP5 as well
e61 = e61 - e61(48)
e62 = e62 - e62(48)
e63 = e63 - e63(48)
e51 = e51 - e51(48) + e61(48+11*12) ;
e52 = e52 - e52(48) + e62(48+11*12) ;
e53 = e53 - e53(48) + e63(48+11*12) ;
;--------------plot-------------------

wks = gsn_open_wks("png", dirip+"cmip_index_xy");
plot = new(10,graphic)                ; create graphic array
plot2 = new(10,graphic)                ; create graphic array


;*******************************************
; time series (principal component) plot
;*******************************************

  gsn_define_colormap(wks,"seaice_2")
  colors = ispan(2, 17, 1)   ; indices into color table
  colors2 = ispan(2, 9, 1)   ; indices into color table
  colors1 = ispan(10, 18, 1)   ; indices into color table


; these four resources allow the user to stretch the plot size, and
; decide exactly where on the page to draw it.

  res = True
  res@gsnDraw = False        ;dont draw
  res@gsnFrame = False        ;dont advance frame
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@vpHeightF = 0.3
  res@vpWidthF  = 0.6

  res@tmXTOn    = False
  res@tmYROn    = False
  ;res@gsnXYBarChart            = True              ; Create bar plot
  ;res@gsnXYBarChartOutlineOnly = True


  res@gsnYRefLine           = 0.0             ; reference line
  ; res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  ; res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  ; res@gsnLeftStringFontHeightF  = 0.03
  ; res@gsnRightStringFontHeightF = 0.03

  ndim5  = dimsizes(e51)
  x_axis5 = fspan(yrs5, yrl5, ndim5(0))
  ndim6  = dimsizes(e61)
  x_axis6 = fspan(yrs6, yrl6, ndim6(0))
  x_axis1 = ispan(yrs, yrl, 1)
  ;res@tmXBMode   = "Explicit"
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
  res@tiYAxisString = ""
  res@tiXAxisString = "year"

  res@xyMonoLineColor = False
  res@xyMonoDashPattern = True

  res@trXMinF               = 1850
  res@trXMaxF               = 2015

  res@trYMinF               = -1.0
  res@trYMaxF               =  3.0


;MODEL
res@xyLineThicknessF = 3.0
res@gsnRightStringOrthogonalPosF = -0.2
res@gsnRightStringParallelPosF = 0.1

res@gsnLeftString = IND1_fullname
res@gsnRightString = sprintf("%5.2f", c61)
res@xyLineColor = "black"
plot(0) = gsn_csm_xy (wks,x_axis6, e61 ,res) ;x_axis2, com_pc
res@xyLineColor = "red"
plota = gsn_csm_xy (wks,x_axis5,e51,res) ;cg_a ;crt_g_a
overlay(plot(0), plota)

res@gsnLeftString = IND2_fullname
res@gsnRightString = sprintf("%5.2f", c62)
res@xyLineColor = "black"
plot(1) = gsn_csm_xy (wks,x_axis6, e62 ,res) ;x_axis2, com_pc
res@xyLineColor = "red"
plota = gsn_csm_xy (wks,x_axis5,e52,res) ;cg_a ;crt_g_a
overlay(plot(1), plota)

res@gsnLeftString = IND3_fullname
res@xyLineColor = "black"
res@gsnRightString = sprintf("%5.2f", c63)
plot(2) = gsn_csm_xy (wks,x_axis6, e63 ,res) ;x_axis2, com_pc
res@xyLineColor = "red"
plota = gsn_csm_xy (wks,x_axis5,e53,res) ;cg_a ;crt_g_a
overlay(plot(2), plota)

;------------shading-------------------------
res@gsnLeftString = ""
res@gsnRightString = ""

 res@xyLineColor     = -1                           ; We don't want the line, so make
 res@gsnXYFillOpacities = 0.3
 res@gsnXYFillColors = "grey55"
 res@xyCurveDrawOrder = "PreDraw"

 mmz6 = conform_dims((/2,dimsizes(e61)/), e61, 1)
 mmz5 = conform_dims((/2,dimsizes(e51)/), e51, 1)
 mmz6(0,:) = e61- s61
 mmz6(1,:) = e61+ s61
 plota  = gsn_csm_xy (wks,(/x_axis6/),mmz6(0:1,:),res)  ; Create filled XY plot.
 overlay(plot(0), plota)
 mmz6(0,:) = e62- s62
 mmz6(1,:) = e62+ s62
 plota  = gsn_csm_xy (wks,(/x_axis6/),mmz6(0:1,:),res)  ; Create filled XY plot.
 overlay(plot(1), plota)
 mmz6(0,:) = e63- s63
 mmz6(1,:) = e63+ s63
 plota  = gsn_csm_xy (wks,(/x_axis6/),mmz6(0:1,:),res)  ; Create filled XY plot.
 overlay(plot(2), plota)

 ; mmz5(0,:) = e51 - s51
 ; mmz5(1,:) = e51 + s51
 ; plota  = gsn_csm_xy (wks,(/x_axis5/),mmz5(0:1,:),res)  ; Create filled XY plot.
 ; overlay(plot(1), plota)


;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@txString = ""

gsn_panel(wks,plot,(/3,1/),resk)

end
