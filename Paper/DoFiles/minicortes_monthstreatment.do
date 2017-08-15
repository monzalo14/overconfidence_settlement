use "$sharelatex\DB\pilot_operation.dta", clear
merge m:1 expediente anio using "$sharelatex\DB\pilot_casefiles_wod.dta", keep(1 3)
drop _merge

 
*File Order
sort anio expediente
gen orden_exp=_n

*Presence employee
replace p_actor=(p_actor==1)

rename tratamientoquelestoco treatment


	eststo clear

	*Same day conciliation
	eststo: reg seconcilio i.treatment if treatment!=0, robust
	estadd scalar Erre=e(r2)
	qui su seconcilio
	estadd scalar DepVarMean=r(mean)
	qui  test 1.treatment=3.treatment
	estadd scalar Pvalue=r(p)
	qui testparm i(2/3).treatment
	estadd scalar Pvalue_=r(p)
	
	*Interaction employee was present
	eststo: reg seconcilio i.treatment##i.p_actor if treatment!=0, robust
	estadd scalar Erre=e(r2)
	qui su seconcilio
	estadd scalar DepVarMean=r(mean)
	qui su p_actor if treatment!=0
	estadd scalar IntMean=r(mean)
	qui  test 1.treatment=3.treatment
	estadd scalar Pvalue=r(p)
	qui testparm i(2/3).treatment
	estadd scalar Pvalue_=r(p)
	
	
foreach m in 1 2 3 4 5 {

	*Simple regression
	eststo: reg convenio_`m'm i.treatment if treatment!=0, robust
	estadd scalar Erre=e(r2)
	qui su convenio_`m'm if e(sample)
	estadd scalar DepVarMean=r(mean)
	qui  test 1.treatment=3.treatment
	estadd scalar Pvalue=r(p)
	qui testparm i(2/3).treatment
	estadd scalar Pvalue_=r(p)
	
	*Interaction employee was present
	eststo: reg convenio_`m'm i.treatment##i.p_actor if treatment!=0, robust
	estadd scalar Erre=e(r2)
	qui su convenio_`m'm if e(sample)
	estadd scalar DepVarMean=r(mean)
	qui su p_actor if treatment!=0
	estadd scalar IntMean=r(mean)
	qui  test 1.treatment=3.treatment
	estadd scalar Pvalue=r(p)
	qui testparm i(2/3).treatment
	estadd scalar Pvalue_=r(p)
	}
	

	


	*************************
	esttab using "$sharelatex/Tables/reg_results/minicortes_monthstreatment.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" "IntMean InteractionVarMean" "Pvalue Pvalue" "Pvalue_ Pvalue_") replace 

	
	
	
	
********************************************************************************
*Adding Basic Variables Controls

	eststo clear

	*Same day conciliation
	eststo: reg seconcilio i.treatment ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
	estadd scalar Erre=e(r2)
	qui su seconcilio
	estadd scalar DepVarMean=r(mean)
	qui  test 1.treatment=3.treatment
	estadd scalar Pvalue=r(p)
	qui testparm i(2/3).treatment
	estadd scalar Pvalue_=r(p)
	
	*Interaction employee was present
	eststo: reg seconcilio i.treatment##i.p_actor ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
	estadd scalar Erre=e(r2)
	qui su seconcilio
	estadd scalar DepVarMean=r(mean)
	qui su p_actor if treatment!=0
	estadd scalar IntMean=r(mean)
	qui  test 1.treatment=3.treatment
	estadd scalar Pvalue=r(p)
	qui testparm i(2/3).treatment
	estadd scalar Pvalue_=r(p)
	
	
foreach m in 1 2 3 4 5 {

	*Simple regression
	eststo: reg convenio_`m'm i.treatment ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
	estadd scalar Erre=e(r2)
	qui su convenio_`m'm if e(sample)
	estadd scalar DepVarMean=r(mean)
	qui  test 1.treatment=3.treatment
	estadd scalar Pvalue=r(p)
	qui testparm i(2/3).treatment
	estadd scalar Pvalue_=r(p)
	
	*Interaction employee was present
	eststo: reg convenio_`m'm i.treatment##i.p_actor ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
	estadd scalar Erre=e(r2)
	qui su convenio_`m'm if e(sample)
	estadd scalar DepVarMean=r(mean)
	qui su p_actor if treatment!=0
	estadd scalar IntMean=r(mean)
	qui  test 1.treatment=3.treatment
	estadd scalar Pvalue=r(p)
	qui testparm i(2/3).treatment
	estadd scalar Pvalue_=r(p)
	}
	

	


	*************************
	esttab using "$sharelatex/Tables/reg_results/minicortes_monthstreatment_B.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" "IntMean InteractionVarMean" "Pvalue Pvalue" "Pvalue_ Pvalue_") replace 
	
