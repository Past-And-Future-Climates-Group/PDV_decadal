begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

diri1 = "/glade/work/chenxing/enso/E3SM/"
diri2 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/"
; diri2 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/cesm_lens/Amon/ts/"
; ;ts_Amon_CESM1-CAM5_historical_rcp85_r40i1p1_192001-210012.nc
; diri3 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/canesm2_lens/Amon/ts/"
; ;ts_Amon_CanESM2_historical_rcp85_r50i1p1_195001-210012.nc
; diri4 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/csiro_mk36_lens/Amon/ts/"
; ;ts_Amon_CSIRO-Mk3-6-0_historical_rcp85_r30i1p1_185001-210012.nc
; diri5 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/gfdl_cm3_lens/Amon/ts/"
; ;ts_Amon_GFDL-CM3_historical_rcp85_r20i1p1_192001-210012.nc
; diri6 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/gfdl_esm2m_lens/Amon/ts/"
; ;ts_Amon_GFDL-ESM2M_historical_rcp85_r8i1p1_195001-210012.nc
; diri7 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/mpi_lens/Amon/ts/"
; ;ts_Amon_MPI-ESM_historical_rcp85_r100i1p1_185001-209912.nc

MODEL_LOCS = (/"cesm_lens","canesm2_lens","csiro_mk36_lens",\;"ec_earth_lens",
  "gfdl_cm3_lens","gfdl_esm2m_lens","mpi_lens" /)
MODEL_NAME = (/"CESM1-CAM5","CanESM2","CSIRO-Mk3-6-0",\;"EC-EARTH",
  "GFDL-CM3","GFDL-ESM2M","MPI-ESM" /)

VAR = "ts" ;"netsw" ;"ts" ;"netcssw" ;"cloudeffect" ;"psl" ; "tas"
EXP = "historical";"hist-nat" ;"hist-GHG" ;"hist-aer" ;"historicalGHG" ;"historicalNat" ;


nm = dimsizes(MODEL_LOCS)

do im = 0,nm-1

diri3 = diri2+MODEL_LOCS(im)+"/Amon/"+VAR+"/"

locs = systemfunc("ls "+diri3+"*rcp85*")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

MODEL = new(nsa, "string")
ENSN  = new(nsa, "string")

istart = 0
do ie = istart,nsa-1

 locs_str0 = str_split(locs(ie), "/")
 locs_str = str_split(locs_str0(9), "_"); "/")
 print("'" + locs_str + "'")


MODEL(ie) = locs_str(2)
ENSN(ie)  = locs_str(5)

bb = str_split(locs_str(6), "-")

  yrl = 2014
  ymlast= yrl*100+12
if(ie.eq.0) then
  ymstrt= bb(0)
  yrs = toint(tofloat(bb(0))/100.)
end if

print(ymstrt+", "+yrs)
print(MODEL(ie)+" ens "+ENSN(ie))

  fils = systemfunc("ls "+locs(ie));+"/*.nc")
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

    xx  = f[:]->$VAR$(ymstrts:ymlasts,:,:);ce;


; ;climatology is 1975-2005
; xc = clmMonTLL(f[:]->$VAR$(ycstrts:yclasts,:,:))
; xa = calcMonAnomTLL(xx, xc)
xa = rmMonAnnCycTLL(xx)
; xa = dtrend_msg_n(xa&time, xa, True, False, 0)

xa_sea = xa
delete([/fils,f,TIME2,yyyymm2/]);,lat,lon
; ;-------------------------------------
; ;cover land data; do this first!!
; ;mask 0=ocean (land reserved), 1=land, 2=lake, 3=small island, 4=ice shelf.

;  lland = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
;  lsm0 = landsea_mask(lland->LSMASK,xa&lat,xa&lon)
;  xa_sea = mask(xa,lsm0.eq.1, False)      ; mask out land points
;  copy_VarMeta(xa, xa_sea)

; delete(lsm0)

;-------------------------
; Calculating index
; Nino 1+2 (0-10S, 90W-80W), Nino 3 (5N-5S, 150W-90W),
; Nino 3.4/ONI (5N-5S, 170W-120W) and Nino 4 (5N-5S, 160E-150W)
; TNI is Nino 1+2 - Nino 4
;
; TNA: Tropical Northern Atlantic Index* Anomaly of the average of the monthly SST from 5.5N to 23.5N and 15W to 57.5W.
; Enfield, D.B., A.M. Mestas, D.A. Mayer, and L. Cid-Serrano, 1999: How ubiquitous is the dipole relationship in
; tropical Atlantic sea surface temperatures? JGR-O, 104, 7841-7848.AOML and PSL

; NPGO index: SLP index is over the Hawaiian region (158W–135W;13N–24N)
; PDO SLP index: SLP over Northeast Pacific (25–61N, 179–111W)

; Pacific dipole (tripole) SST index: a 30-50N, 130E-160W b 10S-10N,150E-100W. b-a
; Pacific dipole (tripole) SST index2 (adapted from Dong et al. 2014 GRL): a 30-45N, 145E-180W b 10S-6N,160W-110W. b-a

; NP cloud effect index: 30-50N, 120E-110W

; East Asian (EA) SW: 20-40N,110-125E
; East American (AM) SW: 30-45N,90-75W

; SW_HD net surface SW radiation between Southern and Northern Hemisphere (Southern-Northern)

  lat = xa_sea&lat
  rad    = 4.0*atan(1.0)/180.0
  clat   = cos(lat*rad)
  copy_VarCoords(xa_sea(0,:,0), clat)
  ; go = wgt_areaave_Wrap(x,clat, 1.0, 1)

  NLAT1 =  5.
  SLAT1 =  -5.
  WLON1 =  360.-170.
  ELON1 =  360.-120.;

  ; NLAT2 =  6.
  ; SLAT2 =  -10.
  ; WLON2 =  360.-160.;
  ; ELON2 =  360.-110.;

  gmst1 = wgt_areaave_Wrap(xa_sea(:,{SLAT1:NLAT1},{WLON1:ELON1}),clat({SLAT1:NLAT1}), 1.0, 1)
  ; gmst2 = wgt_areaave_Wrap(xa_sea(:,{SLAT2:NLAT2},{WLON2:ELON2}),clat({SLAT2:NLAT2}), 1.0, 1)

  gmst = gmst1
  ; gmst = gmst2 - gmst1
  gmst@long_name = "nino34_ts" ;


; ;------------filter----------------------
; fyr   = 8.
; ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
; sigma = 1.0                           ; Lanczos sigma
; nWgt  = toint(fyr*12*2+1) ;fyr)+1 ;                           ; odd only
; fca   = 1./(fyr*12););
; fcb   = -999.
; wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

; gmst = wgt_runave_n_Wrap( gmst, wgt,  -1, 0 )   ;opt < 0 : utilize cyclic conditions


; gmst = dtrend_msg_n(gmst&time, gmst, True, False, 0)


;--------output-------------
fon=diri+"lens5/nino34/"+MODEL(ie)+"_"+EXP+"_"+ENSN(ie)+"_nino34_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->index = gmst

delete([/xx, xa,xa_sea,clat,lat/])

end do
delete([/MODEL,ENSN,locs,gmst1,gmst /]);gmst2,
end do

end
