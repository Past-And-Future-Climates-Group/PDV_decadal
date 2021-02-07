begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

  yrs = 1861;1950;
  yrl = 2004
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/"
SEASON = (/"DJF","MAM","JJA","SON" /)

MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;"bcc-csm1-1-m",
      "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
      "GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
      "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\;"MRI-ESM1",
      "NorESM1-ME","NorESM1-M"/)

M5_YES = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","HadGEM2-CC",\;,"GFDL-CM3"
          "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM-CHEM","MIROC-ESM",\
          "MRI-CGCM3","NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

M5_NO = (/"bcc-csm1-1","BNU-ESM","CCSM4","CESM1-BGC","CESM1-FASTCHEM","CESM1-WACCM",\
          "GFDL-ESM2G","MPI-ESM-LR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

MODEL5_LE = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
             "IPSL-CM5A-LR", "CanESM2", "MIROC5"/);"GFDL-CM3",
nens5 = (/10,10,10,8,6,6,6,\
         6,5,5 /);5,

nm5 = dimsizes(MODEL5)

i5y = new(dimsizes(M5_YES), "integer")
do i = 0,dimsizes(M5_YES)-1
  i5y(i) = ind(MODEL5.eq.M5_YES(i))
end do 
i5n = new(dimsizes(M5_NO), "integer")
do i = 0,dimsizes(M5_NO)-1
  i5n(i) = ind(MODEL5.eq.M5_NO(i))
end do 
i5le = new(dimsizes(MODEL5_LE), "integer")
do i = 0,dimsizes(MODEL5_LE)-1
  i5le(i) = ind(MODEL5.eq.MODEL5_LE(i))
end do 

VAR = "tas" ;"psl" ; 
EXP = "historical"
IND = "pdv"; "AR1Di" ;"AR1varm"; "TNA"; "pdv"

nens_all = 10
  mxlag1 = 5*12                                    ; set lag 2yr *4 season
  mxlag2 = 20                                    ; 20 year

; ; note, the max lag should not be more than N/4
; ccr1 = new((/nm5, mxlag1, 72,144 /), "float") ;cross correlation pattern

; do im = 0,nm5-1

; ;from pdv_cmip5_hist.ncl
; ;cmip5_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
; locs = systemfunc("ls "+diri+"cmip5/pdv/cmip5_historical_"+MODEL5(im)+"_*_pdv_*.nc")
; printVarSummary(locs)
; print(locs)
; nsa = dimsizes(locs)

;   aa = new((/nens_all, mxlag1, 72,144 /), "float") 

; do ia = 0,nsa-1
  
;  locs_str = str_split(locs(ia), "_"); "/")
;  print("'" + locs_str + "'")
;   ENSN  = locs_str(3)

;   print(MODEL5(im)+" ens "+ENSN)

;     exists = isfilepresent(diri3+EXP+"/"+VAR+"/"+MODEL5(im)+"_"+VAR+"_"+EXP+"_"+ENSN+".nc")
;     exists2 = isfilepresent(diri+"cmip5/"+IND+"/cmip5_"+EXP+"_"+MODEL5(im)+"_"+ENSN+"_"+IND+"_1861-2004.nc")
;   if(.not.exists.or..not.exists2) then
;     print(MODEL5(im)+" ens "+ENSN+" file not exist")
;     print("Either the file doesn't exist, or NCL does")
;     print("not have OPeNDAP cabilities on this system.")
;     continue
;   else

;   f   = addfile(diri3+EXP+"/"+VAR+"/"+MODEL5(im)+"_"+VAR+"_"+EXP+"_"+ENSN+".nc", "r") 
;   end if

;   TIME2=f->time
;   yyyymm2=cd_calendar(TIME2, -1)
;   printMinMax(yyyymm2, True)
;   ymstrts = ind(yyyymm2.eq.ymstrt)
;   ymlasts = ind(yyyymm2.eq.ymlast)
;   print(ymstrts+" <--start end--> "+ymlasts)

;     xx  = f->$VAR$(ymstrts:ymlasts,:,:);

;   delete([/f,TIME2,yyyymm2/]);,lat,lon
   
;   xa = rmMonAnnCycTLL(xx)
  
;   xa_annual = month_to_annual(xa, 1)
;   xa_sea = month_to_seasonN(xa, SEASON)
;   ;season, year --> season * year one dimension
;   ndim1 = dimsizes(xa_sea)
;   xa_sea2 = reshape(xa_sea, (/ndim1(0)*ndim1(1),ndim1(2),ndim1(3) /) )
;   xa_sea2!0 = "time"
;   copy_VarMeta(xa(0,:,:), xa_sea2(0,:,:))

;   ;---------read output---------------
  
;   ; ;PDV
;   ; ; from pdv_cmip5_hist.ncl
;   ; f1   = addfile(diri+"cmip5/pdv/cmip5_"+EXP+"_"+MODEL5(im)+"_"+ENSN+"_pdv_1861-2004.nc", "r") 

;   ;;some index
;   ;from cmip_index.ncl
;   f1   = addfile(diri+"cmip5/"+IND+"/cmip5_"+EXP+"_"+MODEL5(im)+"_"+ENSN+"_"+IND+"_1861-2004.nc", "r") 
;   pc  = tofloat(f1->index((yrs-1861)*12:)) ;AR1
;   ; pc  = f1->pc(0,(yrs-1861)*12:) ;pdv
;   ; pc  = f1->gmst((yrs-1861)*12:) ;TNA

;   ; pc  = dtrend(pc, 0)
  
;   pc_annual = month_to_annual(pc, 1)
;   ; pc_sea = month_to_seasonN(pc, SEASON)
;   ; pc_sea2 = ndtooned(pc_sea)
;   ; pc_sea2!0 = "time"
  
;   ;------------filter----------------------
;   fyr   = 8.
;   ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
;   sigma = 1.0                           ; Lanczos sigma
;   nWgt  = toint(fyr*12*2+1); fyr)+1 ;                           ; odd only
;   fca   = 1./(fyr*12)
;   fcb   = -999.
;   wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )
;   pc_ft = wgt_runave_n_Wrap( pc, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions 


;   ;************************************************
;   ; calculate cross correlations
;   ;************************************************

;   ; x_Lead1 = esccr(pc,xa(lat|:,lon|:,time|:),mxlag1) ;pc lead
;   y_Lead1 = esccr(xa(lat|:,lon|:,time|:),pc_ft,mxlag1) ;pc lag
;   y_Lead1!0 = "lat"
;   y_Lead1!1 = "lon"
;   y_Lead1!2 = "time"
;   ; copy_VarMeta(x_Lead1, y_Lead1)
  
;   aa(ia,:,:,:) = y_Lead1(time|1:mxlag1:-1,lat|:,lon|:)  ; "negative lag", -1 reverses order
;   ; aa(ia,mxlag1:,:,:)    = x_Lead1(time|0:mxlag1,lat|:,lon|:)     ; "positive lag"

  
; delete([/xx,locs_str,pc,xa_sea2,y_Lead1,xa_sea/]);,xa,pc_sea2,pc_sea
; end do 

; ;ensemble mean
; ccr1(im,:,:,:) = dim_avg_n_Wrap(aa, 0)

; delete([/locs/]);,x_Lead1

; end do 

; copy_VarCoords(xa(0,:,:), ccr1(0,0,:,:))
; ccr1!0 = "model"
; ccr1!1 = "time"
; printVarSummary(ccr1)

; ;--------output-------------
; fon=diri+"cmip5_cross_cor_"+IND+"_"+EXP+"_"+VAR+"_"+yrs+"-"+yrl+".nc";
; system("rm -f "+fon)
; fo=addfile(fon,"c")
; fo->ccr1 = ccr1

; exit
;---------read output---------------
f1   = addfile(diri+"cmip5_cross_cor_"+IND+"_"+EXP+"_"+VAR+"_"+yrs+"-"+yrl+".nc", "r")
ccr1  = f1->ccr1

f12   = addfile(diri+"cmip6_cross_cor_"+IND+"_"+EXP+"_ts_1850-2014.nc", "r")
ccr2  = f12->ccr1

;;----------composite-----------------
;MME
com_ccr = dim_avg_n_Wrap(ccr1 , 0)
com_ccr6 = dim_avg_n_Wrap(ccr2 , 0)
printVarSummary(com_ccr)
com_ccr_y = dim_avg_n_Wrap(ccr1(i5y,:,:,:) , 0)
com_ccr_n = dim_avg_n_Wrap(ccr1(i5n,:,:,:) , 0)
com_ccr_le = dim_avg_n_Wrap(ccr1(i5le,:,:,:) , 0)

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
wks = gsn_open_wks("ps", dirip+"cmip_PDV_cross_cor");
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
res2@lbTitleString    = "K"                ; title string
res2@lbTitlePosition  = "Right"              ; title position
res2@lbTitleFontHeightF= .015                ; make title smaller
; res2@lbTitleDirection = "Across"             
res2@lbTitleExtentF   = 0.01 ;Default: 0.15
res2@lbLabelFontHeightF = 0.01  ;Default: 0.02
; res2@pmLabelBarWidthF = 0.05

res2@cnLevelSelectionMode  = "ManualLevels"    
res2@cnMinLevelValF        = -0.3
res2@cnMaxLevelValF        =  0.3
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.


res2@gsnLeftString = ""
do iy = 0,11
  iy1 = -5*12+iy*5
    res2@gsnRightString = "lead "+iy1+" month"
    plot((iy)) = gsn_csm_contour_map_ce(wks, com_ccr((iy1+mxlag1),:,:), res2)
    plot1((iy)) = gsn_csm_contour_map_ce(wks, com_ccr_y((iy1+mxlag1),:,:), res2)
    plot2((iy)) = gsn_csm_contour_map_ce(wks, com_ccr_n((iy1+mxlag1),:,:), res2)
    plot3((iy)) = gsn_csm_contour_map_ce(wks, com_ccr6((iy1+mxlag1),:,:), res2)
end do 


resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = True                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@lbBoxEndCapStyle = "TriangleBothEnds"
resk@lbOrientation = "Horizontal"
resk@lbBoxLinesOn = False
;resk@lbBoxMinorExtentF = 0.2
resk@lbLabelFontHeightF = 0.01  ;Default: 0.02
;resk@pmLabelBarWidthF = 0.1
;resk@pmLabelBarHeightF = 0.2
;resk@pmLabelBarParallelPosF = 0.3 ;default 0.5
;resk@pmLabelBarOrthogonalPosF = 0.005 ;default 0.02
resk@txString = IND+" cross correlation changes "+yrs+"-"+yrl+": CMIP5"
gsn_panel(wks,plot,(/6,2/),resk)
resk@txString = IND+" cross correlation changes "+yrs+"-"+yrl+": CMIP5(plus)"
gsn_panel(wks,plot1,(/6,2/),resk)
resk@txString = IND+" cross correlation changes "+yrs+"-"+yrl+": CMIP5(minus)"
gsn_panel(wks,plot2,(/6,2/),resk)
resk@txString = IND+" cross correlation changes "+yrs+"-"+yrl+": CMIP6"
gsn_panel(wks,plot3,(/6,2/),resk)


end
