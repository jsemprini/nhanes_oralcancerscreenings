
*****recent exam by type******
clear all
foreach i in currentexam {
	
clear all 
use "C:\Users\jsemprini\OneDrive - University of Iowa\3-Preliminary\7-NHANES\final\oo_final\data\2011-2018nhanes_toanalyze.dta"

cd "C:\Users\jsemprini\OneDrive - University of Iowa\3-Preliminary\7-NHANES\final\oo_final\crude_results"

set more off
  quietly log
  local logon = r(status)
  if "`logon'" == "on" { 
	log close 
	}
log using Semprini_NHANES_subtype, replace text

global controls i.(age male hispanic white black nohs hsonly somecol married childless)

replace dentistexam=0 if `i'==0 | dentistexam!=1
replace doctorexam=0 if `i'==0 | doctorexam!=1
replace dhexam=0 if `i'==0 | dhexam!=1
replace npexam=0 if `i'==0 | npexam!=1
replace highexam=0 if `i'==0 | highexam!=1
replace lowexam=0 if `i'==0 | lowexam!=1

gen anydent=.
replace anydent=1 if dentistexam==1 | dhexam==1
replace anydent=0 if `i'==0
replace anydent=0 if dentistexam!=1 & dhexam!=1

gen anyphys=.
replace anyphys=1 if doctorexam==1 | npexam==1
replace anyphys=0 if `i'==0
replace anyphys=0 if doctorexam!=1 & npexam!=1

global outcomes dentistexam doctorexam 


***test design***
gen post=0
replace post=1 if svywave>=2015

gen treat=0
replace treat=1 if age<64

gen lowinc=0
replace lowinc=1 if fpl_pct<2

gen neweight=.
replace neweight=4203/17347 if svywave==2011
replace neweight=4461/17373 if svywave==2013
replace neweight=4369/17347 if svywave==2015
replace neweight=4314/17347 if svywave==2017

gen nwt=wt*neweight

gen cat1=1 if private==1
gen cat2=1 if medicare==1
gen cat3=1 if medicaid==1
gen cat4=1 if insured==0
gen cat5=1 if recent_dent==0
gen cat6=1 if recent_dent==1
gen cat7=1 if hc_lastyr==0
gen cat8=1 if hc_lastyr==1
gen cat9=1 if hpv_pos==0
gen cat10=1 if hpv_pos==1


foreach n of numlist 1/10{
foreach y in $outcomes{
    

eststo:	reg `y' i.lowinc i.post i.lowinc#i.post $controls [pw=nwt] if  cat`n'==1 &  treat==1 , vce(robust) 

sum `y' if e(sample) & post==0 & lowinc==1
estadd scalar mean1=r(mean)


	
}

}


}  


esttab using subtendo.csv, replace keep( 1.lowinc#1.post ) sca(mean1) b(3) se(3)

estimates clear
