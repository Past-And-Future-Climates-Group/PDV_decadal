begin

diri = "/Users/xingchen/Documents/project/PDV/data/" ;"/glade/work/chenxing/enso/"
dirip = "/Users/xingchen/Documents/project/PDV/pic/" ;"/glade/u/home/chenxing/enso/"

neof = 1

; ;CMIP5 MODELS
; MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;"bcc-csm1-1-m",
;       "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
;       "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
;       "GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
;       "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
;       "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\;"MRI-ESM1",
;       "NorESM1-ME","NorESM1-M"/)

; MODEL5_PLUS = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","HadGEM2-CC",\;,"GFDL-CM3"
;           "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM-CHEM","MIROC-ESM",\
;           "MRI-CGCM3","NorESM1-M",\
;             "FGOALS-g2","NorESM1-ME"/) ;explicitly have aerosol interaction included in CMIP5

; MODEL5_MINUS = (/"bcc-csm1-1","CCSM4","CESM1-FASTCHEM",\
;           "MPI-ESM-LR",\
;           "GFDL-CM2p1","CMCC-CESM","CMCC-CM","CMCC-CMS","FGOALS-s2","FIO-ESM","HadCM3","inmcm4",\
;           "MPI-ESM-MR","MPI-ESM-P"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

; nens5_plus = (/3,3,5,4,10,10,1,\
;              4,6,3,5,1,3,\
;              3,3,\
;              3,1/)

; nens5_minus = (/3,6,3,3,\
;                10,1,1,1,3,3,8,1,\
;                3,2/)

MODEL5_LE = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
             "IPSL-CM5A-LR", "CanESM2", "MIROC5","CESM1-CAM5","HadGEM2-ES",\
             "ACCESS1-0","ACCESS1-3","bcc-csm1-1","CESM1-FASTCHEM","FGOALS-g2",\
             "FGOALS-s2","FIO-ESM","IPSL-CM5A-MR","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M",\
             "BNU-ESM","CESM1-BGC","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
             "GFDL-ESM2G","GISS-E2-H-CC","HadGEM2-AO","HadGEM2-CC","inmcm4","IPSL-CM5A-LR",\
              "MIROC-ESM-CHEM","MPI-ESM-P","NorESM1-ME"/);"GFDL-CM3",
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
  "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",


MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
  "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",

nens6 = (/32,30,25,12,11, 10, 10,\;10,
          10,7,5,5 /) ;ensemble number 5,



MODEL6_ESM = (/"CanESM5","CESM2","E3SM-1-0",\
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0"/)
MODEL6_CM = (/"GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MIROC6","NorCPM1" /)

nens6_esm = (/25,11,5,7,10, 5/)
nens6_cm = (/12,10,32,10,30/)

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

  yrs = yrs5
  yrl = yrl5

MODEL = MODEL5_LE
nens = nens5

nmo = dimsizes(MODEL)

pc_all = new((/nmo,10,(yrl-yrs+1)*12/), "float")
com_pc = new((/nmo,(yrl-yrs+1)*12/), "float")
com_std = new((/nmo,(yrl-yrs+1)*12/), "float")
com_gmst = com_pc(:,::12)
com_g_std = com_pc(:,::12)
com_rt_pdv = com_pc(:,::12)
com_rt_gmst= com_pc(:,::12)

acu_pc =  new((/(yrl-yrs+1)*12/), "float")
acu_pc = 0. ;accumulated PC of each ensemble
nacu = 0 ;number of all ensembles

do im = 0,nmo-1
print("MODEL "+MODEL(im))

;---------read output---------------
;from lens_ipo.ncl
  fils = systemfunc("ls "+diri+"cmip5/pdv/cmip5_historical_"+MODEL(im)+"_r*_pdv_"+yrs+"-"+yrl+".nc")
  ; print(fils)
  f1   = addfiles(fils, "r")  ;multiple files
  ListSetType (f1, "join")        ; concatenate (=default)

  rc  = f1[:]->rc
  pc  = f1[:]->pc

  ndimf = dimsizes(fils)

  ;from gmst_index_cmip5.ncl
  fils = systemfunc("ls "+diri+"cmip5/gmst/cmip5_historical_"+MODEL(im)+"_*_gmst_1861-2004.nc")
  ; print(fils)
  f   = addfiles(fils, "r")
  ListSetType (f, "join")
  gmst0  = f[:]->gmst

  ;from roll_trend_cmip.ncl
  fils = systemfunc("ls "+diri+"cmip5/roll.trend/cmip5_historical_"+MODEL(im)+"_*_rt_pdv_1861-2004.nc")
  f   = addfiles(fils, "r")
  ListSetType (f, "join")
  rt_pdv  = f[:]->rt

  fils = systemfunc("ls "+diri+"cmip5/roll.trend/cmip5_historical_"+MODEL(im)+"_*_rt_gmst_1861-2004.nc")
  f   = addfiles(fils, "r")
  ListSetType (f, "join")
  rt_gmst  = f[:]->rt

  if(ndimf(0).ge.2) then
  gmst = gmst0(:,::12)
  ndim = dimsizes(gmst0)
    do i = 0,ndim(0)-1
       gmst(i,:) = month_to_annual(gmst0(i,:), 1)
    end do

  ndim1 = dimsizes(pc)
;;----------composite ensemble-----------------
pc_all(im,:ndim1(0)-1,:) = pc(:,0,:)
acu_pc = acu_pc + dim_sum_n_Wrap(pc(:,0,:), 0)
nacu = nacu + ndim1(0)

com_rc = dim_avg_n_Wrap(rc, 0)
com_pc(im,:) = dim_avg_n_Wrap(pc(:,0,:), 0)
com_gmst(im,:) = dim_avg_n_Wrap(gmst, 0)
com_std(im,:) = dim_stddev_n_Wrap(pc(:,0,:), 0)
com_g_std(im,:) = dim_stddev_n_Wrap(gmst, 0)

com_rt_pdv(im,:) = dim_avg_n_Wrap(rt_pdv, 0)
com_rt_gmst(im,:) = dim_avg_n_Wrap(rt_gmst, 0)

  else
    gmst = month_to_annual(gmst0, 1)
    com_pc(im,:) = pc(0,:)
    com_gmst(im,:) = gmst
    com_std(im,:) = pc(0,:)
    com_g_std(im,:) = gmst

    pc_all(im,0,:) = pc(0,:)
    acu_pc = acu_pc + pc(0,:)
    nacu = nacu + 1

  end if
  delete([/fils,rc,pc,gmst0,gmst,rt_pdv,rt_gmst/] )
end do
print(nacu)
printVarSummary(com_pc)
printVarSummary(com_gmst)

;MME
;ignore model bias
; ndimp = dimsizes(pc_all)
; aa = reshape(pc_all, (/ndimp(0)*ndimp(1),ndimp(2)/))
; cp_a = dim_avg_n_Wrap(aa, 0)
; delete([/aa/])
cp_a_2 = acu_pc / nacu

cp_a = dim_avg_n_Wrap(pc_all, (/0,1/))

; ;same weight
; cp_a = dim_avg_n_Wrap(com_pc, 0)

bb = pc_all(i5y,:,:)
ndima = dimsizes(bb)
aa = reshape(bb, (/ndima(0)*ndima(1),ndima(2)/))
cp_plus_a = dim_avg_n_Wrap(pc_all(i5y,:,:), (/0,1/));aa,0);com_pc(i5y,:), 0) ;plus group MME
delete([/aa,bb/])
bb = pc_all(i5n,:,:)
ndima = dimsizes(bb)
aa = reshape(bb, (/ndima(0)*ndima(1),ndima(2)/))
cp_minus_a = dim_avg_n_Wrap(pc_all(i5n,:,:), (/0,1/));aa,0);com_pc(i5n,:), 0) ;minus group MME
delete([/aa,bb/])
cg_a = dim_avg_n_Wrap(com_gmst, 0)
crt_p_a = dim_avg_n_Wrap(com_rt_pdv, 0)
crt_g_a = dim_avg_n_Wrap(com_rt_gmst, 0)

; ;1. averaged STD across ensembles
cs_a = dim_avg_n_Wrap(com_std, 0)
cs_plus_a = dim_avg_n_Wrap(com_std(i5y,:), 0) ;plus group STD
cs_minus_a = dim_avg_n_Wrap(com_std(i5n,:), 0) ;minus group STD
csg_a = dim_avg_n_Wrap(com_g_std, 0)
;2. STD across 8 model mean
; cs_a = dim_stddev_n_Wrap(com_pc, 0)
printVarSummary(crt_p_a)
printVarSummary(cp_a)
; ;--------output-------------
; fon=diri+"cmip6_historical_pdv_mme.nc";
; system("rm -f "+fon)
; fo=addfile(fon,"c")
; fo->com_pc = com_pc

;--------------plot-------------------

wks = gsn_open_wks("png", dirip+"cmip5_pdv_xy");
plot = new(10,graphic)                ; create graphic array
plot1 = new(nmo,graphic)                ; create graphic array

;*******************************************
; time series (principal component) plot
;*******************************************

  gsn_define_colormap(wks,"MPL_gist_rainbow")
  colors = ispan(2, 125, 5)   ; indices into color table
  colors1 = ispan(2, 60, 4)   ; indices into color table
  colors2 = ispan(70, 125, 5)   ; indices into color table


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

  ndim  = dimsizes(com_pc)
  x_axis2 = fspan(yrs, yrl, ndim(1))
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

  res@trYMinF               = -1.5
  res@trYMaxF               =  1.5

print("COR="+escorc(crt_g_a, crt_p_a))
print("COR="+escorc(cg_a, month_to_annual(cp_a,1)))

;MODEL
res@xyLineThicknessF = 1.0
res@gsnLeftString = "PDV"; 15yr rolling trend"
res@gsnRightString = com_pc@units
  res@xyLineColors = colors1
plot(0) = gsn_csm_xy (wks,x_axis2, com_pc(i5y,:) ,res) ;x_axis2, com_pc

delete(res@xyLineColors)
; res@xyDashPattern = 2
  res@xyLineColors = colors2
plota = gsn_csm_xy (wks,x_axis2, com_pc(i5n,:) ,res) ;x_axis2, com_pc
overlay(plot(0), plota)

; delete(res@xyDashPattern)

  res@trYMinF               = -0.5
res@gsnLeftString = "GMST"; 15yr rolling trend"
plot(1) = gsn_csm_xy (wks,x_axis1,com_gmst,res);com_gmst ;com_rt_gmst

delete(res@xyLineColors)
res@xyLineThicknessF = 5.0
res@xyLineColors = "black"

res@gsnLeftString = ""
plota = gsn_csm_xy (wks,x_axis1,cg_a,res) ;cg_a ;crt_g_a
overlay(plot(1), plota)

;ESM MME
res@trYMinF               = -1.5
res@xyLineColors = "red"
plota = gsn_csm_xy (wks,x_axis2,cp_plus_a,res) ;x_axis2, cp_a ;cp_plus_a
overlay(plot(0), plota)

;CM MME
; res@xyDashPattern = 2
res@xyLineColors = "blue"
plota = gsn_csm_xy (wks,x_axis2,cp_minus_a,res) ;x_axis2, cp_a ;cp_minus_a
overlay(plot(0), plota)

do im = 0,nmo-1
  res@gsnLeftString = MODEL5_LE(im)+" ("+nens5(im)+")"
  plot1(im) = gsn_csm_xy (wks,x_axis2,com_pc(im,:),res)
end do
res@gsnLeftString = ""

;---------shading of STD---------

  ; delete(res@xyDashPattern)
  delete(res@xyLineColors)
  res@xyLineColor     = -1                           ; We don't want the line, so make it trax_axisparent.
  mmz = com_pc(0:1,:)

  ;ESM STD shading
  mmz(0,:) = cp_plus_a+cs_plus_a ;cp_a-cs_a
  mmz(1,:) = cp_plus_a-cs_plus_a ;cp_a+cs_a

  res@gsnXYFillOpacities = 0.3
  res@gsnXYFillColors = "lightpink" ;"lightskyblue1"; "grey55"
  res@xyCurveDrawOrder = "PreDraw"
  plota  = gsn_csm_xy (wks,(/x_axis2/),mmz(0:1,:),res)  ; Create filled XY plot.
  overlay(plot(0), plota)

  ;CM STD shading
  mmz(0,:) = cp_minus_a+cs_minus_a ;cp_a-cs_a
  mmz(1,:) = cp_minus_a-cs_minus_a ;cp_a+cs_a

  res@gsnXYFillColors = "lightskyblue1"; "grey55"
  plota  = gsn_csm_xy (wks,(/x_axis2/),mmz(0:1,:),res)  ; Create filled XY plot.
  overlay(plot(0), plota)

  res@xyLineThicknessF = 2.0




; ;;legend
;   gres = True
;   gres@YPosPercent = 95.    ; expressed as %, 0->100, sets position of top border of legend
;                             ;  when gres@Position is set to its default setting of "Top" (Default = 95.)
;   gres@XPosPercent = 5      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)

;   lineres = True
;   lineres@lgLineColors = (/"black","blue"/) ; line colors
;   lineres@lgLineThicknesses = 2.5                        ; line thicknesses
;   lineres@LineLengthPercent = 9.                         ; expressed as %, 0->100, length of line

;   textres = True
;   textres@lgLabels = (/"PDV","TPDV"/)  ; legend labels (required)

  ; plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)
  ; plot(3) = simple_legend(wks,plot(3),gres,lineres,textres)

;---------------------------------
; Set up resources for a customized legend.
;
  lgres                    = True
  lgres@lgLineThicknessF   = 2.0
  lgres@lgItemType         = "Lines"        ; show lines only (default)
  lgres@lgLabelFontHeightF = .1            ; legend label font thickness
  lgres@vpWidthF           = 0.20           ; width of legend (NDC)
  lgres@vpHeightF          = 0.30           ; height of legend (NDC)
  ; lgres@lgPerimThicknessF  = 2.0            ; thicken the box perimeter
  lgres@lgPerimOn          = False
 ; lgres@lgPerimFill = 0
 ; lgres@lgPerimFillColor = 0
  lgres@lgPerimFill            = "SolidFill"      ; Fill legend box w/white
  lgres@lgPerimFillColor       = "white"          ; so it masks XY curves

  lgres@lgMonoDashIndex = True
  lgres@lgDashIndexes = 0;(/0,0,0,0,0,0,0,0/)
  lgres@lgLineColors       = colors1;(::-1)
  labels1 = MODEL5_PLUS+"("+nens5_plus+")"
  nitems1 = dimsizes(labels1)                 ; number of legend items

  lbid1 = gsn_create_legend(wks,nitems1,labels1,lgres)

  delete(lgres@lgLineColors)
  lgres@lgLineColors       = colors2;(::-1)
  lgres@lgDashIndexes = 2; (/2,2,2,2,2,2,2,2/)
  labels2 = MODEL5_MINUS+"("+nens5_minus+")"
  nitems2 = dimsizes(labels2)                 ; number of legend items

  lbid2 = gsn_create_legend(wks,nitems2,labels2,lgres)

; Use gsn_add_annotation to attach this legend to our existing plot.
; This way, if we resize the plot, the legend will stay with the
; plot and be resized automatically.
;
  amres                  = True

  amres@amJust           = "BottomLeft"    ; Use bottom right corner of box
                                            ; for determining its location.
  amres@amParallelPosF   =  0.5              ; Move legend to right
  amres@amOrthogonalPosF =  0.5              ; Move legend down.

  annoid1 = gsn_add_annotation(plot(0),lbid1,amres)  ; add legend to plot
  amres@amParallelPosF   =  0.8              ; Move legend to right
  amres@amOrthogonalPosF =  0.5              ; Move legend down.
  annoid2 = gsn_add_annotation(plot(0),lbid2,amres)  ; add legend to plot

;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@txString = "CMIP5 models with >=3 ens"

gsn_panel(wks,plot,(/2,1/),resk)
gsn_panel(wks,plot1,(/6,3/),resk)

end
