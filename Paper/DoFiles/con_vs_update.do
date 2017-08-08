*Conciliation vs update in beleifs



********************************************************************************
	*PILOT 1
*************************************EMPLOYEE***********************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:1 folio using  "$sharelatex/Raw/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:1 folio using "$sharelatex/Raw/Merge_Actor_OC.dta", keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=99

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=abs((ES_1_4-comp_esp)/(A_5_5-comp_esp))


*Outliers
xtile perc_up=update_comp, nq(100)
drop if perc_up>=90


/***********************
       REGRESSIONS
************************/

eststo clear
		
eststo: reg seconcilio update_comp , robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar mean=r(mean)

eststo: reg seconcilio p_actor##c.update_comp , robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar mean=r(mean)




********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/Raw/Merge_Representante_Actor_OC.dta", keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=99

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=abs((ES_1_4-comp_esp)/(RA_5_5-comp_esp))


*Outliers
xtile perc_up=update_comp, nq(100)
drop if perc_up>=90


/***********************
       REGRESSIONS
************************/


eststo: reg seconcilio update_comp , robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar mean=r(mean)

eststo: reg seconcilio p_actor##c.update_comp , robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar mean=r(mean)





********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/Raw/Merge_Representante_Demandado_OC.dta", keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=99

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=abs((ES_1_4-comp_esp)/(RD5_5-comp_esp))


*Outliers
xtile perc_up=update_comp, nq(100)
drop if perc_up>=90



eststo: reg seconcilio update_comp , robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar mean=r(mean)

eststo: reg seconcilio p_actor##c.update_comp , robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar mean=r(mean)





*************************

esttab using "$sharelatex\Tables\reg_results\con_vs_update_1.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "mean Update var mean") replace 

	
	
	
	
********************************************************************************
********************************************************************************
********************************************************************************



	
********************************************************************************
	*PILOT 2
use "$scaleup\DB\Seguimiento_Juntas.dta", clear
rename ao anio
rename expediente exp
merge m:1 junta exp anio using "$scaleup\DB\predicciones.dta"

********************************************************************************

*Expected compensation
gen comp_esp=liq_total_laudo_avg

 
*Measure of update in beliefs employee:  |P-E_e|/|P-E_b|
gen update_comp_a=abs((ea9_cantidad_pago_s-comp_esp)/(ea2_cantidad_pago-comp_esp))

*Measure of update in beliefs employees's lawyer:  |P-E_e|/|P-E_b|
gen update_comp_ra=abs((era5_cantidad_pago_s-comp_esp)/(era2_cantidad_pago-comp_esp))

*Measure of update in beliefs firm's lawyer:  |P-E_e|/|P-E_b|
gen update_comp_rd=abs((erd5_cantidad_pago_s-comp_esp)/(erd2_cantidad_pago-comp_esp))

*Outliers
foreach var of varlist update_comp_* {
		xtile perc_`var'=`var', nq(100)
		replace `var'=. if perc_`var'>=90
		}

		
		
		
eststo clear

*Regression

eststo: reg convenio update_comp_a , robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su update_comp_a if e(sample)
estadd scalar mean=r(mean)
eststo: reg convenio p_actor##c.update_comp_a , robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su update_comp_a if e(sample)
estadd scalar mean=r(mean)


eststo: reg convenio update_comp_ra , robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su update_comp_ra if e(sample)
estadd scalar mean=r(mean)
eststo: reg convenio p_actor##c.update_comp_ra , robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su update_comp_ra if e(sample)
estadd scalar mean=r(mean)


eststo: reg convenio update_comp_rd , robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su update_comp_rd if e(sample)
estadd scalar mean=r(mean)
eststo: reg convenio p_actor##c.update_comp_rd , robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su update_comp_rd if e(sample)
estadd scalar mean=r(mean)


esttab using "$sharelatex\Tables\reg_results\con_vs_update_2.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "mean Update var mean") replace 
	
