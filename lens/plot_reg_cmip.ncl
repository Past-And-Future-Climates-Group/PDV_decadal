begin
diri5 = "/glade/work/chenxing/enso/lens5/"
diri6 = "/glade/work/chenxing/enso/lens6/"
dirip = "/glade/u/home/chenxing/enso/"

diri1 = "/glade/collections/cmip/cmip5/"
diri2 = "/glade/work/chenxing/CMIP5/historical/remap/tos/"
;from cdo_cmip_data.ncl
diri3 = "/glade/scratch/chenxing/cmip5/"
SEASON = (/"DJF(-1)","MAM(-1)","JJA(-1)","SON(-1)","DJF(0)" /)


EXP  = "historical"
IND  = "PDI" ;"nino34";
LEV  = "850";"200" ;
VAR  = "ts" ; "zg300" ;"ts" ;"psl" "ts"
LR =  "reg" ;"regLag" ;

yrs = (/1950,1991/)
yrl = (/1990,2014/)

MODEL5 = (/"CESM1-CAM5","CanESM2","CSIRO-Mk3-6-0",\;"EC-EARTH",
  "GFDL-CM3","GFDL-ESM2M","MPI-ESM" /)

MODEL6 = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
    "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR"/);,"MRI-ESM2-0","E3SM-1-0" /) ;large ensemble model in CMIP6 "NESM3",

MODEL = MODEL5
diri = diri5

nm = dimsizes(MODEL)

wks = gsn_open_wks("png", dirip+"reg_cmip");
plot = new(30,graphic)                ; create graphic array
plot1 = new(30,graphic)                ; create graphic array
plot2 = new(30,graphic)                ; create graphic array
plot3 = new(30,graphic)                ; create graphic array

do im = 0,nm-1
do i = 0,dimsizes(yrs)-1
;---------read output---------------
; from reg_cmip5.ncl reg_cmip6.ncl
;CESM1-CAM5_r6i1p1_reg_PDI_historical_ts_1920-2014.nc
fils = systemfunc("ls "+diri+MODEL(im)+"_*_"+LR+"_"+IND+"_historical_"+VAR+"_"+yrs(i)+"-"+yrl(i)+".nc");
; print(fils)
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
t1 = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])

if (MODEL(im).ne."GFDL-ESM2M") then
fils = systemfunc("ls "+diri+MODEL(im)+"_*_"+LR+"_"+IND+"_historical_ua"+LEV+"_"+yrs(i)+"-"+yrl(i)+".nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
u1 = dim_avg_n_Wrap(f1[:]->rc ,0)

fils = systemfunc("ls "+diri+MODEL(im)+"_*_"+LR+"_"+IND+"_historical_va"+LEV+"_"+yrs(i)+"-"+yrl(i)+".nc");
f1   = addfiles(fils, "r")
ListSetType (f1, "join")
v1 = dim_avg_n_Wrap(f1[:]->rc ,0)
delete([/fils,f1/])

printMinMax(u1,0)
printMinMax(v1,0)
end if

printMinMax(t1,0)


if (i.eq.0) then

  ; period difference P2-P1
  dt1 = t1
  if (MODEL(im).ne."GFDL-ESM2M") then
    du1 = u1
    dv1 = v1
  end if

else

  ; period difference P2-P1 for each of them
  dt1 = t1 - dt1
  if (MODEL(im).ne."GFDL-ESM2M") then
    du1 = u1 - du1
    dv1 = v1 - dv1
  end if

end if

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
gsn_define_colormap(wks, "NCV_blu_red")


res2 = True
res2@gsnDraw = False        ;dont draw
res2@gsnFrame = False        ;dont advance frame
res2@gsnLeftString = ""
res2@gsnRightString = ""
res2@vpWidthF  = 0.6

vcres = res2

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

res2@gsnLeftStringFontHeightF = 0.02
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
res2@cnMinLevelValF        = -0.6;15.;0.6;0.6;120
res2@cnMaxLevelValF        =  0.6;15.;0.6;0.6;120
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.

; vcres@vcGlyphStyle            = "Fillarrow"    ; turn on curly vectors
vcres@vcMinFracLengthF        = 0.2
vcres@vcMinDistanceF          = 0.02
vcres@vcRefMagnitudeF         = 1.0;2.0 ;             ; define vector ref mag
vcres@vcRefLengthF            = 0.04             ; define length of vec ref

vcres@vcRefAnnoOn             = True
vcres@vcRefAnnoPerimOn          = False          ;参考矢量的边框
vcres@vcRefAnnoString2          = "m/s"            ;not draw the word"reference vector"
vcres@vcRefAnnoOrthogonalPosF = -.15            ; move ref vector up


vcres@lbLabelBarOn = False
vcres@vcFillArrowFillColor = "black"

res2@gsnLeftString = yrs(i)+"-"+yrl(i)
    res2@gsnRightString = MODEL(im)
    plot(im*3+i) = gsn_csm_contour_map_ce(wks, t1, res2)


if (i.eq.1) then

  res2@gsnLeftString = "P2 - P1"
    res2@gsnRightString = MODEL(im)
    plot(im*3+2) = gsn_csm_contour_map_ce(wks, dt1, res2)


end if

if (MODEL(im).ne."GFDL-ESM2M") then
  vector= gsn_csm_vector(wks,u1,v1,vcres)
  overlay(plot(im*3+i),vector)
  if (i.eq.1) then
    vector= gsn_csm_vector(wks,du1,dv1,vcres)
    overlay(plot(im*3+2),vector)
  end if
  delete([/u1,v1/])

end if
  delete([/res2,vcres/])
end do
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
resk@txString = " regression onto "+IND
gsn_panel(wks,plot,(/nm,3/),resk)


end
