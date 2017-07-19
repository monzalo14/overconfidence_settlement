

use "$directorio\DB\treatment_data.dta", clear

********************************************************************************
drop if grupo_tratamiento=="0"
egen treatment=group(grupo_tratamiento)

*Cumulative files
collapse (count) dow , by(date treatment)
sort treatment date
by treatment: gen cum=sum(dow)
tsset treatment date 

twoway (tsline cum if treatment==1,  graphregion(color(none)) ///
	xtitle("Date") ytitle("#") lwidth(thick) lcolor(red)) ///
	(tsline cum if treatment==2,  graphregion(color(none)) ///
	xtitle("Date") ytitle("#") lwidth(thick) lcolor(navy)) ///
	(tsline cum if treatment==3,  graphregion(color(none)) ///
	xtitle("Date") ytitle("#") lwidth(thick) lcolor(dkgreen)) ///
	(tsline cum if treatment==4,  graphregion(color(none)) ///
	xtitle("Date") ytitle("#") lwidth(thick) lcolor(black)) ///
	, scheme(s2mono) legend(order(1 "1A" 2 "1B" 3 "3" 4 "4"))
graph export "$directorio/Figuras/cum_num_cases_tr.pdf", replace 

collapse (sum) dow, by(date)
gen cum=sum(dow)

tsline cum, scheme(s2mono) graphregion(color(none)) ///
	xtitle("Date") ytitle("#") lwidth(thick)
graph export "$directorio/Figuras/cum_num_cases.pdf", replace 
	

