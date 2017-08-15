use "$sharelatex\DB\pilot_operation.dta", clear
merge m:1 expediente anio using "$sharelatex\DB\pilot_casefiles_wod.dta", keep(1 3)
drop _merge


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
