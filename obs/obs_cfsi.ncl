load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/run_cor.ncl"
; Nino 1+2 (0-10S, 90W-80W), Nino 3 (5N-5S, 150W-90W), 
; Nino 3.4/ONI (5N-5S, 170W-120W) and Nino 4 (5N-5S, 160E-150W)
; TNI is Nino 1+2 - Nino 4
begin
diri = "./"
diri0 = "/nuist/scratch/lidongliang1208/zhanglu/xc/data_obs/" 

NLAT =   40
SLAT =  -40
WLON =  0    ;
ELON =  360;150   ;

NLAT1 =  5
SLAT1 = -5
WLON1 = 190
ELON1 = 240

  ymstrt = 198101
  ymlast = 200012
  yrstrt = 1981
  yrlast = 2000

SEASON = (/"DJF","MAM","JJA","SON" /)

;-----El Nino cases---------------------
f2 = addfile("./obs.ersstv5.nino34.1854-2019.nc", "r")
nino34 = f2->index
printVarSummary(nino34)
nino34!0 = "time"
nino34_djf = month_to_season(nino34, "DJF")

nino_std = stddev(nino34_djf)
iel = ind(nino34_djf.gt.0.5*nino_std )

yr_el = iel+1854-1
print("El Nino cases is ") ;
print(""+yr_el)

inmiss = ind(.not.ismissing(yr_el))
elyear = yr_el(inmiss)
print("revised El Nino")
print(""+elyear)
nel = dimsizes(elyear)

;--------deal with datasets-------------------------------
f0 = addfile(diri0+"sst.ersst.v5.1854-2020.nc", "r") 

TIME0=f0->time
yyyymm0=cd_calendar(TIME0, -1)
ymstrt0 =ind(yyyymm0.eq.ymstrt)
ymlast0 = ind(yyyymm0.eq.ymlast)
printMinMax(yyyymm0, 0)

sst_obs = f0->sst(ymstrt0:ymlast0,:,:);{850.},{50.},
sst_obs= dtrend_msg_n(sst_obs&time,sst_obs,False,False,0)
sst3_obs = sst_obs(:,{SLAT:NLAT},{WLON:ELON})

sc=clmMonTLL(sst3_obs);(ymstrt1:ymlast1,:,:)
sa = calcMonAnomTLL(sst3_obs, sc)
printVarSummary(sa)

f1 = addfile(diri0+"dswrf.sfc.mon.mean.nc", "r") ;ncep r2
f2 = addfile(diri0+"uswrf.sfc.mon.mean.nc", "r") 
f3 = addfile(diri0+"precip.mon.GPCP.v2.3.1979-2020.nc", "r") ;GPCP

TIME1=f1->time
yyyymm1=cd_calendar(TIME1, -1)
ymstrt1 =ind(yyyymm1.eq.ymstrt)
ymlast1 = ind(yyyymm1.eq.ymlast)
printMinMax(yyyymm1, 0)

dswrf_obs  = f1->dswrf(ymstrt1:ymlast1,:,:);
uswrf_obs  = f2->uswrf(ymstrt1:ymlast1,:,:);
precip = f3->precip(ymstrt1:ymlast1,:,:);
nsw = dswrf_obs
nsw = dswrf_obs - uswrf_obs

nsw= dtrend_msg_n(nsw&time,nsw,False,False,0)
nsw2 = nsw(:,{SLAT:NLAT},{WLON:ELON})
nsc  = clmMonTLL(nsw2)
nswa = calcMonAnomTLL(nsw2, nsc)
printVarSummary(nswa)

precip= dtrend_msg_n(precip&time,precip,False,False,0)
pr2 = precip(:,{SLAT:NLAT},{WLON:ELON})
prc  = clmMonTLL(pr2)
pra = calcMonAnomTLL(pr2, prc)
printVarSummary(pra)



;-------------resolution---------------------
lat = nswa&lat
lon = nswa&lon
lata = sa&lat
lona = sa&lon 
sa1= linint2_Wrap(lona, lata, sa, True, lon, lat, 0) 
sa1!1 = "lat"
sa1!2 = "lon"
latb = pra&lat
lonb = pra&lon 
pra1= linint2_Wrap(lonb, latb, pra, True, lon, lat, 0) 
pra1!1 = "lat"
pra1!2 = "lon"
copy_VarCoords(nswa,sa1)
copy_VarCoords(nswa,pra1)
printVarSummary(pra1)
printVarSummary(nswa)

;-------normalize sst--------------------------
;remove basin SST mean 
NLAT2 =  20
SLAT2 = -20
WLON2 = 120
ELON2 = 270

rad    = 4.0*atan(1.0)/180.0
clat   = cos(lat*rad)
copy_VarMeta(nswa(0,:,0), clat)
sa_mean = wgt_areaave_Wrap(sa1(:,{SLAT2:NLAT2},{WLON2:ELON2}),clat({SLAT2:NLAT2}), 1.0, 1)
sam = conform_dims(dimsizes(sa1), sa_mean, (/0/))
sa2 = sa1 
sa2 = sa1 - sam 
print(sa_mean+"")
printVarSummary(sa2)
;----------------filter----------------------
ihp   = 1       ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = 71 ;必须是奇数 表示权重系数的总个数，越大效果越好，但是两端损失越多
fca   = 1./(5*12) ;1./ ;                        
fcb   = -999 ;
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )
nswa_f = wgt_runave_n_Wrap ( nswa, wgt, 1, 0 )
sa_f = wgt_runave_n_Wrap ( sa2, wgt, 1, 0 )
pra_f = wgt_runave_n_Wrap ( pra1, wgt, 1, 0 )

;---------------------------------------
AAA = nswa;sa2;sa_f ;
BBB = pra1;pra_f ; 
CCC = sa2;nswa;nswa_f ;

pra_sea = month_to_seasonN(BBB, SEASON)
sa_sea = month_to_seasonN(AAA, SEASON)
nswa_sea = month_to_seasonN(CCC, SEASON)

;-----------------------------------------------

cfsi = regCoef_n(CCC(lat|:,lon|:,time|:),AAA(lat|:,lon|:,time|:), 2, 2)
cfpi = regCoef_n(CCC(lat|:,lon|:,time|:),BBB(lat|:,lon|:,time|:),  2, 2)
copy_VarMeta(AAA(0,:,:), cfsi)
copy_VarMeta(BBB(0,:,:), cfpi)
printVarSummary(cfsi)
printVarSummary(cfpi)

cfsi_sea = regCoef_n(nswa_sea(season|:,lat|:,lon|:,time|:), sa_sea(season|:,lat|:,lon|:,time|:), 3, 3)
cfpi_sea = regCoef_n(nswa_sea(season|:,lat|:,lon|:,time|:),pra_sea(season|:,lat|:,lon|:,time|:),  3,3)
copy_VarMeta(sa_sea(:,0,:,:), cfsi_sea)
copy_VarMeta(pra_sea(:,0,:,:), cfpi_sea)
printVarSummary(cfsi_sea)

; rad    = 4.0*atan(1.0)/180.0
; clat   = cos(lat*rad)
; copy_VarMeta(nswa(0,:,0), clat)
; nsw_mean = wgt_areaave_Wrap(nswa(:,{SLAT1:NLAT1},{WLON1:ELON1}),clat({SLAT1:NLAT1}), 1.0, 1)
; cs = regCoef_n(nsw_mean,sa1,  0, 0)
; cp = regCoef_n( nsw_mean,pra1, 0, 0)
; printVarSummary(cs)
; printVarSummary(cp)
; copy_VarMeta(sa1(0,:,:), cs)
; copy_VarMeta(pra1(0,:,:), cp)

;=========plot=========================

  wks         = gsn_open_wks("ps",diri+"obs_cfsi") 
  plot1 = new(10, graphic)
  plot2 = new(10, graphic)
  plot3 = new(10, graphic)

  res          = True
  res@gsnFrame = False
  res@gsnDraw  = False

  res@mpMinLonF            =  WLON               
  res@mpMaxLonF            =  ELON             
  res@mpMinLatF            =  SLAT            
  res@mpMaxLatF            =  NLAT

  res@gsnAddCyclic         = True
  res@gsnLeftString = ""
  res@gsnRightString = ""

  res@mpCenterLonF         = 180.         ; default is 0 [GM]
  res@gsnLeftStringFontHeightF = 0.02
  ; res@tiMainFontHeightF = 0.03
 res@tmXBLabelFontHeightF = 0.015
 res@tmYLLabelFontHeightF = 0.015

  res@cnFillOn             = True         ; turn on color fill
  res@cnLinesOn            = False         ; True is default
  res@cnLineLabelsOn       = False

  res@lbOrientation = "vertical"
  
  res@mpFillOn      = False  
  res@mpOutlineOn                 = True
  res@mpGeophysicalLineColor    ="gray40"         ;地图边界线颜色
  res@mpGeophysicalLineThicknessF      = 1

  res@lbTitleOn        =  True                ; turn on title
  res@lbTitleString     = ""
  ; res@lbTitleString    = "K"                ; title string
  res@lbTitlePosition  = "Top"              ; title position
  res@lbTitleFontHeightF= .01                ; make title smaller
  ; res@lbTitleDirection = "Across"             
  res@lbTitleExtentF   = 0.01 ;Default: 0.15
  res@lbLabelFontHeightF = 0.01  ;Default: 0.02
  res@pmLabelBarWidthF = 0.05

  res@lbLabelBarOn = True ;False;
  res@cnFillPalette         =  "BlueWhiteOrangeRed"   ; choose colormap
  
  res@cnLevelSelectionMode  = "ManualLevels"
  res@cnMinLevelValF        =  -20.
  res@cnMaxLevelValF        =   20. 
  res@cnLevelSpacingF       =  res@cnMaxLevelValF/5.


  res@gsnRightString = "net sw onto sst"
  plot1(0)   = gsn_csm_contour_map_ce(wks,cfsi,res)
  do isea = 0,3
    res@gsnLeftString = SEASON(isea)
    plot2(isea)   = gsn_csm_contour_map_ce(wks,cfsi_sea(isea,:,:),res)
  end do 
  res@cnMinLevelValF        =  -4.
  res@cnMaxLevelValF        =   4. 
  res@cnLevelSpacingF       =  res@cnMaxLevelValF/5.
  res@gsnRightString = "pr onto sst"
    res@gsnLeftString = ""
  plot1(1)   = gsn_csm_contour_map_ce(wks,cfpi,res)
  do isea = 0,3
    res@gsnLeftString = SEASON(isea)
    plot3(isea)   = gsn_csm_contour_map_ce(wks,cfpi_sea(isea,:,:),res)
  end do 


resk = True
resk@txFontHeightF = 0.02
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
; resk@gsnPanelLabelBar    = False         ; add common colorbar
resk@pmLabelBarWidthF = 0.5
resk@txString  = ""
gsn_panel(wks,plot1,(/2,1/),resk);
gsn_panel(wks,plot2,(/2,2/),resk);
gsn_panel(wks,plot3,(/2,2/),resk);


end