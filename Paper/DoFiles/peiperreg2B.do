/*Plots dummies lawyers*/

clear
set more off
global directorio C:\Users\chasi_000\Dropbox\Statistics\P10
set matsize 1500

import delimited "$directorio\DB\observaciones_tope.csv", clear 


for var c_antiguedad c_indem-c_desc_ob c_recsueldo liq_total: ///
	capture replace X=0 if X<0 & X~=.
	
*Wizorise all at 99th percentile
for var c_* liq_total liq_total_tope: capture egen X99 = pctile(X) , p(99)
for var c_* liq_total liq_total_tope: ///
	capture replace X=X99 if X>X99 & X~=.
drop *99


destring salario_diario, force replace


*We define win as liq_total>0
gen win=(liq_total>0)


*Define dummies
egen desp_uni=group(despacho_ac)

/***********************
       REGRESSIONS
************************/

preserve
*Simple
qui xi : statsby , clear : regress win i.desp_uni 
gen id=1
reshape long _b_Idesp_uni_ , i(id) j(desp_uni)
rename _b_Idesp_uni_ beta_simple
keep desp_uni beta_simple
tempfile simple
save `simple'
restore

preserve
*Basic 
qui xi : statsby , clear : regress win i.desp_uni /// 
	trabajador_base c_antiguedad salario_diario horas_sem 
gen id=1
reshape long _b_Idesp_uni_ , i(id) j(desp_uni)
rename _b_Idesp_uni_ beta_basic
keep desp_uni beta_basic
tempfile basic
save `basic'
restore

preserve
*Strategic
qui xi : statsby , clear : regress win i.desp_uni /// 
	trabajador_base c_antiguedad salario_diario horas_sem ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem c_total 
gen id=1
reshape long _b_Idesp_uni_ , i(id) j(desp_uni)
rename _b_Idesp_uni_ beta_strategic
keep desp_uni beta_strategic
tempfile strategic
save `strategic'
restore

use `simple', clear
merge 1:1 desp_uni using `basic', nogen
merge 1:1 desp_uni using `strategic', nogen



	  
twoway (histogram beta_simple ,  percent color(ltblue)) ///
       (histogram beta_basic , percent fcolor(none) lcolor(black)) ///
       (histogram beta_strategic , percent fcolor(none) lcolor(red))   ///	   
	   , legend(order(1 "Simple" 2 "Basic" 3 "Strategic") row(1)) ///
	   title("Coefficient dummies lawyer office") ///
	   xtitle("Beta coefficients") ytitle("Frequency") ///
	   graphregion(color(none)) scheme(s2mono) 
graph export "$directorio/Plots/Figuras/Beta_dum.pdf", replace 
graph export "$sharelatex/Figuras/Beta_dum.pdf", replace 


