/*Overconfidence plots*/

************************************Employee************************************
use  "$sharelatex\DB\pilot_casefiles.dta", clear
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor) nogen
merge m:1 folio using "$sharelatex/Raw/Append Encuesta Inicial Actor.dta", keep(2 3) nogen

replace seconcilio=0 if seconcilio==.
duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=99

*We keep calculator treatment arm 
keep if tratamientoquelestoco==2

	*Money
gen diff_amount=(A_5_5-exp_comp)/1000

qui su diff_amount

twoway (hist diff_amount if diff_amount<160 & diff_amount>=-50 , w(10) percent) ///
		(scatteri 0 `r(mean)' 20 `r(mean)', c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
		, scheme(s2mono) graphregion(color(none)) ///
	title("Difference in expectation (amount)") xtitle("Difference in thousand pesos") ///
	legend(off)
graph export "$sharelatex/Figuras/difference_amount_employee.pdf", replace 


	*Probability
rename A_5_1 Prob_win
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

gen diff_prob=Prob_win-Prob_win_calc

qui su diff_prob

twoway (hist diff_prob, w(10) percent) ///
		(scatteri 0 `r(mean)' 20 `r(mean)', c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
		, scheme(s2mono) graphregion(color(none)) ///
	title("Difference in expectation (probability)") xtitle(" ") ///
	legend(off)
graph export "$sharelatex/Figuras/difference_prob_employee.pdf", replace 
	


************************************Employe's Lawyer****************************
use  "$sharelatex\DB\pilot_casefiles.dta", clear
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor) nogen
merge m:m folio using "$sharelatex/Raw/Append Encuesta Inicial Representante Actor.dta", keep(2 3) nogen

replace seconcilio=0 if seconcilio==.
duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=99

*We keep calculator treatment arm 
keep if tratamientoquelestoco==2

gen diff_amount=(RA_5_5-exp_comp)/1000

qui su diff_amount

twoway (hist diff_amount if diff_amount<160 & diff_amount>=-50 , w(10) percent) ///
		(scatteri 0 `r(mean)' 20 `r(mean)', c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
		, scheme(s2mono) graphregion(color(none)) ///
	title("Difference in expectation (amount)") xtitle("Difference in thousand pesos") ///
	legend(off)
graph export "$sharelatex/Figuras/difference_amount_employeelawyer.pdf", replace 

	*Probability
rename RA_5_1 Prob_win
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

gen diff_prob=Prob_win-Prob_win_calc

qui su diff_prob

twoway (hist diff_prob, w(10) percent) ///
		(scatteri 0 `r(mean)' 20 `r(mean)', c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
		, scheme(s2mono) graphregion(color(none)) ///
	title("Difference in expectation (probability)") xtitle(" ") ///
	legend(off)
graph export "$sharelatex/Figuras/difference_prob_employeelawyer.pdf", replace 


************************************Firm's Lawyer*******************************
use  "$sharelatex\DB\pilot_casefiles.dta", clear
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor) nogen
merge m:m folio using "$sharelatex/Raw/Append Encuesta Inicial Representante Demandado.dta", keep(2 3) nogen

replace seconcilio=0 if seconcilio==.
duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=99

*We keep calculator treatment arm 
keep if tratamientoquelestoco==2

gen diff_amount=(RD5_5-exp_comp)/1000

qui su diff_amount

twoway (hist diff_amount if diff_amount<160 & diff_amount>=-50 , w(10) percent) ///
		(scatteri 0 `r(mean)' 20 `r(mean)', c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
		, scheme(s2mono) graphregion(color(none)) ///
	title("Difference in expectation (amount)") xtitle("Difference in thousand pesos") ///
	legend(off)
graph export "$sharelatex/Figuras/difference_amount_firmlawyer.pdf", replace 

	*Probability
rename RD5_1_1 Prob_win
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100
		
gen diff_prob=Prob_win-Prob_win_calc

qui su diff_prob

twoway (hist diff_prob, w(10) percent) ///
		(scatteri 0 `r(mean)' 20 `r(mean)', c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
		, scheme(s2mono) graphregion(color(none)) ///
	title("Difference in expectation (probability)") xtitle(" ") ///
	legend(off)
graph export "$sharelatex/Figuras/difference_prob_firmlawyer.pdf", replace 
