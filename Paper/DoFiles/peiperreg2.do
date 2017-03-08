clear
set more off
global directorio C:\Users\chasi_000\Dropbox\Statistics\P10


import delimited "$directorio\DB\observaciones_tope.csv", clear 


for var c_antiguedad c_indem-c_desc_ob c_recsueldo liq_total: ///
	capture replace X=0 if X<0 & X~=.
	
*Wizorise all at 99th percentile
for var c_* liq_total liq_total_tope: capture egen X99 = pctile(X) , p(99)
for var c_* liq_total liq_total_tope: ///
	capture replace X=X99 if X>X99 & X~=.
drop *99


destring salario_diario, force replace



/***********************
       REGRESSIONS
************************/


eststo clear

local reg="Convenio"
		
eststo: areg abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if modo_termino==1, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
qui su abogado_pub if modo_termino==1
estadd scalar DepVarMean=r(mean)
estadd local Conditioning="`reg'"

eststo: areg abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem c_total ///
	if modo_termino==1, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
estadd local Conditioning="`reg'"

*************************

local reg="Desistimiento"

eststo: areg abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if modo_termino==2, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
qui su abogado_pub if modo_termino==2
estadd scalar DepVarMean=r(mean)
estadd local Conditioning="`reg'"

eststo: areg abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem c_total ///
	if modo_termino==2, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
estadd local Conditioning="`reg'"

*************************

local reg="Laudo"

eststo: areg abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if modo_termino==3, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
qui su abogado_pub if modo_termino==3
estadd scalar DepVarMean=r(mean)
estadd local Conditioning="`reg'"

eststo: areg abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem c_total ///
	if modo_termino==3, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
estadd local Conditioning="`reg'"

*************************

local reg="Caducidad"

eststo: areg abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	if modo_termino==4, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
qui su abogado_pub if modo_termino==4
estadd scalar DepVarMean=r(mean)
estadd local Conditioning="`reg'"

eststo: areg abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem c_total ///
	if modo_termino==4, absorb(giro_empresa) robust
estadd scalar Erre=e(r2)
estadd local Conditioning="`reg'"


esttab using "$directorio\Results\Results_3\Regressions\Reg2_lawyer.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean" "Conditioning Conditioning") replace 
