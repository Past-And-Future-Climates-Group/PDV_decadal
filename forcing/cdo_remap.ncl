begin
diri = "/glade/work/chenxing/enso/"

diris = "/glade/scratch/chenxing/aerosol/cmip6/"

system("cd "+diris)
locs = systemfunc("ls *.nc")
print(locs)
nm = dimsizes(locs)
exit
do im = 0,nm-1

	system("cdo remapbil,r144x72 "+locs(im)+" remap/"+locs(im)) ;720x360
	print(locs(im)+" is done")

	; system("rm -rf "+diris+"aa.nc")

end do

end
