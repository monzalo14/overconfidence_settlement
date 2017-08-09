/*
Regressions of overconfidence (AMOUNT) on case characteristics (exogenous) 
*/


*************************************EMPLOYEE***********************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:1 folio using  "$sharelatex/Raw/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_a=A_5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_rel=rel_oc, nq(100)
drop if perc_rel>=98


rename A_7_3 repeat_worker



/***********************
       REGRESSIONS
************************/

eststo clear
		
eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	repeat_worker i.A_1_2 ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	i.A_6_1 ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	repeat_worker i.A_1_2 i.A_6_1 ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)


********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_ra=RA_5_5-comp_esp
gen rel_oc=oc_/comp_esp




/***********************
       REGRESSIONS
************************/


eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)


********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_rd=RD5_5-comp_esp
gen rel_oc=oc_/comp_esp




/***********************
       REGRESSIONS
************************/


eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

*************************

esttab using "$sharelatex\Tables\reg_results\oc_reg.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "OCMean OC_Mean" "OCSD OCSD") replace 
