begin
diri = "/glade/work/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/data/" ;
dirip = "/glade/u/home/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/pic/" ;

setfileoption("nc","SuppressClose",False)

VAR = "cloudeffect";"rsds";"ts";"clt" ;"od550aer" ;"cloudeffect";"ts" ; "rsds" "va" ;"psl" ;
VAR1 ="cloudeffect"; "FSNS" ;"ts"; SWCF exactly the same as cloudeffect result; LWCF represent covective cloud effect the most, around the tropics
EXP = "historical"
IND = "PDI" ;"mmeeof2" ;"mmeeof1" ;"GMAOD" ;"PDI2" ;"PDI"; "AR1Di" ;"SLPAL" ;"pdv";"TNA"; "AR1varm"; "TNA";

yrs = 1990;1950;(/1950,1991/)
yrl = 2014;(/1990,2014/)

wks = gsn_open_wks("png", "cesm_pdi_reg");dirip+
plot = new(10,graphic)                ; create graphic array

;---------read output---------------

;;;;;;;;;;;;;;;LENS;;;;;;;;;;;;;;;;;;;;
;from reg_pdi_lens5.ncl
;;;CMIP5 LENS;;;;;;;;;;;;;;
;CanESM2_r4i1p1_reg_mme_PDI_historical_ts_1950-2014

fils = systemfunc("ls "+diri+"lens5/CESM1-CAM5*reg_mme_"+IND+"*"+VAR1+"_"+yrs+"-"+yrl+".nc")
print(fils)
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
mrc1  =  dim_avg_n_Wrap(f[:]->rc, 0)
mpar1  = dim_avg_n_Wrap(f[:]->par, 0)

delete([/fils,f/])
printVarSummary(mrc1)
;;;CESM2 with CMIP5 forcing;;;;;;;;;;;;;;
;cesm2_cmip5_forcing_001_reg_mme_PDI_TS_1850-2014

fils = systemfunc("ls "+diri+"lens5/cesm2_cmip5_forcing*reg_mme_"+IND+"_"+VAR1+"_"+yrs+"-"+yrl+".nc")
print(fils)
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
mrc3  = dim_avg_n_Wrap(f[:]->rc, 0)
mpar3  = dim_avg_n_Wrap(f[:]->par, 0)
delete([/fils,f/])


;;;;;;;;;;;;;;;CMIP6 LE;;;;;;;;;;;;;;;;;;;;
IND2 = "PDI"

fils = systemfunc("ls "+diri+"lens6/CESM2*reg_mme_"+IND2+"_historical_"+VAR+"_"+yrs+"-"+yrl+".nc")
print(fils)
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
mrc4  = dim_avg_n_Wrap(f[:]->rc, 0)
mpar4  = dim_avg_n_Wrap(f[:]->par, 0)

delete([/fils,f/])

printVarSummary(mrc4)

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


res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""
res2@vpWidthF  = 0.6

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

res2@gsnLeftStringFontHeightF = 0.03
res2@gsnRightStringFontHeightF = res2@gsnLeftStringFontHeightF
res2@lbLabelBarOn = False;
res2@lbOrientation = "Horizontal"
res2@lbBoxLinesOn  = False
res2@lbTitleOn        =  True                ; turn on title
res2@lbLabelStride    = 2
res2@lbTitleString    = ""                ; title string
res2@lbTitlePosition  = "Right"              ; title position
res2@lbTitleFontHeightF= .015                ; make title smaller
; res2@lbTitleDirection = "Across"
res2@lbTitleExtentF   = 0.01 ;Default: 0.15
res2@lbLabelFontHeightF = 0.01  ;Default: 0.02
; res2@pmLabelBarWidthF = 0.05

res2@cnLevelSelectionMode  = "ManualLevels"
res2@cnMinLevelValF        = -3.;0.5;50;
res2@cnMaxLevelValF        =  3.;0.5;50;
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.


  res2@gsnLeftString = "CESM1-LENS"
  res2@gsnRightString = sprintf("%6.2",mpar1)
  plot(0) = gsn_csm_contour_map_ce(wks, mrc1, res2)

  res2@gsnLeftString =  "CESM2"
  res2@gsnRightString = sprintf("%6.2",mpar4)
  plot(2) = gsn_csm_contour_map_ce(wks, mrc4, res2)

  res2@gsnLeftString = "CESM2 with CMIP5 forcing"
  res2@gsnRightString = sprintf("%6.2",mpar3)
  plot(1) = gsn_csm_contour_map_ce(wks, mrc3, res2)



resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = True                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@lbBoxEndCapStyle = "TriangleBothEnds"
resk@lbOrientation = "Horizontal"
resk@lbBoxLinesOn = False
; resk@lbTitleString = com_ccr@units
;resk@lbBoxMinorExtentF = 0.2
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02
resk@txString = VAR+" regressed onto "+IND+" CESM"
gsn_panel(wks,plot,(/3,1/),resk)

end
