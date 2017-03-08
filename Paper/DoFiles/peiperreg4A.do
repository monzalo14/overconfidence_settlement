/*Treatment regression*/

use "$directorio\_aux\Programa_Aleatorizacion.dta", clear
merge m:1 folio using "$directorio\DB\Calculadora_wod.dta", keep(1 3)
drop _merge


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

rename tratamientoquelestoco treatment

eststo clear

*Simple regression
eststo: reg seconcilio i.treatment if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su seconcilio 
estadd scalar DepVarMean=r(mean)
*Interaction file order
eststo: reg seconcilio i.treatment##c.orden_exp if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su orden_exp if treatment!=0
estadd scalar IntMean=r(mean)
*Interaction employee was present
eststo: reg seconcilio i.treatment##i.p_actor if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su p_actor if treatment!=0
estadd scalar IntMean=r(mean)
*Basic Controls
eststo: reg seconcilio i.treatment##i.p_actor ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su p_actor if treatment!=0
estadd scalar IntMean=r(mean)
*Strategic Controls
eststo: reg seconcilio i.treatment##i.p_actor ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	codem c_total ///
	if treatment!=0, robust
estadd scalar Erre=e(r2)
qui su p_actor if treatment!=0
estadd scalar IntMean=r(mean)
	

*************************

esttab using "$directorio\Results\Results_3\Regressions\treatment_reg.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" "IntMean InteractionVarMean") replace 
