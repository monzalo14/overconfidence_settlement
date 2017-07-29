 
*EMPLOYEE
use "$sharelatex\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Merge_Actor_OC.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco )

*Drop outlier
xtile perc=A_5_8, nq(99)
replace A_5_8=. if perc>=98

rename ES_1_5 time_s
rename A_5_8 time_e
rename ES_1_4 amount_s
rename A_5_5 amount_e

*Amount in log
replace amount_s=1 if amount_s==0
replace amount_e=1 if amount_e==0
replace amount_s=log(amount_s)
replace amount_e=log(amount_e)

*Relative OC
gen time_esp=prob_convenio*dur_convenio+prob_cad*dur_cad+ ///
	prob_desist*dur_desist+prob_laudopos*dur_laudopos+prob_laudocero*dur_laudocero
	
replace time_s=(time_s-time_esp)/time_esp
replace time_e=(time_e-time_esp)/time_esp	
replace amount_s=(amount_s-comp_esp)/comp_esp
replace amount_e=(amount_e-comp_esp)/comp_esp

rename tratamientoquelestoco treatment

*Homologación de variables
rename  trabbase  trabajador_base
rename  antigedad   c_antiguedad 
rename  salariodiariointegrado   salario_diario
rename  horas   horas_sem 
rename  tipodeabogadocalc  abogado_pub 
rename  reinstalacin reinst
rename  indemnizacinconstitucional indem 
rename  salcaidost sal_caidos 
rename  primaantigtdummy  prima_antig
rename  primavactdummy  prima_vac 
rename  horasextras  hextra 
drop rec20
rename  rec20diast rec20
rename  primadominical prima_dom 
rename  descansosemanal  desc_sem 
rename  descansoobligdummy desc_ob
rename  sarimssinfo  sarimssinf 
rename  utilidadest  utilidades
rename  nulidad  nulidad  
rename  codemandaimssinfo  codem 
rename  cuantificaciontrabajador c_total



/***********************
       REGRESSIONS
************************/

eststo clear

eststo: reg amount_s c.amount_e##i.treatment ///
	if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su amount_s
estadd scalar DepVarMean=r(mean)

eststo: reg amount_s c.amount_e##i.treatment ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su amount_s
estadd scalar DepVarMean=r(mean)

eststo: reg time_s c.time_e##i.treatment ///
	if treatment!=0, robust 
estadd scalar Erre=e(r2)
qui su time_s
estadd scalar DepVarMean=r(mean)	
	
eststo: reg time_s c.time_e##i.treatment ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust 
estadd scalar Erre=e(r2)
qui su time_s
estadd scalar DepVarMean=r(mean)		


********************************************************************************
********************************************************************************

*EMPLOYEE'S LAWYER
use "$sharelatex\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Merge_Representante_Actor_OC.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco )


rename ES_1_5 time_s
rename RA_5_8 time_e
rename ES_1_4 amount_s
rename RA_5_5 amount_e

*Amount in log
replace amount_s=1 if amount_s==0
replace amount_e=1 if amount_e==0
replace amount_s=log(amount_s)
replace amount_e=log(amount_e)

*Relative OC
gen time_esp=prob_convenio*dur_convenio+prob_cad*dur_cad+ ///
	prob_desist*dur_desist+prob_laudopos*dur_laudopos+prob_laudocero*dur_laudocero
	
replace time_s=(time_s-time_esp)/time_esp
replace time_e=(time_e-time_esp)/time_esp	
replace amount_s=(amount_s-comp_esp)/comp_esp
replace amount_e=(amount_e-comp_esp)/comp_esp

rename tratamientoquelestoco treatment

*Homologación de variables
rename  trabbase  trabajador_base
rename  antigedad   c_antiguedad 
rename  salariodiariointegrado   salario_diario
rename  horas   horas_sem 
rename  tipodeabogadocalc  abogado_pub 
rename  reinstalacin reinst
rename  indemnizacinconstitucional indem 
rename  salcaidost sal_caidos 
rename  primaantigtdummy  prima_antig
rename  primavactdummy  prima_vac 
rename  horasextras  hextra 
drop rec20
rename  rec20diast rec20
rename  primadominical prima_dom 
rename  descansosemanal  desc_sem 
rename  descansoobligdummy desc_ob
rename  sarimssinfo  sarimssinf 
rename  utilidadest  utilidades
rename  nulidad  nulidad  
rename  codemandaimssinfo  codem 
rename  cuantificaciontrabajador c_total



/***********************
       REGRESSIONS
************************/

eststo: reg amount_s c.amount_e##i.treatment ///
	if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su amount_s
estadd scalar DepVarMean=r(mean)

eststo: reg amount_s c.amount_e##i.treatment ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su amount_s
estadd scalar DepVarMean=r(mean)

eststo: reg time_s c.time_e##i.treatment ///
	if treatment!=0, robust 
estadd scalar Erre=e(r2)
qui su time_s
estadd scalar DepVarMean=r(mean)	
	
eststo: reg time_s c.time_e##i.treatment ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust 
estadd scalar Erre=e(r2)
qui su time_s
estadd scalar DepVarMean=r(mean)		


********************************************************************************
********************************************************************************

*FIRM'S LAWYER
use "$sharelatex\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Merge_Representante_Demandado_OC.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco )


rename ES_1_5 time_s
rename RD5_8 time_e
rename ES_1_4 amount_s
rename RD5_5 amount_e

*Amount in log
replace amount_s=1 if amount_s==0
replace amount_e=1 if amount_e==0
replace amount_s=log(amount_s)
replace amount_e=log(amount_e)

*Relative OC
gen time_esp=prob_convenio*dur_convenio+prob_cad*dur_cad+ ///
	prob_desist*dur_desist+prob_laudopos*dur_laudopos+prob_laudocero*dur_laudocero
	
replace time_s=(time_s-time_esp)/time_esp
replace time_e=(time_e-time_esp)/time_esp	
replace amount_s=(amount_s-comp_esp)/comp_esp
replace amount_e=(amount_e-comp_esp)/comp_esp

rename tratamientoquelestoco treatment

*Homologación de variables
rename  trabbase  trabajador_base
rename  antigedad   c_antiguedad 
rename  salariodiariointegrado   salario_diario
rename  horas   horas_sem 
rename  tipodeabogadocalc  abogado_pub 
rename  reinstalacin reinst
rename  indemnizacinconstitucional indem 
rename  salcaidost sal_caidos 
rename  primaantigtdummy  prima_antig
rename  primavactdummy  prima_vac 
rename  horasextras  hextra 
drop rec20
rename  rec20diast rec20
rename  primadominical prima_dom 
rename  descansosemanal  desc_sem 
rename  descansoobligdummy desc_ob
rename  sarimssinfo  sarimssinf 
rename  utilidadest  utilidades
rename  nulidad  nulidad  
rename  codemandaimssinfo  codem 
rename  cuantificaciontrabajador c_total



/***********************
       REGRESSIONS
************************/


eststo: reg amount_s c.amount_e##i.treatment ///
	if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su amount_s
estadd scalar DepVarMean=r(mean)

eststo: reg amount_s c.amount_e##i.treatment ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su amount_s
estadd scalar DepVarMean=r(mean)

eststo: reg time_s c.time_e##i.treatment ///
	if treatment!=0, robust 
estadd scalar Erre=e(r2)
qui su time_s
estadd scalar DepVarMean=r(mean)	
	
eststo: reg time_s c.time_e##i.treatment ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust 
estadd scalar Erre=e(r2)
qui su time_s
estadd scalar DepVarMean=r(mean)	



******************

esttab using "$sharelatex\Tables\reg_results\exit_vs_initial_exp_log.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean") replace 
