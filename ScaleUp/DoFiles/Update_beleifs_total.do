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
capture drop perc_theta
qui xtile perc_theta=update_comp  , nq(99)

*T-test 
ttest update_comp==1 if perc_theta<=90 & dia_tratamiento!=0

if `r(p)'<=0.01 {
	local stars="***"
	}
else {
	if `r(p)'<=0.05 {
		local stars="**"
		}
	else {
		if `r(p)'<=0.1 {
			local stars="*"
		}
		else {
			local stars=""
			}
		}
	}
	

*Mean
qui su update_comp if dia_tratamiento!=0
local tot_obs=`r(N)'
qui su update_comp if perc_theta<=90 & dia_tratamiento!=0
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs' 


*Height of bars 
local ht=0
forvalues i=0(0.2)`r(max)' {
	qui su update_comp if inrange(update_comp,`i',`i'+0.2) & perc_theta<=90 & dia_tratamiento!=0
	local height=`r(N)'/(`perc_obs'*`tot_obs')*10000
	local ht=max(`ht',`height')
	}
local ht=round(`ht'+5,10)

qui su update_comp if perc_theta<=90 & dia_tratamiento!=0
*Histogram
twoway (hist update_comp  if perc_theta<=90, percent w(.05)  ///
	subtitle("Employee") scheme(s2mono) graphregion(color(none)) ///
	xtitle("")  text(`ht' `r(mean)' " `stars' ",  color(black) size(huge) )) ///
	(scatteri 0 `r(mean)' `ht' `r(mean)' if dia_tratamiento!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(employee_amount, replace) legend(off) note("%obs: `perc_obs'", size(small))
	

*Employee's Lawyer

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
replace update_comp=abs((era5_cantidad_pago_s-comp_esp)/(era2_cantidad_pago-comp_esp))
capture drop perc_theta
qui xtile perc_theta=update_comp  , nq(99)

*T-test 
ttest update_comp==1 if perc_theta<=90 & dia_tratamiento!=0

if `r(p)'<=0.01 {
	local stars="***"
	}
else {
	if `r(p)'<=0.05 {
		local stars="**"
		}
	else {
		if `r(p)'<=0.1 {
			local stars="*"
		}
		else {
			local stars=""
			}
		}
	}
	

*Mean
qui su update_comp if dia_tratamiento!=0
local tot_obs=`r(N)'
qui su update_comp if perc_theta<=90 & dia_tratamiento!=0
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs' 


*Height of bars 
local ht=0
forvalues i=0(0.2)`r(max)' {
	qui su update_comp if inrange(update_comp,`i',`i'+0.2) & perc_theta<=90 & dia_tratamiento!=0
	local height=`r(N)'/(`perc_obs'*`tot_obs')*10000
	local ht=max(`ht',`height')
	}
local ht=round(`ht'+5,10)

qui su update_comp if perc_theta<=90 & dia_tratamiento!=0
*Histogram
twoway (hist update_comp  if perc_theta<=90, percent w(.05)  ///
	subtitle("Employee's Lawyer") scheme(s2mono) graphregion(color(none)) ///
	xtitle("")  text(`ht' `r(mean)' " `stars' ",  color(black) size(huge) )) ///
	(scatteri 0 `r(mean)' `ht' `r(mean)' if dia_tratamiento!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(employeeslawyer_amount, replace) legend(off) note("%obs: `perc_obs'", size(small))
	
*Firm's Lawyer

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
replace update_comp=abs((erd5_cantidad_pago_s-comp_esp)/(erd2_cantidad_pago-comp_esp))
capture drop perc_theta
qui xtile perc_theta=update_comp  , nq(99)

*T-test 
ttest update_comp==1 if perc_theta<=90 & dia_tratamiento!=0

if `r(p)'<=0.01 {
	local stars="***"
	}
else {
	if `r(p)'<=0.05 {
		local stars="**"
		}
	else {
		if `r(p)'<=0.1 {
			local stars="*"
		}
		else {
			local stars=""
			}
		}
	}
	

*Mean
qui su update_comp if dia_tratamiento!=0
local tot_obs=`r(N)'
qui su update_comp if perc_theta<=90 & dia_tratamiento!=0
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs' 


*Height of bars 
local ht=0
forvalues i=0(0.2)`r(max)' {
	qui su update_comp if inrange(update_comp,`i',`i'+0.2) & perc_theta<=90 & dia_tratamiento!=0
	local height=`r(N)'/(`perc_obs'*`tot_obs')*10000
	local ht=max(`ht',`height')
	}
local ht=round(`ht'+5,10)

qui su update_comp if perc_theta<=90 & dia_tratamiento!=0
*Histogram
twoway (hist update_comp  if perc_theta<=90, percent w(.05)  ///
	subtitle("Firm's Lawyer") scheme(s2mono) graphregion(color(none)) ///
	xtitle("")  text(`ht' `r(mean)' " `stars' ",  color(black) size(huge) )) ///
	(scatteri 0 `r(mean)' `ht' `r(mean)' if dia_tratamiento!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(firmlawyer_amount, replace) legend(off) note("%obs: `perc_obs'", size(small))
	

	
	
********



graph combine employee_amount employeeslawyer_amount firmlawyer_amount, ///
	xcommon ycommon rows(3)  graphregion(color(none))	
graph export "$directorio/Figures/updatebeleif_amount_total.pdf", replace 
	
