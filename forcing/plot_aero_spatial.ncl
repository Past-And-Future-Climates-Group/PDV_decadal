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


;============read==============================
;------anthropogenic emission---------------

AER = (/"BC","CO","NH3","NMVOC","NO","OC","SO2" /);"CH4",
EMI = (/"emiss_awb","emiss_wst","emiss_dom","emiss_ene","emiss_ind","emiss_tra"/) ;
AER2 = (/"BC","CO","NH3","NOx","OC","SO2" /); "CH4",
;0: Agriculture; 1: Energy; 2: Industrial; 3: Transportation; 4: Residential, Commercial, Other
;5: Solvents production and application; 6: Waste; 7: International Shipping

na = dimsizes(AER)

yrs0 = 1850
yrl0 = 2014
ntime = (yrl0-yrs0+1)*12

aer5 = new((/na,16/), "float")
aer6 = new((/na,165/), "float");1850-2014 (bb BC 1850-2015)

do im = 0,na-1


;---------read output---------------
;from aero_index_cmip5.ncl
  f1   = addfile(diri+"aerosol/cmip5_"+AER(im)+"_anthropogenic_GM.nc", "r")
  aer5(im,:,:)  = f1->index
  ; aer5 = wgt_runave_n_Wrap( aer5, wgt,  0, 1 )

  f1   = addfile(diri+"aerosol/cmip6_"+AER2(im)+"_anthropogenic_GM.nc", "r")
  aer6(im,:,:)  = f1->index

end do
printVarSummary(aer5)
x_axis5 = ispan(1850,2000,10)
printVarSummary(x_axis5)

printVarSummary(aer6)
x_axis6 = ispan(1850,2014,1)
printVarSummary(x_axis6)

;----------------Biomass burning---------------

AER = (/"BC","CO","NH3","NMVOC","NOx","OC","SO2"/) ;"CH4",
EMI = (/"grassfire","forestfire"/);


; f2   = addfile(diri+"aerosol/cmip5_BC_biomassburning_gm.nc", "r") ;1900-2000
; bb5  = f2->index
; f2   = addfile(diri+"aerosol/cmip6_BC_biomassburning_gm.nc", "r") ;1850-2015
; bb6  = f2->index
; printVarSummary(bb6)
; printVarSummary(bb5)
; x_axis5b = ispan(1900,2000,10)
; x_axis6b = ispan(1850,2015,1)

;--------------plot-------------------

wks = gsn_open_wks("png", "./aero_xy");dirip+
plot1 = new(10,graphic)                ; create graphic array

;*******************************************
; time series (principal component) plot
;*******************************************

  ; gsn_define_colormap(wks,"MPL_gist_rainbow")
  ; colors = (/"coral1","cyan1","darkolivegreen1","gold1","mediumpurple1","grey55" /) ;ispan(2, 125, 30)   ; indices into color table
  gsn_define_colormap(wks,"seaice_2")
  colors = ispan(2, 17, 2)   ; indices into color table
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


  ; res@gsnYRefLine           = 0.0             ; reference line
  ; res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  ; res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  ; res@gsnLeftStringFontHeightF  = 0.03
  ; res@gsnRightStringFontHeightF = 0.03

  ;res@tmXBMode   = "Explicit"
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
  res@tiYAxisString = ""
  res@tiXAxisString = "year"

  res@xyMonoLineColor = False
  res@xyMonoDashPattern = True

  res@trXMinF              = 1850
  res@trXMaxF              = 2015

  res@trYMinF               = 0.

res2 = res
;MODEL
res@xyLineThicknessF = 5.0
res@gsnRightString = aer5@units ;aer5@units *??--> Gg/yr
  res@xyLineColors = "lightblue"

res2@xyLineThicknessF = 3.0
res2@xyLineColors = "black"

do im = 0,na-1

  res@trYMaxF               = max(aer5(im,:))*1.5

  res@gsnLeftString = AER(im)
  plot1(im) = gsn_csm_xy (wks,x_axis5,aer5(im,:),res)
  plota = gsn_csm_xy (wks,x_axis6,aer6(im,:),res2)
  overlay(plot1(im),plota)
end do


;
; ;---------------------------------
; ; Set up resources for a customized legend.
; ;
;   lgres                    = True
;   lgres@lgLineThicknessF   = 3.0
;   lgres@lgItemType         = "Lines"        ; show lines only (default)
;   lgres@lgLabelFontHeightF = .1            ; legend label font thickness
;   lgres@vpWidthF           = 0.30           ; width of legend (NDC)
;   lgres@vpHeightF          = 0.10           ; height of legend (NDC)
;   ; lgres@lgPerimThicknessF  = 2.0            ; thicken the box perimeter
;   lgres@lgPerimOn          = False
;  ; lgres@lgPerimFill = 0
;  ; lgres@lgPerimFillColor = 0
;   lgres@lgPerimFill            = "SolidFill"      ; Fill legend box w/white
;   lgres@lgPerimFillColor       = "white"          ; so it masks XY curves
;
;   lgres@lgMonoDashIndex = True
;   lgres@lgDashIndexes = 0;(/0,0,0,0,0,0,0,0/)
;   lgres@lgLineColors       = (/"gold1","pink","grey75"/)
;   labels1 = (/"CESM2(CMIP5forcing| 7)","CESM1(40)","CESM2(11)" /)
;   nitems1 = dimsizes(labels1)                 ; number of legend items
;
;   lbid1 = gsn_create_legend(wks,nitems1,labels1,lgres)
;
;   lgres@lgLineColors       = (/"green","blue" ,"lightpink3"/)
;   labels2 = (/"Difference(Aerosol)","CESM1(NoAerosol| 20)","CESM1(40)" /)
;   nitems2 = dimsizes(labels2)                 ; number of legend items
;   lbid2 = gsn_create_legend(wks,nitems2,labels2,lgres)
;
;   lgres@lgLineColors       = (/"green","gold1" ,"grey75"/)
;   labels3 = (/"Difference(CMIP6/5forcing)","CESM2(CMIP5forcing| 7)","CESM2(11)" /)
;   nitems3 = dimsizes(labels3)                 ; number of legend items
;   lbid3 = gsn_create_legend(wks,nitems3,labels3,lgres)
;
;   lgres@lgLineColors       = (/"green","gold1" ,"pink"/)
;   labels4 = (/"Difference(CESM2/1physics)","CESM2(CMIP5forcing| 7)","CESM1(40)" /)
;   nitems4 = dimsizes(labels4)                 ; number of legend items
;   lbid4 = gsn_create_legend(wks,nitems4,labels4,lgres)
;
;   delete(lgres@lgLineColors)
;   lgres@vpWidthF           = 0.20           ; width of legend (NDC)
;   lgres@vpHeightF          = 0.30           ; height of legend (NDC)
;   lgres@lgLineColors       = colors;(::-1)
;   labels5 = MODEL+"("+nens5+")"
;   nitems5 = dimsizes(labels5)                 ; number of legend items
;
;   lbid5 = gsn_create_legend(wks,nitems5,labels5,lgres)
;
; ; Use gsn_add_annotation to attach this legend to our existing plot.
; ; This way, if we resize the plot, the legend will stay with the
; ; plot and be resized automatically.
; ;
;   amres                  = True
;
;   amres@amJust           = "BottomLeft"    ; Use bottom right corner of box
;                                             ; for determining its location.
;   amres@amParallelPosF   =  -0.44              ; Move legend to right
;   amres@amOrthogonalPosF =  -0.18              ; Move legend down.
;
;   annoid1 = gsn_add_annotation(plot3(0),lbid1,amres)  ; add legend to plot
;   annoid2 = gsn_add_annotation(plot3(1),lbid2,amres)  ; add legend to plot
;   annoid3 = gsn_add_annotation(plot3(2),lbid3,amres)  ; add legend to plot
;   annoid4 = gsn_add_annotation(plot3(3),lbid4,amres)  ; add legend to plot
;   amres@amParallelPosF   =  0.5              ; Move legend to right
;   amres@amOrthogonalPosF =  0.5              ; Move legend down.
;   annoid5 = gsn_add_annotation(plot5(0),lbid5,amres)  ; add legend to plot

; ;************************************************
; ; Attach text to plot using plot coordinates.
; ;************************************************
;   txres               = True                     ; text mods desired
;   txres@txFontHeightF = 0.02                     ; font smaller. default big
;
;   txres@txFontColor  = "darkgreen"
;   dum1 = gsn_add_text(wks,plot3(2),"Difference(CMIP6/5forcing)",1970,-0.8,txres)
;   txres@txFontColor  = "darkgoldenrod3"
;   dum2 = gsn_add_text(wks,plot3(2),"CESM2(CMIP5forcing| 7)",1970,-0.6,txres)
;   txres@txFontColor  = "grey25"
;   dum3 = gsn_add_text(wks,plot3(2),"CESM2(11)",1970,-0.4,txres)

;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@txString = "EA Anthropogenic aerosol emissions in CMIP5 & CMIP6"

gsn_panel(wks,plot1,(/3,2/),resk)

end
