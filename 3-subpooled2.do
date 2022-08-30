****preliminary summary statistics****
clear all

use "C:\Users\jsemprini\OneDrive - University of Iowa\3-Preliminary\7-NHANES\final\oo_final\data\2011-2018nhanes_toanalyze.dta"

cd "C:\Users\jsemprini\OneDrive - University of Iowa\3-Preliminary\7-NHANES\final\oo_final\crude_results"


set more off
  quietly log
  local logon = r(status)
  if "`logon'" == "on" { 
	log close 
	}
log using Semprini_NHANES_anysub, replace text


global controls i.(age male hispanic white black nohs hsonly somecol married childless)

gen ui=0 if insured==1
replace ui=1 if insured==0

global other_outcomes ui medicaid private medicare dentalvisit_1 hc_visit1 hc_lastyr routcare

global p_outcomes currentexam

tab svywave examoc_t, missing

tab hc_visit1, missing

gen neweight=.
replace neweight=4203/17347 if svywave==2011
replace neweight=4461/17373 if svywave==2013
replace neweight=4369/17347 if svywave==2015
replace neweight=4314/17347 if svywave==2017

gen nwt=wt*neweight
gen wt4=wt/4




***design***
gen post=0
replace post=1 if svywave>=2015

gen treat=0
replace treat=1 if age<64

gen lowinc=0
replace lowinc=1 if fpl_pct<2
***DD***

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

estimates clear 
foreach x of numlist 1/10{

foreach i in $p_outcomes{
    

eststo:	reg `i' i.lowinc i.post i.lowinc#i.post $controls [pw=nwt] if  cat`x'==1  & treat==1 , vce(robust) 

sum `i' if e(sample) & post==0 & lowinc==1
estadd scalar mean1=r(mean)


	
}

}




	

esttab using sub1finalendo.csv, replace keep(1.lowinc#1.post) sca(mean1) b(3) se(3) 





estimates clear 

    