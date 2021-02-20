begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
SEASON = (/"DJF","MAM","JJA","SON" /)

  yrs0 = 1850;1950;
  yrl0 = 2014
  ymstrt= yrs0*100+1
  ymlast= yrl0*100+12

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

diri1 = "/glade/collections/cmip/cmip6/"
diri2 = "/glade/work/chenxing/CMIP6/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip6/"

; MODEL6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
;         "CESM2","CESM2-WACCM-FV2",\
;         "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
;         "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",

; MODEL6 = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
;   "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",
; nens6 = (/32,30,25,12,11, 10,\;10,
;       10,10,7,5,5 /) ;ensemble number 5,

MODEL6 = (/ "CESM2"/)

nm6 = dimsizes(MODEL6)
nens_all = 32

VAR  = (/"ts","psl"/) ;"ua" ;"od550aer" ;"cloudeffect";"ts" ; "rsds" "va" ;"psl" ;
VARn = (/"ts","psl"/) ; "ua200"
EXP = "historical"
IND = "nino34" ;"mmeeof2" ;"mmeeof1" ;"GMAOD" ;"PDI2" ;"PDI"; "AR1Di" ;"SLPAL" ;"pdv";"TNA"; "AR1varm"; "TNA";
nlag = 5

yrs1 = (/1950,1991 /) ;1950;1950 ;1991;
yrl1 = (/1990,2014/) ;1990;1990 ;2014;

do iv = 0,dimsizes(VAR)-1
do iy = 0,dimsizes(yrs1)-1

do im = 0,nm6-1

;from pdv_cmip6_hist.ncl
;cmip6_historical_CanESM2_r4i1p1_pdv_1850-2014.nc
locs = systemfunc("ls "+diri+"cmip6/pdv/cmip6_historical_"+MODEL6(im)+"_*_pdv_1850-2014.nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

  aa = new((/nens_all,nlag, 72,144 /), "float")
  rp1 = new((/nens_all,nlag/), "float") ;cross correlation pattern

do ia = 0,nsa-1

 locs_str = str_split(locs(ia), "_"); "/")
 print("'" + locs_str + "'")
  ENSN  = locs_str(3)

  print(MODEL6(im)+" ens "+ENSN)

    file_name = diri3+EXP+"/"+VAR(iv)+"/"+MODEL6(im)+"_"+VAR(iv)+"_"+EXP+"_"+ENSN+".nc"
    file_name2 = diri+"cmip6/"+IND+"/cmip6_"+EXP+"_"+MODEL6(im)+"_"+ENSN+"_"+IND+"_1850-2014.nc"
    exists = isfilepresent(file_name)
    exists2 = isfilepresent(file_name2)
    if(.not.exists.or..not.exists2) then
      print(MODEL6(im)+" ens "+ENSN+" file not exist")
      print("Either the file doesn't exist, or NCL does")
      print("not have OPeNDAP cabilities on this system.")
      continue
    else

    f   = addfile(file_name, "r")
    end if


  TIME2=f->time
  yyyymm2=cd_calendar(TIME2, -1)
  printMinMax(yyyymm2, True)
  ymstrts = ind(yyyymm2.eq.ymstrt)
  ymlasts = ind(yyyymm2.eq.ymlast)
  print(ymstrts+" <--start end--> "+ymlasts)

    xx  = f->$VAR(iv)$(ymstrts:ymlasts,:,:);{20000},:,:);

  delete([/f,TIME2,yyyymm2/]);,lat,lon

  xa = rmMonAnnCycTLL(xx)

  ;------------filter----------------------
  fyr   = 8.
  ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
  sigma = 1.0                           ; Lanczos sigma
  nWgt  = toint(fyr*12*1+1); fyr)+1 ;                           ; odd only
  fca   = 1./(fyr*12)
  fcb   = -999.
  wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

  ;---------read output---------------

  ; ;PDV
  ; ; from pdv_cmip6_hist.ncl
  ; f1   = addfile(diri+"cmip6/pdv/cmip6_"+EXP+"_"+MODEL6(im)+"_"+ENSN+"_pdv_1850-2014.nc", "r")
  ; pc  = f1->pc(0,(yrs-1850)*12:)

  ;;some index
  ;from cmip_index.ncl
  f1   = addfile(diri+"cmip6/"+IND+"/cmip6_"+EXP+"_"+MODEL6(im)+"_"+ENSN+"_"+IND+"_1850-2014.nc", "r")
  ; pc  = tofloat(f1->gmst((yrs-1850)*12:))
  pc  = tofloat(f1->index((yrs0-1850)*12:)) ;fix to the year we want to start here
  ; pc_ft = wgt_runave_n_Wrap( pc, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions

  ; ;global external forcing mode
  ; ; from mme_eof_cmip6.ncl
  ;   f1   = addfile(diri+"cmip6/cmip6_historical_mme.eof_1850-2014.nc", "r")
  ;   pc  = f1->pc(1,:)

  ; ;Each model's MME index
  ; ff = systemfunc("ls "+diri+"cmip6/"+IND+"/cmip6_"+EXP+"_"+MODEL6(im)+"_*_"+IND+"_1850-2014.nc")
  ; f1   = addfiles(ff, "r")
  ; ListSetType (f1, "join")
  ; pc0  = f1[:]->index
  ; pc = wgt_runave_n_Wrap( pc0, wgt,  0, 1 )   ;opt < 0 : utilize cyclic conditions
  ; pc_ft = dim_avg_n_Wrap(pc, 0)
  ; delete([/ff,pc0/])

  ; pc_sea = month_to_seasonN(pc, SEASON)
  ; pc_sea2 = ndtooned(pc_sea)
  ; pc_sea2!0 = "time"
  delete([/xx /])


; normalize
pc = dim_standardize_n_Wrap(pc, 0, 0)

;-----------regression-------------
a1 = yrs1(iy)-yrs0
b1 = yrl1(iy)-yrs0

xa!0 = "time"
pc!0 = "time"
xa_sea = month_to_seasonN(xa,SEASON)
pc_sea = month_to_seasonN(pc,SEASON)

;reg with NINO34 DJF+1
do is=0,3
  aa(ia,is,:,:) = regCoef(pc_sea(0,a1+1:b1),xa_sea(season|is,lat|:,lon|:,time|a1:b1-1));, tval, df);Y
end do
;lag 0
aa(ia,4,:,:) = regCoef(pc_sea(0,a1:b1),xa_sea(season|0,lat|:,lon|:,time|a1:b1));, tval, df);Y

copy_VarCoords(xa(0,:,:), aa(ia,0,:,:))

;--------output-------------
fon=diri+"lens6/"+MODEL6(im)+"_"+ENSN+"_regLag_"+IND+"_"+EXP+"_"+VARn(iv)+"_"+yrs1(iy)+"-"+yrl1(iy)+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->rc = aa(ia,:,:,:)

delete([/locs_str,pc/]);,pc_sea2,xa_sea,pc_sea,xa
end do

delete([/locs/]);,x_Lead1

end do

end do
end do

end
