begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

V_CMIP = 6
VAR1 =  "rsut" ;"ts" ; "tas"
VAR2 =  "rsdt" ;"ts" ; "tas"
EXP = "historical"

  ; yrs = 1861
  ; yrl = 2004
  yrs = 1850
  yrl = 2014
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

;/glade/collections/cmip/cmip6/output1/CNRM-CERFACS/CNRM-CM5/historical/mon/ocean/Omon/r10i1p1/v20130101/tos/
diri1 = "/glade/collections/cmip/CMIP"+V_CMIP+"/"
diri2 = "/glade/work/chenxing/CMIP"+V_CMIP+"/"+EXP+"/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip"+V_CMIP+"/"+EXP+"/"+VAR1+"/"
diri4 = "/glade/scratch/chenxing/cmip"+V_CMIP+"/"+EXP+"/"+VAR2+"/"

; locs = systemfunc("find /glade/collections/cmip/cmip6/ -type d -name tos | grep historical") 
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

    fn2 = diri4+MODEL(im)+"_"+VAR2+"_historical_"+ENSN(im)+".nc"
    exists = isfilepresent(fn2)
  if(.not.exists) then
    print(MODEL(im)+" ens "+ENSN+" file not exist")
    continue
  else
  f2   = addfile(fn2, "r") 
  end if

;only do historical part here first
TIME2=f[:]->time
yyyymm2=cd_calendar(TIME2, -1)
printMinMax(yyyymm2, True)
ymstrts = ind(yyyymm2.eq.ymstrt)
ymlasts = ind(yyyymm2.eq.ymlast)
ycstrts = ind(yyyymm2.eq.197501)
yclasts = ind(yyyymm2.eq.200412)
print(ymstrts+" <--start end--> "+ymlasts)

    xx1  = f[:]->$VAR1$(ymstrts:ymlasts,:,:);
    xx2  = f2->$VAR2$(ymstrts:ymlasts,:,:);

 
; ;climatology is 1975-2005
; xc = clmMonTLL(f[:]->$VAR$(ycstrts:yclasts,:,:))
; xa = calcMonAnomTLL(xx, xc)
xa1 = rmMonAnnCycTLL(xx1)
xa2 = rmMonAnnCycTLL(xx2)
xa = xa1 
xa = xa1 - xa2
xa = dtrend_msg_n(xa&time, xa, True, False, 0)

delete([/fils,f,TIME2,yyyymm2/]);,lat,lon

;-------------------------
; Calculating index 
; Nino 1+2 (0-10S, 90W-80W), Nino 3 (5N-5S, 150W-90W), 
; Nino 3.4/ONI (5N-5S, 170W-120W) and Nino 4 (5N-5S, 160E-150W)
; TNI is Nino 1+2 - Nino 4
; 
; TNA: Tropical Northern Atlantic Index* Anomaly of the average of the monthly SST from 5.5N to 23.5N and 15W to 57.5W. 
; Enfield, D.B., A.M. Mestas, D.A. Mayer, and L. Cid-Serrano, 1999: How ubiquitous is the dipole relationship in 
; tropical Atlantic sea surface temperatures? JGR-O, 104, 7841-7848.AOML and PSL

; NPGO index: SLP index is over the Hawaiian region (158W–135W;13N–24N)
; PDO SLP index: SLP over Northeast Pacific (25–61N, 179–111W)


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
  gmst@long_name = "ASR_HD"

; gmst = dtrend_msg_n(gmst&time, gmst, True, False, 0)


;--------output-------------
fon=diri+"cmip"+V_CMIP+"/ASR_HD/cmip"+V_CMIP+"_"+EXP+"_"+MODEL(im)+"_"+ENSN(im)+"_ASR_HD_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->index = gmst

delete([/ xa,clat,lat/])

end do 

end 