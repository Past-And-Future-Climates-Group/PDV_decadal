begin

diri = "/glade/work/chenxing/enso/"
dirip = "/glade/u/home/chenxing/enso/"

  wks = gsn_open_wks("ps",dirip+"wavelet_aod") 

;--------read-------------
;read files
; files = systemfunc("ls E3SM/E3SM_en*_nino34_1850-2011.nc")

files = systemfunc("ls "+diri+"cmip5/od550aer/global_index/cmip5_historical_*_global_index_od550aer_1861-2004.nc")
; files = systemfunc("ls "+diri+"cmip5/od550aer/global_index/cmip5_historical_*_NP_index_od550aer_1861-2004.nc")
; files = systemfunc("ls "+diri+"cmip6/od550aer/global_index/cmip6_historical_*_global_index_od550aer_1850-2014.nc")
; files = systemfunc("ls "+diri+"cmip6/od550aer/global_index/cmip6_historical_*_NP_index_od550aer_1850-2014.nc")

na = dimsizes(files)
print(files)

; f_yrs = 1920
; f_yrl = 2011

;CMIP5: 44,1728
;CMIP6: 44,1980
power_avg = new((/44,1728/), "float") ;based on dimension of power
power_avg = 0.0

ns = 0 ;sample number

do ia = 0,na-1

 ; ea = str_get_cols(files(ia), 12, 13)

f1 = addfile(files(ia),"r")
; f1 = addfile(diri+"E3SM/E3SM_en1_nino34_1850-2011.nc", "r")
xx = f1->index;(:(f_yrl- f_yrs)*12-1)
printVarSummary(xx)
; xx_djf = month_to_season(xx, "DJF")

data = xx

;--------wavelet----------------------------

ndim = dimsizes(data)

  if(any(ismissing(data))) then
    print("Your data contains some missing values. Beware.")
    print(ind(ismissing(data)))
    data(ind(ismissing(data))) = 0.
  end if


 N = dimsizes(data)
 
  mother  = 0      ; 
  dt      = 1       ; 
  param   = 6.0     ; 
  s0      = dt      ; 
  dj      = 0.25    ; 
  jtot    = 1+floattointeger(((log10(N*dt/s0))/dj)/log10(2.)) ; 
  npad    = N       ; 
  nadof   = 0 ;
  noise   = 1       ; 
  siglvl  = .05     ; 
  isigtest= 0       ; 
  
  w =wavelet(data,mother,dt,param,s0,dj,jtot,npad,noise,isigtest,siglvl,nadof)
  ; printVarSummary(w)  
  
  ;************************************
  power            = onedtond(w@power,(/jtot,N/))  ;
  power!0          = "period"                      ; Y axis
  power&period     = w@period                     

  power!1          = "time"                        ; X axis
  time             = ispan(0, N-1, 1) 
  power&time      = time

  power@long_name  = "Power Spectrum"
  power@units      = "1/unit-freq"

  
  SIG              = power                         ; ??????????
  SIG              = power/conform (power,w@signif,0)
  SIG@long_name    = "Significance"
  SIG@units        = ""

printVarSummary(power) 

power_avg = power_avg + power
ns = ns+1
print("ens"+ia)

end do 

power_avg = power_avg / tofloat(ns)

copy_VarMeta(power, power_avg)

printVarSummary(power_avg)
 ;*************************************************
   gsn_define_colormap(wks,"BlAqGrYeOrReVi200")   

YLValues = (/0.5,1,2,4,8,16,32,64/)*12
YLLabels=YLValues/12+"" ;
  
  res                     = True                  
  res@gsnDraw             = False              
  res@gsnFrame            = False                 
  res@gsnRightString      = ""
  res@gsnLeftString       = ""

  res@vpWidthF  = 0.7
  res@vpHeightF = 0.2

  res@trYReverse = True                  ; ???? y-axis
  res@tmYLMode   = "Explicit"
  res@tmYLValues = YLValues
  res@tmYLLabels = YLLabels
  res@tmLabelAutoStride   = True
  res@tmXBMode            = "Explicit"
  res@tmXBValues          = ispan(0, ndim-1, 12*20)
  res@tmXBLabels          = ispan(1850, 2014, 20) 
  ; res@trYMinF       = 0;12*1
  ; res@trYMaxF       = 12*40;64

  res@cnLinesOn      = False               
  res@cnLineLabelsOn = False
  res@cnInfoLabelOn  = False
    
  res2 = res
 
  res@tiXAxisString       = "";"Year"  
  ; res@tiXAxisOffsetYF     = 0.135
  res@tiYAxisString       = "" 
  
  res@cnFillOn            = True                 
  res@cnFillMode          = "RasterFill"          
  res@cnRasterSmoothingOn = True                  
  
  ;;;;;;;;;;;;;
  res@cnLevelSelectionMode = "ManualLevels" 
  res@cnMinLevelValF       = 0.0        
  res@cnMaxLevelValF       = 0.001       
  res@cnLevelSpacingF      = res@cnMaxLevelValF/10.      

  gws = w@gws
  resl = True
  resl@gsnFrame      = False
  resl@gsnDraw       = False
  resl@trYAxisType   = "LogAxis"
  resl@trYReverse    = True                  ; reverse y-axis
  resl@tmXBMinorOn   = False
  resl@tmXTMinorOn   = False
  resl@tmYLMinorOn   = False
  resl@tmYRMinorOn   = False
  resl@tmYLMode      = "Explicit"
 ; resl@tmYLValues    = YLValues
  ;resl@tmYLLabels    = YLLabels
  resl@trYMaxF       = res@trYMaxF
  resl@trYMinF       = res@trYMinF 
  ; resl@trXMaxF       = 15.
  ; resl@trXMinF       = 1.
  resl@tiXAxisString = "Wavelet Power"

;*************************************** 
  sres                 = True                 ; set up a second resource list               
  sres@gsnDraw         = False                ;         do not draw the plot                
  sres@gsnFrame        = False                ; do not advance the frame                    
  sres@cnLineLabelsOn  = False                ; do not use line labels                      
  sres@cnLinesOn       = False                ; do not draw contour lines                   
  sres@cnInfoLabelOn   = False                                                              
  sres@cnFillOn        = True                 ; color fill                                   
  sres@lbLabelBarOn    = False                                                                  
  sres@cnLevelSelectionMode = "ExplicitLevels"                                                                                             
  sres@cnLevels             = 1   ;-0.254,0.254                                                                                             
  sres@cnMonoFillPattern    = False            ; want multiple patterns                                                               

  sres@cnFillPatterns       = (/-1,17/)         ; the patterns   
  sres@cnFillColor          = "black";"Foreground";"cornsilk";"darkolivegreen2";"cyan"
  ; sres@cnFillScales         = (/-1,0.7/)          ; change densities                                                                
  sres@cnMonoFillScale      = False            ; want different densities                                                                             
  sres@cnMonoFillColor      = True                                                                                                     
  sres@cnFillDotSizeF       = 0.001    
  sres@gsnLeftString        = ""  
  sres@gsnRightString       = ""                                                                                                                            
;;**********************************************************

; devided variance, the units turns to multiple?!
; aa = power
; aa = power/var1
;   res@lbTitleString        =  "mm~S~2~N~ day~S~-2" ;"mm~S~2~N~ day~S~-2"     

  plot    = gsn_csm_contour(wks,power_avg,res)
  plot    = ShadeCOI(wks,plot,w,time,False) ;用网格表示有边界效应的区域
  iplot   = gsn_csm_contour(wks,SIG,sres)
  overlay(plot,iplot)    

  plotg = gsn_csm_xy(wks,gws,power&period,resl) 
  
  ; plotc = gsn_attach_plots(plot,plotg,res,resl)

      resk = True
      resk@txFontHeightF = 0.02
      resk@gsnMaximize = True
      resk@gsnPaperOrientation = "portrait"   ; force portrait

      resk@txString  = "CMIP5 AOD"
      gsn_panel(wks,plot,(/1,1/),resk);

print(resk@txString)

; end do 

end

