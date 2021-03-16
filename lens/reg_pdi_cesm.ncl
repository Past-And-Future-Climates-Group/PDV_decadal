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

;change resolution for obs to fit with model (to do pattern correlation)
    aa = rco;({SLAT:NLAT},{WLON:ELON})
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


;cesm1 single forcing
diri1 = "/glade/scratch/chenxing/cesm1_le/"
;b.e11.B20TRLENS_RCP85.f09_g16.xghg.011.cam.h0.TS.192001-200512.nc

;cesm2 with CMIP5 forcing
diri2 = "/glade/scratch/chenxing/cesm2_cmip5_forcing/"
;b.e21.BHIST.f09_g17.cesm2_cmip5_forcing.002.cam.h0.TS.185001-200512.nc

VAR  = (/"PRECT"/) ;(/"Z3"/) ; (/"U","V"/) ;"TS" ; "va" ;"PSL" ;"CLDTOT"
VARn = (/"pr"/) ;(/"zg300"/) ; (/"ua200","va200"/) ;"va850";"clt"
IND = "PDI" ;"mmeeof2" ;"mmeeof1" ;"GMAOD" ;"PDI2" ;"PDI"; "AR1Di" ;"SLPAL" ;"pdv";"TNA"; "AR1varm"; "TNA";
AA =  ""

yrs1 = (/1950,1991 /) ;1950;1950 ;1991;
yrl1 = (/1990,2014/) ;1990;1990 ;2014;

do iv = 0,dimsizes(VAR)-1
do i = 0,1

MODEL = "cesm2_cmip5_forcing" ;"cesm1_le";
EXP =  "" ;(/"xghg", "xaer" , "xlulc", "xbmb"/);

nm = dimsizes(EXP)

do im = 0,nm-1

if (MODEL.eq."cesm2_cmip5_forcing") then
  locs = systemfunc("ls "+diri2+"*"+MODEL+"*"+VAR(iv)+"*.nc")
  diri0 = diri2
  else
  locs = systemfunc("ls "+diri1+"*"+EXP(im)+"*"+VAR(iv)+"*.nc")
  diri0 = diri1
end if
print(locs)
nsa = dimsizes(locs)


ENSN  = new(nsa, "string")

aa = new((/nsa, 72,144 /), "float")
rp1 = new(nsa, "float")

istart = 0
do ia = istart,nsa-1

 locs_str = str_split(locs(ia), ".")
 print("'" + locs_str + "'")


ENSN(ia)  = locs_str(5)

bb = str_split(locs_str(9), "-")

  yrl0 = 2014
  ymlast= yrl0*100+12
if(ia.eq.0) then
  ymstrt= bb(0)
  yrs0 = toint(tofloat(bb(0))/100.)
end if

print(ymstrt+", "+yrs0)
print(MODEL+" ens "+ENSN(ia))

  ;b.e11.B20TRLENS_RCP85.f09_g16.xaer.014.cam.h0.TS.192001-200512.nc
  ;b.e11.B20TRLENS_RCP85.f09_g16.xaer.013.cam.h0.TS.200601-208012.nc
  fils = systemfunc("ls "+diri0+"*"+EXP(im)+"."+ENSN(ia)+"*"+VAR(iv)+"*"); +locs(ie));+"/*.nc")
  print(fils)
  f   = addfiles(fils, "r")  ;multiple files
  ListSetType (f, "cat")        ; concatenate (=default)

;only do historical part here first
TIME2=f[:]->time
yyyymm2=cd_calendar(TIME2, -1)
printMinMax(yyyymm2, True)
ymstrts = ind(yyyymm2.eq.ymstrt)
ymlasts = ind(yyyymm2.eq.ymlast)
ycstrts = ind(yyyymm2.eq.197501)
yclasts = ind(yyyymm2.eq.200412)
print(ymstrts+" <--start end--> "+ymlasts)

    xx  = f[:]->$VAR(iv)$(0:ymlasts+1,:,:);{200},:,:) ;(ymstrts:ymlasts,:,:);
    if (MODEL.eq."cesm2_cmip5_forcing".and.VAR.eq."PRECT") then
      xx = xx *1000
      xx@units = "kg m-2 s-1"
    end if
  delete([/f,TIME2,yyyymm2/]);,lat,lon

  xa = rmMonAnnCycTLL(xx)

  ; xa_annual = month_to_annual(xa, 1)
  ; xa_sea = month_to_seasonN(xa, SEASON)
  ; ;season, year --> season * year one dimension
  ; ndim1 = dimsizes(xa_sea)
  ; xa_sea2 = reshape(xa_sea, (/ndim1(0)*ndim1(1),ndim1(2),ndim1(3) /) )
  ; xa_sea2!0 = "time"
  ; copy_VarMeta(xa(0,:,:), xa_sea2(0,:,:))

;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*12*1+1); fyr)+1 ;                           ; odd only
fca   = 1./(fyr*12)
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

  ;---------read output---------------


  ;;some index
  ;from lens5_index.ncl
  if (MODEL.eq."cesm2_cmip5_forcing") then
    f1   = addfile(diri+"lens5/PDI/"+MODEL+"_"+ENSN(ia)+"_PDI_"+yrs0+"-"+yrl0+".nc", "r")
  else
    f1   = addfile(diri+"lens5/PDI/"+MODEL+"_"+EXP(im)+"_"+ENSN(ia)+"_PDI_"+yrs0+"-"+yrl0+".nc", "r")
  end if
  pc  = f1->index
  pc_ft = wgt_runave_n_Wrap( pc, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions

  ; ;global external forcing mode
  ; ;from mme_eof_cmip6.ncl
  ; if (MODEL.eq."cesm2_cmip5_forcing") then
  ;   ff = systemfunc("ls "+diri+"lens5/PDI/"+MODEL+"_*_PDI_"+yrs0+"-"+yrl0+".nc")
  ; else
  ;   ff = systemfunc("ls "+diri+"lens5/PDI/"+MODEL+"_"+EXP(im)+"_*_PDI_"+yrs0+"-"+yrl0+".nc")
  ; end if
  ; f1   = addfiles(ff, "r")
  ; ListSetType (f1, "join")
  ; pc0  = f1[:]->index
  ; pc = wgt_runave_n_Wrap( pc0, wgt,  0, 1 )   ;opt < 0 : utilize cyclic conditions
  ; pc_ft = dim_avg_n_Wrap(pc, 0)
  ; delete([/ff,pc0/])

  ; pc_annual = month_to_annual(pc, 1)
  ; pc_sea = month_to_seasonN(pc, SEASON)
  ; pc_sea2 = ndtooned(pc_sea)
  ; pc_sea2!0 = "time"
  delete([/xx/]);,xa_sea,pc_sea /])


; ???
pc_ft = dim_standardize_n_Wrap(pc_ft, 0, 0)
printVarSummary(pc_ft)
;---------interpolate---------------------
;change resolution for MODELS to the same 144*72
    zz = xa
   ; r_lon = 360./dimsizes(xam&lon)
    ; r_lat = 180./dimsizes(xam&lat)
    lat = zz&lat
    lon = zz&lon
    nlat = dimsizes(rref&lat) ;target dimension size
    nlon = dimsizes(rref&lon) ;target dimension size
    klon = fspan(WLON0, ELON0, nlon) ;target dimension
    klat = fspan(SLAT0, NLAT0, nlat) ;target dimension
    cc= linint2_Wrap(lon, lat, zz, True, klon, klat, 0)
    cc&LAT@units="degrees_north"
    cc&LON@units="degrees_east"
    printVarSummary(cc)
    delete([/lat,lon,klat,klon,zz/]);xa0
    cc!1 = "lat"
    cc!2 = "lon"

;-------------month_to_annual-------------

pc3 = month_to_annual(pc_ft,1)
dd = month_to_annual(cc,1)
printVarSummary(dd)
printVarSummary(pc3)
;-----------regression-------------
a1 = (yrs1(i)-yrs0)*12
b1 = (yrl1(i)-yrs0+1)*12-1
pc2 = pc_ft(a1:b1) ;pc3(yrs1(i)-yrs0:yrl1(i)-yrs0+1)
print(a1+" "+b1)
; ic = ind(pc2.gt.0)
; print((yrs1(i)+ic)+"")
; aa(ia,:,:) = dim_avg_n_Wrap(dd(ic,:,:),0)
aa(ia,:,:) = regCoef(pc2,cc(lat|:,lon|:,time|a1:b1));, tval, df);Y

copy_VarCoords(rref, aa(ia,:,:))

;----pattern correlation---------

rp1(ia) = pattern_cor(aa(ia,{SLAT:NLAT},{WLON:ELON}), rco_r({SLAT:NLAT},{WLON:ELON}), 1.0, 0)

;--------output-------------
if (MODEL.eq."cesm2_cmip5_forcing") then
fon=diri+"lens5/"+MODEL+"_"+ENSN(ia)+"_reg_"+IND+"_"+VARn(iv)+"_"+yrs1(i)+"-"+yrl1(i)+".nc";
else
fon=diri+"lens5/"+MODEL+"_"+EXP(im)+"_"+ENSN(ia)+"_reg_"+IND+"_"+VARn(iv)+"_"+yrs1(i)+"-"+yrl1(i)+".nc";
end if
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->rc  = aa(ia,:,:)
fo->par = rp1(ia)

delete([/locs_str,pc,xa,pc_ft,cc,dd,pc2,pc3/]);,pc_sea2,xa_sea2,
end do

aa!0 = "ensemble"
rp1!0 = "ensemble"
; ;--------output-------------
; fon=diri+"lens5/"+MODEL(ia)+"_reg_"+IND+"_"+EXP+"_"+VAR+"_"+yrs+"-"+yrl+".nc";
; system("rm -f "+fon)
; fo=addfile(fon,"c")
; fo->rc  = aa
; fo->par = rp1

delete([/locs/]);,x_Lead1

print("regression done for "+MODEL(0))
delete([/ENSN,aa,rp1/])

end do

print("regression done")
end do
end do

end
