begin
diri =  "/glade/scratch/chenxing/cmip6/ts/"
diri2 =  "/glade/scratch/chenxing/cmip6/" 

model = (/"FIO-ESM-2-0","INM-CM5-0", \
    "MPI-ESM1-2-LR","NorCPM1"/);

  ;NEW MODELS
 ; "CanESM5","CESM2-FV2" "CESM2-WACCM-FV2" "E3SM-1-1" "FIO-ESM-2-0" "GISS-E2-2-G" 
 ; "HadGEM3-GC31-MM" "INM-CM4-8" "INM-CM5-0"  ;NEW MODELS

nm = dimsizes(model)
ne = 32;dimsizes(ensemble)

VAR_A = (/"ts"/) ;"pr" "tos" "hurs";variable 
GR_A = (/"gn"/) ;"gr", "gn","gr1" grid Label
EXP_A = "historical" ;(/"historical","piControl","ssp585", "ssp245"/) ;experiment

do iv = 0,dimsizes(VAR_A)-1
    VAR = VAR_A(iv)
do ig = 0,dimsizes(GR_A)-1
    GR = GR_A(ig)
    do ix = 0,dimsizes(EXP_A)-1
        EXP = EXP_A(ix)
do i=0,nm-1
    do ie = 1,ne
        	;tos_Omon_SAM0-UNICON_ssp585_r1i1p1f1_gn_199001-199912.nc
            ;tos_Omon_NESM3_ssp585_r1i1p1f1_gn_100001-119912.nc
            ;pr_Amon_GISS-E2-2-G_piControl_r1i1p1f1_gn_200001-202512.nc
        files = systemfunc(" ls -1 "+diri2+VAR+"*"+model(i)+"_"+EXP+"_r"+ie+"i1p1f1*.nc")
        print(files)
        nf = dimsizes(.not.ismissing(files))
        print(nf)
        	if(.not.ismissing(files(0)))then
                system("cdo cat "+diri2+VAR+"*"+model(i)+"_"+EXP+"_r"+ie+"i1p1f1*.nc "+diri+"a2.nc")
        		system("cdo remapbil,r144x72, "+diri+"a2.nc "+diri+model(i)+"_"+VAR+"_"+EXP+"_r"+ie+"i1p1f1.nc")
        		print(model(i)+" "+ie)
        end if 
    delete(files)
    system(" rm -rf "+diri+"a2.nc" )
    system(" mv "+diri2+VAR+"*"+model(i)+"_"+EXP+"_r"+ie+"i1p1f1*.nc "+diri2+"trash/" )
    end do 
end do 
end do 
end do 
end do 
end
