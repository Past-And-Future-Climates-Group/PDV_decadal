load "./function_bootstrap_mme.ncl"
begin

diri = "/Users/xingchen/Documents/project/ENSO/data/" ;"/glade/work/chenxing/enso/";
dirip = "/Users/xingchen/Documents/project/ENSO/pic/" ;"/glade/u/home/chenxing/enso/";

neof = 1

;CMIP5 MODELS
MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1-m","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;
      "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5","CNRM-CM5-2","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1","GFDL-CM3",\;
      "GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H-CC","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R","HadCM3","HadGEM2-AO",\;
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
      "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3","MRI-ESM1",\;
      "NorESM1-ME","NorESM1-M"/)


; CMIP6 MODELS
MODEL6 = (/"BCC-CSM2-MR","BCC-ESM1","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5",
        "CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FGOALS-g3","FIO-ESM-2-0","GFDL-CM4","GFDL-ESM4",\;"E3SM-1-1","FGOALS-f3-L",
        "GISS-E2-1-G","GISS-E2-1-H","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC",
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NESM3","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM",

; ;CMIP5 MODELS
; MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;"bcc-csm1-1-m",
;       "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
;       "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
;       "GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
;       "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
;       "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\;"MRI-ESM1",
;       "NorESM1-ME","NorESM1-M"/)

;include all model even its ens is 1
MODEL5_PLUS = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2", "HadGEM2-CC",\;,"GFDL-CM3"
          "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM-CHEM","MIROC-ESM",\
          "MRI-CGCM3","NorESM1-ME", "NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

MODEL5_MINUS = (/"bcc-csm1-1","BNU-ESM","CCSM4","CESM1-BGC","CESM1-FASTCHEM","CESM1-WACCM",\
              "CMCC-CESM","CMCC-CM","CMCC-CMS","FGOALS-s2","GFDL-CM2p1", "GFDL-ESM2G","MPI-ESM-LR",\
              "HadCM3","inmcm4","MPI-ESM-MR","MPI-ESM-P"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

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

; MODEL5_PLUS = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0",\;,"GFDL-CM3"
;           "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM",\
;           "MRI-CGCM3","NorESM1-M","FGOALS-g2"/) ;explicitly have aerosol interaction included in CMIP5

; MODEL5_MINUS = (/"bcc-csm1-1","CCSM4","CESM1-FASTCHEM", "MPI-ESM-LR",\
;           "GFDL-CM2p1","FGOALS-s2","FIO-ESM","HadCM3","MPI-ESM-MR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

; nens5_plus = (/3,3,5,4,10,10,\
;              4,6,3,5,3,\
;              3,3,3/)

; nens5_minus = (/3,6,3,3,\
;                10,3,3,8,3/)

MODEL5_ESM = (/"CanESM2","CESM1-CAM5","CESM1-FASTCHEM",\
      "FIO-ESM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","NorESM1-M"/)

MODEL5_CM = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","CCSM4",\
             "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","GFDL-CM2p1",\
             "HadCM3","HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5", "MRI-CGCM3"/)

; ;; CMIP6 MODELS
; MODEL6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
;         "CESM2","CESM2-WACCM-FV2",\
;         "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
;         "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",
MODEL6_ESM = (/"CanESM5","CESM2-FV2","CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0",\
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorESM2-LM"/)

MODEL6_CM = (/"BCC-CSM2-MR","CAMS-CSM1-0","GFDL-CM4","GISS-E2-1-G",\
       "INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6","NorCPM1","SAM0-UNICON" /)
; MODEL6 = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
;   "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0",\
;   "BCC-CSM2-MR","CESM2-FV2","CESM2-WACCM-FV2",\
;          "CESM2-WACCM","FIO-ESM-2-0","NorESM2-LM" /) ;large ensemble model in CMIP6 "NESM3",


MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
  "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0",\
    "BCC-CSM2-MR","CESM2-FV2","CESM2-WACCM-FV2",\
         "CESM2-WACCM","FIO-ESM-2-0","NorESM2-LM" /) ;large ensemble model in CMIP6 "NESM3",

nens6 = (/32,30,25,12,11, 10, 10,\;10,
          10,7,5,5,\
          3,3,3,\
          3,3,3 /) ;ensemble number 5,



; MODEL6_ESM = (/"CanESM5","CESM2","E3SM-1-0",\
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0"/)
; MODEL6_CM = (/"GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MIROC6","NorCPM1" /)

; nens6_esm = (/25,11,5,7,10, 5/)
; nens6_cm = (/12,10,32,10,30/)

nm5 = dimsizes(MODEL5)
nm6 = dimsizes(MODEL6)

i5y = new(dimsizes(MODEL5_PLUS), "integer")
do i = 0,dimsizes(MODEL5_PLUS)-1
  i5y(i) = ind(MODEL5.eq.MODEL5_PLUS(i))
end do 
i5n = new(dimsizes(MODEL5_MINUS), "integer")
do i = 0,dimsizes(MODEL5_MINUS)-1
  i5n(i) = ind(MODEL5.eq.MODEL5_MINUS(i))
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
IND = "PDI_CE" ;"EACSS" ;"EAS" ;"PDI2" ; "NPCSS" ;"NPC" ;"NPS" ;"NPAOD" ;"PDI2";"TPI" ;"NPI" ;"AMO" ;"pdo" ;"nh-sh" ;"GMAOD" ;"GMSW" ;
MODEL = MODEL5;MODEL6; 
nens = nens6
icmip = 5;6 ; 
nens_all = 10;32 ;

yrs = 1861; 
yrl = 2004; 2014;


nmo5 = dimsizes(MODEL5)
nmo6 = dimsizes(MODEL6)



ce5 = asciiread(diri+"cmip5_historical_PDI_CE_mme.txt", 1728, "float")
ce5_std = asciiread(diri+"cmip5_historical_PDI_CE_std.txt", 1728, "float")
csw5 = asciiread(diri+"cmip5_historical_PDI_CSW_mme.txt", 1728, "float")
csw5_std = asciiread(diri+"cmip5_historical_PDI_CSW_std.txt", 1728, "float")
sw5 = asciiread(diri+"cmip5_historical_PDI_SW_mme.txt", 1728, "float")
sw5_std = asciiread(diri+"cmip5_historical_PDI_SW_std.txt", 1728, "float")
ce6 = asciiread(diri+"cmip6_historical_PDI_CE_mme.txt", 1980, "float")
ce6_std = asciiread(diri+"cmip6_historical_PDI_CE_std.txt", 1980, "float")
csw6 = asciiread(diri+"cmip6_historical_PDI_CSW_mme.txt", 1980, "float")
csw6_std = asciiread(diri+"cmip6_historical_PDI_CSW_std.txt", 1980, "float")
sw6 = asciiread(diri+"cmip6_historical_PDI_SW_mme.txt", 1980, "float")
sw6_std = asciiread(diri+"cmip6_historical_PDI_SW_std.txt", 1980, "float")


ce5@_FillValue = 1e+20
csw5@_FillValue = 1e+20
sw5@_FillValue = 1e+20
sw6@_FillValue = 1e+20
ce6@_FillValue = 1e+20
csw6@_FillValue = 1e+20
printVarSummary(sw6)
;--------output-------------
fon=diri+"cmip5_historical_PDI_CE_mme.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->cp5_a = ce5
fo->std_5 = ce5_std
fon=diri+"cmip6_historical_PDI_CE_mme.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->cp6_a = ce6
fo->std_6 = ce6_std

exit 
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

  ndim5  = dimsizes(sw5)
  x_axis5 = fspan(yrs5, yrl5, ndim5(0))
  ndim6  = dimsizes(sw6)
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

  res@trYMinF               = -3.0
  res@trYMaxF               =  3.0


;MODEL
res@xyLineThicknessF = 2.0
res@gsnLeftString = "SW over Pacific dipole area"
res@xyLineColor = "black"
plot(0) = gsn_csm_xy (wks,x_axis6, sw6 ,res) ;x_axis2, com_pc
res@xyLineColor = "red"
plota = gsn_csm_xy (wks,x_axis5,sw5,res) ;cg_a ;crt_g_a
overlay(plot(0), plota)

res@gsnLeftString = "clear-sky SW over Pacific dipole area"
res@xyLineColor = "black"
plot(1) = gsn_csm_xy (wks,x_axis6, csw6 ,res) ;x_axis2, com_pc
res@xyLineColor = "red"
plota = gsn_csm_xy (wks,x_axis5,csw5,res) ;cg_a ;crt_g_a
overlay(plot(1), plota)

res@gsnLeftString = "cloud effect SW over Pacific dipole area"
res@xyLineColor = "black"
plot(2) = gsn_csm_xy (wks,x_axis6, ce6 ,res) ;x_axis2, com_pc
res@xyLineColor = "red"
plota = gsn_csm_xy (wks,x_axis5,ce5,res) ;cg_a ;crt_g_a
overlay(plot(2), plota)

;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@txString = ""

gsn_panel(wks,plot,(/3,1/),resk)

end
