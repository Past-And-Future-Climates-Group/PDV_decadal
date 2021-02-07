begin
diri = "/glade/work/chenxing/enso/"

diri5 = "/glade/collections/cmip/cmip5/"
diri6 = "/glade/collections/cmip/CMIP6/DAMIP/"
diri_cesm2 = "/glade/collections/cdg/data/CMIP6/DAMIP/NCAR/"
;;;;;;touch here
nn = 6
VAR = "ts";"rsut"; "tas" ; "od550aer"
diris = "/glade/scratch/chenxing/cmip"+nn+"/DAMIP/"+VAR+"/"
;;;;;;touch here
locs = systemfunc("find "+diri_cesm2+" -type d -name "+VAR+" | grep i1p1f1 | grep Amon") 
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

    ; system("cdo cat "+locs(im)+"/*.nc "+diris+"aa.nc")
    system("cdo cat "+locs(im)+"/gn/latest/*.nc "+diris+"aa.nc")
	system("cdo remapbil,r144x72 "+diris+"aa.nc "+diris+MODEL+"_"+VAR+"_"+EXP+"_"+ENS+".nc")
	print(MODEL+"_"+VAR+"_"+EXP+"_"+ENS+".nc is done")

	system("rm -rf "+diris+"aa.nc")
    delete(locs_str)

end do 

end 