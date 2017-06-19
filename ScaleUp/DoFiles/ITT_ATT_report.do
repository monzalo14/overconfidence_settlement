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
eststo: reg convenio dia_tratamiento, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su convenio if e(sample)
estadd scalar DepVarMean=r(mean)


eststo: reg convenio dia_tratamiento junta_* , robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su convenio if e(sample)
estadd scalar DepVarMean=r(mean)


*ATT


	*PLAINTIFF
eststo: ivreg convenio junta_*   ///
	(calcu_p_actora = dia_tratamiento  ) ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su convenio if e(sample)
estadd scalar DepVarMean=r(mean)
qui su calcu_p_actora if e(sample)
estadd scalar perc_treat=r(mean)


	*DEFENDANT
eststo: ivreg convenio junta_*   ///
	(calcu_p_dem = dia_tratamiento  ) ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su convenio if e(sample)
estadd scalar DepVarMean=r(mean)
qui su calcu_p_dem if e(sample)
estadd scalar perc_treat=r(mean)


	*BOTH
gen calcu_both=(calculadoras_partes==2)	
eststo: ivreg convenio junta_*   ///
	(calcu_both = dia_tratamiento  ) ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su convenio if e(sample)
estadd scalar DepVarMean=r(mean)
qui su calcu_both if e(sample)
estadd scalar perc_treat=r(mean)



esttab using "$directorio\Effect\ITT_ATT_report.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" "perc_treat % Treated" ) replace 

******************************************	
	
*First Stage

eststo clear

	*PLAINTIFF
eststo: reg calcu_p_actora dia_tratamiento junta_*   ///
	if convenio!=.  ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su calcu_p_actora if e(sample)
estadd scalar DepVarMean=r(mean)

	*DEFENDANT
eststo: reg calcu_p_dem dia_tratamiento junta_*   ///
	if convenio!=.  ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su calcu_p_dem if e(sample)
estadd scalar DepVarMean=r(mean)

	*BOTH
eststo: reg calcu_both dia_tratamiento junta_*   ///
	if convenio!=.  ///
	, robust cluster(fecha_lista) 
estadd scalar Erre=e(r2)
qui su calcu_p_dem if e(sample)
estadd scalar DepVarMean=r(mean)

esttab using "$directorio\Effect\FS_ATT_report.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean") replace 
	
	

********************************************************************************
