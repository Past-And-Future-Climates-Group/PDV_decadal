begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

;--------read-------------
;cmip6_historical_CanESM5_r14i1p1f1_global_index_od550aer_1850-2014.nc
fon1 = systemfunc("ls "+diri+"cmip5/od550aer/global_index/cmip5_historical_*_global_index_od550aer_1861-2004.nc")
print(fon1)
f1 = addfiles(fon1,"r")
ListSetType (f1, "join")        ; concatenate (=default)
global5 = f1[:]->index

fon1 = systemfunc("ls "+diri+"cmip5/od550aer/global_index/cmip5_historical_*_NP_index_od550aer_1861-2004.nc")
f1 = addfiles(fon1,"r")
ListSetType (f1, "join")        ; concatenate (=default)
npi5 = f1[:]->index

fon2 = systemfunc("ls "+diri+"cmip6/od550aer/global_index/cmip6_historical_*_global_index_od550aer_1850-2014.nc")
print(fon2)
f1 = addfiles(fon2,"r")
ListSetType (f1, "join")        ; concatenate (=default)
global6 = f1[:]->index

fon2 = systemfunc("ls "+diri+"cmip6/od550aer/global_index/cmip6_historical_*_NP_index_od550aer_1850-2014.nc")
f1 = addfiles(fon2,"r")
ListSetType (f1, "join")        ; concatenate (=default)
npi6 = f1[:]->index
printVarSummary(npi6)
printVarSummary(npi5)

  ndim5o  = dimsizes(global5)
  ndim6o  = dimsizes(global6)


;-------------------------------------

;monthly to annual

g5_an = global5(:,::12)
n5_an = global5(:,::12)
do i = 0,ndim5o(0)-1
  g5_an(i,:) = month_to_annual(global5(i,:), 1)
  n5_an(i,:) = month_to_annual(npi5(i,:), 1)
end do 

g6_an = global6(:,::12)
n6_an = global6(:,::12)
do i = 0,ndim6o(0)-1
  g6_an(i,:) = month_to_annual(global6(i,:), 1)
  n6_an(i,:) = month_to_annual(npi6(i,:), 1)
end do 



  ndim5  = dimsizes(g5_an)
  ndim6  = dimsizes(g6_an)


;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*2+1) ;fyr)+1 ;                           ; odd only
fca   = 1./(fyr););
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

global5_ft = wgt_runave_n_Wrap( g5_an, wgt,  -1, 1 )   ;opt < 0 : utilize cyclic conditions 
global6_ft = wgt_runave_n_Wrap( g6_an, wgt,  -1, 1 )   ;opt < 0 : utilize cyclic conditions 
npi5_ft = wgt_runave_n_Wrap( n5_an, wgt,  -1, 1 )   ;opt < 0 : utilize cyclic conditions 
npi6_ft = wgt_runave_n_Wrap( n6_an, wgt,  -1, 1 )   ;opt < 0 : utilize cyclic conditions 

;-----sliding variance------------

nsyr = 20 ;sliding year 
nsyr2 = nsyr/2

var_g5 = g5_an;(:,nsyr:)
var_g5 = g5_an@_FillValue
var_n5 = var_g5

do i = nsyr2,ndim5(1)-1-nsyr2-1

  var_g5(:,i) = dim_variance_n_Wrap(g5_an(:,i-nsyr2:i+nsyr2-1) , 1)
  var_n5(:,i) = dim_variance_n_Wrap(n5_an(:,i-nsyr2:i+nsyr2-1) , 1)

end do 

printVarSummary(var_g5)

var_g6 = g6_an;(:,nsyr:)
var_g6 = g6_an@_FillValue
var_n6 = var_g6

do i = nsyr2,ndim6(1)-1-nsyr2-1

  var_g6(:,i) = dim_variance_n_Wrap(g6_an(:,i-nsyr2:i+nsyr2-1) , 1)
  var_n6(:,i) = dim_variance_n_Wrap(n6_an(:,i-nsyr2:i+nsyr2-1) , 1)

end do 

printVarSummary(var_g6)

delete([/ndim5,ndim6/])
;===================================================
;;----------composite-----------------

X5 = global5 ; g5_an ; var_g5
X6 = global6 ; g6_an ; var_g6
Y5 = npi5 ; n5_an ; var_n5
Y6 = npi6 ; n6_an ; var_n6


  ndim5  = dimsizes(X5)
  ndim6  = dimsizes(X6)

;--------read model names----------

;CMIP5
nsa5 = dimsizes(fon1)
MODEL5 = new(nsa5, "string")
ENS5  = new(nsa5, "string")

;each model ensemble mean
em_g5 = new((/30,ndim5(1)/), typeof(X5), X5@_FillValue)
em_n5 = new((/30,ndim5(1)/), typeof(X5), X5@_FillValue)
ia = 0 ;count model number
ib = 0. ;count ensemble number for each model
aa = X5(0,:)
aa = 0.
bb = aa
do im = 0,nsa5-1

 locs_str = str_split(fon1(im), "_"); "/")
 ; print("'" + locs_str + "'")

MODEL5(im) = locs_str(3)
ENS5(im)  = locs_str(4)

;calculate each model mean
if (im.gt.0.and.MODEL5(im).ne.MODEL5(im-1)) then 
  em_g5(ia,:) = aa/ib
  em_n5(ia,:) = bb/ib
  ia = ia+1
  aa = 0.
  bb = 0.
  ib = 0.
end if 

aa = aa + X5(im,:)
bb = bb + Y5(im,:)
ib = ib + 1.

if (im.eq.nsa5-1) then 
  em_g5(ia,:) = aa/ib
  em_n5(ia,:) = bb/ib
  ia = ia+1
end if 

end do 
print(ia+" models in CMIP5")
delete([/aa,bb/])

;CMIP6
nsa6 = dimsizes(fon2)
MODEL6 = new(nsa6, "string")
ENS6  = new(nsa6, "string")

;each model ensemble mean
em_g6 = new((/30,ndim6(1)/), typeof(X6), X6@_FillValue)
em_n6 = new((/30,ndim6(1)/), typeof(X6), X6@_FillValue)
ia = 0 ;count model number
ib = 0. ;count ensemble number for each model
aa = X6(0,:)
aa = 0.
bb = aa
do im = 0,nsa6-1

 locs_str = str_split(fon2(im), "_"); "/")
 ; print("'" + locs_str + "'")

MODEL6(im) = locs_str(3)
ENS6(im)  = locs_str(4)

;calculate each model mean
if (im.gt.0.and.MODEL6(im).ne.MODEL6(im-1)) then 
  em_g6(ia,:) = aa/ib
  em_n6(ia,:) = bb/ib
  ia = ia+1
  aa = 0.
  bb = 0.
  ib = 0.
end if 

aa = aa + X6(im,:)
bb = bb + Y6(im,:)
ib = ib + 1.

if (im.eq.nsa6-1) then 
  em_g6(ia,:) = aa/ib
  em_n6(ia,:) = bb/ib
  ia = ia+1
end if 

end do 
print(ia+" models in CMIP6")

com_global5 = dim_avg_n_Wrap(em_g5, 0) ;X5, 0)
com_global6 = dim_avg_n_Wrap(em_g6, 0) ;X6, 0)
com_npi5    = dim_avg_n_Wrap(em_n5, 0) ;Y5, 0)
com_npi6    = dim_avg_n_Wrap(em_n6, 0) ;Y6, 0)
printVarSummary(com_global6)

; ; ;1. averaged STD across ensembles 
; cs_a = dim_avg_n_Wrap(com_std, 0)
; ;2. STD across 8 model mean 
; ; cs_a = dim_stddev_n_Wrap(com_pc, 0)


;--------------plot-------------------

wks = gsn_open_wks("ps", dirip+"cmip_aero_xy");
plot = new(10,graphic)                ; create graphic array


;*******************************************
; time series (principal component) plot
;*******************************************

  gsn_define_colormap(wks,"amwg")
  colors = ispan(2, 15, 1)   ; indices into color table


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
  res@trXMinF               = 1850
  res@trXMaxF               = 2014

  x_axis5 = fspan(1861, 2004, ndim5(1))
  x_axis6 = fspan(1850, 2014, ndim6(1))
  ;res@tmXBMode   = "Explicit"                                                
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
  res@tiYAxisString = ""
  res@tiXAxisString = "year"
  
  res@xyLineColor = "grey66"
  res@xyMonoLineColor = False
  res@xyMonoDashPattern = True


  res@trYMinF               = -0.05
  res@trYMaxF               =  0.10
;MODEL
res@xyLineThicknessF = 0.5
res@gsnLeftString = "global averaged"
res@gsnRightString = "CMIP5"
plot(0) = gsn_csm_xy (wks,x_axis5,em_g5,res)
res@gsnRightString = "CMIP6"
plot(1) = gsn_csm_xy (wks,x_axis6,em_g6,res)
res@gsnLeftString = "North Pacific Ocean"
  ; res@trYMaxF               =  0.2
res@gsnRightString = "CMIP5"
plot(2) = gsn_csm_xy (wks,x_axis5,em_n5,res)
res@gsnRightString = "CMIP6"
plot(3) = gsn_csm_xy (wks,x_axis6,em_n6,res)

res@xyLineThicknessF = 2.0
res@xyLineColor = "black"

res@gsnLeftString = ""
res@gsnRightString = ""
  ; res@trYMaxF               =  0.1
plota = gsn_csm_xy (wks, x_axis5, com_global5, res)
overlay(plot(0), plota)
plota = gsn_csm_xy (wks, x_axis6, com_global6, res)
overlay(plot(1), plota)
  ; res@trYMaxF               =  0.2
plota = gsn_csm_xy (wks, x_axis5, com_npi5, res)
overlay(plot(2), plota)
plota = gsn_csm_xy (wks, x_axis6, com_npi6, res)
overlay(plot(3), plota)



; ;---------shading of STD---------

;   delete(res@xyLineColors)
;   res@xyLineColor     = -1                           ; We don't want the line, so make it trax_axisparent.
;   mmz = com_pc(0:1,:)
;   mmz(0,:) = cp_a-cs_a
;   mmz(1,:) = cp_a+cs_a

;   res@gsnXYFillOpacities = 0.3
;   res@gsnXYFillColors = "grey55"
;   res@xyCurveDrawOrder = "PreDraw"
;   plota  = gsn_csm_xy (wks,(/x_axis2/),mmz(0:1,:),res)  ; Create filled XY plot.
;   overlay(plot(0), plota)

;   res@xyLineThicknessF = 2.0
; do im = 0,nmo-1 
;   res@gsnLeftString = MODEL(im)
;   res@xyLineColor     = colors(im)
;   plot1(im) = gsn_csm_xy (wks,x_axis2,com_pc(im,:),res)
; end do 


; ;---------------------------------
; ; Set up resources for a customized legend.
; ;
;   lgres                    = True
;   lgres@lgLineThicknessF   = 2.0
;   lgres@lgItemType         = "Lines"        ; show lines only (default)
;   lgres@lgLabelFontHeightF = .1            ; legend label font thickness
;   lgres@vpWidthF           = 0.20           ; width of legend (NDC)
;   lgres@vpHeightF          = 0.30           ; height of legend (NDC)
;   ; lgres@lgPerimThicknessF  = 2.0            ; thicken the box perimeter
;   lgres@lgPerimOn          = False
;  ; lgres@lgPerimFill = 0
;  ; lgres@lgPerimFillColor = 0
;   lgres@lgPerimFill            = "SolidFill"      ; Fill legend box w/white
;   lgres@lgPerimFillColor       = "white"          ; so it masks XY curves

;   lgres@lgMonoDashIndex = True
;   lgres@lgDashIndexes = (/0,0,0,0,0,0,0,0/)
;   lgres@lgLineColors       = colors(::-1)
;   labels = MODEL(::-1)+"("+nens(::-1)+")"
;   nitems = dimsizes(labels)                 ; number of legend items

;   lbid = gsn_create_legend(wks,nitems,labels,lgres)


; ; Use gsn_add_annotation to attach this legend to our existing plot.
; ; This way, if we resize the plot, the legend will stay with the
; ; plot and be resized automatically.
; ;
;   amres                  = True

;   amres@amJust           = "BottomLeft"    ; Use bottom right corner of box
;                                             ; for determining its location.
;   amres@amParallelPosF   =  0.5              ; Move legend to right
;   amres@amOrthogonalPosF =  0.5              ; Move legend down.

;   annoid = gsn_add_annotation(plot(0),lbid,amres)  ; add legend to plot

;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@txString = "AOD "

gsn_panel(wks,plot,(/2,2/),resk)


;plot each model ensemble
res@xyLineThicknessF = 0.5
;CMIP5 
do ix = 0,2
  plot1 = new(40,graphic)                ; create graphic array
  if (ix.eq.2)then 
    nn = 28
  else 
    nn = 32
  end if 
    do iy = 0,nn-1
    res@gsnLeftString = MODEL5(ix*32+iy)+" "+ENS5(ix*32+iy)
    plot1(iy) = gsn_csm_xy(wks, x_axis5,Y5(ix*32+iy,:), res)
  end do 

  resk@txString = "CMIP5"
  gsn_panel(wks,plot1,(/8,4/),resk)    
end do 

;CMIP6
do ix = 0,3
  plot1 = new(40,graphic)                
  if (ix.eq.3)then 
    nn = 5
  else 
    nn = 32
  end if 
    do iy = 0,nn-1
    res@gsnLeftString = MODEL6(ix*32+iy)+" "+ENS6(ix*32+iy)
    plot1(iy) = gsn_csm_xy(wks, x_axis6,Y6(ix*32+iy,:), res)
  end do 

  resk@txString   = "CMIP6"                
  gsn_panel(wks,plot1,(/8,4/),resk)    
end do 


end
