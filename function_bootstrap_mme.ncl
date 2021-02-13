function bootstrap_mme(y,wgt,N,nBoot,ne)
begin
;-----------BootStrap---------------------
; generate many time series, then select the number of all ensembles
; then composite nBoot times. list their range, and got 97.5% 2.5%

  ndim = dimsizes(y)

  ; N       = 1000;about the ensemble number
  xMean   = 0.0             ; population mean
  xStdDev = stddev(y)            ; populaton standard deviation

  random_setallseed(36484749,119494848)   ; optional: see above comments
  x0       = random_normal(xMean, 1,(/N,ndim(2)/))
  printMinMax(x0, 0)
  x0 = wgt_runave_n_Wrap( x0, wgt,  0, 1 )   ;opt < 0 : utilize cyclic conditions 
  x0 = dim_standardize_n_Wrap(x0, 1, 1)
  x1 = ndtooned(x0)
  ik = ind(.not.ismissing(x1))
  x2 = x1(ik)
  nn = dimsizes(ik)
  nd2 = nn/N
  x = reshape(x2, (/N,nd2/))
  printMinMax(x, 0)
  x = x * xStdDev
  print(xStdDev)
  printMinMax(x, 0)
  printVarSummary(x)

  ; nBoot =   10000                           ; user specified
        xBoot   = new ((/nBoot,nd2/), typeof(x))

        random_setallseed(119494848, 36484749)   ; optional: see above comments
 
                                     ;For 'fun', generate the sampling indices directly in the 'x' array.
  do ns=1,nBoot
        xBoot(ns-1,:) = dim_avg_n_Wrap( x(toint(random_uniform(0,N-1, ne)),: ),0)
  end do


  xAvgBoot= avg(xBoot)      ; Averages of bootstrapped samples
  xStdBoot= stddev(xBoot)   ; Std Dev  "        "        "
  print("nBoot="+nBoot+"  xAvgBoot="+xAvgBoot+"  xStdBoot="+xStdBoot)

  ip = dim_pqsort_n(xBoot, 2, 0)                  ; no reordering needed
  printMinMax(xBoot, 0)

  n025 = toint(0.025*nBoot)   ; indices for sorted array
  n950 = toint(0.950*nBoot)
  n975 = toint(0.975*nBoot)
  print("n025="+n025+"  n950="+n950+"  n975="+n975)

  xBoot_025 = xBoot(n025,:)     ;  2.5% level
  xBoot_950 = xBoot(n950,:)     ; 95.0% level
  xBoot_975 = xBoot(n975,:)     ; 97.5% level
  printVarSummary(xBoot_975)
  printMinMax(xBoot_975, 0)

   bh = new((/2,ndim(2)/), typeof(y), y@_FillValue)
   n1 = (ndim(2) - nd2 )/2
   bh(0,n1:n1+nd2-1) = xBoot_975
   bh(1,n1:n1+nd2-1) = xBoot_025

   return bh

end 