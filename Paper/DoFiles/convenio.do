use "$sharelatex\DB\Seguimiento_Juntas.dta", clear

collapse (mean) mean_con=convenio (sd) sd_con=convenio (count) n_con=convenio ///
		, by(junta calcu_p_actora)
	
drop if missing(calcu_p)
	

label define junta 1 "J 2" 2  "J 7" 3 "J 9"  4 "J 11"  5 "J 16"
label values junta junta

replace junta=1 if junta==2
replace junta=2 if junta==7
replace junta=3 if junta==9
replace junta=4 if junta==11
replace junta=5 if junta==16

	
*CI	(truncated)
generate hi_con = max( min (mean_con + invttail(n_con-1,0.05)*(sd_con / sqrt(n_con)),1),0) if n_con!=0
generate low_con = max( min (mean_con - invttail(n_con-1,0.05)*(sd_con / sqrt(n_con)),1),0) if n_con!=0

gen junta_calcu=.
replace  junta_calcu = calcu_p+1    if junta == 1
replace  junta_calcu = calcu_p+4  if junta == 2
replace  junta_calcu = calcu_p+7  if junta == 3
replace  junta_calcu = calcu_p+10  if junta == 4
replace  junta_calcu = calcu_p+13  if junta == 5


*Difference 
bysort junta: egen mean_con_1=mean(mean_con) if calcu==1
bysort junta: egen mean_con_0=mean(mean_con) if calcu==0
bysort junta: egen mean_con_1_=mean(mean_con_1)
bysort junta: egen mean_con_0_=mean(mean_con_0)

gen dif=mean_con_1_-mean_con_0_


*Observations
sort junta calcu

local n1=n_con[1]
local n2=n_con[2]
local n3=n_con[3]
local n4=n_con[4]
local n5=n_con[5]
local n6=n_con[6]
local n7=n_con[7]
local n8=n_con[8]
local n9=n_con[9]
local n10=n_con[10]

*Difference

local m1=round(dif[2],.01)
local m2=round(dif[4],.01)
local m3=round(dif[6],.01)
local m4=round(dif[8],.01)
local m5=round(dif[10],.01)


twoway (bar mean_con junta_calcu if calcu==0, color(dkgreen) lcolor(black) ) ///
       (bar mean_con junta_calcu if calcu==1, color(navy)) ///
	   (rcap hi_con low_con junta_calcu, color(black) lpattern(solid) ///
			text(-0.05 1 "`n1'", place(n)) ///
			text(-0.05 2 "`n2'", place(n)) ///	
			text(-0.05 4 "`n3'", place(n)) ///
			text(-0.05 5 "`n4'", place(n)) ///	
			text(-0.05 7 "`n5'", place(n)) ///
			text(-0.05 8 "`n6'", place(n)) ///
			text(-0.05 10 "`n7'", place(n)) ///
			text(-0.05 11 "`n8'", place(n)) ///
			text(-0.05 13 "`n9'", place(n)) ///
			text(-0.05 14 "`n10'", place(n)) ///
			text(.5 1.5 "`m1'", place(s)) ///
			text(.5 4.5 "`m2'", place(s)) ///	
			text(.5 7.5 "`m3'", place(s)) ///
			text(.5 10.5 "`m4'", place(s)) ///	
			text(.5 13.5 "`m5'", place(s)) ///			
	   ) ///
	   (scatteri -.05 1, color(none) yaxis(2)) ///
	   (scatteri .5 1, color(none) yaxis(2)) ///
	   (scatteri -0.05 .1, color(none) yaxis(1)) ///
		, ///
       legend(row(1) order(1 "Calculadora : No" 2 "Calculadora : Si") ) ///
       xlabel( 1.5 "J 2" 4.5 "J 7" 7.5 "J 9" 10.5 "J 11" 13.5 "J 16" , noticks) ///
	   xtitle("Junta")  ///
	   ytitle("Porcentaje")  ///
	   ytitle(" ", axis(2)) ///
	   ylabel(0(.1).5, axis(1))  ymtick(0(0.1).5, axis(1)) ///
	   ylabel( -.05 "# Obs" .5 "Diferencia", axis(2) angle(0)) ///
	   title("Porcentaje Convenios") ///
	   subtitle("Parte actora") ///
	   scheme(s2mono) graphregion(color(none)) 
graph export "$sharelatex/Figuras/convenio_act.pdf", replace

	   
	   
********************************************************************************


use "$sharelatex\DB\Seguimiento_Juntas.dta", clear

collapse (mean) mean_con=convenio (sd) sd_con=convenio (count) n_con=convenio ///
		, by(junta calcu_p_dem)
	
drop if missing(calcu_p_dem)
	

label define junta 1 "J 2" 2  "J 7" 3 "J 9"  4 "J 11"  5 "J 16"
label values junta junta

replace junta=1 if junta==2
replace junta=2 if junta==7
replace junta=3 if junta==9
replace junta=4 if junta==11
replace junta=5 if junta==16

	
*CI	(truncated)
generate hi_con = max( min (mean_con + invttail(n_con-1,0.05)*(sd_con / sqrt(n_con)),1),0) if n_con!=0
generate low_con = max( min (mean_con - invttail(n_con-1,0.05)*(sd_con / sqrt(n_con)),1),0) if n_con!=0

gen junta_calcu=.
replace  junta_calcu = calcu_p+1    if junta == 1
replace  junta_calcu = calcu_p+4  if junta == 2
replace  junta_calcu = calcu_p+7  if junta == 3
replace  junta_calcu = calcu_p+10  if junta == 4
replace  junta_calcu = calcu_p+13  if junta == 5


*Difference 
bysort junta: egen mean_con_1=mean(mean_con) if calcu==1
bysort junta: egen mean_con_0=mean(mean_con) if calcu==0
bysort junta: egen mean_con_1_=mean(mean_con_1)
bysort junta: egen mean_con_0_=mean(mean_con_0)

gen dif=mean_con_1_-mean_con_0_


*Observations
sort junta calcu

local n1=n_con[1]
local n2=n_con[2]
local n3=n_con[3]
local n4=n_con[4]
local n5=n_con[5]
local n6=n_con[6]
local n7=n_con[7]
local n8=n_con[8]
local n9=n_con[9]
local n10=n_con[10]

*Difference

local m1=round(dif[2],.01)
local m2=round(dif[4],.01)
local m3=round(dif[6],.01)
local m4=round(dif[8],.01)
local m5=round(dif[10],.01)


twoway (bar mean_con junta_calcu if calcu==0, color(dkgreen) lcolor(black) ) ///
       (bar mean_con junta_calcu if calcu==1, color(navy)) ///
	   (rcap hi_con low_con junta_calcu, color(black) lpattern(solid) ///
			text(-0.05 1 "`n1'", place(n)) ///
			text(-0.05 2 "`n2'", place(n)) ///	
			text(-0.05 4 "`n3'", place(n)) ///
			text(-0.05 5 "`n4'", place(n)) ///	
			text(-0.05 7 "`n5'", place(n)) ///
			text(-0.05 8 "`n6'", place(n)) ///
			text(-0.05 10 "`n7'", place(n)) ///
			text(-0.05 11 "`n8'", place(n)) ///
			text(-0.05 13 "`n9'", place(n)) ///
			text(-0.05 14 "`n10'", place(n)) ///
			text(.5 1.5 "`m1'", place(s)) ///
			text(.5 4.5 "`m2'", place(s)) ///	
			text(.5 7.5 "`m3'", place(s)) ///
			text(.5 10.5 "`m4'", place(s)) ///	
			text(.5 13.5 "`m5'", place(s)) ///			
	   ) ///
	   (scatteri -.05 1, color(none) yaxis(2)) ///
	   (scatteri .5 1, color(none) yaxis(2)) ///
	   (scatteri -0.05 .1, color(none) yaxis(1)) ///
		, ///
       legend(row(1) order(1 "Calculadora : No" 2 "Calculadora : Si") ) ///
       xlabel( 1.5 "J 2" 4.5 "J 7" 7.5 "J 9" 10.5 "J 11" 13.5 "J 16" , noticks) ///
	   xtitle("Junta")  ///
	   ytitle("Porcentaje")  ///
	   ytitle(" ", axis(2)) ///
	   ylabel(0(.1).5, axis(1))  ymtick(0(0.1).5, axis(1)) ///
	   ylabel( -.05 "# Obs" .5 "Diferencia", axis(2) angle(0)) ///
	   title("Porcentaje Convenios") ///
	   subtitle("Parte demandada") ///
	   scheme(s2mono) graphregion(color(none)) 
graph export "$sharelatex/Figuras/convenio_dem.pdf", replace



********************************************************************************

   
