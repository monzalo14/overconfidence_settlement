

use "$directorio\DB\treatment_data.dta", clear

********************************************************************************

*Cumulative files
collapse (count) dow , by(date)
tsset date
gen cum=sum(dow)

tsline cum, scheme(s2mono) graphregion(color(none)) ///
	xtitle("Date") ytitle("#") lwidth(thick)
graph export "$directorio/Figuras/cum_num_cases.pdf", replace 
	


