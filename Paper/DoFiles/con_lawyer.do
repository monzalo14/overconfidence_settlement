
********************************************************************************
	*DB: Calculator:5005
import delimited "$sharelatex\DB\scaleup_hd.csv", clear 

for var c_antiguedad c_indem-c_desc_ob c_recsueldo liq_total: ///
	capture replace X=0 if X<0 & X~=.
	
*Wizorise all at 99th percentile
for var c_* liq_total liq_total_tope: capture egen X99 = pctile(X) , p(99)
for var c_* liq_total liq_total_tope: ///
	capture replace X=X99 if X>X99 & X~=.
drop *99


*Conciliation
gen con=(modo_termino==1)*100
*Months after initial sue
gen fechadem=date(fecha_demanda,"YMD")
gen fechater=date(fecha_termino,"YMD")
gen months_after=(fechater-fechadem)/30

*Daily wage
destring salario_diario, force replace

/***********************
       REGRESSIONS
************************/

eststo clear
		
eststo: reg con  ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su con 
estadd scalar DepVarMean=r(mean)


eststo: reg con ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	codem c_total , robust
estadd scalar Erre=e(r2)
qui su con 
estadd scalar DepVarMean=r(mean)

**************************************************

eststo: reg months_after  ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su months_after 
estadd scalar DepVarMean=r(mean)


eststo: reg months_after ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	codem c_total , robust
estadd scalar Erre=e(r2)
qui su months_after 
estadd scalar DepVarMean=r(mean)


*************************

esttab using "$sharelatex\Tables\reg_results\concilio_vs_lawyer.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" ) replace 
