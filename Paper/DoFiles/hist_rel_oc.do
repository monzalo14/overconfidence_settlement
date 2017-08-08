/*
HISTOGRAM OF RELATIVE OVERCONFIDENCE
*/

********************************************************************************
********************************************************************************
************************************AMOUNT**************************************
********************************************************************************
********************************************************************************


*************************************EMPLOYEE***********************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:1 folio using  "$sharelatex/Raw/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_a=A_5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_rel=rel_oc, nq(100)
drop if perc_rel>=98

qui su rel_oc
twoway (hist rel_oc, percent w(3) ) ///
		(scatteri 0 `r(mean)' 60 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) ) , ///
		scheme(s2mono) graphregion(color(none)) legend(off) ytitle("Percent") ///
		title("Employee OC (Amount)") name(emp, replace)

********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen

*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_ra=RA_5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_rel=rel_oc, nq(100)
drop if perc_rel>=98

qui su rel_oc
twoway (hist rel_oc, percent w(3) ) ///
		(scatteri 0 `r(mean)' 60 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) ) , ///
		scheme(s2mono) graphregion(color(none)) legend(off) ytitle("Percent") ///
		title("Employee's Lawyer OC (Amount)") name(emplaw, replace)


********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen

*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_rd=RD5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_rel=rel_oc, nq(100)
drop if perc_rel>=98

qui su rel_oc
twoway (hist rel_oc, percent w(3) ) ///
		(scatteri 0 `r(mean)' 80 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) ) , ///
		scheme(s2mono) graphregion(color(none)) legend(off) ytitle("Percent") ///
		xtitle("Relative OC") title("Firm's Lawyer OC (Amount)") name(firlaw, replace)

		
***************************		
graph combine emp emplaw firlaw, cols(1) xcommon ///
	graphregion(color(none)) scheme(s2mono) name(amt, replace)		

	
	
********************************************************************************
********************************************************************************
*************************************PROB***************************************
********************************************************************************
********************************************************************************


*************************************EMPLOYEE***********************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:1 folio using  "$sharelatex/Raw/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen

*Regression with crossed effect overconfidence
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

rename A_5_1 Prob_win

gen oc_=Prob_win-Prob_win_calc
gen rel_oc=oc_/Prob_win_calc

qui su rel_oc
twoway (hist rel_oc, percent w(1.5) ) ///
		(scatteri 0 `r(mean)' 40 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) ) , ///
		scheme(s2mono) graphregion(color(none)) legend(off) ytitle("Percent") ///
		title("Employee OC (Prob)") name(emp, replace)

********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen

*Regression with crossed effect overconfidence
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

rename RA_5_1 Prob_win

gen oc_=Prob_win-Prob_win_calc
gen rel_oc=oc_/Prob_win_calc

qui su rel_oc
twoway (hist rel_oc, percent w(1.5) ) ///
		(scatteri 0 `r(mean)' 40 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) ) , ///
		scheme(s2mono) graphregion(color(none)) legend(off) ytitle("Percent") ///
		title("Employee's Lawyer OC (Prob)") name(emplaw, replace)


********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen

*Regression with crossed effect overconfidence
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

rename RD5_1_1 Prob_win

gen oc_=Prob_win-Prob_win_calc
gen rel_oc=oc_/Prob_win_calc

qui su rel_oc
twoway (hist rel_oc, percent w(1.5) ) ///
		(scatteri 0 `r(mean)' 50 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) ) , ///
		scheme(s2mono) graphregion(color(none)) legend(off) ytitle("Percent") ///
		xtitle("Relative OC") title("Firm's Lawyer OC (Prob)") name(firlaw, replace)

		
***************************		
graph combine emp emplaw firlaw, cols(1) xcommon ///
	graphregion(color(none)) scheme(s2mono) name(prob, replace)		

	
******************************************************	
graph combine amt prob, rows(1) ycommon	///
	graphregion(color(none)) scheme(s2mono) 
graph export "$sharelatex/Figuras/hist_rel_oc.pdf", replace 
		
