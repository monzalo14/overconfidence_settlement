/*
Initial claim against case characteristics regression for public and 
private lawyers separately
*/


import delimited "$sharelatex\Raw\observaciones_tope.csv", clear 


for var c_antiguedad c_indem-c_desc_ob c_recsueldo liq_total: ///
	capture replace X=0 if X<0 & X~=.
	
*Wizorise all at 99th percentile
for var c_* liq_total liq_total_tope: capture egen X99 = pctile(X) , p(99)
for var c_* liq_total liq_total_tope: ///
	capture replace X=X99 if X>X99 & X~=.
drop *99


destring salario_diario, force replace
*We omit TOP DESPACHO in specifications (in order to not alter table format we simply omit it from stata output)
gen top_desp=1

 

/***********************
       REGRESSIONS
************************/


eststo clear
local yes="YES"
*************************

eststo: areg c_total  gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	if abogado_pub==1, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
qui su c_total if abogado_pub==1
estadd scalar DepVarMean=r(mean)
estadd local dummygiro="`yes'"

eststo: areg c_total  gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	if abogado_pub==1, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
estadd local dummygiro="`yes'"

*************************

eststo: areg c_total  gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	if abogado_pub==0, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
qui su c_total if abogado_pub==0
estadd scalar DepVarMean=r(mean)
estadd local dummygiro="`yes'"

eststo: areg c_total  gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	if abogado_pub==0, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
estadd local dummygiro="`yes'"

********************************************************************************
esttab using "$sharelatex\Tables\reg_results\Lawyer_reg.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" "dummygiro DummyGiro") replace 

********************************************************************************
********************************************************************************	

