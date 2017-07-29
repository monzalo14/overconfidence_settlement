
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
gen desist=(modo_termino==2)
gen laudo=(modo_termino==3)
gen caduc=(modo_termino==4)

preserve
collapse (mean) mean_1=convenio (sd) sd_1=convenio (count) n_1=convenio ///
		(mean) mean_2=desist (sd) sd_2=desist (count) n_2=desist ///
		(mean) mean_3=laudo (sd) sd_3=laudo (count) n_3=laudo ///
		(mean) mean_4=caduc (sd) sd_4=caduc (count) n_4=caduc 

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

		
collapse (mean) mean_win=win  (sd) sd_win=win (count) n_win=win ///
		(mean) mean_amount=liq_total (sd) sd_amount=liq_total (count) n_amount=liq_total ///
		(mean) mean_asked=c_total (sd) sd_asked=c_total (count) n_asked=c_total ///
		(mean) mean_min=min_ley (sd) sd_min=min_ley (count) n_min=min_ley ///
		(mean) mean_fw=min_comp_fw (sd) sd_fw=min_comp_fw (count) n_fw=min_comp_fw ///
		, by(modo_termino)		

merge 1:1 modo_termino using `total', keep(3) nogen


*CI
generate hi_num = max( min (mean_num + invttail(n_num-1,0.05)*(sd_num / sqrt(n_num)),1),0) if n_num!=0
generate low_num = max( min (mean_num - invttail(n_num-1,0.05)*(sd_num / sqrt(n_num)),1),0) if n_num!=0

generate hi_win = max( min (mean_win + invttail(n_win-1,0.05)*(sd_win / sqrt(n_win)),1),0) if n_win!=0
generate low_win = max( min (mean_win - invttail(n_win-1,0.05)*(sd_win / sqrt(n_win)),1),0) if n_win!=0

generate hi_amount = mean_amount + invttail(n_amount-1,0.05)*(sd_amount / sqrt(n_amount)) if n_amount!=0
generate low_amount =mean_amount - invttail(n_amount-1,0.05)*(sd_amount / sqrt(n_amount)) if n_amount!=0

generate hi_asked = mean_asked + invttail(n_asked-1,0.05)*(sd_asked / sqrt(n_asked)) if n_asked!=0
generate low_asked =mean_asked - invttail(n_asked-1,0.05)*(sd_asked / sqrt(n_asked)) if n_asked!=0

generate hi_min = mean_min + invttail(n_min-1,0.05)*(sd_min / sqrt(n_min)) if n_min!=0
generate low_min = mean_min - invttail(n_min-1,0.05)*(sd_min / sqrt(n_min)) if n_min!=0

generate hi_fw = mean_fw + invttail(n_fw-1,0.05)*(sd_fw / sqrt(n_fw)) if n_fw!=0
generate low_fw = mean_fw - invttail(n_fw-1,0.05)*(sd_fw / sqrt(n_fw)) if n_fw!=0


*Aux variables to graph in x pos
forvalues i=1/27 {
	gen v`i'=`i'
	}

forvalues i=1/4 {
	foreach var in num win  {
		local n_`var'_`i'=n_`var'[`i']
		}
	}
	

twoway (bar mean_num v1 if modo_termino==1, color(gs0) yaxis(1)) ///
       (bar mean_num v8 if modo_termino==2, color(gs0) yaxis(1)) ///
       (bar mean_num v15 if modo_termino==3, color(gs0) yaxis(1)) ///
       (bar mean_num v22 if modo_termino==4, color(gs0) yaxis(1)) ///
	   (rcap hi_num low_num v8 if modo_termino==2, color(black) lpattern(solid) yaxis(1)) ///
	   (rcap hi_num low_num v15 if modo_termino==3, color(black) lpattern(solid) yaxis(1)) ///
	   (rcap hi_num low_num v22 if modo_termino==4, color(black) lpattern(solid) yaxis(1)) ///
	   (bar mean_win v2 if modo_termino==1, color(gs4) yaxis(1)) ///
       (bar mean_win v9 if modo_termino==2, color(gs4) yaxis(1)) ///
       (bar mean_win v16 if modo_termino==3, color(gs4) yaxis(1)) ///
       (bar mean_win v23 if modo_termino==4, color(gs4) yaxis(1)) ///
	   (rcap hi_win low_win v2 if modo_termino==1, color(black) lpattern(solid) yaxis(1)) ///
	   (rcap hi_win low_win v9 if modo_termino==2, color(black) lpattern(solid) yaxis(1)) ///
	   (rcap hi_win low_win v16 if modo_termino==3, color(black) lpattern(solid) yaxis(1)) ///
	   (rcap hi_win low_win v23 if modo_termino==4, color(black) lpattern(solid) yaxis(1)) ///
	   (bar mean_amount v3 if modo_termino==1, color(gs8) yaxis(2)) ///
       (bar mean_amount v10 if modo_termino==2, color(gs8) yaxis(2)) ///
       (bar mean_amount v17 if modo_termino==3, color(gs8) yaxis(2)) ///
       (bar mean_amount v24 if modo_termino==4, color(gs8) yaxis(2)) ///
	   (rcap hi_amount low_amount v3 if modo_termino==1, color(black) lpattern(solid) yaxis(2)) ///
	   (rcap hi_amount low_amount v10 if modo_termino==2, color(black) lpattern(solid) yaxis(2)) ///
	   (rcap hi_amount low_amount v17 if modo_termino==3, color(black) lpattern(solid) yaxis(2)) ///
	   (rcap hi_amount low_amount v24 if modo_termino==4, color(black) lpattern(solid) yaxis(2)) ///
	   (bar mean_asked v4 if modo_termino==1, color(gs12) yaxis(2)) ///
       (bar mean_asked v11 if modo_termino==2, color(gs12) yaxis(2)) ///
       (bar mean_asked v18 if modo_termino==3, color(gs12) yaxis(2)) ///
       (bar mean_asked v25 if modo_termino==4, color(gs12) yaxis(2)) ///
	   (rcap hi_asked low_asked v4 if modo_termino==1, color(black) lpattern(solid) yaxis(2)) ///
	   (rcap hi_asked low_asked v11 if modo_termino==2, color(black) lpattern(solid) yaxis(2)) ///
	   (rcap hi_asked low_asked v18 if modo_termino==3, color(black) lpattern(solid) yaxis(2)) ///
	   (rcap hi_asked low_asked v25 if modo_termino==4, color(black) lpattern(solid) yaxis(2)) ///
	   (bar mean_min v5 if modo_termino==1, color(gs16) lcolor(black) lpattern(dash) yaxis(2)) ///
       (bar mean_min v12 if modo_termino==2, color(gs16) lcolor(black) lpattern(dash) yaxis(2)) ///
       (bar mean_min v19 if modo_termino==3, color(gs16) lcolor(black) lpattern(dash) yaxis(2)) ///
       (bar mean_min v26 if modo_termino==4, color(gs16) lcolor(black) lpattern(dash) yaxis(2)) ///
	   (rcap hi_min low_min v5 if modo_termino==1, color(black) lpattern(solid) yaxis(2)) ///
	   (rcap hi_min low_min v12 if modo_termino==2, color(black) lpattern(solid) yaxis(2)) ///
	   (rcap hi_min low_min v19 if modo_termino==3, color(black) lpattern(solid) yaxis(2)) ///
	   (rcap hi_min low_min v26 if modo_termino==4, color(black) lpattern(solid) yaxis(2)) ///
	   (bar mean_fw v6 if modo_termino==1, color(gs2) lcolor(black) yaxis(2)) ///
       (bar mean_fw v13 if modo_termino==2, color(gs2) lcolor(black) yaxis(2)) ///
       (bar mean_fw v20 if modo_termino==3, color(gs2) lcolor(black) yaxis(2)) ///
       (bar mean_fw v27 if modo_termino==4, color(gs2) lcolor(black) yaxis(2)) ///
	   (rcap hi_fw low_fw v6 if modo_termino==1, color(black) lpattern(solid) yaxis(2)) ///
	   (rcap hi_fw low_fw v13 if modo_termino==2, color(black) lpattern(solid) yaxis(2)) ///
	   (rcap hi_fw low_fw v20 if modo_termino==3, color(black) lpattern(solid) yaxis(2)) ///
	   (rcap hi_fw low_fw v27 if modo_termino==4, color(black) lpattern(solid) yaxis(2)) ///
	   (rcap hi_num low_num v1 if modo_termino==1, color(black) lpattern(solid) yaxis(1) ///
			text(0.4 1 "`n_num_1'", place(n) orient(vertical)) ///
			text(0.4 7 "`n_num_2'", place(n) orient(vertical)) ///	
			text(0.4 13 "`n_num_3'", place(n) orient(vertical)) ///
			text(0.4 19 "`n_num_4'", place(n) orient(vertical)) ///	
			text(0.4 2 "`n_win_1'", place(n) orient(vertical)) ///
			text(0.4 8 "`n_win_2'", place(n) orient(vertical)) ///	
			text(0.4 14 "`n_win_3'", place(n) orient(vertical)) ///
			text(0.4 20 "`n_win_4'", place(n) orient(vertical)) ///	   
	   ), ///
	   legend(row(3) order(1 "% Cases" 8 "% Won" 17 "Amount won " 26 "Amount asked" 33 "Min comp by law" 44 "Min comp + Fallen wages") ) ///
       xlabel( 3 "Convenio" 9 "Desistimiento" 15 "Laudo" 21 "Caducidad" , noticks) ///
	   xtitle(" ") ///
	   ytitle("Percentage", axis(1)) ytitle("Amount in (thousand) pesos", axis(2)) ///
	   ylabel(0(.2)1 , axis(1)) ymtick(0(0.2)1, axis(1)) ///
	   title(" ") ///
	   scheme(s2mono) graphregion(color(none))
	   
graph export "$sharelatex/Figuras/amount.pdf", replace 
	
