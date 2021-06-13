begin
diri =  "/glade/scratch/chenxing/cmip6/ssp585/"
diri2 =  "/glade/scratch/chenxing/cmip6/ssp585/"


;CMIP6 do be careful about r1i1p1f1!!!!
;CMIP6
model = (/"ACCESS-CM2","ACCESS-ESM1-5", "AWI-CM-1-1","CAS-ESM2-0","CIESM","CMCC-CM2-SR5","CMCC-ESM2","CNRM-CM6-1","CNRM-ESM2-1","IPSL-CM6A-LR" /);


nm = dimsizes(model)
ne = 10;dimsizes(ensemble)

VAR_A = (/"tos"/) ;"pr" "tos" "hurs";variable
EXP_A = "ssp585" ;(/"historical","piControl","ssp585", "ssp245"/) ;experiment

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
                system("cdo cat "+diri2+VAR+"*"+model(i)+"_"+EXP+"_r"+ie+"i1p1*.nc "+diri+"cssp.nc")
                system("cdo remapbil,r144x72, "+diri+"cssp.nc "+diri+model(i)+"_"+VAR+"_"+EXP+"_r"+ie+"i1p1.nc")
                print(model(i)+" "+ie)
        end if
    delete(files)
    system(" rm -rf "+diri+"cssp.nc" )
    system(" mv "+diri2+VAR+"*"+model(i)+"_"+EXP+"_r"+ie+"i1p1*.nc "+diri2+"trash/" )
    end do
end do
end do
end do
end
