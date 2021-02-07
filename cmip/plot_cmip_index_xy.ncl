load "./function_bootstrap_mme.ncl"
begin

diri = "/Users/xingchen/Documents/project/ENSO/data/" ;"/glade/work/chenxing/enso/";
dirip = "/Users/xingchen/Documents/project/ENSO/pic/" ;"/glade/u/home/chenxing/enso/";

neof = 1

;CMIP5 MODELS
MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1-m","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;
      "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
      "CNRM-CM5","CNRM-CM5-2","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1","GFDL-CM3",\;
      "GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H-CC","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R","HadCM3","HadGEM2-AO",\;
      "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
      "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3","MRI-ESM1",\;
      "NorESM1-ME","NorESM1-M"/)


; CMIP6 MODELS
MODEL6 = (/"BCC-CSM2-MR","BCC-ESM1","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5",
        "CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FGOALS-g3","FIO-ESM-2-0","GFDL-CM4","GFDL-ESM4",\;"E3SM-1-1","FGOALS-f3-L",
        "GISS-E2-1-G","GISS-E2-1-H","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC",
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NESM3","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM",

; ;CMIP5 MODELS
; MODEL5 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC",\;"bcc-csm1-1-m",
;       "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
;       "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM","GFDL-CM2p1",\;"CNRM-CM5-2""GFDL-CM3",
;       "GFDL-ESM2G","GISS-E2-H-CC","HadCM3","HadGEM2-AO",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
;       "HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
;       "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\;"MRI-ESM1",
;       "NorESM1-ME","NorESM1-M"/)

;include all model even its ens is 1
MODEL5_PLUS = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2", "HadGEM2-CC",\;,"GFDL-CM3"
          "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM-CHEM","MIROC-ESM",\
          "MRI-CGCM3","NorESM1-ME", "NorESM1-M"/) ;explicitly have aerosol interaction included in CMIP5

MODEL5_MINUS = (/"bcc-csm1-1","BNU-ESM","CCSM4","CESM1-BGC","CESM1-FASTCHEM","CESM1-WACCM",\
              "CMCC-CESM","CMCC-CM","CMCC-CMS","FGOALS-s2","GFDL-CM2p1", "GFDL-ESM2G","MPI-ESM-LR",\
              "HadCM3","inmcm4","MPI-ESM-MR","MPI-ESM-P"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

MODEL5_LE = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
             "IPSL-CM5A-LR", "CanESM2", "MIROC5","CESM1-CAM5","HadGEM2-ES",\
             "ACCESS1-0","ACCESS1-3","bcc-csm1-1","CESM1-FASTCHEM","FGOALS-g2",\
             "FGOALS-s2","FIO-ESM","IPSL-CM5A-MR","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M"/);"GFDL-CM3",
nens5 = (/10,10,10,8,6,6,6,\
         6,5,5,4,4,\
         3,3,3,3,3,3,3,\
         3,3,3,3,3,3 /);5,

; MODEL5_ESM = (/"BNU-ESM","CanESM2","CESM1-BGC",\;"bcc-csm1-1-m",
;       "CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM",\
;       "FIO-ESM","GFDL-ESM2G",\;"GFDL-ESM2M","GISS-E2-H","GISS-E2-R-CC","GISS-E2-R",
;       "MIROC-ESM-CHEM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P",\;"MRI-ESM1",
;       "NorESM1-ME","NorESM1-M"/)

; MODEL5_CM = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","CCSM4","CMCC-CM","CMCC-CMS",\
;              "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","GFDL-CM2p1",\
;              "GISS-E2-H-CC","HadCM3","HadGEM2-AO","HadGEM2-CC","HadGEM2-ES",\
;              "inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5",\
;               "MRI-CGCM3"/)

; MODEL5 = (/"CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-CM2p1","HadCM3", "CCSM4", \;"GISS-E2-H","GISS-E2-R",
;              "IPSL-CM5A-LR", "CanESM2", "MIROC5","CESM1-CAM5","HadGEM2-ES",\
;              "ACCESS1-0","ACCESS1-3","bcc-csm1-1","CESM1-FASTCHEM","FGOALS-g2",\
;              "FGOALS-s2","FIO-ESM","IPSL-CM5A-MR","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M"/);"GFDL-CM3",

; MODEL5_PLUS = (/"ACCESS1-0","ACCESS1-3","CanESM2","CESM1-CAM5","CNRM-CM5","CSIRO-Mk3-6-0",\;,"GFDL-CM3"
;           "HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5","MIROC-ESM",\
;           "MRI-CGCM3","NorESM1-M","FGOALS-g2"/) ;explicitly have aerosol interaction included in CMIP5

; MODEL5_MINUS = (/"bcc-csm1-1","CCSM4","CESM1-FASTCHEM", "MPI-ESM-LR",\
;           "GFDL-CM2p1","FGOALS-s2","FIO-ESM","HadCM3","MPI-ESM-MR"  /) ;explicitly no aerosol interaction included in CMIP5 "GFDL-ESM2M",

; nens5_plus = (/3,3,5,4,10,10,\
;              4,6,3,5,3,\
;              3,3,3/)

; nens5_minus = (/3,6,3,3,\
;                10,3,3,8,3/)

MODEL5_ESM = (/"CanESM2","CESM1-CAM5","CESM1-FASTCHEM",\
      "FIO-ESM","MIROC-ESM","MPI-ESM-LR","MPI-ESM-MR","NorESM1-M"/)

MODEL5_CM = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","CCSM4",\
             "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","GFDL-CM2p1",\
             "HadCM3","HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC5", "MRI-CGCM3"/)

; ;; CMIP6 MODELS
; MODEL6 = (/"BCC-CSM2-MR","CAMS-CSM1-0","CanESM5","CESM2-FV2",\ ;"ACCESS-CM2","ACCESS-ESM1-5","BCC-ESM1",
;         "CESM2","CESM2-WACCM-FV2",\
;         "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0","GFDL-CM4",\;"E3SM-1-1","FGOALS-f3-L","FGOALS-g3","GFDL-ESM4",
;         "GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6",\;"GISS-E2-1-G-CC","GISS-E2-1-H",
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorCPM1","NorESM2-LM","SAM0-UNICON"/);"MPI-ESM-1-2-HAM","NESM3",
MODEL6_ESM = (/"CanESM5","CESM2-FV2","CESM2","CESM2-WACCM-FV2",\
        "CESM2-WACCM","E3SM-1-0","FIO-ESM-2-0",\
        "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorESM2-LM"/)

MODEL6_CM = (/"BCC-CSM2-MR","CAMS-CSM1-0","GFDL-CM4","GISS-E2-1-G",\
       "INM-CM5-0","IPSL-CM6A-LR","MCM-UA-1-0","MIROC6","NorCPM1","SAM0-UNICON" /)
; MODEL6 = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
;   "MIROC6","MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0",\
;   "BCC-CSM2-MR","CESM2-FV2","CESM2-WACCM-FV2",\
;          "CESM2-WACCM","FIO-ESM-2-0","NorESM2-LM" /) ;large ensemble model in CMIP6 "NESM3",


MODEL6_LE = (/"IPSL-CM6A-LR","NorCPM1", "CanESM5", "GISS-E2-1-G","CESM2","INM-CM5-0",\;"GISS-E2-1-H",
  "MIROC6"/);,"MPI-ESM1-2-LR","MPI-ESM1-2-HR","MRI-ESM2-0","E3SM-1-0",\
    ; "BCC-CSM2-MR","CESM2-FV2","CESM2-WACCM-FV2",\
    ;      "CESM2-WACCM","FIO-ESM-2-0","NorESM2-LM" /) ;large ensemble model in CMIP6 "NESM3",

nens6 = (/32,30,25,12,11, 10, 10,\;10,
          10/);,7,5,5,\
          ; 3,3,3,\
          ; 3,3,3 /) ;ensemble number 5,



; MODEL6_ESM = (/"CanESM5","CESM2","E3SM-1-0",\
;         "MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0"/)
; MODEL6_CM = (/"GISS-E2-1-G","INM-CM5-0","IPSL-CM6A-LR","MIROC6","NorCPM1" /)

; nens6_esm = (/25,11,5,7,10, 5/)
; nens6_cm = (/12,10,32,10,30/)

nm5 = dimsizes(MODEL5)
nm6 = dimsizes(MODEL6)

i5y = new(dimsizes(MODEL5_PLUS), "integer")
do i = 0,dimsizes(MODEL5_PLUS)-1
  i5y(i) = ind(MODEL5.eq.MODEL5_PLUS(i))
end do 
i5n = new(dimsizes(MODEL5_MINUS), "integer")
do i = 0,dimsizes(MODEL5_MINUS)-1
  i5n(i) = ind(MODEL5.eq.MODEL5_MINUS(i))
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

i5esm = new(dimsizes(MODEL5_ESM), "integer")
do i = 0,dimsizes(MODEL5_ESM)-1
  i5esm(i) = ind(MODEL5.eq.MODEL5_ESM(i))
end do 
i5cm = new(dimsizes(MODEL5_CM), "integer")
do i = 0,dimsizes(MODEL5_CM)-1
  i5cm(i) = ind(MODEL5.eq.MODEL5_CM(i))
end do 

i6esm = new(dimsizes(MODEL6_ESM), "integer")
do i = 0,dimsizes(MODEL6_ESM)-1
  i6esm(i) = ind(MODEL6.eq.MODEL6_ESM(i))
end do 
i6cm = new(dimsizes(MODEL6_CM), "integer")
do i = 0,dimsizes(MODEL6_CM)-1
  i6cm(i) = ind(MODEL6.eq.MODEL6_CM(i))
end do 

yrs5 = 1861
yrl5 = 2004
nyr5 = yrl5 - yrs5 +1
yrs6 = 1850
yrl6 = 2014
nyr6 = yrl6 - yrs6 +1

;;;;touch here;;;;;;;;;;;;
EXP5 = "historical";"historicalNat" ;"historicalGHG" ;
EXP6 = "historical";"hist-aer";"hist-Nat" ;"hist-GHG" ;

;don't filter pdv pc, it's already filtered, double filter will shortern data...
IND = "PDI2" ;"EACSS" ;"EAS" ;"PDI2" ; "NPCSS" ;"NPC" ;"NPS" ;"NPAOD" ;"PDI2";"TPI" ;"NPI" ;"AMO" ;"pdo" ;"nh-sh" ;"GMAOD" ;"GMSW" ;
MODEL = MODEL5;MODEL6; 
nens = nens6
icmip = 5;6 ; 
nens_all = 10;32 ;

yrs = 1861; 
yrl = 2004; 2014;


nmo5 = dimsizes(MODEL5)
nmo6 = dimsizes(MODEL6)

pc5_all = new((/nmo5,10,(yrl5-yrs5+1)*12/), "float")

do im = 0,nmo5-1

;from pdv_cmip5_hist.ncl
;cmip5_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
locs = systemfunc("ls "+diri+"cmip5/pdv/cmip5_historical_"+MODEL5(im)+"_*_pdv_"+yrs5+"-"+yrl5+".nc")
; printVarSummary(locs)
; print(locs)
nsa = dimsizes(locs)

; if(.not.ismissing(locs)) then
do ia = 0,nsa-1

  ; print("MODEL5 "+MODEL5(im))
  locs_str = str_split(locs(ia), "_"); "/")
  ; print("'" + locs_str + "'")
  ENSN  = locs_str(3)
  print(MODEL5(im)+" ens "+ENSN)
  delete(locs_str)

   file_name = diri+"cmip5/"+IND+"/cmip5_"+EXP5+"_"+MODEL5(im)+"_"+ENSN+"_"+IND+"_"+yrs5+"-"+yrl5+".nc"
   exists = isfilepresent(file_name)
   if(.not.exists) then
     ; print(MODEL5(im)+" ens "+ENSN+" file not exist")
     ; print("Either the file doesn't exist, or NCL does")
     ; print("not have OPeNDAP cabilities on this system.")
     continue
   else
    ; print(file_name)
   f   = addfile(file_name, "r") 
   end if

  pc5_all(im,ia,:)  = f->index;pc(0,:);gmst;

; print(""+pc5_all(im,ia,(1890-1861)*12))

end do 
; end if 
delete(locs)
end do 
printVarSummary(pc5_all)


;CMIP6
pc6_all = new((/nmo6,32,(yrl6-yrs6+1)*12/), "float")
do im = 0,nmo6-1

;from pdv_cmip5_hist.ncl
;cmip5_historical_CanESM2_r4i1p1_pdv_1861-2004.nc
locs = systemfunc("ls "+diri+"cmip6/pdv/cmip6_historical_"+MODEL6(im)+"_*_pdv_"+yrs6+"-"+yrl6+".nc")
printVarSummary(locs)
print(locs)
nsa = dimsizes(locs)

; if(.not.ismissing(locs)) then

do ia = 0,nsa-1

  print("MODEL6 "+MODEL6(im))
  locs_str = str_split(locs(ia), "_"); "/")
  print("'" + locs_str + "'")
  ENSN  = locs_str(3)
  print(MODEL6(im)+" ens "+ENSN)
  delete(locs_str)

   file_name = diri+"cmip6/"+IND+"/cmip6_"+EXP6+"_"+MODEL6(im)+"_"+ENSN+"_"+IND+"_"+yrs6+"-"+yrl6+".nc"
   exists = isfilepresent(file_name)
   if(.not.exists) then
     print(MODEL6(im)+" ens "+ENSN+" file not exist")
     print("Either the file doesn't exist, or NCL does")
     print("not have OPeNDAP cabilities on this system.")
     continue
   else
    print(file_name)
   f   = addfile(file_name, "r") 
   end if

  pc6_all(im,ia,:)  = f->index;pc(0,:);gmst;

end do 
; end if 
delete(locs)

end do 

printVarSummary(pc6_all)

;don't filter pdv index twice!!!
;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*12*1+1); fyr)+1 ;                           ; odd only
fca   = 1./(fyr*12)
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )
pc5_all = wgt_runave_n_Wrap( pc5_all, wgt,  0, 2 )   ;opt < 0 : utilize cyclic conditions 
pc6_all = wgt_runave_n_Wrap( pc6_all, wgt,  0, 2 )   ;opt < 0 : utilize cyclic conditions 


;----------composite-------------------
;MME
;ignore model bias 
; ndimp = dimsizes(pc5_all)
; aa = reshape(pc5_all, (/ndimp(0)*ndimp(1),ndimp(2)/))
cp5_a = dim_avg_n_Wrap(pc5_all,(/0,1/)); aa, 0)
cp6_a = dim_avg_n_Wrap(pc6_all,(/0,1/)); aa, 0)

; ;same weight
cp5_a2 = dim_avg_n_Wrap(dim_avg_n_Wrap(pc5_all,1), 0)
cp6_a2 = dim_avg_n_Wrap(dim_avg_n_Wrap(pc6_all,1), 0)

cp5_plus_a = dim_avg_n_Wrap(pc5_all(i5y,:,:), (/0,1/)) ;dim_avg_n_Wrap(dim_avg_n_Wrap(pc5_all(i5y,:,:), 1),0) ;PLUS group MME
cp5_minus_a = dim_avg_n_Wrap(pc5_all(i5n,:,:), (/0,1/)) ;dim_avg_n_Wrap(dim_avg_n_Wrap(pc5_all(i5n,:,:), 1),0) ;MINUS group MME

cp6_esm_a = dim_avg_n_Wrap(pc6_all(i6esm,:,:), (/0,1/)) ;dim_avg_n_Wrap(dim_avg_n_Wrap(pc6_all(i6esm,:,:), 1),0) ;PLUS group MME
cp6_cm_a = dim_avg_n_Wrap(pc6_all(i6cm,:,:), (/0,1/)) ;dim_avg_n_Wrap(dim_avg_n_Wrap(pc6_all(i6cm,:,:), 1),0) ;MINUS group MME

; ;1. averaged STD across ensembles 
cs_a = dim_stddev_n_Wrap(pc5_all, (/0,1/)) ;com_std, 0)

d1 = cp5_plus_a
d1 = cp5_plus_a - cp5_minus_a
d2 = cp5_plus_a
d2 = cp6_a((1861-1850)*12:(2005-1850)*12-1) - cp5_minus_a


std_5 = dim_stddev_n_Wrap(pc5_all,(/0,1/))
std_6 = dim_stddev_n_Wrap(pc6_all,(/0,1/))
;--------output-------------
fon=diri+"cmip5_"+EXP5+"_"+IND+"_mme.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->cp5_a = cp5_a
fo->cp5_a2 = cp5_a2
fo->cp5_plus_a = cp5_plus_a
fo->cp5_minus_a = cp5_minus_a
fo->std_5 = std_5

fon=diri+"cmip6_"+EXP6+"_"+IND+"_mme.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->cp6_a = cp6_a
fo->cp6_a2 = cp6_a2
fo->cp6_esm_a = cp6_esm_a
fo->cp6_cm_a = cp6_cm_a
fo->std_6 = std_6


;   asciiwrite (diri+"cmip5_"+EXP5+"_"+IND+"_mme.txt", cp5_a)
;   asciiwrite (diri+"cmip6_"+EXP6+"_"+IND+"_mme.txt", cp6_a)
;   asciiwrite (diri+"cmip5_"+EXP5+"_"+IND+"_std.txt", std_5)
;   asciiwrite (diri+"cmip6_"+EXP6+"_"+IND+"_std.txt", std_6)

exit
; ;-----------BootStrap---------------------
; function_bootstrap_mme.ncl 

N = 1000 
nBoot =   10000    


nem5y = num(.not.ismissing(ndtooned(pc5_all(i5y,:,500))))
nem5n = num(.not.ismissing(ndtooned(pc5_all(i5n,:,500))))
nem5 = num(.not.ismissing(ndtooned(pc5_all(:,:,500))))
print(nem5y)

boo5 = bootstrap_mme(pc5_all,wgt,N,nBoot,nem5)
; zz = dim_avg_n_Wrap(boo5, 1)
; bh5 = cp5_a
; bh5 = where(cp5_a.ge.zz(0).or.cp5_a.ne.zz(1), cp5_a, cp5_a@_FillValue)

boo5y = bootstrap_mme(pc5_all,wgt,N,nBoot,nem5y)
; zz = dim_avg_n_Wrap(boo5y, 1)
; bh5y = cp5_plus_a
; bh5y = where(cp5_plus_a.ge.zz(0).or.cp5_plus_a.ne.zz(1), cp5_plus_a, cp5_plus_a@_FillValue)

boo5n = bootstrap_mme(pc5_all,wgt,N,nBoot,nem5n)
; zz = dim_avg_n_Wrap(boo5n, 1)
; bh5n = cp5_minus_a
; bh5n = where(cp5_minus_a.ge.zz(0).or.cp5_minus_a.ne.zz(1), cp5_minus_a, cp5_minus_a@_FillValue)

nem6 = num(.not.ismissing(ndtooned(pc6_all(:,:,500))))
boo6 = bootstrap_mme(pc6_all,wgt,N,nBoot,nem6)
; zz = dim_avg_n_Wrap(boo6, 1)
; print(nem6)
; bh6 = cp6_a
; bh6 = where(cp6_a.ge.zz(0).or.cp6_a.ne.zz(1), cp6_a, cp6_a@_FillValue)


; ;-------surface SW - TOA SW------------------------------

; fon=diri+"cmip5_"+EXP5+"_SWHD_mme.nc";
; fo=addfile(diri+"cmip5_"+EXP5+"_SWHD_mme.nc","r")
; sa5 = fo->cp5_a

; fon=diri+"cmip6_"+EXP6+"_SWHD_mme.nc";
; fo=addfile(diri+"cmip6_"+EXP6+"_SWHD_mme.nc","r")
; sa6 = fo->cp6_a

; dst5 = sa5
; dst5 = sa5 - cp5_a

; dst6 = sa6
; dst6 = sa6 - cp6_a


;---------trend (partial t)----------------------------
cd5 = center_finite_diff_n (cp5_a,8*12,False,0,0)
cd6 = center_finite_diff_n (cp6_a,8*12,False,0,0)
printVarSummary(cd5)
printVarSummary(cd6)


;--------------plot-------------------

wks = gsn_open_wks("png", dirip+"cmip_index_xy");
wks2 = gsn_open_wks("png", dirip+"test");
plot = new(10,graphic)                ; create graphic array
plot2 = new(10,graphic)                ; create graphic array


;*******************************************
; time series (principal component) plot
;*******************************************

  gsn_define_colormap(wks,"seaice_2")
  colors = ispan(2, 17, 1)   ; indices into color table
  colors2 = ispan(2, 9, 1)   ; indices into color table
  colors1 = ispan(10, 18, 1)   ; indices into color table


; these four resources allow the user to stretch the plot size, and
; decide exactly where on the page to draw it.

  res = True
  res@gsnDraw = False        ;dont draw
  res@gsnFrame = False        ;dont advance frame
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@vpHeightF = 0.3
  res@vpWidthF  = 0.6
 
  res@tmXTOn    = False
  res@tmYROn    = False
  ;res@gsnXYBarChart            = True              ; Create bar plot
  ;res@gsnXYBarChartOutlineOnly = True


  res@gsnYRefLine           = 0.0             ; reference line   
  ; res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  ; res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  ; res@gsnLeftStringFontHeightF  = 0.03
  ; res@gsnRightStringFontHeightF = 0.03

  ndim5  = dimsizes(pc5_all)
  x_axis5 = fspan(yrs5, yrl5, ndim5(2))
  ndim6  = dimsizes(pc6_all)
  x_axis6 = fspan(yrs6, yrl6, ndim6(2))
  x_axis1 = ispan(yrs, yrl, 1)
  ;res@tmXBMode   = "Explicit"                                                
  ;res@tmXBValues = x_axis;-1
  ;res@tmXBLabels = model
  ;res@tmXBLabelAngleF = 45.
  ;res@tmXBLabelFontHeightF = 0.02
  res@tiYAxisString = ""
  res@tiXAxisString = "year"
  
  res@xyMonoLineColor = False
  res@xyMonoDashPattern = True

  res@trXMinF               = 1850
  res@trXMaxF               = 2015

  res@trYMinF               = -0.05
  res@trYMaxF               =  0.05


ies5 = ind(.not.ismissing(ndtooned(pc5_all(:,:,500))))
ies6 = ind(.not.ismissing(ndtooned(pc6_all(:,:,500))))
printVarSummary(ies5)
printVarSummary(ies6)
print(ind(.not.ismissing((pc5_all(i5y,0,500)))))
print(ind(.not.ismissing((pc5_all(i5n,0,500)))))
print(ind(.not.ismissing((pc5_all(:,0,500)))))
print(ind(.not.ismissing((pc6_all(:,0,500)))))

;MODEL
res@xyLineThicknessF = 1.0
res@gsnRightString = pc5_all@units
  res@xyLineColor = "grey85"
res@gsnLeftString = IND+" in CMIP5 ("+EXP5
aa = reshape(pc5_all, (/ndim5(0)*ndim5(1),ndim5(2)/))
plot(0) = gsn_csm_xy (wks,x_axis5, aa(ies5,:) ,res) ;x_axis2, com_pc
bb = reshape(pc6_all, (/ndim6(0)*ndim6(1),ndim6(2)/))
res@gsnLeftString = IND+" in CMIP6 ("+EXP6
plot(1) = gsn_csm_xy (wks,x_axis6, bb(ies6,:) ,res) ;x_axis2, com_pc

; cp6_a = dim_avg_n_Wrap(bb(ies6,:), 0)
res@gsnLeftString = ""
res@xyLineThicknessF = 5.0
res@xyLineColor = "black"

plota = gsn_csm_xy (wks,x_axis5,cp5_a,res) ;cg_a ;crt_g_a
overlay(plot(0), plota)
plota = gsn_csm_xy (wks,x_axis6,cp6_a,res) ;cg_a ;crt_g_a
overlay(plot(1), plota)


res@xyLineColor = "red"
plota = gsn_csm_xy (wks,x_axis5,cp5_plus_a ,res) ;cg_a ;crt_g_a
overlay(plot(0), plota)
; plota = gsn_csm_xy (wks,x_axis6,cp6_esm_a ,res) ;cg_a ;crt_g_a
; overlay(plot(1), plota)
res@xyLineColor = "blue"
plota = gsn_csm_xy (wks,x_axis5,cp5_minus_a,res) ;cg_a ;crt_g_a
overlay(plot(0), plota)
; plota = gsn_csm_xy (wks,x_axis6,cp6_cm_a,res) ;cg_a ;crt_g_a
; overlay(plot(1), plota)

res@xyLineColor = "green"

plota = gsn_csm_xy (wks,x_axis5,cp5_a2,res) ;cg_a ;crt_g_a
overlay(plot(0), plota)
plota = gsn_csm_xy (wks,x_axis6,cp6_a2,res) ;cg_a ;crt_g_a
overlay(plot(1), plota)


plot(2) = gsn_csm_xy(wks, x_axis5, d1, res)
res@xyLineColor = "blue"
plota = gsn_csm_xy(wks, x_axis5, d2, res)
overlay(plot(2), plota)

res@xyLineThicknessF = 1.0
res@xyDashPattern = 3
res@xyLineColor = "black"
plota = gsn_csm_xy (wks,x_axis5,boo5,res)
overlay(plot(0), plota)
res@xyLineColor = "pink"
plota = gsn_csm_xy (wks,x_axis5,boo5y,res)
overlay(plot(0), plota)
res@xyLineColor = "cyan"
plota = gsn_csm_xy (wks,x_axis5,boo5n,res)
overlay(plot(0), plota)
res@xyLineColor = "black"
plota = gsn_csm_xy (wks,x_axis6,boo6,res)
overlay(plot(1), plota)

delete(res@trYMinF)
delete(res@trYMaxF)
; res@xyLineThicknessF = 3.0
; res@xyLineColors = "black"
; res@gsnLeftString = "surface-TOA SW in CMIP5"
; plot2(0) = gsn_csm_xy (wks2,x_axis5,dst5,res) 
; res@gsnLeftString = "surface-TOA SW in CMIP6"
; plot2(1) = gsn_csm_xy (wks2,x_axis6,dst6,res) 

res@gsnLeftString = "trend in CMIP5"
plot2(0) = gsn_csm_xy (wks2,x_axis5,cd5,res) 
res@gsnLeftString = "trend in CMIP6"
plot2(1) = gsn_csm_xy (wks2,x_axis6,cd6,res) 

;------------------------------------------------
resk = True
;resk@txFontHeightF = 0.03
resk@gsnPanelLabelBar   = False                 ; add common colorbar
resk@gsnMaximize = True
resk@gsnPaperOrientation = "portrait"   ; force portrait
resk@txString = ""

gsn_panel(wks,plot,(/3,1/),resk)
gsn_panel(wks2,plot2,(/2,1/),resk)

end