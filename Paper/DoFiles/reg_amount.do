
import delimited "$sharelatex\DB\scaleup_hd.csv", clear 


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

*We define win as liq_total>0
gen win=(liq_total>0)*100

*Ratio amount won/amount asked
gen won_asked=liq_total/c_total 

*Amount won on log
replace liq_total=1 if liq_total==0
replace liq_total=log(liq_total)

*Total asked in log
replace c_total=1 if c_total==0
replace c_total=log(c_total)

*Tenure | Daily wage | Weekle hours in logs
foreach var of varlist c_antiguedad salario_diario horas_sem {
	replace `var'=1 if `var'==0
	replace `var'=log(`var')
	}

/***********************
       REGRESSIONS
************************/


eststo clear
		
eststo: areg win abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	if modo_termino==1, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
qui su win if modo_termino==1
estadd scalar DepVarMean=r(mean)

eststo: areg win abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem c_total ///
	if modo_termino==1, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)

*************************

eststo: areg liq_total abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	if modo_termino==1, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
qui su liq_total if modo_termino==1
estadd scalar DepVarMean=r(mean)

eststo: areg liq_total abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem c_total ///
	if modo_termino==1, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)

*************************

eststo: areg c_total abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	if modo_termino==1, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
qui su c_total if modo_termino==1
estadd scalar DepVarMean=r(mean)

eststo: areg c_total abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	if modo_termino==1, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)

*************************

eststo: areg won_asked abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	if modo_termino==1, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
qui su won_asked if modo_termino==1
estadd scalar DepVarMean=r(mean)

eststo: areg won_asked abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	if modo_termino==1, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)


********************************************************************************
esttab using "$sharelatex\Tables\reg_results\Reg1_con_log.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" "dummygiro DummyGiro") replace 

********************************************************************************
********************************************************************************	



eststo clear
		
eststo: areg win abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	if modo_termino==3, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
qui su win if modo_termino==3
estadd scalar DepVarMean=r(mean)

eststo: areg win abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem c_total ///
	if modo_termino==3, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)

*************************

eststo: areg liq_total abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	if modo_termino==3, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
qui su liq_total if modo_termino==3
estadd scalar DepVarMean=r(mean)

eststo: areg liq_total abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem c_total ///
	if modo_termino==3, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)

*************************

eststo: areg c_total abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	if modo_termino==3, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
qui su c_total if modo_termino==3
estadd scalar DepVarMean=r(mean)

eststo: areg c_total abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	if modo_termino==3, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)

*************************

eststo: areg won_asked abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	if modo_termino==3, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
qui su won_asked if modo_termino==3
estadd scalar DepVarMean=r(mean)

eststo: areg won_asked abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	top_desp  ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	if modo_termino==3, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)


********************************************************************************
esttab using "$sharelatex\Tables\reg_results\Reg1_lau_log.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" "dummygiro DummyGiro" ) replace 

********************************************************************************
********************************************************************************
