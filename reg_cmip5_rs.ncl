begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

  yrs = 1861;1950;
  yrl = 2004
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/"
SEASON = (/"DJF","MAM","JJA","SON" /)

MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;"bcc-csm1-1-m",
      "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
      "GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
      "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\;"MRI-ESM1",
      "NorESM1-ME","NorESM1-M"/)

M5_YES = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","HadGEM2-CC",\;,"GFDL-CM3"
          "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM-CHEM","MIROC-ESM",\
          "MRI-CGCM3","NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

M5_NO = (/"bcc-csm1-1","BNU-ESM","CCSM4","CESM1-BGC","CESM1-FASTCHEM","CESM1-WACCM",\
          "GFDL-ESM2G","MPI-ESM-LR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

MODEL5_LE = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
             "IPSL-CM5A-LR", "CanESM2", "MIROC5"/);"GFDL-CM3",
nens5 = (/10,10,10,8,6,6,6,\
         6,5,5 /);5,

nm5 = dimsizes(MODEL5)

i5y = new(dimsizes(M5_YES), "integer")
do i = 0,dimsizes(M5_YES)-1
  i5y(i) = ind(MODEL5.eq.M5_YES(i))
end do 
i5n = new(dimsizes(M5_NO), "integer")
do i = 0,dimsizes(M5_NO)-1
  i5n(i) = ind(MODEL5.eq.M5_NO(i))
end do 
i5le = new(dimsizes(MODEL5_LE), "integer")
do i = 0,dimsizes(MODEL5_LE)-1
  i5le(i) = ind(MODEL5.eq.MODEL5_LE(i))
end do 

VARu = "rsuscs" ;"rsus" ; 
VARd = "rsdscs" ; "rsds" ;
EXP = "historical"
IND = "mmeeof2" ;"mmeeof2" ;"SLPAL" ;"pdv";"TNA"; "AR1varm"; "TNA"; 

nens_all = 10


; note, the max lag should not be more than N/4
ccr1 = new((/nm5, 72,144 /), "float") ;cross correlation pattern

do im = 0,nm5-1

;from pdv_cmip5_hist.ncl
;cmip5_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
locs = systemfunc("ls "+diri+"cmip5/pdv/cmip5_historical_"+MODEL5(im)+"_*_pdv_1861-2004.nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

  aa = new((/nens_all, 72,144 /), "float") 

do ia = 0,nsa-1
  
 locs_str = str_split(locs(ia), "_"); "/")
 print("'" + locs_str + "'")
  ENSN  = locs_str(3)

  print(MODEL5(im)+" ens "+ENSN)
      file_name1 = diri3+EXP+"/"+VARu+"/"+MODEL5(im)+"_"+VARu+"_historical_"+ENSN+".nc"
      file_name2 = diri3+EXP+"/"+VARd+"/"+MODEL5(im)+"_"+VARd+"_historical_"+ENSN+".nc"
    exists = isfilepresent(file_name1)
    exists2 = isfilepresent(file_name2)
    if(.not.exists.or..not.exists2) then
      print(MODEL5(im)+" ens "+ENSN+" file not exist")
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
  ; ; from pdv_cmip5_hist.ncl
  ; f1   = addfile(diri+"cmip5/pdv/cmip5_"+EXP+"_"+MODEL5(im)+"_"+ENSN+"_pdv_1861-2004.nc", "r") 
  ; pc  = f1->pc(0,(yrs-1861)*12:)


  ; ;;some index
  ; ;from cmip_index.ncl
  ; f1   = addfile(diri+"cmip5/"+IND+"/cmip5_"+EXP+"_"+MODEL5(im)+"_"+ENSN+"_"+IND+"_1861-2004.nc", "r") 
  ; ; pc  = tofloat(f1->gmst((yrs-1861)*12:))
  ; pc  = tofloat(f1->index((yrs-1861)*12:))
  ; ; pc  = dtrend(pc, 0)

  ;global external forcing mode
  ; from mme_eof_cmip6.ncl 
  
    f1   = addfile(diri+"cmip5/cmip5_historical_mme.eof_1861-2004.nc", "r") 
    pc  = f1->pc(1,:)

  pc_annual = month_to_annual(pc, 1)
  ; pc_sea = month_to_seasonN(pc, SEASON)
  ; pc_sea2 = ndtooned(pc_sea)
  ; pc_sea2!0 = "time"
  delete([/xx/]);,xa_sea,pc_sea /])
  
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
  
delete([/locs_str,pc,xa_sea2/]);,pc_sea2,xa
end do 

;ensemble mean
ccr1(im,:,:) = dim_avg_n_Wrap(aa, 0)

delete([/locs/]);,x_Lead1

end do 

ccr1!0 = "model"
printVarSummary(ccr1)

;--------output-------------
fon=diri+"cmip5_reg_"+IND+"_"+EXP+"_"+VARd+"-"+VARu+"_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->ccr1 = ccr1


end
