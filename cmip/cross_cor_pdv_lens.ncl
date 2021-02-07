begin
diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
neof = 1

dirip1 = "/glade/collections/cmip/CMIP6/CMIP/E3SM-Project/E3SM-1-0/piControl/r1i1p1f1/Amon/ts/gr/v20190719/ts/"
dirip2 = "/glade/collections/cmip/cmip5/output1/NSF-DOE-NCAR/CESM1-BGC/piControl/mon/atmos/Amon/r1i1p1/latest/ts/"
dirip4 = "/glade/collections/cmip/cmip5/output1/CSIRO-QCCCE/CSIRO-Mk3-6-0/piControl/mon/ocean/Omon/r1i1p1/v20130205/tos/"
dirip5 = "/glade/collections/cmip/cmip5/output1/NOAA-GFDL/GFDL-CM3/piControl/mon/ocean/Omon/r1i1p1/v20110601/tos/"
dirip6 = "/glade/collections/cmip/cmip5/output1/NOAA-GFDL/GFDL-ESM2M/piControl/mon/ocean/Omon/r1i1p1/v20130226/tos/"

;read obs IPO results
f0   = addfile(diri+"obs_pdv_1854-2019.nc", "r")
rco  = f0->rc
pco  = f0->pc
pcvaro  = f0->pcvar
printVarSummary(rco)

NLAT =   65; 5; 60;
SLAT =  -70;-5;-60;
WLON =  100;120;
ELON =  300;290;

VAR = "ts"; "psl" ;

diri1 = "/glade/work/chenxing/enso/E3SM/"
diri2 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/cesm_lens/Amon/"+VAR+"/"
;ts_Amon_CESM1-CAM5_historical_rcp85_r40i1p1_192001-210012.nc
diri3 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/canesm2_lens/Amon/"+VAR+"/"
;ts_Amon_CanESM2_historical_rcp85_r50i1p1_195001-210012.nc
diri4 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/csiro_mk36_lens/Amon/"+VAR+"/"
;ts_Amon_CSIRO-Mk3-6-0_historical_rcp85_r30i1p1_185001-210012.nc
diri5 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/gfdl_cm3_lens/Amon/"+VAR+"/"
;ts_Amon_GFDL-CM3_historical_rcp85_r20i1p1_192001-210012.nc
diri6 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/gfdl_esm2m_lens/Amon/"+VAR+"/"
;ts_Amon_GFDL-ESM2M_historical_rcp85_r30i1p1_195001-210012.nc
diri7 = "/gpfs/fs1/collections/cdg/data/CLIVAR_LE/mpi_lens/Amon/"+VAR+"/"
;ts_Amon_MPI-ESM_historical_rcp85_r100i1p1_185001-209912.nc


ntimes = (/2019-1854, 2011-1850, 2100-1920, 2100-1950, 2100-1850, 2100-1920, 2100-1950, 2099-1850/)+1 ;length of time
ys = (/1854, 1850, 1920, 1950, 1850, 1920, 1950, 1850/) ;start year of datasets
yl = (/2019, 2011, 2100, 2100, 2100, 2100, 2100, 2099/) ;end year of datasets
re_lat = (/ 89, 180, 192, 64, 96, 90, 90, 96/)
re_lon = (/ 180, 360, 288, 128, 192, 144, 144, 192/)
nens = (/1, 11, 40, 50, 30, 20, 30, 100 /) ;ensemble number
nens_all = 100
yr_finish = 2011

MODEL = (/"OBS", "E3SM","CESM","CanESM2", "CSIRO-Mk3-6-0","GFDL-CM3","GFDL-ESM2M","MPI-ESM" /)
nmo = dimsizes(MODEL)

SEASON = (/"DJF","MAM","JJA","SON" /)

do im = 1,nmo-1

  mxlag1 = 5*12                                    ; set lag 2yr *4 season
  mxlag2 = 20                                    ; 20 year

;;
; ; note, the max lag should not be more than N/4
; ccr1 = new((/nens_all, mxlag1, re_lat(im), re_lon(im) /), "float") ;cross correlation pattern
; ; ccr2 = new((/nens_all, 2*mxlag2+1, re_lat(im), re_lon(im) /), "float") ;cross correlation pattern

; do ia = 0,nens_all-1;dimsizes(f_input)-1 ;nens(im)-1

; ib = ia+1

; ea = sprinti("%0.2i", ib)

; ;from read_opendap_e3sm.ncl
; if (MODEL(im).eq."E3SM") then 
; f_input = systemfunc(" ls -1 "+diri1+"E3SM_en"+ea+"_"+VAR+"_185001-201112.nc") 
; else if (MODEL(im).eq."CESM") then  
; f_input = systemfunc(" ls -1 "+diri2+VAR+"_Amon_CESM1-CAM5_historical_rcp85_r"+ib+"i1p1_192001-210012.nc") 
; else if (MODEL(im).eq."CanESM2") then  
; f_input = systemfunc(" ls -1 "+diri3+VAR+"_Amon_CanESM2_historical_rcp85_r"+ib+"i1p1_195001-210012.nc") 
; else if (MODEL(im).eq."CSIRO-Mk3-6-0") then  
; f_input = systemfunc(" ls -1 "+diri4+VAR+"_Amon_CSIRO-Mk3-6-0_historical_rcp85_r"+ib+"i1p1_185001-210012.nc") 
; else if (MODEL(im).eq."GFDL-CM3") then  
; f_input = systemfunc(" ls -1 "+diri5+VAR+"_Amon_GFDL-CM3_historical_rcp85_r"+ib+"i1p1_192001-210012.nc") 
; else if (MODEL(im).eq."GFDL-ESM2M") then  
; f_input = systemfunc(" ls -1 "+diri6+VAR+"_Amon_GFDL-ESM2M_historical_rcp85_r"+ib+"i1p1_195001-210012.nc") 
; else if (MODEL(im).eq."MPI-ESM") then  
; f_input = systemfunc(" ls -1 "+diri7+VAR+"_Amon_MPI-ESM_historical_rcp85_r"+ib+"i1p1_185001-209912.nc") 
; end if 
; end if 
; end if 
; end if 
; end if 
; end if 
; end if 

;     print(f_input(0))
;   exists = isfilepresent(f_input(0))
;   if(.not.exists) then
;     print("file doesn't exist, keep on to the next cycle")
;     continue
;   end if
  

; ; do i =0,nm-1
;   f   = addfile(f_input(0), "r")

; ;only do historical part here first
; TIME2=f->time
; yyyymm2=cd_calendar(TIME2, -1)
; printMinMax(yyyymm2, True)
; ymstrts = ind(yyyymm2.eq.195001)
; ymlasts = ind(yyyymm2.eq.201112)

; if (MODEL(im).eq."E3SM") then ;some problems correctly reading time dim of E3SM
;     xx0  = f->$VAR$;(:ymlasts,:,:);
;     ymstrts = (1950-1850)*12
;     xx = xx0(ymstrts:,:,:)
;     xx@_FillValue = 1e+20
; else 
;     xx  = f->$VAR$(ymstrts:ymlasts,:,:);
; end if 
; delete([/f,TIME2,yyyymm2/]);,lat,lon
 
; xx= dtrend_msg_n(xx&time,xx,False,False,0)
; xa = rmMonAnnCycTLL(xx)

; xa_annual = month_to_annual(xa, 1)
; xa_sea = month_to_seasonN(xa, SEASON)
; ndim1 = dimsizes(xa_sea)
; xa_sea2 = reshape(xa_sea, (/ndim1(0)*ndim1(1),ndim1(2),ndim1(3) /) )
; xa_sea2!0 = "time"
; copy_VarMeta(xa(0,:,:), xa_sea2(0,:,:))
; ;---------read output---------------
; ;from lens_ipo.ncl
; f1   = addfile(diri+"lens/"+MODEL(im)+"_pdv_"+yr_finish+".nc", "r") ;pdv ;tpdv
; pc  = f1->pc(ia,0,ymstrts:)

; pc_annual = month_to_annual(pc, 1)
; pc_sea = month_to_seasonN(pc, SEASON)
; pc_sea2 = ndtooned(pc_sea)
; pc_sea2!0 = "time"
; delete([/xx,xa_sea,pc_sea /])

; ;************************************************
; ; calculate cross correlations
; ;************************************************

; ; x_Lead1 = esccr(pc,xa(lat|:,lon|:,time|:),mxlag1) ;pc lead
; y_Lead1 = esccr(xa(lat|:,lon|:,time|:),pc,mxlag1) ;pc lag
; y_Lead1!0 = "lat"
; y_Lead1!1 = "lon"
; y_Lead1!2 = "time"
; ; copy_VarMeta(x_Lead1, y_Lead1)

; ccr1(ia,:,:,:) = y_Lead1(time|1:mxlag1:-1,lat|:,lon|:)  ; "negative lag", -1 reverses order
; ; ccr1(ia,mxlag1:,:,:)    = x_Lead1(time|0:mxlag1,lat|:,lon|:)     ; "positive lag"


; ; x_Lead2 = esccr(pc_annual,xa_annual(lat|:,lon|:,year|:),mxlag2) ;pc lead
; ; y_Lead2 = esccr(xa_annual(lat|:,lon|:,year|:),pc_annual,mxlag2) ;pc lag
; ; x_Lead2!0 = "lat"
; ; x_Lead2!1 = "lon"
; ; x_Lead2!2 = "year"
; ; copy_VarMeta(x_Lead2, y_Lead2)

; ; ccr2(ia,0:mxlag2-1,:,:) = y_Lead2(year|1:mxlag2:-1,lat|:,lon|:)  ; "negative lag", -1 reverses order
; ; ccr2(ia,mxlag2:,:,:)    = x_Lead2(year|0:mxlag2,lat|:,lon|:)     ; "positive lag"

; end do 
; print("MODEL "+MODEL(im)+" is done")

; copy_VarCoords(xa(0,:,:), ccr1(0,0,:,:))
; ; copy_VarCoords(xa_annual(0,:,:), ccr2(0,0,:,:))
; ccr1!0 = "ensemble"
; ; ccr2!0 = "ensemble"
; printVarSummary(ccr1)
; ; printVarSummary(ccr2)

; delete([/pc,xa,pc_sea2,xa_sea2,pc_annual,xa_annual,y_Lead1 /]);,x_Lead1,y_Lead2,x_Lead2 /])

; ;--------output-------------
; fon=diri+"lens/"+MODEL(im)+"_cross_cor_pdv_"+VAR+"_1950-2011.nc";
; system("rm -f "+fon)
; fo=addfile(fon,"c")
; fo->ccr1 = ccr1
; ; fo->ccr2 = ccr2


;---------read output---------------
f1   = addfile(diri+"lens/"+MODEL(im)+"_cross_cor_pdv_"+VAR+"_1950-2011.nc", "r")
ccr1  = f1->ccr1
; ccr2  = f1->ccr2

;;----------composite-----------------

com_ccr = dim_avg_n_Wrap(ccr1, 0)
; com_ccr_annual = dim_avg_n_Wrap(ccr2, 0)
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
wks = gsn_open_wks("ps", dirip+MODEL(im)+"_pdv_cross_cor_"+VAR);
; wks2 = gsn_open_wks("ps", dirip+"obs_pdv_cross_cor_"+VAR);
plot = new(30,graphic)                ; create graphic array
plot2 = new(30,graphic)                ; create graphic array
plot1 = new(30,graphic)                ; create graphic array
gsn_define_colormap(wks, "NCV_blu_red")
; gsn_define_colormap(wks2, "NCV_blu_red")


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


res2@gsnLeftString = "PDV"
do iy = 0,5;12
  iy1 = -5*12+iy*10
    res2@gsnRightString = "lead "+iy1+" month"
    plot((iy)) = gsn_csm_contour_map_ce(wks, com_ccr((iy1+mxlag1),:,:), res2)
end do 

; do iy = -10,9
;   iy1 = iy*2
;     res2@gsnRightString = "lead "+iy1+" year"
;     plot1((iy+10)) = gsn_csm_contour_map_ce(wks, com_ccr_annual(iy1+mxlag2,:,:), res2)
; end do 

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
resk@txString = " PDV cross correlation during 1950-2011 in "+MODEL(im)
gsn_panel(wks,plot,(/3,2/),resk)
; resk@txString = MODEL(im)+" annual mean"
; gsn_panel(wks,plot1,(/8,3/),resk)
; resk@txString = "ERSSTv5"
; gsn_panel(wks2,plot1,(/2,2/),resk)    
delete( res2)

delete([/ccr1, com_ccr/]);ccr2,com_ccr_annual
end do 
end
