/*******************************************************************************
This do file generates all output, such as SS, Two-way tables, Histograms and 
Regressions used as input for the .tex file "Results.tex"
*******************************************************************************/

********************************************************************************

use "$directorio\DB\Seguimiento_Juntas.dta", clear

********************************************************************************


/***********************
       REGRESSIONS
************************/


********************************************************************************	


*ITT

eststo clear

*ITT
eststo: reg convenio dia_tratamiento##p_actor junta_* notificado , robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)

eststo: reg convenio dia_tratamiento##p_actor junta_* if notificado==1 , robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
estadd local Notified="SI"

eststo: reg convenio dia_tratamiento##0.no_encuestado junta_* notificado , robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)



*ATT
gen calcu_a_x_ep=calcu_p_actora*p_actor
gen calcu_d_x_ep=calcu_p_dem*p_actor

gen dt_x_ep=dia_tratamiento*p_actor


	*PLAINTIFF
eststo: ivreg convenio junta_*  notificado ///
	(calcu_p_actora = dia_tratamiento  ) ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)

eststo: ivreg convenio junta_*   ///
	(calcu_p_actora = dia_tratamiento  ) ///
	if notificado==1, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
estadd local Notified="SI"

eststo: ivreg convenio junta_* notificado ///
	(calcu_p_actora calcu_a_x_ep =  dia_tratamiento dt_x_ep) ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)



	*DEFENDANT
eststo: ivreg convenio junta_*  notificado ///
	(calcu_p_dem = dia_tratamiento  ) ///
	,  robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)

eststo: ivreg convenio junta_*   ///
	(calcu_p_dem = dia_tratamiento  ) ///
	,  robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
estadd local Notified="SI"

eststo: ivreg convenio junta_* notificado ///
	(calcu_p_dem calcu_d_x_ep =  dia_tratamiento dt_x_ep) ///
	,  robust cluster(fecha_lista)
estadd scalar Erre=e(r2)




esttab using "$directorio\Effect\ITT_ATT.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "Notified Notified") replace 

******************************************	
	
*First Stage

eststo clear

	*PLAINTIFF
eststo: reg calcu_p_actora dia_tratamiento junta_*  notificado ///
	if convenio!=.  ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)

eststo: reg calcu_p_actora dia_tratamiento junta_*   ///
	if convenio!=. & notificado==1  ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)	
estadd local Notified="SI"

eststo: reg calcu_p_actora dia_tratamiento dt_x_ep junta_*  notificado ///
	if convenio!=.  ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)

eststo: reg calcu_a_x_ep dia_tratamiento dt_x_ep junta_*  notificado ///
	if convenio!=.  ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)

	*DEFENDANT
eststo: reg calcu_p_dem dia_tratamiento junta_*  notificado ///
	if convenio!=.  ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)

eststo: reg calcu_p_dem dia_tratamiento junta_*   ///
	if convenio!=.  & notificado==1  ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
estadd local Notified="SI"

eststo: reg calcu_p_dem dia_tratamiento dt_x_ep junta_*  notificado ///
	if convenio!=.  ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)

eststo: reg calcu_d_x_ep dia_tratamiento dt_x_ep junta_*  notificado ///
	if convenio!=.  ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)

	
esttab using "$directorio\Effect\FS_ATT.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "Notified Notified") replace 
	
	
