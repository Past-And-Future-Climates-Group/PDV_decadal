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

  fref = systemfunc("ls "+diri+"cmip5/tos.pdv/cmip5_historical_ACCESS1-0_r1i1p1_pdv_1861-2004.nc")
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

  yrs = 1861;1950;
  yrl = 2004
  ymstrt= yrs*100+1
  ymlast= yrl*100+12

diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/"
SEASON = (/"DJF","MAM","JJA","SON" /)



diri1 = "/glade/work/chenxing/enso/E3SM/"
diri2 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/"
SEASON = (/"DJF","MAM","JJA","SON" /)

MODEL_LOCS = (/"cesm_lens","canesm2_lens","csiro_mk36_lens",\;"ec_earth_lens",
  "gfdl_cm3_lens","gfdl_esm2m_lens","mpi_lens" /)
MODEL_NAME = (/"CESM1-CAM5","CanESM2","CSIRO-Mk3-6-0",\;"EC-EARTH",
  "GFDL-CM3","GFDL-ESM2M","MPI-ESM" /)

nm = dimsizes(MODEL_LOCS)

VAR = "ts" ;"od550aer" ;"cloudeffect";"tas" ; "rsds" "va" ;"psl" ;
EXP = "historical"
IND = "PDI2" ;"mmeeof2" ;"mmeeof1" ;"GMAOD" ;"PDI2" ;"PDI"; "AR1Di" ;"SLPAL" ;"pdv";"TNA"; "AR1varm"; "TNA";
AA =  ""

nens_all = 10

;from reg_pdi_lens5.ncl


;---------read output---------------
f1   = addfile(diri+"cmip5_reg_all_PDI2_historical_tas_1861-2004.nc", "r")
ccr1  = f1->ccr1

f2   = addfile(diri+"cmip6_reg_all_PDI2_historical_ts_1850-2014.nc", "r")
ccr2  = f2->ccr1


f1   = addfile(diri+"cmip5_reg_mmemmeeof2_historical_tas_1861-2004.nc", "r")
mcr1  = f1->ccr1

f2   = addfile(diri+"cmip6_reg_mmemmeeof2_historical_ts_1850-2014.nc", "r")
mcr2  = f2->ccr1

printVarSummary(ccr1)
printVarSummary(mcr1)
printVarSummary(mcr2)
;;----------composite-----------------
;MME
com_ccr = dim_avg_n_Wrap(ccr1 , 0)
printVarSummary(com_ccr)
com_ccr_y = dim_avg_n_Wrap(ccr1(i5y,:,:) , 0)
com_ccr_n = dim_avg_n_Wrap(ccr1(i5n,:,:) , 0)
com_mcr = dim_avg_n_Wrap(mcr1 , 0)
printVarSummary(com_mcr)
com_mcr_y = dim_avg_n_Wrap(mcr1(i5y,:,:) , 0)
com_mcr_n = dim_avg_n_Wrap(mcr1(i5n,:,:) , 0)

;CMIP6
com_ccr6 = dim_avg_n_Wrap(ccr2 , 0)
com_mcr6 = dim_avg_n_Wrap(mcr2 , 0)

printMinMax(com_ccr, 0)
printMinMax(com_mcr, 0)
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
wks = gsn_open_wks("ps", dirip+"fig2_pdi_reg");
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
res2@cnMinLevelValF        = -0.5
res2@cnMaxLevelValF        =  0.5
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.


    res2@gsnLeftString = "internal variability"
    res2@gsnRightString = "CMIP5"
    plot(0) = gsn_csm_contour_map_ce(wks, com_ccr, res2)
    res2@gsnRightString = "CMIP6"
    plot(1) = gsn_csm_contour_map_ce(wks, com_ccr6, res2)
    res2@gsnLeftString = "external response"
    res2@gsnRightString = "CMIP5"
    plot1(0) = gsn_csm_contour_map_ce(wks, com_mcr, res2)
    res2@gsnRightString = "CMIP6"
    plot1(1) = gsn_csm_contour_map_ce(wks, com_mcr6, res2)


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
; resk@txString = VAR+" regressed onto "+IND+" "+yrs+"-"+yrl
gsn_panel(wks,plot,(/1,2/),resk)
gsn_panel(wks,plot1,(/1,2/),resk)
; gsn_panel(wks,plot,(/2,1/),resk)
; gsn_panel(wks,plot1,(/2,1/),resk)


end
