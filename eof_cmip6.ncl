begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
neof = 3

; NLAT =   65; 5; 60;
; SLAT =  -70;-5;-60;
; WLON =  100;120;
; ELON =  300;290;

; CMIP6 MODELS
MODEL6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
        "CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
        "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",
MODEL6_ESM = (/"CanESM5","CESM2-FV2","CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0",\
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorESM2-LM"/)

MODEL6_CM = (/"BCC-CSM2-MR","CAMS-CSM1-0","GFDL-CM4","GISS-E2-1-G",\
       "INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6","NorCPM1","SAM0-UNICON" /)

MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
  "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0",\
    "BCC-CSM2-MR","CESM2-FV2","CESM2-WACCM-FV2",\
         "CESM2-WACCM","FIO-ESM-2-0","NorESM2-LM" /) ;large ensemble model in CMIP6 "NESM3",

nens6 = (/32,30,25,12,11, 10, 10,\;10,
          10,7,5,5,\
          3,3,3,\
          3,3,3 /) ;ensemble number 5,


nm6 = dimsizes(MODEL6)

  yrs = 1850
  yrl = 2014
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

VAR = "cloudeffect" ;"cloudeffect";"tas" ; "rsds" "va" ;"psl" ; 
EXP = "historical"

nens_all = 32

diri1 = "/glade/collections/cmip/cmip6/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip6/"

; note, the max lag should not be more than N/4
rc = new((/nm6,nens_all,neof, 72,144 /), "float") 
pc = new((/nm6,nens_all,neof,(yrl-yrs+1)*12 /), "float") 

do im = 0,nm6-1

;from pdv_cmip6_hist.ncl
;cmip6_historical_CanESM2_r4i1p1_pdv_1850-2014.nc
locs = systemfunc("ls "+diri+"cmip6/pdv/cmip6_historical_"+MODEL6(im)+"_*_pdv_1850-2014.nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

do ia = 0,nsa-1
  
 locs_str = str_split(locs(ia), "_"); "/")
 print("'" + locs_str + "'")
  ENSN  = locs_str(3)

  print(MODEL6(im)+" ens "+ENSN)

    file_name = diri3+EXP+"/"+VAR+"/"+MODEL6(im)+"_"+VAR+"_"+EXP+"_"+ENSN+".nc"
    exists = isfilepresent(file_name)
    if(.not.exists) then
      print(MODEL6(im)+" ens "+ENSN+" file not exist")
      print("Either the file doesn't exist, or NCL does")
      print("not have OPeNDAP cabilities on this system.")
      continue
    else
  
    f   = addfile(file_name, "r") 
    end if

  
TIME2=f->time
yyyymm2=cd_calendar(TIME2, -1)
printMinMax(yyyymm2, True)
ymstrts = ind(yyyymm2.eq.ymstrt)
ymlasts = ind(yyyymm2.eq.ymlast)

    xx  = f->ce(ymstrts:ymlasts,:,:);$VAR$

;;check NAN points!!!
  if (any(ismissing(xx))) then
    print("there is nan in col")
    xx = where(ismissing(xx), 0.0, xx)  
  end if

delete([/f,TIME2,yyyymm2/]);,lat,lon
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
  
X = xam_ft(lat|:,lon|:,time|:) 
eof    = eofunc_Wrap(X(:,:,:),neof,optEof)
eof_ts = eofunc_ts_Wrap(X(:,:,:),eof,False)
pcvar = eof@pcvar
copy_VarCoords(xam(0,:,:),eof(0,:,:))
pc(im,ia,:,:) = dim_standardize_n_Wrap(eof_ts,0,1) ;population standard
  do i = 0,neof-1
    rc(im,ia,i,:,:) = regCoef(pc(im,ia,i,:),xa(lat|:,lon|:,time|:))
  end do 
  copy_VarCoords(xa(0,:,:), rc(im,ia,0,:,:))

delete([/locs_str,X/])


end do 
delete([/locs/]);,x_Lead1
end do 
  rc!0 = "model"
  rc!1 = "ensemble"
  rc!2 = "eof"

pc!0 = "model"
pc!1 = "ensemble"
pc!2 = "eof"
pc!3 = "time"
printVarSummary(rc)
printVarSummary(pc)
;--------output-------------
fon=diri+"cmip6_"+EXP+"_eof_"+VAR+"_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->rc = rc
fo->pc = pc
fo->pcvar = pcvar

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
ndimr = dimsizes(rca)
ndimp = dimsizes(pca)

MODEL = new(nsa, "string")
ENS  = new(nsa, "string")

;each model ensemble mean
em_rc = new((/30,ndimr(1),ndimr(2)/), typeof(rca), rca@_FillValue)
em_pc = new((/30,ndimp(1),ndimp(2)/), typeof(pca), pca@_FillValue)
MODEL1 = new(30, "string")
ia = 0  ;count model number
ib = 0. ;count ensemble number for each model
aa = rca(0,:,:)
aa = 0.
bb = pca(0,:,:)
bb = 0.

do im = 0,nsa-1

 locs_str = str_split(fils(im), "_"); "/")
 ; print("'" + locs_str + "'")


MODEL(im) = locs_str(2)
ENS(im)  = locs_str(3)

;calculate each model mean
if (im.gt.0.and.MODEL(im).ne.MODEL(im-1)) then 
  em_rc(ia,:,:) = aa/ib
  em_pc(ia,:,:) = bb/ib
  MODEL1(ia) = MODEL(im-1)
  ia = ia+1
  aa = 0.
  bb = 0.
  ib = 0.
end if 

aa = aa + rca(im,:,:)
bb = bb + pca(im,:,:)
ib = ib + 1.

if (im.eq.nsa-1) then 
  em_rc(ia,:,:) = aa/ib
  em_pc(ia,:,:) = bb/ib
  MODEL1(ia) = MODEL(im)
  ia = ia+1
end if 

end do 
print(ia+" models in CMIP6")
print(MODEL1+"")
;;----------composite-----------------
com_rc = dim_avg_n_Wrap(em_rc, 0) ;rca, 0)
com_pc = dim_avg_n_Wrap(em_pc, 0) ;pca, 0)

printVarSummary(pca)
printVarSummary(com_rc)
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

; do ix = 0,6
  plot1 = new(40,graphic)                ; create graphic array
  ; if (ix.eq.6)then 
  ;   nn = 9
  ; else 
  ;   nn = 32
  ; end if 
    do iy = 0,29
    res2@gsnLeftString = MODEL1(iy)+" (EOF"+(i+1)+")"
    res2@gsnRightString = ""; sprintf("%5.1f", pcvar(iy)) +"%"
    plot1(iy) = gsn_csm_contour_map_ce(wks, em_rc(iy,:,:), res2)
  end do 

  resk@gsnPanelLabelBar   = True                 ; add common colorbar
  gsn_panel(wks,plot1,(/8,4/),resk)    
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

; delete([/ndim, pca, rca, pcvar, com_rc, com_pc, x_axis2, res, res2/])

end
