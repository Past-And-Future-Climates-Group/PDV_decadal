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

VARu = "rsut" ;"rsuscs" ;"rsus" ; 
VARd = "rsdt" ;"rsdscs" ;"rsds" ;
; VARcu = "rsuscs" ;
; VARcd = "rsdscs" ;
EXP = "historical"
IND = "mmeeof2" ;"mmeeof2" ;"SLPAL" ;"pdv";"TNA"; "AR1varm"; "TNA"; 

do im = 0,nm6-1

;from pdv_cmip6_hist.ncl
;cmip6_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
locs = systemfunc("ls "+diri+"cmip6/pdv/cmip6_historical_"+MODEL6(im)+"_*_pdv_1850-2014.nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

do ia = 0,nsa-1
  
 locs_str = str_split(locs(ia), "_"); "/")
 print("'" + locs_str + "'")
  ENSN  = locs_str(3)

  print(MODEL6(im)+" ens "+ENSN)
      file_name1 = diri3+EXP+"/"+VARu+"/"+MODEL6(im)+"_"+VARu+"_historical_"+ENSN+".nc"
      file_name2 = diri3+EXP+"/"+VARd+"/"+MODEL6(im)+"_"+VARd+"_historical_"+ENSN+".nc"
      ; file_name3 = diri3+EXP+"/"+VARcu+"/"+MODEL6(im)+"_"+VARcu+"_historical_"+ENSN+".nc"
      ; file_name4 = diri3+EXP+"/"+VARcd+"/"+MODEL6(im)+"_"+VARcd+"_historical_"+ENSN+".nc"
    exists = isfilepresent(file_name1)
    exists2 = isfilepresent(file_name2)
    ; exists3 = isfilepresent(file_name3)
    ; exists4 = isfilepresent(file_name4)
    if(.not.exists.or..not.exists2) then
      print(MODEL6(im)+" ens "+ENSN+" file not exist")
      print("Either the file doesn't exist, or NCL does")
      print("not have OPeNDAP cabilities on this system.")
      continue
    else
  
  fu   = addfile(file_name1, "r") 
  fd   = addfile(file_name2, "r") 
  ; f3   = addfile(file_name3, "r") 
  ; f4   = addfile(file_name4, "r") 
    end if

  TIME2=fu->time
  yyyymm2=cd_calendar(TIME2, -1)
  printMinMax(yyyymm2, True)
  ymstrts = ind(yyyymm2.eq.ymstrt)
  ymlasts = ind(yyyymm2.eq.ymlast)
  print(ymstrts+" <--start end--> "+ymlasts)

    xu  = fu->$VARu$(ymstrts:ymlasts,:,:)
    xd  = fd->$VARd$(ymstrts:ymlasts,:,:)
    ; x3  = f3->$VARcu$(ymstrts:ymlasts,:,:)
    ; x4  = f4->$VARcd$(ymstrts:ymlasts,:,:)

    xx = xu 
    xx = xd - xu 
    ; xc = x3 
    ; xc = x4 - x3 
  delete([/fu,fd,TIME2,yyyymm2,xu,xd/]);,lat,lon
    
    xx@long_name = "TOA net shortwave radiation"
  
;--------output-------------
fon=diri3+EXP+"/netswtoa/"+MODEL6(im)+"_netswtoa_"+EXP+"_"+ENSN+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->netswtoa = xx

delete([/locs_str,xx/]);,pc_sea2,xa
end do 


delete([/locs/]);,x_Lead1

end do 



end
