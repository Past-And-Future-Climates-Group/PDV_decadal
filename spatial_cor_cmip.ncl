begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"


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

MODEL6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
        "CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
        "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",

MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
  "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",
nens6 = (/32,30,25,12,11, 10, 10,\;10,
          10,7,5,5 /) ;ensemble number 5,

MODEL6_ESM = (/"CanESM5","CESM2","E3SM-1-0",\
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0"/)

MODEL6_CM = (/"GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MIROC6","NorCPM1" /)

i6esm = new(dimsizes(MODEL6_ESM), "integer")
do i = 0,dimsizes(MODEL6_ESM)-1
  i6esm(i) = ind(MODEL6.eq.MODEL6_ESM(i))
end do 
i6cm = new(dimsizes(MODEL6_CM), "integer")
do i = 0,dimsizes(MODEL6_CM)-1
  i6cm(i) = ind(MODEL6.eq.MODEL6_CM(i))
end do 

i6le = new(dimsizes(MODEL6_LE), "integer")
do i = 0,dimsizes(MODEL6_LE)-1
  i6le(i) = ind(MODEL6.eq.MODEL6_LE(i))
end do 

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

;;;;touch here;;;;;;;;;;;;
VARr = "cloudeffect" ; "rsuscs" ;
EXP = "historical"

VARs = "tas";"ts" ;
MODEL = MODEL5;MODEL6; 
icmip = 5;6 ; 
nens_all = 10;32 ;

yrs = 1861;1850;1930; 
yrl = 2004;2014; 
;;;;;;;;;;;;;;;;;;;;;;;;;

diri3 = "/glade/scratch/chenxing/cmip"+icmip+"/"
nm = dimsizes(MODEL)
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

; ; note, the max lag should not be more than N/4
; ccr = new((/nm, 72,144 /), "float") ;cross correlation pattern

; do im = 0,nm-1

; ;from pdv_cmip5_hist.ncl
; ;cmip5_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
; locs = systemfunc("ls "+diri3+EXP+"/"+VARs+"/"+MODEL(im)+"_"+VARs+"_historical_*.nc")
; printVarSummary(locs)
; print(locs)
; nsa = dimsizes(locs)

;   aa = new((/nens_all, 72,144 /), "float") 

; do ia = 0,nsa-1
  
;  locs_str = str_split(locs(ia), "_"); "/")
;  print("'" + locs_str + "'")
;   ENSN  = locs_str(3)

;   print(MODEL(im)+" ens "+ENSN)
;       file_name1 = diri3+EXP+"/"+VARr+"/"+MODEL(im)+"_"+VARr+"_historical_"+ENSN+".nc"
;     exists = isfilepresent(file_name1)
;   if(.not.exists) then
;     print(MODEL(im)+" ens "+ENSN+" file not exist")
;     print("Either the file doesn't exist, or NCL does")
;     print("not have OPeNDAP cabilities on this system.")
;     continue
;   else

;   fu   = addfile(file_name1, "r") 
;   end if

;   TIME2=fu->time
;   yyyymm2=cd_calendar(TIME2, -1)
;   printMinMax(yyyymm2, True)
;   ymstrts = ind(yyyymm2.eq.ymstrt)
;   ymlasts = ind(yyyymm2.eq.ymlast)
;   print(ymstrts+" <--start end--> "+ymlasts)

;     xu  = fu->ce(ymstrts:ymlasts,:,:)

;     xx = xu 
;     xx@long_name = "surface net radiant"
;     xx= dtrend_msg_n(xx&time,xx,False,False,0)
;   delete([/fu,TIME2,yyyymm2,xu/]);,lat,lon
   
;   xa = rmMonAnnCycTLL(xx)
  
; ;---------read surface temp---------------
;   f   = addfile(locs(ia), "r") 
;   TIME2=f->time
;   yyyymm2=cd_calendar(TIME2, -1)
;   printMinMax(yyyymm2, True)
;   ymstrts = ind(yyyymm2.eq.ymstrt)
;   ymlasts = ind(yyyymm2.eq.ymlast)
;   print(ymstrts+" <--start end--> "+ymlasts)
;   xs  = f->$VARs$(ymstrts:ymlasts,:,:)
;   xsa = rmMonAnnCycTLL(xs)
  
;     delete([/f,TIME2,yyyymm2,xs/]);,lat,lon

; ;------------filter----------------------
; fyr   = 8.
; ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
; sigma = 1.0                           ; Lanczos sigma
; nWgt  = toint(fyr*12*1+1); fyr)+1 ;                           ; odd only
; fca   = 1./(fyr*12)
; fcb   = -999.
; wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )
; xsa_ft = wgt_runave_n_Wrap( xsa, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions 
; xa_ft = wgt_runave_n_Wrap( xa, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions 


; ;-----------correlation-------------
; aa(ia,:,:) = escorc_n(xsa_ft, xa_ft, 0, 0) ;regCoef(pc_ft,xa(lat|:,lon|:,time|:));, tval, df);Y
; aa(ia,:,:) = aa(ia,:,:) * dim_stddev_n_Wrap(xsa_ft, 0)
; ; aa(ia,:,:) = regCoef_n(xsa_ft, xa_ft, 0, 0)

; copy_VarCoords(xa(0,:,:), aa(0,:,:))
  
; delete([/locs_str,xsa, xa,xx,xsa_ft, xa_ft/]);,pc_sea2,xa
; end do 

; ;ensemble mean
; ccr(im,:,:) = dim_avg_n_Wrap(aa, 0)

; delete([/locs/]);,x_Lead1

; end do 

; ccr!0 = "model"
; printVarSummary(ccr)

; ;--------output-------------
; fon=diri+"cmip"+icmip+"_reg_"+VARr+"_"+VARs+"_"+yrs+"-"+yrl+".nc";
; system("rm -f "+fon)
; fo=addfile(fon,"c")
; fo->ccr = ccr

; exit
;---------read output---------------

f1   = addfile(diri+"cmip5_reg_cloudeffect_tas_1861-2004.nc", "r")
r1  = f1->ccr

f2   = addfile(diri+"cmip6_reg_cloudeffect_ts_1850-2014.nc", "r")
r2  = f2->ccr

;;----------composite-----------------
;CMIP5

com_r1 = dim_avg_n_Wrap(r1 , 0)
com_r1_y = dim_avg_n_Wrap(r1(i5y,:,:) , 0)
com_r1_n = dim_avg_n_Wrap(r1(i5n,:,:) , 0)

;CMIP6
com_r2 = dim_avg_n_Wrap(r2 , 0)
com_r2_esm = dim_avg_n_Wrap(r2(i6esm,:,:) , 0)
com_r2_cm = dim_avg_n_Wrap(r2(i6cm,:,:) , 0)

printMinMax(com_r2, 0)
printVarSummary(com_r2)
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
wks = gsn_open_wks("ps", dirip+"rs_cor_cmip");
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
res2@cnMinLevelValF        = -0.4
res2@cnMaxLevelValF        =  0.4
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.


res2@gsnLeftString = ""
    res2@gsnRightString = "CMIP6"
    plot(0) = gsn_csm_contour_map_ce(wks, com_r2, res2)
    ; res2@gsnRightString = "CMIP6(ESM)"
    ; plot(2) = gsn_csm_contour_map_ce(wks, com_r2_esm, res2)
    ; res2@gsnRightString = "CMIP6(CM)"
    ; plot(4) = gsn_csm_contour_map_ce(wks, com_r2_cm, res2)
    res2@gsnRightString = "CMIP5"
    plot(1) = gsn_csm_contour_map_ce(wks, com_r1, res2)
    res2@gsnRightString = "CMIP5(plus)"
    plot(2) = gsn_csm_contour_map_ce(wks, com_r1_y, res2)
    res2@gsnRightString = "CMIP5(minus)"
    plot(3) = gsn_csm_contour_map_ce(wks, com_r1_n, res2)


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
resk@txString = "cloud effect correlation with surface temp"
gsn_panel(wks,plot,(/2,2/),resk)


end
