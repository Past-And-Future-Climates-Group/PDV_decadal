begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
neof = 3

; NLAT =   65; 5; 60;
; SLAT =  -70;-5;-60;
; WLON =  100;120;
; ELON =  300;290;

  yrs = 1861
  yrl = 2004
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

  yrs5 = 1861
  yrl5 = 2004
  yrs6 = 1850
  yrl6 = 2014

MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;"bcc-csm1-1-m",
      "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
      "GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
      "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\;"MRI-ESM1",
      "NorESM1-ME","NorESM1-M"/)

MODEL5_PLUS = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0",\;,"GFDL-CM3"
          "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM",\
          "MRI-CGCM3","NorESM1-M",\
          "FGOALS-g2"/) ;explicitly have aerosol interaction included in CMIP5

MODEL5_MINUS = (/"bcc-csm1-1","CCSM4","CESM1-FASTCHEM",\
          "MPI-ESM-LR",\
          "GFDL-CM2p1","FGOALS-s2","FIO-ESM","HadCM3",\
          "MPI-ESM-MR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",
; MODEL5_PLUS = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","HadGEM2-CC",\;,"GFDL-CM3"
;           "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM-CHEM","MIROC-ESM",\
;           "MRI-CGCM3","NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

; MODEL5_MINUS = (/"bcc-csm1-1","BNU-ESM","CCSM4","CESM1-BGC","CESM1-FASTCHEM","CESM1-WACCM",\
;           "GFDL-ESM2G","MPI-ESM-LR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",
; nens5_plus = (/3,3,5,4,10,10,\
;              4,6,3,5,3,\
;              3,3,\
;              3/)

; nens5_minus = (/3,6,3,3,\
;                10,3,3,8,\
;                3/)

MODEL5_LE = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
             "IPSL-CM5A-LR", "CanESM2", "MIROC5","CESM1-CAM5","HadGEM2-ES",\
             "ACCESS1-0","ACCESS1-3","bcc-csm1-1","CESM1-FASTCHEM","FGOALS-g2",\
             "FGOALS-s2","FIO-ESM","IPSL-CM5A-MR","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M",\
             "BNU-ESM","CESM1-BGC","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
             "GFDL-ESM2G","GISS-E2-H-CC","HadGEM2-AO","HadGEM2-CC","inmcm4","IPSL-CM5A-LR",\
              "MIROC-ESM-CHEM","MPI-ESM-P","NorESM1-ME"/);"GFDL-CM3",
nens5 = (/10,10,10,8,6,6,6,\
         6,5,5,4,4,\
         3,3,3,3,3,3,3,\
         3,3,3,3,3,3,\
         1,1,1,1,1,1,\
         1,1,1,1,1,1,\
         1,2,1 /);5,

nm5 = dimsizes(MODEL5)

i5y = new(dimsizes(MODEL5_PLUS), "integer")
do i = 0,dimsizes(MODEL5_PLUS)-1
  i5y(i) = ind(MODEL5.eq.MODEL5_PLUS(i))
end do 
i5n = new(dimsizes(MODEL5_MINUS), "integer")
do i = 0,dimsizes(MODEL5_MINUS)-1
  i5n(i) = ind(MODEL5.eq.MODEL5_MINUS(i))
end do 
i5le = new(dimsizes(MODEL5_LE), "integer")
do i = 0,dimsizes(MODEL5_LE)-1
  i5le(i) = ind(MODEL5.eq.MODEL5_LE(i))
end do 

VAR = "cloudeffect" ;"cloudeffect";"tas" ; "rsds" "va" ;"psl" ; 
EXP = "historical"

nens_all = 10

diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/"

; ; note, the max lag should not be more than N/4
; rc = new((/nm5,nens_all,neof, 72,144 /), "float") 
; pc = new((/nm5,nens_all,neof,(yrl-yrs+1)*12 /), "float") 

; do im = 0,nm5-1

; ;from pdv_cmip6_hist.ncl
; ;cmip6_historical_CanESM2_r4i1p1_pdv_1850-2014.nc
; locs = systemfunc("ls "+diri+"cmip5/pdv/cmip5_historical_"+MODEL5(im)+"_*_pdv_1861-2004.nc")
; printVarSummary(locs)
; print(locs)
; nsa = dimsizes(locs)

; do ia = 0,nsa-1
  
;  locs_str = str_split(locs(ia), "_"); "/")
;  print("'" + locs_str + "'")
;   ENSN  = locs_str(3)

;   print(MODEL5(im)+" ens "+ENSN)

;     file_name = diri3+EXP+"/"+VAR+"/"+MODEL5(im)+"_"+VAR+"_"+EXP+"_"+ENSN+".nc"
;     exists = isfilepresent(file_name)
;     if(.not.exists) then
;       print(MODEL5(im)+" ens "+ENSN+" file not exist")
;       print("Either the file doesn't exist, or NCL does")
;       print("not have OPeNDAP cabilities on this system.")
;       continue
;     else
  
;     f   = addfile(file_name, "r") 
;     end if

  
; TIME2=f->time
; yyyymm2=cd_calendar(TIME2, -1)
; printMinMax(yyyymm2, True)
; ymstrts = ind(yyyymm2.eq.ymstrt)
; ymlasts = ind(yyyymm2.eq.ymlast)

;     xx  = f->ce(ymstrts:ymlasts,:,:);$VAR$

; ;;check NAN points!!!
;   if (any(ismissing(xx))) then
;     print("there is nan in col")
;     xx = where(ismissing(xx), 0.0, xx)  
;   end if

; delete([/f,TIME2,yyyymm2/]);,lat,lon
; xa = rmMonAnnCycTLL(xx)

; ;montly mean 
; xam = xa ;xa_r ;xa_r
; ; ;yearly mean 
; ; xam = month_to_annual(xa_r, 1) ;xa_r: global mean removed; xa: oringinal
; ; ndim = dimsizes(xam)
; ; xam!0 = "time"
; ; xam&time = ispan(1, ndim(0), 1)
; ; xam= dtrend_msg_n(xam&time,xam,False,False,0) ;caveat --> unable to remove global sst mean!

; ; ;-------------------------------------
; ; ; no need for aerosol, eofs over ocean and global are the same!!!
; ; ;cover land data
; ; ;mask 0=ocean (land reserved), 1=land, 2=lake, 3=small island, 4=ice shelf.

; ;  lland = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
; ;  lsm0 = landsea_mask(lland->LSMASK,xam&lat,xam&lon)
; ;  xam_sea = mask(xam,lsm0.eq.1, False)      ; mask out land points
; ;  copy_VarMeta(xam, xam_sea)

; ; delete(lsm0)

; ;------------filter----------------------
; fyr   = 8.
; ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
; sigma = 1.0                           ; Lanczos sigma
; nWgt  = toint(fyr*12*1+1) ;fyr)+1 ;                           ; odd only
; fca   = 1./(fyr*12););
; fcb   = -999.
; wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

; xam_ft = wgt_runave_n_Wrap( xam, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions 

; ;-------------EOF----------------------------------------
; optEof = False
  
; X = xam_ft(lat|:,lon|:,time|:) 
; eof    = eofunc_Wrap(X(:,:,:),neof,optEof)
; eof_ts = eofunc_ts_Wrap(X(:,:,:),eof,False)
; pcvar = eof@pcvar
; copy_VarCoords(xam(0,:,:),eof(0,:,:))
; pc(im,ia,:,:) = dim_standardize_n_Wrap(eof_ts,0,1) ;population standard
;   do i = 0,neof-1
;     rc(im,ia,i,:,:) = regCoef(pc(im,ia,i,:),xa(lat|:,lon|:,time|:))
;   end do 
;   copy_VarCoords(xa(0,:,:), rc(im,ia,0,:,:))

; delete([/locs_str,X/])


; end do 
; delete([/locs/]);,x_Lead1
; end do 
;   rc!0 = "model"
;   rc!1 = "ensemble"
;   rc!2 = "eof"

; pc!0 = "model"
; pc!1 = "ensemble"
; pc!2 = "eof"
; pc!3 = "time"
; printVarSummary(rc)
; printVarSummary(pc)
; ;--------output-------------
; fon=diri+"cmip5_"+EXP+"_eof_"+VAR+"_"+yrs+"-"+yrl+".nc";
; system("rm -f "+fon)
; fo=addfile(fon,"c")
; fo->rc = rc
; fo->pc = pc
; fo->pcvar = pcvar

; exit
;---------read output---------------
f1   = addfile(diri+"cmip5_"+EXP+"_eof_"+VAR+"_"+yrs+"-"+yrl+".nc", "r")

  rc5  = f1->rc
  pc5  = f1->pc
  pcvar5= f1->pcvar
  printVarSummary(rc5)
  printVarSummary(pc5)

f2   = addfile(diri+"cmip6_"+EXP+"_eof_"+VAR+"_1850-2014.nc", "r")

  rc6  = f2->rc
  pc6  = f2->pc
  pcvar6= f2->pcvar
  printVarSummary(rc6)
  printVarSummary(pc6)

;;----------composite-----------------
;MME
;CMIP5
com_rc5 = dim_avg_n_Wrap(rc5 , (/0,1/))
printVarSummary(com_rc5)
com_rc5_y = dim_avg_n_Wrap(rc5(i5y,:,:,:,:) , (/0,1/))
com_rc5_n = dim_avg_n_Wrap(rc5(i5n,:,:,:,:) , (/0,1/))
; com_rc_le = dim_avg_n_Wrap(rc5(i5le,:,:) , (/0,1/))

;CMIP6
com_rc6 = dim_avg_n_Wrap(rc6 , (/0,1/))

printMinMax(com_rc6, 0)

;CMIP5
com_pc5 = dim_avg_n_Wrap(pc5 , (/0,1/))
printVarSummary(com_pc5)
com_pc5_y = dim_avg_n_Wrap(pc5(i5y,:,:,:) , (/0,1/))
com_pc5_n = dim_avg_n_Wrap(pc5(i5n,:,:,:) , (/0,1/))
; com_pc_le = dim_avg_n_Wrap(pc5(i5le,:,:) , (/0,1/))

;CMIP6
com_pc6 = dim_avg_n_Wrap(pc6 , (/0,1/))

;--------------plot-------------------
wks = gsn_open_wks("ps", dirip+"cmip_eof_"+VAR);
plot = new(10,graphic)                ; create graphic array
plot1 = new(10,graphic)                ; create graphic array
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


; res2@cnLevelSelectionMode  = "ManualLevels"    
; res2@cnMinLevelValF        = -0.40
; res2@cnMaxLevelValF        =  0.40 
; res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.

do i = 0,neof-1

res2@gsnLeftString = "CMIP5 (EOF"+(i+1)+")"
mpp = dim_avg_n_Wrap(pcvar5(i), 0)
res2@gsnRightString = sprintf("%5.1f", mpp) +"%"
plot(i) = gsn_csm_contour_map_ce(wks, com_rc5(i,:,:), res2)
res2@gsnLeftString = "CMIP6 (EOF"+(i+1)+")"
mpp = dim_avg_n_Wrap(pcvar6(i), 0)
res2@gsnRightString = sprintf("%5.1f", mpp) +"%"
plot1(i) = gsn_csm_contour_map_ce(wks, com_rc6(i,:,:), res2)
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

; do ix = 0,6
;   plot1 = new(40,graphic)                ; create graphic array
;   if (ix.eq.6)then 
;     nn = 9
;   else 
;     nn = 32
;   end if 
;     do iy = 0,nn-1
;     res2@gsnLeftString = MODEL(ix*32+iy)+" "+ENS(ix*32+iy)+" (EOF"+(i+1)+")"
;     res2@gsnRightString = sprintf("%5.1f", pcvar(ix*32+iy)) +"%"
;     plot1(iy) = gsn_csm_contour_map_ce(wks, rca(ix*32+iy,:,:), res2)
;   end do 

;   resk@gsnPanelLabelBar   = True                 ; add common colorbar
;   gsn_panel(wks,plot1,(/8,4/),resk)    
; end do 

; resk@gsnPanelLabelBar   = False                 ; add common colorbar

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

 ndim5 = dimsizes(pc5)
ndim6 = dimsizes(pc6)
  x_axis5 = fspan(yrs5, yrl5+1, ndim5(3))
  x_axis6 = fspan(yrs6, yrl6+1, ndim6(3))
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
do i =0,neof-1
res@gsnRightString = "PC"+i
aa = reshape(pc5, (/ndim5(0)*ndim5(1),ndim5(2),ndim5(3)/))
plot(i+3) = gsn_csm_xy (wks,x_axis5,aa(:,i,:),res)
bb = reshape(pc6, (/ndim6(0)*ndim6(1),ndim6(2),ndim6(3)/))
plot1(i+3) = gsn_csm_xy (wks,x_axis6,bb(:,i,:),res)

res@xyLineThicknessF = 4.0
res@xyLineColor = "black"

plota = gsn_csm_xy (wks,x_axis5,com_pc5(i,:),res)
overlay(plot(i+3), plota)
plota = gsn_csm_xy (wks,x_axis6,com_pc6(i,:),res)
overlay(plot1(i+3), plota)
end do 

resk@txString = VAR+" in CMIP5"
gsn_panel(wks,plot,(/2,3/),resk)
resk@txString = VAR+" in CMIP6"
gsn_panel(wks,plot1,(/2,3/),resk)


end
