****preliminary summary statistics****
clear all

use "C:\Users\jsemprini\OneDrive - University of Iowa\3-Preliminary\7-NHANES\final\oo_final\data\2011-2018nhanes_toanalyze.dta"

cd "C:\Users\jsemprini\OneDrive - University of Iowa\3-Preliminary\7-NHANES\final\oo_final\crude_graphs"


set more off
  quietly log
  local logon = r(status)
  if "`logon'" == "on" { 
	log close 
	}
log using Semprini_NHANES_anysens, replace text


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

foreach i in $outcomes{
	
	tab svywave `i', missing
}



***design***
gen post=0
replace post=1 if svywave>=2015

gen treat=0
replace treat=1 if age<64

gen lowinc=0
replace lowinc=1 if fpl_pct<2



foreach n of numlist .5 .6 .7 .8 .9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.1 4.2 4.3 4.4 4.5{
	
	drop lowinc
	gen lowinc=0
	replace lowinc=1 if fpl_pct<`n'
    

foreach i in $p_outcomes{
    

eststo:	reg `i' i.lowinc i.post i.lowinc#i.post $controls [pw=nwt] , vce(robust) 

	
}

}

esttab using sens1.csv , keep(1.lowinc#1.post) replace

estimates clear

foreach n of numlist .5 .6 .7 .8 .9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.1 4.2 4.3 4.4 4.5{
	
	drop lowinc
	gen lowinc=0
	replace lowinc=1 if fpl_pct<`n'
    

foreach i in $p_outcomes{
    

eststo:	reg `i' i.lowinc i.post i.lowinc#i.post $controls [pw=nwt] if treat==0 , vce(robust) 
	
}

}

esttab using sens2.csv , keep(1.lowinc#1.post)  replace

estimates clear


foreach n of numlist .5 .6 .7 .8 .9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.1 4.2 4.3 4.4 4.5{
	
	drop lowinc
	gen lowinc=0
	replace lowinc=1 if fpl_pct<`n'
    


foreach i in $p_outcomes{
    

 
eststo:	reg `i' i.lowinc i.post i.lowinc#i.post $controls [pw=nwt] if treat==1 , vce(robust) 
 


	
}

}

esttab using sens3.csv , keep(1.lowinc#1.post) replace

estimates clear


foreach n of numlist .5 .6 .7 .8 .9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.1 4.2 4.3 4.4 4.5{
	
	drop lowinc
	gen lowinc=0
	replace lowinc=1 if fpl_pct<`n'
    


foreach i in $p_outcomes{
    
 
 
eststo:	reg `i' i.treat i.post i.treat#i.post i.lowinc i.lowinc#i.treat i.lowinc#i.post i.lowinc#i.treat#i.post $controls [pw=nwt], vce(robust) 


	
}

}

esttab using sens4.csv , keep(1.lowinc#1.treat#1.post) replace

estimates clear

