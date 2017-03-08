********************************************************************************
********************************************************************************
**************************OVERCONFIDENCE IN LOG AMOUNT**************************
********************************************************************************





*************************************EMPLOYEE***********************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=97

*Regression with crossed effect overconfidence
gen oc_=A_5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_oc=oc_, nq(100)
drop if perc_oc>=98
xtile perc_rel=rel_oc, nq(100)
drop if perc_rel>=98

*Log of OC
replace oc_=log(oc_)
replace rel_oc=log(rel_oc)

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

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=98

*Regression with crossed effect overconfidence
gen oc_=RA_5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_oc=oc_, nq(100)
drop if perc_oc>=98

*Log of OC
replace oc_=log(oc_)
replace rel_oc=log(rel_oc)

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

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=98

*Regression with crossed effect overconfidence
gen oc_=RD5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_oc=oc_, nq(100)
drop if perc_oc>=98

*Log of OC
replace oc_=log(oc_)
replace rel_oc=log(rel_oc)

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

esttab using "$directorio\Results\Results_3\Regressions\concilio_vs_oc_log.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" "std_dev_Y std_dev_Y" "OCMean OC_Mean" "std_dev_X std_dev_X") replace 
