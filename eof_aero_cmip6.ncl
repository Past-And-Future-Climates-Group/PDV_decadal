begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
neof = 3

;read obs IPO results
;from obs_ipo.ncl
f0   = addfile(diri+"obs_pdv_1880-2018.nc", "r") ;obs_pdv_1854-2019.nc
rco  = f0->rc(0,:,:)
pco  = f0->pc
pcvaro  = f0->pcvar
printVarSummary(rco)

; ; Asian area
; NLAT =   65; 5; 60;
; SLAT =  -10;-5;-60;
; WLON =   90;120;
; ELON =  180;290;

; global area
NLAT =   90; 5; 60;
SLAT =  -90;-5;-60;
WLON =   0;120;
ELON =  360;290;


  yrs = 1850
  yrl = 2014
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

;/glade/collections/cmip/cmip6/output1/CNRM-CERFACS/CNRM-CM5/historical/mon/ocean/Omon/r10i1p1/v20130101/tos/
diri1 = "/glade/collections/cmip/CMIP6/"
diri2 = "/glade/scratch/chenxing/cmip6/historical/od550aer/"

; locs = systemfunc("find /glade/collections/cmip/cmip6/ -type d -name tos | grep historical") 
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
MODEL(im) = aa(6)
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

;montly mean 
xam = xa ;xa_r ;xa_r
; ;yearly mean 
; xam = month_to_annual(xa_r, 1) ;xa_r: global mean removed; xa: oringinal
; ndim = dimsizes(xam)
; xam!0 = "time"
; xam&time = ispan(1, ndim(0), 1)
; xam= dtrend_msg_n(xam&time,xam,False,False,0) ;caveat --> unable to remove global sst mean!

; ;-------------------------------------
; ; no need for aerosol, eofs over ocean and global are the same!!!
; ;cover land data
; ;mask 0=ocean (land reserved), 1=land, 2=lake, 3=small island, 4=ice shelf.

;  lland = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
;  lsm0 = landsea_mask(lland->LSMASK,xam&lat,xam&lon)
;  xam_sea = mask(xam,lsm0.eq.1, False)      ; mask out land points
;  copy_VarMeta(xam, xam_sea)

; delete(lsm0)

;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*12*1+1) ;fyr)+1 ;                           ; odd only
fca   = 1./(fyr*12););
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

xam_ft = wgt_runave_n_Wrap( xam, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions 

;-------------EOF----------------------------------------
optEof = False
  
X = xam_ft({lat|SLAT:NLAT},{lon|WLON:ELON},time|:) 
eof    = eofunc_Wrap(X(:,:,:),neof,optEof)
eof_ts = eofunc_ts_Wrap(X(:,:,:),eof,False)
pcvar = eof@pcvar
copy_VarCoords(xam(0,{SLAT:NLAT},{WLON:ELON}),eof(0,:,:))
; pc = dim_standardize_n_Wrap(eof_ts,0,1) ;population standard


eof!0 = "eof"
eof_ts!0 = "eof"
eof_ts!1 = "time"
printVarSummary(eof)
printVarSummary(eof_ts)

rc = xam(1:neof,:,:)
do i = 0,neof-1
  rc(i,:,:) = regCoef_n(eof_ts(i,:),xam_ft,  0, 0)
end do 
copy_VarCoords(xam(0,:,:),rc(0,:,:))
rc!0 = "eof"
;--------output-------------
fon=diri+"cmip6/od550aer/cmip6_historical_"+MODEL(im)+"_"+ENS(im)+"_eof_global_od550aer_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
; fo->eof = eof
fo->rc = rc
fo->pc = eof_ts
fo->pcvar = pcvar

delete([/xx, xa, xam,  xam_ft, eof, eof_ts, X, pcvar,rc/]);xa_r,

end do 

exit
;---------read output---------------
  fils = systemfunc("ls "+diri+"cmip6/cmip6_historical_*_eof_od550aer_"+yrs+"-"+yrl+".nc")
  print(fils)
  f1   = addfiles(fils, "r")  ;multiple files
  ListSetType (f1, "join")        ; concatenate (=default)

  rca  = f1[:]->rc
  pca  = f1[:]->pc
  pcvar= f1[:]->pcvar
  printVarSummary(rca)
  printVarSummary(pca)
  printVarSummary(pcvar)

nsa = dimsizes(fils)


MODEL = new(nsa, "string")
ENS  = new(nsa, "string")

do im = 0,nsa-1

 locs_str = str_split(fils(im), "_"); "/")
 print("'" + locs_str + "'")


MODEL(im) = locs_str(2)
ENS(im)  = locs_str(3)

end do 

;;----------composite-----------------
com_rc = dim_avg_n_Wrap(rca, 0)
com_pc = dim_avg_n_Wrap(pca, 0)

printVarSummary(pca)
;--------------plot-------------------
wks = gsn_open_wks("ps", dirip+"cmip6_pdv");
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


res2@gsnLeftString = "CMIP6 MME (EOF"+(i+1)+")"
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

do ix = 0,6
  plot1 = new(40,graphic)                ; create graphic array
  if (ix.eq.6)then 
    nn = 9
  else 
    nn = 32
  end if 
    do iy = 0,nn-1
    res2@gsnLeftString = MODEL(ix*32+iy)+" "+ENS(ix*32+iy)+" (EOF"+(i+1)+")"
    res2@gsnRightString = sprintf("%5.1f", pcvar(ix*32+iy)) +"%"
    plot1(iy) = gsn_csm_contour_map_ce(wks, rca(ix*32+iy,:,:), res2)
  end do 

  resk@gsnPanelLabelBar   = True                 ; add common colorbar
  gsn_panel(wks,plot1,(/8,4/),resk)    
end do 

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
plot(1) = gsn_csm_xy (wks,x_axis2,pca(:,0,:),res)

res@xyLineThicknessF = 4.0
res@xyLineColor = "black"

plota = gsn_csm_xy (wks,x_axis2,com_pc(0,:),res)
overlay(plot(1), plota)


gsn_panel(wks,plot,(/2,1/),resk);(without removing nearby annual cycle)

; delete([/ndim, pca, rca, pcvar, com_rc, com_pc, x_axis2, res, res2/])

end
