begin

diri  = "/Users/xingchen/Documents/project/ENSO/data/" ;"/glade/work/chenxing/enso/"
diri0 = "/Users/xingchen/Documents/project/ENSO/pic/" ;"/glade/u/home/chenxing/enso/"

SEASON = (/"DJF","MAM","JJA","SON" /)

;CMIP5 MODELS
MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1-m","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;
      "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5","CNRM-CM5-2","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1","GFDL-CM3",\;
      "GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H-CC","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R","HadCM3","HadGEM2-AO",\;
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
      "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3","MRI-ESM1",\;
      "NorESM1-ME","NorESM1-M"/)


; CMIP6 MODELS
MODEL6 = (/"BCC-CSM2-MR","BCC-ESM1","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5",
        "CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FGOALS-g3","FIO-ESM-2-0","GFDL-CM4","GFDL-ESM4",\;"E3SM-1-1","FGOALS-f3-L",
        "GISS-E2-1-G","GISS-E2-1-H","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC",
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NESM3","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM",

nm5 = dimsizes(MODEL5)
nm6 = dimsizes(MODEL6)

IND = "PDI2"

yrs5 = 1861
yrl5 = 2004
nyr5 = yrl5 - yrs5 +1
yrs6 = 1850
yrl6 = 2014
nyr6 = yrl6 - yrs6 +1

nens_all = 32
pc5 = new((/nm5,nens_all,nyr5/), "float")
pc6 = new((/nm6,nens_all,nyr6/), "float")

;--------------MODEL---------------------------------

do im = 0,nm5-1


  ;from pdv_cmip5_hist.ncl
  fils = systemfunc("ls "+diri+"cmip5/"+IND+"/cmip5_historical_"+MODEL5(im)+"_*_"+IND+"_1861-2004.nc")
  ; print(fils)
  f   = addfiles(fils, "r") 
  ListSetType (f, "join")   
  pc50  = f[:]->index;pc(:,0,:)
  ; par50  = f[:]->par
  delete([/fils,f/])


  ndim = dimsizes(pc50)
  if (dimsizes(ndim).eq.1) then 
     pc5(im,0,:) = month_to_annual(pc50, 1)
  else 
    do i = 0,ndim(0)-1
     pc5(im,i,:) = month_to_annual(pc50(i,:), 1)
    end do 
  end if 


   print(MODEL5(im)+" done")
   delete([/pc50, ndim/]);
end do 

do im = 0,nm6-1

 ;from pdv_cmip6_hist.ncl
  fils = systemfunc("ls "+diri+"cmip6/"+IND+"/cmip6_historical_"+MODEL6(im)+"_*_"+IND+"_1850-2014.nc")
  ; print(fils)
  f   = addfiles(fils, "r") 
  ListSetType (f, "join")   
  pc60  = f[:]->index;pc(:,0,:)
  delete([/fils,f/])


  ndim = dimsizes(pc60)
  if (dimsizes(ndim).eq.1) then 
     pc6(im,0,:) = month_to_annual(pc60, 1)
  else 
    do i = 0,ndim(0)-1
       pc6(im,i,:) = month_to_annual(pc60(i,:), 1)
    end do 
  end if 


   print(MODEL6(im)+" with "+ndim(0)+"ens is done")
   delete([/pc60, ndim/]);
end do 

  printVarSummary(pc5)
  printVarSummary(pc6)

;--------output-------------
fon=diri+"cmip5_"+IND+"_all_model.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->pc = pc5

fon=diri+"cmip6_"+IND+"_all_model.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->pc = pc6


end 