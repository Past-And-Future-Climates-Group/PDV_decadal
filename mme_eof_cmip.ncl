begin

NLAT =   90; 5; 60;
SLAT =  -90;-5;-60;
WLON =  0;120;
ELON =  360;290;


diri = "/glade/work/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/data/" ;
dirip = "/glade/u/home/chenxing/enso/";"/Users/xingchen/Documents/project/ENSO/pic/" ;
neof = 2

;CMIP5 MODELS
MODEL_cmip5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;"bcc-csm1-1-m",
      "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
      "GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
      "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\;"MRI-ESM1",
      "NorESM1-ME","NorESM1-M"/)


; CMIP6 MODELS
MODEL_cmip6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
        "CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
        "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",

; MODEL6 = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
;   "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",


; MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
;   "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",

; nens6 = (/32,30,25,12,11, 10, 10,\;10,
;           10,7,5,5 /) ;ensemble number 5,



; MODEL6_ESM = (/"CanESM5","CESM2","E3SM-1-0",\
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0"/)

; MODEL6_CM = (/"GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MIROC6","NorCPM1" /)

yrs6 = 1850;1930;
yrl6 = 2014;
yrs5 = 1861;1930;
yrl5 = 2004;

;;;change here
icmip = 6; 5 ;
VAR = "ts" ;"tas";

MODEL = MODEL_cmip6

yrs = yrs6
yrl = yrl6


ymstrt= yrs*100+1  
ymlast= yrl*100+12

nyr = yrl - yrs +1
;;

;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip"+icmip+"/historical/"+VAR+"/"
; locs = systemfunc("find /glade/collections/cmip/cmip"+icmip+"/ -type d -name tos | grep historical") 
nsa = dimsizes(MODEL)

xmodel = new((/nsa,nyr*12,72,144/), "float")
xmodel = 0.

do im = 0,nsa-1
  
  fils = systemfunc("ls "+diri3+"*"+MODEL(im)+"*.nc")
  nf = dimsizes(fils)
  print(fils)
  ; f   = addfiles(fils, "r")  ;multiple files
  ; ListSetType (f, "join")        ; concatenate (=default)

xa = new((/nf,nyr*12,72,144/), "float") 
do ii = 0,nf-1
  f   = addfile(fils(ii), "r")
  TIME2=f->time
  yyyymm2=cd_calendar(TIME2, -1)
  printMinMax(yyyymm2, True)
  ymstrts = ind(yyyymm2.eq.ymstrt)
  ymlasts = ind(yyyymm2.eq.ymlast)
  print(ymstrts+" <--start end--> "+ymlasts)
  
      xx  = f->$VAR$(ymstrts(0):ymlasts(0),:,:);
  ; printVarSummary(xx)
  delete([/f,TIME2,yyyymm2/]);,lat,lon
 
  xa(ii,:,:,:) = rmMonAnnCycTLL(xx)
end do 

;ensemble mean 
xe = dim_avg_n_Wrap(xa, 0)

xmodel(im,:,:,:) = xe 
copy_VarMeta(xx, xmodel(im,:,:,:))

print(MODEL(im)+" is done")
delete([/fils,xx,xa,xe/])
end do 

xmme = dim_avg_n_Wrap(xmodel, 0)
printVarSummary(xmme)

;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*12*1+1) ;fyr)+1 ;                           ; odd only
fca   = 1./(fyr*12););
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

xmme = wgt_runave_n_Wrap( xmme, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions 
delete(wgt)


; ;Dtrended!!
; xmme= dtrend_msg_n(xmme&time,xmme,False,False,0)

;-------------EOF----------------------------------------
; weight!!
; calculate the weights using the square root of the cosine of the latitude and
; also convert degrees to radians
  wgt = sqrt(cos(xmme&lat*0.01745329)) 
  
; reorder data so time is fastest varying
  pt  = xmme(lat|:,lon|:,time|:)         ; (lat,lon,time)
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
copy_VarCoords(xmme(0,{SLAT:NLAT},{WLON:ELON}),eof(0,:,:))

 ; tval =new((/nlat,nlon/),typeof(xmme)) 
 ; df = new((/nlat,nlon/),"integer")

rc = new((/neof,72,144/), typeof(xmme))
rc(0,:,:) = regCoef(pc(0,:),xmme(lat|:,lon|:,time|:));, tval, df);Y
rc(1,:,:) = regCoef(pc(1,:),xmme(lat|:,lon|:,time|:));, tval, df);Y
copy_VarCoords(xmme(0,:,:), rc(0,:,:))


;df = df-2
;b1 = tval               ; b must be same size as tval (and df) 
;b1 = 0.5 
;prob(ia,i,:,:) = (1-(betainc(df/(df+tval^2),df/2.0,b1)))*100 


pc!0 = "eof"
pc!1 = "time"
; printVarSummary(rc)
; printVarSummary(pc)

;--------output-------------
fon=diri+"cmip"+icmip+"/cmip"+icmip+"_historical_mme.eof_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->rc = rc
fo->pc = pc
fo->pcvar = pcvar

exit
;---------read output---------------
  f1   = addfile(diri+"cmip5/cmip5_historical_mme.eof_1861-2004.nc", "r")  ;multiple files
  f2   = addfile(diri+"cmip6/cmip6_historical_mme.eof_1850-2014.nc", "r")  ;multiple files

  rca5  = f1->rc
  pca5  = f1->pc
  pcvar5= f1->pcvar
  rca6  = f2->rc
  pca6  = f2->pc
  pcvar6= f2->pcvar
  printVarSummary(rca5)
  printVarSummary(pca5)
  printVarSummary(pcvar5)

;--------------plot-------------------
wks = gsn_open_wks("png", dirip+"mme_eof");
plot = new(10,graphic)                ; create graphic array
plot2 = new(10,graphic)                ; create graphic array
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

res2@lbLabelBarOn = False;True ;
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

res2@cnLevelSelectionMode  = "ManualLevels"    
res2@cnMinLevelValF        = -0.40
res2@cnMaxLevelValF        =  0.40 
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.

do i = 0,neof-1


res2@gsnLeftString = "CMIP5 MME (EOF"+(i+1)+")"
res2@gsnRightString = sprintf("%5.1f", pcvar5(i)) +"%"
plot(i*2) = gsn_csm_contour_map_ce(wks, rca5(i,:,:), res2)
res2@gsnLeftString = "CMIP6 MME (EOF"+(i+1)+")"
res2@gsnRightString = sprintf("%5.1f", pcvar6(i)) +"%"
plot(i*2+1) = gsn_csm_contour_map_ce(wks, rca6(i,:,:), res2)
end do 

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

resk@gsnPanelLabelBar   = True                 ; add common colorbar
gsn_panel(wks,plot,(/2,2/),resk)

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
  
  res@trYMinF               = -3.
  res@trYMaxF               =  3.
  res@trXMinF               = 1850
  res@trXMaxF               = 2015

    ndim5  = dimsizes(pca5)
  x_axis5 = fspan(yrs5, yrl5+1, ndim5(1))
    ndim6  = dimsizes(pca6)
  x_axis6 = fspan(yrs6, yrl6+1, ndim6(1))
  ;res@tmXBMode   = "Explicit"                                                
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
res@tiYAxisString = ""
; res@tiXAxisString = "year"

res@xyLineThicknessF = 2.0
res@gsnLeftString = ""
do i = 0,neof-1

  res@gsnRightString = "PC"+(i+1)
  res@xyLineColor = "red"
  plot2(i) = gsn_csm_xy (wks,x_axis5,pca5(i,:),res) ;pca
  res@xyLineColor = "black"
  plota = gsn_csm_xy (wks,x_axis6,pca6(i,:),res) ;pca
  overlay(plot2(i), plota)

end do 

;************************************************
; Attach text to plot using plot coordinates.
;************************************************
  txres               = True                     ; text mods desired
  txres@txFontHeightF = 0.015                     ; font smaller. default big
  txres@txFontColor   = "red"
  dum  = gsn_add_text(wks,plot2(0),"CMIP5",1870,2.0,txres) 
  dum2 = gsn_add_text(wks,plot2(1),"CMIP5",1870,2.0,txres) 
  txres@txFontColor   = "black"
  dum1 = gsn_add_text(wks,plot2(0),"CMIP6",1870,1.5,txres) 
  dum3 = gsn_add_text(wks,plot2(1),"CMIP6",1870,1.5,txres) 


resk@gsnPanelLabelBar   = False                 ; add common colorbar
gsn_panel(wks,plot2,(/2,1/),resk)


end
