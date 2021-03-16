begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

; VAR = "TS" ;"netsw" ;"ts" ;"netcssw" ;"cloudeffect" ;"psl" ; "tas"

; MODEL = "cesm2_cmip5_forcing" ;"cesm1_le";

diri1 = "/glade/scratch/chenxing/aerosol/"

;CMIP5 aerosols
;IPCC_emissions_BC_anthropogenic_1860_0.5x0.5_v1_21_05_2009.nc

BB = "yes"
AER = (/"BC","CO","NH3","NMVOC","NOx","OC","SO2" /); "CH4",
;0: Agriculture; 1: Energy; 2: Industrial; 3: Transportation; 4: Residential, Commercial, Other
;5: Solvents production and application; 6: Waste; 7: International Shipping

;CMIP6 aerosols
;0: Agriculture; 1: Energy; 2: Industrial; 3: Transportation; 4: Residential, Commercial, Other
;5: Solvents production and application; 6: Waste; 7: International Shipping
;NOx-em-anthro_input4MIPs_emissions_CMIP_CEDS-2017-05-18_gn_190001-194912.nc
;BC-em-biomassburning_input4MIPs_emissions_CMIP_VUA-CMIP-BB4CMIP6-1-2_gn_185001-201512.nc

nm = dimsizes(AER)


do im = 0,nm-1

if (BB.eq."yes") then
  if (AER.eq."NMVOC") then
    fils = systemfunc("ls "+diri1+"cmip6/"+AER(im)+"-bulk-em-biomassburning_input4MIPs_emissions_CMIP*")
  else
    fils = systemfunc("ls "+diri1+"cmip6/"+AER(im)+"-em-biomassburning_input4MIPs_emissions_CMIP*")
  end if
else
  fils = systemfunc("ls "+diri1+"cmip6/"+AER(im)+"-em-anthro_input4MIPs_emissions_CMIP*")
end if
print(fils)
 f   = addfiles(fils, "r")  ;multiple files
 ListSetType (f, "cat")        ; concatenate (=default)

; ;only do historical part here first
; TIME2=f[:]->time
; yyyymm2=cd_calendar(TIME2, -1)
; printMinMax(yyyymm2, True)
; ymstrts = ind(yyyymm2.eq.ymstrt)
; ymlasts = ind(yyyymm2.eq.ymlast)
; print(ymstrts+" <--start end--> "+ymlasts)
aa = str_concat((/AER(im),"_em_anthro"/))
if (BB.eq."yes") then
  x  = f[:]->$AER(im)$;(ymstrts:ymlasts,:,:);
  x!1 = "lat"
  x!2 = "lon"
  xx = x
else
  x  = f[:]->$aa$;(ymstrts:ymlasts,:,:);
  x!2 = "lat"
  x!3 = "lon"
  xx = dim_avg_n_Wrap(x,1)
end if
printVarSummary(xx)
printVarSummary(x)

xx1 = month_to_annual(xx,0) ;0 sum 1 average
printVarSummary(xx1)

;--------output-------------
if (BB.eq."yes") then
fon=diri+"aerosol/cmip6_"+AER(im)+"_biomassburning.nc";
else
fon=diri+"aerosol/cmip6_"+AER(im)+"_anthropogenic.nc";
end if
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->emiss = x

;-------------------------
; Calculating index
; East Asian (EA) SW: 20-40N,110-125E
; East American (AM) SW: 30-45N,90-75W

NLAT1 =  90. ; 40.
SLAT1 =  -90.;20.
WLON1 =  0. ;110.
ELON1 =  360.;125.

lat = xx1&lat
lon = xx1&lon

re   = 6.37122e06
rad  = 4.0 * atan(1.0) / 180.
con  = re * rad
clat = cos(lat * rad)           ; cosine of latitude

dlon = (lon(2) - lon(1))        ; assume dlon is constant
dlat = (lat(2) - lat(1))        ; assume dlat is constant

dx   = con * dlon * clat        ; dx at each latitude
dy   = con * dlat               ; dy is constant
dydx = dy * dx                  ; dydx(nlat)

wgt  = new((/dimsizes(lat), dimsizes(lon)/), typeof(xx1))
printVarSummary(wgt)
printVarSummary(dydx)
wgt  = conform(wgt, tofloat(dydx), 0)

copy_VarCoords(xx1(0,:,:), wgt)

gmst1 = wgt_areasum2(xx1(:,{SLAT1:NLAT1},{WLON1:ELON1}),wgt({SLAT1:NLAT1},{WLON1:ELON1}), 1)

  gmst = gmst1
  gmst@long_name = "area sum "+AER(im) ;


;--------output-------------
if (BB.eq."yes") then
fon=diri+"aerosol/cmip6_"+AER(im)+"_biomassburning_GM.nc";
else
fon=diri+"aerosol/cmip6_"+AER(im)+"_anthropogenic_GM.nc";
end if
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->index = gmst

delete([/xx, xx1,clat,lat,aa/])
print("cal done for "+AER(im))

end do


end
