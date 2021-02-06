begin

diri = "/Users/xingchen/Documents/project/ENSO/data/" ;
dirip = "/Users/xingchen/Documents/project/ENSO/pic/" ;

NLAT =  70; 65; 5; 60;
SLAT =  20;-70;-5;-60;
WLON =  100;120;
ELON =  300;290;

;read obs IPO results
;from obs_ipo.ncl
f0   = addfile(diri+"obs_pdv_1880-2018.nc", "r") ;obs_pdv_1854-2019.nc
rco  = f0->rc(0,:,:)
pco  = f0->pc
pcvaro  = f0->pcvar
printVarSummary(rco)

  fref = systemfunc("ls "+diri+"cmip5/tos.pdv/cmip5_historical_ACCESS1-0_r1i1p1_pdv_1861-2004.nc")
  print(fref)
  fr   = addfile(fref(0), "r")  ;multiple files
  rref = fr->rc({SLAT:NLAT},{WLON:ELON})

;change resolution for obs to fit with model (to do pattern correlation)
    aa = rco({SLAT:NLAT},{WLON:ELON})
   ; r_lon = 360./dimsizes(xam&lon)
    ; r_lat = 180./dimsizes(xam&lat)
    lat = aa&lat
    lon = aa&lon 
    nlat = dimsizes(rref&lat) ;target dimension size
    nlon = dimsizes(rref&lon) ;target dimension size
    klon = fspan(WLON, ELON, nlon) ;target dimension 
    klat = fspan(SLAT, NLAT, nlat) ;target dimension
    rco_r= linint2_Wrap(lon, lat, aa, True, klon, klat, 0) 
    rco_r&LAT@units="degrees_north"
    rco_r&LON@units="degrees_east"
    printVarSummary(rco_r)
    delete([/lat,lon,klat,klon,aa/]);xa0


;---------read output---------------
f1   = addfile(diri+"cmip5_reg_PDI2_historical_tas_1861-2004.nc", "r")
ccr1  = f1->ccr1

f2   = addfile(diri+"cmip6_reg_PDI2_historical_ts_1850-2014.nc", "r")
ccr2  = f2->ccr1

printVarSummary(ccr1)
printVarSummary(ccr2)

ndim1 = dimsizes(ccr1)
ndim2 = dimsizes(ccr2)
rp1 = new(ndim1(0), "float")
rp2 = new(ndim2(0), "float")
do i = 0,ndim1(0)-1
  rp1(i) = pattern_cor(ccr1(i,{SLAT:NLAT},{WLON:ELON}), rco_r({SLAT:NLAT},{WLON:ELON}), 1.0, 0)
end do 

do i = 0,ndim2(0)-1
  rp2(i) = pattern_cor(ccr2(i,{SLAT:NLAT},{WLON:ELON}), rco_r({SLAT:NLAT},{WLON:ELON}), 1.0, 0)
end do 

print("pattern correlation with OBS in CMIP5 is ")
print(""+rp1)
print("pattern correlation with OBS in CMIP6 is ")
print(""+rp2)


;--------output-------------
fon=diri+"cmip5_reg_PDI2_historical_tas_1861-2004.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->ccr1 = ccr1
fo->rp = rp1

fon=diri+"cmip6_reg_PDI2_historical_ts_1850-2014.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->ccr1 = ccr2
fo->rp = rp2

end