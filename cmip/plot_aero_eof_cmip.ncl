begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
diri5 = "/glade/scratch/chenxing/cmip5/od550aer/"
diri6 = "/glade/scratch/chenxing/cmip6/od550aer/"
neof = 3


NLAT =  5; 65;60;70;
SLAT =  -5;-70;-60; -50;
WLON =  100;120;100
ELON =  300;290;290;

  yrs5 = 1861
  yrl5 = 2004
  yrs6 = 1850
  yrl6 = 2014

  ymstrt5 = yrs5*100+1  
  ymlast5 = yrl5*100+12
  ymstrt6 = yrs6*100+1  
  ymlast6 = yrl6*100+12

; f1 = addfile(diri+"cmip5_reg_mmemmeeof2_historical_tas_1861-2004.nc", "r")
; v_ref = f1->ccr1
; printVarSummary(v_ref)

;====================================================
;     CMIP5 
;====================================================

;/glade/work/chenxing/enso/cmip6/cmip6_historical_E3SM-1-0_r2i1p1f1_eof_global_od550aer_1850-2014.nc
locs5 = systemfunc("ls "+diri+"cmip5/od550aer/*i1p1_eof_global_od550aer*") ;)
printVarSummary(locs5)
nsa5 = dimsizes(locs5)
print(locs5)

MODEL5 = new(nsa5, "string")
ENS5   = new(nsa5, "string")
pc5 = new((/nsa5,neof,(yrl5-yrs5+1)*12/), "float")
rc5 = new((/nsa5,neof,72,144/), "float")
pcvar5 = new((/nsa5,neof/), "float")

do im = 0,nsa5-2

 locs5_str = str_split(locs5(im), "_"); "/")
 ; print("'" + locs5_str + "'")


  MODEL5(im) = locs5_str(2)
  ENS5(im)  = locs5_str(3)
  
  print(MODEL5(im)+" ens "+ENS5(im))
  
;---------read output---------------
  ;from eof_aero_cmip6.ncl
  f1   = addfile(diri+"cmip5/od550aer/cmip5_historical_"+MODEL5(im)+"_"+ENS5(im)+"_eof_global_od550aer_"+yrs5+"-"+yrl5+".nc", "r")
  pc5(im,:,:)  = f1->pc
  pcvar5(im,:)  = f1->pcvar
  rc5(im,:,:,:) = f1->rc

  ndim = dimsizes(pc5(0,0,:))
  trend1 =  regline(ispan(1, ndim, 1), pc5(im,0,:))          ; slope           
  trend2 =  regline(ispan(1, ndim-(1950-1861)*12, 1), pc5(im,1,(1950-1861)*12:))          ; slope           


  if (trend1.lt.0) then 
  ; if (rc5(im,0,{-60},{210}).lt.0) then 
    rc5(im,0,:,:) = rc5(im,0,:,:)*-1
    pc5(im,0,:)   = pc5(im,0,:)*-1
  end if   
  if (trend2.lt.0) then 
  ; if (rc5(im,1,{30},{110}).gt.0) then 
    rc5(im,1,:,:) = rc5(im,1,:,:)*-1
    pc5(im,1,:)   = pc5(im,1,:)*-1
  end if 
  if (pc5(im,2,(2000-yrs5)*12).gt.0) then 
    rc5(im,2,:,:) = rc5(im,2,:,:)*-1
    pc5(im,2,:)   = pc5(im,2,:)*-1
  end if 

; ;--------read data---------------
;   ;/glade/scratch/chenxing/cmip6/od550aer/CNRM-CM6-1_od550aer_historical_r11i1p1f2.nc
;   f   = addfile(diri5+MODEL5(im)+"_od550aer_historical_"+ENS5(im)+".nc", "r") 
  
;   TIME2=f->time
;   yyyymm2=cd_calendar(TIME2, -1)
;   printMinMax(yyyymm2, True)
;   ymstrts = ind(yyyymm2.eq.ymstrt5)
;   ymlasts = ind(yyyymm2.eq.ymlast5)
  
;       xx  = f->od550aer(ymstrts:ymlasts,:,:);
  
;   ;;check NAN points!!!
;     if (any(ismissing(xx))) then
;       print("there is nan in col")
;       xx = where(ismissing(xx), 0.0, xx)  
;     end if
  
;   xa = rmMonAnnCycTLL(xx)
;   delete([/f,TIME2,yyyymm2/]);,lat,lon


; ;------regression------------

;   pc5(im,:,:) = dim_standardize_n_Wrap(pc5(im,:,:),0,1) ;population standard
  
;   do i = 0,neof-1
;     rc5(im,i,:,:) = regCoef(pc5(im,i,:),xa(lat|:,lon|:,time|:))
;   end do 

;   copy_VarCoords(xa(0,:,:), rc5(im,0,:,:))
;   rc5!1 = "eof"
;   pc5!1 = "eof"
  
;   fon=diri+"cmip5/od550aer/cmip5_historical_"+MODEL5(im)+"_"+ENS5(im)+"_eof_global_od550aer_"+yrs5+"-"+yrl5+".nc";
;   system("rm -f "+fon)
;   fo=addfile(fon,"c")
;   fo->rc = rc5(im,:,:,:)
;   fo->pc = pc5(im,:,:)
;   fo->pcvar = pcvar5(im,:)

end do 
  ; copy_VarMeta(v_ref(0,:,:), rc5(im,0,:,:))

  rc5!0 = "ensemble"
  pc5!0 = "ensemble"

printVarSummary(rc5)
printVarSummary(pc5)

; delete([/xx,xa/])
;====================================================
;     CMIP6
;====================================================

;/glade/work/chenxing/enso/cmip6/cmip6_historical_E3SM-1-0_r2i1p1f1_eof_global_od550aer_1850-2014.nc
locs6 = systemfunc("ls "+diri+"cmip6/od550aer/*i1p1f1_eof_global_od550aer*") ;)
printVarSummary(locs6)
nsa6 = dimsizes(locs6)
print(locs6)

MODEL6 = new(nsa6, "string")
ENS6   = new(nsa6, "string")
pc6 = new((/nsa6,neof,(yrl6-yrs6+1)*12/), "float")
rc6 = new((/nsa6,neof,72,144/), "float")
pcvar6 = new((/nsa6,neof/), "float")

do im = 0,nsa6-2

 locs6_str = str_split(locs6(im), "_"); "/")
 ; print("'" + locs6_str + "'")


  MODEL6(im) = locs6_str(2)
  ENS6(im)  = locs6_str(3)
  
  print(MODEL6(im)+" ens "+ENS6(im))
  
;---------read output---------------
  ;from eof_aero_cmip6.ncl
  f1   = addfile(diri+"cmip6/od550aer/cmip6_historical_"+MODEL6(im)+"_"+ENS6(im)+"_eof_global_od550aer_"+yrs6+"-"+yrl6+".nc", "r")
  pc6(im,:,:)  = f1->pc
  pcvar6(im,:)  = f1->pcvar
  rc6(im,:,:,:)  = f1->rc
  
  ndim = dimsizes(pc6(0,0,:))
  trend1 =  regline(ispan(1, ndim, 1), pc6(im,0,:))          ; slope           
  trend2 =  regline(ispan(1, ndim-(1950-1850)*12, 1), pc6(im,1,(1950-1850)*12:))          ; slope           


  if (trend1.lt.0) then 
  ; if (rc6(im,0,{-60},{210}).lt.0) then 
    rc6(im,0,:,:) = rc6(im,0,:,:)*-1
    pc6(im,0,:)   = pc6(im,0,:)*-1
  end if   
  if (trend2.lt.0) then 
  ; if (rc6(im,1,{30},{110}).gt.0) then 
    rc6(im,1,:,:) = rc6(im,1,:,:)*-1
    pc6(im,1,:)   = pc6(im,1,:)*-1
  end if 
  if (rc6(im,2,{-5},{240}).lt.0) then 
    rc6(im,2,:,:) = rc6(im,2,:,:)*-1
    pc6(im,2,:)   = pc6(im,2,:)*-1
  end if 
; ;--------read data---------------
;   ;/glade/scratch/chenxing/cmip6/od550aer/CNRM-CM6-1_od550aer_historical_r11i1p1f2.nc
;   f   = addfile(diri6+MODEL6(im)+"_od550aer_historical_"+ENS6(im)+".nc", "r") 
  
;   TIME2=f->time
;   yyyymm2=cd_calendar(TIME2, -1)
;   printMinMax(yyyymm2, True)
;   ymstrts = ind(yyyymm2.eq.ymstrt6)
;   ymlasts = ind(yyyymm2.eq.ymlast6)
  
;       xx  = f->od550aer(ymstrts:ymlasts,:,:);
  
;   ;;check NAN points!!!
;     if (any(ismissing(xx))) then
;       print("there is nan in col")
;       xx = where(ismissing(xx), 0.0, xx)  
;     end if
  
;   xa = rmMonAnnCycTLL(xx)
;   delete([/f,TIME2,yyyymm2/]);,lat,lon


; ;------regression------------

;   pc6(im,:,:) = dim_standardize_n_Wrap(pc6(im,:,:),0,1) ;population standard
  
;   do i = 0,neof-1
;     rc6(im,i,:,:) = regCoef(pc6(im,i,:),xa(lat|:,lon|:,time|:))
;   end do 
;   copy_VarCoords(xa(0,:,:), rc6(im,0,:,:))
;   rc6!1 = "eof"
;   pc6!1 = "eof"
  
;   fon=diri+"cmip6/od550aer/cmip6_historical_"+MODEL6(im)+"_"+ENS6(im)+"_eof_global_od550aer_"+yrs6+"-"+yrl6+".nc";
;   system("rm -f "+fon)
;   fo=addfile(fon,"c")
;   fo->rc = rc6(im,:,:,:)
;   fo->pc = pc6(im,:,:)
;   fo->pcvar = pcvar6(im,:)

end do 
  ; copy_VarMeta(v_ref(0,:,:), rc6(im,0,:,:))

  rc6!0 = "ensemble"

  pc6!0 = "ensemble"

printVarSummary(rc6)
printVarSummary(pc6)
; delete([/xx,xa/])


;;----------composite-----------------
com_rc5 = dim_avg_n_Wrap(rc5, 0)
com_pc5 = dim_avg_n_Wrap(pc5, 0)
com_rc6 = dim_avg_n_Wrap(rc6, 0)
com_pc6 = dim_avg_n_Wrap(pc6, 0)
com_pcvar5 = dim_avg_n_Wrap(pcvar5, 0)
com_pcvar6 = dim_avg_n_Wrap(pcvar6, 0)

com_rcd = com_rc5
com_rcd = com_rc6 - com_rc5

com_rc5!0 = "eof"    
com_pc5!0 = "eof"    
com_rc6!0 = "eof"    
com_pc6!0 = "eof"    
com_pcvar5!0 = "eof"    
com_pcvar6!0 = "eof"

;--------output-------------
fon=diri+"cmip5_historical_eof_global_od550aer_mme.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->rc = com_rc5
fo->pc = com_pc5
fo->pcvar = com_pcvar5

fon=diri+"cmip6_historical_eof_global_od550aer_mme.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->rc = com_rc6
fo->pc = com_pc6
fo->pcvar = com_pcvar6

;-----------correlation with PDV--------------------------
;global external forcing mode
; from mme_eof_cmip6.ncl 
  f1   = addfile(diri+"cmip5/cmip5_historical_mme.eof_1861-2004.nc", "r") 
  com_pdv5  = f1->pc(1,:)
  f1   = addfile(diri+"cmip6/cmip6_historical_mme.eof_1850-2014.nc", "r") 
  com_pdv6  = f1->pc(1,:)

; fo   = addfile(diri+"cmip6_historical_pdv_mme.nc", "r") 
; com_pdv = dim_avg_n_Wrap(fo->com_pc,0)
; com_pdv = dim_standardize_n_Wrap(com_pdv, 1, 0)

cor5 = new(neof, "float")
cor6 = new(neof, "float")
do i = 0,neof-1
  cor5(i) = escorc(com_pdv5, com_pc5(i,:));com_pc6(i,(yrs5-yrs6)*12:(yrl5-yrs6+1)*12-1), com_pc5(i,:))
  cor6(i) = escorc(com_pdv6, com_pc6(i,:))
end do 
print(cor5)


print("correlation with EOF2")
print("in CMIP5 is "+cor5(1))
print("in CMIP6 is "+cor6(1))

;-----------calculate specific year of EOF1-------------------------

spe_yr1 = 1980
spe_yr2 = 2000
ie = 0 ;EOF1

com_pc5_annual = month_to_annual(com_pc5(ie,:), 1)
com_pc6_annual = month_to_annual(com_pc6(ie,:), 1)

spe_r51 = com_rc5(0,:,:)
spe_r51 = com_rc5(ie,:,:) * com_pc5_annual(spe_yr1-yrs5) * com_pcvar5(ie)
spe_r61 = com_rc6(0,:,:)
spe_r61 = com_rc6(ie,:,:) * com_pc6_annual(spe_yr1-yrs6) * com_pcvar6(ie)

spe_r52 = com_rc5(0,:,:)
spe_r52 = com_rc5(ie,:,:) * com_pc5_annual(spe_yr2-yrs5) * com_pcvar5(ie)
spe_r62 = com_rc6(0,:,:)
spe_r62 = com_rc6(ie,:,:) * com_pc6_annual(spe_yr2-yrs6) * com_pcvar6(ie)

printVarSummary(spe_r62)


;-------GMST----------------------------

  f1   = addfile(diri+"cmip5_historical_GMST_mme.nc", "r") 
  gmst5  = f1->cp5_a
  f1   = addfile(diri+"cmip6_historical_GMST_mme.nc", "r") 
  gmst6  = f1->cp6_a


;--------------plot-------------------
wks1 = gsn_open_wks("ps", dirip+"cmip_aod_eof");
wks2 = gsn_open_wks("ps", dirip+"cmip_sp_aod_eof");
plot5 = new(10,graphic)                ; create graphic array
plot6 = new(10,graphic)                ; create graphic array
plot = new(10,graphic)                ; create graphic array
gsn_define_colormap(wks1, "BlueWhiteOrangeRed")
gsn_define_colormap(wks2, "WhiteYellowOrangeRed")


res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""
res2@vpWidthF  = 0.4

res2@mpCenterLonF = 0.
res2@mpFillOn = False
res2@mpFillDrawOrder = "PostDraw"
;  res2@mpMaxLatF                   = NLAT         ; choose subregion           
;  res2@mpMinLatF                   = SLAT
;  res2@mpMaxLonF                   = ELON
;  res2@mpMinLonF                   = WLON
res2@gsnAddCyclic = True ;False         
res2@cnFillOn = True;False ;
res2@cnLinesOn = False;True ;
res2@cnLineLabelsOn = False

res2@gsnLeftStringFontHeightF = 0.015
res2@gsnRightStringFontHeightF = res2@gsnLeftStringFontHeightF
res2@lbBoxEndCapStyle = "TriangleBothEnds"
res2@lbOrientation = "Horizontal"
res2@lbBoxLinesOn  = False
res2@lbTitleOn        =  True                ; turn on title
res2@lbLabelStride    = 2
res2@lbTitleString    = ""                ; title string
res2@lbTitlePosition  = "Right"              ; title position
res2@lbTitleFontHeightF= .015                ; make title smaller
; res2@lbTitleDirection = "Across"             
res2@lbTitleExtentF   = 0.01 ;Default: 0.15
res2@lbLabelFontHeightF = 0.01  ;Default: 0.02
; res2@pmLabelBarWidthF = 0.05

res2@lbLabelBarOn = True
res2@cnLevelSelectionMode  = "ManualLevels"    

  res2@cnMinLevelValF        =   0.
  res2@cnMaxLevelValF        =  10.
  res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/20.

  res2@gsnLeftString = spe_yr1+" CMIP5"
  res2@gsnRightString = sprintf("%5.2f", com_pcvar5(ie)) +"% EOF1"
  plot(0) = gsn_csm_contour_map_ce(wks2,spe_r51 , res2)
  res2@gsnLeftString = spe_yr2+" CMIP5"
  plot(1) = gsn_csm_contour_map_ce(wks2,spe_r52 , res2)
  
  res2@gsnRightString = sprintf("%5.2f", com_pcvar6(ie)) +"% EOF1"
  res2@gsnLeftString = spe_yr1+" CMIP6"
  plot(2) = gsn_csm_contour_map_ce(wks2, spe_r61, res2)
  res2@gsnLeftString = spe_yr2+" CMIP6"
  plot(3) = gsn_csm_contour_map_ce(wks2, spe_r62, res2)


do i = 0,1

  res2@cnMinLevelValF        = -0.03
  res2@cnMaxLevelValF        =  0.03 
  res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.
  ee = i+1
  res2@gsnLeftString = "EOF"+ee
  res2@gsnRightString = sprintf("%5.2f", com_pcvar5(i)) +"%"
  plot5(i*2) = gsn_csm_contour_map_ce(wks1,com_rc5(i,:,:) , res2)
  
  res2@gsnRightString = sprintf("%5.2f", com_pcvar6(i)) +"%"
  plot6(i*2) = gsn_csm_contour_map_ce(wks1, com_rc6(i,:,:), res2)

  ; res2@cnMinLevelValF        = -0.02
  ; res2@cnMaxLevelValF        =  0.02 
  ; res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.
  ; res2@gsnRightString = ""
  ; plot(i) = gsn_csm_contour_map_ce(wks6, com_rcd(i,:,:), res2)
end do 


;*******************************************
; time series (principal component) plot
;*******************************************

; these four resources allow the user to stretch the plot size, and
; decide exactly where on the page to draw it.

  res = True
  res@gsnDraw = False        ;dont draw
  res@gsnFrame = False        ;dont advance frame
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@vpHeightF = res2@vpWidthF/2.0  
  res@vpWidthF  = res2@vpWidthF
 
  res@tmXTOn    = False


  res@gsnYRefLine           = 0.0             ; reference line   
  ; res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  ; res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  res@gsnLeftStringFontHeightF  = res2@gsnLeftStringFontHeightF 
  res@gsnRightStringFontHeightF = res2@gsnLeftStringFontHeightF 
  res@trYMinF               = -5.
  res@trYMaxF               =  5.
  res@trXMinF               = 1850
  res@trXMaxF               = 2015

    ndim5  = dimsizes(pc5)
    ndim6  = dimsizes(pc6)
  x_axis5 = fspan(yrs5, yrl5+1, ndim5(2))
  x_axis6 = fspan(yrs6, yrl6+1, ndim6(2))

  ;res@tmXBMode   = "Explicit"                                                
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
res@tiYAxisString = ""
res@tiXAxisString = "year"

res@xyMonoDashPattern = True

do i = 0,1

  ee = i+1

  res@xyLineThicknessF = 1.0
  res@gsnLeftString = "PC"+ee
  res@xyLineColor = "lightblue3"
  res@gsnRightString = "" ;"COR(&CMIP6)="+sprintf("%5.2f", cor5(i))
  plot5(i*2+1) = gsn_csm_xy (wks1,x_axis5,pc5(:,i,:),res)
  ; res@gsnRightString = "COR(&PDV)="+sprintf("%5.2f", cor6(i))
  plot6(i*2+1) = gsn_csm_xy (wks1,x_axis6,pc6(:,i,:),res)
  
  res@xyLineThicknessF = 4.0
  res@xyLineColor = "blue"
  res@gsnLeftString = ""
  res@gsnRightString = ""
  plota = gsn_csm_xy (wks1,x_axis5,com_pc5(i,:),res)
  overlay(plot5(i*2+1), plota)  
  plota = gsn_csm_xy (wks1,x_axis6,com_pc6(i,:),res)
  overlay(plot6(i*2+1), plota)


end do 

  res@xyLineColor = "red"
  plota = gsn_csm_xy (wks1,x_axis6,com_pdv6,res)
  ; overlay(plot6(3), plota)

  res@xyLineColor = "blue"
  plota = gsn_csm_xy (wks1,x_axis5,gmst5,res)
  overlay(plot5(1), plota)  
  plota = gsn_csm_xy (wks1,x_axis5,gmst5,res)
  overlay(plot5(1), plota)  
  plota = gsn_csm_xy (wks1,x_axis6,com_pdv6,res)
  overlay(plot6(1), plota)

;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@lbBoxEndCapStyle = "TriangleBothEnds"
;resk@lbOrientation = "vertical"
resk@lbBoxLinesOn = False
;resk@lbBoxMinorExtentF = 0.2
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02

resk@txString = "CMIP5"
gsn_panel(wks1,plot5,(/2,2/),resk)
resk@txString = "CMIP6"
gsn_panel(wks1,plot6,(/2,2/),resk)    
resk@txString = ""
gsn_panel(wks2,plot,(/2,2/),resk)    


  res@xyLineColors = (/"black","red","blue"/)
  res@tiXAxisString = ""

; do ix = 0,2
;   plot1 = new(40,graphic)                ; create graphic array
;   if (ix.eq.2)then 
;     nn = 8
;   else 
;     nn = 28
;   end if 
;     do iy = 0,nn-1
;     res@gsnLeftString = MODEL5(ix*28+iy)+" "+ENS5(ix*28+iy)
;     res@gsnRightString = ""
;     plot1(iy) = gsn_csm_xy(wks5,x_axis5, pc5(ix*28+iy,:,:), res)
;   end do 

;   resk@txString = ""
;   resk@gsnPanelLabelBar   = False                 ; add common colorbar
;   gsn_panel(wks5,plot1,(/7,4/),resk)    
; end do 

end
