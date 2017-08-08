/*Summary statistics table for update in beliefs measure as a relative difference*/


********************************************************************************
	*PILOT 1
*Employee
use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:1 folio using "$sharelatex/Raw/Merge_Actor_OC.dta", keep(2 3) nogen
rename ES_fecha fecha

merge 1:1 folio fecha using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio)

*Cleaning
foreach var of varlist ES_1_4 A_5_5 {
	qui xtile perc_`var'=`var', n(99)
	qui su `var'
	replace `var'=. if perc_`var'>=99 
	}
	

*Measure of update in beliefs:  (E_e-E_b)/E_b
gen diff=(ES_1_4-A_5_5)
qui xtile perc_diff=diff, n(99)
replace diff=. if perc_diff>=95

gen update_emp=diff/A_5_5
qui xtile perc_update=update, n(99)
replace update=. if perc_update>=90


drop if tratamientoquelestoco==0
keep update tratamientoquelestoco

tempfile emp
save `emp'

*Employee's Lawyer
use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using "$sharelatex/Raw/Merge_Representante_Actor_OC.dta", keep(2 3) nogen
rename ES_fecha fecha

merge m:1 folio fecha using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio)
duplicates drop folio fecha tratamientoquelestoco, force

*Cleaning
foreach var of varlist ES_1_4 RA_5_5 {
	qui xtile perc_`var'=`var', n(99)
	qui su `var'
	replace `var'=. if perc_`var'>=99 
	}
	

*Measure of update in beliefs:  (E_e-E_b)/E_b
gen diff=(ES_1_4-RA_5_5)
qui xtile perc_diff=diff, n(99)
replace diff=. if perc_diff>=95

gen update_emp_law=diff/RA_5_5
qui xtile perc_update=update, n(99)
replace update=. if perc_update>=90


drop if tratamientoquelestoco==0
keep update tratamientoquelestoco

tempfile emp_law
save `emp_law'

*Firm's Lawyer
use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using "$sharelatex/Raw/Merge_Representante_Demandado_OC.dta", keep(2 3) nogen
rename ES_fecha fecha

merge m:1 folio fecha using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio)
duplicates drop folio fecha tratamientoquelestoco, force

*Cleaning
foreach var of varlist ES_1_4 RD5_5 {
	qui xtile perc_`var'=`var', n(99)
	qui su `var'
	replace `var'=. if perc_`var'>=99 
	}
	

*Measure of update in beliefs:  (E_e-E_b)/E_b
gen diff=(ES_1_4-RD5_5)
qui xtile perc_diff=diff, n(99)
replace diff=. if perc_diff>=95

gen update_fir_law=diff/RD5_5
qui xtile perc_update=update, n(99)
replace update=. if perc_update>=95


drop if tratamientoquelestoco==0
keep update tratamientoquelestoco

append using `emp'
append using `emp_law'

********************************************************************************

label variable update_emp "Amount employee"
label variable update_emp_law "Amount employee's lawyer"
label variable update_fir_law "Amount firm's lawyer"

*Update in beleifs
sutex update_emp update_emp_law update_fir_law, digits(2) labels nobs   ///
	file("$sharelatex\Tables\update_beleif_1.tex") replace ///
	title("Pilot") 

	
	
********************************************************************************
********************************************************************************
********************************************************************************

	
	
********************************************************************************
	*PILOT 2	
use "$scaleup\DB\Seguimiento_Juntas.dta", clear

********************************************************************************

label variable update_pago_a "Amount employee"
label variable update_pago_ra "Amount employee's lawyer"
label variable update_pago_rd "Amount firm's lawyer"

label variable update_prob_a "Prob employee"
label variable update_prob_ra "Prob employee's lawyer"
label variable update_prob_rd "Prob firm's lawyer"

*Update in beleifs
sutex update_*, digits(2) labels  nobs   ///
	file("$sharelatex\Tables\update_beleif_2.tex") replace ///
	title("Scale Up") 
	
