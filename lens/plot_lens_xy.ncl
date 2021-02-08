;derive from plot_pdv_cmip5_xy.ncl
begin

;don't filter pdv index twice!!!
;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*12*1+1); fyr)+1 ;                           ; odd only
fca   = 1./(fyr*12)
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

diri = "/Users/xingchen/Documents/project/ENSO/data/" ;"/glade/work/chenxing/enso/"
dirip = "/Users/xingchen/Documents/project/ENSO/pic/" ;"/glade/u/home/chenxing/enso/"

neof = 1

MODEL = (/"CESM1-CAM5","CanESM2","CSIRO-Mk3-6-0",\;"EC-EARTH",
  "GFDL-CM3","GFDL-ESM2M","MPI-ESM" /)

nens = (/ 40, 50, 30, 20, 30, 100 /) ;ensemble number

EXP = "historical"
IND = "PDI"

nml5 = dimsizes(MODEL)

yrs0 = 1850
yrl0 = 2014;2004
ntime = (yrl0-yrs0+1)*12
; pc_all = new((/nml5,100,ntime/), "float")
com_pc = new((/nml5,ntime/), "float")
com_std = new((/nml5,ntime/), "float")

do im = 0,nml5-1

locs = systemfunc("ls "+diri+"lens5/"+IND+"/"+MODEL(im)+"_"+EXP+"*")
 locs_str = str_split(locs(im), "_")
 print("'" + locs_str + "'")


bb = str_split(locs_str(4), "-")

  yrl = 2004
  yrs= toint(bb(0))

print("yrs = "+yrs)

;---------read output---------------
;from lens5_index.ncl
  f1   = addfiles(locs, "r")  ;multiple files
  ListSetType (f1, "join")        ; concatenate (=default)

  pc  = f1[:]->index
  pc = wgt_runave_n_Wrap( pc, wgt,  0, 1 )

printVarSummary(pc)
;;----------composite ensemble-----------------
printVarSummary(com_pc(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1))
com_pc(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_avg_n_Wrap(pc, 0)
com_std(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_stddev_n_Wrap(pc, 0)

  delete([/locs,pc,f1,bb,locs_str/] )
end do
printVarSummary(com_pc)


;==========================CESM==========================

MODEL2 = (/"CESM1","CESM1","CESM1","CESM1","CESM2 (CMIP5 forcing)"/)
EXP2 =  (/ "xghg", "xaer" , "xlulc", "xbmb",""/)
lens2 = (/"20","20","5","15","7" /) ;
nec = dimsizes(EXP2)
cesm_pc = new((/nec,ntime/), "float")
cesm_std = new((/nec,ntime/), "float")
nens2 = ispan(1, nec, 1)

;;;;;;;cesm2_cmip5_forcing;;;;;;;;
;cesm2_cmip5_forcing_002_PDI_1850-2004.nc
locs = systemfunc("ls "+diri+"lens5/"+IND+"/cesm2_cmip5_forcing_*")
f1   = addfiles(locs, "r")  ;multiple files
ListSetType (f1, "join")        ; concatenate (=default)
pc  = f1[:]->index
pc = wgt_runave_n_Wrap( pc, wgt,  0, 1 )
yrs = 1850
yrl = 2004
im = nec-1
cesm_pc(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_avg_n_Wrap(pc, 0)
cesm_std(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_stddev_n_Wrap(pc, 0)
ndim = dimsizes(pc)
nens2(im) = ndim(0)
delete([/locs,pc,f1/] )
cesm_pc(im,:) = cesm_pc(im,:) - avg(cesm_pc(im,(1920-1850)*12:)) ;consist the clm with other which started from 1920

;;;;;;;cesm1_le single forcing;;;;;;;;
do im = 0,nec-2

;cesm1_le_xghg_015_PDI_1920-2004
locs = systemfunc("ls "+diri+"lens5/"+IND+"/cesm1_le_"+EXP2(im)+"_*")
locs_str = str_split(locs(im), "_")
 print("'" + locs_str + "'")

bb = str_split(locs_str(5), "-")

  yrl = 2004
  yrs= toint(bb(0))

print("yrs = "+yrs)

;---------read output---------------
;from lens5_index.ncl
  f1   = addfiles(locs, "r")  ;multiple files
  ListSetType (f1, "join")        ; concatenate (=default)

  pc  = f1[:]->index
  pc = wgt_runave_n_Wrap( pc, wgt,  0, 1 )

printVarSummary(pc)
;;----------composite ensemble-----------------
printVarSummary(cesm_pc(im,(yrs-yrs0)*12:))
cesm_pc(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_avg_n_Wrap(pc, 0)
cesm_std(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_stddev_n_Wrap(pc, 0)

ndim = dimsizes(pc)
nens2(im) = ndim(0)

  delete([/locs,pc,f1,bb,locs_str/] )
end do
printVarSummary(cesm_pc)

; ;--------output-------------
; fon=diri+"cmip6_historical_pdv_mme.nc";
; system("rm -f "+fon)
; fo=addfile(fon,"c")
; fo->com_pc = com_pc


;;;;;;;CESM2 from CMIP6;;;;;;;;
locs = systemfunc("ls "+diri+"cmip6/"+IND+"/cmip6_historical_CESM2_*_"+IND+"_1850-2014.nc")
f1   = addfiles(locs, "r")  ;multiple files
ListSetType (f1, "join")        ; concatenate (=default)

pc_cesm2  = f1[:]->index

pc_cesm2 = wgt_runave_n_Wrap( pc_cesm2, wgt,  0, 1 )   ;opt < 0 : utilize cyclic conditions
printVarSummary(pc_cesm2)
pca_cesm2 = dim_avg_n_Wrap(pc_cesm2,0)
pca_cesm2 = pca_cesm2 - avg(pca_cesm2((1920-1850)*12:)) ;consist the clm with other which started from 1920

;--------------plot-------------------

wks = gsn_open_wks("png", "lens5_xy");dirip+
plot1 = new(nml5,graphic)                ; create graphic array
plot2 = new(nec,graphic)                ; create graphic array
plot3 = new(2,graphic)                ; create graphic array

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

  x_axis = fspan(yrs0, yrl0+1, ntime)
  ;res@tmXBMode   = "Explicit"
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
  res@tiYAxisString = ""
  res@tiXAxisString = "year"

  res@xyMonoLineColor = False
  res@xyMonoDashPattern = True

  res@trXMinF              = yrs0
  res@trXMaxF              = yrl0+1

  res@trYMinF               = -1.0
  res@trYMaxF               =  1.0


;MODEL
res@xyLineThicknessF = 5.0
res@gsnLeftString = "PDV"; 15yr rolling trend"
res@gsnRightString = com_pc@units
  res@xyLineColors = "black"


do im = 0,nml5-1
  res@gsnLeftString = MODEL(im)+" ("+nens(im)+")"
  plot1(im) = gsn_csm_xy (wks,x_axis,com_pc(im,:),res)
end do

do im = 0,nec-1
  res@gsnLeftString = MODEL2(im)+" "+EXP2(im)+" ("+nens2(im)+")"
  plot2(im) = gsn_csm_xy (wks,x_axis,cesm_pc(im,:),res)
end do
res@gsnLeftString = ""

;---------shading of STD---------

  ; delete(res@xyDashPattern)
  delete(res@xyLineColors)
  res@xyLineColor     = -1                           ; We don't want the line, so make it trax_axisparent.
  mmz = com_pc(0:1,:)

do im = 0,nml5-1

  ; STD shading
  mmz(0,:) = com_pc(im,:)+com_std(im,:)
  mmz(1,:) = com_pc(im,:)-com_std(im,:)

  res@gsnXYFillOpacities = 0.3
  res@gsnXYFillColors = "grey55"
  res@xyCurveDrawOrder = "PreDraw"
  plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
  overlay(plot1(im), plota)

end do

do im = 0,nec-1

  ; STD shading
  mmz(0,:) = cesm_pc(im,:)+cesm_std(im,:)
  mmz(1,:) = cesm_pc(im,:)-cesm_std(im,:)

  res@gsnXYFillOpacities = 0.3
  res@gsnXYFillColors = "grey55"
  res@xyCurveDrawOrder = "PreDraw"
  plota  = gsn_csm_xy (wks,(/x_axis/),mmz(0:1,:),res)  ; Create filled XY plot.
  overlay(plot2(im), plota)

end do


;;;;; CESM playground;;;;;;;
res@trYMinF               = -0.8
res@trYMaxF               =  0.8

res@xyLineThicknessF = 8.0
;CESM2 LE (pca_cesm2)
res@xyLineColors = "grey55"
plot3(0) = gsn_csm_xy (wks,x_axis,pca_cesm2,res)

;CESM1 LENS (com_pc(0,:))
; res@xyLineThicknessF = 5.0
res@xyLineColors = "pink"
plotb = gsn_csm_xy (wks,x_axis,com_pc(0,:),res)
overlay(plot3(0), plotb)

;CESM1 single forcing (GHG:cesm_pc(0,:); AER:cesm_pc(1,:); LULC:cesm_pc(2,:); BMB:cesm_pc(3,:)  )
res@xyLineColors = "lightblue2"
plot3(1) = gsn_csm_xy (wks,x_axis,cesm_pc(1,:),res)
dces1 = cesm_pc(1,:)
dces1 = cesm_pc@_FillValue
dces1((1920-yrs0)*12:) = com_pc(0,(1920-yrs0)*12:) - cesm_pc(1,(1920-yrs0)*12:)
res@xyLineColors = "green"
plota = gsn_csm_xy (wks,x_axis,dces1,res)
overlay(plot3(1), plota)
plota = gsn_csm_xy (wks,x_axis,dces1,res)
overlay(plot3(0), plota)
res@xyLineColors = "pink"
plotb = gsn_csm_xy (wks,x_axis,com_pc(0,:),res)
overlay(plot3(1), plotb)

;CESM2 CMIP5 forcing (cesm_pc(4,:))
res@xyLineColors = "wheat"
plota = gsn_csm_xy (wks,x_axis,cesm_pc(4,:),res)
overlay(plot3(0), plota)



; ; ;;legend
; ;   gres = True
; ;   gres@YPosPercent = 95.    ; expressed as %, 0->100, sets position of top border of legend
; ;                             ;  when gres@Position is set to its default setting of "Top" (Default = 95.)
; ;   gres@XPosPercent = 5      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)

; ;   lineres = True
; ;   lineres@lgLineColors = (/"black","blue"/) ; line colors
; ;   lineres@lgLineThicknesses = 2.5                        ; line thicknesses
; ;   lineres@LineLengthPercent = 9.                         ; expressed as %, 0->100, length of line

; ;   textres = True
; ;   textres@lgLabels = (/"PDV","TPDV"/)  ; legend labels (required)

;   ; plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)
;   ; plot(3) = simple_legend(wks,plot(3),gres,lineres,textres)

;---------------------------------
; Set up resources for a customized legend.
;
  lgres                    = True
  lgres@lgLineThicknessF   = 10.0
  lgres@lgItemType         = "Lines"        ; show lines only (default)
  lgres@lgLabelFontHeightF = .1            ; legend label font thickness
  lgres@vpWidthF           = 0.30           ; width of legend (NDC)
  lgres@vpHeightF          = 0.10           ; height of legend (NDC)
  ; lgres@lgPerimThicknessF  = 2.0            ; thicken the box perimeter
  lgres@lgPerimOn          = False
 ; lgres@lgPerimFill = 0
 ; lgres@lgPerimFillColor = 0
  lgres@lgPerimFill            = "SolidFill"      ; Fill legend box w/white
  lgres@lgPerimFillColor       = "white"          ; so it masks XY curves

  lgres@lgMonoDashIndex = True
  lgres@lgDashIndexes = 0;(/0,0,0,0,0,0,0,0/)
  lgres@lgLineColors       = (/"wheat","pink","grey55"/)
  labels1 = (/"CESM2(CMIP5forcing| 7)","CESM1(40)","CESM2(11)" /)
  nitems1 = dimsizes(labels1)                 ; number of legend items

  lbid1 = gsn_create_legend(wks,nitems1,labels1,lgres)

  lgres@lgLineColors       = (/"green","lightblue2" ,"pink"/)
  labels2 = (/"Difference(Aerosol)","CESM1(NoAerosol| 20)","CESM1(40)" /)
  nitems2 = dimsizes(labels2)                 ; number of legend items
  lbid2 = gsn_create_legend(wks,nitems2,labels2,lgres)

; Use gsn_add_annotation to attach this legend to our existing plot.
; This way, if we resize the plot, the legend will stay with the
; plot and be resized automatically.
;
  amres                  = True

  amres@amJust           = "BottomLeft"    ; Use bottom right corner of box
                                            ; for determining its location.
  amres@amParallelPosF   =  -0.5              ; Move legend to right
  amres@amOrthogonalPosF =  -0.15              ; Move legend down.

  annoid1 = gsn_add_annotation(plot3(0),lbid1,amres)  ; add legend to plot
  annoid2 = gsn_add_annotation(plot3(1),lbid2,amres)  ; add legend to plot

;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@txString = IND

gsn_panel(wks,plot1,(/3,2/),resk)
gsn_panel(wks,plot2,(/3,2/),resk)
gsn_panel(wks,plot3,(/2,1/),resk)

end
