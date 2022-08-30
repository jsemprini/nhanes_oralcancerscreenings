****NHANES Import: 2011-2012, 2013-2014, 2015-2016, 2017-2018****
cd "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\rawdata\2011-2012"

clear all

clear
local myfilelist : dir . files"*.xpt"
foreach file of local myfilelist {
drop _all
import sasxport5 `file', clear
local outfile = subinstr("`file'",".csv","",.)
save "`outfile'.dta", replace
}


cd "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\rawdata\2013-2014"

clear all

clear
local myfilelist : dir . files"*.xpt"
foreach file of local myfilelist {
drop _all
import sasxport5 `file', clear
local outfile = subinstr("`file'",".csv","",.)
save "`outfile'.dta", replace
}

cd "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\rawdata\2015-2016"

clear all

clear
local myfilelist : dir . files"*.xpt"
foreach file of local myfilelist {
drop _all
import sasxport5 `file', clear
local outfile = subinstr("`file'",".csv","",.)
save "`outfile'.dta", replace
}

cd "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\rawdata\2017-2018"

clear all

clear
local myfilelist : dir . files"*.xpt"
foreach file of local myfilelist {
drop _all
import sasxport5 `file', clear
local outfile = subinstr("`file'",".csv","",.)
save "`outfile'.dta", replace
}

clear all
*****Merge each year******
cd "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\rawdata\2011-2012"
clear all

use "demo_g.xpt.dta"


local satafiles: dir . files "*.dta"
foreach file of local satafiles { 

merge m:m seqn using `file', nogenerate



}

gen svywave=2011

save "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\statadata\20112012_nhanes.dta", replace

cd "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\rawdata\2013-2014"

clear all

use "demo_h.xpt.dta"


local satafiles: dir . files "*.dta"
foreach file of local satafiles { 

merge m:m seqn using `file', nogenerate


}
gen svywave=2013

save "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\statadata\20132014_nhanes.dta", replace


cd "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\rawdata\2015-2016"

clear all

use "demo_i.xpt.dta"


local satafiles: dir . files "*.dta"
foreach file of local satafiles { 

merge m:m seqn using `file', nogenerate


}

gen svywave=2015

save "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\statadata\20152016_nhanes.dta", replace

cd "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\rawdata\2017-2018"

clear all

use "demo_j.xpt.dta"


local satafiles: dir . files "*.dta"
foreach file of local satafiles { 

merge m:m seqn using `file', nogenerate


}

gen svywave=2017

save "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\statadata\20172018_nhanes.dta", replace

clear all

***append all years together***

local satafiles: dir . files "*.dta"
foreach file of local satafiles { 

preserve
use `file', clear
gen filename2 =  regexr("`file'", "_.20", "")



save temp, replace
restore
append using temp, force
}
erase temp.dta

subsave using "nhanes.dta", replace

save