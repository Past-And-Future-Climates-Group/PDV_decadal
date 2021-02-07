begin
diri =  "/glade/scratch/chenxing/cmip5/"
diri2 =  "/glade/scratch/chenxing/cmip5/" 

;CMIP5
model = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","bcc-csm1-1-m","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;
      "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1","CNRM-CM5-2","GFDL-CM3",\;
      "GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R","GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
      "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-ESM1","MRI-CGCM3",\;
      "NorESM1-ME","NorESM1-M"/)

; ;CMIP6 do be careful about r1i1p1f1!!!!
; ;CMIP6
; model = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
;         "CESM2","CESM2-WACCM-FV2",\
;         "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
;         "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",

  ;NEW MODELS
 ; "CanESM5","CESM2-FV2" "CESM2-WACCM-FV2" "E3SM-1-1" "FIO-ESM-2-0" "GISS-E2-2-G" 
 ; "HadGEM3-GC31-MM" "INM-CM4-8" "INM-CM5-0"  ;NEW MODELS

nm = dimsizes(model)
ne = 10;dimsizes(ensemble)

VAR_A = (/"clt"/) ;"pr" "tos" "hurs";variable 
EXP_A = "historical" ;(/"historical","piControl","ssp585", "ssp245"/) ;experiment

do iv = 0,dimsizes(VAR_A)-1
    VAR = VAR_A(iv)
    do ix = 0,dimsizes(EXP_A)-1
        EXP = EXP_A(ix)
do i=0,nm-1
    do ie = 1,ne
            ;tos_Omon_SAM0-UNICON_ssp585_r1i1p1_gn_199001-199912.nc
            ;tos_Omon_NESM3_ssp585_r1i1p1_gn_100001-119912.nc
            ;pr_Amon_GISS-E2-2-G_piControl_r1i1p1_gn_200001-202512.nc
        files = systemfunc(" ls -1 "+diri2+VAR+"*"+model(i)+"_"+EXP+"_r"+ie+"i1p1*.nc")
        print(files)
        nf = dimsizes(.not.ismissing(files))
        print(nf)
            if(.not.ismissing(files(0)))then
                system("cdo cat "+diri2+VAR+"*"+model(i)+"_"+EXP+"_r"+ie+"i1p1*.nc "+diri+"a2.nc")
                system("cdo remapbil,r144x72, "+diri+"a2.nc "+diri+model(i)+"_"+VAR+"_"+EXP+"_r"+ie+"i1p1.nc")
                print(model(i)+" "+ie)
        end if 
    delete(files)
    system(" rm -rf "+diri+"a2.nc" )
    system(" mv "+diri2+VAR+"*"+model(i)+"_"+EXP+"_r"+ie+"i1p1*.nc "+diri2+"trash/" )
    end do 
end do 
end do 
end do 
end
