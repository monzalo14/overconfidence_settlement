 
*EMPLOYEE
use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Merge_Actor_OC.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco )

*Drop outlier
xtile perc=A_5_8, nq(99)
replace A_5_8=. if perc>=98

rename ES_1_5 time_s
rename A_5_8 time_e
rename ES_1_4 amount_s
rename A_5_5 amount_e

*Winzorise all at 95th percentile
for var time_s time_e amount_s amount_e: capture egen X95 = pctile(X) , p(95)
for var time_s time_e amount_s amount_e: ///
	 replace X=X95 if X>X95 & X~=.
drop *95

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
use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Merge_Representante_Actor_OC.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco )


rename ES_1_5 time_s
rename RA_5_8 time_e
rename ES_1_4 amount_s
rename RA_5_5 amount_e

*Winzorise all at 95th percentile
for var time_s time_e amount_s amount_e: capture egen X95 = pctile(X) , p(95)
for var time_s time_e amount_s amount_e: ///
	 replace X=X95 if X>X95 & X~=.
drop *95

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
use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Merge_Representante_Demandado_OC.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco )


rename ES_1_5 time_s
rename RD5_8 time_e
rename ES_1_4 amount_s
rename RD5_5 amount_e

*Winzorise all at 95th percentile
for var time_s time_e amount_s amount_e: capture egen X95 = pctile(X) , p(95)
for var time_s time_e amount_s amount_e: ///
	 replace X=X95 if X>X95 & X~=.
drop *95

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

esttab using "$directorio\Results\Results_3\Regressions\exit_vs_initial_exp.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean") replace 
