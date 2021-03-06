; load "./function_bootstrap_mme.ncl"
load "/Users/xingchen/Documents/project/ENSO/program/function_bootstrap_mme.ncl"
begin

diri = "/Users/xingchen/Documents/project/ENSO/data/" ;"/glade/work/chenxing/enso/";
dirip = "/Users/xingchen/Documents/project/ENSO/pic/" ;"/glade/u/home/chenxing/enso/";

; ;CMIP5 MODELS
; MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1-m","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;
;       "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
;       "CNRM-CM5","CNRM-CM5-2","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1","GFDL-CM3",\;
;       "GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H-CC","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R","HadCM3","HadGEM2-AO",\;
;       "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
;       "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3","MRI-ESM1",\;
;       "NorESM1-ME","NorESM1-M"/)


; ; CMIP6 MODELS
; MODEL6 = (/"BCC-CSM2-MR","BCC-ESM1","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5",
;         "CESM2","CESM2-WACCM-FV2",\
;         "CESM2-WACCM","E3SM-1-0","FGOALS-g3","FIO-ESM-2-0","GFDL-CM4","GFDL-ESM4",\;"E3SM-1-1","FGOALS-f3-L",
;         "GISS-E2-1-G","GISS-E2-1-H","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC",
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NESM3","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM",


;include all model even its ens is 1
MODEL5_PLUS = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2", "HadGEM2-CC",\;,"GFDL-CM3"
          "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM-CHEM","MIROC-ESM",\
          "MRI-CGCM3","NorESM1-ME", "NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

MODEL5_MINUS = (/"bcc-csm1-1","BNU-ESM","CCSM4","CESM1-BGC","CESM1-FASTCHEM","CESM1-WACCM",\
              "CMCC-CESM","CMCC-CM","CMCC-CMS","FGOALS-s2","GFDL-CM2p1", "GFDL-ESM2G","MPI-ESM-LR",\
              "HadCM3","inmcm4","MPI-ESM-MR","MPI-ESM-P"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

MODEL5 = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
             "IPSL-CM5A-LR"/);, "CanESM2", "MIROC5","CESM1-CAM5","HadGEM2-ES",\
             ; "ACCESS1-0","ACCESS1-3","bcc-csm1-1","CESM1-FASTCHEM","FGOALS-g2",\
             ; "FGOALS-s2","FIO-ESM","IPSL-CM5A-MR","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M"/);"GFDL-CM3",
nens5 = (/10,10,10,8,6,\;6,6,
         6/);,5,5,4,4,\
         ; 3,3,3,3,3,3,3,\
         ; 3,3,3,3,3,3 /);5,



MODEL6 = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0","MIROC6",\;"GISS-E2-1-H",
  "MPI-ESM1-2-LR","MPI-ESM1-2-HR"/);,"MRI-ESM2-0","E3SM-1-0",\
    ; "BCC-CSM2-MR","CESM2-FV2","CESM2-WACCM-FV2",\
    ;      "CESM2-WACCM","FIO-ESM-2-0","NorESM2-LM" /) ;large ensemble model in CMIP6 "NESM3",

nens6 = (/32,30,25,12,11, 10, 10,\;10,
          10,7/);,5,5,\
          ; 3,3,3,\
          ; 3,3,3 /) ;ensemble number 5,


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
IND = "PDI2" ;"EACSS" ;"EAS" ;"PDI2" ; "NPCSS" ;"NPC" ;"NPS" ;"NPAOD" ;"PDI2";"TPI" ;"NPI" ;"AMO" ;"pdo" ;"nh-sh" ;"GMAOD" ;"GMSW" ;
MODEL = MODEL5;MODEL6;
nens = nens6
icmip = 5;6 ;
nens_all = 10;32 ;

yrs = 1861;
yrl = 2004; 2014;


nmo5 = dimsizes(MODEL5)
nmo6 = dimsizes(MODEL6)

pc5_all = new((/nmo5,10,(yrl5-yrs5+1)*12/), "float")

do im = 0,nmo5-1

;from pdv_cmip5_hist.ncl
;cmip5_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
locs = systemfunc("ls "+diri+"cmip5/pdv/cmip5_historical_"+MODEL5(im)+"_*_pdv_"+yrs5+"-"+yrl5+".nc")
; printVarSummary(locs)
; print(locs)
nsa = dimsizes(locs)

; if(.not.ismissing(locs)) then
do ia = 0,nsa-1

  ; print("MODEL5 "+MODEL5(im))
  locs_str = str_split(locs(ia), "_"); "/")
  ; print("'" + locs_str + "'")
  ENSN  = locs_str(3)
  print(MODEL5(im)+" ens "+ENSN)
  delete(locs_str)

   file_name = diri+"cmip5/"+IND+"/cmip5_"+EXP5+"_"+MODEL5(im)+"_"+ENSN+"_"+IND+"_"+yrs5+"-"+yrl5+".nc"
   exists = isfilepresent(file_name)
   if(.not.exists) then
     ; print(MODEL5(im)+" ens "+ENSN+" file not exist")
     ; print("Either the file doesn't exist, or NCL does")
     ; print("not have OPeNDAP cabilities on this system.")
     continue
   else
    ; print(file_name)
   f   = addfile(file_name, "r")
   end if

  pc5_all(im,ia,:)  = f->index;pc(0,:);gmst;

; print(""+pc5_all(im,ia,(1890-1861)*12))

end do
; end if
delete(locs)
end do
printVarSummary(pc5_all)


;CMIP6
pc6_all = new((/nmo6,32,(yrl6-yrs6+1)*12/), "float")
do im = 0,nmo6-1

;from pdv_cmip5_hist.ncl
;cmip5_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
locs = systemfunc("ls "+diri+"cmip6/pdv/cmip6_historical_"+MODEL6(im)+"_*_pdv_"+yrs6+"-"+yrl6+".nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

; if(.not.ismissing(locs)) then

do ia = 0,nsa-1

  print("MODEL6 "+MODEL6(im))
  locs_str = str_split(locs(ia), "_"); "/")
  print("'" + locs_str + "'")
  ENSN  = locs_str(3)
  print(MODEL6(im)+" ens "+ENSN)
  delete(locs_str)

   file_name = diri+"cmip6/"+IND+"/cmip6_"+EXP6+"_"+MODEL6(im)+"_"+ENSN+"_"+IND+"_"+yrs6+"-"+yrl6+".nc"
   exists = isfilepresent(file_name)
   if(.not.exists) then
     print(MODEL6(im)+" ens "+ENSN+" file not exist")
     print("Either the file doesn't exist, or NCL does")
     print("not have OPeNDAP cabilities on this system.")
     continue
   else
    print(file_name)
   f   = addfile(file_name, "r")
   end if

  pc6_all(im,ia,:)  = f->index;pc(0,:);gmst;

end do
; end if
delete(locs)

end do

printVarSummary(pc6_all)

;============CMIP5 LENS==============================

MODEL5le = (/"CESM1-CAM5","CanESM2","CSIRO-Mk3-6-0",\;"EC-EARTH",
  "GFDL-ESM2M","MPI-ESM" /);"GFDL-CM3",

nens5le = (/ 40, 50, 30, 30,  100 /) ;20, ensemble number

nml5le = dimsizes(MODEL5le)

EXP = "historical"
IND2 = "PDI"

yrs0 = 1850
yrl0 = 2014;2004
ntime = (yrl0-yrs0+1)*12
; pc_all = new((/nml5le,100,ntime/), "float")
; pca_lens5le = new((/nml5le,ntime/), "float")
pc_lens5le = new((/nml5le,max(nens5le),ntime/), "float")
com_std5le = new((/nml5le,ntime/), "float")

do im = 0,nml5le-1

locs = systemfunc("ls "+diri+"lens5/"+IND2+"/"+MODEL5le(im)+"_"+EXP+"*")
 locs_str = str_split(locs(im), "_")
 print("'" + locs_str + "'")


bb = str_split(locs_str(4), "-")

  yrl = 2014
  yrs= toint(bb(0))

print("yrs = "+yrs)

;---------read output---------------
;from lens5_index.ncl
  f1   = addfiles(locs, "r")  ;multiple files
  ListSetType (f1, "join")        ; concatenate (=default)

  pc  = f1[:]->index
  ; pc = wgt_runave_n_Wrap( pc, wgt,  0, 1 )

printVarSummary(pc)
;;----------composite ensemble-----------------

com_std5le(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_stddev_n_Wrap(pc, 0)
pc_lens5le(im,:nens5le(im)-1,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = pc
  delete([/locs,pc,f1,bb,locs_str/] )
end do
printVarSummary(pc_lens5le)


;don't filter pdv index twice!!!
;=============filter========================
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*12*1+1); fyr)+1 ;                           ; odd only
fca   = 1./(fyr*12)
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )
pc5_all = wgt_runave_n_Wrap( pc5_all, wgt,  0, 2 )   ;opt < 0 : utilize cyclic conditions
pc6_all = wgt_runave_n_Wrap( pc6_all, wgt,  0, 2 )   ;opt < 0 : utilize cyclic conditions
pc_lens5le = wgt_runave_n_Wrap( pc_lens5le, wgt,  0, 2 )   ;opt < 0 : utilize cyclic conditions


;----------composite-------------------
;MME
;ignore model bias
; ndimp = dimsizes(pc5_all)
; aa = reshape(pc5_all, (/ndimp(0)*ndimp(1),ndimp(2)/))
cp5_a = dim_avg_n_Wrap(pc5_all,(/0,1/)); aa, 0)
cp6_a = dim_avg_n_Wrap(pc6_all,(/0,1/)); aa, 0)

; ;each model mean
cp5 = dim_avg_n_Wrap(pc5_all,1)
cp6 = dim_avg_n_Wrap(pc6_all,1)

com_pc5 = dim_avg_n_Wrap(cp5,0)
com_pc6 = dim_avg_n_Wrap(cp6,0)
pca_lens5le = dim_avg_n_Wrap(pc_lens5le, 1)
com_pc5le = dim_avg_n_Wrap(pca_lens5le,0)
printVarSummary(com_pc5le)
printVarSummary(pca_lens5le)

; ;1. averaged STD across ensembles
cs_a = dim_stddev_n_Wrap(pc5_all, (/0,1/)) ;com_std, 0)


std_5 = dim_stddev_n_Wrap(pc5_all,(/1/))
std_6 = dim_stddev_n_Wrap(pc6_all,(/1/))
; ;--------output-------------
; fon=diri+"cmip5_"+EXP5+"_"+IND+"_mme.nc";
; system("rm -f "+fon)
; fo=addfile(fon,"c")
; fo->cp5_a = cp5_a
; fo->cp5_a2 = cp5_a2
; fo->std_5 = std_5

; fon=diri+"cmip6_"+EXP6+"_"+IND+"_mme.nc";
; system("rm -f "+fon)
; fo=addfile(fon,"c")
; fo->cp6_a = cp6_a
; fo->cp6_a2 = cp6_a2
; fo->std_6 = std_6


; ; ;-----------BootStrap---------------------
; ; function_bootstrap_mme.ncl

; N = 1000
; nBoot =   10000


; nem5y = num(.not.ismissing(ndtooned(pc5_all(i5y,:,500))))
; nem5n = num(.not.ismissing(ndtooned(pc5_all(i5n,:,500))))
; nem5 = num(.not.ismissing(ndtooned(pc5_all(:,:,500))))
; print(nem5y)

; boo5 = bootstrap_mme(pc5_all,wgt,N,nBoot,nem5)
; ; zz = dim_avg_n_Wrap(boo5, 1)
; ; bh5 = cp5_a
; ; bh5 = where(cp5_a.ge.zz(0).or.cp5_a.ne.zz(1), cp5_a, cp5_a@_FillValue)

; boo5y = bootstrap_mme(pc5_all,wgt,N,nBoot,nem5y)
; ; zz = dim_avg_n_Wrap(boo5y, 1)
; ; bh5y = cp5_plus_a
; ; bh5y = where(cp5_plus_a.ge.zz(0).or.cp5_plus_a.ne.zz(1), cp5_plus_a, cp5_plus_a@_FillValue)

; boo5n = bootstrap_mme(pc5_all,wgt,N,nBoot,nem5n)
; ; zz = dim_avg_n_Wrap(boo5n, 1)
; ; bh5n = cp5_minus_a
; ; bh5n = where(cp5_minus_a.ge.zz(0).or.cp5_minus_a.ne.zz(1), cp5_minus_a, cp5_minus_a@_FillValue)

; nem6 = num(.not.ismissing(ndtooned(pc6_all(:,:,500))))
; boo6 = bootstrap_mme(pc6_all,wgt,N,nBoot,nem6)
; ; zz = dim_avg_n_Wrap(boo6, 1)
; ; print(nem6)
; ; bh6 = cp6_a
; ; bh6 = where(cp6_a.ge.zz(0).or.cp6_a.ne.zz(1), cp6_a, cp6_a@_FillValue)



;--------------plot-------------------

wks = gsn_open_wks("png", "./pic/lens_xy");dirip
wks2 = gsn_open_wks("png", dirip+"test");
plot1 = new(10,graphic)                ; create graphic array
plot2 = new(10,graphic)                ; create graphic array
plot3 = new(10,graphic)                ; create graphic array
plot4 = new(10,graphic)                ; create graphic array


;*******************************************
; time series (principal component) plot
;*******************************************

  gsn_define_colormap(wks,"seaice_2")
  colors = ispan(2, 17, 1)   ; indices into color table
  colors2 = ispan(2, 17, 2)   ; indices into color table
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

  ndim5  = dimsizes(pc5_all)
  x_axis5 = fspan(yrs5, yrl5, ndim5(2))
  ndim6  = dimsizes(pc6_all)
  x_axis6 = fspan(yrs6, yrl6, ndim6(2))
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

  res@trYMinF               = -1.0
  res@trYMaxF               =  1.0


;MODEL
res@xyLineThicknessF = 5.0
res@gsnRightString = pc5_all@units
  res@xyLineColors = "black"

do im = 0,nmo5-1
res@gsnLeftString = IND+" in "+MODEL5(im)+"("+nens5(im)+")"
plot1(im) = gsn_csm_xy (wks,x_axis5, cp5(im,:) ,res)

end do

do im = 0,nmo6-1
res@gsnLeftString = IND+" in "+MODEL6(im)+"("+nens6(im)+")"
plot2(im) = gsn_csm_xy (wks,x_axis6, cp6(im,:) ,res)
end do

;==========================================================
; models in one plot
;==========================================================
delete(res@xyLineColors)


;MODEL
res@xyLineThicknessF = 5.0
  res@xyLineColors = colors2
  res@gsnLeftString = "CMIP5";
  plot3(0) = gsn_csm_xy (wks,x_axis5, cp5 ,res) ;x_axis2, com_pc
  delete(res@xyLineColors)
  res@xyLineColors = colors
  res@gsnLeftString = "CMIP6";
  plot3(1) = gsn_csm_xy (wks,x_axis6, cp6,res) ;x_axis2, com_pc

delete(res@xyLineColors)
res@xyLineThicknessF = 5.0
res@xyLineColors = "black"
res@gsnLeftString = ""
;
; plota = gsn_csm_xy (wks,x_axis5,com_pc5,res)
; overlay(plot3(0), plota)
; plota = gsn_csm_xy (wks,x_axis6,com_pc6,res)
; overlay(plot3(1), plota)


;---------shading of STD---------

  ; delete(res@xyDashPattern)
  delete(res@xyLineColors)
  res2 = res
  res2@xyLineColor     = -1                           ; We don't want the line, so make it trax_axisparent.
  mmz = cp5(0:1,:)

res2@gsnLeftString = ""

do im = 0,nmo5-1

  ; STD shading
  mmz(0,:) = cp5(im,:)+std_5(im,:)
  mmz(1,:) = cp5(im,:)-std_5(im,:)

  res2@gsnXYFillOpacities = 0.3
  res2@gsnXYFillColors = "grey55"
  res2@xyCurveDrawOrder = "PreDraw"
  plota  = gsn_csm_xy (wks,(/x_axis5/),mmz(0:1,:),res2)  ; Create filled XY plot.
  overlay(plot1(im), plota)

end do
delete(mmz)
  mmz = cp6(0:1,:)

do im = 0,nmo6-1

  ; STD shading
  mmz(0,:) = cp6(im,:)+std_6(im,:)
  mmz(1,:) = cp6(im,:)-std_6(im,:)

  plota  = gsn_csm_xy (wks,(/x_axis6/),mmz(0:1,:),res2)  ; Create filled XY plot.
  overlay(plot2(im), plota)

end do

;---------shading of STD---------

com_std6 = dim_avg_n_Wrap(std_6,0)

  mmz(0,:) = com_pc6-com_std6
  mmz(1,:) = com_pc6+com_std6

  plota  = gsn_csm_xy (wks,(/x_axis6/),mmz(0:1,:),res2)  ; Create filled XY plot.
  overlay(plot3(1), plota)

  delete(mmz)
  mmz = cp5(0:1,:)
  com_std5 = dim_avg_n_Wrap(std_5,0)

    mmz(0,:) = com_pc5-com_std5
    mmz(1,:) = com_pc5+com_std5

    plota  = gsn_csm_xy (wks,(/x_axis5/),mmz(0:1,:),res2)  ; Create filled XY plot.
    overlay(plot3(0), plota)

;---------------
; MME
;---------------

res@trYMinF               = -0.4
res@trYMaxF               =  0.4

res@gsnLeftString = ""
res@xyLineColors = "blue"
plot4(0) = gsn_csm_xy (wks,x_axis5, com_pc5 ,res)
res@xyLineColors = "red"
plota = gsn_csm_xy (wks,x_axis6, com_pc6 ,res)
overlay(plot4(0),plota)
res@xyLineColors = "lightblue3"
plota = gsn_csm_xy (wks,x_axis6, com_pc5le ,res)
overlay(plot4(0),plota)


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
    lgres@lgLineColors       = colors2;(::-1)
    labels1 = MODEL5+"("+nens5+")"
    nitems1 = dimsizes(labels1)                 ; number of legend items

    lbid1 = gsn_create_legend(wks,nitems1,labels1,lgres)

    delete(lgres@lgLineColors )
    lgres@lgLineColors       = colors;(::-1)
    labels2 = MODEL6+"("+nens6+")"
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

    annoid1 = gsn_add_annotation(plot3(0),lbid1,amres)  ; add legend to plot
    annoid2 = gsn_add_annotation(plot3(1),lbid2,amres)  ; add legend to plot


;************************************************
; Attach text to plot using plot coordinates.
;************************************************
  txres               = True                     ; text mods desired
  txres@txFontHeightF = 0.02                     ; font smaller. default big

  txres@txFontColor  = "blue"
  dum1 = gsn_add_text(wks,plot4(0),"CMIP5 LE",1880,0.3,txres)
  txres@txFontColor  = "lightblue3"
  dum1 = gsn_add_text(wks,plot4(0),"CMIP5 LENS",1880,0.2,txres)
  txres@txFontColor  = "red"
  dum2 = gsn_add_text(wks,plot4(0),"CMIP6 LE",1880,0.1,txres)

;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait

resk@txString = "CMIP5 LE"
gsn_panel(wks,plot1,(/5,2/),resk)
resk@txString = "CMIP6 LE"
gsn_panel(wks,plot2,(/5,2/),resk)
resk@txString = ""
gsn_panel(wks,plot3,(/2,1/),resk)
gsn_panel(wks,plot4,(/1,1/),resk)

end
