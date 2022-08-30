****preliminary summary statistics****
clear all

use "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\statadata\2011-2018nhanes_toanalyze.dta"




clear all

use "C:\Users\jsemprini\OneDrive - University of Iowa\3-Preliminary\7-NHANES\final\oo_final\data\2011-2018nhanes_toanalyze.dta"

cd "C:\Users\jsemprini\OneDrive - University of Iowa\3-Preliminary\7-NHANES\final\oo_final\crude_graphs"

global controls i.(age male hispanic white black nohs hsonly somecol married childless)

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

foreach i in $outcomes{
	
	tab svywave `i', missing
}



***test design***
gen post=0
replace post=1 if svywave>=2015

gen treat=0
replace treat=1 if age<64

gen lowinc=0
replace lowinc=1 if fpl_pct<2

***regression***
***DD***
eststo clear 

gen cat1=1 if treat==0 & lowinc==0
gen cat2=1 if treat==0 & lowinc==1
gen cat3=1 if treat==1 & lowinc==0
gen cat4=1 if treat==1 & lowinc==1

tab svywave, gen(year)

foreach y in $p_outcomes{
foreach i of numlist 1/4{
    
reg recentexam i.(year*) [pw=nwt] if cat`i'==1 , vce(robust) nocons
estimates store store`i'
	
}

coefplot store1 store2 store3 store4, vertical  xtitle("Year") ytitle("Pr(A Recent Oral Cancer Screen)") title("Year-by-Year Oral Cancer Screening Rates (any provider)", size(small))   fcolor(*.5) ciopts(recast(rcap))  nolabels recast(line) offset(0) ylabel(0(0.2)1) yscale(range(0(0.2)1)) rename(1.year1 = "2011" 1.year2 = "2013" 1.year3 = "2015" 1.year4 = "2017" 1.ses5 = "5") 


graph save f1_`y'.gph, replace

estimates clear

}




