begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"


  yrs = 1850;1950; 
  yrl = 2014
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

diri1 = "/glade/collections/cmip/cmip6/"
diri2 = "/glade/work/chenxing/CMIP6/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip6/"
SEASON = (/"DJF","MAM","JJA","SON" /)

MODEL6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
        "CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
        "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",

MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
  "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",
nens6 = (/32,30,25,12,11, 10, 10,\;10,
          10,7,5,5 /) ;ensemble number 5,

i6le = new(dimsizes(MODEL6_LE), "integer")
do i = 0,dimsizes(MODEL6_LE)-1
  i6le(i) = ind(MODEL6.eq.MODEL6_LE(i))
end do 

nm6 = dimsizes(MODEL6)
nens_all = 32

VARu = "rsuscs" ;"rsus" ; 
VARd = "rsdscs" ; "rsds" ;
EXP = "historical"
IND = "mmeeof2";"mmeeof2" ;"pdv" ;"SLPAL" ;"TNA" ; "AR1varm"; "TNA"; "PDV"

; note, the max lag should not be more than N/4
ccr1 = new((/nm6, 72,144 /), "float") ;cross correlation pattern

do im = 0,nm6-1

;from pdv_cmip6_hist.ncl
;cmip6_historical_CanESM2_r4i1p1_pdv_1850-2014.nc
locs = systemfunc("ls "+diri+"cmip6/pdv/cmip6_historical_"+MODEL6(im)+"_*_pdv_1850-2014.nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

  aa = new((/nens_all, 72,144 /), "float") 

do ia = 0,nsa-1
  
 locs_str = str_split(locs(ia), "_"); "/")
 print("'" + locs_str + "'")
  ENSN  = locs_str(3)

  print(MODEL6(im)+" ens "+ENSN)

      file_name1 = diri3+EXP+"/"+VARu+"/"+MODEL6(im)+"_"+VARu+"_historical_"+ENSN+".nc"
      file_name2 = diri3+EXP+"/"+VARd+"/"+MODEL6(im)+"_"+VARd+"_historical_"+ENSN+".nc"
    exists = isfilepresent(file_name1)
    exists2 = isfilepresent(file_name2)
    if(.not.exists.or..not.exists2) then
      print(MODEL6(im)+" ens "+ENSN+" file not exist")
      print("Either the file doesn't exist, or NCL does")
      print("not have OPeNDAP cabilities on this system.")
      continue
    else
  
  fu   = addfile(file_name1, "r") 
  fd   = addfile(file_name2, "r") 
    end if   


  TIME2=fu->time
  yyyymm2=cd_calendar(TIME2, -1)
  printMinMax(yyyymm2, True)
  ymstrts = ind(yyyymm2.eq.ymstrt)
  ymlasts = ind(yyyymm2.eq.ymlast)
  print(ymstrts+" <--start end--> "+ymlasts)

    xu  = fu->$VARu$(ymstrts:ymlasts,:,:)
    xd  = fd->$VARd$(ymstrts:ymlasts,:,:)

    xx = xu 
    xx = xd - xu 
    xx@long_name = "surface net radiant"
    xx= dtrend_msg_n(xx&time,xx,False,False,0)
  delete([/fu,fd,TIME2,yyyymm2,xu,xd/]);,lat,lon
   
  xa = rmMonAnnCycTLL(xx)
  
  xa_annual = month_to_annual(xa, 1)
  xa_sea = month_to_seasonN(xa, SEASON)
  ;season, year --> season * year one dimension
  ndim1 = dimsizes(xa_sea)
  xa_sea2 = reshape(xa_sea, (/ndim1(0)*ndim1(1),ndim1(2),ndim1(3) /) )
  xa_sea2!0 = "time"
  copy_VarMeta(xa(0,:,:), xa_sea2(0,:,:))

  ;---------read output---------------
  
  ; ;PDV
  ; ; from pdv_cmip6_hist.ncl
  ; f1   = addfile(diri+"cmip6/pdv/cmip6_"+EXP+"_"+MODEL6(im)+"_"+ENSN+"_pdv_1850-2014.nc", "r") 
  ; pc  = f1->pc(0,(yrs-1850)*12:)

  ; ;;some index
  ; ;from cmip_index.ncl
  ; f1   = addfile(diri+"cmip6/"+IND+"/cmip6_"+EXP+"_"+MODEL6(im)+"_"+ENSN+"_"+IND+"_1850-2014.nc", "r") 
  ; ; pc  = tofloat(f1->gmst((yrs-1850)*12:))
  ; pc  = tofloat(f1->index((yrs-1850)*12:))
  ; ; pc  = dtrend(pc, 0)

  ;global external forcing mode
  ; from mme_eof_cmip6.ncl 
    f1   = addfile(diri+"cmip6/cmip6_historical_mme.eof_1850-2014.nc", "r") 
    pc  = f1->pc(1,:)

  pc_annual = month_to_annual(pc, 1)
  ; pc_sea = month_to_seasonN(pc, SEASON)
  ; pc_sea2 = ndtooned(pc_sea)
  ; pc_sea2!0 = "time"
  delete([/xx /])
  
;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*12*1+1); fyr)+1 ;                           ; odd only
fca   = 1./(fyr*12)
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )
pc_ft = wgt_runave_n_Wrap( pc, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions 


;-----------regression-------------
aa(ia,:,:) = regCoef(pc_ft,xa(lat|:,lon|:,time|:));, tval, df);Y

copy_VarCoords(xa(0,:,:), aa(ia,:,:))
  
delete([/locs_str,pc,xa_sea2/]);,pc_sea2,xa_sea,pc_sea,xa
end do 

;ensemble mean
ccr1(im,:,:) = dim_avg_n_Wrap(aa, 0)

delete([/locs/]);,x_Lead1

end do 

ccr1!0 = "model"
printVarSummary(ccr1)
;--------output-------------
fon=diri+"cmip6_reg_"+IND+"_"+EXP+"_"+VARd+"-"+VARu+"_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->ccr1 = ccr1


end
