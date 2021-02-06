begin

  ymstrt= 185001  
  ymlast= 201112
  yrstrt= 1850  
  yrlast= 2011

nyr = yrlast-yrstrt+1

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
nens = (/1, 11, 40, 50, 30, 20, 8, 100 /) ;ensemble number
nens_all = 100
yr_finish = 2011

MODEL = (/"OBS", "E3SM","CESM","CanESM2", "CSIRO-Mk3-6-0","GFDL-CM3","GFDL-ESM2M","MPI-ESM" /)
nmo = dimsizes(MODEL)

do im = 1,nmo-1

nino3 = new((/nens_all, ntimes(im)*12/), "float")
nino4 = nino3 
nino34 = nino3
epi   = nino3
cpi   = nino3

do ia = 0,nens_all-1;nens(im)-1

ib = ia+1


f_input = systemfunc(" ls -1 /glade/work/chenxing/sst.ersst.v5.185401-201912.nc") 

ea = sprinti("%0.2i", ib)

;from read_opendap_e3sm.ncl
if (MODEL(im).eq."E3SM") then 
f_input = systemfunc(" ls -1 "+diri1+"E3SM_en"+ea+"_TS_185001-201112.nc") 
else if (MODEL(im).eq."CESM") then  
f_input = systemfunc(" ls -1 "+diri2+"ts_Amon_CESM1-CAM5_historical_rcp85_r"+ib+"i1p1_192001-210012.nc") 
else if (MODEL(im).eq."CanESM2") then  
f_input = systemfunc(" ls -1 "+diri3+"ts_Amon_CanESM2_historical_rcp85_r"+ib+"i1p1_195001-210012.nc") 
else if (MODEL(im).eq."CSIRO-Mk3-6-0") then  
f_input = systemfunc(" ls -1 "+diri4+"ts_Amon_CSIRO-Mk3-6-0_historical_rcp85_r"+ib+"i1p1_185001-210012.nc") 
else if (MODEL(im).eq."GFDL-CM3") then  
f_input = systemfunc(" ls -1 "+diri5+"ts_Amon_GFDL-CM3_historical_rcp85_r"+ib+"i1p1_192001-210012.nc") 
else if (MODEL(im).eq."GFDL-ESM2M") then  
f_input = systemfunc(" ls -1 "+diri6+"ts_Amon_GFDL-ESM2M_historical_rcp85_r"+ib+"i1p1_195001-210012.nc") 
else if (MODEL(im).eq."MPI-ESM") then  
f_input = systemfunc(" ls -1 "+diri7+"ts_Amon_MPI-ESM_historical_rcp85_r"+ib+"i1p1_185001-209912.nc") 
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
  ; ymstrt1 = ind(yyyymm.eq.ymstrt)
  ; ymlast1 = ind(yyyymm.eq.ymlast)
  ; print(yyyymm)
  ; print(ymstrt1)
  ; print(ymlast1)
  x = f->ts(:,{-10:10},:);(ymstrt1(0):ymlast1(0),{SLAT:NLAT},{WLON:ELON})
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

  NLAT =   5  
  SLAT =  -5 

  WLON34 =  190
  ELON34 =  240
  o34 = wgt_areaave_Wrap(xa(:,{SLAT:NLAT},{WLON34:ELON34}),clat({SLAT:NLAT}), 1.0, 1)
  WLON3 =  210
  ELON3 =  270
  o3 = wgt_areaave_Wrap(xa(:,{SLAT:NLAT},{WLON3:ELON3}),clat({SLAT:NLAT}), 1.0, 1)
  WLON4 =  160
  ELON4 =  210
  o4 = wgt_areaave_Wrap(xa(:,{SLAT:NLAT},{WLON4:ELON4}),clat({SLAT:NLAT}), 1.0, 1)

  nino34(ia,:) = o34 ;dim_standardize_n_Wrap(o34, 1, 0)
  nino3(ia,:)  = o3  ;dim_standardize_n_Wrap(o3, 1, 0)
  nino4(ia,:)  = o4  ;dim_standardize_n_Wrap(o4, 1, 0)

;
; EP CP index http://www.bom.gov.au/research/projects/El-Nino-Indices/
; EP = Niño3_normalized – 0.5 * Niño4_normalized
; CP = Niño4_normalized – 0.5 * Niño3_normalized
; Mixed type = EP + CP ≈ Niño3.4_normalized

epi(ia,:) = o3 - 0.5*o4
cpi(ia,:) = o4 - 0.5*o3 
; end do
; nino34!0 = "ensemble"
printVarSummary(cpi)

print(MODEL(im)+" ens "+ea)
end do 
nino3!0 = "ensemble"
nino4!0 = "ensemble"
nino34!0 = "ensemble"
copy_VarMeta(nino3, epi)
copy_VarMeta(nino3, cpi)
epi@long_name = "EP index = Niño3_normalized – 0.5 * Niño4_normalized"
cpi@long_name = "CP index = Niño4_normalized – 0.5 * Niño3_normalized"
; go@long_name = "original data"
nino34@long_name = "normalized Nino34 index"
nino3@long_name = "normalized Nino3 index"
nino4@long_name = "normalized Nino4 index"

;------output--------------
fon=diri+MODEL(im)+"_ENSO_index.nc";
if (MODEL(im).eq."OBS") then
  fon=diri+"ERSSTv5_ENSO_index_185401-201912.nc";
end if 

system("rm -f "+fon)
fo=addfile(fon,"c")
fo->nino34 = nino34
fo->nino3 = nino3
fo->nino4 = nino4
fo->epi   = epi
fo->cpi   = cpi
; fo->org_index = go

delete([/x, xa, xc, lat, clat, o3, o34, o4,nino34,nino3,nino4,epi,cpi   /])
end do 

end