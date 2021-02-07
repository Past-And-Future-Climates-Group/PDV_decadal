begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
neof = 1

  yrs = 1861
  yrl = 2004
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/"
SEASON = (/"DJF","MAM","JJA","SON" /)

MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;"bcc-csm1-1-m",
      "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
      "GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
      "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\;"MRI-ESM1",
      "NorESM1-ME","NorESM1-M"/)

; M5_YES = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","HadGEM2-CC",\;,"GFDL-CM3"
;           "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM-CHEM","MIROC-ESM",\
;           "MRI-CGCM3","NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

; M5_NO = (/"bcc-csm1-1","BNU-ESM","CCSM4","CESM1-BGC","CESM1-FASTCHEM","CESM1-WACCM",\
;           "GFDL-ESM2G","MPI-ESM-LR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

MODEL5_LE = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
             "IPSL-CM5A-LR", "CanESM2", "MIROC5"/);"GFDL-CM3",
nens5 = (/10,10,10,8,6,6,6,\
         6,5,5 /);5,

;LE version
M5_YES = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0",\;,"GFDL-CM3"
          "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM",\
          "MRI-CGCM3","NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

;LE version
M5_NO = (/"bcc-csm1-1","CCSM4","CESM1-FASTCHEM",\
          "MPI-ESM-LR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

MODEL6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
        "CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
        "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",

; MODEL6_ESM = (/"CanESM5","CESM2-FV2","CESM2","CESM2-WACCM-FV2",\
;         "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0",\
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorESM2-LM"/)

; MODEL6_CM = (/"BCC-CSM2-MR","CAMS-CSM1-0","GFDL-CM4","GISS-E2-1-G",\
;        "INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6","NorCPM1","SAM0-UNICON" /)
; MODEL6 = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
;   "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",


MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
  "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",

nens6 = (/32,30,25,12,11, 10, 10,\;10,
          10,7,5,5 /) ;ensemble number 5,

;LE version
MODEL6_ESM = (/"CanESM5","CESM2","E3SM-1-0",\
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0"/)

;LE version
MODEL6_CM = (/"GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MIROC6","NorCPM1" /)


nm5 = dimsizes(MODEL5)
nm6 = dimsizes(MODEL6)

i5y = new(dimsizes(M5_YES), "integer")
do i = 0,dimsizes(M5_YES)-1
  i5y(i) = ind(MODEL5.eq.M5_YES(i))
end do 
i5n = new(dimsizes(M5_NO), "integer")
do i = 0,dimsizes(M5_NO)-1
  i5n(i) = ind(MODEL5.eq.M5_NO(i))
end do 
print("say yes "+i5y)
print("say no "+i5n)
i5le = new(dimsizes(MODEL5_LE), "integer")
do i = 0,dimsizes(MODEL5_LE)-1
  i5le(i) = ind(MODEL5.eq.MODEL5_LE(i))
end do 
i6le = new(dimsizes(MODEL6_LE), "integer")
do i = 0,dimsizes(MODEL6_LE)-1
  i6le(i) = ind(MODEL6.eq.MODEL6_LE(i))
end do 

i6esm = new(dimsizes(MODEL6_ESM), "integer")
do i = 0,dimsizes(MODEL6_ESM)-1
  i6esm(i) = ind(MODEL6.eq.MODEL6_ESM(i))
end do 
i6cm = new(dimsizes(MODEL6_CM), "integer")
do i = 0,dimsizes(MODEL6_CM)-1
  i6cm(i) = ind(MODEL6.eq.MODEL6_CM(i))
end do 

i5 = ispan(0, nm5-1, 1)
i6 = ispan(0, nm6-1, 1)


VAR = "ua" ;"ts" ;"psl" ; 
EXP = "historical"


; from clm_cmip5.ncl clm_cmip6.ncl
f1   = addfile(diri+"cmip5_annual_EnsMean_tas_"+yrs+"-"+yrl+".nc", "r")
mclm5  = f1->mclm

f1   = addfile(diri+"cmip6_annual_EnsMean_ts_1850-2014.nc", "r")
mclm6  = f1->mclm

f1   = addfile(diri+"cmip5_annual_EnsMean_ua_"+yrs+"-"+yrl+".nc", "r")
uclm5  = f1->mclm
f1   = addfile(diri+"cmip6_annual_EnsMean_ua_1850-2014.nc", "r")
uclm6  = f1->mclm
f1   = addfile(diri+"cmip5_annual_EnsMean_va_"+yrs+"-"+yrl+".nc", "r")
vclm5  = f1->mclm
f1   = addfile(diri+"cmip6_annual_EnsMean_va_1850-2014.nc", "r")
vclm6  = f1->mclm

;something worng with E3SM-1-0 ua va....
uclm6(7,:,:,:) = uclm6@_FillValue
vclm6(7,:,:,:) = vclm6@_FillValue

  yrs5 = 1861
  yrl5 = 2004
  yrs6 = 1850
  yrl6 = 2014
printVarSummary(mclm5)
printVarSummary(mclm6)
printVarSummary(uclm6)

print(nm5)
print(nm6)
;;----------composite-----------------
;MME
ys1 = yrs
ys2 = 1950
ys3 = 1980
yl1 = 1950
yl2 = 1980
yl3 = yrl

;AA group
yy = yrs6
zz = i6cm
com5_1 = dim_avg_n_Wrap(mclm6(zz,ys1-yy:yl1-yy,:,:) , (/0,1/))
com5_2 = dim_avg_n_Wrap(mclm6(zz,ys2-yy:yl2-yy,:,:) , (/0,1/))
com5_3 = dim_avg_n_Wrap(mclm6(zz,ys3-yy:yl3-yy,:,:) , (/0,1/))

ua5_1 = dim_avg_n_Wrap(uclm6(zz,ys1-yy:yl1-yy,:,:) , (/0,1/))
ua5_2 = dim_avg_n_Wrap(uclm6(zz,ys2-yy:yl2-yy,:,:) , (/0,1/))
ua5_3 = dim_avg_n_Wrap(uclm6(zz,ys3-yy:yl3-yy,:,:) , (/0,1/))

va5_1 = dim_avg_n_Wrap(vclm6(zz,ys1-yy:yl1-yy,:,:) , (/0,1/))
va5_2 = dim_avg_n_Wrap(vclm6(zz,ys2-yy:yl2-yy,:,:) , (/0,1/))
va5_3 = dim_avg_n_Wrap(vclm6(zz,ys3-yy:yl3-yy,:,:) , (/0,1/))

;BB group
yy = yrs6
xx = i6esm
com6_1 = dim_avg_n_Wrap(mclm6(xx,ys1-yy:yl1-yy,:,:) , (/0,1/))
com6_2 = dim_avg_n_Wrap(mclm6(xx,ys2-yy:yl2-yy,:,:) , (/0,1/))
com6_3 = dim_avg_n_Wrap(mclm6(xx,ys3-yy:yl3-yy,:,:) , (/0,1/))

ua6_1 = dim_avg_n_Wrap(uclm6(xx,ys1-yy:yl1-yy,:,:) , (/0,1/))
ua6_2 = dim_avg_n_Wrap(uclm6(xx,ys2-yy:yl2-yy,:,:) , (/0,1/))
ua6_3 = dim_avg_n_Wrap(uclm6(xx,ys3-yy:yl3-yy,:,:) , (/0,1/))

va6_1 = dim_avg_n_Wrap(vclm6(xx,ys1-yy:yl1-yy,:,:) , (/0,1/))
va6_2 = dim_avg_n_Wrap(vclm6(xx,ys2-yy:yl2-yy,:,:) , (/0,1/))
va6_3 = dim_avg_n_Wrap(vclm6(xx,ys3-yy:yl3-yy,:,:) , (/0,1/))
printVarSummary(com6_3)
printMinMax(com5_3, 0)

dif_1 = com5_1
dif_2 = com5_1
dif_3 = com5_1
dif_1 = com6_1 - com5_1
dif_2 = com6_2 - com5_2
dif_3 = com6_3 - com5_3

difu_1 = ua5_1
difu_2 = ua5_1
difu_3 = ua5_1
difu_1 = ua6_1 - ua5_1
difu_2 = ua6_2 - ua5_2
difu_3 = ua6_3 - ua5_3

difv_1 = va5_1
difv_2 = va5_1
difv_3 = va5_1
difv_1 = va6_1 - va5_1
difv_2 = va6_2 - va5_2
difv_3 = va6_3 - va5_3

printMinMax(uclm6, 0)
printMinMax(vclm6, 0)
printMinMax(ua6_1, 0)
printMinMax(va6_1, 0)
printMinMax(ua6_2, 0)
printMinMax(va6_2, 0)
printMinMax(difv_3, 0)
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
wks = gsn_open_wks("ps", dirip+"cmip_clm");
plot = new(30,graphic)                ; create graphic array
plot2 = new(30,graphic)                ; create graphic array
plot1 = new(30,graphic)                ; create graphic array
gsn_define_colormap(wks, "NCV_blu_red")


res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""
vcres = res2 

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
res2@cnMinLevelValF        = -0.8
res2@cnMaxLevelValF        =  0.8 
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.

AA = "CMIP6(CM)"
BB = "CMIP6(ESM)"

    res2@gsnLeftString = AA
    res2@gsnRightString = ys1+"-"+yl1
    plot(0) = gsn_csm_contour_map_ce(wks, com5_1 , res2)
    res2@gsnRightString = ys2+"-"+yl2
    plot(1) = gsn_csm_contour_map_ce(wks, com5_2 , res2)
    res2@gsnRightString = ys3+"-"+yl3
    plot(2) = gsn_csm_contour_map_ce(wks, com5_3 , res2)

    res2@gsnLeftString = BB
    res2@gsnRightString = ys1+"-"+yl1
    plot(3) = gsn_csm_contour_map_ce(wks, com6_1 , res2)
    res2@gsnRightString = ys2+"-"+yl2
    plot(4) = gsn_csm_contour_map_ce(wks, com6_2 , res2)
    res2@gsnRightString = ys3+"-"+yl3
    plot(5) = gsn_csm_contour_map_ce(wks, com6_3 , res2)

    res2@gsnLeftString = BB+"-"+AA
    res2@gsnRightString = ys1+"-"+yl1
    plot(6) = gsn_csm_contour_map_ce(wks, dif_1 , res2)
    res2@gsnRightString = ys2+"-"+yl2
    plot(7) = gsn_csm_contour_map_ce(wks, dif_2 , res2)
    res2@gsnRightString = ys3+"-"+yl3
    plot(8) = gsn_csm_contour_map_ce(wks, dif_3 , res2)


  ; vcres@vcGlyphStyle            = "Fillarrow"    ; turn on curly vectors
  vcres@vcMinFracLengthF        = 0.2 
  vcres@vcMinDistanceF          = 0.02
  vcres@vcRefMagnitudeF         = 0.3            ; define vector ref mag
  vcres@vcRefLengthF            = 0.04              ; define length of vec ref

  vcres@vcRefAnnoOn             = True
  vcres@vcRefAnnoPerimOn          = False          ;参考矢量的边框
  vcres@vcRefAnnoString2          = "m/s"            ;not draw the word"reference vector"
  vcres@vcRefAnnoOrthogonalPosF = -.15            ; move ref vector up
  
   
  vcres@lbLabelBarOn = False
  vcres@vcFillArrowFillColor = "black"

  vector= gsn_csm_vector(wks,ua5_1,va5_1,vcres)       
  overlay(plot(0),vector)
  vector= gsn_csm_vector(wks,ua5_2,va5_2,vcres)       
  overlay(plot(1),vector)
  vector= gsn_csm_vector(wks,ua5_3,va5_3,vcres)       
  overlay(plot(2),vector)
  vector= gsn_csm_vector(wks,ua6_1,va6_1,vcres)       
  overlay(plot(3),vector)
  vector= gsn_csm_vector(wks,ua6_2,va6_2,vcres)       
  overlay(plot(4),vector)
  vector= gsn_csm_vector(wks,ua6_3,va6_3,vcres)       
  overlay(plot(5),vector)
  vector= gsn_csm_vector(wks,difu_1,difv_1,vcres)       
  overlay(plot(6),vector)
  vector= gsn_csm_vector(wks,difu_2,difv_2,vcres)       
  overlay(plot(7),vector)
  vector= gsn_csm_vector(wks,difu_3,difv_3,vcres)       
  overlay(plot(8),vector)

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
resk@txString = ""
gsn_panel(wks,plot,(/3,3/),resk)


end
