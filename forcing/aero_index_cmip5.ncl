begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

; VAR = "TS" ;"netsw" ;"ts" ;"netcssw" ;"cloudeffect" ;"psl" ; "tas"

; MODEL = "cesm2_cmip5_forcing" ;"cesm1_le";

diri1 = "/glade/scratch/chenxing/aerosol/"

;CMIP5 aerosols
;IPCC_emissions_BC_anthropogenic_1860_0.5x0.5_v1_21_05_2009.nc
;IPCC_GriddedBiomassBurningEmissions_BC_decadalmonthlymean1940_v1.nc
BB = "no"
if (BB.eq."yes") then
AER = (/"BC","CH4","CO","NH3","NMVOC","NOx","OC","SO2"/) ;
EMI = (/"grassfire","forestfire"/);
else
AER = (/"BC","CH4","CO","NH3","NMVOC","NO","OC","SO2" /);
EMI = (/"emiss_awb","emiss_wst","emiss_dom","emiss_ene","emiss_ind","emiss_tra"/) ;
end if

;CMIP6 aerosols
;0: Agriculture; 1: Energy; 2: Industrial; 3: Transportation; 4: Residential, Commercial, Other
;5: Solvents production and application; 6: Waste; 7: International Shipping
;NOx-em-anthro_input4MIPs_emissions_CMIP_CEDS-2017-05-18_gn_190001-194912.nc


nm = dimsizes(AER)
nv = dimsizes(EMI)

do im = 0,nm-1

  if (BB.eq."yes") then
    fils = systemfunc("ls "+diri1+"cmip5/remap/IPCC_GriddedBiomassBurningEmissions_"+AER(im)+"_decadalmonthlymean*");+"/*.nc")
  else
  fils = systemfunc("ls "+diri1+"cmip5/remap/IPCC_emissions_"+AER(im)+"_anthropogenic*");+"/*.nc")
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
xx = new((/192,72,144/),"float") ;360,720
xx = 0.
x = xx
x_all = new((/192,nv,72,144/),"float")
do iv = 0,nv-1
  x = 0.
  if (AER(im).eq."CO".and.EMI(iv).eq."emiss_ene") then
    x(12:,:,:)  = f[1:]->$EMI(iv)$

  else if (AER(im).eq."NH3".and.EMI(iv).eq."emiss_wst") then
    continue
  else if (AER(im).eq."NH3".and.EMI(iv).eq."emiss_dom") then
    ; x  = f[/0,1,2,3,7/]->$EMI(iv)$
    continue
  else if (AER(im).eq."NH3".and.EMI(iv).eq."emiss_ene") then
    x(12*2:,:,:)  = f[2:]->$EMI(iv)$
  else if (AER(im).eq."NH3".and.EMI(iv).eq."emiss_tra") then
    x(12*2:,:,:)  = f[2:]->$EMI(iv)$
  else if (AER(im).eq."SO2".and.EMI(iv).eq."emiss_ene") then
    x(12:,:,:)  = f[1:]->$EMI(iv)$

  else if (AER(im).eq."NMVOC".and.EMI(iv).eq."emiss_ene") then
      x(12:,:,:)  = f[1:]->$EMI(iv)$
  else if (AER(im).eq."NMVOC".and.EMI(iv).eq."emiss_tra") then
      x(12*2:,:,:)  = f[2:]->$EMI(iv)$

  else
   x  = f[:]->$EMI(iv)$
  end if
  end if
  end if
  end if
  end if
  end if
  end if
  end if
   printVarSummary(x)
   x_all(:,iv,:,:) = x

end do
; x_all!0 = "time"
; x_all!2 = "lat"
; x_all!3 = "lon"
xx = dim_avg_n_Wrap(x_all,1)
xx@units = x@units

copy_VarMeta(x,xx)
copy_VarMeta(x,x_all(:,0,:,:))
printVarSummary(xx)
x_all!1 = "sector"
printVarSummary(x_all)

xx1 = month_to_annual(xx,0) ;0 sum 1 average
printVarSummary(xx1)

;--------output-------------
if (BB.eq."yes") then
  fon=diri+"aerosol/cmip5_"+AER(im)+"_biomassburning.nc";
else
  fon=diri+"aerosol/cmip5_"+AER(im)+"_anthropogenic.nc";
end if
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->emiss = x_all

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
  wgt  = conform(wgt, tofloat(dydx), 0)

  copy_VarCoords(xx1(0,:,:), wgt)

  gmst1 = wgt_areasum2(xx1(:,{SLAT1:NLAT1},{WLON1:ELON1}),wgt({SLAT1:NLAT1},{WLON1:ELON1}), 1)

  gmst = gmst1
  gmst@long_name = "area sum "+AER(im) ;


;--------output-------------
if (BB.eq."yes") then
  fon=diri+"aerosol/cmip5_"+AER(im)+"_biomassburning_GM.nc";
else
  fon=diri+"aerosol/cmip5_"+AER(im)+"_anthropogenic_GM.nc";
end if
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->index = gmst

delete([/xx, xx1,wgt,lat,fils,f/])
print("cal done for "+AER(im))

end do


end
