********************************************************************************
********************************************************************************
*****************************OVERCONFIDENCE IN AMOUNT***************************
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


rename tratamientoquelestoco treatment



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

*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=98

*Regression with crossed effect overconfidence
gen oc_=RA_5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_oc=oc_, nq(100)
drop if perc_oc>=98

rename tratamientoquelestoco treatment



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

*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=98

*Regression with crossed effect overconfidence
gen oc_=RD5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_oc=oc_, nq(100)
drop if perc_oc>=98

rename tratamientoquelestoco treatment



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

esttab using "$sharelatex\Tables\reg_results\concilio_vs_oc.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" "std_dev_Y std_dev_Y" "OCMean OC_Mean" "std_dev_X std_dev_X") replace 
