********************************************************************************

use "$directorio\DB\Seguimiento_Juntas.dta", clear
rename ao anio
rename expediente exp
merge m:1 junta exp anio using "$directorio\DB\predicciones.dta"

********************************************************************************

*Expected compensation
gen comp_esp=liq_total_laudo_avg

*Update_comp "theta" 
gen update_comp=. 
 
*Employee
 
*Measure of update in beliefs:  |P-E_e|/|P-E_b|
replace update_comp=abs((ea9_cantidad_pago_s-comp_esp)/(ea2_cantidad_pago-comp_esp))

qui su update_comp
local tot_obs=`r(N)'
qui su update_comp if  update_comp>=0 & update_comp <=1
local perc_obs=round(`r(N)'/`tot_obs'*100,.1)
local perc_obs : di %3.1f `perc_obs'

twoway (hist update_comp  if update_comp>=0 & update_comp <=1, percent w(.1) xlabel(0(0.1)1) ///
	subtitle("Employee") scheme(s2mono) graphregion(color(none)) ///
	xtitle("") ) ///
	(scatteri 0 `r(mean)' 40 `r(mean)' if dia_tratamiento!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(employee_amount, replace) legend(off) note("%obs: `perc_obs'", size(small))
	

*Employee's Lawyer

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
replace update_comp=abs((era5_cantidad_pago_s-comp_esp)/(era2_cantidad_pago-comp_esp))

qui su update_comp
local tot_obs=`r(N)'
qui su update_comp if  update_comp>=0 & update_comp <=1
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs'

twoway (hist update_comp  if update_comp>=0 & update_comp <=1, percent w(.1) xlabel(0(0.1)1) ///
	subtitle("Employee's Lawyer") scheme(s2mono) graphregion(color(none)) ///
	xtitle("") ) ///
	(scatteri 0 `r(mean)' 40 `r(mean)' if dia_tratamiento!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(employeeslawyer_amount, replace) legend(off) note("%obs: `perc_obs'", size(small))
	
*Firm's Lawyer

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
replace update_comp=abs((erd5_cantidad_pago_s-comp_esp)/(erd2_cantidad_pago-comp_esp))

qui su update_comp
local tot_obs=`r(N)'
qui su update_comp if  update_comp>=0 & update_comp <=1
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs'

twoway (hist update_comp  if update_comp>=0 & update_comp <=1, percent w(.1) xlabel(0(0.1)1) ///
	subtitle("Firm's Lawyer") scheme(s2mono) graphregion(color(none)) ///
	xtitle("") ) ///
	(scatteri 0 `r(mean)' 40 `r(mean)' if dia_tratamiento!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(firmlawyer_amount, replace) legend(off) note("%obs: `perc_obs'", size(small))
	

	
	
********



graph combine employee_amount employeeslawyer_amount firmlawyer_amount, ///
	xcommon ycommon rows(3)  graphregion(color(none))	
graph export "$directorio/Figures/updatebeleif_amount.pdf", replace 
	
