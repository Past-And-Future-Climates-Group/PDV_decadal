load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
begin

diri = "/glade/work/chenxing/enso/"
diri0 = "/glade/u/home/chenxing/enso/"

SEASON = (/"DJF","MAM","JJA","SON" /)

EXP5 = "rcp45"
EXP6 = "ssp370"

MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;"bcc-csm1-1-m",
      "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
      "GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
      "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\;"MRI-ESM1",
      "NorESM1-ME","NorESM1-M"/)

M5_YES = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","HadGEM2-CC",\;,"GFDL-CM3"
          "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM-CHEM","MIROC-ESM",\
          "MRI-CGCM3","NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

M5_NO = (/"bcc-csm1-1","BNU-ESM","CCSM4","CESM1-BGC","CESM1-FASTCHEM","CESM1-WACCM",\
          "GFDL-ESM2G","MPI-ESM-LR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

MODEL5_LE = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
             "IPSL-CM5A-LR", "CanESM2", "MIROC5"/);"GFDL-CM3",
nens5 = (/10,10,10,8,6,6,6,\
         6,5,5 /);5,

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

yrs5 = 2006
yrl5 = 2095
nyr5 = yrl5 - yrs5 +1
yrs6 = 2015
yrl6 = 2099
nyr6 = yrl6 - yrs6 +1

nens_all = 32
pc5 = new((/nm5,nens_all,nyr5/), "float")
pc6 = new((/nm6,nens_all,nyr6/), "float")
gmst5 = new((/nm5,nens_all,nyr5/), "float")
gmst6 = new((/nm6,nens_all,nyr6/), "float")

;--------------MODEL---------------------------------

do im = 0,nm5-1

  ;from pdv_cmip5_hist.ncl
  exists = isfilepresent(diri+"cmip5/tas.pdv/cmip5_"+EXP5+"_"+MODEL5(im)+"_r1i1p1_pdv_"+yrs5+"-"+yrl5+".nc")
  if(.not.exists) then
    print(MODEL5(im)+" not exist")
    print("Either the file doesn't exist, or NCL does")
    print("not have OPeNDAP cabilities on this system.")
    continue
  end if

  fils = systemfunc("ls "+diri+"cmip5/tas.pdv/cmip5_"+EXP5+"_"+MODEL5(im)+"_*_pdv_"+yrs5+"-"+yrl5+".nc")
  f   = addfiles(fils, "r") 
  ListSetType (f, "join")   
  pc50  = f[:]->pc(:,0,:)
  ; printVarSummary(pc50)

  ;from gmst_index_cmip5.ncl
  ; fils = systemfunc("ls "+diri+"cmip5/gmst/cmip5_"+EXP5+"_"+MODEL5(im)+"_*_gmst_"+yrs5+"-"+yrl5+".nc")
  fils = systemfunc("ls "+diri+"cmip5/nh-sh/cmip5_"+EXP5+"_"+MODEL5(im)+"_*_nh-sh_"+yrs5+"-"+yrl5+".nc")
  ; fils = systemfunc("ls "+diri+"cmip5/TNA/cmip5_"+EXP5+"_"+MODEL5(im)+"_*_TNA_"+yrs5+"-"+yrl5+".nc") 
  ; print(fils)
  f   = addfiles(fils, "r") 
  ListSetType (f, "join")   
  gmst50  = f[:]->gmst
  gmst50 = dtrend(gmst50, True)
  delete([/fils,f/])

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

  exists = isfilepresent(diri+"cmip6/tas.pdv/cmip6_"+EXP6+"_"+MODEL6(im)+"_r1i1p1f1_pdv_"+yrs6+"-"+yrl6+".nc")
  if(.not.exists) then
    print(MODEL6(im)+" not exist")
    print("Either the file doesn't exist, or NCL does")
    print("not have OPeNDAP cabilities on this system.")
    continue
  end if

 ;from pdv_cmip6_hist.ncl
  fils = systemfunc("ls "+diri+"cmip6/tas.pdv/cmip6_"+EXP6+"_"+MODEL6(im)+"_*_pdv_"+yrs6+"-"+yrl6+".nc")
  f   = addfiles(fils, "r") 
  ListSetType (f, "join")   
  pc60  = f[:]->pc(:,0,:)
  ; printVarSummary(pc60)
  delete([/fils,f/])

  ; ;from gmst_index_cmip6.ncl
  ; ; fils = systemfunc("ls "+diri+"cmip6/gmst/cmip6_"+EXP6+"_"+MODEL6(im)+"_*_gmst_"+yrs6+"-"+yrl6+".nc")
  fils = systemfunc("ls "+diri+"cmip6/nh-sh/cmip6_"+EXP6+"_"+MODEL6(im)+"_*_nh-sh_"+yrs6+"-"+yrl6+".nc")
  ;from cmip_index.ncl
  ; fils = systemfunc("ls "+diri+"cmip6/TNA/cmip6_"+EXP6+"_"+MODEL6(im)+"_*_TNA_"+yrs6+"-"+yrl6+".nc") 
  ; print(fils)
  f   = addfiles(fils, "r") 
  ListSetType (f, "join")   
  gmst60  = f[:]->gmst
  gmst60 = dtrend(gmst60, True)
  ; printVarSummary(gmst60)
  delete([/fils,f/])

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

  gmst5_avg = dim_avg_n_Wrap(gmst5, 1)
  pc5_avg = dim_avg_n_Wrap(pc5, 1)
  gmst6_avg = dim_avg_n_Wrap(gmst6, 1)
  pc6_avg = dim_avg_n_Wrap(pc6, 1)

  gmst5_mme = dim_avg_n_Wrap(gmst5_avg, 0)
  pc5_mme = dim_avg_n_Wrap(pc5_avg, 0)
  gmst6_mme = dim_avg_n_Wrap(gmst6_avg, 0)
  pc6_mme = dim_avg_n_Wrap(pc6_avg, 0)

  gmst5_yes = dim_avg_n_Wrap(gmst5_avg(i5y,:), 0)
  pc5_yes = dim_avg_n_Wrap(pc5_avg(i5y,:), 0)
  gmst5_no = dim_avg_n_Wrap(gmst5_avg(i5n,:), 0)
  pc5_no = dim_avg_n_Wrap(pc5_avg(i5n,:), 0)

  gmst5_le = dim_avg_n_Wrap(gmst5_avg(i5le,:), 0)
  pc5_le = dim_avg_n_Wrap(pc5_avg(i5le,:), 0)
  gmst6_le = dim_avg_n_Wrap(gmst5_avg(i6le,:), 0)
  pc6_le = dim_avg_n_Wrap(pc5_avg(i6le,:), 0)

print(pc5_avg(:,0))

; ;------------filter----------------------
; fyr   = 8.
; ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
; sigma = 1.0                           ; Lanczos sigma
; nWgt  = toint(fyr+1)                            ; odd only
; fca   = 1./fyr;*12)
; fcb   = -999.
; wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

; mxi_ft = wgt_runave_n_Wrap( mxi_sea, wgt,  -1, 0 )   ;opt < 0 : utilize cyclic conditions 
; ; print(ind(ndtooned(.not.ismissing(mxi_ft))))
; print(MODEL(im)+"")
;=========plot=========================
wks         = gsn_open_wks("ps",diri0+"plot_cmip_rcp_scatter") 
plot = new(12, graphic)
plot2 = new(20, graphic)
plot3 = new(20, graphic)
plot4 = new(20, graphic)
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

res@tiXAxisString = "NH-SH"
res@tiYAxisString = "PDV"

X1 = gmst5_mme
Y1 = pc5_mme
X2 = gmst6_mme
Y2 = pc6_mme
X3 = gmst5_yes
Y3 = pc5_yes
X4 = gmst5_no
Y4 = pc5_no
X5 = gmst5_le
Y5 = pc5_le
X6 = gmst6_le
Y6 = pc6_le

;start sectional scatter
yr_start = 1950 ; ys(im)

  cor1 = escorc(X1, Y1)
  cor2 = escorc(X2, Y2)
  cor3 = escorc(X3, Y3)
  cor4 = escorc(X4, Y4)
  cor5 = escorc(X5, Y5)
  cor6 = escorc(X6, Y6)
 
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

res@gsnLeftString = "CMIP5"
res@gsnRightString = "R="+sprintf("%3.2f", cor1)
plot(0) = gsn_csm_xy(wks, X1 , Y1, res) 
res@gsnLeftString = "CMIP6"
res@gsnRightString = "R="+sprintf("%3.2f", cor2)
plot(1) = gsn_csm_xy(wks, X2 , Y2,res) 
res@gsnLeftString = "CMIP5(plus)";indirect aerosol)"
res@gsnRightString = "R="+sprintf("%3.2f", cor3)
plot(2) = gsn_csm_xy(wks, X3 , Y3,res) 
res@gsnLeftString = "CMIP5(minus)"; indirect aerosol)"
res@gsnRightString = "R="+sprintf("%3.2f", cor4)
plot(3) = gsn_csm_xy(wks, X4 , Y4,res) 
; res@gsnLeftString = "CMIP5(le)"
; res@gsnRightString = "R="+sprintf("%3.2f", cor5)
; plot(4) = gsn_csm_xy(wks, X5 , Y5,res) 
; res@gsnLeftString = "CMIP6(le)"
; res@gsnRightString = "R="+sprintf("%3.2f", cor6)
; plot(5) = gsn_csm_xy(wks, X6 , Y6,res) 


res@gsnLeftString  = "" 
res@gsnRightString = ""

; res@xyMarkerColor = "blue"
; plota = gsn_csm_xy(wks, X1(yr_start - yrs5:) , Y1(yr_start - yrs5:),res) 
; overlay(plot(0), plota)
; plota = gsn_csm_xy(wks, X2(yr_start - yrs6:) , Y2(yr_start - yrs6:),res) 
; overlay(plot(1), plota)
; plota = gsn_csm_xy(wks, X3(yr_start - yrs5:) , Y3(yr_start - yrs5:),res) 
; overlay(plot(2), plota)
; plota = gsn_csm_xy(wks, X4(yr_start - yrs5:) , Y4(yr_start - yrs5:),res) 
; overlay(plot(3), plota)


delete(res@trXMinF)
delete(res@trXMaxF)
delete(res@trYMinF)
delete(res@trYMaxF)


res@xyMarkerColor = "black"

do i = 0,dimsizes(MODEL5_LE)-1
  res@gsnLeftString = MODEL5_LE(i)
  res@gsnRightString = "R="+sprintf("%3.2f", escorc(gmst5_avg(i5le(i),:) , pc5_avg(i5le(i),:)));\
  ; +"("+sprintf("%3.2f", escorc(gmst5_avg(i5le(i),yr_start - yrs5:) , pc5_avg(i5le(i),yr_start - yrs5:)))+")"
  
  plot2(i) = gsn_csm_xy(wks, gmst5_avg(i5le(i),:) , pc5_avg(i5le(i),:), res) 
end do 

do i = 0,dimsizes(MODEL6_LE)-1
  res@gsnLeftString = MODEL6_LE(i)
  res@gsnRightString = "R="+sprintf("%3.2f", escorc(gmst6_avg(i6le(i),:) , pc6_avg(i6le(i),:)));\
  ; +"("+sprintf("%3.2f", escorc(gmst6_avg(i6le(i),yr_start - yrs6:) , pc6_avg(i6le(i),yr_start - yrs6:)))+")"
  
  plot3(i) = gsn_csm_xy(wks, gmst6_avg(i6le(i),:) , pc6_avg(i6le(i),:), res) 
end do 

res@gsnLeftString  = "" 
res@gsnRightString = ""
res@xyMarkerColor = "blue"

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

  res2@trYMinF               = -2.0
  res2@trYMaxF               =  2.0
  res2@trXMinF               = 2006
  res2@trXMaxF               = 2099

  ;MODEL
  res2@xyLineColor = "grey55"
  res2@xyLineThicknessF = 1.0
  res2@gsnLeftString = "CMIP5"
  res2@gsnRightString = "PDV"
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


  ; res2@trYMinF               = -0.6
  ; res2@trYMaxF               =  0.6
  res2@xyLineColor = "grey55"
  res2@xyLineThicknessF = 1.0
  res2@gsnLeftString = "CMIP5"
  res2@gsnRightString = "NH-SH"
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

  ; res2@trYMinF               = -0.6
  ; res2@trYMaxF               =  0.6
  res2@xyLineColor = "grey55"
  res2@xyLineThicknessF = 1.0
  res2@gsnLeftString = "CMIP6"
  res2@gsnRightString = "NH-SH"
  plot4(3) = gsn_csm_xy (wks,x_axis6,gmst6_avg,res2)
  res2@xyLineThicknessF = 2.0
  res2@xyLineColor = "black"
  plota  = gsn_csm_xy (wks,x_axis6,gmst6_mme,res2)
  overlay(plot4(3), plota)

  ; res2@trYMinF               = -2.0
  ; res2@trYMaxF               =  2.0
  res2@xyLineColor = "grey55"
  res2@xyLineThicknessF = 1.0
  res2@gsnLeftString = "CMIP6"
  res2@gsnRightString = "PDV"
  plot4(2) = gsn_csm_xy (wks,x_axis6,pc6_avg,res2)
  res2@xyLineThicknessF = 2.0
  res2@xyLineColor = "black"
  plota  = gsn_csm_xy (wks,x_axis6,pc6_mme,res2)
  overlay(plot4(2), plota)

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

      resk@txString  = "future senario"
      gsn_panel(wks,plot,(/2,2/),resk);

      resk@txString  = "CMIP5 LE"
      gsn_panel(wks,plot2,(/3,4/),resk);
      resk@txString  = "CMIP6 LE"
      gsn_panel(wks,plot3,(/4,4/),resk);
      resk@txString  = ""
      gsn_panel(wks,plot4,(/4,1/),resk);


end 