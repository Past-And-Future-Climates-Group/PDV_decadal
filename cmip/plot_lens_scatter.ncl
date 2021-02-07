load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
begin

diri = "/glade/work/chenxing/enso/"
diri0 = "/glade/u/home/chenxing/enso/"

wks         = gsn_open_wks("ps",diri0+"scatter_enso") 
plot = new(12, graphic)
text1 = new(12, graphic)
text2 = new(12, graphic)
text3 = new(12, graphic)

SEASON = (/"DJF","MAM","JJA","SON" /)

ntimes = (/2019-1854, 2011-1850, 2100-1920, 2100-1950, 2100-1850, 2100-1920, 2100-1950, 2099-1850/)+1 ;length of time
ys = (/1854, 1850, 1920, 1950, 1850, 1920, 1950, 1850/) ;start year of datasets
yl = (/2019, 2011, 2100, 2100, 2100, 2100, 2100, 2099/) ;end year of datasets
re_lat = (/ 89, 180, 192, 64, 96, 90, 90, 96/)
re_lon = (/ 180, 360, 288, 128, 192, 144, 144, 192/)
nens = (/1, 11, 40, 50, 30, 20, 30, 100 /) ;ensemble number
nens_all = 100
yr_finish = 2011

MODEL = (/"OBS", "E3SM","CESM","CanESM2", "CSIRO-Mk3-6-0","GFDL-ESM2M","MPI-ESM" /);"GFDL-CM3",
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

f0 = addfile(diri+"GISTEMP_GMST_index_188001-201812.nc", "r")
gmst_obs = f0->gmst(0,:) 
printVarSummary(gmst_obs)
gmst_obs_annual = month_to_annual(gmst_obs, 1)


;from obs_ipo.ncl
; f0   = addfile(diri+"obs_ipo_1854-2019.nc", "r")
;from obs_ipo.ncl
f0   = addfile(diri+"obs_pdv_1880-2018.nc", "r") ;obs_pdv_1854-2019.nc ;_annual
; pco  = f0->pc(0,:)
pco0  = f0->pc(0,:)
pco = pco0(::12)
; pco = (pco0(0::12)+pco0(1::12)+pco0(2::12))/3.0
pco = (pco0(0::12)+pco0(1::12)+pco0(2::12)+pco0(3::12)+pco0(4::12)\
      +pco0(5::12)+pco0(6::12)+pco0(7::12)+pco0(8::12)+pco0(9::12)\
      +pco0(10::12)+pco0(11::12))/12.0
printVarSummary(pco)

;--------------MODEL---------------------------------
do im = 1,nmo-1


;from lens_ipo.ncl
; f0   = addfile(diri+MODEL(im)+"_ipo_"+yr_finish+".nc", "r");annual results
;from lens_ipo.ncl
f0   = addfile(diri+"lens/"+MODEL(im)+"_pdv_"+yr_finish+".nc", "r");monthly results ;_annual
; pc  = f0->pc(:,0,:)
; pc0 = pc
pc0  = f0->pc(:,0,:)
pc = pc0(:,::12)
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

;from gmst_index.ncl
f0 = addfile(diri+"lens/nh-sh/"+MODEL(im)+"_nh-sh_index.nc", "r")
gmst = f0->gmst(:,:(yr_finish+1 - ys(im))*12-1) ;extract historical only
printVarSummary(gmst)

;from gmst_index_pi.ncl
f0 = addfile(diri+"lens/nh-sh/"+MODEL(im)+"_nh-sh_index_picontrol.nc", "r")
gmst_pi0 = f0->gmst
gmst_pi = month_to_annual(gmst_pi0, 1) ;annual GMST index in pi-control
printVarSummary(gmst_pi)

;from lens_ipo_picontrol.ncl
f0   = addfile(diri+"lens/"+MODEL(im)+"_pdv_picontrol.nc", "r");monthly results 
pcp0  = f0->pc(0,:)
pc_pi = month_to_annual(pcp0, 1) ;annual PC in pi-control
delete([/ gmst_pi0,pcp0/])
printVarSummary(pc_pi)

gmst_annual = gmst(:,::12)
epi_sea = epi(:,::12)
cpi_sea = cpi(:,::12)
mxi_sea = mxi(:,::12)

do i = 0,nens_all-1
pc(i,:) = month_to_annual(pc0(i,:), 1)
gmst_annual(i,:) = dim_rmvmean_n_Wrap(month_to_annual(gmst(i,:), 1), 0)
epi_sea(i,:) = dim_rmvmean_n_Wrap( month_to_season(epi(i,:), "DJF"), 0)
cpi_sea(i,:) = dim_rmvmean_n_Wrap( month_to_season(cpi(i,:), "DJF"), 0)
mxi_sea(i,:) = dim_rmvmean_n_Wrap( month_to_season(mxi(i,:), "DJF"), 0)
end do 
printVarSummary(pc)
printVarSummary(gmst_annual)

gmst_annual_avg = dim_avg_n_Wrap(gmst_annual, 0)
pc_avg = dim_avg_n_Wrap(pc, 0)

;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr+1)                            ; odd only
fca   = 1./fyr;*12)
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

mxi_ft = wgt_runave_n_Wrap( mxi_sea, wgt,  -1, 0 )   ;opt < 0 : utilize cyclic conditions 
mxi_obs_ft = wgt_runave_n_Wrap( mxi_obs_sea, wgt,  -1, 0 )   ;opt < 0 : utilize cyclic conditions 
; print(ind(ndtooned(.not.ismissing(mxi_ft))))
print(MODEL(im)+"")
;=========plot=========================

res = True
res@gsnFrame = False
res@gsnDraw  = False

res@xyMarkLineMode     = "Markers"  ; choose which have markers
; res@xyDashPatterns      = 1                      ; solid line 
  res@xyMarker         =  1                      ; choose type of marker  
  res@xyMarkerSizeF     = 0.01                     ; Marker size (default 0.01)
;   res@xyLineThicknesses   = (/1,2/)                ; set second line to 2

res@xyMarkerOpacityF = 1.0
  res@tmYROn                 = False    ; right off
;res@vpWidthF    = 0.5        ; Make plots wider
;res@vpHeightF   = 0.5
res@tmXTOn              = False   ; Turn off top tickmarks
res@tmYLMinorOn         = False   ; Turn off left minor tickmarks
res@tmXMajorGrid                = True
res@tmYMajorGrid                = True
res@tmXMajorGridThicknessF      = 1.0
res@tmYMajorGridThicknessF      = 1.0
res@tmXMajorGridLineDashPattern = 2
res@tmYMajorGridLineDashPattern = 2

res@gsnRightString = ""
res@gsnLeftString = ""
res@gsnLeftStringFontHeightF = 0.03
res@gsnRightStringFontHeightF = 0.03

res@xyMonoMarkerColor  = False ;True ;          ; Allow different colors for markers
 ; res@xyMonoDashPattern        = True              ; all solid 



;colors = read_colormap_file("default") ;("BkBlAqGrYeOrReViWh200");("default");("cosam");"GMT_paired"
  res@xyMarkLineMode     = "Markers"  ; choose which have markers
  ; res@xyMarker         =  9
 
  ; res@xyMarkerColors             = colors;ispan(1, nm+7, 1)

  res@gsnYRefLine = 0;avg(index_pro)
  res@gsnYRefLineThicknessF = 2.
  res@gsnYRefLineDashPattern = 1  
  res@gsnXRefLine = 0;avg(index_vwso)
  res@gsnXRefLineThicknessF = 2.
  res@gsnXRefLineDashPattern = 1  
  res@tiMainString             = ""

res@xyMarkerSizeF = 0.02

res@trXMinF             = -0.8
res@trXMaxF             =  0.8
res@trYMinF             = -3.0
res@trYMaxF             =  3.0

res@tiXAxisString = "NH-SH"
res@tiYAxisString = "PDV"

yr_start = 1950 ; ys(im)
XO = gmst_obs_annual;(yr_start - ys(0):)
YO =             pco;(yr_start - ys(0):)
X  =     gmst_annual;(:,yr_start - ys(im):)
Y  =              pc;(:,yr_start - ys(im):)
XM = gmst_annual_avg;(yr_start - ys(im):)
YM =          pc_avg;(yr_start - ys(im):)
XP =         gmst_pi;(yr_start - ys(im):)
YP =           pc_pi;(yr_start - ys(im):)

  coro = escorc(XO, YO)
  cor = escorc(ndtooned(X), ndtooned(Y))
  corm = escorc(XM, YM)
  corp = escorc(XP, YP)

; ;normalize
; XO = dim_standardize_n_Wrap(XO, 1, 0)
; YO = dim_standardize_n_Wrap(YO, 1, 0)
; X =  dim_standardize_n_Wrap(X , 1, 1)
; Y =  dim_standardize_n_Wrap(Y , 1, 1)
; XM =  dim_standardize_n_Wrap(XM , 1, 0)
; YM =  dim_standardize_n_Wrap(YM , 1, 0)
; XP = dim_standardize_n_Wrap(XP, 1, 0)
; YP = dim_standardize_n_Wrap(YP, 1, 0)

print(escorc_n(X, Y, 1, 1))

res@xyMarkerColor = "grey55"

res@gsnLeftString = "OBS"
; res@gsnRightString = "R="+sprintf("%3.2f", coro)
plot(0) = gsn_csm_xy(wks, XO , YO,res) 


res@gsnLeftString = MODEL(im)
; res@gsnRightString = "R="+sprintf("%3.2f", cor)+" |"+sprintf("%3.2f", corm)+" |"+sprintf("%3.2f", corp)
plot(im) = gsn_csm_xy(wks, X, Y,res) 

res@xyMarkerSizeF = 0.03
res@xyMarkerColor = "blue"
plota = gsn_csm_xy(wks, XP, YP,res) 
overlay(plot(im), plota)
res@xyMarkerColor = "red"
res@xyMarkerSizeF = 0.04
plota = gsn_csm_xy(wks, XM, YM,res) 
overlay(plot(im), plota)


;;regression line
res@gsnLeftString = ""
res@gsnRightString = ""
res@xyMarkLineMode = "Lines"
rco = regline (XO , YO)                  ; linear regression
yregro = rco*XO + rco@yintercept                               ; regression
plot1 = gsn_csm_xy(wks, XO , yregro,res) 
; overlay(plot(0), plot1)

rc = regline (ndtooned(X), ndtooned(Y))                  ; linear regression
yregr = rc*ndtooned(X)+ rc@yintercept                               ; regression
plot1 = gsn_csm_xy(wks, ndtooned(X), yregr,res) 
; overlay(plot(im), plot1)

;************************************************
; Attach text to plot using plot coordinates.
;************************************************
  txres               = True                     ; text mods desired
  txres@txFontHeightF = 0.03                     ; font smaller. default big

  txres@txFontColor = "grey55"
  text1(0)  = gsn_add_text(wks,plot(0),"R="+sprintf("%3.2f", coro),0.55,2.2,txres) 
  text1(im) = gsn_add_text(wks,plot(im),"R ="+sprintf("%3.2f", cor),0.55,2.7,txres) 
  txres@txFontColor = "red"
  text2(im) = gsn_add_text(wks,plot(im),"R_m="+sprintf("%3.2f", corm),0.55,1.7,txres) 
  txres@txFontColor = "blue"
  text3(im) = gsn_add_text(wks,plot(im),"R_pi="+sprintf("%3.2f", corp),0.55,2.2,txres) 

delete([/epi, cpi, mxi, epi_sea, cpi_sea, mxi_sea,mxi_ft, pc, res,\
 rc,yregr, X, Y,XP, YP,XM, YM, pc0,gmst,gmst_annual,gmst_annual_avg,pc_avg,gmst_pi,pc_pi /])
end do 

      resk = True
      resk@txFontHeightF = 0.02
      resk@gsnMaximize = True
      resk@gsnPaperOrientation = "portrait"   ; force portrait

      ; resk@txString  = "start from "+yr_start
      gsn_panel(wks,plot,(/2,toint(nmo/2)/),resk);



end 