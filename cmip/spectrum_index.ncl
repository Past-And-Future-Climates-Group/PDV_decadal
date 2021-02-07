load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
; load "./wavelet_nino.ncl"
begin

diri = "/glade/work/chenxing/enso/"
diri0 = "/glade/u/home/chenxing/enso/"

wks         = gsn_open_wks("ps",diri0+"spectrum_index") 
plot = new(12, graphic)
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

f0 = addfile(diri+"ERSSTv5_ENSO_index_185401-201912.nc", "r")
epi_obs = f0->epi 
cpi_obs = f0->cpi 
mxi_obs = f0->nino34 

epi_obs_sea = month_to_season(epi_obs, "DJF")
cpi_obs_sea = month_to_season(cpi_obs, "DJF")
mxi_obs_sea = month_to_season(mxi_obs, "DJF")
printVarSummary(epi_obs_sea)


; f0   = addfile(diri+"obs_ipo_1854-2019.nc", "r")
;from obs_ipo.ncl
f0   = addfile(diri+"obs_tpdv_1854-2019.nc", "r")
pco  = f0->pc(0,:)

;--------------MODEL---------------------------------
do im = 1,nmo-1

; f0   = addfile(diri+MODEL(im)+"_ipo_"+yr_finish+".nc", "r")
;from lens_ipo.ncl
f0   = addfile(diri+MODEL(im)+"_tpdv_"+yr_finish+".nc", "r")
pc  = f0->pc(:,0,:)
printVarSummary(pc)

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


print("MODEL "+MODEL(im))
;************************************************
; set function arguments
;************************************************
  d   = 0    ; detrending opt: 0=>remove mean 1=>remove mean + detrend
  sm  = 3   ; smooth: should be at least 3 and odd
  pct = 0.10 ; percent taper: (0.0 <= pct <= 1.0) 0.10 common. 
  val1 = .95
  val2 = .99

;************************************************
; calculate spectrum
;************************************************
II = pc ; conform_dims((/1,dimsizes(pco)/), pco, 1) --> for OBS ; pc ; nino
ndima = dimsizes(II)

  nmissy = ind(.not.ismissing(II(1,:)))
  sdof0 = specx_anal(II(1,nmissy),d,sm,pct) 
  splt0 = specx_ci(sdof0,val1,val2)  ;4*44

SA = sdof0@frq
SB = splt0
;N = 0
SA = 0
SB = 0
printVarSummary(SA)
printVarSummary(SB)
ndim = dimsizes(splt0)


  
fq = conform_dims((/ndima(0),dimsizes(SA)/), SA, (/1/));72
sp = conform_dims((/ndima(0),ndim(0),ndim(1)/), splt0, (/1,2/))
fq@_FillValue = 9.96921e+36
fq = 9.96921e+36
sp@_FillValue = 9.96921e+36
sp = 9.96921e+36

  do ia=0,ndima(0)-1
    spectra_mvf = False
      nmissy = ind(.not.ismissing(II(ia,:)))
      if(.not.all(ismissing(II(ia,:))))then 
        sdof = specx_anal(II(ia,nmissy),d,sm,pct)   ; pc1 is standardized
        splt1 = specx_ci(sdof,val1,val2)
        fq(ia,:) = sdof@frq
        sp(ia,:,:) = splt1
       delete([/splt1,sdof/])
      end if
      delete([/nmissy/])
  end do 

printVarSummary(fq)
printVarSummary(sp)
delete([/II, SA,SB, splt0, sdof0/])

fq_avg = dim_avg_n_Wrap(fq, 0)
sp_avg = dim_avg_n_Wrap(sp, 0)

; ;output
; fon=diri+"obs_spectrum_pdv_index.nc";
; system("rm -f "+fon)
; fo=addfile(fon,"c")
; fo->fq = fq_avg
; fo->sp = sp_avg
; exit
f0 = addfile(diri+"obs_spectrum_pdv_index.nc", "r")
fq_obs = f0->fq 
sp_obs = f0->sp 

;========================================================================

     pres = True
     pres@vpXF = 0.07
     pres@trYMinF = 0.
     pres@trYMaxF = 500.
     pres@trXMinF = 0.0
     pres@trXMaxF = 0.02
     pres@tiYAxisString = "Power"              ; yaxis
     pres@xyLineColor   =  "black"         
     pres@gsnFrame      = False
     pres@gsnDraw       = False
  
     pres@tmXBLabelDeltaF = -.8
     pres@tmXTLabelDeltaF = -.8
     pres@pmLegendDisplayMode    = "Never"
     ; pres@xyLineThicknesses   = (/3.5,2.,1.,1./) 
     pres@xyDashPatterns      = 0; (/0,0,0,0/)
     pres@tmXTOn = False
     pres@tmYROn = False
     pres@tmXTLabelsOn = True
     pres@tmXUseBottom = False
     ; pres@tmXTMode   = "Explicit"  
     ; pres@tmXTValues = (/"0.08","0.06","0.04","0.02","0.01"/);,".0416",".0556",".0832"
     ; pres@tmXTLabels = (/"12.5","16.7","25","50","100"/) ; ,"2","1.5","1"         
     pres@tmXTLabelFontHeightF = 0.018
     pres@tmXBLabelFontHeightF = 0.018
     pres@tmYLLabelFontHeightF = 0.018
     pres@tiYAxisString = "Variance" ;"Power (~S~o~N~C~S~2~N~ / cycles mo~S~-1~N~)"              ; yaxis
     pres@tiXAxisString = "Frequency (month~S~-1~N~)";(cycles mo~S~-1~N~)"
     pres@tiMainString = ""
     pres@txFontHeightF = 0.015
     pres@xyLineLabelFontHeightF = 0.022
     pres@tiXAxisFontHeightF = 0.03
     pres@tiYAxisFontHeightF = 0.03
     pres@tiMainFontHeightF = 0.03
     ; pres@gsnRightStringOrthogonalPosF = -0.115
     ; pres@gsnLeftStringOrthogonalPosF = -0.05
     
     pres@tiMainOn = False
     pres@gsnLeftStringFontHeightF =    pres@tiYAxisFontHeightF
     pres@gsnCenterStringFontHeightF =    pres@tiYAxisFontHeightF
     pres@gsnRightStringFontHeightF  =    pres@tiYAxisFontHeightF - 0.005
     pres@gsnRightString = "";ensemble(ie)
     pres@gsnLeftString = MODEL(im)


        ;each ensemble
        ; pres@trYMaxF = max(sp(:,0,:))*1.1
        pres@xyLineThicknessF   = 0.5
        pres@xyLineColor = "grey40"
        plot(im-1) = gsn_csm_xy(wks,fq,sp(:,0,:),pres)

        ;OBS
        pres@xyLineThicknessF   = 3.0
        pres@xyLineColor = "blue"
        plot1 = gsn_csm_xy(wks,fq_obs, sp_obs(0,:),pres)
        overlay(plot(im-1), plot1)

        delete(pres@xyLineColors)
        delete(pres@xyLineThicknesses)

        ;ensemble mean
        pres@xyLabelMode = "custom"
        pres@xyExplicitLabels = (/"","",val1*100+"%",val2*100+"%"/)
        pres@xyLineColors        = (/"foreground","red","Transparent","green"/)      
        pres@xyLineLabelFontColors = pres@xyLineColors 
        pres@xyLineThicknesses   = (/5.,3.,3.,3./) 
        plot1 = gsn_csm_xy(wks,fq_avg,sp_avg(0,:),pres)
        overlay(plot(im-1), plot1)
        delete([/fq,sp/])

delete([/epi, cpi, mxi, epi_sea, cpi_sea, mxi_sea, pc, pres, fq_avg,sp_avg /])

end do 

  panres = True
  panres@gsnMaximize = True
  panres@gsnPaperOrientation = "portrait"
  panres@gsnPanelYWhiteSpacePercent = 3.0
  panres@pmLabelBarHeightF = 0.05
  panres@pmLabelBarWidthF = 0.55
  panres@lbTitleOn = False
  panres@lbBoxLineColor = "gray70"
  panres@lbLabelFontHeightF = 0.013
     panres@txFontHeightF = 0.02
     panres@gsnPanelBottom = 0.05

  panres@txString = ""; "power spectrum of PC"
  gsn_panel(wks,plot,(/toint(nmo/2),2/),panres)


end 