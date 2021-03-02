begin
diri = "/glade/work/chenxing/enso/"

diri5 = "/glade/collections/cmip/cmip5/"
diri6 = "/glade/collections/cmip/CMIP6/"
; diri_cesm1 = "/glade/collections/cdg/data/cmip5/output1/" I skip this one... there are many many similar upload version of CESM!!!
diri_cesm2 = "/glade/collections/cdg/data/CMIP6/CMIP/NCAR/"
;;;;;;touch here
nn = 6
VAR = "zg" ;"rsdscs" ;"rsuscs";"rsut"; "tas" ; "od550aer"
diris = "/glade/scratch/chenxing/cmip"+nn+"/historical/"+VAR+"/"
;;;;;;touch here
locs = systemfunc("find "+diri6+" -type d -name "+VAR+" | grep historical/ | grep Amon | grep i1p1f1") ;i1p1 for CMIP5 i1p1f1 for CMIP6
print(locs)
nm = dimsizes(locs)

do im = 0,nm-1

    ;cmip5
	; "/glade/collections/cmip/cmip5/output1/IPSL/IPSL-CM5A-LR/historical/mon/aerosol/aero/r1i1p1/v20110406/od550aer"
    ;cmip6
    ; "/glade/collections/cmip/CMIP6/CMIP/IPSL/IPSL-CM6A-LR/historical/r11i1p1f1/AERmon/od550aer/gr/v20180803/od550aer"
    ;cesm1
    ;"/glade/collections/cdg/data/cmip5/output1/NCAR/CCSM4/historical/mon/atmos/Amon/r4i1p1/v20121031/tas"
    ;"/glade/collections/cdg/data/CMIP6/CMIP/NCAR/CESM2/historical/r1i1p1f1/Amon/psl/gn/latest"
	locs_str = str_split(locs(im), "/")
	; print("'" + locs_str + "'")


;;;;;;touch here
	MODEL = locs_str(6) ;6 for cmip5&6; 7 for cesm1 & 2
	ENS  = locs_str(8); 11 for cmip5 ; 8 for cmip6 ; 12 for cesm1; 9 for cesm2

    system("cdo cat "+locs(im)+"/*.nc "+diris+"cmip.nc")
;;;;;;touch here for cesm2
    ; system("cdo cat "+locs(im)+"/gn/latest/*.nc "+diris+"cmip.nc")
	system("cdo remapbil,r144x72 "+diris+"cmip.nc "+diris+MODEL+"_"+VAR+"_historical_"+ENS+".nc")
	print(MODEL+"_"+VAR+"_historical_"+ENS+".nc is done")

	system("rm -rf "+diris+"cmip.nc")
    delete(locs_str)

end do

end
