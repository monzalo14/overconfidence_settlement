
import delimited "$sharelatex\Raw\observaciones_tope.csv", clear 


for var c_antiguedad c_indem-c_desc_ob c_recsueldo liq_total: ///
	capture replace X=0 if X<0 & X~=.
	
*Wizorise all at 99th percentile
for var c_* liq_total liq_total_tope: capture egen X99 = pctile(X) , p(99)
for var c_* liq_total liq_total_tope: ///
	capture replace X=X99 if X>X99 & X~=.
drop *99


*Quitamos salarios caidos
gen salarios_caidos=sueldo*duracion*365
replace liq_total=liq_total-salarios_caidos

*Cantidades convertidas en log
replace liq_total=1 if liq_total<=0
replace c_total=1 if c_total<=0
replace min_ley=1 if min_ley<=0

replace liq_total=log(liq_total)
replace c_total=log(c_total)
replace min_ley=log(min_ley)



twoway (scatter liq_total min_ley  if modo_termino==1 , msymbol(circle_hollow) mlc(blue) ) ///
	(scatter liq_total min_ley  if modo_termino==2 , msymbol(square_hollow) mlc(red) )  ///
	(function x, range(min_ley) n(2)) , ///
	legend(order (1 "Convenio" 2 "Desistimiento")) name(gr_desist, replace) ///
	   xtitle(" ") ///
	   ytitle("Amount got (log pesos)") ///
	   scheme(s2mono) graphregion(color(none))
twoway (scatter liq_total min_ley  if modo_termino==1 , msymbol(circle_hollow) mlc(blue) ) ///
	(scatter liq_total min_ley  if modo_termino==3 , msymbol(square_hollow) mlc(red) )  ///
	(function x, range(min_ley) n(2)) , ///
	legend(order (1 "Convenio" 2 "Laudo")) name(gr_laudo, replace) ///
	   xtitle(" ") ///
	   ytitle("Amount got (log pesos)") ///
	   scheme(s2mono) graphregion(color(none))
twoway (scatter liq_total min_ley  if modo_termino==1 , msymbol(circle_hollow) mlc(blue) ) ///
	(scatter liq_total min_ley  if modo_termino==4 , msymbol(square_hollow) mlc(red) )  ///
	(function x, range(min_ley) n(2)) , ///
	legend(order (1 "Convenio" 2 "Caducidad")) name(gr_cad, replace) ///
	   xtitle("Entitlement by law (log pesos)") ///
	   ytitle("Amount got (log pesos)") ///
	   scheme(s2mono) graphregion(color(none))	   


twoway (scatter liq_total c_total  if modo_termino==1 , msymbol(circle_hollow) mlc(blue) ) ///
	(scatter liq_total c_total  if modo_termino==2 , msymbol(square_hollow) mlc(red) )  ///
	(function x, range(c_total) n(2)) , ///
	legend(order (1 "Convenio" 2 "Desistimiento")) name(gr_desist2, replace) ///
	   xtitle(" ") ///
	   ytitle(" ") ///
	   scheme(s2mono) graphregion(color(none))
twoway (scatter liq_total c_total  if modo_termino==1 , msymbol(circle_hollow) mlc(blue) ) ///
	(scatter liq_total c_total  if modo_termino==3 , msymbol(square_hollow) mlc(red) )  ///
	(function x, range(c_total) n(2)) , ///
	legend(order (1 "Convenio" 2 "Laudo")) name(gr_laudo2, replace) ///
	   xtitle(" ") ///
	   ytitle(" ") ///
	   scheme(s2mono) graphregion(color(none))
twoway (scatter liq_total c_total  if modo_termino==1 , msymbol(circle_hollow) mlc(blue) ) ///
	(scatter liq_total c_total  if modo_termino==4 , msymbol(square_hollow) mlc(red) )  ///
	(function x, range(c_total) n(2)) , ///
	legend(order (1 "Convenio" 2 "Caducidad")) name(gr_cad2, replace) ///
	   xtitle("What employee asked (log pesos)") ///
	   ytitle(" ") ///
	   scheme(s2mono) graphregion(color(none))	   

graph combine gr_desist gr_laudo gr_cad gr_desist2 gr_laudo2 gr_cad2, ///
	row(3) col(2) colf scheme(s2mono) graphregion(color(none))		   
graph export "$sharelatex/Figuras/Scatter1.pdf", replace
