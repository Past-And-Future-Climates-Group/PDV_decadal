begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

NLAT =  70; 65; 5; 60;
SLAT =  20;-70;-5;-60;
WLON =  100;120;
ELON =  300;290;

NLAT0 =  90
SLAT0 =  -90
WLON0 =  0;
ELON0 =  360;

;read obs IPO results
;from obs_ipo.ncl
f0   = addfile(diri+"obs_pdv_1880-2018.nc", "r") ;obs_pdv_1854-2019.nc
rco  = f0->rc(0,:,:)
pco  = f0->pc
pcvaro  = f0->pcvar
printVarSummary(rco)

  fref = systemfunc("ls "+diri+"cmip6/tos.pdv/cmip6_historical_ACCESS-CM2_r1i1p1f1_pdv_1850-2014.nc")
  print(fref)
  fr   = addfile(fref(0), "r")  ;multiple files
  rref = fr->rc;({SLAT:NLAT},{WLON:ELON})


diri1 = "/glade/work/chenxing/enso/E3SM/"
diri2 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/"
diris = "/glade/scratch/chenxing/cesm1_le/"
SEASON = (/"DJF","MAM","JJA","SON" /)

; MODEL_LOCS = (/"cesm_lens","canesm2_lens","csiro_mk36_lens",\;"ec_earth_lens",
;   "gfdl_cm3_lens","mpi_lens" /);"gfdl_esm2m_lens",
; MODEL_NAME = (/"CESM1-CAM5","CanESM2","CSIRO-Mk3-6-0",\;"EC-EARTH",
;   "GFDL-CM3","MPI-ESM" /);"GFDL-ESM2M",
;
  MODEL_LOCS = (/"cesm_lens"/)
  MODEL_NAME = (/"CESM1-CAM5" /)

nm = dimsizes(MODEL_LOCS)

VAR  = "pr";(/"ua","va"/) ;"zg";(/"ts","pr" ,"psl"/);"cloudeffect" ;"pr" ;"psl" ; "ua" ;"od550aer" ;"cloudeffect";"ts" ;
VARn = "pr";(/"ua200","va200"/) ;"zg300";(/"ts","pr" ,"psl"/);"cloudeffect";"pr";"psl" ;"ua200"
EXP = "historical"
ORG = "CLIVAR"

yrs1 = (/1950,1991/) ;1950;1950 ;1991;
yrl1 = (/1990,2014/) ;1990;1990 ;2014;

do iv = 0,dimsizes(VAR)-1

do i = 0,dimsizes(yrs1)-1

do im = 0,0;nm-1

diri3 = diri2+MODEL_LOCS(im)+"/Amon/"+VAR(iv)+"/"

if (ORG.eq."CLIVAR") then
  locs = systemfunc("ls "+diri3+"*rcp85*")
else
  locs = systemfunc("ls "+diris+"*."+VAR+".*200512.nc")

end if
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

MODEL = new(nsa, "string")
ENSN  = new(nsa, "string")

do ia = 0,nsa-1

  if (ORG.eq."CLIVAR") then
; for files stored in CLIVAR_LE
 locs_str0 = str_split(locs(ia), "/")
 locs_str = str_split(locs_str0(9), "_");
 print("'" + locs_str + "'")


MODEL(ia) = locs_str(2)
ENSN(ia)  = locs_str(5)

bb = str_split(locs_str(6), "-")

  yrl0 = 2014
  ymlast= yrl0*100+12
; if(ia.eq.0) then ???
  ymstrt= bb(0)
  yrs0 = toint(tofloat(bb(0))/100.)
; end if

print(ymstrt+", "+yrs0)
print(MODEL(ia)+" ens "+ENSN(ia))

  fils = systemfunc("ls "+locs(ia));+"/*.nc")

else
  ; for files in scratch (e.g. FSNS)
  locs_str = str_split(locs(ia), ".");
  print("'" + locs_str + "'")
  ENSN(ia)  = locs_str(4) ;cesm2 cmip5 forcing 5 ;cesm1 le 4
  TT  = locs_str(8) ; 9       ;  8
  print(ENSN(ia)+" "+TT)
  ak = str_split(TT, "-");
  ymstrt = toint(ak(0))+1
  yrs0 = toint(tofloat(ymstrt)/100.)
  delete(ak)
  yrl0 = 2100
  ymlast= yrl0*100+12+89
  print(ymstrt+" "+ymlast)

   fils = systemfunc("ls "+diris+"*"+ENSN(ia)+"*"+VAR+".*.nc")
end if
  print(fils)
  f   = addfiles(fils, "r")  ;multiple files
  ListSetType (f, "cat")        ; concatenate (=default)

;only do historical part here first
TIME2=f[:]->time
yyyymm2=cd_calendar(TIME2, -1)
printMinMax(yyyymm2, True)
ymstrts = ind(yyyymm2.eq.ymstrt)
ymlasts = ind(yyyymm2.eq.ymlast)
print(ymstrts+" <--start end--> "+ymlasts)

  xx  = f[:]->$VAR(iv)$(ymstrts:ymlasts,:,:);{20000},:,:);ce;
  ; xx  = f[:]->ce(ymstrts:ymlasts,:,:)

  delete([/f,TIME2,yyyymm2/]);,lat,lon

xa = rmMonAnnCycTLL(xx)
x_annual = month_to_annual(xx,1)
xa_annual = month_to_annual(xa,1)

; ;---------interpolate---------------------
; ;change resolution for MODELS to the same 144*72
;     zz = xx
;    ; r_lon = 360./dimsizes(xam&lon)
;     ; r_lat = 180./dimsizes(xam&lat)
;     lat = zz&lat
;     lon = zz&lon
;     nlat = dimsizes(rref&lat) ;target dimension size
;     nlon = dimsizes(rref&lon) ;target dimension size
;     klon = fspan(WLON0, ELON0, nlon) ;target dimension
;     klat = fspan(SLAT0, NLAT0, nlat) ;target dimension
;     cc= linint2_Wrap(lon, lat, zz, True, klon, klat, 0)
;     cc&LAT@units="degrees_north"
;     cc&LON@units="degrees_east"
;     printVarSummary(cc)
;     delete([/lat,lon,klat,klon,zz/]);xa0
;     cc!1 = "lat"
;     cc!2 = "lon"
;
;     copy_VarMeta(cc(0,:,:), xx(0,:,:))

    a1 = yrs1(i)-yrs0
    b1 = yrl1(i)-yrs0
    print(a1+" "+b1)

    xc = dim_avg_n_Wrap(x_annual(a1:b1,:,:),0)
    ; xc = clmMonTLL(x_annual(a1:b1,:,:))
    xz = dim_avg_n_Wrap(x_annual,2)

    xca = dim_avg_n_Wrap(xa_annual(a1:b1,:,:),0)
    xza = dim_avg_n_Wrap(xa_annual,2)

;--------output-------------
fon=diri+"lens5/"+MODEL_NAME(im)+"_"+ENSN(ia)+"_clim_"+EXP+"_"+VARn(iv)+"_"+yrs1(i)+"-"+yrl1(i)+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->clim  = xc
fo->aclim  = xca

fon=diri+"lens5/"+MODEL_NAME(im)+"_"+ENSN(ia)+"_clim_zonal_"+EXP+"_"+VARn(iv)+"_"+yrs0+"-"+yrl0+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->xz  = xz
fo->axz  = xza

delete([/locs_str,xx,xc,fils/]);
delete([/xa,x_annual,xa_annual,xz,xza,xca/])
end do

delete([/locs/]);,x_Lead1

print("Calculation is done for "+MODEL_NAME(im))

end do
end do
end do

print("Calculation is done")


end
