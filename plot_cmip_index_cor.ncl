load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
neof = 1

  yrs = 1950;1861
  yrl = 2004
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/tas/"
SEASON = (/"DJF","MAM","JJA","SON" /)

MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1-m","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\
      "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5-2","CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1","GFDL-CM3",\
      "GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H-CC","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R","HadCM3","HadGEM2-AO",\
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
      "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3","MRI-ESM1",\
      "NorESM1-ME","NorESM1-M"/)

M5_YES = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","HadGEM2-CC",\;,"GFDL-CM3"
          "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM-CHEM","MIROC-ESM",\
          "MRI-CGCM3","NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

M5_NO = (/"bcc-csm1-1","BNU-ESM","CCSM4","CESM1-BGC","CESM1-FASTCHEM","CESM1-WACCM",\
          "GFDL-ESM2G","MPI-ESM-LR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

MODEL5_LE = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
             "IPSL-CM5A-LR", "CanESM2", "MIROC5"/);"GFDL-CM3",
nens5 = (/10,10,10,8,6,6,6,\
         6,5,5,5 /)

MODEL6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
        "CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
        "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",

MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
  "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",
nens6 = (/32,30,25,12,11, 10, 10,\;10,
          10,7,5,5 /) ;ensemble number 5,


nm5 = dimsizes(MODEL5)

i5y = new(dimsizes(M5_YES), "integer")
do i = 0,dimsizes(M5_YES)-1
  i5y(i) = ind(MODEL5.eq.M5_YES(i))
end do 
i5n = new(dimsizes(M5_NO), "integer")
do i = 0,dimsizes(M5_NO)-1
  i5n(i) = ind(MODEL5.eq.M5_NO(i))
end do 
i5le = new(dimsizes(MODEL5_LE), "integer")
do i = 0,dimsizes(MODEL5_LE)-1
  i5le(i) = ind(MODEL5.eq.MODEL5_LE(i))
end do 

mxlag = 20*12

;;;================================================
;;;;CMIP5
;;;================================================
nens_all = 10

; note, the max lag should not be more than N/4
acr5 = new((/nm5, mxlag+1 /), "float") ;cross correlation pattern

do im = 0,nm5-1

;from pdv_cmip5_hist.ncl
;cmip5_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
locs = systemfunc("ls "+diri+"cmip5/tas.pdv/cmip5_historical_"+MODEL5(im)+"_*_pdv_*.nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

  aa = new((/nens_all, mxlag+1 /), "float") 

do ia = 0,nsa-1
  
 locs_str = str_split(locs(ia), "_"); "/")
 ; print("'" + locs_str + "'")
  ENSN  = locs_str(3)

  print(MODEL5(im)+" ens "+ENSN)
  ;---------read output---------------
  ;from pdv_cmip5_hist.ncl
  f1   = addfile(diri+"cmip5/tas.pdv/cmip5_historical_"+MODEL5(im)+"_"+ENSN+"_pdv_1861-2004.nc", "r") 
  pc  = f1->pc(0,:);(yrs-1861)*12:)
  
  pc_annual = month_to_annual(pc, 1)
  pc_sea = month_to_seasonN(pc, SEASON)
  pc_sea2 = ndtooned(pc_sea)
  pc_sea2!0 = "time"
  delete([/pc_sea /])
  
  ;************************************************
  ; calculate auto correlations
  ;************************************************

  ;self-correlation
  aa(ia,:)   = esacr(pc,mxlag) 

  
delete([/locs_str/])
end do 

;ensemble mean
acr5(im,:) = dim_avg_n_Wrap(aa, 0)
acr5!0 = "model"
acr5!1 = "time"

delete([/aa,pc,pc_sea2,locs,pc_annual/])

end do 

;;;================================================
;;;;CMIP6
;;;================================================

nm6 = dimsizes(MODEL6)
nens_all = 32

acr6 = new((/nm6, mxlag+1 /), "float") ;cross correlation pattern

do im = 0,nm6-1

;from pdv_cmip6_hist.ncl
;cmip6_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
locs = systemfunc("ls "+diri+"cmip6/ts.pdv/cmip6_historical_"+MODEL6(im)+"_*_pdv_*.nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

  aa = new((/nens_all, mxlag+1 /), "float") 

do ia = 0,nsa-1
  
 locs_str = str_split(locs(ia), "_"); "/")
 ; print("'" + locs_str + "'")
  ENSN  = locs_str(3)

  print(MODEL6(im)+" ens "+ENSN)

  ;---------read output---------------
  ;from pdv_cmip6_hist.ncl
  f1   = addfile(diri+"cmip6/ts.pdv/cmip6_historical_"+MODEL6(im)+"_"+ENSN+"_pdv_1850-2014.nc", "r") 
  pc  = f1->pc(0,:);(yrs-1850)*12:(yrl+1-1850)*12-1)
  
  pc_annual = month_to_annual(pc, 1)
  pc_sea = month_to_seasonN(pc, SEASON)
  pc_sea2 = ndtooned(pc_sea)
  pc_sea2!0 = "time"
  delete([/pc_sea /])
  
  ;************************************************
  ; calculate cross correlations
  ;************************************************

  aa(ia,:)   = esacr(pc,mxlag) 
  
delete([/locs_str/])
end do 

;ensemble mean
acr6(im,:) = dim_avg_n_Wrap(aa, 0)
acr6!0 = "model"
acr6!1 = "time"

delete([/aa,pc,pc_sea2,locs,pc_annual/])

end do 

acr5_avg = dim_avg_n_Wrap(acr5(model|i5n,time|:), 0)
acr6_avg = dim_avg_n_Wrap(acr6(model|:,time|:), 0)

printVarSummary(acr5_avg)


;;;;==========plot===================================================
wks = gsn_open_wks("ps", dirip+"cmip_autocor");
plot = new(30,graphic)                ; create graphic array

  x_axis = ispan(0, mxlag, 1)
  x_axis2 = ispan(-mxlag, mxlag, 1)
  printVarSummary(x_axis2)

  res                    = True              ; plot mods desired
  res@gsnDraw            = False             ; don't draw yet
  res@gsnFrame           = False             ; don't advance frame yet
  res@gsnPaperOrientation = "portrait"   ; force portrait
  res@vpWidthF  = 0.7
  res@vpHeightF = 0.3
  res@tmXTOn              = False   ; Turn off top tickmarks
  res@tmYLMinorOn         = False   ; Turn off left minor tickmarks
  res@tmYROn              = False

  res@gsnYRefLine = 0
  res@gsnXRefLine = 0


  ; res@gsnRightString = "auto correlation"
  ; plot(2) = gsn_csm_xy(wks,x_axis2,acr,res)   ;

  ; res@trYMaxF   =  2.0 
  ; res@trYMinF   = -2.0 
  ; res@trXMinF = -13;half_p
  ; res@trXMaxF =  13;half_p
  res@tmXBMode     = "Explicit"        
  res@tmXBValues   = x_axis2(::5*12)   
  res@tmXBLabels   = ispan(-mxlag/12,mxlag/12, 5)
  ; res@tmXBMinorValues = ispan(f_yrs,f_yrl+1,1)



; ; Set special resources for the time axis
;   resTick                = True
;   resTick@ttmFormat      = "%Y"
;   resTick@ttmAxis        = "XB" ;
;   resTick@ttmMajorStride = 10*12

;   time_axis_labels( nino_e3sm&time,  res, resTick )

res@trYMinF = -0.4
res@trYMaxF =  0.6

res@tiXAxisString = "year"

  res@xyLineThicknessF = 1.0 
  res@xyLineColor = "lightblue3"
  res@gsnRightString = "PC lead CP index"
  res@gsnLeftString = "CP lead PC"
  res@tiYAxisString  = "Cor"

  res@xyLineThicknessF = 4.0
  res@xyLineColor = "blue"


res@trYMinF = -1.0
res@trYMaxF =  1.0

  res@gsnLeftString = ""
  res@gsnRightString = "Self correlation"
  plota = gsn_csm_xy(wks, x_axis, acr5_avg, res)
  plotb = gsn_csm_xy(wks, x_axis, acr6_avg, res)
  res@xyLineThicknessF = 1.0 
  res@xyLineColor = "lightblue3"
  res@gsnCenterString = "CMIP5(no)"
  plot(0) = gsn_csm_xy(wks,x_axis,acr5(model|:,time|:),res)   ;
  overlay(plot(0), plota)
  res@gsnCenterString = "CMIP6"
  plot(1) = gsn_csm_xy(wks,x_axis,acr6(model|:,time|:),res)   ;
  overlay(plot(1), plotb)

      resk = True
      resk@txFontHeightF = 0.02
      resk@gsnMaximize = True
      resk@gsnPaperOrientation = "portrait"   ; force portrait

      resk@txString  = ""
      gsn_panel(wks,plot,(/2,1/),resk);


end 