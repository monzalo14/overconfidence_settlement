/*Effect/Update on beleifs*/


*Employee
use "$directorio/DB/Merge_Actor_OC.dta", clear
rename ES_fecha fecha

merge 1:1 folio fecha using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio)

*Drop outlier
xtile perc=A_5_8, nq(99)
replace A_5_8=. if perc>=98

gen update_tiempo=ES_1_5-A_5_8
gen update_comp=ES_1_4-A_5_5
replace update_comp=update_comp/10000

drop if tratamientoquelestoco==0

qui su update_tiempo if tratamientoquelestoco!=0 & update_tiempo>=-5 & update_tiempo <=5

twoway (hist update_tiempo if tratamientoquelestoco!=0 & update_tiempo>=-5 & update_tiempo <=5 ///
	,  percent w(1) xlabel(-5(1)5) ///
	by(tratamientoquelestoco,  legend(off) row(1) title("") ///
		subtitle("Employee") note("") graphregion(color(none))) ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("") ) ///
	(scatteri 0 `r(mean)' 50 `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(employee_duration, replace)  

qui su update_comp if tratamientoquelestoco!=0 & update_comp>=-5 & update_comp <=5

twoway (hist update_comp if tratamientoquelestoco!=0 & update_comp>=-5 & update_comp <=5, percent w(.5) xlabel(-5(1)5) ///
	by(tratamientoquelestoco, legend(off) row(1) title("") ///
		subtitle("Employee") note("") graphregion(color(none))) ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("") ) ///
	(scatteri 0 `r(mean)' 40 `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(employee_amount, replace) 
	

*Employee's Lawyer
use "$directorio/DB/Merge_Representante_Actor_OC.dta", clear
rename ES_fecha fecha

merge m:1 folio fecha using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio)
duplicates drop folio fecha tratamientoquelestoco, force

gen update_tiempo=ES_1_5-RA_5_8
gen update_comp=ES_1_4-RA_5_5
replace update_comp=update_comp/10000

drop if tratamientoquelestoco==0

qui su update_tiempo if tratamientoquelestoco!=0 & update_tiempo>=-5 & update_tiempo <=5

twoway (hist update_tiempo if tratamientoquelestoco!=0 & update_tiempo>=-5 & update_tiempo <=5 ///
	, percent w(1) xlabel(-5(1)5) ///
	by(tratamientoquelestoco, legend(off) row(1) title("") ///
		subtitle("Employee's Lawyer") note("") graphregion(color(none))) ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("") ) ///
	(scatteri 0 `r(mean)' 30 `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(employeeslawyer_duration, replace) legend( off )

qui su update_comp if update_comp>=-2 & update_comp <=2

twoway (hist update_comp if tratamientoquelestoco!=0 & update_comp>=-5 & update_comp <=5, percent w(.5) xlabel(-5(1)5) ///
	by(tratamientoquelestoco, legend(off) row(1) title("") ///
		subtitle("Employee's Lawyer") note("") graphregion(color(none))) ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("") ) ///
	(scatteri 0 `r(mean)' 40 `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(employeeslawyer_amount, replace) 
	
	
*Firm's Lawyer
use "$directorio/DB/Merge_Representante_Demandado_OC.dta", clear
rename ES_fecha fecha

merge m:1 folio fecha using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio)
duplicates drop folio fecha tratamientoquelestoco, force

gen update_tiempo=ES_1_5-RD5_8
gen update_comp=ES_1_4-RD5_5
replace update_comp=update_comp/10000

drop if tratamientoquelestoco==0

qui su update_tiempo if tratamientoquelestoco!=0 & update_tiempo>=-5 & update_tiempo <=5

twoway (hist update_tiempo if tratamientoquelestoco!=0 & update_tiempo>=-5 & update_tiempo <=5 ///
	, percent w(1) xlabel(-5(1)5) ///
	by(tratamientoquelestoco, legend(off) row(1) title("") ///
		subtitle("Firm's Lawyer") note("") graphregion(color(none))) ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("") ) ///
	(scatteri 0 `r(mean)' 30 `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(firmlawyer_duration, replace) 

qui su update_comp if tratamientoquelestoco!=0 & update_comp>=-2 & update_comp <=2

twoway (hist update_comp if tratamientoquelestoco!=0 & update_comp>=-5 & update_comp <=5, percent w(.5) xlabel(-5(1)5) ///
	by(tratamientoquelestoco, legend(off) row(1) title("") ///
		subtitle("Firm's Lawyer") note("") graphregion(color(none))) ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("") ) ///
	(scatteri 0 `r(mean)' 40 `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(firmlawyer_amount, replace) 
	

	
	
********

graph combine employee_duration employeeslawyer_duration firmlawyer_duration, ///
	xcommon ycommon rows(3)  graphregion(color(none)) note("Graphs by treatment", size(small)) 
graph export "$sharelatex/Figuras/updatebeleif_duration.pdf", replace 
	

graph combine employee_amount employeeslawyer_amount firmlawyer_amount, ///
	xcommon ycommon rows(3)  graphregion(color(none))	note("Graphs by treatment", size(small)) 
graph export "$sharelatex/Figuras/updatebeleif_amount.pdf", replace 
	
