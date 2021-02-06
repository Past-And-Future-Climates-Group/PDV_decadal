begin

diri = "./"
diri0 = "./"

;https://psl.noaa.gov/thredds/fileServer/Datasets/E3SM_LE/en1/atm/TS.1973-10.nc ;HTTPServer  --> X
;https://psl.noaa.gov/thredds/dodsC/Datasets/E3SM_LE/en1/atm/TS.1973-10.nc ;OPENDAP --> V

EN = (/1,2,3,4,13,14,15,16,17,18,19,20/)

do ia = 1,20

url = "https://psl.noaa.gov/thredds/dodsC/Datasets/E3SM_LE/en"+ia+"/atm/"
filename = "TS.*.nc"
filename0 = "TS.1973-10.nc"


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

system("rm download_e3sm_ens"+ia+"_https.txt")

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

      ;https://psl.noaa.gov/thredds/fileServer/Datasets/E3SM_LE/en1/atm/TS.1862-02.nc
      f2 = (/"https://psl.noaa.gov/thredds/fileServer/Datasets/E3SM_LE/en",tostring(ia)\
            ,"/atm/",tostring(fname(ix*12+iy)) /)
      new2 = str_concat(f2)
      write_table("download_e3sm_ens"+ia+"_https.txt", "a", \
                  [/new2/], "%s")

    end do 
end do 


end do 
end 

