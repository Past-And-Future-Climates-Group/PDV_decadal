begin
IND = "pdo" ;"pdv"

NLAT =  70; 65; 5; 60;
SLAT =  20;-70;-5;-60;
WLON =  100;120;
ELON =  300;290;

  yrs = 1861;1930;
  yrl = 2004
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12


diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
neof = 1

;read obs IPO results
;from obs_ipo.ncl
f0   = addfile(diri+"obs_pdv_1880-2018.nc", "r") ;obs_pdv_1854-2019.nc
rco  = f0->rc(0,:,:)
pco  = f0->pc
pcvaro  = f0->pcvar
printVarSummary(rco)

  fref = systemfunc("ls "+diri+"cmip5/tos.pdv/cmip5_historical_*_pdv_1861-2004.nc")
  print(fref)
  fr   = addfile(fref(0), "r")  ;multiple files
  rref = fr->rc({SLAT:NLAT},{WLON:ELON})

;change resolution for obs to fit with model (to do pattern correlation)
    aa = rco({SLAT:NLAT},{WLON:ELON})
   ; r_lon = 360./dimsizes(xam&lon)
    ; r_lat = 180./dimsizes(xam&lat)
    lat = aa&lat
    lon = aa&lon 
    nlat = dimsizes(rref&lat) ;target dimension size
    nlon = dimsizes(rref&lon) ;target dimension size
    klon = fspan(WLON, ELON, nlon) ;target dimension 
    klat = fspan(SLAT, NLAT, nlat) ;target dimension
    rco_r= linint2_Wrap(lon, lat, aa, True, klon, klat, 0) 
    rco_r&LAT@units="degrees_north"
    rco_r&LON@units="degrees_east"
    printVarSummary(rco_r)
    delete([/lat,lon,klat,klon,aa/]);xa0

;/glade/collections/cmip/cmip5/output1/CNRM-CERFACS/CNRM-CM5/historical/mon/ocean/Omon/r10i1p1/v20130101/tos/
diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/historical/tas/"

; locs = systemfunc("find /glade/collections/cmip/cmip5/ -type d -name tos | grep historical") 
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

;only do historical part here first
TIME2=f[:]->time
yyyymm2=cd_calendar(TIME2, -1)
printMinMax(yyyymm2, True)
ymstrts = ind(yyyymm2.eq.ymstrt)
ymlasts = ind(yyyymm2.eq.ymlast)
print(ymstrts+" <--start end--> "+ymlasts)

    xx  = f[:]->tas(ymstrts:ymlasts,:,:);

delete([/fils,f,TIME2,yyyymm2/]);,lat,lon
 
xx= dtrend_msg_n(xx&time,xx,False,False,0)
xa = rmMonAnnCycTLL(xx)
; xa0!1 = "lat"
; xa0!2 = "lon"

;-------------------------------------
;cover land data; must go first!
;mask 0=ocean (land reserved), 1=land, 2=lake, 3=small island, 4=ice shelf.

 lland = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
 lsm0 = landsea_mask(lland->LSMASK,xa&lat,xa&lon)
 xa_sea = mask(xa,lsm0.eq.1, False)      ; mask out land points
 copy_VarMeta(xa, xa_sea)

delete(lsm0)

;------------remove global mean sst---------------
lat    = xa_sea&lat
rad    = 4.0*atan(1.0)/180.0
clat   = cos(lat*rad)
global_sst = wgt_areaave_Wrap(xa_sea,clat, 1.0, 1)
global_sst2 = conform_dims(dimsizes(xa_sea), global_sst, 0)

xa_r = xa_sea 
xa_r = xa_sea - global_sst2
delete([/lat,clat,global_sst2,global_sst/])


;montly mean 
xam = xa_r ;xa ;xa_r
; ;yearly mean 
; xam = month_to_annual(xa_r, 1) ;xa_r: global mean removed; xa: oringinal
; ndim = dimsizes(xam)
; xam!0 = "time"
; xam&time = ispan(1, ndim(0), 1)
; xam= dtrend_msg_n(xam&time,xam,False,False,0) ;caveat --> unable to remove global sst mean!


;-----------running average------
; endopt    = 1
;  nrun      = 3;*12
;  xam_ft = runave_n_Wrap (xam, nrun, endopt, 1)
;  poam_rm = runave_n_Wrap (poam, nrun, endopt, 0) 
;  printVarSummary(xam_ft)
; ;------------filter----------------------
; fyr   = 8.
; ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
; sigma = 1.0                           ; Lanczos sigma
; nWgt  = toint(fyr*12*1+1) ;fyr)+1 ;                           ; odd only
; fca   = 1./(fyr*12););
; fcb   = -999.
; wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

; xam_ft = wgt_runave_n_Wrap( xam, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions 
; delete(wgt)
;-------------EOF----------------------------------------
; weight!!
; calculate the weights using the square root of the cosine of the latitude and
; also convert degrees to radians
  wgt = sqrt(cos(xam&lat*0.01745329)) 
  
; reorder data so time is fastest varying
  pt  = xam(lat|:,lon|:,time|:)         ; (lat,lon,time)
  ptw = pt                            ; create an array with metadata

; weight each point prior to calculation. 
; conform is used to make wgt the same size as pt

  ptw = pt*tofloat(conform(pt, wgt, 0))
  delete([/pt,wgt/])

optEof = False
  
X = ptw(lat|:,lon|:,time|:) 
eof    = eofunc_Wrap(X({SLAT:NLAT},{WLON:ELON},:),neof,optEof)
eof_ts = eofunc_ts_Wrap(X({SLAT:NLAT},{WLON:ELON},:),eof,False)
pc = dim_standardize_n_Wrap(eof_ts,0,1) ;population standard
pcvar = eof@pcvar
copy_VarCoords(xam(0,{SLAT:NLAT},{WLON:ELON}),eof(0,:,:))


;based on pattern correlation to find the same sign of IPO
rc0  = regCoef(pc(0,:),xam(lat|:,lon|:,time|:));Y
copy_VarCoords(xam(0,:,:),rc0)
rp0 = pattern_cor(rc0({SLAT:NLAT},{WLON:ELON}), rco_r({SLAT:NLAT},{WLON:ELON}), 1.0, 0)
print("pattern correlation with OBS is "+rp0)
if (rp0.le.0) then; (22->-5S,64->110W)   rp0(ia).le.0 rc0({-5},{240}).lt.0.
   pc(0,:) = pc(0,:)*-1.0
   eof_ts(0,:) = eof_ts(0,:)*-1.0
   eof(0,:,:) = eof(0,:,:)*-1.0
end if

 ; tval =new((/nlat,nlon/),typeof(xam)) 
 ; df = new((/nlat,nlon/),"integer")
i = 0
rc = regCoef(pc(i,:),xa(lat|:,lon|:,time|:));, tval, df);Y
copy_VarCoords(xx(0,:,:), rc)
par = pattern_cor(rc({SLAT:NLAT},{WLON:ELON}), rco_r, 1.0, 0) ;pattern correlation with obs of EOF

;df = df-2
;b1 = tval               ; b must be same size as tval (and df) 
;b1 = 0.5 
;prob(ia,i,:,:) = (1-(betainc(df/(df+tval^2),df/2.0,b1)))*100 


copy_VarCoords(xam(0,:,:),rc)

pc!0 = "eof"
pc!1 = "time"
; printVarSummary(rc)
; printVarSummary(pc)

;--------output-------------
fon=diri+"cmip5/"+IND+"/cmip5_historical_"+MODEL(im)+"_"+ENSN(im)+"_"+IND+"_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->rc = rc
fo->pc = pc
fo->pcvar = pcvar
fo->par = par

fon=diri+"cmip5/"+IND+"/cmip5_historical_"+MODEL(im)+"_"+ENSN(im)+"_org."+IND+"_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo1=addfile(fon,"c")
fo1->eof = eof(0,:,:)
fo1->pco = eof_ts

delete([/xx, xa, xam,ptw, xa_r, xa_sea, eof, eof_ts, X, rc0, pcvar,locs_str,par,bb/]);xam_ft,

end do 

;---------read output---------------
  fils = systemfunc("ls "+diri+"cmip5/pdv/cmip5_historical_*_pdv_"+yrs+"-"+yrl+".nc")
  print(fils)
  f1   = addfiles(fils, "r")  ;multiple files
  ListSetType (f1, "join")        ; concatenate (=default)

  rca  = f1[:]->rc
  pca  = f1[:]->pc
  pcvar= f1[:]->pcvar
  par = f1[:]->par
  printVarSummary(rca)
  printVarSummary(pca)
  printVarSummary(pcvar)

nsa = dimsizes(fils)
ndimr = dimsizes(rca)
ndimp = dimsizes(pca)

; ;
; ;method 1: pattern correlation to seperate models don't work
; rad    = 4.0*atan(1.0)/180.0
; clat   = cos(rco_r&LAT*rad)
; ; copy_VarCoords(rco_r(:,0), clat)
; do ii = 0,nsa-1
;   par(ii) = pattern_cor(rca(ii,{SLAT:NLAT},{WLON:ELON}), rco_r, clat, 0)
; end do 
; print(par)

;method 2: three boxes index 
;BOX 1: NPI box (30 to 60°N, 160°E to 140°W)
SLAT1 = 30
NLAT1 = 60
WLON1 = 160
ELON1 = 220

rad    = 4.0*atan(1.0)/180.0
clat   = cos(rca&lat*rad)
copy_VarCoords(rca(0,:,0), clat)
box1 = wgt_areaave_Wrap(rca(:,{SLAT1:NLAT1},{WLON1:ELON1}),clat({SLAT1:NLAT1}), 1.0, 1)

;BOX 2: Tropics box (20S to 20°N, 170 to 100°W)
SLAT2 = -20
NLAT2 =  20
WLON2 = 190
ELON2 = 260

box2 = wgt_areaave_Wrap(rca(:,{SLAT2:NLAT2},{WLON2:ELON2}),clat({SLAT2:NLAT2}), 1.0, 1)

;BOX 3: Southern Pacific box (30 to 60°S, 180 to 120°W)
SLAT3 = -60
NLAT3 = -30
WLON3 = 180
ELON3 = 240

box3 = wgt_areaave_Wrap(rca(:,{SLAT3:NLAT3},{WLON3:ELON3}),clat({SLAT3:NLAT3}), 1.0, 1)

bind = box1 
bind = box2 - (box1+ box3)/2.0
printVarSummary(bind)
print(bind)

;------------------------------------------
MODEL = new(nsa, "string")
ENS  = new(nsa, "string")

;each model ensemble mean
em_rc = new((/50,ndimr(1),ndimr(2)/), typeof(rca), rca@_FillValue)
em_pc = new((/50,ndimp(1),ndimp(2)/), typeof(pca), pca@_FillValue)
em_par = new(50, "float")
MODEL1 = new(50, "string")
ia = 0  ;count model number
ib = 0. ;count ensemble number for each model
aa = rca(0,:,:)
aa = 0.
bb = pca(0,:,:)
bb = 0.
cc = 0.
do im = 0,nsa-1

 locs_str = str_split(fils(im), "_"); "/")
 ; print("'" + locs_str + "'")


MODEL(im) = locs_str(2)
ENS(im)  = locs_str(3)

;calculate each model mean
if (im.gt.0.and.MODEL(im).ne.MODEL(im-1)) then 
  em_rc(ia,:,:) = aa/ib
  em_pc(ia,:,:) = bb/ib
  em_par(ia) = cc/ib
  MODEL1(ia) = MODEL(im-1)
  ia = ia+1
  aa = 0.
  bb = 0.
  cc = 0.
  ib = 0.
end if 

aa = aa + rca(im,:,:)
bb = bb + pca(im,:,:)
cc = cc + par(im)
ib = ib + 1.

if (im.eq.nsa-1) then 
  em_rc(ia,:,:) = aa/ib
  em_pc(ia,:,:) = bb/ib
  em_par(ia) = cc/ib
  MODEL1(ia) = MODEL(im)
  ia = ia+1
end if 

end do 
nmodel = ia 
print(nmodel+" models in CMIP6")
print(MODEL1+" pattern cor="+em_par)
copy_VarMeta(rca(0,:,:), em_rc(0,:,:))
;;----------composite-----------------
com_rc = dim_avg_n_Wrap(em_rc, 0) ;rca, 0)
com_pc = dim_avg_n_Wrap(em_pc, 0) ;pca, 0)

printVarSummary(pca)
printVarSummary(com_rc)

;--------------plot-------------------
wks = gsn_open_wks("ps", dirip+"cmip5_pdv");
plot = new(10,graphic)                ; create graphic array
gsn_define_colormap(wks, "NCV_blu_red"); "BlueDarkRed18");"BrownBlue12");"BlueGreen14");"BlueYellowRed");"sunshine_9lev")"BrownBlue12";
res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""

res2@mpCenterLonF = 180.
res2@mpFillOn = False
res2@mpFillDrawOrder = "PostDraw"
;  res2@mpMaxLatF                   = NLAT         ; choose subregion           
;  res2@mpMinLatF                   = SLAT
;  res2@mpMaxLonF                   = ELON
;  res2@mpMinLonF                   = WLON
res2@gsnAddCyclic = True ;False         
res2@cnFillOn = True;False ;
res2@cnLinesOn = False;True ;
res2@cnLineLabelsOn = False

res2@gsnLeftStringFontHeightF = 0.03
res2@gsnRightStringFontHeightF = 0.03
res2@lbLabelBarOn = True ;False;
res2@lbOrientation = "vertical"
res2@lbTitleOn        =  True                ; turn on title
res2@lbLabelStride    = 2
res2@lbTitleString    = "K"                ; title string
res2@lbTitlePosition  = "Top"              ; title position
res2@lbTitleFontHeightF= .01                ; make title smaller
; res2@lbTitleDirection = "Across"             
res2@lbTitleExtentF   = 0.01 ;Default: 0.15
res2@lbLabelFontHeightF = 0.01  ;Default: 0.02
res2@pmLabelBarWidthF = 0.05

i = 0

res2@cnLevelSelectionMode  = "ManualLevels"    
res2@cnMinLevelValF        = -0.40
res2@cnMaxLevelValF        =  0.40 
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.


res2@gsnLeftString = "CMIP5 MME (EOF"+(i+1)+")"
mpp = dim_avg_n_Wrap(pcvar(:), 0)
res2@gsnRightString = sprintf("%5.1f", mpp) +"%"
plot(0) = gsn_csm_contour_map_ce(wks, com_rc, res2)


resk = True
;resk@txFontHeightF = 0.03
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@lbBoxEndCapStyle = "TriangleBothEnds"
;resk@lbOrientation = "vertical"
resk@lbBoxLinesOn = False
;resk@lbBoxMinorExtentF = 0.2
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02
; resk@txString = MODEL(im)

; gsn_panel(wks,plot,(/2,1/),resk)    

res2@lbLabelBarOn = False;

; do ix = 0,6
  plot1 = new(50,graphic)                ; create graphic array
  ; if (ix.eq.6)then 
  ;   nn = 9
  ; else 
  ;   nn = 32
  ; end if 
    do iy = 0,nmodel-1
    res2@gsnLeftString = MODEL1(iy)+" (EOF"+(i+1)+")"
    res2@gsnRightString = "Pattern Cor="+sprintf("%5.2f", em_par(iy));+"%"
    plot1(iy) = gsn_csm_contour_map_ce(wks, em_rc(iy,:,:), res2)
  end do 

  resk@gsnPanelLabelBar   = True                 ; add common colorbar
  gsn_panel(wks,plot1,(/10,5/),resk)    
; end do 

resk@gsnPanelLabelBar   = False                 ; add common colorbar

;*******************************************
; time series (principal component) plot
;*******************************************

; these four resources allow the user to stretch the plot size, and
; decide exactly where on the page to draw it.

  res = True
  res@gsnDraw = False        ;dont draw
  res@gsnFrame = False        ;dont advance frame
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@vpHeightF = 0.30        ; Changes the aspect ratio
  res@vpWidthF  = 0.6
 
  res@tmXTOn    = False

  ;res2@gsnScale  = True        ; force text scaling               
  ;res@gsnXYBarChart            = True              ; Create bar plot
  ;res@gsnXYBarChartOutlineOnly = True


  res@gsnYRefLine           = 0.0             ; reference line   
  ; res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  ; res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  res@gsnLeftStringFontHeightF  = 0.03
  res@gsnRightStringFontHeightF = 0.03
 ; res@trYMinF               = -3.
 ; res@trYMaxF               =  3.

    ndim  = dimsizes(pca)
  x_axis2 = fspan(yrs, yrl+1, ndim(2))
  ;res@tmXBMode   = "Explicit"                                                
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
res@tiYAxisString = ""
res@tiXAxisString = "year"

res@xyLineThicknessF = 1.0
res@xyLineColor = "grey40"
res@gsnLeftString = ""
res@gsnRightString = "PC1"
plot(1) = gsn_csm_xy (wks,x_axis2,em_pc(:,0,:),res) ;pca

res@xyLineThicknessF = 4.0
res@xyLineColor = "black"

plota = gsn_csm_xy (wks,x_axis2,com_pc(0,:),res)
overlay(plot(1), plota)


gsn_panel(wks,plot,(/2,1/),resk);(without removing nearby annual cycle)

  do iy = 0,nmodel-1
    res@gsnLeftString = MODEL1(iy)
    res@gsnRightString = ""; sprintf("%5.1f", pcvar(iy)) +"%"
    plot1(iy) = gsn_csm_xy(wks,x_axis2, em_pc(iy,0,:), res)
  end do 
  resk@gsnPanelLabelBar   = False                 ; add common colorbar
  gsn_panel(wks,plot1,(/10,5/),resk)    


; delete([/ndim, pca, rca, pcvar, com_rc, com_pc, x_axis2, res, res2/])

end
