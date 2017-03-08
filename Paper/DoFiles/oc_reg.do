/*
Regressions of overconfidence (AMOUNT) on case characteristics (exogenous) 
*/


*************************************EMPLOYEE***********************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_a=A_5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_rel=rel_oc, nq(100)
drop if perc_rel>=98


rename A_7_3 repeat_worker

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
		
eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)

eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	repeat_worker i.A_1_2 ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)

eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	i.A_6_1 ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)

eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	repeat_worker i.A_1_2 i.A_6_1 ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)



********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_ra=RA_5_5-comp_esp
gen rel_oc=oc_/comp_esp


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


eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)



********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_rd=RD5_5-comp_esp
gen rel_oc=oc_/comp_esp


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


eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)


*************************

esttab using "$directorio\Results\Results_3\Regressions\oc_reg.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "OCMean OC_Mean") replace 
