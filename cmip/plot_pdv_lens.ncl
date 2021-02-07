begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
neof = 1

;read obs IPO results
;from obs_ipo.ncl
f0   = addfile(diri+"obs_pdv_1854-2019.nc", "r")
rco  = f0->rc
pco  = f0->pc
pcvaro  = f0->pcvar
printVarSummary(rco)

f0   = addfile(diri+"obs_tpdv_1854-2019.nc", "r")
trco  = f0->rc
tpco  = f0->pc
tpcvaro  = f0->pcvar
printVarSummary(trco)

;;;
cor1 = escorc(ndtooned(pco), ndtooned(tpco))
print("correlation between PDV and TPDV is "+cor1)


NLAT =  5; 65;60;70;
SLAT =  -5;-70;-60; -50;
WLON =  100;120;100
ELON =  300;290;290;

diri1 = "/glade/work/chenxing/enso/E3SM/"
diri2 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/cesm_lens/Amon/ts/"
;ts_Amon_CESM1-CAM5_historical_rcp85_r40i1p1_192001-210012.nc
diri3 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/canesm2_lens/Amon/ts/"
;ts_Amon_CanESM2_historical_rcp85_r50i1p1_195001-210012.nc
diri4 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/csiro_mk36_lens/Amon/ts/"
;ts_Amon_CSIRO-Mk3-6-0_historical_rcp85_r30i1p1_185001-210012.nc
diri5 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/gfdl_cm3_lens/Amon/ts/"
;ts_Amon_GFDL-CM3_historical_rcp85_r20i1p1_192001-210012.nc
diri6 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/gfdl_esm2m_lens/Amon/ts/"
;ts_Amon_GFDL-ESM2M_historical_rcp85_r30i1p1_195001-210012.nc
diri7 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/mpi_lens/Amon/ts/"
;ts_Amon_MPI-ESM_historical_rcp85_r100i1p1_185001-209912.nc


ntimes = (/2019-1854, 2011-1850, 2100-1920, 2100-1950, 2100-1850, 2100-1920, 2100-1950, 2099-1850/)+1 ;length of time
ys = (/1854, 1850, 1920, 1950, 1850, 1920, 1950, 1850/) ;start year of datasets
yl = (/2019, 2011, 2100, 2100, 2100, 2100, 2100, 2099/) ;end year of datasets
re_lat = (/ 89, 180, 192, 64, 96, 90, 90, 96/)
re_lon = (/ 180, 360, 288, 128, 192, 144, 144, 192/)
nens = (/1, 11, 40, 50, 30, 20, 30, 100 /) ;ensemble number
nens_all = 100
yr_finish = 2011

MODEL = (/"OBS", "E3SM","CESM","CanESM2", "CSIRO-Mk3-6-0","GFDL-CM3","GFDL-ESM2M","MPI-ESM" /)
nmo = dimsizes(MODEL)

do im = 1,nmo-1
print("MODEL "+MODEL(im))

;---------read output---------------
;from lens_ipo.ncl
f1   = addfile(diri+"lens/"+MODEL(im)+"_pdv_"+yr_finish+".nc", "r")
rc  = f1->rc
pc  = f1->pc
pcvar  = f1->pcvar
par  = f1->par
; printVarSummary(rc)

f2   = addfile(diri+MODEL(im)+"_tpdv_"+yr_finish+".nc", "r")
trc  = f2->rc
tpc  = f2->pc
tpcvar  = f2->pcvar
tpar  = f2->par
; printVarSummary(trc)

;;;
cor2 = escorc_n(pc(:,0,:), tpc(:,0,:), 1, 1)
print("correlation between PDV and TPDV is "+avg(cor2))

;---------pi-control----------
;from lens_ipo_picontrol.ncl
f1   = addfile(diri+"lens/"+MODEL(im)+"_pdv_picontrol.nc", "r")
rc_pi  = f1->rc;(0,:,:)
pc_pi  = f1->pc;(0,:)
pcvar_pi  = f1->pcvar(0)
printVarSummary(pc_pi)
printVarSummary(rc_pi)

;;----------composite-----------------
com_rc = dim_avg_n_Wrap(rc, 0)
com_pc = dim_avg_n_Wrap(pc, 0)
com_trc = dim_avg_n_Wrap(trc, 0)
com_tpc = dim_avg_n_Wrap(tpc, 0)

std_rc = dim_stddev_n_Wrap(rc, 0)

com_par = avg(par)

;--------------plot-------------------
wks = gsn_open_wks("ps", dirip+MODEL(im)+"_pdv");
wks2 = gsn_open_wks("ps", dirip+"obs_pdv");
plot = new(10,graphic)                ; create graphic array
plot1 = new(10,graphic)                ; create graphic array
gsn_define_colormap(wks, "NCV_blu_red")
gsn_define_colormap(wks2, "NCV_blu_red")


res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""
res2@vpWidthF  = 0.6

res2@mpCenterLonF = 180.
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
res2@lbLabelBarOn = True ;False;
res2@lbOrientation = "Horizontal"
res2@lbBoxLinesOn  = False
res2@lbTitleOn        =  True                ; turn on title
res2@lbLabelStride    = 2
res2@lbTitleString    = "K"                ; title string
res2@lbTitlePosition  = "Right"              ; title position
res2@lbTitleFontHeightF= .015                ; make title smaller
; res2@lbTitleDirection = "Across"             
res2@lbTitleExtentF   = 0.01 ;Default: 0.15
res2@lbLabelFontHeightF = 0.01  ;Default: 0.02
; res2@pmLabelBarWidthF = 0.05

i = 0

res2@cnLevelSelectionMode  = "ManualLevels"    
res2@cnMinLevelValF        = -0.40
res2@cnMaxLevelValF        =  0.40 
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.


res2@gsnLeftString = "PDV"
res2@gsnRightString = sprintf("%5.1f", pcvaro(i)) +"%"
plot1(0) = gsn_csm_contour_map_ce(wks2,rco(i,:,:) , res2)

res2@gsnLeftString = "TPDV"
res2@gsnRightString = sprintf("%5.1f", tpcvaro(i)) +"%"
plot1(2) = gsn_csm_contour_map_ce(wks2,trco(i,:,:) , res2)


res2@gsnLeftString = "historical" ;"PDV"
mpp = dim_avg_n_Wrap(pcvar(:,i), 0)
res2@gsnRightString = sprintf("%5.1f", mpp) +"%"
plot(0) = gsn_csm_contour_map_ce(wks, com_rc(i,:,:), res2)
res2@gsnLeftString = "pi-control" ;"TPDV"
; mpp = dim_avg_n_Wrap(tpcvar(:,i), 0)
res2@gsnRightString = sprintf("%5.1f", pcvar_pi) +"%"
plot(2) = gsn_csm_contour_map_ce(wks, rc_pi, res2);com_trc

res2@cnMinLevelValF        =  0.;
res2@cnMaxLevelValF        =  0.2; 
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.
res2@gsnLeftString = "ensemble STD (EOF"+(i+1)+")"
; plot(1) = gsn_csm_contour_map_ce(wks, std_rc(i,:,:), res2)


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
resk@txString = MODEL(im)

; gsn_panel(wks,plot,(/2,1/),resk)    


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

  ;res2@gsnScale  = True        ; force text scaling               
  ;res@gsnXYBarChart            = True              ; Create bar plot
  ;res@gsnXYBarChartOutlineOnly = True


  res@gsnYRefLine           = 0.0             ; reference line   
  ; res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  ; res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  res@gsnLeftStringFontHeightF  = res2@gsnLeftStringFontHeightF 
  res@gsnRightStringFontHeightF = res2@gsnLeftStringFontHeightF 
 res@trYMinF               = -3.
 res@trYMaxF               =  3.

    ndim  = dimsizes(pc)
    ndimo = dimsizes(pco)
    ndimp = dimsizes(pc_pi)
  x_axis1 = fspan(1854, 2019, ndimo(1))
  x_axis2 = fspan(ys(im), ys(im)+ndim(2)/12.-1, ndim(2))
  x_axis3 = fspan(1, ndimp(1)/12., ndimp(1))
  ;res@tmXBMode   = "Explicit"                                                
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
res@tiYAxisString = ""
res@tiXAxisString = "year"

res@xyMonoDashPattern = True

;MODEL
res@xyLineThicknessF = 1.0
res@gsnLeftString = "PDV"
res@gsnRightString = "Pattern_Cor(hist&obs) = "+sprintf("%5.2f", com_par) ; avg(cor2))
res@xyLineColor = "lightblue3"
plot(1) = gsn_csm_xy (wks,x_axis2,pc(:,0,:),res)
res@gsnRightString = ""
; res@gsnLeftString = "TPDV"
; plot(3) = gsn_csm_xy (wks,x_axis2,tpc(:,0,:),res)

res@xyLineThicknessF = 2.0
res@xyLineColor = "blue"

res@gsnLeftString = ""
plota = gsn_csm_xy (wks,x_axis2,com_pc(0,:),res)
overlay(plot(1), plota)
; plota = gsn_csm_xy (wks,x_axis2,com_tpc(0,:),res)
; overlay(plot(3), plota)


;OBS
res@gsnRightString = "COR = "+sprintf("%5.2f", cor1)
res@gsnLeftString = "PDV"
plot1(1) = gsn_csm_xy (wks2,x_axis1,pco(0,:),res)
; res@xyLineColor = "blue"
res@gsnLeftString = "TPDV"
res@gsnRightString = ""
plot1(3) = gsn_csm_xy (wks2,x_axis1,tpco(0,:),res)

res@gsnLeftString = "PDV"
res@xyLineColor = "black"
res@gsnRightString = "Pattern_Cor(hist&pi) = "+sprintf("%5.2f", pattern_cor(com_rc(i,:,:), rc_pi, 1.0, 0)) ; avg(cor2))
plot(3) = gsn_csm_xy (wks,x_axis3,pc_pi(0,:),res)

;;legend
  gres = True
  gres@YPosPercent = 95.    ; expressed as %, 0->100, sets position of top border of legend 
                            ;  when gres@Position is set to its default setting of "Top" (Default = 95.)
  gres@XPosPercent = 5      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)

  lineres = True
  lineres@lgLineColors = (/"black","blue"/) ; line colors
  lineres@lgLineThicknesses = 2.5                        ; line thicknesses
  lineres@LineLengthPercent = 9.                         ; expressed as %, 0->100, length of line

  textres = True
  textres@lgLabels = (/"PDV","TPDV"/)  ; legend labels (required)

  ; plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)
  ; plot(3) = simple_legend(wks,plot(3),gres,lineres,textres)

;------------------------------------------------
gsn_panel(wks,plot,(/2,2/),resk)
resk@txString = "ERSSTv5"
gsn_panel(wks2,plot1,(/2,2/),resk)    

delete([/ndim,ndimo, pc, rc, trc, tpc, cor2,pcvar, par, com_rc, rc_pi, pc_pi,\
       com_pc, com_trc, com_tpc, std_rc, x_axis1, x_axis2,x_axis3, res, res2/])
end do 
end
