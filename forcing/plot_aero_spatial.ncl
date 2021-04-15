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

diri = "/glade/work/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/data/" ;
dirip = "/glade/u/home/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/pic/" ;


;============read==============================
;------anthropogenic emission---------------

; AER = (/"BC","CO","NH3","NMVOC","NO","OC","SO2" /);"CH4",
EMI = (/"emiss_awb","emiss_wst","emiss_dom","emiss_ene","emiss_ind","emiss_tra"/) ;
; AER2 = (/"BC","CO","NH3","NMVOC","NOx","OC","SO2" /); "CH4",
AER = (/"BC","SO2" /);"CH4",
AER2 = (/"BC","SO2" /); "CH4",
;0: Agriculture; 1: Energy; 2: Industrial; 3: Transportation; 4: Residential, Commercial, Other
;5: Solvents production and application; 6: Waste; 7: International Shipping

na = dimsizes(AER)

yrs0 = 1850
yrl0 = 2014
ntime = (yrl0-yrs0+1)*12

aer5 = new((/na,16,72,144/), "float") ;360,720
aer6 = new((/na,165,72,144/), "float");1850-2014 (bb BC 1850-2015)

do im = 0,na-1

;from aero_index_cmip5.ncl
  f1   = addfile(diri+"aerosol/cmip5_"+AER(im)+"_anthropogenic.nc", "r")
  aa = dim_avg_n_Wrap( f1->emiss,1)
  aer5(im,:,:,:)  = month_to_annual(aa,0)

  ; system("cdo remapbil,r720,360 "+diri+"aerosol/cmip6_"+AER2(im)+"_anthropogenic.nc "+diri+"aerosol/aa.nc")
  ; f1   = addfile(diri+"aerosol/aa.nc", "r")
  f1   = addfile(diri+"aerosol/cmip6_"+AER2(im)+"_anthropogenic.nc", "r")
  ; if(AER2(im).eq."SO2") then
  ;   printVarSummary(f1->emiss)
  ;   aer6(im,:,:,:)  =  f1->emiss
  ; else
    bb = dim_avg_n_Wrap( f1->emiss,1)
    aer6(im,:,:,:)  = month_to_annual(bb,0)
  ; end if

  print(AER(im)+" is done in AA")
end do
printVarSummary(aer5)
printVarSummary(aer6)
printMinMax(aer5,True)
printMinMax(aer6,True)
aer5 = aer5 * 0.000001 * 3600 * 24 * 365 * 0.5*0.5*111000*111000
aer5@units = "Gg/year"
aer6 = aer6 * 0.000001 * 3600 * 24 * 365 * 0.5*0.5*111000*111000
aer6@units = "Gg/year"

year1 = 1950
year2 = 1980
year3 = 2000

a5_1 = dim_avg_n_Wrap(aer5(:,0:toint((year1-yrs0)/10),:,:),1)
a5_2 = dim_avg_n_Wrap(aer5(:,toint((year1-yrs0)/10):toint((year2-yrs0)/10),:,:),1)
a5_3 = dim_avg_n_Wrap(aer5(:,toint((year2-yrs0)/10):toint((year3-yrs0)/10),:,:),1)
a6_1 = dim_avg_n_Wrap(aer6(:,0:toint((year1-yrs0)),:,:),1)
a6_2 = dim_avg_n_Wrap(aer6(:,toint((year1-yrs0)):toint((year2-yrs0)),:,:),1)
a6_3 = dim_avg_n_Wrap(aer6(:,toint((year2-yrs0)):toint((year3-yrs0)),:,:),1)
dif_a1 = a5_1
dif_a1 = a5_1 - a6_1
dif_a2 = a5_2
dif_a2 = a5_2 - a6_2
dif_a3 = a5_3
dif_a3 = a5_3 - a6_3

; ;----------------Biomass burning---------------
;
; BBV = (/"BC","CO","NH3","NMVOC","NOx","OC","SO2"/) ;"CH4",
; BBV2 = (/"BC","CO","NH3","NMVOC","NOx","OC","SO2" /); "CH4",
; ; EMI = (/"grassfire","forestfire"/);
;
; nab = dimsizes(BBV)
; bb5 = new((/nab,16,360,720/), "float")
; bb6 = new((/nab,166,720,1440/), "float");1850-2014 (bb BC 1850-2015)
;
; do im = 0,nab-1
;
;
; ;from aero_index_cmip5.ncl
;   f1   = addfile(diri+"aerosol/cmip5_"+BBV(im)+"_biomassburning.nc", "r")
;   bb5(im,:,:,:)  = dim_avg_n_Wrap( f1->emiss,1)
;
;   ; system("cdo remapbil,r720x360 "+diri+"aerosol/cmip6_"+BBV2(im)+"_biomassburning.nc "+diri+"aerosol/aa.nc")
;   ; f1   = addfile(diri+"aerosol/aa.nc", "r")
;   f1   = addfile(diri+"aerosol/cmip6_"+BBV2(im)+"_biomassburning.nc", "r")
;   bb6(im,:,:,:)  = f1->emiss
;
;   print(BBV(im)+" is done in BB")
;
; end do
; printVarSummary(bb5)
; printVarSummary(bb6)
; bb5 = bb5 * 0.000001 * 3600 * 24 * 365 * 0.5*0.5*111000*111000
; bb5@units = "Gg/year"
; bb6 = bb6 * 0.000001 * 3600 * 24 * 365 * 0.5*0.5*111000*111000
; bb6@units = "Gg/year"
;
; ; dif_b1 = bb5(:,0,:,:)
; ; dif_b1 = bb6(:,toint((year1-yrs0)),:,:) - bb5(:,toint((year1-yrs0)/10),:,:)
; ; dif_b2 = bb5(:,0,:,:)
; ; dif_b2 = bb6(:,toint((year2-yrs0)),:,:) - bb5(:,toint((year2-yrs0)/10),:,:)
; ; dif_b3 = bb5(:,0,:,:)
; ; dif_b3 = bb6(:,toint((year3-yrs0)),:,:) - bb5(:,toint((year3-yrs0)/10),:,:)

;--------------plot-------------------

wks = gsn_open_wks("png", "./aero_spatial");dirip+
plot1 = new(30,graphic)                ; create graphic array
plot2 = new(30,graphic)                ; create graphic array
plot3 = new(30,graphic)                ; create graphic array

gsn_define_colormap(wks, "NCV_blu_red")


res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""
res2@vpWidthF  = 0.6

res2@mpCenterLonF = 180.
res2@mpFillOn = False
res2@mpFillDrawOrder = "PostDraw"
 ; res2@mpMaxLatF                   = NLAT         ; choose subregion
 ; res2@mpMinLatF                   = SLAT
 ; res2@mpMaxLonF                   = ELON
 ; res2@mpMinLonF                   = WLON
res2@gsnAddCyclic = True ;False
res2@cnFillOn = True;False ;
res2@cnLinesOn = False;True ;
res2@cnLineLabelsOn = False

res2@gsnLeftStringFontHeightF = 0.03
res2@gsnRightStringFontHeightF = res2@gsnLeftStringFontHeightF
res2@lbLabelBarOn = True;
res2@lbOrientation = "Vertical"
res2@lbBoxLinesOn  = False
res2@lbTitleOn        =  True                ; turn on title
res2@lbLabelStride    = 2
res2@lbTitleString    = aer5@units                ; title string
res2@lbTitlePosition  = "Top"              ; title position
res2@lbTitleFontHeightF= .015                ; make title smaller
; res2@lbTitleDirection = "Across"
res2@lbTitleExtentF   = 0.01 ;Default: 0.15
res2@lbLabelFontHeightF = 0.01  ;Default: 0.02
; res2@pmLabelBarWidthF = 0.05

rl = (/0.5,10./)
do i = 0,na-1

  res2@cnLevelSelectionMode  = "ManualLevels"
  res2@cnMinLevelValF        = -1*rl(i);-1*ceil(max(abs(a6_1(i,:,:)))/20.) ;-50.
  res2@cnMaxLevelValF        =  rl(i);   ceil(max(abs(a6_1(i,:,:)))/20.) ; 50.
  res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.
  print(res2@cnMinLevelValF)
  print(res2@cnLevelSpacingF)

  res2@gsnRightString = AER2(i);BBV2(i);
  res2@gsnLeftString = "CMIP5"
  plot1(i*3) = gsn_csm_contour_map_ce(wks, a5_1(i,:,:), res2) ;aer5 ;bb5
  res2@gsnLeftString = "CMIP6"
  plot1(i*3+1) = gsn_csm_contour_map_ce(wks, a6_1(i,:,:), res2)
  res2@gsnLeftString = "Dif"
  plot1(i*3+2) = gsn_csm_contour_map_ce(wks, dif_a1(i,:,:), res2)

  res2@gsnRightString = AER2(i);BBV2(i);
  res2@gsnLeftString = "CMIP5"
  plot2(i*3) = gsn_csm_contour_map_ce(wks, a5_2(i,:,:), res2)
  res2@gsnLeftString = "CMIP6"
  plot2(i*3+1) = gsn_csm_contour_map_ce(wks, a6_2(i,:,:), res2)
  res2@gsnLeftString = "Dif"
  plot2(i*3+2) = gsn_csm_contour_map_ce(wks, dif_a2(i,:,:), res2)

  res2@gsnRightString = AER2(i);BBV2(i);
  res2@gsnLeftString = "CMIP5"
  plot3(i*3) = gsn_csm_contour_map_ce(wks, a5_3(i,:,:), res2)
  res2@gsnLeftString = "CMIP6"
  plot3(i*3+1) = gsn_csm_contour_map_ce(wks, a6_3(i,:,:), res2)
  res2@gsnLeftString = "Dif"
  plot3(i*3+2) = gsn_csm_contour_map_ce(wks, dif_a3(i,:,:), res2)
end do

;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
; resk@gsnPanelLabelBar   = True                 ; add common colorbar
resk@lbBoxEndCapStyle = "TriangleBothEnds"
resk@lbOrientation = "Horizontal"
resk@lbBoxLinesOn = False
;resk@lbBoxMinorExtentF = 0.2
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@txString = "Anthropogenic aerosol emissions in 1850-"+year1
; resk@txString = "Biomass burning in "+year1

gsn_panel(wks,plot1,(/na,3/),resk)
resk@txString = "Anthropogenic aerosol emissions in "+year1+"-"+year2
gsn_panel(wks,plot2,(/na,3/),resk)
resk@txString = "Anthropogenic aerosol emissions in "+year2+"-"+year3
gsn_panel(wks,plot3,(/na,3/),resk)

end
