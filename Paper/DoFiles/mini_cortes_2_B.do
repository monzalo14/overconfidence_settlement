use "$sharelatex\DB\Base_Seguimiento.dta", clear
merge m:1 expediente anio using "$sharelatex\DB\Calculadora_wod.dta", keep(1 3)
drop _merge


*Persistent conciliation variable
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)

gen fecha_con=date(c1_fecha_convenio,"DMY")
bysort expediente anio : egen fecha_convenio=max(fecha_con)
format fecha_convenio %td


*Mini cortes

	*June
gen june="30/05/2016"
gen cortejune=date(june,"DMY")
gen convenio_june=conciliation
replace convenio_june=0 if fecha_convenio>=cortejune & !missing(conciliation)

	*July
gen july="30/07/2016"
gen cortejuly=date(july,"DMY")
gen convenio_july=conciliation
replace convenio_july=0 if fecha_convenio>=cortejuly & !missing(conciliation)

	*August
gen aug="30/08/2016"
gen corteaug=date(aug,"DMY")
gen convenio_aug=conciliation
replace convenio_aug=0 if fecha_convenio>=corteaug & !missing(conciliation)

	*September
gen sept="30/09/2016"
gen cortesept=date(sept,"DMY")
gen convenio_sept=conciliation
replace convenio_sept=0 if fecha_convenio>=cortesept & !missing(conciliation)

	*October
gen oct="30/10/2016"
gen corteoct=date(oct,"DMY")
gen convenio_oct=conciliation
replace convenio_oct=0 if fecha_convenio>=corteoct & !missing(conciliation)


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
	
	
foreach corte in june july aug sept oct {

	*Simple regression
	eststo: reg convenio_`corte' i.treatment ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
	estadd scalar Erre=e(r2)
	qui su convenio_`corte'
	estadd scalar DepVarMean=r(mean)
	qui  test 1.treatment=3.treatment
	estadd scalar Pvalue=r(p)
	qui testparm i(2/3).treatment
	estadd scalar Pvalue_=r(p)
	
	}
	

	*Interaction employee was present
	eststo: reg convenio_june i.treatment##i.p_actor ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
	estadd scalar Erre=e(r2)
	qui su convenio_june
	estadd scalar DepVarMean=r(mean)
	qui su p_actor if treatment!=0
	estadd scalar IntMean=r(mean)
	qui  test 1.treatment=3.treatment
	estadd scalar Pvalue=r(p)
	qui testparm i(2/3).treatment
	estadd scalar Pvalue_=r(p)	
	
	*****************************
	eststo: reg convenio_oct i.treatment##i.p_actor ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
	estadd scalar Erre=e(r2)
	qui su convenio_oct
	estadd scalar DepVarMean=r(mean)
	qui su p_actor if treatment!=0
	estadd scalar IntMean=r(mean)
	qui  test 1.treatment=3.treatment
	estadd scalar Pvalue=r(p)
	qui testparm i(2/3).treatment
	estadd scalar Pvalue_=r(p)	
	
*************************************EMPLOYEE***********************************
********************************************************************************

use "$sharelatex\DB\Calculadora_wod.dta", clear	
merge m:1 folio using  "$sharelatex/Raw/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:m expediente anio using "$sharelatex\DB\Base_Seguimiento.dta", keep(1 3) keepusing(tratamientoquelestoco c1_se_concilio p_actor c1_fecha_convenio seconcilio)
drop _merge

*Persistent conciliation variable
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)

gen fecha_con=date(c1_fecha_convenio,"DMY")
bysort expediente anio : egen fecha_convenio=max(fecha_con)
format fecha_convenio %td

duplicates drop folio tratamientoqueles conciliation, force

	*June
gen june="30/05/2016"
gen cortejune=date(june,"DMY")
gen convenio_june=conciliation
replace convenio_june=0 if fecha_convenio>=cortejune & !missing(conciliation)

 
	*October
gen oct="30/10/2016"
gen corteoct=date(oct,"DMY")
gen convenio_oct=conciliation
replace convenio_oct=0 if fecha_convenio>=corteoct & !missing(conciliation)

 
*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_a=A_5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_rel=rel_oc, nq(100)
drop if perc_rel>=98

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

		
eststo: reg convenio_june i.treatment##c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su convenio_june if treatment!=0
estadd scalar DepVarMean=r(mean)
qui su rel_oc if treatment!=0
estadd scalar IntMean=r(mean)
qui  test 1.treatment=3.treatment
estadd scalar Pvalue=r(p)
qui testparm i(2/3).treatment
estadd scalar Pvalue_=r(p)	

***************************

eststo: reg convenio_oct i.treatment##c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su convenio_oct if treatment!=0
estadd scalar DepVarMean=r(mean)
qui su rel_oc if treatment!=0
estadd scalar IntMean=r(mean)
qui  test 1.treatment=3.treatment
estadd scalar Pvalue=r(p)
qui testparm i(2/3).treatment
estadd scalar Pvalue_=r(p)

********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m expediente anio using "$sharelatex\DB\Base_Seguimiento.dta", keep(1 3) keepusing(tratamientoquelestoco c1_se_concilio p_actor c1_fecha_convenio seconcilio)
drop _merge

*Persistent conciliation variable
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)

gen fecha_con=date(c1_fecha_convenio,"DMY")
bysort expediente anio : egen fecha_convenio=max(fecha_con)
format fecha_convenio %td

duplicates drop folio tratamientoqueles conciliation, force

	*June
gen june="30/05/2016"
gen cortejune=date(june,"DMY")
gen convenio_june=conciliation
replace convenio_june=0 if fecha_convenio>=cortejune & !missing(conciliation)
 
	*October
gen oct="30/10/2016"
gen corteoct=date(oct,"DMY")
gen convenio_oct=conciliation
replace convenio_oct=0 if fecha_convenio>=corteoct & !missing(conciliation)


*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_ra=RA_5_5-comp_esp
gen rel_oc=oc_/comp_esp

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


eststo: reg convenio_june i.treatment##c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su convenio_june if treatment!=0
estadd scalar DepVarMean=r(mean)
qui su rel_oc if treatment!=0
estadd scalar IntMean=r(mean)
qui  test 1.treatment=3.treatment
estadd scalar Pvalue=r(p)
qui testparm i(2/3).treatment
estadd scalar Pvalue_=r(p)	

***************************

eststo: reg convenio_oct i.treatment##c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su convenio_oct if treatment!=0
estadd scalar DepVarMean=r(mean)
qui su rel_oc if treatment!=0
estadd scalar IntMean=r(mean)
qui  test 1.treatment=3.treatment
estadd scalar Pvalue=r(p)
qui testparm i(2/3).treatment
estadd scalar Pvalue_=r(p)


********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$sharelatex\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m expediente anio using "$sharelatex\DB\Base_Seguimiento.dta", keep(1 3) keepusing(tratamientoquelestoco c1_se_concilio p_actor c1_fecha_convenio seconcilio)
drop _merge

*Persistent conciliation variable
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)

gen fecha_con=date(c1_fecha_convenio,"DMY")
bysort expediente anio : egen fecha_convenio=max(fecha_con)
format fecha_convenio %td

duplicates drop folio tratamientoqueles conciliation, force

	*June
gen june="30/05/2016"
gen cortejune=date(june,"DMY")
gen convenio_june=conciliation
replace convenio_june=0 if fecha_convenio>=cortejune & !missing(conciliation)
 
	*October
gen oct="30/10/2016"
gen corteoct=date(oct,"DMY")
gen convenio_oct=conciliation
replace convenio_oct=0 if fecha_convenio>=corteoct & !missing(conciliation)

 
*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_rd=RD5_5-comp_esp
gen rel_oc=oc_/comp_esp

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


eststo: reg convenio_june i.treatment##c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su convenio_june if treatment!=0
estadd scalar DepVarMean=r(mean)
qui su rel_oc if treatment!=0
estadd scalar IntMean=r(mean)
qui  test 1.treatment=3.treatment
estadd scalar Pvalue=r(p)
qui testparm i(2/3).treatment
estadd scalar Pvalue_=r(p)	

***************************

eststo: reg convenio_oct i.treatment##c.rel_oc ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su convenio_oct if treatment!=0
estadd scalar DepVarMean=r(mean)
qui su rel_oc if treatment!=0
estadd scalar IntMean=r(mean)
qui  test 1.treatment=3.treatment
estadd scalar Pvalue=r(p)
qui testparm i(2/3).treatment
estadd scalar Pvalue_=r(p)


	*************************
	esttab using "$sharelatex\Tables\reg_results\treatment_reg_minicortes_2_B.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" "IntMean InteractionVarMean" "Pvalue Pvalue" "Pvalue_ Pvalue_") replace 
