begin

diri = "/glade/work/chenxing/"

NLAT =   65; 5; 60;70;
SLAT =  -70;-5;-60; -50;
WLON =  100;120;100
ELON =  300;290;290;


MO = (/"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"/)
SEASON = (/"DJF","MAM", "JJA","SON" /)

;-----------------OBS---------------------------------------
f1 = addfile(diri+"air.2x2.250.mon.anom.comb.nc" , "r" )
; f1 = addfile(diri+"sst.ersst.v5.185401-201912.nc" , "r" )
TIME2=f1->time
yyyymm2=cd_calendar(TIME2, -1)
printMinMax(yyyymm2, True)
ymstrts = ind(yyyymm2.eq.188001)
ymlasts = ind(yyyymm2.eq.201812)
po1 = f1->air(ymstrts:ymlasts,:,:);{SLAT:NLAT},{WLON:ELON});

po1= dtrend_msg_n(po1&time,po1,False,False,0)
poc  = clmMonTLL(po1)
poa  = calcMonAnomTLL(po1, poc)

;-------------------------------------
;cover land data
;mask 0=ocean (land reserved), 1=land, 2=lake, 3=small island, 4=ice shelf.

 lland = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
 lsm0 = landsea_mask(lland->LSMASK,poa&lat,poa&lon)
 poa_sea = mask(poa,lsm0.eq.1, False)      ; mask out land points
 copy_VarMeta(poa, poa_sea)

delete(lsm0)

;------------remove global mean sst---------------
lat    = poa_sea&lat
rad    = 4.0*atan(1.0)/180.0
clat   = cos(lat*rad)
global_sst = wgt_areaave_Wrap(poa_sea,clat, 1.0, 1)
global_sst2 = conform_dims(dimsizes(poa_sea), global_sst, 0)

poa_r = poa_sea 
poa_r = poa_sea - global_sst2


; ;poa_r or poa: global mean removed or not
; ;montly mean 
poam = poa_r

;yearly mean
; poam = month_to_annual(poa_r, 1) ;0 is sum; 1 is mean

ndim = dimsizes(poam)
poam!0 = "time"
poam&time = ispan(1, ndim(0), 1)
poam= dtrend_msg_n(poam&time,poam,False,False,0) ;caveat --> unable to remove global sst mean!
printVarSummary(poam)
;-----------running average------
; endopt    = 1
;  nrun      = 3;*12
;  xam_rm = runave_n_Wrap (xam, nrun, endopt, 1)
;  poam_ft = runave_n_Wrap (poam, nrun, endopt, 0) 
;  printVarSummary(xam_rm)
;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*12+1);)+1;                            ; odd only
fca   = 1./(fyr*12););
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

poam_ft = wgt_runave_n_Wrap( poam, wgt, 0, 0 ) ;opt > 0 : utilize reflective (symmetric) conditions
copy_VarMeta(poam, poam_ft)
printVarSummary(poam_ft)
;-------------EOF----------------------------------------
  optEof = False
  neof   = 1
  XO = poam_ft(lat|:,lon|:,time|:); for IPO index
  eof    = eofunc_Wrap(XO({SLAT:NLAT},{WLON:ELON},:),neof,optEof)
  eof_ts = eofunc_ts_Wrap(XO({SLAT:NLAT},{WLON:ELON},:),eof,False)

; eof_ts    = eof_ts*-1.0
pc = dim_standardize_n_Wrap(eof_ts(:,:), 0, 1) ;eof_ts(0,:);
;Setting opt=1 means to use the population standard deviation (i.e., divide by the number of non-missing value [N]). 
;Otherwise, the sample standard deviation is used for normalization (i.e., divide by [N-1])
  printVarSummary(eof)
  printVarSummary(eof_ts)


;----original field regressed onto the index -----------
; rco    = poam(0:1,:,:)
; prob0  = poam(0:1,:,:)
; tval0  = poam(0,:,:)
; df0 = floattointeger(tval0 )
; do i=0,1
rco = regCoef(pc,poa(lat|:,lon|:,time|:));, tval0, df0);poam
;df0 = df0-2
;b10 = tval0               ; b must be same size as tval (and df) 
;b10 = 0.5 
;prob0(i,:,:) = (1-(betainc(df0/(df0+tval0^2),df0/2.0,b10)))*100 
; end do 
copy_VarCoords(poam(0,:,:),rco(0,:,:))
rco!0 = "eof"
pc!1 = "time"
printVarSummary(rco)


;--------output-------------
fon=diri+"enso/obs_pdv_1880-2018.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->rc = rco;(0,:,:)
fo->pc = pc;(0,:)
fo->pcvar = eof@pcvar;(0)

fon=diri+"enso/obs_org.pdv_1880-2018.nc";
system("rm -f "+fon)
fo1=addfile(fon,"c")
fo1->eof = eof(0,:,:)
fo1->pco = eof_ts

end
