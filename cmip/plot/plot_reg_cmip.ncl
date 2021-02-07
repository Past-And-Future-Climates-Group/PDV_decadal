begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

  yrs = 1861;1950;
  yrl = 2004
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/"
SEASON = (/"DJF","MAM","JJA","SON" /)

; ;CMIP5 MODELS
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
             "IPSL-CM5A-LR", "CanESM2", "MIROC5","CESM1-CAM5","HadGEM2-ES",\
             "ACCESS1-0","ACCESS1-3","bcc-csm1-1","CESM1-FASTCHEM","FGOALS-g2",\
             "FGOALS-s2","FIO-ESM","IPSL-CM5A-MR","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M"/);"GFDL-CM3",
nens5 = (/10,10,10,8,6,6,6,\
         6,5,5,4,4,\
         3,3,3,3,3,3,3,\
         3,3,3,3,3,3 /);5,

; MODEL5_ESM = (/"BNU-ESM","CanESM2","CESM1-BGC",\;"bcc-csm1-1-m",
;       "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM",\
;       "FIO-ESM","GFDL-ESM2G",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
;       "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P",\;"MRI-ESM1",
;       "NorESM1-ME","NorESM1-M"/)

; MODEL5_CM = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","CCSM4","CMCC-CM","CMCC-CMS",\
;              "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","GFDL-CM2p1",\
;              "GISS-E2-H-CC","HadCM3","HadGEM2-AO","HadGEM2-CC","HadGEM2-ES",\
;              "inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
;               "MRI-CGCM3"/)

; MODEL5 = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
;              "IPSL-CM5A-LR", "CanESM2", "MIROC5","CESM1-CAM5","HadGEM2-ES",\
;              "ACCESS1-0","ACCESS1-3","bcc-csm1-1","CESM1-FASTCHEM","FGOALS-g2",\
;              "FGOALS-s2","FIO-ESM","IPSL-CM5A-MR","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M"/);"GFDL-CM3",

M5_YES = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0",\;,"GFDL-CM3"
          "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM",\
          "MRI-CGCM3","NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

M5_NO = (/"bcc-csm1-1","CCSM4","CESM1-FASTCHEM",\
          "MPI-ESM-LR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

MODEL5_ESM = (/"CanESM2","CESM1-CAM5","CESM1-FASTCHEM",\
      "FIO-ESM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","NorESM1-M"/)

MODEL5_CM = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","CCSM4",\
             "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","GFDL-CM2p1",\
             "HadCM3","HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5", "MRI-CGCM3"/)

;; CMIP6 MODELS
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



MODEL6_ESM = (/"CanESM5","CESM2","E3SM-1-0",\
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0"/)

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

i5esm = new(dimsizes(MODEL5_ESM), "integer")
do i = 0,dimsizes(MODEL5_ESM)-1
  i5esm(i) = ind(MODEL5.eq.MODEL5_ESM(i))
end do 
i5cm = new(dimsizes(MODEL5_CM), "integer")
do i = 0,dimsizes(MODEL5_CM)-1
  i5cm(i) = ind(MODEL5.eq.MODEL5_CM(i))
end do 

i6esm = new(dimsizes(MODEL6_ESM), "integer")
do i = 0,dimsizes(MODEL6_ESM)-1
  i6esm(i) = ind(MODEL6.eq.MODEL6_ESM(i))
end do 
i6cm = new(dimsizes(MODEL6_CM), "integer")
do i = 0,dimsizes(MODEL6_CM)-1
  i6cm(i) = ind(MODEL6.eq.MODEL6_CM(i))
end do 

; VAR = "ua" ;"psl" ; 
EXP = "historical"
IND = "mmeeof2" ;"SLPAL" ;"pdv";"TNA"; "AR1Di" ;"AR1varm"; "TNA"; 

nens_all = 10


;---------read output---------------
; from reg_cmip5.ncl reg_cmip6.ncl
;cmip5_reg_SLPAL_historical_tas_1861-2004.nc
f1   = addfile(diri+"cmip5_reg_"+IND+"_historical_tas_1861-2004.nc", "r")
t5  = f1->ccr1
f1   = addfile(diri+"cmip5_reg_"+IND+"_historical_ua_1861-2004.nc", "r")
u5  = f1->ccr1
f1   = addfile(diri+"cmip5_reg_"+IND+"_historical_va_1861-2004.nc", "r")
v5  = f1->ccr1

f2   = addfile(diri+"cmip6_reg_"+IND+"_historical_ts_1850-2014.nc", "r")
t6  = f2->ccr1
f2   = addfile(diri+"cmip6_reg_"+IND+"_historical_ua_1850-2014.nc", "r")
u6  = f2->ccr1
f2   = addfile(diri+"cmip6_reg_"+IND+"_historical_va_1850-2014.nc", "r")
v6  = f2->ccr1

if (IND.eq."SLPAL") then 
    t5 = t5*-1
    u5 = u5*-1
    v5 = v5*-1
    t6 = t6*-1
    u6 = u6*-1
    v6 = v6*-1
end if 

printVarSummary(t5)
printVarSummary(t6)
printVarSummary(u5)
printVarSummary(u6)
printVarSummary(v5)
printVarSummary(v6)

do i=0,nm6-1
    print(i+"")
    printMinMax(u6(i,:,:), 1)
end do 

;something worng with E3SM-1-0 ua va....
u6(7,:,:) = u6@_FillValue
v6(7,:,:) = v6@_FillValue

;;----------composite-----------------
;MME
com_t5 = dim_avg_n_Wrap(t5 , 0)
com_t5_y = dim_avg_n_Wrap(t5(i5y,:,:) , 0)
com_t5_n = dim_avg_n_Wrap(t5(i5n,:,:) , 0)
printVarSummary(com_t5)
com_u5 = dim_avg_n_Wrap(u5 , 0)
com_u5_y = dim_avg_n_Wrap(u5(i5y,:,:) , 0)
com_u5_n = dim_avg_n_Wrap(u5(i5n,:,:) , 0)
com_v5 = dim_avg_n_Wrap(v5 , 0)
com_v5_y = dim_avg_n_Wrap(v5(i5y,:,:) , 0)
com_v5_n = dim_avg_n_Wrap(v5(i5n,:,:) , 0)

;CMIP6
com_t6 = dim_avg_n_Wrap(t6 , 0)
com_t6_e = dim_avg_n_Wrap(t6(i6esm,:,:) , 0)
com_t6_c = dim_avg_n_Wrap(t6(i6cm,:,:) , 0)
com_u6 = dim_avg_n_Wrap(u6 , 0)
com_u6_e = dim_avg_n_Wrap(u6(i6esm,:,:) , 0)
com_u6_c = dim_avg_n_Wrap(u6(i6cm,:,:) , 0)
com_v6 = dim_avg_n_Wrap(v6 , 0)
com_v6_e = dim_avg_n_Wrap(v6(i6esm,:,:) , 0)
com_v6_c = dim_avg_n_Wrap(v6(i6cm,:,:) , 0)

printMinMax(com_t6, 0)
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
wks = gsn_open_wks("ps", dirip+"cmip_reg");
plot = new(30,graphic)                ; create graphic array
plot1 = new(30,graphic)                ; create graphic array
plot2 = new(30,graphic)                ; create graphic array
plot3 = new(30,graphic)                ; create graphic array
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

res2@cnLevelSelectionMode  = "ManualLevels"    
res2@cnMinLevelValF        = -0.2;0.4
res2@cnMaxLevelValF        =  0.2;0.4
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.


res2@gsnLeftString = ""
    res2@gsnRightString = "CMIP5"
    plot(0) = gsn_csm_contour_map_ce(wks, com_t5, res2)
    res2@gsnRightString = "CMIP6"
    plot(1) = gsn_csm_contour_map_ce(wks, com_t6, res2)
    res2@gsnRightString = "CMIP5(plus)"
    plot(2) = gsn_csm_contour_map_ce(wks, com_t5_y, res2)
    res2@gsnRightString = "CMIP5(minus)"
    plot(4) = gsn_csm_contour_map_ce(wks, com_t5_n, res2)
    res2@gsnRightString = "CMIP6(ESM)"
    plot(3) = gsn_csm_contour_map_ce(wks, com_t6_e, res2)
    res2@gsnRightString = "CMIP6(CM)"
    plot(5) = gsn_csm_contour_map_ce(wks, com_t6_c, res2)

  ; vcres@vcGlyphStyle            = "Fillarrow"    ; turn on curly vectors
  vcres@vcMinFracLengthF        = 0.2 
  vcres@vcMinDistanceF          = 0.018
  vcres@vcRefMagnitudeF         = 0.5;1.0             ; define vector ref mag
  vcres@vcRefLengthF            = 0.04             ; define length of vec ref

  vcres@vcRefAnnoOn             = True
  vcres@vcRefAnnoPerimOn          = False          ;参考矢量的边框
  vcres@vcRefAnnoString2          = "m/s"            ;not draw the word"reference vector"
  vcres@vcRefAnnoOrthogonalPosF = -.15            ; move ref vector up
  
   
  vcres@lbLabelBarOn = False
  vcres@vcFillArrowFillColor = "black"

  vector= gsn_csm_vector(wks,com_u5,com_v5,vcres)       
  overlay(plot(0),vector)
  vector= gsn_csm_vector(wks,com_u6,com_v6,vcres)       
  overlay(plot(1),vector)
  vector= gsn_csm_vector(wks,com_u5_y,com_v5_y,vcres)       
  overlay(plot(2),vector)
  vector= gsn_csm_vector(wks,com_u5_n,com_v5_n,vcres)       
  overlay(plot(4),vector)
  vector= gsn_csm_vector(wks,com_u6_e,com_v6_e,vcres)       
  overlay(plot(3),vector)
  vector= gsn_csm_vector(wks,com_u6_c,com_v6_c,vcres)       
  overlay(plot(5),vector)


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
resk@txString = " regression onto "+IND
gsn_panel(wks,plot,(/3,2/),resk)


end