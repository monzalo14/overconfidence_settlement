clear
set more off

import delimited "$sharelatex\Raw\observaciones_tope.csv", clear 


*Percentage of cases not ended: 29%
gen not_ended=29
gen seis=6

qui su duracion if modo_termino==1
local m1=`r(mean)'
qui su duracion if modo_termino==2
local m2=`r(mean)'

twoway (hist duracion if modo_termino==1, w(.15) percent color(gs10) lcolor(gs2)) ///
	   (hist duracion if modo_termino==2, w(.15) percent color(none) lcolor(black))  ///
	   (scatteri 0 `m1' 30 `m1' , c(l) m(i) color(gs2) lwidth(vthick) )  ///
		(scatteri 0 `m2' 30 `m2' , c(l) m(i) color(white) lwidth(vthick) )  ///
		(bar not_ended seis, color(ltbluishgray) lcolor(black) barwidth(.15) ///
			xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "Not ended")) , ///
		xtitle(" ")  scheme(s2mono) graphregion(color(none)) name(gr1, replace) ///
	   legend(order(1 "Conciliation" 2 "Drop"))

	   
qui su duracion if modo_termino==3
local m3=`r(mean)'
qui su duracion if modo_termino==4
local m4=`r(mean)'	   
	   
twoway (hist duracion if modo_termino==3, w(.15) percent color(gs10) lcolor(gs2)) ///
	   (hist duracion if modo_termino==4, w(.15) percent color(none) lcolor(black))  ///
	   	(scatteri 0 `m3' 30 `m3' , c(l) m(i) color(gs2) lwidth(vthick) )  ///
		(scatteri 0 `m4' 30 `m4' , c(l) m(i) color(white) lwidth(vthick) )  ///
		(bar not_ended seis, color(ltbluishgray) lcolor(black) barwidth(.15) ///
			xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "Not ended")) , ///
		xtitle("Years")  scheme(s2mono) graphregion(color(none)) name(gr2, replace) ///
	   legend(order(1 "Court ruling" 2 "Expiry"))
	   
graph combine gr1 gr2, xcommon rows(2)	 scheme(s2mono) graphregion(color(none)) ///
	title("Length of case")
graph export "$sharelatex\Figuras\Duracion.pdf", replace 
