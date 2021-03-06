begin
diri = "/glade/work/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/data/" ;
dirip = "/glade/u/home/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/pic/" ;

setfileoption("nc","SuppressClose",False)

VAR = "clt" ;"od550aer" ;"cloudeffect";"ts" ; "rsds" "va" ;"psl" ;
EXP = "historical"
IND = "PDI" ;"mmeeof2" ;"mmeeof1" ;"GMAOD" ;"PDI2" ;"PDI"; "AR1Di" ;"SLPAL" ;"pdv";"TNA"; "AR1varm"; "TNA";

yrs = (/1950,1991/)
yrl = (/1990,2014/)

wks = gsn_open_wks("png", "pdi_reg");dirip+
plot = new(10,graphic)                ; create graphic array
plot1 = new(10,graphic)                ; create graphic array
plot2 = new(10,graphic)                ; create graphic array
plot3 = new(10,graphic)                ; create graphic array
plot4 = new(10,graphic)                ; create graphic array
plot5 = new(10,graphic)                ; create graphic array
plotc = new(10,graphic)                ; create graphic array
plotd = new(10,graphic)                ; create graphic array

do i = 0,dimsizes(yrs)-1


  MODEL5 = (/"CESM1-CAM5","CSIRO-Mk3-6-0",\;"CanESM2",
    "GFDL-CM3","GFDL-ESM2M"/);,"MPI-ESM"
  nens5 = (/"40","30","20","30"/);"50",,"100"

  nm5 = dimsizes(MODEL5)

rc1 = new((/nm5,72,144/),"float")
mrc1 = new((/nm5,72,144/),"float")
par1 = new((/nm5/),"float")
mpar1 = new((/nm5/),"float")

do im = 0,nm5-1
;---------read output---------------

;;;;;;;;;;;;;;;LENS;;;;;;;;;;;;;;;;;;;;
;from reg_pdi_lens5.ncl
;;;CMIP5 LENS;;;;;;;;;;;;;;
;CanESM2_r4i1p1_reg_mme_PDI_historical_ts_1950-2004
fils = systemfunc("ls "+diri+"lens5/"+MODEL5(im)+"*reg_"+IND+"*"+VAR+"_"+yrs(i)+"-"+yrl(i)+".nc")
print(fils)
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
rc1(im,:,:)  = dim_avg_n_Wrap(f[:]->rc, 0)
par1(im)  = dim_avg_n_Wrap(f[:]->par, 0)

; fils = systemfunc("ls "+diri+"lens5/"+MODEL5(im)+"*reg_mme_"+IND+"*"+VAR+"_"+yrs(i)+"-"+yrl(i)+".nc")
; print(fils)
; f   = addfiles(fils, "r")  ;multiple files
; ListSetType (f, "join")
; mrc1(im,:,:)  =  dim_avg_n_Wrap(f[:]->rc, 0)
; mpar1(im)  = dim_avg_n_Wrap(f[:]->par, 0)

delete([/fils,f/])
end do
printVarSummary(rc1)
printVarSummary(mrc1)
;
; ;;;;;;;;;;;;;;;CESM;;;;;;;;;;;;;;;;;;;;
; ;from reg_pdi_cesm.ncl
; ;;;CESM1 single forcing;;;;;;;;;;;;;;
; MODEL2 = "cesm1_le";"cesm2_cmip5_forcing" ;
; EXP2 =  (/"xghg", "xaer" , "xlulc", "xbmb"/);"" ;
; nens2 = (/"20","20","5","15" /) ;"7"
; nex = dimsizes(EXP2)
; VAR2 = "TS"
;
; rc2 = new((/nex,72,144/),"float")
; mrc2 = new((/nex,72,144/),"float")
; par2 = new((/nex/),"float")
; mpar2 = new((/nex/),"float")
;
; do ia = 0,nex-1
; ;cesm1_le_xaer_020_reg_mme_PDI_TS_1920-2004
; fils = systemfunc("ls "+diri+"lens5/cesm1_le_"+EXP2(ia)+"*reg_"+IND+"_"+VAR2+"_"+yrs(i)+"-"+yrl(i)+".nc")
; print(fils)
; f   = addfiles(fils, "r")  ;multiple files
; ListSetType (f, "join")
; rc2(ia,:,:)  = dim_avg_n_Wrap(f[:]->rc, 0)
; par2(ia)  = dim_avg_n_Wrap(f[:]->par, 0)
;
; fils = systemfunc("ls "+diri+"lens5/cesm1_le_"+EXP2(ia)+"*reg_mme_"+IND+"_"+VAR2+"_"+yrs(i)+"-"+yrl(i)+".nc")
; print(fils)
; f   = addfiles(fils, "r")  ;multiple files
; ListSetType (f, "join")
; mrc2(ia,:,:)  = dim_avg_n_Wrap(f[:]->rc, 0)
; mpar2(ia)  = dim_avg_n_Wrap(f[:]->par, 0)
;
; delete([/fils,f/])
; end do
; printVarSummary(mrc2)
;
;;;CESM2 with CMIP5 forcing;;;;;;;;;;;;;;
;cesm2_cmip5_forcing_001_reg_mme_PDI_TS_1850-2004
fils = systemfunc("ls "+diri+"lens5/cesm2_cmip5_forcing*reg_"+IND+"_"+VAR+"_"+yrs(i)+"-"+yrl(i)+".nc")
print(fils)
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
rc3  = dim_avg_n_Wrap(f[:]->rc, 0)
; cautious here!!
rc3 = rc3 *100. ;units ????
par3  = dim_avg_n_Wrap(f[:]->par, 0)

; fils = systemfunc("ls "+diri+"lens5/cesm2_cmip5_forcing*reg_mme_"+IND+"_"+VAR2+"_"+yrs(i)+"-"+yrl(i)+".nc")
; print(fils)
; f   = addfiles(fils, "r")  ;multiple files
; ListSetType (f, "join")
; mrc3  = dim_avg_n_Wrap(f[:]->rc, 0)
; mpar3  = dim_avg_n_Wrap(f[:]->par, 0)
delete([/fils,f/])


;;;;;;;;;;;;;;;CMIP6 LE;;;;;;;;;;;;;;;;;;;;
; MODEL6 = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0","MIROC6",\;"GISS-E2-1-H",
;   "MPI-ESM1-2-LR","MPI-ESM1-2-HR"/);,"MRI-ESM2-0","E3SM-1-0",\
;     ; "BCC-CSM2-MR","CESM2-FV2","CESM2-WACCM-FV2",\
;     ;      "CESM2-WACCM","FIO-ESM-2-0","NorESM2-LM" /) ;large ensemble model in CMIP6 "NESM3",
    MODEL6 = (/"IPSL-CM6A-LR", "CanESM5", "GISS-E2-1-G","CESM2","MIROC6"/);,\;"GISS-E2-1-H",

nens6 = (/32,30,25,12,11, 10, 10,\;10,
          10,7/);,5,5,\
          ; 3,3,3,\
          ; 3,3,3 /) ;ensemble number 5,
nm6 = dimsizes(MODEL6)
IND2 = "PDI"

rc4 = new((/nm6,72,144/),"float")
mrc4 = new((/nm6,72,144/),"float")
par4 = new((/nm6/),"float")
mpar4 = new((/nm6/),"float")

do ia = 0,nm6-1
;NorCPM1_r24i1p1f1_reg_mme_PDI2_historical_ts_1850-2014.nc
fils = systemfunc("ls "+diri+"lens6/"+MODEL6(ia)+"*reg_"+IND2+"_historical_"+VAR+"_"+yrs(i)+"-"+yrl(i)+".nc")
print(fils)
f   = addfiles(fils, "r")  ;multiple files
ListSetType (f, "join")
rc4(ia,:,:)  = dim_avg_n_Wrap(f[:]->rc, 0)
par4(ia)  = dim_avg_n_Wrap(f[:]->par, 0)

; fils = systemfunc("ls "+diri+"lens6/"+MODEL6(ia)+"*reg_mme_"+IND2+"_historical_"+VAR+"_"+yrs(i)+"-"+yrl(i)+".nc")
; print(fils)
; f   = addfiles(fils, "r")  ;multiple files
; ListSetType (f, "join")
; mrc4(ia,:,:)  = dim_avg_n_Wrap(f[:]->rc, 0)
; mpar4(ia)  = dim_avg_n_Wrap(f[:]->par, 0)

delete([/fils,f/])
end do

printVarSummary(mrc4)

if (i.eq.0) then

  ; period difference P2-P1
  drc1 = rc1
  drc3 = rc3
  drc4 = rc4


else

  ; period difference P2-P1 for each of them
  drc1 = rc1 - drc1
  drc3 = rc3 - drc3
  drc4 = rc4 - drc4

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
res2@cnMinLevelValF        = -5.
res2@cnMaxLevelValF        =  5.
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.



do im = 0,nm5-1
    res2@gsnLeftString = MODEL5(im)
    res2@gsnRightString = sprintf("%6.2",par1(im))
    plot(im) = gsn_csm_contour_map_ce(wks, rc1(im,:,:), res2)
    res2@gsnRightString = sprintf("%6.2",mpar1(im))
    ; plot1(im) = gsn_csm_contour_map_ce(wks, mrc1(im,:,:), res2)
end do

do im = 0,nm6-1
  res2@gsnLeftString =  MODEL6(im)
  res2@gsnRightString = sprintf("%6.2",par4(im))
  plot2(im) = gsn_csm_contour_map_ce(wks, rc4(im,:,:), res2)
  res2@gsnRightString = sprintf("%6.2",mpar4(im))
  ; plot3(im) = gsn_csm_contour_map_ce(wks, mrc4(im,:,:), res2)
end do
;
; do im = 0,nex-1
;   res2@gsnLeftString = EXP2(im)+" in CESM1"
;   res2@gsnRightString = sprintf("%6.2",par2(im))
;   plot4(im) = gsn_csm_contour_map_ce(wks, rc2(im,:,:), res2)
;   res2@gsnRightString = sprintf("%6.2",mpar2(im))
;   ; plot5(im) = gsn_csm_contour_map_ce(wks, mrc2(im,:,:), res2)
; end do
;
res2@gsnLeftString = "CESM2 with CMIP5 forcing"
res2@gsnRightString = sprintf("%6.2",par3)
plot4(0) = gsn_csm_contour_map_ce(wks, rc3, res2)
; res2@gsnRightString = sprintf("%6.2",mpar3)
; plot5(nex) = gsn_csm_contour_map_ce(wks, mrc3, res2)

res2@cnMinLevelValF        = -5.
res2@cnMaxLevelValF        =  5.
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.

if (i.eq.1) then
  res2@gsnLeftString = "P2 - P1"
  do im = 0,nm5-1
      res2@gsnLeftString = MODEL5(im)
    plotc(im) = gsn_csm_contour_map_ce(wks, drc1(im,:,:), res2)
  end do

  do im = 0,nm6-1
    res2@gsnLeftString =  MODEL6(im)
    plotd(im+1) = gsn_csm_contour_map_ce(wks, drc4(im,:,:), res2)
  end do

    res2@gsnLeftString = "CESM2 with CMIP5 forcing"
    plotd(0) = gsn_csm_contour_map_ce(wks, drc3, res2)

end if


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
resk@txString = VAR+" regressed onto "+IND+" CMIP5 LENS  ~C~ internal variability"
gsn_panel(wks,plot,(/5,2/),resk)
resk@txString = VAR+" regressed onto "+IND+" CMIP5 LENS  ~C~ external response"
; gsn_panel(wks,plot1,(/5,2/),resk)
resk@txString = VAR+" regressed onto "+IND+" CMIP6 LENS  ~C~ internal variability"
gsn_panel(wks,plot2,(/5,2/),resk)
resk@txString = VAR+" regressed onto "+IND+" CMIP6 LENS ~C~ external response"
; gsn_panel(wks,plot3,(/5,2/),resk)
resk@txString = VAR+" regressed onto "+IND+" CMIP5 EXPs ~C~ internal variability"
gsn_panel(wks,plot4,(/5,2/),resk)
resk@txString = VAR+" regressed onto "+IND+" CMIP5 EXPs ~C~ external response"
; gsn_panel(wks,plot5,(/5,2/),resk)

delete([/res2/])
end do

resk@txString = ""
gsn_panel(wks,plotc,(/5,2/),resk)
gsn_panel(wks,plotd,(/5,2/),resk)

end
