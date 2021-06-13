begin
diri = "/glade/work/chenxing/enso/"

diri5 = "/glade/collections/cmip/cmip5/"
diri6 = "/glade/collections/cmip/CMIP6/"
;;;;;;touch here
nn = 5
VAR = "tas";"rsut"; "tas" ; "od550aer"
diris = "/glade/scratch/chenxing/cmip"+nn+"/rcp85/"+VAR+"/"
diri_cesm1 = "/glade/collections/cdg/data/cmip5/output1/NSF-DOE-NCAR/"
;;;;;;touch here
locs = systemfunc("find "+diri_cesm1+" -type d -name "+VAR+" | grep rcp85/ | grep Amon | grep i1p1")
print(locs)
nm = dimsizes(locs)

do im = 0,nm-1

    ;cmip5
	; "/glade/collections/cmip/cmip5/output1/NCC/NorESM1-M/rcp85/mon/atmos/Amon/r1i1p1/v20120412/tas"
	locs_str = str_split(locs(im), "/")
	; print("'" + locs_str + "'")


;;;;;;touch here
	MODEL = locs_str(7) ;6 for cmip5&6; 7 for cesm1 & 2
	ENS  = locs_str(12); 11 for cmip5 ; 8 for cmip6 ; 12 for cesm1; 9 for cesm2

    system("cdo cat "+locs(im)+"/*.nc "+diris+"cmip5_exp.nc")
	system("cdo remapbil,r144x72 "+diris+"cmip5_exp.nc "+diris+MODEL+"_"+VAR+"_rcp85_"+ENS+".nc")
	print(MODEL+"_"+VAR+"_rcp85_"+ENS+".nc is done")

	system("rm -rf "+diris+"cmip5_exp.nc")
    delete(locs_str)

end do

end
