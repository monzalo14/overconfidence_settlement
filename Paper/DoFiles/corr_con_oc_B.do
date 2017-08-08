********************************************************************************
********************************************************************************
*****************************OVERCONFIDENCE IN PROB*****************************
********************************************************************************





*************************************EMPLOYEE***********************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:1 folio using  "$sharelatex/Raw/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force


*Regression with crossed effect overconfidence
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

rename A_5_1 Prob_win

gen oc_=Prob_win-Prob_win_calc
gen rel_oc=oc_/Prob_win_calc

rename tratamientoquelestoco treatment

*Variable Homologation
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
		
eststo: reg seconcilio c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su seconcilio 
estadd scalar DepVarMean=r(mean)
estadd scalar std_dev_Y=r(sd)
qui su rel_oc 
estadd scalar OCMean=r(mean)
estadd scalar std_dev_X=r(sd)



eststo: reg seconcilio c.oc_ ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su seconcilio 
estadd scalar DepVarMean=r(mean)
estadd scalar std_dev_Y=r(sd)
qui su oc_ 
estadd scalar OCMean=r(mean)
estadd scalar std_dev_X=r(sd)

********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force


*Regression with crossed effect overconfidence
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

rename RA_5_1 Prob_win

gen oc_=Prob_win-Prob_win_calc
gen rel_oc=oc_/Prob_win_calc


rename tratamientoquelestoco treatment

*Variable Homologation
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


eststo: reg seconcilio c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su seconcilio 
estadd scalar DepVarMean=r(mean)
estadd scalar std_dev_Y=r(sd)
qui su rel_oc 
estadd scalar OCMean=r(mean)
estadd scalar std_dev_X=r(sd)



eststo: reg seconcilio c.oc_ ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su seconcilio 
estadd scalar DepVarMean=r(mean)
estadd scalar std_dev_Y=r(sd)
qui su oc_ 
estadd scalar OCMean=r(mean)
estadd scalar std_dev_X=r(sd)


********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force


*Regression with crossed effect overconfidence
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

rename RD5_1_1 Prob_win

gen oc_=Prob_win-Prob_win_calc
gen rel_oc=oc_/Prob_win_calc


rename tratamientoquelestoco treatment

*Variable Homologation
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


eststo: reg seconcilio c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su seconcilio 
estadd scalar DepVarMean=r(mean)
estadd scalar std_dev_Y=r(sd)
qui su rel_oc 
estadd scalar OCMean=r(mean)
estadd scalar std_dev_X=r(sd)



eststo: reg seconcilio c.oc_ ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su seconcilio 
estadd scalar DepVarMean=r(mean)
estadd scalar std_dev_Y=r(sd)
qui su oc_ 
estadd scalar OCMean=r(mean)
estadd scalar std_dev_X=r(sd)




*************************

esttab using "$sharelatex\Tables\reg_results\concilio_vs_oc_b.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" "std_dev_Y std_dev_Y" "OCMean OC_Mean" "std_dev_X std_dev_X") replace 
