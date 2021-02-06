begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
dirip1 = "/glade/collections/cmip/CMIP6/CMIP/E3SM-Project/E3SM-1-0/piControl/r1i1p1f1/Amon/ts/gr/v20190719/ts/"
dirip2 = "/glade/collections/cmip/cmip5/output1/NSF-DOE-NCAR/CESM1-CAM5/piControl/mon/atmos/Amon/r1i1p1/latest/ts/"
dirip3 = "/glade/collections/cmip/cmip5/output1/CCCma/CanESM2/piControl/mon/ocean/Omon/r1i1p1/v20120410/tos/"
dirip4 = "/glade/collections/cmip/cmip5/output1/CSIRO-QCCCE/CSIRO-Mk3-6-0/piControl/mon/ocean/Omon/r1i1p1/v20130205/tos/"
dirip5 = "/glade/collections/cmip/cmip5/output1/NOAA-GFDL/GFDL-CM3/piControl/mon/ocean/Omon/r1i1p1/v20110601/tos/"
dirip6 = "/glade/collections/cmip/cmip5/output1/NOAA-GFDL/GFDL-ESM2M/piControl/mon/ocean/Omon/r1i1p1/v20130226/tos/"

  ; ymstrt= 185001  
  ; ymlast= 201112
  ; yrstrt= 1850  
  ; yrlast= 2011

; nyr = yrlast-yrstrt+1

diri = "/glade/work/chenxing/enso/"
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
;ts_Amon_GFDL-ESM2M_historical_rcp85_r8i1p1_195001-210012.nc
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

do im = 1,nmo-1


; f_input = systemfunc(" ls -1 /glade/work/chenxing/sst.ersst.v5.185401-201912.nc") 
f_input = systemfunc(" ls -1 /glade/work/chenxing/air.2x2.250.mon.anom.comb.nc") 

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
  ; TIME=f->time;
  ; yyyymm  = cd_calendar(TIME, -1)
  ; ymstrt1 = ind(yyyymm.eq.188001) ;for GISTEMP
  ; ymlast1 = ind(yyyymm.eq.201812)
  ; print(yyyymm)
  ; print(ymstrt1)
  ; print(ymlast1)
  x = f->ts;(ymstrt1(0):ymlast1(0),:,:);,{SLAT:NLAT},{WLON:ELON})
  xc=clmMonTLL(x)
  xa = calcMonAnomTLL(x, xc)
  printVarSummary(xa)
  

;-------------------------
; Calculating index 
; Nino 1+2 (0-10S, 90W-80W), Nino 3 (5N-5S, 150W-90W), 
; Nino 3.4/ONI (5N-5S, 170W-120W) and Nino 4 (5N-5S, 160E-150W)
; TNI is Nino 1+2 - Nino 4

  lat = xa&lat
  rad    = 4.0*atan(1.0)/180.0
  clat   = cos(lat*rad)
  copy_VarCoords(xa(0,:,0), clat)
  ; go = wgt_areaave_Wrap(x,clat, 1.0, 1)

  NLAT =  90;  70;
  SLAT =  -90;50;
  WLON =  0;300;
  ELON =  360;360;
  ; gmst = wgt_areaave_Wrap(xa(:,{SLAT:NLAT},{WLON:ELON}),clat({SLAT:NLAT}), 1.0, 1)
  g1 = wgt_areaave_Wrap(xa(:,{SLAT:0},{WLON:ELON}),clat({SLAT:0}), 1.0, 1) ;SH mean 
  g2 = wgt_areaave_Wrap(xa(:,{0:NLAT},{WLON:ELON}),clat({0:NLAT}), 1.0, 1) ;NH mean
  gmst = g2 - g1

print(MODEL(im)+"")

gmst@long_name = "Global mean surface temperature";"AMO" ;
printVarSummary(gmst)
;------output--------------
fon=diri+MODEL(im)+"_nh-sh_index_picontrol.nc";
if (MODEL(im).eq."OBS") then
  fon=diri+"GISTEMP_nh-sh_index_188001-201812.nc";
end if 

system("rm -f "+fon)
fo=addfile(fon,"c")
fo->gmst = gmst

delete([/x, xa, xc, lat, clat, gmst,g1,g2/])
end do 

end