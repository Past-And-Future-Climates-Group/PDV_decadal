begin

diri = "./"
diri0 = "./"

;https://psl.noaa.gov/thredds/fileServer/Datasets/E3SM_LE/en1/atm/TS.1973-10.nc ;HTTPServer  --> X
;https://psl.noaa.gov/thredds/dodsC/Datasets/E3SM_LE/en1/atm/TS.1973-10.nc ;OPENDAP --> V

EN = (/1,2,3,4,13,14,15,16,17,18,19,20/)

  f0   = addfile("/glade/work/chenxing/enso/E3SM/E3SM_en02_TS_185001-201112.nc", "r")
  tso  = f0->ts
  printVarSummary(tso)

do ia = 18,20

url = "https://psl.noaa.gov/thredds/dodsC/Datasets/E3SM_LE/en"+ia+"/atm/"
filename = "seaLevelPressure.*.nc"
filename0 = "seaLevelPressure.1973-10.nc"


  exists = isfilepresent(url+filename0)
  if(.not.exists) then
    print("OPeNDAP test unsuccessful.")
    print("Either the file doesn't exist, or NCL does")
    print("not have OPeNDAP cabilities on this system.")
    continue
  else
    f = addfile(url + filename0,"r")
    vnames = getfilevarnames(f)
    print(vnames(0))
  end if
  
print("ens "+ia)

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
        fname(ix*12+iy) = "seaLevelPressure."+iyear+"-"+sprinti("%0.2i", imon)+".nc"
    end do 
end do 
print(fname(0:10))

;read files
url1 = fname
url1 = url
;print(url1+fname+"")
fx   = addfiles(url1+fname, "r")  ;multiple files
ListSetType (fx, "cat")        ; concatenate (=default)
printVarSummary(fx)
; TIME0=fx[:]->time
; yyyymm0 = cd_calendar(TIME0, -1)
; ; ymstrt0 = ind(yyyymm0.eq.ymstrt)
; ; ymlast0 = ind(yyyymm0.eq.ymlast)
; print(yyyymm0)


var = fx[:]->PSL;(ymstrt0:ymlast0,:,:)
;lack of _FillValue and time dimension!!!
printVarSummary(var)
var!0 = "time"
var&time := tso&time
; copy_VarMeta(tso, var)
printVarSummary(var)
;------output--------------
fon=diri+"E3SM_en"+ia+"_psl_"+yrstrt+"01-"+yrlast+"12.nc";
system("rm -f "+fon)
fo=addfile(fon,"c")
fo->psl = var

end do 
end 

