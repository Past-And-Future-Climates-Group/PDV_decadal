begin
diri =  "/glade/scratch/chenxing/cmip5/"
diri2 =  "/glade/scratch/chenxing/cesm1_le/"

;CMIP5
model = (/"CESM1-CAM5" /)


nm = dimsizes(model)
ne = 40

;b.e11.BRCP85C5CNBDRD.f09_g16.007.cam.h0.SWCF.208101-210012.nc
;fsns_Amon_CESM1-CAM5_historical_rcp85_r36i1p1_192001-210012.nc

VAR_A = (/"SWCF","FSNSC"/) ;"pr" "tos" "hurs";variable
VAR_B = (/"swcf","fsnsc"/) ;"pr" "tos" "hurs";variable
EXP_A = "historical" ;(/"historical","piControl","ssp585", "ssp245"/) ;experiment

do iv = 0,dimsizes(VAR_A)-1
    VAR = VAR_A(iv)
    do ix = 0,dimsizes(EXP_A)-1
        EXP = EXP_A(ix)
do i=0,nm-1
    do ie = 1,ne

        files = systemfunc(" ls -1 "+diri2+"*0"+ie+".cam.h0."+VAR_A(iv)+".*.nc")
        print(files)
        nf = dimsizes(.not.ismissing(files))
        print(nf)
            if(.not.ismissing(files(0)))then
              if(ie.eq.1) then
                system("cdo -O mergetime "+diri2+"*0"+ie+".cam.h0."+VAR_A(iv)+".*.nc "+diri2+VAR_B(iv)+"_Amon_"+model(i)+"_"+EXP_A+"_rcp85_r"+ie+"i1p1_185001-210012.nc")
              else
                system("cdo -O mergetime "+diri2+"*0"+ie+".cam.h0."+VAR_A(iv)+".*.nc "+diri2+VAR_B(iv)+"_Amon_"+model(i)+"_"+EXP_A+"_rcp85_r"+ie+"i1p1_192001-210012.nc")
              end if
                print(model(i)+" "+ie)
        end if
    delete(files)
    end do
end do
end do
end do
end
