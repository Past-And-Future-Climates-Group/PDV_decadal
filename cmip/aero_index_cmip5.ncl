begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

  yrs = 1861
  yrl = 2004
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

;/glade/collections/cmip/cmip5/output1/CNRM-CERFACS/CNRM-CM5/historical/mon/ocean/Omon/r10i1p1/v20130101/tos/
diri1 = "/glade/collections/cmip/CMIP5/"
diri2 = "/glade/scratch/chenxing/cmip5/od550aer/"

; locs = systemfunc("find /glade/collections/cmip/cmip5/ -type d -name tos | grep historical") 
locs = systemfunc("ls "+diri2+"*") ;)
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

MODEL = new(nsa, "string")
ENS  = new(nsa, "string")

do im = 0,nsa-1

 locs_str = str_split(locs(im), "_"); "/")
 print("'" + locs_str + "'")


aa = str_split(locs_str(0), "/")
MODEL(im) = aa(5);(6)
bb = str_split(locs_str(3), ".")
ENS(im)  = bb(0);(11)

print(MODEL(im)+" ens "+ENS(im))

  
  fils = systemfunc("ls "+locs(im));+"/*.nc")
  print(fils)
  f   = addfiles(fils, "r")  ;multiple files
  ListSetType (f, "cat")        ; concatenate (=default)

TIME2=f[:]->time
yyyymm2=cd_calendar(TIME2, -1)
printMinMax(yyyymm2, True)
ymstrts = ind(yyyymm2.eq.ymstrt)
ymlasts = ind(yyyymm2.eq.ymlast)

    xx  = f[:]->od550aer(ymstrts:ymlasts,:,:);

;;check NAN points!!!
  if (any(ismissing(xx))) then
    print("there is nan in col")
    xx = where(ismissing(xx), 0.0, xx)  
  end if

delete([/fils,f,TIME2,yyyymm2/]);,lat,lon
xa = rmMonAnnCycTLL(xx)

;-------------------------------------
;cover land data
;mask 0=ocean (land reserved), 1=land, 2=lake, 3=small island, 4=ice shelf.

 lland = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
 lsm0 = landsea_mask(lland->LSMASK,xa&lat,xa&lon)
 xa_sea = mask(xa,lsm0.eq.1, False)      ; mask out land points
 copy_VarMeta(xa, xa_sea)

;-------------------------
; Calculating index 

;;;;;;;;;;;;;;;;;
;;change here!!!
;;;;;;;;;;;;;;;;;
X = xa_sea ; xa_sea ; xa

  lat = xa&lat
  rad    = 4.0*atan(1.0)/180.0
  clat   = cos(lat*rad)
  copy_VarCoords(xa(0,:,0), clat)
  ; go = wgt_areaave_Wrap(x,clat, 1.0, 1)

  NLAT =   65;90 ; 70;
  SLAT =   0 ;-90;50;
  WLON =  150;0  ;300;
  ELON =  240;360;360;
  gmst = wgt_areaave_Wrap(X(:,{SLAT:NLAT},{WLON:ELON}),clat({SLAT:NLAT}), 1.0, 1)


;--------output-------------
fon=diri+"cmip5/od550aer/global_index/cmip5_historical_"+MODEL(im)+"_"+ENS(im)+"_NP_index_od550aer_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->index = gmst

delete([/xx, xa,gmst,xa_sea,X /])

end do 


end
