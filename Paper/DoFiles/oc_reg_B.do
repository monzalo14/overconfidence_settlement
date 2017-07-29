/*
Regressions of overconfidence (PROBABILITY) on case characteristics (exogenous) 
*/


*************************************EMPLOYEE***********************************
********************************************************************************

use "$sharelatex\DB\Calculadora_wod.dta", clear	
merge m:1 folio using  "$sharelatex/Raw/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force

*Regression with crossed effect overconfidence
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

rename A_5_1 Prob_win

gen oc_=Prob_win-Prob_win_calc
gen rel_oc=oc_/Prob_win_calc


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
estadd scalar OCSD=r(sd)

eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	repeat_worker i.A_1_2 ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	i.A_6_1 ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	repeat_worker i.A_1_2 i.A_6_1 ///
	, robust
estadd scalar Erre=e(r2)
qui su rel_oc 
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)


********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force

*Regression with crossed effect overconfidence
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

rename RA_5_1 Prob_win

gen oc_=Prob_win-Prob_win_calc
gen rel_oc=oc_/Prob_win_calc


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
estadd scalar OCSD=r(sd)


********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force

*Regression with crossed effect overconfidence
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

rename RD5_1_1 Prob_win

gen oc_=Prob_win-Prob_win_calc
gen rel_oc=oc_/Prob_win_calc


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
estadd scalar OCSD=r(sd)

*************************

esttab using "$sharelatex\Tables\reg_results\oc_reg_b.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "OCMean OC_Mean" "OCSD OCSD") replace 
