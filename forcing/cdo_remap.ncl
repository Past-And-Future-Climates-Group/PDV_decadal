begin
diri = "/glade/work/chenxing/enso/"

diris = "/glade/scratch/chenxing/aerosol/cmip6/"

locs = systemfunc("ls "+diris+"*.nc")
print(locs)
nm = dimsizes(locs)

do im = 0,nm-1

	system("cdo remapbil,r144x72 "+locs(im)+" "+locs(im)+"3.nc") ;720x360
	print(locs(im)+" is done")

	; system("rm -rf "+diris+"aa.nc")

end do

end
