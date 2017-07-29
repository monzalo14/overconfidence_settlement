use "$sharelatex\DB\Base_Seguimiento.dta", clear
merge m:1 expediente anio using "$sharelatex\DB\Calculadora_wod.dta", keep(1 3)
drop _merge


*Persistent conciliation variable
replace seconcilio=1 if c1_fecha_con==fechalista
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)

*Conciliation date
replace c1_fecha_convenio=fechalista if seconcilio==1 & c1_se_concilio==1
gen fecha_con=date(c1_fecha_convenio,"DMY")
bysort expediente anio : egen fecha_convenio=max(fecha_con)
format fecha_convenio %td

*Treatment date
gen fecha_treat=date(fechalista,"DMY")
bysort expediente anio : egen fecha_treatment=min(fecha_treat)
format fecha_treatment %td

*Months after treatment 
gen months_treat=(fecha_convenio-fecha_treatment)/30

*1 month after
gen convenio_1m=0
replace convenio_1m=1 if inrange(months_treat,0,1)

*2 month after
gen convenio_2m=0
replace convenio_2m=1 if inrange(months_treat,0,2)

*3 month after
gen convenio_3m=0
replace convenio_3m=1 if inrange(months_treat,0,3)

*4 month after
gen convenio_4m=0
replace convenio_4m=1 if inrange(months_treat,0,4)

*+5 month after
gen convenio_5m=conciliation


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
	
