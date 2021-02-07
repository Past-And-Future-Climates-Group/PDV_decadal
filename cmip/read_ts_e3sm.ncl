begin

diri = "./"
diri0 = "./"

;https://psl.noaa.gov/thredds/fileServer/Datasets/E3SM_LE/en1/atm/TS.1973-10.nc ;HTTPServer  --> X
;https://psl.noaa.gov/thredds/dodsC/Datasets/E3SM_LE/en1/atm/TS.1973-10.nc ;OPENDAP --> V

url = "https://psl.noaa.gov/thredds/dodsC/Datasets/E3SM_LE/en1/atm/"
filename = "TS.*.nc"
filename0 = "TS.1973-10.nc"


  exists = isfilepresent(url+filename0)
  if(.not.exists) then
    print("OPeNDAP test unsuccessful.")
    print("Either the file doesn't exist, or NCL does")
    print("not have OPeNDAP cabilities on this system.")
  else
    f = addfile(url + filename0,"r")
    vnames = getfilevarnames(f)
    print(vnames)
  end if


;generature file names 
;1850-01 - 2011-12
yrstrt = 1850
yrlast = 2011
fname = new((yrlast+1-yrstrt)*12,"string")
printVarSummary(fname)
do iyear = yrstrt,yrlast
    do imon = 1,12
        ix = iyear - yrstrt
        iy = imon-1
        fname(ix*12+iy) = "TS."+iyear+"-"+sprinti("%0.2i", imon)+".nc"
    end do 
end do 
print(fname)

;read files
url1 = fname
url1 = url
print(url1+fname+"")
fx   = addfiles(url1+fname, "r")  ;multiple files
ListSetType (fx, "cat")        ; concatenate (=default)
print(fx)
printVarSummary(fx)
; TIME0=fx[:]->time
; yyyymm0 = cd_calendar(TIME0, -1)
; ; ymstrt0 = ind(yyyymm0.eq.ymstrt)
; ; ymlast0 = ind(yyyymm0.eq.ymlast)
; print(yyyymm0)


ts = fx[:]->TS;(ymstrt0:ymlast0,:,:)
printVarSummary(ts)

;------output--------------
fon=diri+"E3SM_en1_TS_"+yrstrt+"-"+yrlast+".nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->TS = ts

end 
