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

  ymstrt = 197901
  ymlast = 201912
  yrstrt = 1979
  yrlast = 2019

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

pra_djf = month_to_season(pra, "DJF")
sa_djf = month_to_season(sa, "DJF")
printVarSummary(sa_djf)
;------------------------------------------
;nino3.4
NLAT1 =  5
SLAT1 = -5
WLON1 = 190
ELON1 = 240

;nino3
NLAT2 =  5
SLAT2 = -5
WLON2 = 210
ELON2 = 270

lats = sa&lat
rad    = 4.0*atan(1.0)/180.0
clat1   = cos(lats*rad)
copy_VarMeta(sa(0,:,0), clat1)
sa_34 = wgt_areaave_Wrap(sa(:,{SLAT1:NLAT1},{WLON1:ELON1}),clat1({SLAT1:NLAT1}), 1.0, 1)
sa_3  = wgt_areaave_Wrap(sa(:,{SLAT2:NLAT2},{WLON2:ELON2}),clat1({SLAT2:NLAT2}), 1.0, 1)
printVarSummary(sa_3)

latp = pra&lat
clat2   = cos(latp*rad)
copy_VarMeta(pra(0,:,0), clat2)
pra_34 = wgt_areaave_Wrap(pra(:,{SLAT1:NLAT1},{WLON1:ELON1}),clat2({SLAT1:NLAT1}), 1.0, 1)
pra_3  = wgt_areaave_Wrap(pra(:,{SLAT2:NLAT2},{WLON2:ELON2}),clat2({SLAT2:NLAT2}), 1.0, 1)
printVarSummary(pra_3)


;--------------plot-------------------
wks = gsn_open_wks("ps", diri+"obs_scatter");
  gsn_define_colormap(wks,"default");"BlueDarkRed18""precip_diff_12lev""MPL_BrBG" "BlueWhiteOrangeRed" temp_diff_18lev
plot = new(4,graphic)

res = True
res@gsnFrame = False
res@gsnDraw  = False

;res@gsnPaperHeightF  = 8.5 ;default 11.0
;res@gsnPaperWidthF  =  8.5 ;default 8.5
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

res@xyMonoMarkerColor  = False ;True ;          ; Allow different colors for markers


res@gsnLeftString = "";"(a)";"

colors = read_colormap_file("default") ;("BkBlAqGrYeOrReViWh200");("default");("cosam");"GMT_paired"
  res@xyMarkLineMode     = "MarkLines"  ; choose which have markers
  res@xyMarkers          =  1 
  res@xyMarkerColors             = colors;ispan(1, nm+7, 1)


  res@gsnYRefLine = 0;avg(index_pro)
  res@gsnYRefLineThicknessF = 2.
  res@gsnYRefLineDashPattern = 1  
  res@gsnXRefLine = 0;avg(index_vwso)
  res@gsnXRefLineThicknessF = 2.
  res@gsnXRefLineDashPattern = 1  
  res@tiMainString             = ""

res@xyMarkerSizes = 0.04

res@tiXAxisString = "sst"
res@tiYAxisString = "pr"
; res@trXMinF             = -1*max_x(ix)
; res@trXMaxF             = max_x(ix)
; res@trYMinF             = -1*max_x(iy)
; res@trYMaxF             = max_x(iy)

plot(0) = gsn_csm_xy(wks, sa_34 ,pra_34,res) 
plot(1) = gsn_csm_xy(wks, sa_3 ,pra_3,res) 


 resk = True
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
gsn_panel(wks, plot, (/2,1/), resk)


end