begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
neof = 1

  yrs = 1950
  yrl = 2014
  ymstrt= yrs*100+1  
  ymlast= yrl*100+12

diri1 = "/glade/collections/cmip/cmip6/"
diri2 = "/glade/work/chenxing/CMIP6/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip6/psl/"
SEASON = (/"DJF","MAM","JJA","SON" /)

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

  mxlag1 = 5*12                                    ; set lag 2yr *4 season

; note, the max lag should not be more than N/4
ccr1 = new((/nm6, mxlag1, 72,144 /), "float") ;cross correlation pattern

do im = 17,20; 0,nm6-1

;from pdv_cmip6_hist.ncl
;cmip6_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
locs = systemfunc("ls "+diri+"cmip6/ts.pdv/cmip6_historical_"+MODEL6(im)+"_*_pdv_*.nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

  aa = new((/nens_all, mxlag1, 72,144 /), "float") 

do ia = 0,nsa-1
  
 locs_str = str_split(locs(ia), "_"); "/")
 print("'" + locs_str + "'")
  ENSN  = locs_str(3)

  print(MODEL6(im)+" ens "+ENSN)

  exists = isfilepresent(diri3+MODEL6(im)+"_psl_historical_"+ENSN+".nc")
  if(.not.exists) then
    print(MODEL6(im)+" ens "+ENSN+" file not exist")
    print("Either the file doesn't exist, or NCL does")
    print("not have OPeNDAP cabilities on this system.")
    continue
  else

  f   = addfile(diri3+MODEL6(im)+"_psl_historical_"+ENSN+".nc", "r") 
  end if

  TIME2=f->time
  yyyymm2=cd_calendar(TIME2, -1)
  printMinMax(yyyymm2, True)
  ymstrts = ind(yyyymm2.eq.ymstrt)
  ymlasts = ind(yyyymm2.eq.ymlast)
  print(ymstrts+" <--start end--> "+ymlasts)

    xx  = f->psl(ymstrts:ymlasts,:,:);

  delete([/f,TIME2,yyyymm2/]);,lat,lon

  xa = rmMonAnnCycTLL(xx)
  
  xa_annual = month_to_annual(xa, 1)
  xa_sea = month_to_seasonN(xa, SEASON)
  ;season, year --> season * year one dimension
  ndim1 = dimsizes(xa_sea)
  xa_sea2 = reshape(xa_sea, (/ndim1(0)*ndim1(1),ndim1(2),ndim1(3) /) )
  xa_sea2!0 = "time"
  copy_VarMeta(xa(0,:,:), xa_sea2(0,:,:))

  ;---------read output---------------
  ;from pdv_cmip6_hist.ncl
  f1   = addfile(diri+"cmip6/ts.pdv/cmip6_historical_"+MODEL6(im)+"_"+ENSN+"_pdv_1850-2014.nc", "r") 
  pc  = f1->pc(0,(yrs-1850)*12:(yrl+1-1850)*12-1)
  
  pc_annual = month_to_annual(pc, 1)
  pc_sea = month_to_seasonN(pc, SEASON)
  pc_sea2 = ndtooned(pc_sea)
  pc_sea2!0 = "time"
  delete([/xx,xa_sea,pc_sea /])
  
  ;************************************************
  ; calculate cross correlations
  ;************************************************

  ; x_Lead1 = esccr(pc,xa(lat|:,lon|:,time|:),mxlag1) ;pc lead
  y_Lead1 = esccr(xa(lat|:,lon|:,time|:),pc,mxlag1) ;pc lag
  y_Lead1!0 = "lat"
  y_Lead1!1 = "lon"
  y_Lead1!2 = "time"
  ; copy_VarMeta(x_Lead1, y_Lead1)
  
  aa(ia,:,:,:) = y_Lead1(time|1:mxlag1:-1,lat|:,lon|:)  ; "negative lag", -1 reverses order
  ; aa(ia,mxlag1:,:,:)    = x_Lead1(time|0:mxlag1,lat|:,lon|:)     ; "positive lag"
  
delete([/locs_str,pc,pc_sea2,xa_sea2,y_Lead1/]);,xa
end do 

;ensemble mean
ccr1(im,:,:,:) = dim_avg_n_Wrap(aa, 0)

delete([/locs/]);,x_Lead1

end do 
copy_VarCoords(xa(0,:,:), ccr1(0,0,:,:))
ccr1!0 = "model"
ccr1!1 = "time"
printVarSummary(ccr1)

;--------output-------------
fon=diri+"cmip6_cross_cor_pdv_psl_"+yrs+"-"+yrl+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->ccr1 = ccr1


;---------read output---------------
f1   = addfile(diri+"cmip6_cross_cor_pdv_psl_"+yrs+"-"+yrl+".nc", "r")
ccr1  = f1->ccr1

;;----------composite-----------------
;MME
com_ccr = dim_avg_n_Wrap(ccr1, 0)
printVarSummary(com_ccr)

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
wks = gsn_open_wks("ps", dirip+"cmip6_pdv_cross_cor");
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
res2@cnMinLevelValF        = -0.1
res2@cnMaxLevelValF        =  0.1 
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.


res2@gsnLeftString = ""
do iy = 0,12
  iy1 = -5*12+iy*2
    res2@gsnRightString = "lead "+iy1+" month"
    plot((iy)) = gsn_csm_contour_map_ce(wks, com_ccr((iy1+mxlag1),:,:), res2)
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
resk@txString = "PDV cross correlation changes "+yrs+"-"+yrl+": CMIP6"
gsn_panel(wks,plot,(/6,2/),resk)


end
