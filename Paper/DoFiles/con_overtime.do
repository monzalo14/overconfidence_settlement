clear
set more off
global directorio C:\Users\chasi_000\Dropbox\Statistics\P10
global sharelatex C:\Users\chasi_000\Dropbox\Apps\ShareLaTeX\Overconfidence and settlement

********************************************************************************
	*DB: Calculator:5005
import delimited "$directorio\DB\observaciones_tope.csv", clear 

for var c_antiguedad c_indem-c_desc_ob c_recsueldo liq_total: ///
	capture replace X=0 if X<0 & X~=.
	
*Wizorise all at 99th percentile
for var c_* liq_total liq_total_tope: capture egen X99 = pctile(X) , p(99)
for var c_* liq_total liq_total_tope: ///
	capture replace X=X99 if X>X99 & X~=.
drop *99



*Conciliation
gen con=(modo_termino==1)
*Months after initial sue
gen fechadem=date(fecha_demanda,"YMD")
gen fechater=date(fecha_termino,"YMD")
gen months_after=(fechater-fechadem)/30

gen perc_con_5005=.
gen time=.

qui su con
local obs=`r(N)'
local n=1
forvalues i=0(0.25)60 {

	*Total
	qui count if  months_after<=`i' & con==1
	qui replace perc_con_5005=`r(N)'/`obs' in `n'
	
	qui replace time=`i' in `n'
	local n=`n'+1
	
	}

keep perc_con time
drop if time==.
tempfile temp5005
save `temp5005'


********************************************************************************
	*DB: March Pilot
use "$directorio\DB\DB3\Base_Seguimiento.dta", clear
merge m:1 expediente anio using "$directorio\DB\Calculadora_wod.dta", keep(1 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) nogen keepusing(tratamientoquelestoco)


*Persistent conciliation variable
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)

gen fecha_con=date(c1_fecha_convenio,"DMY")
bysort expediente anio : egen fecha_convenio=max(fecha_con)
format fecha_convenio %td

*Conciliation
gen con=c1_se_concilio

*Months after initial sue
gen fechadem=date(fecha_demanda,"DMY")
gen fechater=fecha_convenio
gen months_after=(fechater-fechadem)/30
replace months_after=. if months_after<0
xtile perc=months_after, nq(99)
replace months_after=. if perc>=99

gen perc_con_pilot=.
gen perc_con_t1=.
gen perc_con_t2=.
gen perc_con_t3=.
gen time=.

qui su con
local obs=`r(N)'
qui su con if tratamientoquelestoco==1
local obs1=`r(N)'
qui su con if tratamientoquelestoco==2
local obs2=`r(N)'
qui su con if tratamientoquelestoco==3
local obs3=`r(N)'
local n=1
forvalues i=0(0.25)60 {

	*Total
	qui count if  months_after<=`i' & con==1
	qui replace perc_con_pilot=`r(N)'/`obs' in `n'
	*Control
	qui count if  months_after<=`i' & con==1 & tratamientoquelestoco==1
	qui replace perc_con_t1=`r(N)'/`obs1' in `n'
	*Calculator
	qui count if  months_after<=`i' & con==1 & tratamientoquelestoco==2
	qui replace perc_con_t2=`r(N)'/`obs2' in `n'	
	*Conciliator
	qui count if  months_after<=`i' & con==1 & tratamientoquelestoco==3
	qui replace perc_con_t3=`r(N)'/`obs3' in `n'	
	
	qui replace time=`i' in `n'
	local n=`n'+1
	
	}

keep perc_con* time
drop if time==.
merge 1:1 time using `temp5005', nogen

twoway 	(line perc_con_t1 time, lwidth(medthick) lpattern(solid)) ///
		(line perc_con_t2 time, lwidth(medthick) lpattern(dash)) ///
		(line perc_con_t3 time, lwidth(medthick) lpattern(dot)) ///
	, graphregion(color(none)) scheme(s2mono)  ///
	xtitle("Months after initial sue") ytitle(" ") ///
	xlabel(0(10)60) ///
	legend(order(1 "Ctrl" 2 "Calc" 3 "Conc") rows(1)) name(treat, replace)
	
twoway 	(line perc_con_5005 time, lwidth(medthick) lpattern(solid)) ///
		(line perc_con_5005 time, lwidth(medthick) lpattern(solid)) ///
	, graphregion(color(none)) scheme(s2mono)  ///
	xtitle("Months after initial sue") ytitle("Percentage of conciliation files") ///
	xlabel(0(10)60) ///
	legend(order(1 "DB: 5005")) name(db5005, replace)

graph combine db5005 treat,  row(1)  graphregion(color(none)) scheme(s2mono)
graph export "$sharelatex/Figuras/con_overtime.pdf", replace 