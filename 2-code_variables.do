****keep and code variables for prelimineary analysis****

clear all

use "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\statadata\2011-2018nhanes.dta"

keep svywave ohq614 ohq880 ohq895 ohq900 ohq030 ohq033 ohq770 ohq780* ohq610 ohq612 ohq845 ohq848g dmdcitzn	dmdeduc2	dmdeduc3	dmdfmsiz	dmdhhsiz	dmdhhsza	dmdhhszb	dmdhhsze	dmdhragz	dmdhredz	dmdhrgnd	dmdhrmaz	dmdhsedz	dmdmartl	dmdyrsus	dmqmiliz	fiaintrp	indfmin2	indfmpir	indhhin2	riagendr	ridagemn	ridageyr	ridexagm	ridexmon	ridexprg	ridreth1	ridreth3	ridstatr	sddsrvyr	sdmvpsu	sdmvstra	seqn	siaintrp	sialang	siaproxy	wtint2yr	wtmec2yr ohx* ohd* oha* alq* hsd010 hiq* ind* orxg* orxh* smq681 smdany smq020 smq040



order svywave ohq614 ohq880 ohq895 ohq900 ohq030 

tab ohq614 svywave, missing
tab ohq880 svywave, missing
tab ohq895 svywave, missing
tab ohq900 svywave, missing

gen talkoc=.
replace talkoc=0 if ohq614==2
replace talkoc=1 if ohq614==1

gen examoc=.
replace examoc=0 if ohq880==2
replace examoc=1 if ohq880==1

gen currentexam=.
replace currentexam=0 if ohq895>1 & ohq895<=3
replace currentexam=1 if ohq895==1

gen recentexam=. 
replace recentexam=0 if ohq895>=3
replace recentexam=1 if ohq895==1 | ohq895==2

gen doctorexam=.
replace doctorexam=0 if ohq900!=1 & ohq900!=. & ohq900<5
replace doctorexam=1 if ohq900==1

gen npexam=.
replace npexam=0 if ohq900!=2 & ohq900!=. & ohq900<5
replace npexam=1 if ohq900==2

gen dentistexam=.
replace dentistexam=0 if ohq900!=3 & ohq900!=. & ohq900<5
replace dentistexam=1 if ohq900==3

gen dhexam=. 
replace dhexam=0 if ohq900!=4 & ohq900!=. & ohq900<5
replace dhexam=1 if ohq900==4

gen highexam=.
replace highexam=0 if dhexam==1 | npexam==1
replace highexam=1 if dentistexam==1 | doctorexam==1

gen lowexam=.
replace lowexam=0 if dentistexam==1 | doctorexam==1
replace lowexam=1 if highexam==0


keep svywave riagendr ridageyr ridreth1 ridreth3 dmdeduc2 dmdmartl ridexprg wtint2yr sdmvpsu sdmvstra indhhin2 indfmin2 indfmpir dmdhhsiz dmdfmsiz dmdhhsza dmdhhszb dmdhhsze alq130 alq151 hiq011 hiq031a hiq031b hiq031d hiq031aa hiq210 hsd010 ohq845 ohdexsts ohdrcsts oharec oharocdt orxgh orxgl orxhpv smq020 smq040 talkoc examoc currentexam recentexam doctorexam npexam dentistexam dhexam highexam lowexam ohq030 ohq895

drop if ridageyr<30 
drop if ridageyr==80

drop ridexprg

order svywave wtint2yr sdmvpsu sdmvstra

gen male=.
replace male=0 if riagendr==2
replace male=1 if riagendr==1

gen age=ridageyr

gen hispanic=. 
replace hispanic=0 if ridreth3!=1 & ridreth3!=2
replace hispanic=1 if ridreth3==1 | ridreth3==2

gen white=.
replace white=0 if ridreth3!=3 & ridreth3<7 & ridreth3!=.
replace white=1 if ridreth3==3

gen black=.
replace black=0 if ridreth3!=4 & ridreth3<7 & ridreth3!=.
replace black=1 if ridreth3==4

gen asian=.
replace asian=0 if ridreth3!=6 & ridreth3<7 & ridreth3!=.
replace asian=1 if ridreth3==6

gen otherrace=.
replace otherrace=0 if ridreth3!=7 & ridreth3!=.
replace otherrace=1 if ridreth3==7


gen nohs=.
replace nohs=0 if dmdeduc2>=3 & dmdeduc2<7 & dmdeduc2!=.
replace nohs=1 if dmdeduc2==1 | dmdeduc2==2

gen hsonly=. 
replace hsonly=0 if dmdeduc2!=3 & dmdeduc2<7 & dmdeduc2!=.
replace hsonly=1 if dmdeduc2==3

gen somecol=.
replace somecol=0 if dmdeduc2!=4 & dmdeduc2<7 & dmdeduc2!=.
replace somecol=1 if dmdeduc2==4

gen college=.
replace college=0 if dmdeduc2!=5 & dmdeduc2<7 & dmdeduc2!=.
replace college=1 if dmdeduc2==5

gen married=.
replace married=0 if dmdmartl!=1 & dmdmartl!=. & dmdmartl<77
replace married=1 if dmdmartl==1

gen fpl_pct=indfmpir

gen childless=.
replace childless=0 if dmdhhsza!=0 | dmdhhszb!=0
replace childless=1 if dmdhhsza==0 & dmdhhszb==0

gen binge=.
replace binge=0 if alq151==2
replace binge=1 if alq151==1

gen insured=.
replace insured=0 if hiq011==2
replace insured=1 if hiq011==1

gen private=.
replace private=0 if insured!=. & hiq031a!=14
replace private=1 if hiq031a==14

gen medicare=.
replace medicare=0 if insured!=. & hiq031b!=15
replace medicare=1 if hiq031b==15

gen medicaid=.
replace medicaid=0 if insured!=. & hiq031d!=17
replace medicaid=1 if hiq031d==17

gen uninsure_yr=.
replace uninsure_yr=0 if hiq210==2
replace uninsure_yr=1 if hiq210==1

gen genhealth=.
replace genhealth=1 if hsd010==5
replace genhealth=2 if hsd010==4
replace genhealth=3 if hsd010==3
replace genhealth=4 if hsd010==2
replace genhealth=5 if hsd010==1

gen goodhealth=.
replace goodhealth=0 if genhealth<4
replace goodhealth=1 if genhealth>=4

gen poorhealth=.
replace poorhealth=0 if genhealth!=1
replace poorhealth=1 if genhealth==1

gen hpv_pos=.
replace hpv_pos=0 if orxhpv==2
replace hpv_pos=1 if orxhpv==1

gen pastsmoker=.
replace pastsmoker=0 if smq020==2 & smq040==2
replace pastsmoker=1 if smq020==1

gen currentsmoker=. 
replace currentsmoker=0 if smq040==2
replace currentsmoker=1 if smq040==1


gen dentalvisit_1=.
replace dentalvisit_1=0 if ohq030!=1 & ohq030!=2 & ohq030!=. & ohq030<77
replace dentalvisit_1=1 if ohq030==1 | ohq030==2

gen dentalvisit_2=.
replace dentalvisit_2=0 if ohq030!=3 & ohq030!=. & ohq030<77
replace dentalvisit_2=1 if ohq030==3

gen dentalvisit_3=.
replace dentalvisit_3=0 if ohq030!=4 & ohq030!=. & ohq030<77
replace dentalvisit_3=1 if ohq030==4

gen dentalvisit_5=.
replace dentalvisit_5=0 if ohq030!=5 & ohq030!=. & ohq030<77
replace dentalvisit_5=1 if ohq030==5

gen dentalvisit_never=.
replace dentalvisit_never=0 if ohq030!=7 & ohq030!=. & ohq030<77
replace dentalvisit_never=1 if ohq030==7

gen ocexam_1=. 
replace ocexam_1=0 if ohq895!=1 & ohq895<7 & ohq895!=.
replace ocexam_1=1 if ohq895==1

gen recent_dent=.
replace recent_dent=0 if dentalvisit_1==0 & dentalvisit_2==0
replace recent_dent=1 if dentalvisit_1==1 | dentalvisit_2==1

keep svywave wtint2yr sdmvpsu sdmvstra talkoc examoc currentexam recentexam doctorexam npexam dentistexam dhexam highexam lowexam male age hispanic white black asian otherrace nohs hsonly somecol college married fpl_pct childless binge insured private medicare medicaid uninsure_yr genhealth goodhealth poorhealth hpv_pos pastsmoker currentsmoker dentalvisit_1 dentalvisit_2 dentalvisit_3 dentalvisit_5 dentalvisit_never ocexam_1 recent_dent

save "C:\Users\jsemprini\Documents\7-NHANES\0-prelim\statadata\2011-2018nhanes_toanalyze.dta", replace


