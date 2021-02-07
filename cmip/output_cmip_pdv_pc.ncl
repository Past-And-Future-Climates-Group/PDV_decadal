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


yrs5 = 1861
yrl5 = 2004
nyr5 = yrl5 - yrs5 +1
yrs6 = 1850
yrl6 = 2014
nyr6 = yrl6 - yrs6 +1

nens_all = 32
pc5 = new((/nm5,nens_all,nyr5/), "float")
pc6 = new((/nm6,nens_all,nyr6/), "float")
pco5 = new((/nm5,nens_all,nyr5/), "float")
pco6 = new((/nm6,nens_all,nyr6/), "float")
par5 = new((/nm5/), "float");,nens_all
par6 = new((/nm6/), "float")

;--------------MODEL---------------------------------

do im = 0,nm5-1


  ;from pdv_cmip5_hist.ncl
  fils = systemfunc("ls "+diri+"cmip5/pdv/cmip5_historical_"+MODEL5(im)+"_*_pdv_1861-2004.nc")
  ; print(fils)
  f   = addfiles(fils, "r") 
  ListSetType (f, "join")   
  pc50  = f[:]->pc(:,0,:)
  par50  = f[:]->par
  ; printVarSummary(pc50)
  delete([/fils,f/])

  fils2 = systemfunc("ls "+diri+"cmip5/pdv/cmip5_historical_"+MODEL5(im)+"_*_org.pdv_1861-2004.nc")
  ; print(fils2)
  f2   = addfiles(fils2, "r") 
  ListSetType (f2, "join")   
  pco50  = f2[:]->pco(:,0,:)
  ; eof5  = f2[:]->eof
  delete([/fils2,f2/])



  ndim = dimsizes(pc50)
  if (dimsizes(ndim).eq.1) then 
     pc5(im,0,:) = month_to_annual(pc50(0,:), 1)
     pco5(im,0,:) = month_to_annual(pco50(0,:), 1)
     ; par5(im,0) = par50
  else 
    do i = 0,ndim(0)-1
     pc5(im,i,:) = month_to_annual(pc50(i,:), 1)
     pco5(im,i,:) = month_to_annual(pco50(i,:), 1)
      ; par5(im,i) = par50(i)
    end do 
  end if 

  par5(im) = dim_avg_n_Wrap(par50, 0)

   print(MODEL5(im)+" done")
   delete([/pc50,par50,pco50, ndim/])
end do 

do im = 0,nm6-1

 ;from pdv_cmip6_hist.ncl
  fils = systemfunc("ls "+diri+"cmip6/pdv/cmip6_historical_"+MODEL6(im)+"_*_pdv_1850-2014.nc")
  ; print(fils)
  f   = addfiles(fils, "r") 
  ListSetType (f, "join")   
  pc60  = f[:]->pc(:,0,:)
  par60  = f[:]->par
  ; printVarSummary(pc60)
  delete([/fils,f/])

  fils2 = systemfunc("ls "+diri+"cmip6/pdv/cmip6_historical_"+MODEL6(im)+"_*_org.pdv_1850-2014.nc")
  f2   = addfiles(fils2, "r") 
  ListSetType (f2, "join")   
  pco60  = f2[:]->pco(:,0,:)
  ; eof6  = f2[:]->eof
  delete([/fils2,f2/])

  ndim = dimsizes(pc60)
  if (dimsizes(ndim).eq.1) then 
     pc6(im,0,:) = month_to_annual(pc60(0,:), 1)
     pco6(im,0,:) = month_to_annual(pco60(0,:), 1)
     ; par6(im,0) = par60
  else 
    do i = 0,ndim(0)-1
       pc6(im,i,:) = month_to_annual(pc60(i,:), 1)
       pco6(im,i,:) = month_to_annual(pco60(i,:), 1)
      ; par6(im,i) = par60(i)
    end do 
  end if 

  par6(im) = dim_avg_n_Wrap(par60, 0)

   print(MODEL6(im)+" with "+ndim(0)+"ens is done")
   delete([/pc60,par60,pco60, ndim/])
end do 

  printVarSummary(pc5)
  printVarSummary(pc6)
  printVarSummary(par5)

;--------output-------------
fon=diri+"cmip5_pdv_all_model.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->pc = pc5
fo->pco = pco5
fo->par = par5

fon=diri+"cmip6_pdv_all_model.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->pc = pc6
fo->pco = pco6
fo->par = par6


end 