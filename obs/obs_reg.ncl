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

IND = "PDI" ;"mmeeof2" ;"mmeeof1" ;"GMAOD" ;"PDI2" ;"PDI"; "AR1Di" ;"SLPAL" ;"pdv";"TNA"; "AR1varm"; "TNA";
AA =  ""

yrs = 1854
yrl = 2019
ymstrt= yrs*100+1
ymlast= yrl*100+12


f   = addfile("/glade/work/chenxing/sst.ersst.v5.185401-201912.nc", "r")  ;multiple files

;only do historical part here first
TIME2=f->time
yyyymm2=cd_calendar(TIME2, -1)
printMinMax(yyyymm2, True)
ymstrts = ind(yyyymm2.eq.ymstrt)
ymlasts = ind(yyyymm2.eq.ymlast)
ycstrts = ind(yyyymm2.eq.197501)
yclasts = ind(yyyymm2.eq.200412)
print(ymstrts+" <--start end--> "+ymlasts)

xx  = f->sst(ymstrts:ymlasts,:,:);

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

  f1   = addfile(diri+"obs_"+IND+"_1854-2019.nc", "r")
  pc  = f1->index
  pc_ft = wgt_runave_n_Wrap( pc, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions

; ???
pc_ft = dim_standardize_n_Wrap(pc_ft, 0, 0)
printVarSummary(pc_ft)

;-----------regression-------------
rc = regCoef(pc_ft,xa(lat|:,lon|:,time|:));, tval, df);Y
copy_VarCoords(xx(0,:,:), rc)
printVarSummary(rc)

;--------output-------------
fon=diri+"obs_reg_"+IND+"_sst_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->rc  = rc

end
