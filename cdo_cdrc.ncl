begin
diri =  "/data3/home/liufeiclim2014/xing/"

diri2 = "/data2/data/cmip5/historical/atmos/mon/"

; model = (/"BNU-ESM","CanESM2","CMCC-CESM","CMCC-CM","CMCC-CMS",\
;       "FGOALS-g2","FGOALS-s2","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
;       "GFDL-ESM2G","GISS-E2-H-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
;       "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\;"MRI-ESM1",
;       "NorESM1-ME","NorESM1-M"/) ;va

model = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","BNU-ESM","CanESM2",\;"bcc-csm1-1-m",
      "CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5","CSIRO-Mk3-6-0","FIO-ESM","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
      "GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR",\
      "MIROC-ESM-CHEM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P",\;"MRI-ESM1",
      "NorESM1-ME","NorESM1-M"/) ;psl

; model = (/"ACCESS1-3","CanESM2","FGOALS-s2","GFDL-CM2p1","HadGEM2-CC","HadGEM2-ES" /);ua
  ;NEW MODELS
 ; "CanESM5","CESM2-FV2" "CESM2-WACCM-FV2" "E3SM-1-1" "FIO-ESM-2-0" "GISS-E2-2-G" 
 ; "HadGEM3-GC31-MM" "INM-CM4-8" "INM-CM5-0"  ;NEW MODELS

nm = dimsizes(model)
ne = 10;dimsizes(ensemble)

VAR_A = (/"psl"/) ;"pr" "tos" "hurs";variable 
EXP_A = "historical" ;(/"historical","piControl","ssp585", "ssp245"/) ;experiment

do iv = 0,dimsizes(VAR_A)-1
    VAR = VAR_A(iv)
    do ix = 0,dimsizes(EXP_A)-1
        EXP = EXP_A(ix)
do i=0,nm-1
    do ie = 1,ne

        ;/data2/data/cmip5/historical/atmos/mon/ua/NorESM1-M/r1i1p1
        files = systemfunc(" ls -1 "+diri2+VAR+"/"+model(i)+"/r"+ie+"i1p1/*.nc")
        print(files)
        nf = dimsizes(.not.ismissing(files))
        print(nf)
            if(.not.ismissing(files(0)))then
                system("cdo cat "+diri2+VAR+"/"+model(i)+"/r"+ie+"i1p1/*.nc "+diri+"a"+VAR+".nc")
                system("cdo remapbil,r144x72, "+diri+"a"+VAR+".nc "+diri+model(i)+"_"+VAR+"_"+EXP+"_r"+ie+"i1p1.nc")
                print(model(i)+" "+ie)
        end if 
    delete(files)
    system(" rm -rf "+diri+"a"+VAR+".nc" )
    end do 
end do 
end do 
end do 
end
