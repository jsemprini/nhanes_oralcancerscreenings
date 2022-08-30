

*****recent exam by type******
clear all
foreach i in  currentexam  {
	clear all
	
use "C:\Users\jsemprini\OneDrive - University of Iowa\3-Preliminary\7-NHANES\final\oo_final\data\2011-2018nhanes_toanalyze.dta"

cd "C:\Users\jsemprini\OneDrive - University of Iowa\3-Preliminary\7-NHANES\final\oo_final\crude_graphs"


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

global outcomes dentistexam anydent doctorexam anyphys highexam lowexam


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



***regression***
***DD***
eststo clear 

***regression***
***DD***
eststo clear 

gen cat1=1 if treat==0 & lowinc==0
gen cat2=1 if treat==0 & lowinc==1
gen cat3=1 if treat==1 & lowinc==0
gen cat4=1 if treat==1 & lowinc==1

tab svywave, gen(year)

foreach y in $outcomes{
foreach x of numlist 1/4{
    
reg `y' i.(year*) [pw=wt] if cat`x'==1 , vce(robust) nocons
estimates store store`x'
	
}

coefplot store1 store2 store3 store4, vertical  xtitle("Year") ytitle("Pr(A Recent Oral Cancer Screen)") title("Year-by-Year Oral Cancer Screening Rates (`y')", size(small))   fcolor(*.5) ciopts(recast(rcap))  nolabels recast(line) offset(0) ylabel(0(0.1).4) yscale(range(0(0.1).4)) rename(1.year1 = "2011" 1.year2 = "2013" 1.year3 = "2015" 1.year4 = "2017") 


graph save f2`y'.gph, replace

}

}

graph combine f2anyphys.gph f2anydent.gph f2highexam.gph, ycommon

graph save f2_final, replace

****graph combine f2danyphys.gph f2anydent.gph f2highexam.gph f2lowexam.gph, ycommon




