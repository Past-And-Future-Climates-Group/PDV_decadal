begin
diri =  "/glade/scratch/chenxing/cmip5/historical/"
diri2 =  "/glade/scratch/chenxing/cmip5/rcp85/"
diri3 =  "/glade/scratch/chenxing/cmip5/histrcp85/"

model = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1-m","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;
      "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5","CNRM-CM5-2","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1","GFDL-CM3",\;
      "GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H-CC","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R","HadCM3","HadGEM2-AO",\;
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
      "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3","MRI-ESM1",\;
      "NorESM1-ME","NorESM1-M"/)


nm = dimsizes(model)
ne = 10;dimsizes(ensemble)

VAR_A = (/"tas"/) ;"pr" "tos" "hurs";variable
EXP = "rcp85" ;(/"historical","piControl","ssp585", "ssp245"/) ;experiment

do iv = 0,dimsizes(VAR_A)-1
    VAR = VAR_A(iv)
do i=0,nm-1
    do ie = 1,ne
            ;CESM1-CAM5_tas_rcp85_r3i1p1.nc
        file_rcp = diri2+VAR+"/"+model(i)+"_"+VAR+"_"+EXP+"_r"+ie+"i1p1.nc"
        exists = isfilepresent(file_rcp)
        if(.not.exists) then
          continue
        else
          file_hist = diri+VAR+"/"+model(i)+"_"+VAR+"_historical_r"+ie+"i1p1.nc"
                system("cdo cat "+file_hist+" "+file_rcp+" "+diri3+VAR+"/"+model(i)+"_"+VAR+"_histrcp85_r"+ie+"i1p1.nc")
                print(model(i)+" "+ie)
        end if
    end do
end do
end do
end
