begin
diri = "/glade/work/chenxing/enso/"

diri5 = "/glade/collections/cmip/cmip5/"
diri6 = "/glade/collections/cmip/CMIP6/"
;;;;;;touch here
nn = 5
VAR = "tas";"rsut"; "tas" ; "od550aer"
diris = "/glade/scratch/chenxing/cmip"+nn+"/rcp45/"+VAR+"/"
;;;;;;touch here
locs = systemfunc("find "+diri5+" -type d -name "+VAR+" | grep rcp45/ | grep Amon | grep i1p1") 
print(locs)
nm = dimsizes(locs)

do im = 0,nm-1

    ;cmip5
	; "/glade/collections/cmip/cmip5/output1/NCC/NorESM1-M/rcp45/mon/atmos/Amon/r1i1p1/v20120412/tas"
	locs_str = str_split(locs(im), "/")
	; print("'" + locs_str + "'")


;;;;;;touch here
	MODEL = locs_str(6) ;6 for cmip5&6; 7 for cesm1 & 2
	ENS  = locs_str(11); 11 for cmip5 ; 8 for cmip6 ; 12 for cesm1; 9 for cesm2

    system("cdo cat "+locs(im)+"/*.nc "+diris+"aa.nc")
	system("cdo remapbil,r144x72 "+diris+"aa.nc "+diris+MODEL+"_"+VAR+"_rcp45_"+ENS+".nc")
	print(MODEL+"_"+VAR+"_rcp45_"+ENS+".nc is done")

	system("rm -rf "+diris+"aa.nc")
    delete(locs_str)

end do 

end 