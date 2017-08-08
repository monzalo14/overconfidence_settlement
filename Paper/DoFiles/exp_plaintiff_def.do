

*EMPLOYEE LAWYER
use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)

	*Expectations variables	
*Money
gen diff_amount=RA_5_5-exp_comp
rename RA_5_5 amount
*Prob
rename RA_5_1 Prob_win
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100
gen diff_prob=Prob_win-Prob_win_calc
*Time
rename RA_5_8 time


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


keep amount Prob_win time diff_amount diff_prob ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	 codem  
	
gen emplaw=1	

tempfile tempemplaw
save `tempemplaw'

*FIRM LAWYER
use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)

	*Expectations variables	
*Money
gen diff_amount=RD5_5-exp_comp
rename RD5_5 amount
*Prob
rename RD5_1_1 Prob_win
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100
gen diff_prob=Prob_win-Prob_win_calc
*Time
rename RD5_8 time


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


keep amount Prob_win time diff_amount diff_prob ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	 codem  
	
gen firlaw=1

tempfile tempfirlaw
save `tempfirlaw'

*EMPLOYEE
use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	
merge m:1 folio using  "$sharelatex/Raw/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:m folio using "$sharelatex/DB/pilot_operation.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=97

	*Expectations variables	
*Money
gen diff_amount=A_5_5-exp_comp
rename A_5_5 amount
*Prob
rename A_5_1 Prob_win
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100
gen diff_prob=Prob_win-Prob_win_calc
*Time
rename A_5_8 time


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


keep amount Prob_win time diff_amount diff_prob ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	 codem  
	
gen emp=1	

append using `tempemplaw'
append using `tempfirlaw'


*Dummy for who answers survey
replace emp=0 if missing(emp)
replace emplaw=0 if missing(emplaw)
replace firlaw=0 if missing(firlaw)

*Dummy product who answers and type of (employee) lawyer
gen emp_pub=(emp==1 & abogado_pub==1)
gen emp_pri=(emp==1 & abogado_pub==0)

gen emplaw_pub=(emplaw==1 & abogado_pub==1)
gen emplaw_pri=(emplaw==1 & abogado_pub==0)



/***********************
       REGRESSIONS
************************/

eststo clear

eststo: reg amount emp_pub emplaw_pub emplaw_pri firlaw ///
	gen trabajador_base c_antiguedad salario_diario horas_sem , robust
estadd scalar Erre=e(r2)
qui su amount 
estadd scalar DepVarMean=r(mean)
qui  test emp_pub=emplaw_pub
estadd scalar Pvalue1=r(p)
qui  test emp_pub=emplaw_pri
estadd scalar Pvalue2=r(p)		


eststo: reg amount emp_pub emplaw_pub emplaw_pri firlaw ///
	gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	 codem  , robust
estadd scalar Erre=e(r2)
qui su amount 
estadd scalar DepVarMean=r(mean)
qui  test emp_pub=emplaw_pub
estadd scalar Pvalue1=r(p)
qui  test emp_pub=emplaw_pri
estadd scalar Pvalue2=r(p)	

***************************

eststo: reg Prob_win emp_pub emplaw_pub emplaw_pri firlaw ///
	gen trabajador_base c_antiguedad salario_diario horas_sem , robust
estadd scalar Erre=e(r2)
qui su Prob_win 
estadd scalar DepVarMean=r(mean)
qui  test emp_pub=emplaw_pub
estadd scalar Pvalue1=r(p)
qui  test emp_pub=emplaw_pri
estadd scalar Pvalue2=r(p)		


eststo: reg Prob_win emp_pub emplaw_pub emplaw_pri firlaw ///
	gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	 codem  , robust
estadd scalar Erre=e(r2)
qui su Prob_win 
estadd scalar DepVarMean=r(mean)
qui  test emp_pub=emplaw_pub
estadd scalar Pvalue1=r(p)
qui  test emp_pub=emplaw_pri
estadd scalar Pvalue2=r(p)	

***************************

eststo: reg time emp_pub emplaw_pub emplaw_pri firlaw ///
	gen trabajador_base c_antiguedad salario_diario horas_sem , robust
estadd scalar Erre=e(r2)
qui su time 
estadd scalar DepVarMean=r(mean)
qui  test emp_pub=emplaw_pub
estadd scalar Pvalue1=r(p)
qui  test emp_pub=emplaw_pri
estadd scalar Pvalue2=r(p)		


eststo: reg time emp_pub emplaw_pub emplaw_pri firlaw ///
	gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	 codem  , robust
estadd scalar Erre=e(r2)
qui su time 
estadd scalar DepVarMean=r(mean)
qui  test emp_pub=emplaw_pub
estadd scalar Pvalue1=r(p)
qui  test emp_pub=emplaw_pri
estadd scalar Pvalue2=r(p)	

***************************

eststo: reg diff_amount emp_pub emplaw_pub emplaw_pri firlaw ///
	gen trabajador_base c_antiguedad salario_diario horas_sem , robust
estadd scalar Erre=e(r2)
qui su diff_amount 
estadd scalar DepVarMean=r(mean)
qui  test emp_pub=emplaw_pub
estadd scalar Pvalue1=r(p)
qui  test emp_pub=emplaw_pri
estadd scalar Pvalue2=r(p)		


eststo: reg diff_amount emp_pub emplaw_pub emplaw_pri firlaw ///
	gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	 codem  , robust
estadd scalar Erre=e(r2)
qui su diff_amount 
estadd scalar DepVarMean=r(mean)
qui  test emp_pub=emplaw_pub
estadd scalar Pvalue1=r(p)
qui  test emp_pub=emplaw_pri
estadd scalar Pvalue2=r(p)	

***************************

eststo: reg diff_prob emp_pub emplaw_pub emplaw_pri firlaw ///
	gen trabajador_base c_antiguedad salario_diario horas_sem , robust
estadd scalar Erre=e(r2)
qui su diff_prob 
estadd scalar DepVarMean=r(mean)
qui  test emp_pub=emplaw_pub
estadd scalar Pvalue1=r(p)
qui  test emp_pub=emplaw_pri
estadd scalar Pvalue2=r(p)		


eststo: reg diff_prob emp_pub emplaw_pub emplaw_pri firlaw ///
	gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	 codem  , robust
estadd scalar Erre=e(r2)
qui su diff_prob 
estadd scalar DepVarMean=r(mean)
qui  test emp_pub=emplaw_pub
estadd scalar Pvalue1=r(p)
qui  test emp_pub=emplaw_pri
estadd scalar Pvalue2=r(p)	


*************************
esttab using "$sharelatex\Tables\reg_results\exp_plaintiff_def.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean"  "Pvalue1 Pvalue1" "Pvalue2 Pvalue2") replace 
