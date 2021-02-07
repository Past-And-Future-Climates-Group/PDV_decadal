begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"
neof = 1

;read obs IPO results
;from obs_ipo.ncl
f0   = addfile(diri+"obs_pdv_1854-2019.nc", "r")
rco  = f0->rc
pco  = f0->pc
pcvaro  = f0->pcvar
printVarSummary(rco)

f0   = addfile(diri+"obs_tpdv_1854-2019.nc", "r")
trco  = f0->rc
tpco  = f0->pc
tpcvaro  = f0->pcvar
printVarSummary(trco)

;;;
cor1 = escorc(ndtooned(pco), ndtooned(tpco))
print("correlation between PDV and TPDV is "+cor1)


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

nm5 = dimsizes(MODEL5)
nm6 = dimsizes(MODEL6)

i5y = new(dimsizes(M5_YES), "integer")
do i = 0,dimsizes(M5_YES)-1
  i5y(i) = ind(MODEL5.eq.M5_YES(i))
end do 
i5n = new(dimsizes(M5_NO), "integer")
do i = 0,dimsizes(M5_NO)-1
  i5n(i) = ind(MODEL5.eq.M5_NO(i))
end do 
print("say yes "+i5y)
print("say no "+i5n)
i5le = new(dimsizes(MODEL5_LE), "integer")
do i = 0,dimsizes(MODEL5_LE)-1
  i5le(i) = ind(MODEL5.eq.MODEL5_LE(i))
end do 
i6le = new(dimsizes(MODEL6_LE), "integer")
do i = 0,dimsizes(MODEL6_LE)-1
  i6le(i) = ind(MODEL6.eq.MODEL6_LE(i))
end do 

yrs5 = 1861
yrl5 = 2004
nyr5 = yrl5 - yrs5 +1
yrs6 = 1850
yrl6 = 2014
nyr6 = yrl6 - yrs6 +1

  yrs = yrs6
  yrl = yrl6

MODEL = MODEL6;_LE
nens = nens6

nmo = dimsizes(MODEL)

com_pc = new((/nmo,(yrl-yrs+1)*12/), "float")
com_std = new((/nmo,(yrl-yrs+1)*12/), "float")
com_gmst = com_pc(:,::12)
com_g_std = com_pc(:,::12)
com_rt_pdv = com_pc(:,::12)
com_rt_gmst= com_pc(:,::12)
com_rc = new((/nmo, 72,144 /), "float") 

do im = 0,nmo-1
print("MODEL "+MODEL(im))

;---------read output---------------
;from lens_ipo.ncl
  fils = systemfunc("ls "+diri+"cmip6/pdv/cmip6_historical_"+MODEL(im)+"_r*_pdv_1850-2014.nc")
  ; print(fils)
  f1   = addfiles(fils, "r")  ;multiple files
  ListSetType (f1, "join")        ; concatenate (=default)
  nf = dimsizes(fils)

  rc  = f1[:]->rc
  pc  = f1[:]->pc

  printVarSummary(rc)

;;----------composite ensemble-----------------
if (nf.eq.1) then 

  com_rc(im,:,:) = rc
else 
  com_rc(im,:,:) = dim_avg_n_Wrap(rc, 0)
end if 

  delete([/fils,rc,pc/] )
end do 

printVarSummary(com_rc)

;MME

rc_mme = dim_avg_n_Wrap(com_rc, 0)

; ;--------output-------------
; fon=diri+"cmip6_historical_pdv_mme.nc";
; system("rm -f "+fon)
; fo=addfile(fon,"c")
; fo->com_pc = com_pc

;--------------plot-------------------

wks = gsn_open_wks("ps", dirip+"cmip_pdv");
plot = new(10,graphic)                ; create graphic array
plot2 = new(10,graphic)                ; create graphic array

gsn_define_colormap(wks, "NCV_blu_red")

; ;---------EOF pattern------------------------

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
res2@cnMinLevelValF        = -0.4
res2@cnMaxLevelValF        =  0.4 
res2@cnLevelSpacingF       =  res2@cnMaxLevelValF/10.


    res2@gsnLeftString = "CMIP6"
    plot2(0) = gsn_csm_contour_map_ce(wks, rc_mme , res2)

;------------------------------------------------
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
resk@txString = "CMIP6 PDV (EOF1)"

gsn_panel(wks,plot2,(/1,1/),resk)

end
