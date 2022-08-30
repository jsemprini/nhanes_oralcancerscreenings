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
log using Semprini_NHANES_summary, replace text


global controls i.(male white hispanic black nohs hsonly somecol married childless)

gen ui=0 if insured==1
replace ui=1 if insured==0

global other_outcomes ui medicaid private medicare dentalvisit_1 hc_visit1 hc_lastyr routcare

global p_outcomes examoc_t recentexam currentexam talkoc

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

gen cat1=1 if treat==0 & lowinc==0
gen cat2=1 if treat==0 & lowinc==1
gen cat3=1 if treat==1 & lowinc==0
gen cat4=1 if treat==1 & lowinc==1

global sumgroups male white hispanic black nohs hsonly somecol married childless



*****recent exam by type******
foreach i in currentexam {

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


}

global outcomes currentexam doctorexam dentistexam anyphys anydent npexam dhexam highexam lowexam


eststo:	reg currentexam i.treat i.post i.treat#i.post i.lowinc i.lowinc#i.treat i.lowinc#i.post i.lowinc#i.treat#i.post $controls [pw=nwt], vce(robust) 

gen kept=1 if e(sample)
foreach n of numlist 1/4{


eststo: mean $outcomes $sumgroups [pweight=nwt] if cat`n'==1 & svywave<=2013 & kept==1
eststo: mean $outcomes $sumgroups  [pweight=nwt] if cat`n'==1 & svywave>=2015 & kept==1

esttab using summary`n'.csv,  nostar nonote nomtitle nonumber replace 

estimates clear

}
