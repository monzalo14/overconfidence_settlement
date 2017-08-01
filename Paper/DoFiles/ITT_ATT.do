*ITT & ATT

********************************************************************************

use "$scaleup\DB\Seguimiento_Juntas.dta", clear

********************************************************************************


/***********************
       REGRESSIONS
************************/


********************************************************************************	


*ITT

eststo clear

*ITT
eststo: reg convenio dia_tratamiento if notificado==1, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su convenio if e(sample)
estadd scalar DepVarMean=r(mean)
estadd local Notified="YES"


eststo: reg convenio dia_tratamiento junta_* if notificado==1 , robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su convenio if e(sample)
estadd scalar DepVarMean=r(mean)
estadd local Notified="YES"


*ATT


	*PLAINTIFF
eststo: ivreg convenio junta_*   ///
	(calcu_p_actora = dia_tratamiento  ) if notificado==1 ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su convenio if e(sample)
estadd scalar DepVarMean=r(mean)
qui su calcu_p_actora if e(sample)
estadd scalar perc_treat=r(mean)
estadd local Notified="YES"


	*DEFENDANT
eststo: ivreg convenio junta_*   ///
	(calcu_p_dem = dia_tratamiento  ) if notificado==1 ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su convenio if e(sample)
estadd scalar DepVarMean=r(mean)
qui su calcu_p_dem if e(sample)
estadd scalar perc_treat=r(mean)
estadd local Notified="YES"


	*BOTH
gen calcu_both=(calculadoras_partes==2)	
eststo: ivreg convenio junta_*   ///
	(calcu_both = dia_tratamiento  ) if notificado==1 ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su convenio if e(sample)
estadd scalar DepVarMean=r(mean)
qui su calcu_both if e(sample)
estadd scalar perc_treat=r(mean)
estadd local Notified="YES"


*ATT##EP
gen calcu_a_x_ep=calcu_p_actora*p_actor
gen calcu_d_x_ep=calcu_p_dem*p_actor

gen dt_x_ep=dia_tratamiento*p_actor


	*PLAINTIFF
eststo: ivreg convenio junta_*  ///
	(calcu_p_actora calcu_a_x_ep =  dia_tratamiento dt_x_ep) if notificado==1 ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su convenio if e(sample)
estadd scalar DepVarMean=r(mean)
estadd local Notified="YES"


	*DEFENDANT
eststo: ivreg convenio junta_*  ///
	(calcu_p_dem calcu_d_x_ep =  dia_tratamiento dt_x_ep) if notificado==1 ///
	,  robust cluster(fecha_lista)
estadd scalar Erre=e(r2)
qui su convenio if e(sample)
estadd scalar DepVarMean=r(mean)
estadd local Notified="YES"



esttab using "$sharelatex\Tables\reg_results\ITT_ATT.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" "perc_treat % Treated" "Notified Notified") replace 

******************************************	
	
*First Stage

eststo clear

	*PLAINTIFF
eststo: reg calcu_p_actora dia_tratamiento junta_*   ///
	if convenio!=. & notificado==1 ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su calcu_p_actora if e(sample)
estadd scalar DepVarMean=r(mean)

	*DEFENDANT
eststo: reg calcu_p_dem dia_tratamiento junta_*   ///
	if convenio!=.  & notificado==1 ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su calcu_p_dem if e(sample)
estadd scalar DepVarMean=r(mean)

	*BOTH
eststo: reg calcu_both dia_tratamiento junta_*   ///
	if convenio!=.  & notificado==1 ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su calcu_p_dem if e(sample)
estadd scalar DepVarMean=r(mean)

esttab using "$sharelatex\Tables\reg_results\FS_ATT.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean") replace 
	
	

********************************************************************************