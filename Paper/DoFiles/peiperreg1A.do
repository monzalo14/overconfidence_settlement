********************************************************************************
********************************EXPECTATION*************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
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
  
 
eststo clear

preserve
*Employee
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3)
rename A_5_1 masprob_employee
rename A_5_5 dineromasprob_employee

local no="NO"

eststo: reg masprob abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	,  robust
estadd scalar Erre=e(r2)
qui su masprob 
estadd scalar DepVarMean=r(mean)
estadd local dummygiro="`no'"

eststo: reg masprob abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	codem c_total,  robust
estadd scalar Erre=e(r2)
estadd local dummygiro="`no'"

*************************

eststo: reg dineromasprob abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	,  robust
estadd scalar Erre=e(r2)
qui su dineromasprob 
estadd scalar DepVarMean=r(mean)
estadd local dummygiro="`no'"

eststo: reg dineromasprob abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	codem c_total,  robust
estadd scalar Erre=e(r2)
estadd local dummygiro="`no'"

restore

preserve
*Employee's Lawyer
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Actor.dta" , keep(2 3)
rename RA_5_1 masprob_law_emp
replace masprob=masprob/100
rename RA_5_5 dineromasprob_law_emp

local no="NO"

eststo: reg masprob abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	,  robust
estadd scalar Erre=e(r2)
qui su masprob 
estadd scalar DepVarMean=r(mean)
estadd local dummygiro="`no'"

eststo: reg masprob abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	codem c_total,  robust
estadd scalar Erre=e(r2)
estadd local dummygiro="`no'"

*************************

eststo: reg dineromasprob abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	,  robust
estadd scalar Erre=e(r2)
qui su dineromasprob 
estadd scalar DepVarMean=r(mean)
estadd local dummygiro="`no'"

eststo: reg dineromasprob abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	codem c_total,  robust
estadd scalar Erre=e(r2)
estadd local dummygiro="`no'"

restore


preserve
*Firm's Lawyer
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3)
rename RD5_1_1 masprob_law_firm
replace masprob=masprob/100
rename RD5_5 dineromasprob_law_firm
	
local no="NO"

eststo: reg masprob abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	,  robust
estadd scalar Erre=e(r2)
qui su masprob 
estadd scalar DepVarMean=r(mean)
estadd local dummygiro="`no'"

eststo: reg masprob abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	codem c_total,  robust
estadd scalar Erre=e(r2)
estadd local dummygiro="`no'"

*************************

eststo: reg dineromasprob abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	,  robust
estadd scalar Erre=e(r2)
qui su dineromasprob 
estadd scalar DepVarMean=r(mean)
estadd local dummygiro="`no'"

eststo: reg dineromasprob abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	codem c_total,  robust
estadd scalar Erre=e(r2)
estadd local dummygiro="`no'"

restore

********************************************************************************
esttab using "$directorio\Results\Results_3\Regressions\Reg1_expectation.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" "dummygiro DummyGiro" ) replace 

********************************************************************************
********************************************************************************
