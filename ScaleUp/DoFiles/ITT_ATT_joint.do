/*******************************************************************************
This do file creates the ITT and ATT tables from the joint database
*******************************************************************************/

clear
set more off
global directorio C:\Users\chasi_000\Dropbox\Apps\ShareLaTeX\overconfidence_settlement\ScaleUp

********************************************************************************
import delimited "$directorio\DB\seguimiento_joint.csv", clear 

drop junta_2
drop v1
*Necesito una variable que indique junta

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


*We only keep data from the ScaleUp
preserve 
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
	
	

*Correlation with presence of employee


	*Triple interaction
gen triple=calcu_p_actora*p_actor*notificado 
	
eststo clear		

eststo: reg convenio i.calcu_p_actora##1.p_actor notificado##i.calcu_p_actora triple, robust
estadd scalar Erre=e(r2)
eststo: reg convenio i.calcu_p_dem##1.p_actor notificado##i.calcu_p_dem triple, robust
estadd scalar Erre=e(r2)

esttab using "$directorio\Effect\Presence_employee_triple.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" ) replace 

	
	
********************************************************************************	


*ITT

eststo clear

*ITT SCALE UP
eststo: reg convenio tratamiento, robust 
estadd scalar Erre=e(r2)

eststo: reg convenio tratamiento junta_* notificado , robust 
estadd scalar Erre=e(r2)

eststo: reg convenio tratamiento##p_actor junta_* notificado , robust 
estadd scalar Erre=e(r2)

eststo: reg convenio tratamiento##c.num_conciliadores junta_* notificado , robust 
estadd scalar Erre=e(r2)
	
restore

keep if piloto_1==1
*ITT PILOT
eststo: reg convenio tratamiento, robust 
estadd scalar Erre=e(r2)

eststo: reg convenio tratamiento junta_* notificado , robust 
estadd scalar Erre=e(r2)

eststo: reg convenio tratamiento##p_actor junta_* notificado , robust 
estadd scalar Erre=e(r2)

eststo: reg convenio tratamiento##c.num_conciliadores junta_* notificado , robust 
estadd scalar Erre=e(r2)

esttab using "$directorio\Effect\ITT_SU_P.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" ) replace 