begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"


  ; fils = systemfunc("ls "+diri+"cmip6/ts.pdv/cmip6_historical_*_pdv_1850-2014.nc")
  ; fils = systemfunc("ls "+diri+"cmip6/gmst/cmip6_historical_*_gmst_1850-2014.nc")
  ; fils = systemfunc("ls "+diri+"cmip5/gmst/cmip5_historical_*_gmst_1861-2004.nc")
  fils = systemfunc("ls "+diri+"cmip5/tas.pdv/cmip5_historical_*_pdv_1861-2004.nc")
  print(fils)
  nf = dimsizes(fils)

do im = 0,nf(0)-1

;---------read output---------------

 locs_str = str_split(fils(im), "_"); "/")
 ; print("'" + locs_str + "'")


  MODEL = locs_str(2)
  ENSN  = locs_str(3)
  NN4  = locs_str(4)
  NN5  = locs_str(5)
  NN1  = locs_str(1) ;exp
  zz   = str_split(locs_str(0), "/")
  nz = dimsizes(zz)
  CMIP = zz(nz-1)
  delete([/zz,nz/])

  f1   = addfile(fils(im), "r")
  ;touch here!!!!
  ;for PDV
  xx0  = f1->pc(0,:)
  ;for GMST
  ; xx0   = f1->gmst
    xx = month_to_annual(xx0, 1)

   nrt = 15
   nrt2 = nrt/2

  ; ;not work!!!
  ; ;central difference to calculating rolling trend
  ; ;not work!!!
  ;  rt = center_finite_diff_n (xx,nrt,False,0,0)


   ndim = dimsizes(xx)
    x = ispan(1, ndim(0), 1)
    rt = xx 
    rt = xx@_FillValue
   do i = nrt2,ndim(0)-1-nrt2
    ;**************************
    ; linear regression: x,y pairs can be in any order
    ;**************************
      aa = i-nrt2
      bb = i+nrt2
     rt(i) = regline (x(aa:bb),xx(aa:bb))                  ; linear regression
     ; print(rt(i))
     ; print("======")
  end do 
  rt = rt * 10
  rt@units = "K per decade"

print(MODEL+" "+ENSN+" done")

fon=diri+CMIP+"/roll.trend/"+CMIP+"_"+NN1+"_"+MODEL+"_"+ENSN+"_rt_"+NN4+"_"+NN5;
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->rt = rt

end do 


end 