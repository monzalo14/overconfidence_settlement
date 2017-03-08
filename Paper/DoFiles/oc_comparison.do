/*Overconfidence plots*/

************************************Employee************************************
use  "$directorio\DB\Calculadora.dta", clear
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor) nogen
merge m:1 folio using "$directorio/DB/Append Encuesta Inicial Actor.dta", keep(2 3) nogen

replace seconcilio=0 if seconcilio==.
duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=99

*Nos quedamos con los que tuvieron tratamiento de la calculadora
keep if tratamientoquelestoco==2

	*Dinero
replace A_5_3=1 if A_5_3==0
gen  Dinero_min = log(A_5_3)

replace A_5_4=1 if A_5_4==0
gen  Dinero_max = log(A_5_4)

replace A_5_5=1 if A_5_5==0
gen  Dinero_mas_prob = log(A_5_5)

replace exp_comp=1 if exp_comp==0
gen  Dinero_calc = log(exp_comp)

qui su Dinero_mas_prob if Dinero_mas_prob<60
local mns=`r(mean)'
qui su  Dinero_calc if Dinero_calc<60
local mnc=`r(mean)'
		
twoway  (hist Dinero_mas_prob if Dinero_mas_prob<60, percent w(0.5) fcolor(ltbluishgray) ) ///
		(hist Dinero_calc if Dinero_calc<60, percent w(0.5)  fcolor(none) lcolor(black) mlwidth(thick)) ///
		(scatteri 0 `mns' 40 `mns', c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
		(scatteri 0 `mnc' 40 `mnc', c(l) m(i) color(gs2) lwidth(vthick) ) , ///
		legend(order(1 "Most probable" 2 "Calculator" )) ///
		title("Compensation in log pesos")  graphregion(color(white)) scheme(s2mono)
graph export "$sharelatex/Figuras/Compensation_comparison_employee.pdf", replace 

	*Probabilidad
rename A_5_1 Prob_win
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

qui su Prob_win if Dinero_mas_prob<60
local mns=`r(mean)'
qui su  Prob_win_calc if Dinero_calc<60
local mnc=`r(mean)'
		
twoway  (hist Prob_win, w(5) percent fcolor(ltbluishgray) ) ///
		(hist Prob_win_calc, w(5) percent  fcolor(none) lcolor(black) lwidth(thick)) ///
		(scatteri 0 `mns' 40 `mns', c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
		(scatteri 0 `mnc' 40 `mnc', c(l) m(i) color(gs2) lwidth(vthick) ) , ///
		legend(order(1 "Survey" 2 "Calculator" )) ///
		title("Probability of winning")  graphregion(color(white)) scheme(s2mono)
graph export "$sharelatex/Figuras/Probability_comparison_employee.pdf", replace 


************************************Employe's Lawyer****************************
use  "$directorio\DB\Calculadora.dta", clear
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor) nogen
merge m:m folio using "$directorio/DB/Append Encuesta Inicial Representante Actor.dta", keep(2 3) nogen

replace seconcilio=0 if seconcilio==.
duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=99

*Nos quedamos con los que tuvieron tratamiento de la calculadora
keep if tratamientoquelestoco==2

	*Dinero
replace RA_5_3=1 if RA_5_3==0
gen  Dinero_min = log(RA_5_3)

replace RA_5_4=1 if RA_5_4==0
gen  Dinero_max = log(RA_5_4)

replace RA_5_5=1 if RA_5_5==0
gen  Dinero_mas_prob = log(RA_5_5)

replace exp_comp=1 if exp_comp==0
gen  Dinero_calc = log(exp_comp)

		
qui su Dinero_mas_prob if Dinero_mas_prob<60
local mns=`r(mean)'
qui su  Dinero_calc if Dinero_calc<60
local mnc=`r(mean)'
		
twoway  (hist Dinero_mas_prob if Dinero_mas_prob<60, percent w(0.5) fcolor(ltbluishgray) ) ///
		(hist Dinero_calc if Dinero_calc<60, percent w(0.5)  fcolor(none) lcolor(black) mlwidth(thick)) ///
		(scatteri 0 `mns' 40 `mns', c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
		(scatteri 0 `mnc' 40 `mnc', c(l) m(i) color(gs2) lwidth(vthick) ) , ///
		legend(order(1 "Most probable" 2 "Calculator" )) ///
		title("Compensation in log pesos")  graphregion(color(white)) scheme(s2mono)
graph export "$sharelatex/Figuras/Compensation_comparison_EmployeeLawyer.pdf", replace 

	*Probabilidad
rename RA_5_1 Prob_win
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

		
qui su Prob_win if Dinero_mas_prob<60
local mns=`r(mean)'
qui su  Prob_win_calc if Dinero_calc<60
local mnc=`r(mean)'
		
twoway  (hist Prob_win, w(5) percent fcolor(ltbluishgray) ) ///
		(hist Prob_win_calc, w(5) percent  fcolor(none) lcolor(black) lwidth(thick)) ///
		(scatteri 0 `mns' 40 `mns', c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
		(scatteri 0 `mnc' 40 `mnc', c(l) m(i) color(gs2) lwidth(vthick) ) , ///
		legend(order(1 "Survey" 2 "Calculator" )) ///
		title("Probability of winning")  graphregion(color(white)) scheme(s2mono)
graph export "$sharelatex/Figuras/Probability_comparison_EmployeeLawyer.pdf", replace 



************************************Firm's Lawyer*******************************
use  "$directorio\DB\Calculadora.dta", clear
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor) nogen
merge m:m folio using "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta", keep(2 3) nogen

replace seconcilio=0 if seconcilio==.
duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=99

*Nos quedamos con los que tuvieron tratamiento de la calculadora
keep if tratamientoquelestoco==2

	*Dinero
replace RD5_3=1 if RD5_3==0
gen  Dinero_min = log(RD5_3)

replace RD5_4=1 if RD5_4==0
gen  Dinero_max = log(RD5_4)

replace RD5_5=1 if RD5_5==0
gen  Dinero_mas_prob = log(RD5_5)

replace exp_comp=1 if exp_comp==0
gen  Dinero_calc = log(exp_comp)

qui su Dinero_mas_prob if Dinero_mas_prob<60
local mns=`r(mean)'
qui su  Dinero_calc if Dinero_calc<60
local mnc=`r(mean)'
		
twoway  (hist Dinero_mas_prob if Dinero_mas_prob<60, percent w(0.5) fcolor(ltbluishgray) ) ///
		(hist Dinero_calc if Dinero_calc<60, percent w(0.5)  fcolor(none) lcolor(black) mlwidth(thick)) ///
		(scatteri 0 `mns' 40 `mns', c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
		(scatteri 0 `mnc' 40 `mnc', c(l) m(i) color(gs2) lwidth(vthick) ) , ///
		legend(order(1 "Most probable" 2 "Calculator" )) ///
		title("Compensation in log pesos")  graphregion(color(white)) scheme(s2mono)
graph export "$sharelatex/Figuras/Compensation_comparison_FirmLawyer.pdf", replace 

	*Probabilidad
rename RD5_1_1 Prob_win
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

		
qui su Prob_win if Dinero_mas_prob<60
local mns=`r(mean)'
qui su  Prob_win_calc if Dinero_calc<60
local mnc=`r(mean)'
		
twoway  (hist Prob_win, w(5) percent fcolor(ltbluishgray) ) ///
		(hist Prob_win_calc, w(5) percent  fcolor(none) lcolor(black) lwidth(thick)) ///
		(scatteri 0 `mns' 40 `mns', c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
		(scatteri 0 `mnc' 40 `mnc', c(l) m(i) color(gs2) lwidth(vthick) ) , ///
		legend(order(1 "Survey" 2 "Calculator" )) ///
		title("Probability of winning")  graphregion(color(white)) scheme(s2mono)
graph export "$sharelatex/Figuras/Probability_comparison_FirmLawyer.pdf", replace 
	
