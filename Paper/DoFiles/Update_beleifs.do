/*Effect/Update on beleifs*/

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
 
qui su update_comp
local tot_obs=`r(N)'
qui su update_comp if  update_comp>=0 & update_comp <=1
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs'

twoway (hist update_comp if  update_comp>=0 & update_comp <=1, percent w(.1) xlabel(0(0.1)1) ///
	by(tratamientoquelestoco, legend(off) row(1) title("") ///
		subtitle("Employee") note("%obs: `perc_obs'", size(small)) graphregion(color(none))) ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("") ) ///
	(scatteri 0 `r(mean)' 30 `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(employee_amount, replace) 
	

*Employee's Lawyer
use "$sharelatex\DB\Calculadora_wod.dta", clear	
merge m:m folio using "$sharelatex/Raw/Merge_Representante_Actor_OC.dta", keep(2 3) nogen
rename ES_fecha fecha

merge m:1 folio fecha using "$sharelatex/DB/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio)
duplicates drop folio fecha tratamientoquelestoco, force

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=abs((ES_1_4-comp_esp)/(RA_5_5-comp_esp))

drop if tratamientoquelestoco==0

qui su update_comp
local tot_obs=`r(N)'
qui su update_comp if  update_comp>=0 & update_comp <=1
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs'

twoway (hist update_comp if  update_comp>=0 & update_comp <=1, percent w(.1) xlabel(0(0.1)1) ///
	by(tratamientoquelestoco, legend(off) row(1) title("") ///
		subtitle("Employee's Lawyer") note("%obs: `perc_obs'", size(small)) graphregion(color(none))) ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("") ) ///
	(scatteri 0 `r(mean)' 30 `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(employeeslawyer_amount, replace) 
	
	
*Firm's Lawyer
use "$sharelatex\DB\Calculadora_wod.dta", clear	
merge m:m folio using "$sharelatex/Raw/Merge_Representante_Demandado_OC.dta", keep(2 3) nogen
rename ES_fecha fecha

merge m:1 folio fecha using "$sharelatex/DB/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio)
duplicates drop folio fecha tratamientoquelestoco, force

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=abs((ES_1_4-comp_esp)/(RD5_5-comp_esp))

drop if tratamientoquelestoco==0

qui su update_comp
local tot_obs=`r(N)'
qui su update_comp if  update_comp>=0 & update_comp <=1
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs'

twoway (hist update_comp if update_comp>=0 & update_comp <=1, percent w(.1) xlabel(0(0.1)1) ///
	by(tratamientoquelestoco, legend(off) row(1) title("") ///
		subtitle("Firm's Lawyer") note("%obs: `perc_obs'", size(small)) graphregion(color(none))) ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("") ) ///
	(scatteri 0 `r(mean)' 40 `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(firmlawyer_amount, replace) 
	

	
	
********



graph combine employee_amount employeeslawyer_amount firmlawyer_amount, ///
	xcommon ycommon rows(3)  graphregion(color(none))	note("Graphs by treatment", size(small)) 
graph export "$sharelatex/Figuras/updatebeleif_amount.pdf", replace 
	
