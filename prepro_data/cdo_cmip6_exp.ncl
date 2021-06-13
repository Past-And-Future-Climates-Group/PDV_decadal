begin
diri = "/glade/work/chenxing/enso/"

diri5 = "/glade/collections/cmip/cmip5/"
diri6 = "/glade/collections/cmip/CMIP6/ScenarioMIP/"
; diri_cesm2 = "/glade/collections/cdg/data/CMIP6/CMIP/NCAR/"
diri_cesm2 = "/glade/collections/cdg/data/CMIP6/ScenarioMIP/NCAR/"
;;;;;;touch here
nn = 6
VAR = "tos";"rsut"; "ts" ; "od550aer"
;;;;;;touch here
locs = systemfunc("find "+diri_cesm2+" -type d -name "+VAR+" | grep ssp585 | grep i1p1f1 | grep Omon")
print("find "+diri_cesm2+" -type d -name "+VAR+" | grep ssp585 | grep i1p1f1 | grep Omon")
print(locs)
nm = dimsizes(locs)

do im = 0,nm-1

    ;cmip6
	; "/glade/collections/cmip/CMIP6/ScenarioMIP/NCC/NorESM2-LM/ssp370/r1i1p1f1/Amon/tas/gn/v20191108/tas"
    ;"/glade/collections/cdg/data/CMIP6/ScenarioMIP/NCAR/CESM2/ssp370/r4i1p1f1/Amon/tas/gn/latest"
	locs_str = str_split(locs(im), "/")
	; print("'" + locs_str + "'")


;;;;;;touch here
	MODEL = locs_str(7) ;6 for cmip5&6; 7 for cesm1 & 2
    EXP = locs_str(8)  ; 7 for cmip6 ; 8 for cesm2
	ENS  = locs_str(9); 11 for cmip5 ; 8 for cmip6 ; 12 for cesm1; 9 for cesm2

	diris = "/glade/scratch/chenxing/cmip"+nn+"/"+EXP+"/"+VAR+"/"

    ; system("cdo cat "+locs(im)+"/*.nc "+diris+"cmip6_exp.nc")

		;; for CESM2 touch here:
    system("cdo cat "+locs(im)+"/gn/latest/*.nc "+diris+"cmip6_exp.nc")

	system("cdo remapbil,r144x72 "+diris+"cmip6_exp.nc "+diris+MODEL+"_"+VAR+"_"+EXP+"_"+ENS+".nc")
	print(MODEL+"_"+VAR+"_"+EXP+"_"+ENS+".nc is done")

	system("rm -rf "+diris+"cmip6_exp.nc")
    delete(locs_str)

end do

end
