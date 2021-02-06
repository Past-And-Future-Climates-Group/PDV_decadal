begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
  yrs = 2015;1850
  yrl = 2099;2014
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

EXP = "ssp585"

;/glade/collections/cmip/cmip6/output1/CNRM-CERFACS/CNRM-CM5/"+EXP+"/mon/ocean/Omon/r10i1p1/v20130101/tos/
diri1 = "/glade/collections/cmip/CMIP6/"
diri2 = "/glade/work/chenxing/CMIP6/"+EXP+"/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip6/"+EXP+"/tas/"

; locs = systemfunc("find /glade/collections/cmip/cmip6/ -type d -name tos | grep "+EXP+"") 
locs = systemfunc("ls "+diri3) 
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

MODEL = new(nsa, "string")
ENSN  = new(nsa, "string")

istart = 0
do im = istart,nsa-1

 locs_str = str_split(locs(im), "_"); "/")
 print("'" + locs_str + "'")


MODEL(im) = locs_str(0);(6)
bb = str_split(locs_str(3), ".")
ENSN(im)  = bb(0);(11)

print(MODEL(im)+" ens "+ENSN(im))
  
  fils = systemfunc("ls "+diri3+locs(im));+"/*.nc")
  print(fils)
  f   = addfiles(fils, "r")  ;multiple files
  ListSetType (f, "cat")        ; concatenate (=default)

;only do "+EXP+" part here first
TIME2=f[:]->time
yyyymm2=cd_calendar(TIME2, -1)
printMinMax(yyyymm2, True)
ymstrts = ind(yyyymm2.eq.ymstrt)
ymlasts = ind(yyyymm2.eq.ymlast)
print(ymstrts+" <--start end--> "+ymlasts)

    xx  = f[:]->tas(ymstrts:ymlasts,:,:);

delete([/fils,f,TIME2,yyyymm2/]);,lat,lon
 
xa = rmMonAnnCycTLL(xx)

;-------------------------
; Calculating index 
; Nino 1+2 (0-10S, 90W-80W), Nino 3 (5N-5S, 150W-90W), 
; Nino 3.4/ONI (5N-5S, 170W-120W) and Nino 4 (5N-5S, 160E-150W)
; TNI is Nino 1+2 - Nino 4

  lat = xa&lat
  rad    = 4.0*atan(1.0)/180.0
  clat   = cos(lat*rad)
  copy_VarCoords(xa(0,:,0), clat)
  ; go = wgt_areaave_Wrap(x,clat, 1.0, 1)

  NLAT =   90  
  SLAT =  -90
  WLON =  0
  ELON =  360
  ; gmst = wgt_areaave_Wrap(xa(:,{SLAT:NLAT},{WLON:ELON}),clat({SLAT:NLAT}), 1.0, 1)
  g1 = wgt_areaave_Wrap(xa(:,{SLAT:0},{WLON:ELON}),clat({SLAT:0}), 1.0, 1) ;SH mean 
  g2 = wgt_areaave_Wrap(xa(:,{0:NLAT},{WLON:ELON}),clat({0:NLAT}), 1.0, 1) ;NH mean
  gmst = g2 - g1

  gmst@long_name = "Global mean surface temperature"


;--------output-------------
fon=diri+"cmip6/nh-sh/cmip6_"+EXP+"_"+MODEL(im)+"_"+ENSN(im)+"_nh-sh_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->gmst = gmst

delete([/xx, xa,clat,lat/])

end do 

end 