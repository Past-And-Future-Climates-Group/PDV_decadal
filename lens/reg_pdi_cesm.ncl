begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

NLAT =  70; 65; 5; 60;
SLAT =  20;-70;-5;-60;
WLON =  100;120;
ELON =  300;290;

;read obs IPO results
;from obs_ipo.ncl
f0   = addfile(diri+"obs_pdv_1880-2018.nc", "r") ;obs_pdv_1854-2019.nc
rco  = f0->rc(0,:,:)
pco  = f0->pc
pcvaro  = f0->pcvar
printVarSummary(rco)

  fref = systemfunc("ls "+diri+"cmip6/tos.pdv/cmip6_historical_ACCESS-CM2_r1i1p1f1_pdv_1850-2014.nc")
  print(fref)
  fr   = addfile(fref(0), "r")  ;multiple files
  rref = fr->rc;({SLAT:NLAT},{WLON:ELON})

;change resolution for obs to fit with model (to do pattern correlation)
    aa = rco;({SLAT:NLAT},{WLON:ELON})
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


;cesm1 single forcing
diri1 = "/glade/scratch/chenxing/cesm1_le/"
;b.e11.B20TRLENS_RCP85.f09_g16.xghg.011.cam.h0.TS.192001-200512.nc

;cesm2 with CMIP5 forcing
diri2 = "/glade/scratch/chenxing/cesm2_cmip5_forcing/"
;b.e21.BHIST.f09_g17.cesm2_cmip5_forcing.002.cam.h0.TS.185001-200512.nc


VAR = "TS" ;"od550aer" ;"cloudeffect";"tas" ; "rsds" "va" ;"psl" ; 
IND = "PDI" ;"mmeeof2" ;"mmeeof1" ;"GMAOD" ;"PDI2" ;"PDI"; "AR1Di" ;"SLPAL" ;"pdv";"TNA"; "AR1varm"; "TNA"; 
AA =  ""

MODEL = "cesm1_le";"cesm2_cmip5_forcing" ;
EXP =  (/"xghg", "xaer" , "xlulc", "xbmb"/);"" ;

nm = dimsizes(EXP)

do im = 0,nm-1

if (MODEL.eq."cesm2_cmip5_forcing") then
locs = systemfunc("ls "+diri2+"*"+MODEL+"*"+VAR+"*.nc") 
else 
locs = systemfunc("ls "+diri1+"*"+EXP(im)+"*"+VAR+"*.nc") 
end if 
print(locs)
nsa = dimsizes(locs)


ENSN  = new(nsa, "string")

aa = new((/nsa, 72,144 /), "float") 
rp1 = new(nsa, "float")

istart = 0
do ia = istart,nsa-1

 locs_str = str_split(locs(ia), ".")
 print("'" + locs_str + "'")


ENSN(ia)  = locs_str(5)

bb = str_split(locs_str(9), "-")

  yrl = 2004
  ymlast= yrl*100+12
if(ia.eq.0) then 
  ymstrt= bb(0)
  yrs = toint(tofloat(bb(0))/100.)
end if 

print(ymstrt+", "+yrs)
print(MODEL+" ens "+ENSN(ia))
  
  fils = systemfunc("ls "+locs(ia));+"/*.nc")
  print(fils)
  f   = addfiles(fils, "r")  ;multiple files
  ListSetType (f, "cat")        ; concatenate (=default)

;only do historical part here first
TIME2=f[:]->time
yyyymm2=cd_calendar(TIME2, -1)
printMinMax(yyyymm2, True)
ymstrts = ind(yyyymm2.eq.ymstrt)
ymlasts = ind(yyyymm2.eq.ymlast)
ycstrts = ind(yyyymm2.eq.197501)
yclasts = ind(yyyymm2.eq.200412)
print(ymstrts+" <--start end--> "+ymlasts)

    xx  = f[:]->$VAR$(0:ymlasts+1,:,:) ;(ymstrts:ymlasts,:,:);

  delete([/f,TIME2,yyyymm2/]);,lat,lon
   
  xa = rmMonAnnCycTLL(xx)
  
  ; xa_annual = month_to_annual(xa, 1)
  ; xa_sea = month_to_seasonN(xa, SEASON)
  ; ;season, year --> season * year one dimension
  ; ndim1 = dimsizes(xa_sea)
  ; xa_sea2 = reshape(xa_sea, (/ndim1(0)*ndim1(1),ndim1(2),ndim1(3) /) )
  ; xa_sea2!0 = "time"
  ; copy_VarMeta(xa(0,:,:), xa_sea2(0,:,:))

;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*12*1+1); fyr)+1 ;                           ; odd only
fca   = 1./(fyr*12)
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

  ;---------read output---------------
  

  ;;some index
  ;from lens5_index.ncl
  if (MODEL.eq."cesm2_cmip5_forcing") then
    f1   = addfile(diri+"lens5/PDI/"+MODEL+"_"+ENSN(ia)+"_PDI_"+yrs+"-"+yrl+".nc", "r") 
  else
    f1   = addfile(diri+"lens5/PDI/"+MODEL+"_"+EXP(im)+"_"+ENSN(ia)+"_PDI_"+yrs+"-"+yrl+".nc", "r") 
  end if 
  pc  = f1->index
  pc_ft = wgt_runave_n_Wrap( pc, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions 

  ; ;global external forcing mode
  ; ;from mme_eof_cmip6.ncl 
  ; if (MODEL.eq."cesm2_cmip5_forcing") then
  ;   ff = systemfunc("ls "+diri+"lens5/PDI/"+MODEL+"_*_PDI_"+yrs+"-"+yrl+".nc") 
  ; else
  ;   ff = systemfunc("ls "+diri+"lens5/PDI/"+MODEL+"_"+EXP(im)+"_*_PDI_"+yrs+"-"+yrl+".nc") 
  ; end if 
  ; f1   = addfiles(ff, "r") 
  ; ListSetType (f1, "join")       
  ; pc0  = f1[:]->index
  ; pc = wgt_runave_n_Wrap( pc0, wgt,  0, 1 )   ;opt < 0 : utilize cyclic conditions 
  ; pc_ft = dim_avg_n_Wrap(pc, 0)
  ; delete([/ff,pc0/])

  ; pc_annual = month_to_annual(pc, 1)
  ; pc_sea = month_to_seasonN(pc, SEASON)
  ; pc_sea2 = ndtooned(pc_sea)
  ; pc_sea2!0 = "time"
  delete([/xx/]);,xa_sea,pc_sea /])
  

; ???
pc_ft = dim_standardize_n_Wrap(pc_ft, 0, 0)
printVarSummary(pc_ft)
;---------interpolate---------------------
;change resolution for MODELS to the same 144*72
    zz = xa
   ; r_lon = 360./dimsizes(xam&lon)
    ; r_lat = 180./dimsizes(xam&lat)
    lat = zz&lat
    lon = zz&lon 
    nlat = dimsizes(rref&lat) ;target dimension size
    nlon = dimsizes(rref&lon) ;target dimension size
    klon = fspan(WLON, ELON, nlon) ;target dimension 
    klat = fspan(SLAT, NLAT, nlat) ;target dimension
    cc= linint2_Wrap(lon, lat, zz, True, klon, klat, 0) 
    cc&LAT@units="degrees_north"
    cc&LON@units="degrees_east"
    printVarSummary(cc)
    delete([/lat,lon,klat,klon,zz/]);xa0
    cc!1 = "lat"
    cc!2 = "lon"

;-----------regression-------------
aa(ia,:,:) = regCoef(pc_ft,cc(lat|:,lon|:,time|:));, tval, df);Y

copy_VarCoords(rref, aa(ia,:,:))
 
;----pattern correlation---------

rp1(ia) = pattern_cor(aa(ia,{SLAT:NLAT},{WLON:ELON}), rco_r({SLAT:NLAT},{WLON:ELON}), 1.0, 0)

;--------output-------------
if (MODEL.eq."cesm2_cmip5_forcing") then
fon=diri+"lens5/"+MODEL+"_"+ENSN(ia)+"_reg_"+IND+"_"+VAR+"_"+yrs+"-"+yrl+".nc";
; fon=diri+"lens5/"+MODEL+"_"+ENSN(ia)+"_reg_mme_"+IND+"_"+VAR+"_"+yrs+"-"+yrl+".nc";
else
fon=diri+"lens5/"+MODEL+"_"+EXP(im)+"_"+ENSN(ia)+"_reg_"+IND+"_"+VAR+"_"+yrs+"-"+yrl+".nc";
; fon=diri+"lens5/"+MODEL+"_"+EXP(im)+"_"+ENSN(ia)+"_reg_mme_"+IND+"_"+VAR+"_"+yrs+"-"+yrl+".nc";
end if 
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->rc  = aa(ia,:,:)
fo->par = rp1(ia)

delete([/locs_str,pc,xa,pc_ft,cc/]);,pc_sea2,xa_sea2,
end do 

aa!0 = "ensemble"
rp1!0 = "ensemble"
; ;--------output-------------
; fon=diri+"lens5/"+MODEL(ia)+"_reg_"+IND+"_"+EXP+"_"+VAR+"_"+yrs+"-"+yrl+".nc";
; system("rm -f "+fon)
; fo=addfile(fon,"c")
; fo->rc  = aa
; fo->par = rp1

delete([/locs/]);,x_Lead1

print("regression done for "+MODEL(0))
delete([/ENSN,aa,rp1/])

end do 

print("regression done")

exit
;---------read output---------------
f1   = addfile(diri+"cmip5_reg_all_"+IND+"_"+EXP+"_"+VAR+"_"+yrs+"-"+yrl+".nc", "r")
ccr1  = f1->ccr1

f2   = addfile(diri+"cmip6_reg_all_"+IND+"_"+EXP+"_ts_1850-2014.nc", "r")
ccr2  = f2->ccr1

;;----------composite-----------------
;MME
com_ccr = dim_avg_n_Wrap(ccr1 , 0)
printVarSummary(com_ccr)
com_ccr_y = dim_avg_n_Wrap(ccr1(i5y,:,:) , 0)
com_ccr_n = dim_avg_n_Wrap(ccr1(i5n,:,:) , 0)
; com_ccr_le = dim_avg_n_Wrap(ccr1(i5le,:,:) , 0)

;CMIP6
com_ccr6 = dim_avg_n_Wrap(ccr2 , 0)

printMinMax(com_ccr, 0)
; ;-------t-test---------------------------------
; pra_std = dim_stddev_n_Wrap(ccr, 0)

; df = pra_avg_p1
; df = nens(im)
; b = pra_avg_p1
; b = 0.5
; pr_tval = pra_avg_p1
; pr_tval = (pra_avg_p1-0)*sqrt(40)/pra_std
; pr_prob = (1.-betainc( df/(df+pr_tval^2), df/2.0, b))*100.  ; probability in %
; printMinMax(pr_prob, 0)

; delete([/df,b/])

; sig_pra1 = pra_avg_p1
; sig_pra1 = where(pr_prob.ge.90., abs(pra_avg_p1), pra_avg_p1@_FillValue) 

;--------------plot-------------------
wks = gsn_open_wks("ps", dirip+"cmip5_reg");
plot = new(30,graphic)                ; create graphic array
plot1 = new(30,graphic)                ; create graphic array
plot2 = new(30,graphic)                ; create graphic array
plot3 = new(30,graphic)                ; create graphic array
gsn_define_colormap(wks, "NCV_blu_red")


res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""
res2@vpWidthF  = 0.6

res2@mpCenterLonF = 180.
res2@mpFillOn = False
res2@mpFillDrawOrder = "PostDraw"
 ; res2@mpMaxLatF                   = NLAT         ; choose subregion           
 ; res2@mpMinLatF                   = SLAT
 ; res2@mpMaxLonF                   = ELON
 ; res2@mpMinLonF                   = WLON
res2@gsnAddCyclic = True ;False         
res2@cnFillOn = True;False ;
res2@cnLinesOn = False;True ;
res2@cnLineLabelsOn = False

res2@gsnLeftStringFontHeightF = 0.03
res2@gsnRightStringFontHeightF = res2@gsnLeftStringFontHeightF
res2@lbLabelBarOn = False;
res2@lbOrientation = "Horizontal"
res2@lbBoxLinesOn  = False
res2@lbTitleOn        =  True                ; turn on title
res2@lbLabelStride    = 2
res2@lbTitleString    = ""                ; title string
res2@lbTitlePosition  = "Right"              ; title position
res2@lbTitleFontHeightF= .015                ; make title smaller
; res2@lbTitleDirection = "Across"             
res2@lbTitleExtentF   = 0.01 ;Default: 0.15
res2@lbLabelFontHeightF = 0.01  ;Default: 0.02
; res2@pmLabelBarWidthF = 0.05

res2@cnLevelSelectionMode  = "ManualLevels"    
res2@cnMinLevelValF        = -0.05
res2@cnMaxLevelValF        =  0.05
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.


res2@gsnLeftString = ""
    res2@gsnRightString = "CMIP6"
    plot(0) = gsn_csm_contour_map_ce(wks, com_ccr6, res2)
    res2@gsnRightString = "CMIP5"
    plot(1) = gsn_csm_contour_map_ce(wks, com_ccr, res2)
    res2@gsnRightString = "CMIP5(plus)"
    plot(2) = gsn_csm_contour_map_ce(wks, com_ccr_y, res2)
    res2@gsnRightString = "CMIP5(minus)"
    plot(3) = gsn_csm_contour_map_ce(wks, com_ccr_n, res2)


resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = True                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@lbBoxEndCapStyle = "TriangleBothEnds"
resk@lbOrientation = "Horizontal"
resk@lbBoxLinesOn = False
; resk@lbTitleString = com_ccr@units
;resk@lbBoxMinorExtentF = 0.2
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02
resk@txString = VAR+" regressed onto "+IND+" "+yrs+"-"+yrl
gsn_panel(wks,plot,(/2,2/),resk)


end