/*Effect/Update on beleifs*/

	
********************************************************************************
	*PILOT 2
use "$scaleup\DB\Seguimiento_Juntas.dta", clear
rename ao anio
rename expediente exp
merge m:1 junta exp anio using "$scaleup\DB\predicciones.dta"

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
twoway (hist update_comp  if perc_theta<=90, percent w(.1)  ///
	subtitle("Scale Up" , box bexpand) scheme(s2mono) graphregion(color(none)) ///
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
twoway (hist update_comp  if perc_theta<=90, percent w(.1)  ///
	subtitle("Scale Up" , box bexpand) scheme(s2mono) graphregion(color(none)) ///
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
twoway (hist update_comp  if perc_theta<=90, percent w(.1)  ///
	subtitle("Scale Up" , box bexpand) scheme(s2mono) graphregion(color(none)) ///
	xtitle("")  text(`ht' `r(mean)' " `stars' ",  color(black) size(huge) )) ///
	(scatteri 0 `r(mean)' `ht' `r(mean)' if dia_tratamiento!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(firmlawyer_amount, replace) legend(off) note("%obs: `perc_obs'", size(small))
	


********************************************************************************
********************************************************************************
********************************************************************************


	
********************************************************************************
	*PILOT 1	
*Employee
use "$sharelatex\DB\Calculadora_wod.dta", clear	
merge m:1 folio using "$sharelatex/Raw/Merge_Actor_OC.dta", keep(2 3) nogen
rename ES_fecha fecha

merge 1:1 folio fecha using "$sharelatex/DB/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio)

*Drop outlier
xtile perc=A_5_8, nq(99)
replace A_5_8=. if perc>=98

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=abs((ES_1_4-comp_esp)/(A_5_5-comp_esp))

drop if tratamientoquelestoco==0
 
qui xtile perc_theta=update_comp  , nq(99)


*CONTROL 
********************************************************************************
*T-test 
ttest update_comp==1 if perc_theta<=90 & tratamientoquelestoco==1

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
qui su update_comp if tratamientoquelestoco==1
local tot_obs=`r(N)'
qui su update_comp if perc_theta<=90 & tratamientoquelestoco==1
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs' 


*Height of bars 
local ht=0
forvalues i=0(0.2)`r(max)' {
	qui su update_comp if inrange(update_comp,`i',`i'+0.2) & perc_theta<=90 & tratamientoquelestoco==1
	local height=`r(N)'/(`perc_obs'*`tot_obs')*10000
	local ht=max(`ht',`height')
	}
local ht=round(`ht'+5,10)

qui su update_comp if perc_theta<=90 & tratamientoquelestoco==1
*Histogram
twoway (hist update_comp if  perc_theta<=90 & tratamientoquelestoco==1, ///
	percent w(.1)  ///
	text(`ht' `r(mean)' " `stars' ",  color(black) size(huge) ) subtitle("Control", box bexpand) ) ///
	(scatteri 0 `r(mean)' `ht' `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	,legend(off) scheme(s2mono) graphregion(color(none)) ///
	 note("%obs: `perc_obs'", size(small)) ///
	 name(control, replace)
********************************************************************************

*CALCULATOR 
********************************************************************************
*T-test 
ttest update_comp==1 if perc_theta<=90 & tratamientoquelestoco==2

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
qui su update_comp if tratamientoquelestoco==2
local tot_obs=`r(N)'
qui su update_comp if perc_theta<=90 & tratamientoquelestoco==2
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs' 


*Height of bars 
local ht=0
forvalues i=0(0.2)`r(max)' {
	qui su update_comp if inrange(update_comp,`i',`i'+0.2) & perc_theta<=90 & tratamientoquelestoco==2
	local height=`r(N)'/(`perc_obs'*`tot_obs')*10000
	local ht=max(`ht',`height')
	}
local ht=round(`ht'+5,10)

qui su update_comp if perc_theta<=90 & tratamientoquelestoco==2
*Histogram
twoway (hist update_comp if  perc_theta<=90 & tratamientoquelestoco==2, ///
	percent w(.1)  ///
	text(`ht' `r(mean)' " `stars' ",  color(black) size(huge) ) subtitle("Calculator", box bexpand) ) ///
	(scatteri 0 `r(mean)' `ht' `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	,legend(off) scheme(s2mono) graphregion(color(none)) ///
	 note("%obs: `perc_obs'", size(small)) ///
	 name(calc, replace)
********************************************************************************

*CONCILIATOR 
********************************************************************************
*T-test 
ttest update_comp==1 if perc_theta<=90 & tratamientoquelestoco==3

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
qui su update_comp if tratamientoquelestoco==3
local tot_obs=`r(N)'
qui su update_comp if perc_theta<=90 & tratamientoquelestoco==3
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs' 


*Height of bars 
local ht=0
forvalues i=0(0.2)`r(max)' {
	qui su update_comp if inrange(update_comp,`i',`i'+0.2) & perc_theta<=90 & tratamientoquelestoco==3
	local height=`r(N)'/(`perc_obs'*`tot_obs')*10000
	local ht=max(`ht',`height')
	}
local ht=round(`ht'+5,10)

qui su update_comp if perc_theta<=90 & tratamientoquelestoco==3
*Histogram
twoway (hist update_comp if  perc_theta<=90 & tratamientoquelestoco==3, ///
	percent w(.1)  ///
	text(`ht' `r(mean)' " `stars' ",  color(black) size(huge) ) subtitle("Conciliator", box bexpand) ) ///
	(scatteri 0 `r(mean)' `ht' `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	,legend(off) scheme(s2mono) graphregion(color(none)) ///
	 note("%obs: `perc_obs'", size(small)) ///
	 name(conciliator, replace)
********************************************************************************	 

graph combine control calc conciliator employee_amount, ycommon rows(1) scheme(s2mono) graphregion(color(none)) ///
	name(emp, replace) title("Employee")
	

*Employee's Lawyer
use "$sharelatex\DB\Calculadora_wod.dta", clear	
merge m:m folio using "$sharelatex/Raw/Merge_Representante_Actor_OC.dta", keep(2 3) nogen
rename ES_fecha fecha

merge m:1 folio fecha using "$sharelatex/DB/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio)
duplicates drop folio fecha tratamientoquelestoco, force

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=abs((ES_1_4-comp_esp)/(RA_5_5-comp_esp))

drop if tratamientoquelestoco==0

qui xtile perc_theta=update_comp  , nq(99)


*CONTROL 
********************************************************************************
*T-test 
ttest update_comp==1 if perc_theta<=90 & tratamientoquelestoco==1

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
qui su update_comp if tratamientoquelestoco==1
local tot_obs=`r(N)'
qui su update_comp if perc_theta<=90 & tratamientoquelestoco==1
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs' 


*Height of bars 
local ht=0
forvalues i=0(0.2)`r(max)' {
	qui su update_comp if inrange(update_comp,`i',`i'+0.2) & perc_theta<=90 & tratamientoquelestoco==1
	local height=`r(N)'/(`perc_obs'*`tot_obs')*10000
	local ht=max(`ht',`height')
	}
local ht=round(`ht'+5,10)

qui su update_comp if perc_theta<=90 & tratamientoquelestoco==1
*Histogram
twoway (hist update_comp if  perc_theta<=90 & tratamientoquelestoco==1, ///
	percent w(.1)  ///
	text(`ht' `r(mean)' " `stars' ",  color(black) size(huge) ) subtitle("Control", box bexpand) ) ///
	(scatteri 0 `r(mean)' `ht' `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	,legend(off) scheme(s2mono) graphregion(color(none)) ///
	 note("%obs: `perc_obs'", size(small)) ///
	 name(control, replace)
********************************************************************************

*CALCULATOR 
********************************************************************************
*T-test 
ttest update_comp==1 if perc_theta<=90 & tratamientoquelestoco==2

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
qui su update_comp if tratamientoquelestoco==2
local tot_obs=`r(N)'
qui su update_comp if perc_theta<=90 & tratamientoquelestoco==2
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs' 


*Height of bars 
local ht=0
forvalues i=0(0.2)`r(max)' {
	qui su update_comp if inrange(update_comp,`i',`i'+0.2) & perc_theta<=90 & tratamientoquelestoco==2
	local height=`r(N)'/(`perc_obs'*`tot_obs')*10000
	local ht=max(`ht',`height')
	}
local ht=round(`ht'+5,10)

qui su update_comp if perc_theta<=90 & tratamientoquelestoco==2
*Histogram
twoway (hist update_comp if  perc_theta<=90 & tratamientoquelestoco==2, ///
	percent w(.1)  ///
	text(`ht' `r(mean)' " `stars' ",  color(black) size(huge) ) subtitle("Calculator", box bexpand) ) ///
	(scatteri 0 `r(mean)' `ht' `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	,legend(off) scheme(s2mono) graphregion(color(none)) ///
	 note("%obs: `perc_obs'", size(small)) ///
	 name(calc, replace)
********************************************************************************

*CONCILIATOR 
********************************************************************************
*T-test 
ttest update_comp==1 if perc_theta<=90 & tratamientoquelestoco==3

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
qui su update_comp if tratamientoquelestoco==3
local tot_obs=`r(N)'
qui su update_comp if perc_theta<=90 & tratamientoquelestoco==3
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs' 


*Height of bars 
local ht=0
forvalues i=0(0.2)`r(max)' {
	qui su update_comp if inrange(update_comp,`i',`i'+0.2) & perc_theta<=90 & tratamientoquelestoco==3
	local height=`r(N)'/(`perc_obs'*`tot_obs')*10000
	local ht=max(`ht',`height')
	}
local ht=round(`ht'+5,10)

qui su update_comp if perc_theta<=90 & tratamientoquelestoco==3
*Histogram
twoway (hist update_comp if  perc_theta<=90 & tratamientoquelestoco==3, ///
	percent w(.1)  ///
	text(`ht' `r(mean)' " `stars' ",  color(black) size(huge) ) subtitle("Conciliator", box bexpand) ) ///
	(scatteri 0 `r(mean)' `ht' `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	,legend(off) scheme(s2mono) graphregion(color(none)) ///
	 note("%obs: `perc_obs'", size(small)) ///
	 name(conciliator, replace)
********************************************************************************	 

graph combine control calc conciliator employeeslawyer_amount, ycommon rows(1) scheme(s2mono) graphregion(color(none)) ///
	name(emp_law, replace) title("Employee's Lawyer")
	
	
*Firm's Lawyer
use "$sharelatex\DB\Calculadora_wod.dta", clear	
merge m:m folio using "$sharelatex/Raw/Merge_Representante_Demandado_OC.dta", keep(2 3) nogen
rename ES_fecha fecha

merge m:1 folio fecha using "$sharelatex/DB/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio)
duplicates drop folio fecha tratamientoquelestoco, force

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=abs((ES_1_4-comp_esp)/(RD5_5-comp_esp))

drop if tratamientoquelestoco==0

qui xtile perc_theta=update_comp  , nq(99)


*CONTROL 
********************************************************************************
*T-test 
ttest update_comp==1 if perc_theta<=90 & tratamientoquelestoco==1

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
qui su update_comp if tratamientoquelestoco==1
local tot_obs=`r(N)'
qui su update_comp if perc_theta<=90 & tratamientoquelestoco==1
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs' 


*Height of bars 
local ht=0
forvalues i=0(0.2)`r(max)' {
	qui su update_comp if inrange(update_comp,`i',`i'+0.2) & perc_theta<=90 & tratamientoquelestoco==1
	local height=`r(N)'/(`perc_obs'*`tot_obs')*10000
	local ht=max(`ht',`height')
	}
local ht=round(`ht'+5,10)

qui su update_comp if perc_theta<=90 & tratamientoquelestoco==1
*Histogram
twoway (hist update_comp if  perc_theta<=90 & tratamientoquelestoco==1, ///
	percent w(.1)  ///
	text(`ht' `r(mean)' " `stars' ",  color(black) size(huge) ) subtitle("Control", box bexpand) ) ///
	(scatteri 0 `r(mean)' `ht' `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	,legend(off) scheme(s2mono) graphregion(color(none)) ///
	 note("%obs: `perc_obs'", size(small)) ///
	 name(control, replace)
********************************************************************************

*CALCULATOR 
********************************************************************************
*T-test 
ttest update_comp==1 if perc_theta<=90 & tratamientoquelestoco==2

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
qui su update_comp if tratamientoquelestoco==2
local tot_obs=`r(N)'
qui su update_comp if perc_theta<=90 & tratamientoquelestoco==2
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs' 


*Height of bars 
local ht=0
forvalues i=0(0.2)`r(max)' {
	qui su update_comp if inrange(update_comp,`i',`i'+0.2) & perc_theta<=90 & tratamientoquelestoco==2
	local height=`r(N)'/(`perc_obs'*`tot_obs')*10000
	local ht=max(`ht',`height')
	}
local ht=round(`ht'+5,10)

qui su update_comp if perc_theta<=90 & tratamientoquelestoco==2
*Histogram
twoway (hist update_comp if  perc_theta<=90 & tratamientoquelestoco==2, ///
	percent w(.1)  ///
	text(`ht' `r(mean)' " `stars' ",  color(black) size(huge) ) subtitle("Calculator", box bexpand) ) ///
	(scatteri 0 `r(mean)' `ht' `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	,legend(off) scheme(s2mono) graphregion(color(none)) ///
	 note("%obs: `perc_obs'", size(small)) ///
	 name(calc, replace)
********************************************************************************

*CONCILIATOR 
********************************************************************************
*T-test 
ttest update_comp==1 if perc_theta<=90 & tratamientoquelestoco==3

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
qui su update_comp if tratamientoquelestoco==3
local tot_obs=`r(N)'
qui su update_comp if perc_theta<=90 & tratamientoquelestoco==3
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs' 


*Height of bars 
local ht=0
forvalues i=0(0.2)`r(max)' {
	qui su update_comp if inrange(update_comp,`i',`i'+0.2) & perc_theta<=90 & tratamientoquelestoco==3
	local height=`r(N)'/(`perc_obs'*`tot_obs')*10000
	local ht=max(`ht',`height')
	}
local ht=round(`ht'+5,10)

qui su update_comp if perc_theta<=90 & tratamientoquelestoco==3
*Histogram
twoway (hist update_comp if  perc_theta<=90 & tratamientoquelestoco==3, ///
	percent w(.1)  ///
	text(`ht' `r(mean)' " `stars' ",  color(black) size(huge) ) subtitle("Conciliator", box bexpand) ) ///
	(scatteri 0 `r(mean)' `ht' `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	,legend(off) scheme(s2mono) graphregion(color(none)) ///
	 note("%obs: `perc_obs'", size(small)) ///
	 name(conciliator, replace)
********************************************************************************	 

graph combine control calc conciliator firmlawyer_amount, ycommon rows(1) scheme(s2mono) graphregion(color(none)) ///
	name(fir_law, replace) title("Firm's Lawyer")
	

	
	
********



graph combine emp emp_law fir_law , ///
	xcommon ycommon rows(3)  graphregion(color(none)) 
graph export "$sharelatex/Figuras/updatebeleif_amount_total.pdf", replace 

