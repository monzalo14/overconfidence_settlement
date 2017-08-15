/*
Regressions of overconfidence (AMOUNT) on case characteristics (exogenous) 
*/

********************************************************************************
********************************************************************************
*								Theta Updating
********************************************************************************
********************************************************************************


*************************************EMPLOYEE***********************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:1 folio using  "$sharelatex/Raw/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:1 folio using "$sharelatex/Raw/Merge_Actor_OC.dta", keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force
drop if tratamientoquelestoco==0

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=99

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=abs((ES_1_4-comp_esp)/(A_5_5-comp_esp))


*Outliers
xtile perc_up=update_comp, nq(100)
drop if perc_up>=90

*Rename
rename A_7_3 repeat_worker



/***********************
       REGRESSIONS
************************/

eststo clear
		
eststo: reg  c.update_comp ///
	i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)


eststo: reg  c.update_comp ///
	i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	repeat_worker i.A_1_2 i.A_6_1 ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.update_comp ///
	i.tratamientoqueles i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	repeat_worker i.A_1_2 i.A_6_1 ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.update_comp ///
	i.tratamientoqueles##i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	repeat_worker i.A_1_2 i.A_6_1 ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/Raw/Merge_Representante_Actor_OC.dta", keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force
drop if tratamientoquelestoco==0


*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=99

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=abs((ES_1_4-comp_esp)/(RA_5_5-comp_esp))


*Outliers
xtile perc_up=update_comp, nq(100)
drop if perc_up>=90





/***********************
       REGRESSIONS
************************/


eststo: reg  c.update_comp ///
	i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.update_comp ///
	i.tratamientoqueles i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.update_comp ///
	i.tratamientoqueles##i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/Raw/Merge_Representante_Demandado_OC.dta", keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force
drop if tratamientoquelestoco==0


*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=99

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=abs((ES_1_4-comp_esp)/(RD5_5-comp_esp))


*Outliers
xtile perc_up=update_comp, nq(100)
drop if perc_up>=90





/***********************
       REGRESSIONS
************************/


eststo: reg  c.update_comp ///
	i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.update_comp ///
	i.tratamientoqueles i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.update_comp ///
	i.tratamientoqueles##i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

*************************




********************************************************************************
********************************************************************************
*								Relative Updating
********************************************************************************
********************************************************************************



*************************************EMPLOYEE***********************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:1 folio using  "$sharelatex/Raw/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:1 folio using "$sharelatex/Raw/Merge_Actor_OC.dta", keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force
drop if tratamientoquelestoco==0


*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=99

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=(ES_1_4-A_5_5)/(A_5_5)


*Outliers
xtile perc_up=update_comp, nq(100)
drop if perc_up>=90

*Rename
rename A_7_3 repeat_worker



/***********************
       REGRESSIONS
************************/


eststo: reg  c.update_comp ///
	i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)


eststo: reg  c.update_comp ///
	i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	repeat_worker i.A_1_2 i.A_6_1 ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.update_comp ///
	i.tratamientoqueles i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	repeat_worker i.A_1_2 i.A_6_1 ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.update_comp ///
	i.tratamientoqueles##i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	repeat_worker i.A_1_2 i.A_6_1 ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/Raw/Merge_Representante_Actor_OC.dta", keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force
drop if tratamientoquelestoco==0


*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=99

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=(ES_1_4-RA_5_5)/(RA_5_5)


*Outliers
xtile perc_up=update_comp, nq(100)
drop if perc_up>=90





/***********************
       REGRESSIONS
************************/


eststo: reg  c.update_comp ///
	i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.update_comp ///
	i.tratamientoqueles i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.update_comp ///
	i.tratamientoqueles##i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/Raw/Merge_Representante_Demandado_OC.dta", keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge



duplicates drop folio tratamientoqueles secon, force
drop if tratamientoquelestoco==0


*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=99

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=(ES_1_4-RD5_5)/(RD5_5)


*Outliers
xtile perc_up=update_comp, nq(100)
drop if perc_up>=90





/***********************
       REGRESSIONS
************************/


eststo: reg  c.update_comp ///
	i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.update_comp ///
	i.tratamientoqueles i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)

eststo: reg  c.update_comp ///
	i.tratamientoqueles##i.abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	, robust
estadd scalar Erre=e(r2)
qui su update_comp if e(sample)
estadd scalar OCMean=r(mean)
estadd scalar OCSD=r(sd)


*************************
*************************
*************************
*************************


esttab using "$sharelatex\Tables\reg_results\oc_reg_theta.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "OCMean OC_Mean" "OCSD OCSD") replace 
