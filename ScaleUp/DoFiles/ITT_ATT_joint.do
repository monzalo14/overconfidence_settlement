********************************************************************************
import delimited "$directorio\DB\seguimiento_joint.csv", clear 

drop junta_2
drop v1
*Necesito una variable que indiue junta

*Presence of parts
foreach var of varlist p_* {
	replace `var'=1 if !missing(`var') & `var'>1
	}
********************************************************************************


/***********************
       REGRESSIONS
************************/



********************************************************************************	


*ITT

eststo clear

*ITT
eststo: reg convenio tratamiento, robust 
estadd scalar Erre=e(r2)

eststo: reg convenio tratamiento junta_* notificado , robust 
estadd scalar Erre=e(r2)

eststo: reg convenio tratamiento##p_actor junta_* notificado , robust 
estadd scalar Erre=e(r2)

eststo: reg convenio tratamiento##c.num_conciliadores junta_* notificado , robust 
estadd scalar Erre=e(r2)


keep if piloto_1==0

*ATT
gen calcu_a_x_ep=calcu_p_actora*p_actor
gen calcu_d_x_ep=calcu_p_dem*p_actor

gen dt_x_ep=tratamiento*p_actor


	*PLAINTIFF
eststo: ivreg convenio junta_*  notificado ///
	(calcu_p_actora = tratamiento  ) ///
	, robust 
estadd scalar Erre=e(r2)

eststo: ivreg convenio junta_* notificado ///
	(calcu_p_actora calcu_a_x_ep =  tratamiento dt_x_ep) ///
	, robust 
estadd scalar Erre=e(r2)

	*DEFENDANT
eststo: ivreg convenio junta_*  notificado ///
	(calcu_p_dem = tratamiento  ) ///
	, robust 
estadd scalar Erre=e(r2)

eststo: ivreg convenio junta_* notificado ///
	(calcu_p_dem calcu_d_x_ep =  tratamiento dt_x_ep) ///
	, robust
estadd scalar Erre=e(r2)


esttab using "$directorio\Effect\ITT_ATT_joint.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" ) replace 

******************************************	
	
*First Stage

eststo clear

	*PLAINTIFF
eststo: reg calcu_p_actora tratamiento junta_*  notificado ///
	if convenio!=.  ///
	, robust 
estadd scalar Erre=e(r2)

eststo: reg calcu_p_actora tratamiento dt_x_ep junta_*  notificado ///
	if convenio!=.  ///
	, robust 
estadd scalar Erre=e(r2)

eststo: reg calcu_a_x_ep tratamiento dt_x_ep junta_*  notificado ///
	if convenio!=.  ///
	, robust 
estadd scalar Erre=e(r2)

	*DEFENDANT
eststo: reg calcu_p_dem tratamiento junta_*  notificado ///
	if convenio!=.  ///
	, robust 
estadd scalar Erre=e(r2)

eststo: reg calcu_p_dem tratamiento dt_x_ep junta_*  notificado ///
	if convenio!=.  ///
	, robust 
estadd scalar Erre=e(r2)

eststo: reg calcu_d_x_ep tratamiento dt_x_ep junta_*  notificado ///
	if convenio!=.  ///
	, robust 
estadd scalar Erre=e(r2)


esttab using "$directorio\Effect\FS_ATT_joint.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" ) replace 
	
	
