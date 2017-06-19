use "$directorio\DB\DB3\Base_Seguimiento.dta", clear
merge m:1 expediente anio using "$directorio\DB\Calculadora_wod.dta", keep(1 3)
drop _merge


*Persistent conciliation variable
replace seconcilio=1 if c1_fecha_con==fechalista
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)

*Conciliation date
replace c1_fecha_convenio=fechalista if seconcilio==1 & c1_se_concilio==1
gen fecha_con=date(c1_fecha_convenio,"DMY")
bysort expediente anio : egen fecha_convenio=max(fecha_con)
format fecha_convenio %td

*Treatment date
gen fecha_treat=date(fechalista,"DMY")
bysort expediente anio : egen fecha_treatment=min(fecha_treat)
format fecha_treatment %td


*Months after initial sue
gen fechadem=date(fecha_demanda,"DMY")
gen months_after=(fecha_treatment-fechadem)/30
replace months_after=. if months_after<0
xtile perc=months_after, nq(99)
replace months_after=. if perc>=99



rename tratamientoquelestoco treatment
*Collapse tretament Calculator and Conciliator
replace treatment=2 if treatment==3

gen beta=.
gen low=.
gen high=.

forvalues i=0(10)50 {

reg conciliation i.treatment ///
	if treatment!=0 & (inrange(months_after,`i',`í'+10) | missing(months_after) ), robust

local n=`i'+5	
replace beta=_b[2.treatment] in `n'
replace low=_b[2.treatment] - invttail(e(df_r),0.025) * _se[2.treatment] in `n'
replace high=_b[2.treatment] + invttail(e(df_r),0.025) * _se[2.treatment] in `n'
	
}

*X-axis	
gen num=_n
	
twoway (rcap high low num if num<=60, msize(vhuge) lwidth(thick) lcolor(gray) yaxis(1)) ///
		(scatter beta num if num<=60, msymbol(O) msize(large) mlwidth(thick) ///
			mlcolor(black) mfcolor(black) yaxis(1)) ///
		(hist months_after if months_after<=60, w(10) freq color(none) lcolor(black) ///
			xlabel(0(10)60) yaxis(2) ) , ytitle("Effect", axis(1)) xtitle("Months after sue") ///
			legend(off) scheme(s2mono) graphregion(color(none))
	
graph export "$sharelatex/Figuras/beta_monthsafter.pdf", replace 
