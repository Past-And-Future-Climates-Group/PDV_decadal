begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
neof = 1

  yrs = 1850
  yrl = 2014
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

diri1 = "/glade/collections/cmip/cmip6/"
diri2 = "/glade/work/chenxing/CMIP6/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip6/"
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

MODEL6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
        "CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
        "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",

MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
  "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",
nens6 = (/32,30,25,12,11, 10, 10,\;10,
          10,7,5,5 /) ;ensemble number 5,

i6le = new(dimsizes(MODEL6_LE), "integer")
do i = 0,dimsizes(MODEL6_LE)-1
  i6le(i) = ind(MODEL6.eq.MODEL6_LE(i))
end do 

nm6 = dimsizes(MODEL6)
nens_all = 32


VAR = "va" ;"ts" ;"psl" ; 
EXP = "historical"


; note, the max lag should not be more than N/4
mclm = new((/nm6, yrl-yrs+1, 72,144 /), "float") ;cross correlation pattern

do im = 0,nm6-1

;from pdv_cmip6_hist.ncl
;cmip6_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
locs = systemfunc("ls "+diri+"cmip6/pdv/cmip6_historical_"+MODEL6(im)+"_*_pdv_1850-2014.nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

  xa_annual = new((/nens_all, yrl-yrs+1, 72,144 /), "float") 

do ia = 0,nsa-1
  
 locs_str = str_split(locs(ia), "_"); "/")
 print("'" + locs_str + "'")
  ENSN  = locs_str(3)

  print(MODEL6(im)+" ens "+ENSN)

    file_name = diri3+EXP+"/"+VAR+"/"+MODEL6(im)+"_"+VAR+"_historical_"+ENSN+".nc"
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
  print(ymstrts+" <--start end--> "+ymlasts)

    xx  = f->$VAR$(ymstrts:ymlasts,{85000},:,:); :,:);

  delete([/f,TIME2,yyyymm2/]);,lat,lon
   
  xa = rmMonAnnCycTLL(xx)
  
  xa_annual(ia,:,:,:) = month_to_annual(xa, 1)
  delete([/xx /])
  
copy_VarCoords(xa(0,:,:), xa_annual(0,0,:,:))
  
delete([/xa,locs_str/])
end do 

;ensemble mean
mclm(im,:,:,:) = dim_avg_n_Wrap(xa_annual, 0)

delete([/locs/])

end do 
mclm!0 = "model"
mclm!1 = "year"
printVarSummary(mclm)

;--------output-------------
fon=diri+"cmip6_annual_EnsMean_"+VAR+"_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->mclm = mclm

exit
;---------read output---------------
f1   = addfile(diri+"cmip6_annual_EnsMean_"+yrs+"-"+yrl+".nc", "r")
mclm  = f1->mclm

;;----------composite-----------------
;MME
ys1 = yrs
ys2 = 1950
ys3 = 1980
yl1 = 1950
yl2 = 1980
yl3 = yrl
com_1 = dim_avg_n_Wrap(mclm(:,ys1-yrs:yl1-yrs,:,:) , (/0,1/))
com_2 = dim_avg_n_Wrap(mclm(:,ys2-yrs:yl2-yrs,:,:) , (/0,1/))
com_3 = dim_avg_n_Wrap(mclm(:,ys3-yrs:yl3-yrs,:,:) , (/0,1/))
printVarSummary(com_3)

printMinMax(com_3, 0)
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
wks = gsn_open_wks("ps", dirip+"cmip6_clm");
plot = new(30,graphic)                ; create graphic array
plot2 = new(30,graphic)                ; create graphic array
plot1 = new(30,graphic)                ; create graphic array
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
res2@cnMinLevelValF        = -0.5
res2@cnMaxLevelValF        =  0.5 
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.


res2@gsnLeftString = ""
    res2@gsnRightString = ys1+"-"+yl1
    plot(0) = gsn_csm_contour_map_ce(wks, com_1 , res2)
    res2@gsnRightString = ys2+"-"+yl2
    plot(1) = gsn_csm_contour_map_ce(wks, com_2 , res2)
    res2@gsnRightString = ys3+"-"+yl3
    plot(2) = gsn_csm_contour_map_ce(wks, com_3 , res2)


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
resk@txString = "mean state anomalies in CMIP6"
gsn_panel(wks,plot,(/3,1/),resk)


end