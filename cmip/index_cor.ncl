load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
begin

diri = "/glade/work/chenxing/enso/"
diri0 = "/glade/u/home/chenxing/enso/"

wks         = gsn_open_wks("ps",diri0+"cross_cor") 
plot = new(12, graphic)
plot1 = new(12, graphic)
text = new(12, graphic)

SEASON = (/"DJF","MAM","JJA","SON" /)

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

;--------------OBS---------------------------------
;from nino_index.ncl
f0 = addfile(diri+"ERSSTv5_ENSO_index_185401-201912.nc", "r")
epi_obs = f0->epi 
cpi_obs = f0->cpi 
mxi_obs = f0->nino34 

epi_obs_sea = month_to_season(epi_obs, "DJF")
cpi_obs_sea = month_to_season(cpi_obs, "DJF")
mxi_obs_sea = month_to_season(mxi_obs, "DJF")
printVarSummary(epi_obs_sea)


;from obs_ipo.ncl
; f0   = addfile(diri+"obs_ipo_1854-2019.nc", "r")
;from obs_ipo.ncl
f0   = addfile(diri+"obs_tpdv_1854-2019.nc", "r")
pco  = f0->pc(0,:)
; pco = pco0(::12)
; pco = (pco0(0::12)+pco0(1::12)+pco0(2::12))/3.0
printVarSummary(pco)

;--------------MODEL---------------------------------
do im = 1,nmo-1


;from lens_ipo.ncl
f1   = addfile(diri+"lens/"+MODEL(im)+"_pdv_"+yr_finish+".nc", "r") ;pdv ;tpdv
pc  = f1->pc(:,0,:)
; pc = pc0(:,::12)
; pc = (pc0(:,0::12)+pc0(:,1::12)+pc0(:,2::12)+pc0(:,3::12)+pc0(:,4::12)\
;       +pc0(:,5::12)+pc0(:,6::12)+pc0(:,7::12)+pc0(:,8::12)+pc0(:,9::12)\
;       +pc0(:,10::12)+pc0(:,11::12))/12.0
printVarSummary(pc)

;from nino_index.ncl
f0 = addfile(diri+MODEL(im)+"_ENSO_index.nc", "r")
epi = f0->epi(:,:(yr_finish+1 - ys(im))*12-1) ;extract historical only
cpi = f0->cpi(:,:(yr_finish+1 - ys(im))*12-1) 
mxi = f0->nino34(:,:(yr_finish +1- ys(im))*12-1) 
printVarSummary(mxi)

epi_sea = epi(:,::12)
cpi_sea = cpi(:,::12)
mxi_sea = mxi(:,::12)

do i = 0,nens_all-1
epi_sea(i,:) = dim_rmvmean_n_Wrap( month_to_season(epi(i,:), "DJF"), 0)
cpi_sea(i,:) = dim_rmvmean_n_Wrap( month_to_season(cpi(i,:), "DJF"), 0)
mxi_sea(i,:) = dim_rmvmean_n_Wrap( month_to_season(mxi(i,:), "DJF"), 0)
end do 
printVarSummary(epi_sea)


;************************************************
; calculate cross correlations
;************************************************

mxlag = 20*12

X = pc(ensemble|:,time|:)
Y = cpi(ensemble|:,time|:)

x_Lead1 = esccr(X,Y,mxlag) ;X lead
y_Lead1 = esccr(Y,X,mxlag) ;X lag
x_Lead1!0 = "ensemble"
x_Lead1!1 = "time"
copy_VarMeta(x_Lead1, y_Lead1)

ccr = new((/2*mxlag+1, nens_all /), "float") ;cross correlation pattern
ccr(0:mxlag-1,:) = y_Lead1(time|1:mxlag:-1,ensemble|:)  ; "negative lag", -1 reverses order
ccr(mxlag:,:)    = x_Lead1(time|0:mxlag,ensemble|:)     ; "positive lag"

;self-correlation
acr   = esacr(X,mxlag) 
acr!0 = "ensemble"
acr!1 = "time"

ccr_avg = dim_avg_n_Wrap(ccr(ensemble|:,time|:), 0)
acr_avg = dim_avg_n_Wrap(acr(ensemble|:,time|:), 0)

delete([/x_Lead1,y_Lead1,X,Y /])
printVarSummary(ccr)
printVarSummary(acr)

;OBS
x_Lead1 = esccr(pco,cpi_obs,mxlag) ;X lead
y_Lead1 = esccr(mxi_obs,pco,mxlag) ;X lag
x_Lead1!0 = "time"
copy_VarMeta(x_Lead1, y_Lead1)

ccr_obs = new((/2*mxlag+1 /), "float") ;cross correlation pattern
ccr_obs(0:mxlag-1) = y_Lead1(time|1:mxlag:-1)  ; "negative lag", -1 reverses order
ccr_obs(mxlag:)    = x_Lead1(time|0:mxlag)     ; "positive lag"

;self-correlation
acr_obs   = esacr(pco,mxlag) 
acr_obs!0 = "time"
delete([/x_Lead1,y_Lead1 /])

; ;cross-correlation --> that is lead-lag correlation
; crc_e3sm = new((/dimsizes(nino_e3sm),dimsizes(nino_e3sm)/), typeof(nino_e3sm), nino_e3sm@_FillValue)

;     mxlag = 200
; mcr_e3sm = new((/ndime,mxlag+1/), typeof(nino_e3sm), nino_e3sm@_FillValue)
; do it = 0,ndime-1
;     mcr_e3sm(it,:)   = esacr(nino_e3sm(it:),mxlag) ; acr(mxlag+1)
; end do 



; nst = 30 ;sliding month
; ; ne_e3sm = new((/(ndime_yr+nst)*12/), typeof(nino_e3sm), nino_e3sm@_FillValue)
; ; ne_e3sm(nst*12/2:(nst/2+ndime_yr)*12-1) = nino_e3sm

; ; mcr_e3sm = new((/ndime_yr,ndime_yr/), typeof(nino_e3sm), nino_e3sm@_FillValue)

; ; do ix = 0,ndime_yr-1
; ;     do iy = 0,ndime_yr-1
; ;         mcr_e3sm(ix,iy) = escorc(ne_e3sm(ix*12:(ix+nst)*12-1), ne_e3sm(iy*12:(iy+nst)*12-1))
; ;     end do 
; ; end do 

; ne_e3sm = new((/(ndime_yr+nst)/), typeof(nino_e3sm), nino_e3sm@_FillValue)
; ne_e3sm(nst/2:(nst/2+ndime_yr)-1) = nino_e3sm_djf

; mcr_e3sm = new((/ndime_yr,ndime_yr/), typeof(nino_e3sm), nino_e3sm@_FillValue)

; do ix = 0,ndime_yr-1
;     do iy = 0,ndime_yr-1
;         mcr_e3sm(ix,iy) = escorc(ne_e3sm(ix:(ix+nst)-1), ne_e3sm(iy:(iy+nst)-1))
;     end do 
; end do 

; mcr_e3sm!0 = "time1"
; mcr_e3sm!1 = "time2"
; printVarSummary(mcr_e3sm)

; aa = month_to_annual(mcr_e3sm, 1)
; printVarSummary(aa)
; acr_e3sm = month_to_annual(aa(time2|:,year|:), 1)
; printVarSummary(acr_e3sm)

;=========plot=========================

  ; res          = True
  ; res@gsnFrame = False
  ; res@gsnDraw  = False

  ; res@vpWidthF  = 0.7

  ; res@gsnAddCyclic         = True
  ; res@gsnLeftString = ""
  ; res@gsnRightString = ""

  ; res@cnFillOn             = True         ; turn on color fill
  ; res@cnLinesOn            = False         ; True is default
  ; res@cnLineLabelsOn       = False

  ; res@lbOrientation = "vertical"

  ; res@lbLabelBarOn = True ;False;
  ; res@cnFillPalette         =  "BlueWhiteOrangeRed"   ; choose colormap
  
  ;     ;  res@cnLevelSelectionMode  = "ManualLevels"
  ;     ; res@cnMinLevelValF        =   -1.0
  ;     ; res@cnMaxLevelValF        =    1.0 
  ;     ; res@cnLevelSpacingF       =  res@cnMaxLevelValF/5.
  ;     res@gsnRightString = "cross autocorrelation"
  ;     plot(0)   = gsn_csm_contour(wks,mcr_e3sm,res)
        


;;;;=======XY plot===================================================
  x_axis = ispan(0, mxlag, 1)
  x_axis2 = ispan(-mxlag, mxlag, 1)
  printVarSummary(x_axis2)

  res                    = True              ; plot mods desired
  res@gsnDraw            = False             ; don't draw yet
  res@gsnFrame           = False             ; don't advance frame yet
  res@gsnPaperOrientation = "portrait"   ; force portrait
  res@vpWidthF  = 0.7
  res@vpHeightF = 0.3
  res@tmXTOn              = False   ; Turn off top tickmarks
  res@tmYLMinorOn         = False   ; Turn off left minor tickmarks
  res@tmYROn              = False

  res@gsnYRefLine = 0
  res@gsnXRefLine = 0


  ; res@gsnRightString = "auto correlation"
  ; plot(2) = gsn_csm_xy(wks,x_axis2,acr,res)   ;

  ; res@trYMaxF   =  2.0 
  ; res@trYMinF   = -2.0 
  ; res@trXMinF = -13;half_p
  ; res@trXMaxF =  13;half_p
  res@tmXBMode     = "Explicit"        
  res@tmXBValues   = x_axis2(::5*12)   
  res@tmXBLabels   = ispan(-mxlag/12,mxlag/12, 5)
  ; res@tmXBMinorValues = ispan(f_yrs,f_yrl+1,1)



; ; Set special resources for the time axis
;   resTick                = True
;   resTick@ttmFormat      = "%Y"
;   resTick@ttmAxis        = "XB" ;
;   resTick@ttmMajorStride = 10*12

;   time_axis_labels( nino_e3sm&time,  res, resTick )

res@trYMinF = -0.4
res@trYMaxF =  0.6

res@tiXAxisString = "year"

  res@xyLineThicknessF = 1.0 
  res@xyLineColor = "lightblue3"
  res@gsnRightString = "PC lead CP index"
  res@gsnLeftString = "CP lead PC"
  res@tiYAxisString  = "Cor"
  res@gsnCenterString = MODEL(im)
  plot(im) = gsn_csm_xy(wks,x_axis2,ccr(ensemble|:,time|:),res)   ;

  res@xyLineThicknessF = 4.0
  res@xyLineColor = "blue"
  plota = gsn_csm_xy(wks, x_axis2, ccr_avg, res)
  overlay(plot(im), plota)
  res@gsnCenterString = "ERSSTv5"
  plot(0) = gsn_csm_xy(wks,x_axis2,ccr_obs,res)   ;


res@trYMinF = -1.0
res@trYMaxF =  1.0

  res@gsnLeftString = ""
  res@gsnRightString = "Self correlation"
  res@gsnCenterString = "ERSSTv5"
  plot1(0) = gsn_csm_xy(wks,x_axis,acr_obs,res)   ;
  res@gsnCenterString = MODEL(im)
  plota = gsn_csm_xy(wks, x_axis, acr_avg, res)
  res@xyLineThicknessF = 1.0 
  res@xyLineColor = "lightblue3"
  plot1(im) = gsn_csm_xy(wks,x_axis,acr(ensemble|:,time|:),res)   ;
  overlay(plot1(im), plota)

      resk = True
      resk@txFontHeightF = 0.02
      resk@gsnMaximize = True
      resk@gsnPaperOrientation = "portrait"   ; force portrait

      resk@txString  = "OBS" ;"CESM en"+ea
      ; gsn_panel(wks,(/plot(3),plot(1)/),(/2,1/),resk);
      ; gsn_panel(wks,(/plot/),(/4,1/),resk);

delete([/epi, cpi, mxi, epi_sea, cpi_sea, mxi_sea, pc, res /])
end do 

      resk = True
      resk@txFontHeightF = 0.02
      resk@gsnMaximize = True
      resk@gsnPaperOrientation = "portrait"   ; force portrait

      resk@txString  = ""
      gsn_panel(wks,plot,(/4,2/),resk);
      gsn_panel(wks,plot1,(/4,2/),resk);


end 