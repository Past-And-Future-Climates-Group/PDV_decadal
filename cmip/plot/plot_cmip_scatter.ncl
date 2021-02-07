load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
begin

diri  = "/Users/xingchen/Documents/project/ENSO/data/" ;"/glade/work/chenxing/enso/"
diri0 = "/Users/xingchen/Documents/project/ENSO/pic/" ;"/glade/u/home/chenxing/enso/"

SEASON = (/"DJF","MAM","JJA","SON" /)

; ;CMIP5 MODELS
; MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;"bcc-csm1-1-m",
;       "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
;       "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
;       "GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
;       "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
;       "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\;"MRI-ESM1",
;       "NorESM1-ME","NorESM1-M"/)

; M5_YES = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","HadGEM2-CC",\;,"GFDL-CM3"
;           "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM-CHEM","MIROC-ESM",\
;           "MRI-CGCM3","NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

; M5_NO = (/"bcc-csm1-1","BNU-ESM","CCSM4","CESM1-BGC","CESM1-FASTCHEM","CESM1-WACCM",\
;           "GFDL-ESM2G","MPI-ESM-LR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

MODEL5_LE = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
             "IPSL-CM5A-LR", "CanESM2", "MIROC5","CESM1-CAM5","HadGEM2-ES",\
             "ACCESS1-0","ACCESS1-3","bcc-csm1-1","CESM1-FASTCHEM","FGOALS-g2",\
             "FGOALS-s2","FIO-ESM","IPSL-CM5A-MR","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M"/);,\
             ; "BNU-ESM","CESM1-BGC","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
             ; "GFDL-ESM2G","GISS-E2-H-CC","HadGEM2-AO","HadGEM2-CC","inmcm4","IPSL-CM5A-LR",\
             ;  "MIROC-ESM-CHEM","MPI-ESM-P","NorESM1-ME"/);"GFDL-CM3",
nens5 = (/10,10,10,8,6,6,6,\
         6,5,5,4,4,\
         3,3,3,3,3,3,3,\
         3,3,3,3,3,3,\
         1,1,1,1,1,1,\
         1,1,1,1,1,1,\
         1,2,1 /);5,

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

MODEL5 = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
             "IPSL-CM5A-LR", "CanESM2", "MIROC5","CESM1-CAM5","HadGEM2-ES",\
             "ACCESS1-0","ACCESS1-3","bcc-csm1-1","CESM1-FASTCHEM","FGOALS-g2",\
             "FGOALS-s2","FIO-ESM","IPSL-CM5A-MR","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M"/);"GFDL-CM3",

MODEL5_PLUS = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0",\;,"GFDL-CM3"
          "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM",\
          "MRI-CGCM3","NorESM1-M",\
          "FGOALS-g2"/) ;explicitly have aerosol interaction included in CMIP5

MODEL5_MINUS = (/"bcc-csm1-1","CCSM4","CESM1-FASTCHEM",\
          "MPI-ESM-LR",\
          "GFDL-CM2p1","FGOALS-s2","FIO-ESM","HadCM3",\
          "MPI-ESM-MR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

nens5_plus = (/3,3,5,4,10,10,\
             4,6,3,5,3,\
             3,3,\
             3/)

nens5_minus = (/3,6,3,3,\
               10,3,3,8,\
               3/)

MODEL5_ESM = (/"CanESM2","CESM1-CAM5","CESM1-FASTCHEM",\
      "FIO-ESM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","NorESM1-M"/)

MODEL5_CM = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","CCSM4",\
             "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","GFDL-CM2p1",\
             "HadCM3","HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5", "MRI-CGCM3"/)

;; CMIP6 MODELS
; MODEL6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
;         "CESM2","CESM2-WACCM-FV2",\
;         "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
;         "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",
; MODEL6_ESM = (/"CanESM5","CESM2-FV2","CESM2","CESM2-WACCM-FV2",\
;         "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0",\
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorESM2-LM"/)

; MODEL6_CM = (/"BCC-CSM2-MR","CAMS-CSM1-0","GFDL-CM4","GISS-E2-1-G",\
;        "INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6","NorCPM1","SAM0-UNICON" /)
MODEL6 = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
  "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0",\
  "BCC-CSM2-MR","CESM2-FV2","CESM2-WACCM-FV2",\
         "CESM2-WACCM","FIO-ESM-2-0","NorESM2-LM" /) ;large ensemble model in CMIP6 "NESM3",


MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
  "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0",\
    "BCC-CSM2-MR","CESM2-FV2","CESM2-WACCM-FV2",\
         "CESM2-WACCM","FIO-ESM-2-0","NorESM2-LM" /) ;large ensemble model in CMIP6 "NESM3",

nens6 = (/32,30,25,12,11, 10, 10,\;10,
          10,7,5,5,\
          3,3,3,\
          3,3,3 /) ;ensemble number 5,



MODEL6_ESM = (/"CanESM5","CESM2","E3SM-1-0",\
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0"/)

MODEL6_CM = (/"GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MIROC6","NorCPM1" /)


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

nens_all = 32
pc5 = new((/nm5,nens_all,nyr5/), "float")
pc6 = new((/nm6,nens_all,nyr6/), "float")
gmst5 = new((/nm5,nens_all,nyr5/), "float")
gmst6 = new((/nm6,nens_all,nyr6/), "float")


TARG = "gmst" ;"nh-sh";"ASR_HD" ; "TNA" ; 
IND = "PDI2" ;"NPI"
;--------------MODEL---------------------------------

do im = 0,nm5-1

  ;from cmip_index_rs.ncl
  ; fils = systemfunc("ls "+diri+"cmip5/ASR_HD/cmip5_historical_"+MODEL5(im)+"_*_ASR_HD_1861-2004.nc") 
   file_name = diri+"cmip5/"+TARG+"/cmip5_historical_"+MODEL5(im)+"_r1i1p1_"+TARG+"_1861-2004.nc"
    exists = isfilepresent(file_name(0))
  if(.not.exists) then
    print(MODEL5(im)+" of "+TARG+" not exist")
    continue
  else
  fils = systemfunc("ls "+diri+"cmip5/"+TARG+"/cmip5_historical_"+MODEL5(im)+"_*_"+TARG+"_1861-2004.nc")
  f   = addfiles(fils, "r") 
  ListSetType (f, "join")   
  gmst50  = f[:]->gmst;index
  end if
  ; printVarSummary(gmst50)
  delete([/fils,f/])


  ;from pdv_cmip5_hist.ncl
  fils = systemfunc("ls "+diri+"cmip5/"+IND+"/cmip5_historical_"+MODEL5(im)+"_*_"+IND+"_1861-2004.nc")
  ; print(fils)
  f   = addfiles(fils, "r") 
  ListSetType (f, "join")   
  pc50  = f[:]->index;pc(:,0,:)
  ; printVarSummary(pc50)
  delete([/fils,f/])

  ;from gmst_index_cmip5.ncl
  ; fils = systemfunc("ls "+diri+"cmip5/gmst/cmip5_historical_"+MODEL5(im)+"_*_gmst_1861-2004.nc")
  ; fils = systemfunc("ls "+diri+"cmip5/nh-sh/cmip5_historical_"+MODEL5(im)+"_*_nh-sh_1861-2004.nc")
  ; fils = systemfunc("ls "+diri+"cmip5/TNA/cmip5_historical_"+MODEL5(im)+"_*_TNA_1861-2004.nc") 
  ; ; print(fils)
  ; f   = addfiles(fils, "r") 
  ; ListSetType (f, "join")   
  ; gmst50  = f[:]->gmst


  ndim = dimsizes(gmst50)
  if (dimsizes(ndim).eq.1) then 
     pc5(im,0,:) = month_to_annual(pc50(0,:), 1)
     gmst5(im,0,:) = dim_rmvmean_n_Wrap(month_to_annual(gmst50, 1), 0)
  else 
    do i = 0,ndim(0)-1
       pc5(im,i,:) = month_to_annual(pc50(i,:), 1)
       gmst5(im,i,:) = dim_rmvmean_n_Wrap(month_to_annual(gmst50(i,:), 1), 0)
    end do 
  end if 

   print(MODEL5(im)+" done")
   delete([/pc50, gmst50, ndim/])
end do 

do im = 0,nm6-1

  ;from cmip_index_rs.ncl
   file_name = diri+"cmip6/"+TARG+"/cmip6_historical_"+MODEL6(im)+"_r1i1p1f1_"+TARG+"_1850-2014.nc"
    exists = isfilepresent(file_name(0))
  if(.not.exists) then
    print(MODEL6(im)+" of "+TARG+" not exist")
    continue
  else
  fils = systemfunc("ls "+diri+"cmip6/"+TARG+"/cmip6_historical_"+MODEL6(im)+"_*_"+TARG+"_1850-2014.nc")
  f   = addfiles(fils, "r") 
  ListSetType (f, "join")   
  gmst60  = f[:]->gmst ;index
  end if
  ; printVarSummary(gmst60)
  delete([/fils,f/])

 ;from pdv_cmip6_hist.ncl
  fils = systemfunc("ls "+diri+"cmip6/"+IND+"/cmip6_historical_"+MODEL6(im)+"_*_"+IND+"_1850-2014.nc")
  ; print(fils)
  f   = addfiles(fils, "r") 
  ListSetType (f, "join")   
  pc60  = f[:]->index;pc(:,0,:)
  ; printVarSummary(pc60)
  delete([/fils,f/])

  ; ;from gmst_index_cmip6.ncl
  ; ; fils = systemfunc("ls "+diri+"cmip6/gmst/cmip6_historical_"+MODEL6(im)+"_*_gmst_1850-2014.nc")
  ; fils = systemfunc("ls "+diri+"cmip6/nh-sh/cmip6_historical_"+MODEL6(im)+"_*_nh-sh_1850-2014.nc")
  ;from cmip_index.ncl
  ; fils = systemfunc("ls "+diri+"cmip6/TNA/cmip6_historical_"+MODEL6(im)+"_*_TNA_1850-2014.nc") ;gmst
  ; ; print(fils)
  ; f   = addfiles(fils, "r") 
  ; ListSetType (f, "join")   
  ; gmst60  = f[:]->index


  ndim = dimsizes(gmst60)
  if (dimsizes(ndim).eq.1) then 
     pc6(im,0,:) = month_to_annual(pc60(0,:), 1)
     gmst6(im,0,:) = dim_rmvmean_n_Wrap(month_to_annual(gmst60, 1), 0)
  else 
    do i = 0,ndim(0)-1
       pc6(im,i,:) = month_to_annual(pc60(i,:), 1)
       gmst6(im,i,:) = dim_rmvmean_n_Wrap(month_to_annual(gmst60(i,:), 1), 0)
    end do 
  end if 
  
   print(MODEL6(im)+" with "+ndim(0)+"ens is done")
   delete([/pc60, gmst60, ndim/])
end do 

  printVarSummary(pc5)
  printVarSummary(pc6)
  printVarSummary(gmst5)
  printVarSummary(gmst6)

;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr+1)                            ; odd only
fca   = 1./fyr;*12)
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

gmst5 = wgt_runave_n_Wrap( gmst5, wgt,  0, 2 )   ;opt < 0 : utilize cyclic conditions 
gmst6 = wgt_runave_n_Wrap( gmst6, wgt,  0, 2 )   ;opt < 0 : utilize cyclic conditions 

;--------MME----------------------------------

  gmst5_avg = dim_avg_n_Wrap(gmst5, 1)
  pc5_avg = dim_avg_n_Wrap(pc5, 1)
  gmst6_avg = dim_avg_n_Wrap(gmst6, 1)
  pc6_avg = dim_avg_n_Wrap(pc6, 1)

  gmst5_mme = dim_avg_n_Wrap(gmst5_avg, 0)
  pc5_mme = dim_avg_n_Wrap(pc5_avg, 0);pc5,(/0,1/));
  gmst6_mme = dim_avg_n_Wrap(gmst6_avg, 0)
  pc6_mme = dim_avg_n_Wrap(pc6_avg, 0);pc6,(/0,1/));

  gmst5_yes = dim_avg_n_Wrap(gmst5_avg(i5y,:), 0)
  pc5_yes = dim_avg_n_Wrap(pc5_avg(i5y,:), 0);pc5(i5y,:,:),(/0,1/));
  gmst5_no = dim_avg_n_Wrap(gmst5_avg(i5n,:), 0)
  pc5_no = dim_avg_n_Wrap(pc5_avg(i5n,:), 0);pc5(i5n,:,:),(/0,1/));

  gmst5_le = dim_avg_n_Wrap(gmst5_avg(i5le,:), 0)
  pc5_le = dim_avg_n_Wrap(pc5_avg(i5le,:), 0)
  gmst6_le = dim_avg_n_Wrap(gmst6_avg(i6le,:), 0)
  pc6_le = dim_avg_n_Wrap(pc6_avg(i6le,:), 0)

  gmst5_esm = dim_avg_n_Wrap(gmst5_avg(i5esm,:), 0)
  pc5_esm = dim_avg_n_Wrap(pc5_avg(i5esm,:), 0)
  gmst5_cm = dim_avg_n_Wrap(gmst5_avg(i5cm,:), 0)
  pc5_cm = dim_avg_n_Wrap(pc5_avg(i5cm,:), 0)

  gmst6_esm = dim_avg_n_Wrap(gmst6_avg(i6esm,:), 0)
  pc6_esm = dim_avg_n_Wrap(pc6_avg(i6esm,:), 0)
  gmst6_cm = dim_avg_n_Wrap(gmst6_avg(i6cm,:), 0)
  pc6_cm = dim_avg_n_Wrap(pc6_avg(i6cm,:), 0)


printVarSummary(gmst5_mme)
printVarSummary(pc5_mme)
printVarSummary(pc6_mme)


;------------read global external forcing mode-----------
; from mme_eof_cmip6.ncl 

  f1   = addfile(diri+"cmip5/cmip5_historical_mme.eof_1861-2004.nc", "r") 
  meof5_mo  = f1->pc(0,:)
  f1   = addfile(diri+"cmip6/cmip6_historical_mme.eof_1850-2014.nc", "r") 
  meof6_mo  = f1->pc(0,:)

printVarSummary(meof5_mo)

meof5 = month_to_annual(meof5_mo, 1)
meof6 = month_to_annual(meof6_mo, 1)
printVarSummary(meof5)
printVarSummary(meof6)
;------------correlation---------------


;=========plot=========================
wks         = gsn_open_wks("png",diri0+"plot_cmip_scatter") 
plot = new(12, graphic)
plot2 = new(40, graphic)
plot3 = new(40, graphic)
plot4 = new(40, graphic)
text1 = new(12, graphic)
text2 = new(12, graphic)
text3 = new(12, graphic)


res = True
res@gsnFrame = False
res@gsnDraw  = False

res@xyMarkLineMode     = "Markers"  ; choose which have markers
; res@xyDashPatterns      = 1                      ; solid line 
  res@xyMarker         =  1                      ; choose type of marker  
  res@xyMarkerSizeF     = 0.01                     ; Marker size (default 0.01)
;   res@xyLineThicknesses   = (/1,2/)                ; set second line to 2

res@xyMarkerOpacityF = 1.0
  res@tmYROn                 = False    ; right off
;res@vpWidthF    = 0.5        ; Make plots wider
;res@vpHeightF   = 0.5
res@tmXTOn              = False   ; Turn off top tickmarks
res@tmYLMinorOn         = False   ; Turn off left minor tickmarks
res@tmXMajorGrid                = True
res@tmYMajorGrid                = True
res@tmXMajorGridThicknessF      = 1.0
res@tmYMajorGridThicknessF      = 1.0
res@tmXMajorGridLineDashPattern = 2
res@tmYMajorGridLineDashPattern = 2

res@gsnRightString = ""
res@gsnLeftString = ""
res@gsnLeftStringFontHeightF = 0.03
res@gsnRightStringFontHeightF = 0.03

res@xyMonoMarkerColor  = False ;True ;          ; Allow different colors for markers
 ; res@xyMonoDashPattern        = True              ; all solid 



;colors = read_colormap_file("default") ;("BkBlAqGrYeOrReViWh200");("default");("cosam");"GMT_paired"
  res@xyMarkLineMode     = "Markers"  ; choose which have markers
  ; res@xyMarker         =  9
 
  ; res@xyMarkerColors             = colors;ispan(1, nm+7, 1)

  res@gsnYRefLine = 0;avg(index_pro)
  res@gsnYRefLineThicknessF = 2.
  res@gsnYRefLineDashPattern = 1  
  res@gsnXRefLine = 0;avg(index_vwso)
  res@gsnXRefLineThicknessF = 2.
  res@gsnXRefLineDashPattern = 1  
  res@tiMainString             = ""


; res@trXMinF             = -0.4;8
; res@trXMaxF             =  0.4;8
; res@trYMinF             = -0.6
; res@trYMaxF             =  0.6

res@tiXAxisString = "external mode (EOF1)"; TARG ;"TNA" ;"NH-SH"
res@tiYAxisString = IND

X1 = meof5 ; gmst5_le
Y1 = pc5_mme
X2 = meof5 ; gmst5_esm  ;gmst5_mme
Y2 = pc5_yes  ;pc5_mme
X3 = meof5 ; gmst5_cm  ;gmst6_mme
Y3 = pc5_no  ;pc6_mme
X4 = meof5 ;
Y4 = pc5_esm
X5 = meof5 ; gmst6_le
Y5 = pc5_cm
X6 = meof6 ;
Y6 = pc6_mme 
X7 = meof6 ;
Y7 = pc6_esm  ;pc5_yes
X8 = meof6 ; gmst6_cm  ;gmst5_no
Y8 = pc6_cm  ;pc5_no

;start sectional scatter
yr_start = 1950 ; ys(im)

  cor1 = escorc(X1, Y1)
  cor2 = escorc(X2, Y2)
  cor3 = escorc(X3, Y3)
  cor4 = escorc(X4, Y4)
  cor5 = escorc(X5, Y5)
  cor6 = escorc(X6, Y6)
  cor7 = escorc(X7, Y7)
  cor8 = escorc(X8, Y8)
  cor1_2 = escorc(X1(yr_start - yrs5:), Y1(yr_start - yrs5:))
  cor2_2 = escorc(X2(yr_start - yrs5:), Y2(yr_start - yrs5:))
  cor3_2 = escorc(X3(yr_start - yrs5:), Y3(yr_start - yrs5:))
  cor4_2 = escorc(X4(yr_start - yrs5:), Y4(yr_start - yrs5:))
  cor5_2 = escorc(X5(yr_start - yrs5:), Y5(yr_start - yrs5:))
  cor6_2 = escorc(X6(yr_start - yrs6:), Y6(yr_start - yrs6:))
  cor7_2 = escorc(X7(yr_start - yrs6:), Y7(yr_start - yrs6:))
  cor8_2 = escorc(X8(yr_start - yrs6:), Y8(yr_start - yrs6:))
 
; ;normalize
; X1 = dim_standardize_n_Wrap(X1, 1, 0)
; Y1 = dim_standardize_n_Wrap(Y1, 1, 0)
; X =  dim_standardize_n_Wrap(X , 1, 1)
; Y =  dim_standardize_n_Wrap(Y , 1, 1)
; XM =  dim_standardize_n_Wrap(XM , 1, 0)
; YM =  dim_standardize_n_Wrap(YM , 1, 0)
; XP = dim_standardize_n_Wrap(XP, 1, 0)
; YP = dim_standardize_n_Wrap(YP, 1, 0)

res@xyMarkerColor = "black"
res@xyMarkerSizeF = 0.03

res@gsnLeftString = "CMIP5 MME"
res@gsnRightString = "R="+sprintf("%3.2f", cor1)+"("+sprintf("%3.2f", cor1_2)+")"
plot(0) = gsn_csm_xy(wks, X1 , Y1, res) 
res@gsnLeftString = "CMIP5 PLUS"
res@gsnRightString = "R="+sprintf("%3.2f", cor2)+"("+sprintf("%3.2f", cor2_2)+")"
plot(1) = gsn_csm_xy(wks, X2 , Y2,res) 
res@gsnLeftString = "CMIP5 MINUS" ;"CMIP5(plus)";indirect aerosol)"
res@gsnRightString = "R="+sprintf("%3.2f", cor3)+"("+sprintf("%3.2f", cor3_2)+")"
plot(2) = gsn_csm_xy(wks, X3 , Y3,res) 
res@gsnLeftString = "CMIP5 ESM" ;"CMIP5(minus)"; indirect aerosol)"
res@gsnRightString = "R="+sprintf("%3.2f", cor4)+"("+sprintf("%3.2f", cor4_2)+")"
plot(3) = gsn_csm_xy(wks, X4 , Y4,res) 
res@gsnLeftString = "CMIP5 CM"
res@gsnRightString = "R="+sprintf("%3.2f", cor5)+"("+sprintf("%3.2f", cor5_2)+")"
plot(4) = gsn_csm_xy(wks, X5 , Y5,res) 
res@gsnLeftString = "CMIP6 MME"
res@gsnRightString = "R="+sprintf("%3.2f", cor6)+"("+sprintf("%3.2f", cor6_2)+")"
plot(5) = gsn_csm_xy(wks, X6 , Y6,res) 
res@gsnLeftString = "CMIP6 ESM"
res@gsnRightString = "R="+sprintf("%3.2f", cor7)+"("+sprintf("%3.2f", cor7_2)+")"
plot(6) = gsn_csm_xy(wks, X7 , Y7,res) 
res@gsnLeftString = "CMIP6 CM"
res@gsnRightString = "R="+sprintf("%3.2f", cor8)+"("+sprintf("%3.2f", cor8_2)+")"
plot(7) = gsn_csm_xy(wks, X8 , Y8,res) 


res@gsnLeftString  = "" 
res@gsnRightString = ""

res@xyMarkerColor = "blue"
plota = gsn_csm_xy(wks, X1(yr_start - yrs5:) , Y1(yr_start - yrs5:),res) 
overlay(plot(0), plota)
plota = gsn_csm_xy(wks, X2(yr_start - yrs5:) , Y2(yr_start - yrs5:),res) 
overlay(plot(1), plota)
plota = gsn_csm_xy(wks, X3(yr_start - yrs5:) , Y3(yr_start - yrs5:),res) 
overlay(plot(2), plota)
plota = gsn_csm_xy(wks, X4(yr_start - yrs5:) , Y4(yr_start - yrs5:),res) 
overlay(plot(3), plota)
plota = gsn_csm_xy(wks, X5(yr_start - yrs5:) , Y5(yr_start - yrs5:),res) 
overlay(plot(4), plota)
plota = gsn_csm_xy(wks, X6(yr_start - yrs6:) , Y6(yr_start - yrs6:),res) 
overlay(plot(5), plota)
plota = gsn_csm_xy(wks, X7(yr_start - yrs6:) , Y7(yr_start - yrs6:),res) 
overlay(plot(6), plota)
plota = gsn_csm_xy(wks, X8(yr_start - yrs6:) , Y8(yr_start - yrs6:),res) 
overlay(plot(7), plota)


delete(res@trXMinF)
delete(res@trXMaxF)
delete(res@trYMinF)
delete(res@trYMaxF)


res@xyMarkerColor = "black"

do i = 0,dimsizes(MODEL5)-1
  res@gsnLeftString = MODEL5(i)
  res@gsnRightString = "R="+sprintf("%3.2f", escorc(gmst5_avg(i,:) , pc5_avg(i,:)))\
  +"("+sprintf("%3.2f", escorc(gmst5_avg(i,yr_start - yrs5:) , pc5_avg(i,yr_start - yrs5:)))+")" ;i5le(i) i6le(i)
  
  plot2(i) = gsn_csm_xy(wks, gmst5_avg(i,:) , pc5_avg(i,:), res) 
end do 

do i = 0,dimsizes(MODEL6_LE)-1
  res@gsnLeftString = MODEL6_LE(i)
  res@gsnRightString = "R="+sprintf("%3.2f", escorc(gmst6_avg(i,:) , pc6_avg(i,:)))\
  +"("+sprintf("%3.2f", escorc(gmst6_avg(i,yr_start - yrs6:) , pc6_avg(i,yr_start - yrs6:)))+")"
  
  plot3(i) = gsn_csm_xy(wks, gmst6_avg(i,:) , pc6_avg(i,:), res) 
end do 

res@gsnLeftString  = "" 
res@gsnRightString = ""
res@xyMarkerColor = "blue"

do i = 0,dimsizes(MODEL5)-1
  plota = gsn_csm_xy(wks, gmst5_avg(i,yr_start - yrs5:) , pc5_avg(i,yr_start - yrs5:), res) 
  overlay(plot2(i), plota)
end do 

do i = 0,dimsizes(MODEL6_LE)-1
  plota = gsn_csm_xy(wks, gmst6_avg(i,yr_start - yrs6:) , pc6_avg(i,yr_start - yrs6:), res) 
  overlay(plot3(i), plota)
end do 

;;regression line
res@gsnLeftString = ""
res@gsnRightString = ""
res@xyMarkLineMode = "Lines"
rco = regline (X1 , Y1)                  ; linear regression
yregro = rco*X1 + rco@yintercept                               ; regression
plot1 = gsn_csm_xy(wks, X1 , yregro,res) 
; overlay(plot(0), plot1)

rc = regline (ndtooned(X2), ndtooned(Y2))                  ; linear regression
yregr = rc*ndtooned(X2)+ rc@yintercept                               ; regression
plot1 = gsn_csm_xy(wks, ndtooned(X2), yregr,res) 
; overlay(plot(im), plot1)



;-------------------------------
;             XY 

  res2 = True
  res2@gsnDraw = False        ;dont draw
  res2@gsnFrame = False        ;dont advance frame
  res2@gsnLeftString = ""
  res2@gsnRightString = ""
  res2@vpHeightF = 0.3
  res2@vpWidthF  = 1.0
 
  res2@tmXTOn    = False
  res2@tmYROn    = False
  ;res2@gsnXYBarChart            = True              ; Create bar plot
  ;res2@gsnXYBarChartOutlineOnly = True


  res2@gsnYRefLine           = 0.0             ; reference line   
  ; res2@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  ; res2@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  ; res2@gsnLeftStringFontHeightF  = 0.03
  ; res2@gsnRightStringFontHeightF = 0.03

  x_axis5 = ispan(yrs5, yrl5, 1)
  x_axis6 = ispan(yrs6, yrl6, 1)
  ;res2@tmXBMode   = "Explicit"                                                
  ;res2@tmXBValues = x_axis;-1
  ;res2@tmXBLabels = model
  ;res2@tmXBLabelAngleF = 45.
  ;res2@tmXBLabelFontHeightF = 0.02
  res2@tiYAxisString = ""
  res2@tiXAxisString = "year"
  
  res2@xyMonoLineColor = False
  res2@xyMonoDashPattern = True

  res2@trYMinF               = -1.5
  res2@trYMaxF               =  1.5
  res2@trXMinF               = 1850
  res2@trXMaxF               = 2015

  ;MODEL
  res2@xyLineColor = "grey55"
  res2@xyLineThicknessF = 1.0
  res2@gsnLeftString = "CMIP5"
  res2@gsnRightString = IND
  plot4(0) = gsn_csm_xy (wks,x_axis5,pc5_avg,res2)
  res2@xyLineThicknessF = 3.0
  res2@xyLineColor = "red"
  plota  = gsn_csm_xy (wks,x_axis5,pc5_yes,res2)
  overlay(plot4(0), plota)
  res2@xyLineColor = "blue"
  plota  = gsn_csm_xy (wks,x_axis5,pc5_no,res2)
  overlay(plot4(0), plota)
  res2@xyLineColor = "black"
  plota  = gsn_csm_xy (wks,x_axis5,pc5_mme,res2)
  overlay(plot4(0), plota)


  res2@trYMinF               = -0.6
  res2@trYMaxF               =  1.0
  res2@xyLineColor = "grey55"
  res2@xyLineThicknessF = 1.0
  res2@gsnLeftString = "CMIP5"
  res2@gsnRightString = TARG ;"NH-SH"
  plot4(1) = gsn_csm_xy (wks,x_axis5,gmst5_avg,res2)
  res2@xyLineThicknessF = 3.0
  res2@xyLineColor = "red"
  plota  = gsn_csm_xy (wks,x_axis5,gmst5_yes,res2)
  overlay(plot4(1), plota)
  res2@xyLineColor = "blue"
  plota  = gsn_csm_xy (wks,x_axis5,gmst5_no,res2)
  overlay(plot4(1), plota)
  res2@xyLineColor = "black"
  plota  = gsn_csm_xy (wks,x_axis5,gmst5_mme,res2)
  overlay(plot4(1), plota)

  res2@trYMinF               = -1.5
  res2@trYMaxF               =  1.5
  res2@xyLineColor = "grey55"
  res2@xyLineThicknessF = 1.0
  res2@gsnLeftString = "CMIP6"
  res2@gsnRightString = IND
  plot4(2) = gsn_csm_xy (wks,x_axis6,pc6_avg,res2)
  res2@xyLineThicknessF = 3.0
  res2@xyLineColor = "black"
  plota  = gsn_csm_xy (wks,x_axis6,pc6_mme,res2)
  overlay(plot4(2), plota)
  res2@xyLineColor = "red"
  plota  = gsn_csm_xy (wks,x_axis6,pc6_esm,res2)
  overlay(plot4(2), plota)
  res2@xyLineColor = "blue"
  plota  = gsn_csm_xy (wks,x_axis6,pc6_cm,res2)
  overlay(plot4(2), plota)

  res2@trYMinF               = -0.6
  res2@trYMaxF               =  1.0
  res2@xyLineColor = "grey55"
  res2@xyLineThicknessF = 1.0
  res2@gsnLeftString = "CMIP6"
  res2@gsnRightString = TARG ;"NH-SH"
  plot4(3) = gsn_csm_xy (wks,x_axis6,gmst6_avg,res2)
  res2@xyLineThicknessF = 3.0
  res2@xyLineColor = "red"
  plota  = gsn_csm_xy (wks,x_axis6,gmst6_esm,res2)
  overlay(plot4(3), plota)
  res2@xyLineColor = "blue"
  plota  = gsn_csm_xy (wks,x_axis6,gmst6_cm,res2)
  overlay(plot4(3), plota)
  res2@xyLineColor = "black"
  plota  = gsn_csm_xy (wks,x_axis6,gmst6_mme,res2)
  overlay(plot4(3), plota)
;************************************************
; ; Attach text to plot using plot coordinates.
; ;************************************************
;   txres               = True                     ; text mods desired
;   txres@txFontHeightF = 0.03                     ; font smaller. default big

;   txres@txFontColor = "grey55"
;   text1(0)  = gsn_add_text(wks,plot(0),"R="+sprintf("%3.2f", coro),-2.0,3.2,txres) 
;   text1(im) = gsn_add_text(wks,plot(im),"R ="+sprintf("%3.2f", cor),-2.0,3.7,txres) 
;   txres@txFontColor = "red"
;   text2(im) = gsn_add_text(wks,plot(im),"R_m="+sprintf("%3.2f", corm),-2.0,3.2,txres) 
;   txres@txFontColor = "blue"
;   text3(im) = gsn_add_text(wks,plot(im),"R_pi="+sprintf("%3.2f", corp),-2.0,2.7,txres) 




      resk = True
      resk@txFontHeightF = 0.02
      resk@gsnMaximize = True
      resk@gsnPaperOrientation = "portrait"   ; force portrait

      resk@txString  = ""
      gsn_panel(wks,plot,(/2,4/),resk);

      resk@txString  = "CMIP5 LE"
      gsn_panel(wks,plot2,(/3,4/),resk);
      resk@txString  = "CMIP6 LE"
      gsn_panel(wks,plot3,(/4,4/),resk);
      resk@txString  = ""
      gsn_panel(wks,plot4,(/4,1/),resk);

; ;==============================================
; ;  attach plots
; ;=============================================
; delete(res2)
; res1 = True
; res2 = True
; res2@gsnAttachPlotsXAxis = True ; 是否以x轴为连接线
; res1@gsnAttachPlotsXAxis = True ; 是否以x轴为连接线
; ;res2@gsnMaximize = True
; res1@gsnPaperOrientation = "portrait"   ; force portrait
; res2@gsnAttachBorderOn = True ;False ; 图之间用线间隔
; res1@gsnAttachBorderOn = False

; ; newplot4 = gsn_attach_plots(plot1(1),(/plot1(3),plot1(5),plot1(7),plot1(9)/),res1,res2)
; newplot4 = gsn_attach_plots(plot4(0),(/plot4(2)/),res1,res2)
; newplot3 = gsn_attach_plots(plot4(1),(/plot4(3)/),res1,res2)


      gsn_panel(wks,(/plot4(0),plot4(2)/),(/2,1/),resk);
      gsn_panel(wks,(/plot4(1),plot4(3)/),(/2,1/),resk);


end 