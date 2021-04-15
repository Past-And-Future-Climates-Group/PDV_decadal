begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

diri3 = "/glade/scratch/chenxing/"

MODEL = (/"CESM1-CAM5" /);cesm2_cmip5_forcing

VARs = "FSNS" ;
VARc = "FSNSC" ;
YRL = "208012";"200512" ;209912 ; 210012 ; 208012
; diris = "/glade/scratch/chenxing/cesm2_cmip5_forcing/"
diris = "/glade/scratch/chenxing/cesm1_le/"

;b.e21.BRCP85.f09_g17.cesm2_cmip5_forcing.007.cam.h0.FSNS.200601-209912.nc
;b.e21.BHIST.f09_g17.cesm2_cmip5_forcing.006.cam.h0.SWCF.185001-200512.nc
;b.e11.B20TRC5CNBDRD.f09_g16.023.cam.h0.FSNS.192001-200512.nc
;b.e11.BRCP85C5CNBDRD.f09_g16.008.cam.h0.FSNSC.200601-208012.nc

  ; system("cd "+diris)
  locs1 = systemfunc("ls "+diris+"*."+VARs+".*"+YRL+".nc")
  print(locs1)
  nsa = dimsizes(locs1)

do ia = 0,nsa-1

  locs_str = str_split(locs1(ia), ".");
  print("'" + locs_str + "'")
  ID  = locs_str(4) ;cesm2 cmip5 forcing 5 ;cesm1 le 4
  TT  = locs_str(8) ; 9       ;  8
  print(ID+" "+TT)

   locs2 = systemfunc("ls "+diris+"*"+ID+"*"+VARc+"."+TT+".nc")
   print(locs2)

  fs   = addfile(locs1(ia), "r")
  fc   = addfile(locs2, "r")

    xx  = fs->$VARs$
    xc  = fc->$VARc$

    ce = xx
    ce = xx - xc
    ce@long_name = "cloud effect (SW - clear sky)"

;--------output-------------
fon=diris+MODEL+"_"+ID+"_cloudeffect_"+TT+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->ce = ce

delete([/ce,xx,xc/]);,pc_sea2,xa
end do

end
