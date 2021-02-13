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

nens5 = (/ 40, 50, 30, 20, 30, 100 /) ;ensemble number

EXP = "historical"
IND = "PDI"

nml5 = dimsizes(MODEL)

yrs0 = 1850
yrl0 = 2014;2004
ntime = (yrl0-yrs0+1)*12
; pc_all = new((/nml5,100,ntime/), "float")
pca_lens5 = new((/nml5,ntime/), "float")
pc_lens5 = new((/nml5,max(nens5),ntime/), "float")
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

pca_lens5(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_avg_n_Wrap(pc, 0)
com_std(im,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = dim_stddev_n_Wrap(pc, 0)
pc_lens5(im,:nens5(im)-1,(yrs-yrs0)*12:(yrl-yrs0+1)*12-1) = pc
  delete([/locs,pc,f1,bb,locs_str/] )
end do
printVarSummary(pca_lens5)

;-----------random ensemble---------------------

; ire = 5 ;test 20
nt  = 100;100 ;number of test
neall = 100;40
te = new((/neall/),"float")
ts = new((/neall/),"float")
do ire = 2,neall
  tp = new((/nt,ntime/),"float")
  do i=0,nt-1
    ie   = generate_sample_indices( ire, 1 );method=1: Sample with replacement.
    ; print(ie)
    tp(i,:) = dim_avg_n_Wrap(pc_lens5(5,ie,:),0)
  end do

  ; printVarSummary(tp)
  sta = dim_stddev_n_Wrap(tp,0)
  ts(ire-1)  = dim_avg_n_Wrap(sta,0)
  tpa = dim_avg_n_Wrap(tp,0)
  te(ire-1) = escorc(tpa,pca_lens5(5,:))
  delete([/ie/])
end do

;--------------plot-------------------

wks = gsn_open_wks("png", "test");dirip+
plot1 = new(5,graphic)                ; create graphic array
plot2 = new(5,graphic)                ; create graphic array

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
  res3 = res

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
  x_axis2 = ispan(1, neall, 1)
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

res2 = res
;MODEL
res@xyLineThicknessF = 5.0
res@gsnRightString = pca_lens5@units
  res@xyLineColors = "black"

res2@xyLineThicknessF = 0.5
res2@xyLineColors = "lightblue"

  plot1(0) = gsn_csm_xy (wks,x_axis,pca_lens5(5,:),res)
  plota = gsn_csm_xy (wks,x_axis,pc_lens5(5,:,:),res2)
  overlay(plot1(0),plota)
  res@gsnLeftString = "test ensemble number="+ire
  res@gsnRightString = sprintf("%6.2f",escorc(tpa,pca_lens5(5,:)))
  plot1(1) = gsn_csm_xy (wks,x_axis,tpa,res)
  plota = gsn_csm_xy (wks,x_axis,tp,res2)
  overlay(plot1(1),plota)

  res@xyLineColors = "red"
  plota = gsn_csm_xy (wks,x_axis,pca_lens5(5,:),res)
  overlay(plot1(1),plota)

  res3@xyLineThicknessF = 5
  res4 = res3
  res4@xyLineColors = "red"
  res3@tiXAxisString = "Ens Number"
  res3@tiYAxisString = "Cor"
  res4@tiYAxisString = "STD"
  plot1(2) = gsn_csm_xy2 (wks,x_axis2,te,ts,res3,res4)

;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@txString = IND

gsn_panel(wks,plot1,(/3,1/),resk)

end
