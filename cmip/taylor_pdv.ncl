;**********************************
; adapt from taylor_4.ncl
;**********************************
load "./taylor_diagram.ncl"
; load "./taylor_metrics_table.ncl"
begin

diri  = "/Users/xingchen/Documents/project/ENSO/data/" ;"/glade/work/chenxing/enso/"
diri0 = "/Users/xingchen/Documents/project/ENSO/pic/" ;"/glade/u/home/chenxing/enso/"

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

nm5 = dimsizes(MODEL5)
nm6 = dimsizes(MODEL6)


;------------filter----------------------
fyr   = 8.
ihp   = 0                             ; low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2.
sigma = 1.0                           ; Lanczos sigma
nWgt  = toint(fyr*1+1); fyr)+1 ;                           ; odd only
fca   = 1./(fyr)
fcb   = -999.
wgt  = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )

;**********************************
; Assume the following have already been computed:
;   _ratio are the ratio:  Case_Variance/Reference_Variance
;   _cc    are the cross correlation coef of Case to Reference
; In this example, these are derived for annual mean climatologies.
;**********************************

; Cases [groups]
  case      = (/ "CMIP6" /) ;, "CMIP5"
  nCase     = dimsizes(case )                 ; # of Cases [Cases]

; models compared
  var       = MODEL6
  nVar      = dimsizes(var)                   ; # of Variables


;---------read output---------------

; OBS from obs_ipo.ncl
f1   = addfile(diri+"obs_org.pdv_1880-2018.nc", "r")
; OBS from obs_index.ncl
f1   = addfile(diri+"obs_PDI2_1854-2019.nc", "r")
pc_obs  = f1->index;pco(0,:)
printVarSummary(pc_obs)
pc_obs_annual = month_to_annual(pc_obs, 1)
pc_obs_annual = wgt_runave_n_Wrap( pc_obs_annual, wgt,  0, 0 )   ;opt < 0 : utilize cyclic conditions 
std_obs = stddev(pc_obs_annual)
print(std_obs+" obs std")


; ; from output_cmip_pdv_pc.ncl
; f1   = addfile(diri+"cmip5_pdv_all_model.nc", "r")
; pc  = f1->pco ;pc
; par = f1->par

;from cmip_index.ncl
f1   = addfile(diri+"cmip6_PDI2_all_model.nc", "r") 
pc  = f1->pc

; ;from reg_cmip5.ncl (ts regressed onto PDI2)
; ;then patterncor_cmip_pdi.ncl
; from reg_cmip5_pdi_0.ncl
; f1   = addfile(diri+"cmip5_reg_all_PDI2_historical_tas_1861-2004.nc", "r") 
f1   = addfile(diri+"cmip6_reg_all_PDI2_historical_ts_1850-2014.nc", "r") 
par  = f1->par

printVarSummary(pc)
printVarSummary(par)

;ensemble mean
; par_avg = dim_avg_n_Wrap(par, 1)
pc_avg = dim_avg_n_Wrap(pc, 1)

  ratio      = new ((/nCase, nVar/),typeof(pc) )  
  cc         = new ((/nCase, nVar/),typeof(pc) ) 

  pc = wgt_runave_n_Wrap( pc, wgt,  0, 2 )   ;opt < 0 : utilize cyclic conditions 
  std_pc = dim_stddev_n_Wrap(pc, (/1,2/)) 

  print(std_pc)

  ratio(0,:) = std_pc / std_obs
  cc(0,:)    = par ;par_avg 

printVarSummary(cc)
printVarSummary(ratio)

;**********************************
; create plot
;**********************************
  varSource = var              ; add extra info [*not* required]

  ty_opt   = True                           ; taylor diagram with options
        
  ty_opt@Markers       = (/16/)         ; make all solid fill
  ty_opt@Colors        = (/"red" /)          
  ; ty_opt@varLabels     = varSource
  ; ty_opt@caseLabels    = case

  ty_opt@varLabelsYloc = 1.5                ; Move location of variable labels [default 0.45]
  ty_opt@caseLabelsFontHeightF = 0.14       ; make slight larger   [default=0.12 ]
  ty_opt@varLabelsFontHeightF  = 0.011      ; make slight smaller  [default=0.013]
 
  ty_opt@tiMainString  = case+" PDV"           ; title
  ty_opt@stnRad        = (/ 0.5/)     ; additional standard radii
  ty_opt@ccRays        = (/ 0.3/)     ; correllation rays
  ty_opt@centerDiffRMS = True               ; RMS 'circles'

  wks   = gsn_open_wks("png","../pic/taylor.000004")      ; send graphics to PNG file
  plot  = taylor_diagram(wks,ratio,cc,ty_opt)

; ;**************************************************
; ; fill an array for a "taylor metrics table"
; ;**************************************************

;   season    = (/ "ANN" /)
;   nSeason   = dimsizes(season)

;   table     = new ( (/nCase,nSeason,nVar/), typeof(ratio) )
;   table(0,0,:) = CA_ratio

;   tt_opt        = True
;   tt_opt@pltType= "png"                  ; "eps" [default], "pdf", "ps"
;                                          ; "png", "gif" [if you have ImageMajik 'convert']
;   tt_opt@color0 = "palegreen2"
;   tt_opt@color1 = "tomato2"


;   taylor_metrics_table("taylor.000002", varSource, case ,season, table, tt_opt)
end 