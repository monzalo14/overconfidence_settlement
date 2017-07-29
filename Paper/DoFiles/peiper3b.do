
import delimited "$sharelatex\Raw\observaciones_tope.csv", clear 


for var c_antiguedad c_indem-c_desc_ob c_recsueldo liq_total: ///
	capture replace X=0 if X<0 & X~=.
	
*Wizorise all at 99th percentile
for var c_* liq_total liq_total_tope: capture egen X99 = pctile(X) , p(99)
for var c_* liq_total liq_total_tope: ///
	capture replace X=X99 if X>X99 & X~=.
drop *99


***


*We define win as liq_total>0
gen win=(liq_total>0)


label define modo_termino 1 "Convenio" 2 "Desistimiento" 3 "Laudo" 4 "Caducidad"
label values modo_termino modo_termino

*Modo término
gen convenio=(modo_termino==1)
gen laudo=(modo_termino==3)

*Convenios y laudos
keep if modo_termino==1 | modo_termino==3

preserve
collapse (mean) mean_1=convenio (sd) sd_1=convenio (count) n_1=convenio ///
		(mean) mean_3=laudo (sd) sd_3=laudo (count) n_3=laudo 

gen id=1

reshape long mean_ sd_ n_, i(id) j(modo_termino)		

rename mean_ mean_num
rename sd_ sd_num
rename n_ n_num

tempfile total
save `total'
restore		

*Cantidades convertidas en miles de pesos
replace liq_total=liq_total/1000
replace c_total=c_total/1000
replace min_ley=min_ley/1000

*Lost wages
gen salarios_caidos=sueldo*duracion*365/1000

*Min compensation+Fallen wages	
gen min_comp_fw=min_ley+salarios_caidos

*Ratios
gen won_asked=liq_total/c_total
gen won_mincomp=liq_total/min_ley
gen won_mincompfw=liq_total/min_comp_fw


collapse (mean) mean_won_asked=won_asked  (sd) sd_won_asked=won_asked (count) n_won_asked=won_asked ///
		(mean) mean_won_mincomp=won_mincomp (sd) sd_won_mincomp=won_mincomp (count) n_won_mincomp=won_mincomp ///
		(mean) mean_won_mincompfw=won_mincompfw (sd) sd_won_mincompfw=won_mincompfw (count) n_won_mincompfw=won_mincompfw ///
		, by(modo_termino)		

merge 1:1 modo_termino using `total', keep(3) nogen


*CI
generate hi_won_asked = max( min (mean_won_asked + invttail(n_won_asked-1,0.05)*(sd_won_asked / sqrt(n_won_asked)),1),0) if n_won_asked!=0
generate low_won_asked = max( min (mean_won_asked - invttail(n_won_asked-1,0.05)*(sd_won_asked / sqrt(n_won_asked)),1),0) if n_won_asked!=0

generate hi_won_mincomp = max( min (mean_won_mincomp + invttail(n_won_mincomp-1,0.05)*(sd_won_mincomp / sqrt(n_won_mincomp)),1),0) if n_won_mincomp!=0
generate low_won_mincomp = max( min (mean_won_mincomp - invttail(n_won_mincomp-1,0.05)*(sd_won_mincomp / sqrt(n_won_mincomp)),1),0) if n_won_mincomp!=0

generate hi_won_mincompfw = max( min (mean_won_mincompfw + invttail(n_won_mincompfw-1,0.05)*(sd_won_mincompfw / sqrt(n_won_mincompfw)),1),0) if n_won_mincompfw!=0
generate low_won_mincompfw = max( min (mean_won_mincompfw - invttail(n_won_mincompfw-1,0.05)*(sd_won_mincompfw / sqrt(n_won_mincompfw)),1),0) if n_won_mincompfw!=0


*Aux variables to graph in x pos
forvalues i=1/27 {
	gen v`i'=`i'
	}


	

twoway (bar mean_won_asked v1 if modo_termino==1, color(blue) ) ///
       (bar mean_won_asked v5 if modo_termino==3, color(blue) ) ///
	   (rcap hi_won_asked low_won_asked v1 if modo_termino==1, color(black) lpattern(solid) ) ///
	   (rcap hi_won_asked low_won_asked v5 if modo_termino==3, color(black) lpattern(solid) ) ///
	   (bar mean_won_mincomp v2 if modo_termino==1, color(dkgreen) ) ///
       (bar mean_won_mincomp v6 if modo_termino==3, color(dkgreen) ) ///
	   (rcap hi_won_mincomp low_won_mincomp v2 if modo_termino==1, color(black) lpattern(solid) ) ///
	   (rcap hi_won_mincomp low_won_mincomp v6 if modo_termino==3, color(black) lpattern(solid) ) ///
	   (bar mean_won_mincompfw v3 if modo_termino==1, color(red) ) ///
       (bar mean_won_mincompfw v7 if modo_termino==3, color(red) ) ///
	   (rcap hi_won_mincompfw low_won_mincompfw v3 if modo_termino==1, color(black) lpattern(solid) ) ///
	   (rcap hi_won_mincompfw low_won_mincompfw v7 if modo_termino==3, color(black) lpattern(solid) ) ///
		, ///
	   legend( order(1 "Win/asked" 5 "Win/min comp" 9 "Win/(min comp + fallen wages)" ) ) ///
       xlabel( 2 "Convenio"  6 "Laudo"  , noticks) ///
	   xtitle(" ") ///
	   ytitle("Ratio")  ///
	   title(" ") ///
	   scheme(s2mono) graphregion(color(none))
	   
graph export "$sharelatex/Figuras/ratio.pdf", replace 
	
