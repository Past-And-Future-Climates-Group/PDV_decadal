begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/"
SEASON = (/"DJF(-1)","MAM(-1)","JJA(-1)","SON(-1)","DJF(0)" /)

NLAT =  70; 65; 5; 60;
SLAT =  -70;-5;-60;
WLON =  100;120;
ELON =  300;290;


IND  = "PDI" ;"nino34";
; LEV  = "200";"200" ;
VAR  = "ts" ;"pr" ; "zg300" ;"psl" "ts"
; units = "mm/day"
LR =  "reg";"reg_mme" ;"regLag" ;

wks = gsn_open_wks("png", dirip+"reg_cesm_obs");
plot = new(30,graphic)                ; create graphic array

;---------read output---------------
; from reg_pdi_lens5.ncl
;CESM1-CAM5_r6i1p1_reg_PDI_historical_ts_1920-2014.nc
fils = systemfunc("ls "+diri+"lens5/CESM1-CAM5_*_"+LR+"_"+IND+"_historical_"+VAR+"_1920-2004.nc");
print(fils)
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
t1 = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])

; from reg_pdi_lens6.ncl
;CESM2_r4i1p1f1_reg_PDI_historical_va200_1991-2014.nc
fils = systemfunc("ls "+diri+"lens6/CESM2_*_"+LR+"_"+IND+"_historical_"+VAR+"_1850-2014.nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
t2 = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])

; from reg_pdi_cesm.ncl
;cesm2_cmip5_forcing_007_reg_PDI_ua850_1991-2014.nc
fils = systemfunc("ls "+diri+"lens5/cesm2_cmip5_forcing_*_"+LR+"_"+IND+"_TS_1850-2004.nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
t0 = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])

;read obs PDV results
;from obs_reg.ncl
f0   = addfile(diri+"obs_reg_PDI_sst_1854-2019.nc", "r")
rco  = f0->rc
printVarSummary(rco)

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
 res2@mpMaxLatF                   = NLAT         ; choose subregion
 res2@mpMinLatF                   = SLAT
 res2@mpMaxLonF                   = ELON
 res2@mpMinLonF                   = WLON
res2@gsnAddCyclic = True ;False
res2@cnFillOn = True;False ;
res2@cnLinesOn = False;True ;
res2@cnLineLabelsOn = False
res2@tmXBLabelFontHeightF = 0.018         ; change maj lat tm spacing
res2@tmYLLabelFontHeightF = res2@tmXBLabelFontHeightF
res2@gsnMajorLonSpacing = 50              ; change maj lon tm spacing

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
res2@cnMinLevelValF        = -0.5;
res2@cnMaxLevelValF        =  0.5;
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.

res2@gsnLeftString = ""
res2@gsnRightString = "ERSST"
plot(0) = gsn_csm_contour_map_ce(wks, rco, res2)
    res2@gsnRightString = "CESM1"
    plot(1) = gsn_csm_contour_map_ce(wks, t1, res2)
    res2@gsnRightString = "CESM2 with CMIP5 forcing"
    plot(2) = gsn_csm_contour_map_ce(wks, t0, res2)
    res2@gsnRightString = "CESM2"
    plot(3) = gsn_csm_contour_map_ce(wks, t2, res2)

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
resk@lbTitleDirection = "Across"
resk@lbTitleFontHeightF= .015                ; make title smaller
;resk@lbBoxMinorExtentF = 0.2
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02
; resk@txString = " regression onto "+IND
gsn_panel(wks,plot,(/2,2/),resk)


end
