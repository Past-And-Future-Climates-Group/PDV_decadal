begin

NLAT =   65; 5; 60;
SLAT =  -70;-5;-60;
WLON =  100;120;
ELON =  300;290;

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
dirip1 = "/glade/collections/cmip/CMIP6/CMIP/E3SM-Project/E3SM-1-0/piControl/r1i1p1f1/Amon/ts/gr/v20190719/ts/"
dirip2 = "/glade/collections/cmip/cmip5/output1/NSF-DOE-NCAR/CESM1-CAM5/piControl/mon/atmos/Amon/r1i1p1/latest/ts/"
dirip3 = "/glade/collections/cmip/cmip5/output1/CCCma/CanESM2/piControl/mon/ocean/Omon/r1i1p1/v20120410/tos/"
dirip4 = "/glade/collections/cmip/cmip5/output1/CSIRO-QCCCE/CSIRO-Mk3-6-0/piControl/mon/ocean/Omon/r1i1p1/v20130205/tos/"
dirip5 = "/glade/collections/cmip/cmip5/output1/NOAA-GFDL/GFDL-CM3/piControl/mon/ocean/Omon/r1i1p1/v20110601/tos/"
dirip6 = "/glade/collections/cmip/cmip5/output1/NOAA-GFDL/GFDL-ESM2M/piControl/mon/ocean/Omon/r1i1p1/v20130226/tos/"
neof = 1

;read obs IPO results
f0   = addfile(diri+"obs_pdv_1880-2018.nc", "r") ;obs_pdv_1854-2019.nc
rco  = f0->rc(0,:,:)
pco  = f0->pc
pcvaro  = f0->pcvar
printVarSummary(rco)

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
ys = (/1854, 1, 1920, 1950, 1850, 1920, 1950, 1850/) ;start year of datasets
yl = (/2019, 500, 2100, 2100, 2100, 2100, 2100, 2099/) ;end year of datasets
re_lat = (/ 89, 180, 192, 64, 96, 90, 90, 96/)
re_lon = (/ 180, 360, 288, 128, 192, 144, 144, 192/)
nens = (/1, 11, 40, 50, 30, 20, 30, 100 /) ;ensemble number
nens_all = 100
; yr_finish = 2011

MODEL = (/"OBS", "E3SM","CESM","CanESM2", "CSIRO-Mk3-6-0","GFDL-CM3","GFDL-ESM2M","MPI-ESM" /)
nmo = dimsizes(MODEL)

do im = 2,nmo-1

; pc = new((/ neof, 12*((yl(im)-ys(im))+1)/), "float") ;12* ;PC series of EOF nens(im),
; rc = new((/ neof, re_lat(im), re_lon(im)/), "float") ;regressed pattern of PC
; pcvar = new((/ neof/), "float") ;explained variance
; par = new((/ neof/), "float") ;pattern correlation of EOF with OBS



if (MODEL(im).eq."E3SM") then 
f_input = diri+"ts_Amon_E3SM-1-0_piControl_000101-050012.nc"
else if (MODEL(im).eq."CESM") then  
f_input = dirip2+"ts_Amon_CESM1-CAM5_piControl_r1i1p1_000101-031912.nc"
else if (MODEL(im).eq."CanESM2") then  
f_input = "/glade/work/chenxing/picontrol/CanESM2/ts_Amon_CanESM2_piControl_201501-301012.nc"
else if (MODEL(im).eq."CSIRO-Mk3-6-0") then  
f_input = "/glade/work/chenxing/picontrol/CSIRO-Mk3-6-0/ts_Amon_CSIRO-Mk3-6-0_piControl_r1i1p1_000101-050012.nc"
else if (MODEL(im).eq."GFDL-CM3") then  
f_input = "/glade/work/chenxing/picontrol/GFDL-CM3/ts_Amon_GFDL-CM3_piControl_000101-050012.nc"
else if (MODEL(im).eq."GFDL-ESM2M") then  
f_input = "/glade/work/chenxing/picontrol/GFDL-ESM2M/ts_Amon_GFDL-ESM2M_piControl_000101-050012.nc"
else if (MODEL(im).eq."MPI-ESM") then  
f_input = "/glade/work/chenxing/picontrol/MPI-ESM/ts_Amon_MPI-ESM_piControl_185001-385012.nc"
end if 
end if 
end if 
end if 
end if 
end if 
end if 

    print(f_input(0))
  exists = isfilepresent(f_input(0))
  if(.not.exists) then
    print("file doesn't exist, keep on to the next cycle")
    continue
  end if
  

; do i =0,nm-1
  f   = addfile(f_input(0), "r")

;only do historical part here first
TIME2=f->time
yyyymm2=cd_calendar(TIME2, -1)
printMinMax(yyyymm2, True)
; ymstrts = ind(yyyymm2.eq.ymstrt)
; ymlasts = ind(yyyymm2.eq.201112)

if (MODEL(im).eq."E3SM") then ;some problems correctly reading time dim of E3SM
    xx  = f->ts;(:ymlasts,:,:);
else 
    xx  = f->ts;(:ymlasts,:,:);
end if 
delete([/f,TIME2,yyyymm2/]);,lat,lon
 
xx= dtrend_msg_n(xx&time,xx,False,False,0)
xa = rmMonAnnCycTLL(xx)

;-------------------------------------
;cover land data
;mask 0=ocean (land reserved), 1=land, 2=lake, 3=small island, 4=ice shelf.

 lland = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
 lsm0 = landsea_mask(lland->LSMASK,xa&lat,xa&lon)
 xa_sea = mask(xa,lsm0.eq.1, False)      ; mask out land points
 copy_VarMeta(xa, xa_sea)

delete(lsm0)


;------------remove global mean sst---------------
lat    = xa_sea&lat
rad    = 4.0*atan(1.0)/180.0
clat   = cos(lat*rad)
global_sst = wgt_areaave_Wrap(xa_sea,clat, 1.0, 1)
global_sst2 = conform_dims(dimsizes(xa_sea), global_sst, 0)

xa_r = xa_sea 
xa_r = xa_sea - global_sst2
delete([/lat,clat,global_sst2,global_sst/])

print(MODEL(im))

;montly mean 
xam = xa_r ;xa ;xa_r
; ;yearly mean 
; xam = month_to_annual(xa_r, 1) ;xa_r: global mean removed; xa: oringinal
; ndim = dimsizes(xam)
; xam!0 = "time"
; xam&time = ispan(1, ndim(0), 1)
; xam= dtrend_msg_n(xam&time,xam,False,False,0) ;caveat --> unable to remove global sst mean!

;-----------running average------
; endopt    = 1
;  nrun      = 3;*12
;  xam_ft = runave_n_Wrap (xam, nrun, endopt, 1)
;  poam_rm = runave_n_Wrap (poam, nrun, endopt, 0) 
;  printVarSummary(xam_ft)
;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*12*2+1) ;fyr)+1 ;                           ; odd only
fca   = 1./(fyr*12); );
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

xam_ft = wgt_runave_n_Wrap( xam, wgt,  -1, 0 )   ;opt < 0 : utilize cyclic conditions 

delete(wgt)
;-------------EOF----------------------------------------
optEof = False
  
X = xam_ft(lat|:,lon|:,time|:) 
eof    = eofunc_Wrap(X({SLAT:NLAT},{WLON:ELON},:),neof,optEof)
eof_ts = eofunc_ts_Wrap(X({SLAT:NLAT},{WLON:ELON},:),eof,False)
pc = dim_standardize_n_Wrap(eof_ts,0,1) ;population standard
pcvar = eof@pcvar
copy_VarCoords(xam(0,{SLAT:NLAT},{WLON:ELON}),eof(0,:,:))

;change resolution for obs to fit with model (to do pattern correlation)
    aa = rco({SLAT:NLAT},{WLON:ELON})
    ; r_lon = 360./dimsizes(xam&lon)
    ; r_lat = 180./dimsizes(xam&lat)
    lat = aa&lat
    lon = aa&lon 
    nlat = dimsizes(eof&lat) ;target dimension size
    nlon = dimsizes(eof&lon) ;target dimension size
    klon = fspan(WLON, ELON, nlon) ;ispan(0,nlon-1,1)*r_lon+WLON   ;target dimension 
    klat = fspan(SLAT, NLAT, nlat) ;ispan(0,nlat-1,1)*r_lat+SLAT  ;target dimension
    rco_r= linint2_Wrap(lon, lat, aa, True, klon, klat, 0) 
    rco_r&LAT@units="degrees_north"
    rco_r&LON@units="degrees_east"
    ; printVarSummary(rco_r)
    delete([/lat,lon,klat,klon/])

;based on pattern correlation to find the same sign of IPO
rc0  = regCoef(pc(0,:),xam(lat|:,lon|:,time|:));Y
copy_VarCoords(xam(0,:,:),rc0)
rp0 = pattern_cor(rc0({SLAT:NLAT},{WLON:ELON}), rco_r, 1.0, 0)
print("pattern correlation with OBS is "+rp0)
if (rp0.le.0) then; (22->-5S,64->110W)   rp0(.le.0 rc0({-5},{240}).lt.0.
   pc(0,:) = pc(0,:)*-1.0
end if

 ; tval =new((/nlat,nlon/),typeof(xam)) 
 ; df = new((/nlat,nlon/),"integer")
; do i = 0,neof-1
rc = regCoef(pc(0,:),xa(lat|:,lon|:,time|:));, tval, df);Y
copy_VarCoords(xx(0,:,:), rc)
par = pattern_cor(rc({SLAT:NLAT},{WLON:ELON}), rco_r, 1.0, 0) ;pattern correlation with obs of EOF

;df = df-2
;b1 = tval               ; b must be same size as tval (and df) 
;b1 = 0.5 
;prob(ia,i,:,:) = (1-(betainc(df/(df+tval^2),df/2.0,b1)))*100 
; end do

print(MODEL(im)+"")
copy_VarCoords(xam(0,:,:),rc)

pc!0 = "eof"
pc!1 = "time"
printVarSummary(rc)
printVarSummary(pc)

;--------output-------------
fon=diri+"lens/"+MODEL(im)+"_pdv_picontrol.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->rc = rc
fo->pc = pc
fo->pcvar = pcvar
fo->par = par

delete([/xx, xa, xam, xa_r,xa_sea, xam_ft, eof, eof_ts, X, rc0, rco_r, f_input,par/])


;---------read output---------------
f1   = addfile(diri+"lens/"+MODEL(im)+"_pdv_picontrol.nc", "r")
rc  = f1->rc
pc  = f1->pc
pcvar  = f1->pcvar
par  = f1->par
printVarSummary(rc)


;--------------plot-------------------
wks = gsn_open_wks("ps", dirip+MODEL(im)+"_pdv_picontrol");
plot = new(10,graphic)                ; create graphic array
plot1 = new(10,graphic)                ; create graphic array
gsn_define_colormap(wks, "NCV_blu_red"); "BlueDarkRed18");"BrownBlue12");"BlueGreen14");"BlueYellowRed");"sunshine_9lev")"BrownBlue12";
res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""

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

res2@gsnLeftStringFontHeightF = 0.03
res2@gsnRightStringFontHeightF = 0.03
res2@lbLabelBarOn = True ;False;
res2@lbOrientation = "vertical"
res2@lbTitleOn        =  True                ; turn on title
res2@lbLabelStride    = 2
res2@lbTitleString    = "K"                ; title string
res2@lbTitlePosition  = "Top"              ; title position
res2@lbTitleFontHeightF= .01                ; make title smaller
; res2@lbTitleDirection = "Across"             
res2@lbTitleExtentF   = 0.01 ;Default: 0.15
res2@lbLabelFontHeightF = 0.01  ;Default: 0.02
res2@pmLabelBarWidthF = 0.05

i = 0

res2@cnLevelSelectionMode  = "ManualLevels"    
res2@cnMinLevelValF        = -0.30
res2@cnMaxLevelValF        =  0.30 
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.


res2@gsnLeftString = "OBS (EOF"+(i+1)+")"
res2@gsnRightString = sprintf("%5.1f", pcvaro(i)) +"%"
plot1(0) = gsn_csm_contour_map_ce(wks,rco , res2)


res2@gsnLeftString = "ensemble mean (EOF"+(i+1)+")"
mpp = dim_avg_n_Wrap(pcvar(i), 0)
res2@gsnRightString = sprintf("%5.1f", mpp) +"%"
plot(0) = gsn_csm_contour_map_ce(wks, rc, res2)

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
  res@vpHeightF = 0.40        ; Changes the aspect ratio
  res@vpWidthF  = 0.85
 
  res@tmXTOn    = False

  ;res2@gsnScale  = True        ; force text scaling               
  ;res@gsnXYBarChart            = True              ; Create bar plot
  ;res@gsnXYBarChartOutlineOnly = True


  res@gsnYRefLine           = 0.0             ; reference line   
  ; res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  ; res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  res@gsnLeftStringFontHeightF  = 0.03
  res@gsnRightStringFontHeightF = 0.03
 ; res@trYMinF               = -3.
 ; res@trYMaxF               =  3.

    ndim  = dimsizes(pc)
    ndimo = dimsizes(pco)
  x_axis1 = fspan(1854, 2019, ndimo(1))
  x_axis2 = fspan(ys(im), ys(im)+ndim(1)/12.-1, ndim(1))
  ;res@tmXBMode   = "Explicit"                                                
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
res@tiYAxisString = ""

res@xyLineThicknessF = 4.0
res@xyLineColor = "black"
res@gsnLeftString = ""
res@gsnRightString = "PC1"
plot(1) = gsn_csm_xy (wks,x_axis2,pc(0,:),res)


res@gsnLeftString = "OBS"
plot1(1) = gsn_csm_xy (wks,x_axis1,pco(0,:),res)

gsn_panel(wks,plot,(/2,1/),resk);(without removing nearby annual cycle)
gsn_panel(wks,plot1,(/2,1/),resk)    

delete([/ndim,ndimo, pc, rc, pcvar, par, x_axis1, x_axis2, res, res2/])
end do 
end
