*Conciliation vs update in beleifs

********************************************************************************

use "$directorio\DB\Seguimiento_Juntas.dta", clear
rename ao anio
rename expediente exp
merge m:1 junta exp anio using "$directorio\DB\predicciones.dta"

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


esttab using "$directorio\Effect\con_vs_update.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "mean Update var mean") replace 
	
