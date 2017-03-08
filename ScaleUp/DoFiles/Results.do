/*******************************************************************************
This do file generates all output, such as SS, Two-way tables, Histograms and 
Regressions used as input for the .tex file "Results.tex"
*******************************************************************************/

clear
set more off
global directorio C:\Users\chasi_000\Dropbox\Statistics\P10

********************************************************************************

use "$directorio\DB\DB2\Seguimiento_Juntas.dta", clear

********************************************************************************


/***********************
   SUMMARY STATISTICS
************************/

*Presence of actors
sutex p_*, nobs minmax  ///
	file("$directorio\Results\Results_2\Effect\presence.tex") replace ///
	title("Presence of actors") 
sutex v*, nobs minmax  ///
	file("$directorio\Results\Results_2\Effect\presence_t.tex") replace ///
	title("Presence of actors") 
	
*Update in beleifs
sutex update_*, nobs minmax  ///
	file("$directorio\Results\Results_2\Effect\update_beleif.tex") replace ///
	title("Update in beleifs") 

	
*Test for update

	*PROBABILITY
	
*Employee	
ttest ea1_prob_pago==ea8_prob_pago_s
local mean1=round(`r(mu_1)', 0.001)
local mean2=round(`r(mu_2)', 0.001)
local sd1=round(`r(sd_1)', 0.001)
local sd2=round(`r(sd_2)', 0.001)
local val_p=round(`r(p)', 0.001)

qui putexcel B4=(`mean1') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C4=(`mean2') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel B5=("(`sd1')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C5=("(`sd2')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

qui putexcel D4=(`val_p') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

*Employee's Lawyer	
ttest era1_prob_pago==era4_prob_pago_s
local mean1=round(`r(mu_1)', 0.001)
local mean2=round(`r(mu_2)', 0.001)
local sd1=round(`r(sd_1)', 0.001)
local sd2=round(`r(sd_2)', 0.001)
local val_p=round(`r(p)', 0.001)

qui putexcel B6=(`mean1') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C6=(`mean2') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel B7=("(`sd1')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C7=("(`sd2')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

qui putexcel D6=(`val_p') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

*Firm's Lawyer	
ttest erd1_prob_pago==erd4_prob_pago_s
local mean1=round(`r(mu_1)', 0.001)
local mean2=round(`r(mu_2)', 0.001)
local sd1=round(`r(sd_1)', 0.001)
local sd2=round(`r(sd_2)', 0.001)
local val_p=round(`r(p)', 0.001)

qui putexcel B8=(`mean1') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C8=(`mean2') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel B9=("(`sd1')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C9=("(`sd2')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

qui putexcel D8=(`val_p') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify


	*PAYMENT LEVELS
	
*Employee	
ttest ea2_cantidad_pago==ea9_cantidad_pago_s
local mean1=round(`r(mu_1)', 0.001)
local mean2=round(`r(mu_2)', 0.001)
local sd1=round(`r(sd_1)', 0.001)
local sd2=round(`r(sd_2)', 0.001)
local val_p=round(`r(p)', 0.001)

qui putexcel B11=(`mean1') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C11=(`mean2') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel B12=("(`sd1')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C12=("(`sd2')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

qui putexcel D11=(`val_p') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

*Employee's Lawyer	
ttest era2_cantidad_pago==era5_cantidad_pago_s
local mean1=round(`r(mu_1)', 0.001)
local mean2=round(`r(mu_2)', 0.001)
local sd1=round(`r(sd_1)', 0.001)
local sd2=round(`r(sd_2)', 0.001)
local val_p=round(`r(p)', 0.001)

qui putexcel B13=(`mean1') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C13=(`mean2') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel B14=("(`sd1')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C14=("(`sd2')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

qui putexcel D13=(`val_p') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

*Firm's Lawyer	
ttest erd2_cantidad_pago==erd5_cantidad_pago_s	
local mean1=round(`r(mu_1)', 0.001)
local mean2=round(`r(mu_2)', 0.001)
local sd1=round(`r(sd_1)', 0.001)
local sd2=round(`r(sd_2)', 0.001)
local val_p=round(`r(p)', 0.001)

qui putexcel B15=(`mean1') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C15=(`mean2') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel B16=("(`sd1')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C16=("(`sd2')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

qui putexcel D15=(`val_p') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify


	*PAYMENT LOGS
	
*Employee	
ttest log_ea2_cantidad_pago==log_ea9_cantidad_pago_s
local mean1=round(`r(mu_1)', 0.001)
local mean2=round(`r(mu_2)', 0.001)
local sd1=round(`r(sd_1)', 0.001)
local sd2=round(`r(sd_2)', 0.001)
local val_p=round(`r(p)', 0.001)

qui putexcel B18=(`mean1') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C18=(`mean2') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel B19=("(`sd1')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C19=("(`sd2')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

qui putexcel D18=(`val_p') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

*Employee's Lawyer	
ttest log_era2_cantidad_pago==log_era5_cantidad_pago_s
local mean1=round(`r(mu_1)', 0.001)
local mean2=round(`r(mu_2)', 0.001)
local sd1=round(`r(sd_1)', 0.001)
local sd2=round(`r(sd_2)', 0.001)
local val_p=round(`r(p)', 0.001)

qui putexcel B20=(`mean1') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C20=(`mean2') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel B21=("(`sd1')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C21=("(`sd2')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

qui putexcel D20=(`val_p') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

*Firm's Lawyer	
ttest log_erd2_cantidad_pago==log_erd5_cantidad_pago_s	
local mean1=round(`r(mu_1)', 0.001)
local mean2=round(`r(mu_2)', 0.001)
local sd1=round(`r(sd_1)', 0.001)
local sd2=round(`r(sd_2)', 0.001)
local val_p=round(`r(p)', 0.001)

qui putexcel B22=(`mean1') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C22=(`mean2') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel B23=("(`sd1')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify
qui putexcel C23=("(`sd2')") using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify

qui putexcel D22=(`val_p') using "$directorio\Results\Results_2\Effect\ttest.xlsx", sheet("ttest") modify





*Treatments
latab calcu_p_actora	calcu_p_dem,  replace ///
	tf("$directorio\Results\Results_2\Effect\tab_calc")


************************************

*Conciliation in the day of treatment with "calculadora"
latab convenio calcu_p_actora,  replace ///
	tf("$directorio\Results\Results_2\Effect\con_calc_actor")
ttesttable convenio calcu_p_actora , tex("$directorio\Results\Results_2\Effect\test_con_calc_actor") ///
	pre("\begin{table}[H]\centering \caption{\textbf{T-Test: Convenio by Calculadora Actora}}") ///
    post("\end{table}")
	

latab convenio calcu_p_dem,  replace ///
	tf("$directorio\Results\Results_2\Effect\con_calc_dem")
ttesttable convenio calcu_p_dem , tex("$directorio\Results\Results_2\Effect\test_con_calc_dem") ///
	pre("\begin{table}[H]\centering \caption{\textbf{T-Test: Convenio by Calculadora Demandada}}") ///
    post("\end{table}")
	
	
	
*Conciliation in the day of treatment CONDITIONING ON: "TOOK PART OF SURVEY"
latab convenio calcu_p_actora if registro_p_actora==1,  replace ///
	tf("$directorio\Results\Results_2\Effect\con_calc_actor_registro1")
ttesttable convenio calcu_p_actora if registro_p_actora==1, ///
	tex("$directorio\Results\Results_2\Effect\test_con_calc_actor_registro1") ///
	pre("\begin{table}[H]\centering \caption{\textbf{T-Test: Convenio by Calculadora Actora}}") ///
    post("\end{table}")
	
latab convenio calcu_p_actora if registro_p_actora==0,  replace ///
	tf("$directorio\Results\Results_2\Effect\con_calc_actor_registro0")
ttesttable convenio calcu_p_actora if registro_p_actora==0, ///
	tex("$directorio\Results\Results_2\Effect\test_con_calc_actor_registro0") ///
	pre("\begin{table}[H]\centering \caption{\textbf{T-Test: Convenio by Calculadora Actora}}") ///
    post("\end{table}")
	
latab convenio calcu_p_dem if registro_p_dem==1,  replace ///
	tf("$directorio\Results\Results_2\Effect\con_calc_dem_registro1")
ttesttable convenio calcu_p_dem if registro_p_dem==1, ///
	tex("$directorio\Results\Results_2\Effect\test_con_calc_dem_registro1") ///
	pre("\begin{table}[H]\centering \caption{\textbf{T-Test: Convenio by Calculadora Demandada}}") ///
    post("\end{table}")
	
latab convenio calcu_p_dem if registro_p_dem==0,  replace ///
	tf("$directorio\Results\Results_2\Effect\con_calc_dem_registro0")	
ttesttable convenio calcu_p_dem if registro_p_dem==0, ///
	tex("$directorio\Results\Results_2\Effect\test_con_calc_dem_registro0") ///
	pre("\begin{table}[H]\centering \caption{\textbf{T-Test: Convenio by Calculadora Demandada}}") ///
    post("\end{table}")


*Conciliation in the day of treatment with "registro"
latab convenio registro_p_actora,  replace ///
	tf("$directorio\Results\Results_2\Effect\con_reg_actor")
ttesttable convenio registro_p_actora , tex("$directorio\Results\Results_2\Effect\test_con_reg_actor") ///
	pre("\begin{table}[H]\centering \caption{\textbf{T-Test: Convenio by Calculadora Actora}}") ///
    post("\end{table}")
	

latab convenio registro_p_dem,  replace ///
	tf("$directorio\Results\Results_2\Effect\con_reg_dem")
ttesttable convenio registro_p_dem , tex("$directorio\Results\Results_2\Effect\test_con_reg_dem") ///
	pre("\begin{table}[H]\centering \caption{\textbf{T-Test: Convenio by Calculadora Demandada}}") ///
    post("\end{table}")	

************************************	

*Summary statistics surveys
sutex ea1_prob_pago	ea2_cantidad_pago	///
		ea8_prob_pago_s	ea9_cantidad_pago_s ///
era1_prob_pago	era2_cantidad_pago	///
		era4_prob_pago_s era5_cantidad_pago_s ///
erd1_prob_pago	erd2_cantidad_pago ///
		erd4_prob_pago_s erd5_cantidad_pago_s ///
ea4_compra	ea6_trabaja	ea7_busca_trabajo,  nobs minmax labels	 ///
	file("$directorio\Results\Results_2\Effect\SS_survey.tex") replace ///
	title("SS survey variables") 


local j=2
foreach var of varlist ea3_enojo ea5_estudios era3_litigios  erd3_litigios {
	forvalues i=1/4 {
		qui su `var' if `var'==`i'
		qui putexcel C`j'=(r(N)) using "$directorio\Results\Results_2\Effect\TAB_survey.xlsx", sheet("TAB_survey") modify
		local j=`j'+1
		}
	local j=`j'+1	
	}	
	
*Missing values
 
*Employee
local max_obs=0
foreach var of varlist ea1_prob_pago	ea2_cantidad_pago	////
		ea8_prob_pago_s	ea9_cantidad_pago_s ea4_compra	ea6_trabaja	ea7_busca_trabajo ///
		ea3_enojo ea5_estudios {
			
	qui su `var'
	local max_obs=max(`max_obs',`r(N)')
	}

local j=6
foreach var of varlist ea1_prob_pago	ea2_cantidad_pago	////
		ea8_prob_pago_s	ea9_cantidad_pago_s ea4_compra	ea6_trabaja	ea7_busca_trabajo ///
		ea3_enojo ea5_estudios {
			
	qui su `var'
	local NA=`max_obs'-`r(N)'
	qui putexcel C`j'=(`NA') using "$directorio\Results\Results_2\Effect\NA.xlsx", sheet("NA") modify
	local j=`j'+1	
	}
	
*Employee's Lawyer
local max_obs=0
foreach var of varlist era1_prob_pago	era2_cantidad_pago	///
		era4_prob_pago_s era5_cantidad_pago_s ///
		era3_litigios {
			
	qui su `var'
	local max_obs=max(`max_obs',`r(N)')
	}

local j=16
foreach var of varlist  era1_prob_pago	era2_cantidad_pago	///
		era4_prob_pago_s era5_cantidad_pago_s ///
		era3_litigios {
			
	qui su `var'
	local NA=`max_obs'-`r(N)'
	qui putexcel C`j'=(`NA') using "$directorio\Results\Results_2\Effect\NA.xlsx", sheet("NA") modify
	local j=`j'+1	
	}	
	
*Firm's Lawyer
local max_obs=0
foreach var of varlist erd1_prob_pago	erd2_cantidad_pago ///
		erd4_prob_pago_s erd5_cantidad_pago_s ///
		erd3_litigios {
			
	qui su `var'
	local max_obs=max(`max_obs',`r(N)')
	}

local j=22
foreach var of varlist erd1_prob_pago	erd2_cantidad_pago ///
		erd4_prob_pago_s erd5_cantidad_pago_s ///
		erd3_litigios {
			
	qui su `var'
	local NA=`max_obs'-`r(N)'
	qui putexcel C`j'=(`NA') using "$directorio\Results\Results_2\Effect\NA.xlsx", sheet("NA") modify
	local j=`j'+1	
	}		
*************************************


*HISTOGRAMS EXPECTATIONS 

qui su update_pago_a if  update_pago_a>=-1.5 & update_pago_a <=2

twoway (hist update_pago_a if update_pago_a>=-1.5 & update_pago_a <=2 ///
	, percent w(.25) xlabel(-1.5(1)2)  ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("")  subtitle("Payment") legend(off)  ) ///
	(scatteri 0 `r(mean)' 80 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(pago_a, replace) note("Number of observations: `r(N)'", size(small))
	
qui su update_pago_ra if  update_pago_ra>=-1.5 & update_pago_ra <=2

twoway (hist update_pago_ra if update_pago_ra>=-1.5 & update_pago_ra <=2 ///
	, percent w(.25) xlabel(-1.5(1)2)  ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("")   legend(off)  ) ///
	(scatteri 0 `r(mean)' 80 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(pago_ra, replace) note("Number of observations: `r(N)'", size(small))
	
qui su update_pago_rd if  update_pago_rd>=-1.5 & update_pago_rd <=2

twoway (hist update_pago_rd if update_pago_rd>=-1.5 & update_pago_rd <=2 ///
	, percent w(.25) xlabel(-1.5(1)2)  ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("")  legend(off)  ) ///
	(scatteri 0 `r(mean)' 80 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(pago_rd, replace) note("Number of observations: `r(N)'", size(small))
	
qui su update_prob_a if  update_prob_a>=-1 & update_prob_a <=4

twoway (hist update_prob_a if update_prob_a>=-1 & update_prob_a <=4 ///
	, percent w(.25) xlabel(-1(1)4)  ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("")  subtitle("Probability") legend(off)  ) ///
	(scatteri 0 `r(mean)' 70 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(prob_a, replace) note("Number of observations: `r(N)'", size(small))

qui su update_prob_ra if  update_prob_ra>=-1 & update_prob_ra <=4

twoway (hist update_prob_ra if update_prob_ra>=-1 & update_prob_ra <=4 ///
	, percent w(.25) xlabel(-1(1)4) ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("")  legend(off)  ) ///
	(scatteri 0 `r(mean)' 70 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(prob_ra, replace) note("Number of observations: `r(N)'", size(small))
		
qui su update_prob_rd if  update_prob_rd>=-1 & update_prob_rd <=4

twoway (hist update_prob_rd if update_prob_rd>=-1 & update_prob_rd <=4 ///
	, percent w(.25) xlabel(-1(1)4)  ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("")  legend(off)  ) ///
	(scatteri 0 `r(mean)' 80 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(prob_rd, replace) note("Number of observations: `r(N)'", size(small))


graph combine prob_a pago_a, colf ycommon scheme(s2mono) graphregion(color(none)) ///
	title("Employee") name(emp, replace)

graph combine prob_ra pago_ra, colf ycommon scheme(s2mono) graphregion(color(none)) ///
	title("Employee's Lawyer") name(emp_law, replace)
	
graph combine prob_rd pago_rd, colf ycommon scheme(s2mono) graphregion(color(none)) ///
	title("Firm's Lawyer") name(fir_law, replace)
	
graph combine emp emp_law fir_law, xcommon rows(3) scheme(s2mono) graphregion(color(none)) ///
	title("Update in beliefs")

graph export "$directorio\Results\Results_2\Figures\update_belief.pdf", replace 
 

 

local cutoff=0	
qui su ea2_cantidad_pago, d	
local cutoff=max(`cutoff', `r(p75)')
qui su era2_cantidad_pago, d	
local cutoff=max(`cutoff', `r(p75)')
qui su erd2_cantidad_pago, d	
local cutoff=max(`cutoff', `r(p75)')

local width=round(`cutoff'/10,1000)
local jump=round(`width'*3,100)

qui su ea2_cantidad_pago if   ea2_cantidad_pago <=`cutoff'

twoway (hist ea2_cantidad_pago if   ea2_cantidad_pago <=`cutoff' ///
	, percent w(`width') xlabel(0(`jump')`cutoff')  ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("")  subtitle("Payment")  legend(off)  ) ///
	(scatteri 0 `r(mean)' 80 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(pago_a, replace) note("Number of observations: `r(N)'", size(small))
		
qui su era2_cantidad_pago if   era2_cantidad_pago <=`cutoff'

twoway (hist era2_cantidad_pago if   era2_cantidad_pago <=`cutoff' ///
	, percent w(`width') xlabel(0(`jump')`cutoff')  ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("")   legend(off)  ) ///
	(scatteri 0 `r(mean)' 80 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(pago_ra, replace) note("Number of observations: `r(N)'", size(small))
		
qui su ea2_cantidad_pago if   ea2_cantidad_pago <=`cutoff'

twoway (hist ea2_cantidad_pago if   ea2_cantidad_pago <=`cutoff' ///
	, percent w(`width') xlabel(0(`jump')`cutoff')  ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("")   legend(off)  ) ///
	(scatteri 0 `r(mean)' 80 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(pago_rd, replace) note("Number of observations: `r(N)'", size(small))
	
	
	
qui su ea1_prob_pago

twoway (hist ea1_prob_pago ///
	, percent w(10) xlabel(0(10)100)  ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("")  subtitle("Probability") legend(off)  ) ///
	(scatteri 0 `r(mean)' 40 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(prob_a, replace) note("Number of observations: `r(N)'", size(small))

qui su era1_prob_pago 

twoway (hist era1_prob_pago  ///
	, percent w(10) xlabel(0(10)100) ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("")  legend(off)  ) ///
	(scatteri 0 `r(mean)' 25 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(prob_ra, replace) note("Number of observations: `r(N)'", size(small))
		
qui su erd1_prob_pago

twoway (hist erd1_prob_pago ///
	, percent w(10) xlabel(0(10)100) ///
	scheme(s2mono) graphregion(color(none)) ///
	xtitle("")  legend(off)  ) ///
	(scatteri 0 `r(mean)' 40 `r(mean)' , c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(prob_rd, replace) note("Number of observations: `r(N)'", size(small))


graph combine prob_a pago_a, colf ycommon scheme(s2mono) graphregion(color(none)) ///
	title("Employee") name(emp, replace)

graph combine prob_ra pago_ra, colf ycommon scheme(s2mono) graphregion(color(none)) ///
	title("Employee's Lawyer") name(emp_law, replace)
	
graph combine prob_rd pago_rd, colf ycommon scheme(s2mono) graphregion(color(none)) ///
	title("Firm's Lawyer") name(fir_law, replace)
	
graph combine emp emp_law fir_law, xcommon rows(3) scheme(s2mono) graphregion(color(none)) ///
	title("Initial beliefs")

graph export "$directorio\Results\Results_2\Figures\belief.pdf", replace 
 
 
 	

********************************************************************************


/***********************
       REGRESSIONS
************************/


*Simple regression (Correlation)

eststo clear
		
eststo: reg convenio i.calcu_p_actora, robust
estadd scalar Erre=e(r2)
eststo: reg convenio i.calcu_p_actora junta_*, robust
estadd scalar Erre=e(r2)
eststo: reg convenio i.calcu_p_dem, robust
estadd scalar Erre=e(r2)
eststo: reg convenio i.calcu_p_dem junta_*, robust
estadd scalar Erre=e(r2)
eststo: reg convenio i.calcu_p_actora i.calcu_p_dem, robust
estadd scalar Erre=e(r2)
eststo: reg convenio i.calcu_p_actora i.calcu_p_dem junta_*, robust
estadd scalar Erre=e(r2)


esttab using "$directorio\Results\Results_2\Effect\Simple_regression.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" ) replace 

	
***************************************


*Correlation with presence of employee

eststo clear
		
eststo: reg convenio i.calcu_p_actora##1.p_actor, robust
estadd scalar Erre=e(r2)
eststo: reg convenio i.calcu_p_dem##1.p_actor, robust
estadd scalar Erre=e(r2)
eststo: reg convenio i.calcu_p_actora##1.p_actor i.calcu_p_dem##1.p_actor, robust
estadd scalar Erre=e(r2)

esttab using "$directorio\Results\Results_2\Effect\Presence_employee.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" ) replace 
	

***************************************


*Conditioning of notification

eststo clear

eststo: reg convenio i.calcu_p_dem junta_* if emplazamiento==1, robust
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion"
eststo: reg convenio i.calcu_p_dem junta_* if (emplazamiento==1 | emplazamiento==2), robust
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion Parcial"
eststo: reg convenio i.calcu_p_dem junta_* if emplazamiento==3, robust
estadd scalar Erre=e(r2)
estadd local conditioning="No Notificacion"

eststo: reg convenio i.calcu_p_dem junta_* if emplazamiento==1 & dia_tratamiento==1 , robust
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion y Dia Tratamiento"
eststo: reg convenio i.calcu_p_dem junta_* if (emplazamiento==1 | emplazamiento==2) & dia_tratamiento==1, robust
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion Parcial y Dia Tratamiento"
eststo: reg convenio i.calcu_p_dem junta_* if emplazamiento==3 & dia_tratamiento==1, robust
estadd scalar Erre=e(r2)
estadd local conditioning="No Notificacion y Dia Tratamiento"


esttab using "$directorio\Results\Results_2\Effect\Notification_dem.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "conditioning Conditioning" ) replace 
	
	
*****	
	
eststo clear

eststo: reg convenio i.calcu_p_actora junta_* if emplazamiento==1, robust
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion"
eststo: reg convenio i.calcu_p_actora junta_* if (emplazamiento==1 | emplazamiento==2), robust
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion Parcial"
eststo: reg convenio i.calcu_p_actora junta_* if emplazamiento==3, robust
estadd scalar Erre=e(r2)
estadd local conditioning="No Notificacion"

eststo: reg convenio i.calcu_p_actora junta_* if emplazamiento==1 & dia_tratamiento==1 , robust
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion y Dia Tratamiento"
eststo: reg convenio i.calcu_p_actora junta_* if (emplazamiento==1 | emplazamiento==2) & dia_tratamiento==1, robust
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion Parcial y Dia Tratamiento"
eststo: reg convenio i.calcu_p_actora junta_* if emplazamiento==3 & dia_tratamiento==1, robust
estadd scalar Erre=e(r2)
estadd local conditioning="No Notificacion y Dia Tratamiento"


esttab using "$directorio\Results\Results_2\Effect\Notification_actor.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "conditioning Conditioning" ) replace 	
	
********************************************************************************
	
*Instrumental Variable

eststo clear

eststo: reg convenio dia_tratamiento, robust
estadd scalar Erre=e(r2)

eststo: reg convenio dia_tratamiento junta_*, robust
estadd scalar Erre=e(r2)

eststo: ivreg convenio  (calcu_p_actora = dia_tratamiento ), robust first
estadd scalar Erre=e(r2)

eststo: ivreg convenio  junta_*  notificado (calcu_p_actora = dia_tratamiento ), robust first
estadd scalar Erre=e(r2)
eststo: ivreg convenio  junta_*  notificado (calcu_p_actora = dia_tratamiento ) ///
	if emplazamiento==1, robust first
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion"
eststo: ivreg convenio  junta_*  notificado (calcu_p_actora = dia_tratamiento ) ///
	if (emplazamiento==1 | emplazamiento==2), robust first
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion Parcial"
eststo: ivreg convenio  junta_*  notificado (calcu_p_actora = dia_tratamiento ) ///
	if emplazamiento==3, robust first
estadd scalar Erre=e(r2)
estadd local conditioning="No Notificacion"


eststo: ivreg convenio  (calcu_p_dem = dia_tratamiento ), robust first
estadd scalar Erre=e(r2)
eststo: ivreg convenio  junta_*  notificado (calcu_p_dem = dia_tratamiento ), robust first
estadd scalar Erre=e(r2)
eststo: ivreg convenio  junta_*  notificado (calcu_p_dem = dia_tratamiento ) ///
	if emplazamiento==1, robust first
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion"
eststo: ivreg convenio  junta_*  notificado (calcu_p_dem = dia_tratamiento ) ///
	if (emplazamiento==1 | emplazamiento==2), robust first
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion Parcial"
eststo: ivreg convenio  junta_*  notificado (calcu_p_dem = dia_tratamiento ) ///
	if emplazamiento==3, robust first
estadd scalar Erre=e(r2)
estadd local conditioning="No Notificacion"
	

esttab using "$directorio\Results\Results_2\Effect\IV.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "conditioning Conditioning") replace 
	

***************************************

*First stage

eststo clear


eststo: reg  calcu_p_actora  dia_tratamiento  if convenio!=. , robust first
estadd scalar Erre=e(r2)
eststo: reg  calcu_p_actora junta_*  notificado  dia_tratamiento  if convenio!=. , robust first
estadd scalar Erre=e(r2)
eststo: reg  calcu_p_actora junta_*  notificado  dia_tratamiento  if convenio!=. & ///
	 emplazamiento==1, robust first
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion"
eststo: reg  calcu_p_actora junta_*  notificado  dia_tratamiento  if convenio!=. & ///
	 (emplazamiento==1 | emplazamiento==2), robust first
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion Parcial"
eststo: reg  calcu_p_actora junta_*  notificado  dia_tratamiento  if convenio!=. & ///
	 emplazamiento==3, robust first
estadd scalar Erre=e(r2)
estadd local conditioning="No Notificacion"


eststo: reg  calcu_p_dem  dia_tratamiento  if convenio!=. , robust first
estadd scalar Erre=e(r2)
eststo: reg  calcu_p_dem junta_*  notificado  dia_tratamiento  if convenio!=. , robust first
estadd scalar Erre=e(r2)
eststo: reg  calcu_p_dem junta_*  notificado  dia_tratamiento  if convenio!=. & ///
	 emplazamiento==1, robust first
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion"
eststo: reg  calcu_p_dem junta_*  notificado  dia_tratamiento  if convenio!=. & ///
	 (emplazamiento==1 | emplazamiento==2), robust first
estadd scalar Erre=e(r2)
estadd local conditioning="Notificacion Parcial"
eststo: reg  calcu_p_dem junta_*  notificado  dia_tratamiento  if convenio!=. & ///
	 emplazamiento==3, robust first
estadd scalar Erre=e(r2)
estadd local conditioning="No Notificacion"
	

esttab using "$directorio\Results\Results_2\Effect\Firststage.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "conditioning Conditioning") replace 
***************************************


*Does calculator works even without survey?

gen treatnosurv_act=dia_tratamiento*(1-registro_p_actora)
gen treatnosurv_dem=dia_tratamiento*(1-registro_p_dem)


eststo clear

	*ACTOR
*Reduced form
eststo: reg convenio i.dia_tratamiento##0.registro_p_actora, robust
estadd scalar Erre=e(r2)
*IV
eststo: ivreg convenio  ///
	(calcu_p_actora = dia_tratamiento  treatnosurv_act), robust first
estadd scalar Erre=e(r2)

	*DEMANDADO
*Reduced form
eststo: reg convenio i.dia_tratamiento##0.registro_p_dem, robust
estadd scalar Erre=e(r2)
*IV
eststo: ivreg convenio  ///
	(calcu_p_dem = dia_tratamiento treatnosurv_dem), robust first
estadd scalar Erre=e(r2)

esttab using "$directorio\Results\Results_2\Effect\treat_withoutsurvey.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" ) replace 
***************************************


*IV 2 instruments

eststo clear

*PLAINTIFF
eststo: ivreg convenio  (calcu_p_actora registro_p_actor= dia_tratamiento no_encuestado ) ///
	, robust first
estadd scalar Erre=e(r2)

eststo: ivreg convenio junta_*  notificado ///
	(calcu_p_actora registro_p_actor= dia_tratamiento no_encuestado ) ///
	, robust first
estadd scalar Erre=e(r2)

*DEFENDANT
eststo: ivreg convenio  (calcu_p_dem registro_p_dem = dia_tratamiento no_encuestado ) ///
	, robust first
estadd scalar Erre=e(r2)

eststo: ivreg convenio junta_*  notificado ///
	(calcu_p_dem registro_p_dem = dia_tratamiento no_encuestado ) ///
	, robust first
estadd scalar Erre=e(r2)


esttab using "$directorio\Results\Results_2\Effect\IV_2instruments.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" ) replace 

******************************************	
	
*First Stage

eststo clear

*PLAINTIFF
eststo: reg calcu_p_actora dia_tratamiento no_encuestado if convenio!=. , robust
estadd scalar Erre=e(r2)
eststo: reg registro_p_actor dia_tratamiento no_encuestado if convenio!=. , robust
estadd scalar Erre=e(r2)

eststo: reg calcu_p_actora junta_*  notificado ///
	dia_tratamiento no_encuestado if convenio!=. , robust
estadd scalar Erre=e(r2)
eststo: reg registro_p_actor junta_*  notificado ///
	dia_tratamiento no_encuestado if convenio!=. , robust
estadd scalar Erre=e(r2)


*DEFENDANT
eststo: reg calcu_p_dem dia_tratamiento no_encuestado if convenio!=. , robust
estadd scalar Erre=e(r2)
eststo: reg registro_p_dem dia_tratamiento no_encuestado if convenio!=. , robust
estadd scalar Erre=e(r2)

eststo: reg calcu_p_dem junta_*  notificado ///
	dia_tratamiento no_encuestado if convenio!=. , robust
estadd scalar Erre=e(r2)
eststo: reg registro_p_dem junta_*  notificado ///
	dia_tratamiento no_encuestado if convenio!=. , robust
estadd scalar Erre=e(r2)


esttab using "$directorio\Results\Results_2\Effect\FirstStage_2instruments.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" ) replace 
	
********************************************************************************	


*Controlling for number of litigios

eststo clear

eststo: reg convenio i.calcu_p_dem  i.erd3_litigios, robust
estadd scalar Erre=e(r2)
eststo: reg convenio i.calcu_p_actor i.era3_litigios, robust
estadd scalar Erre=e(r2)
eststo: reg convenio i.calcu_p_dem i.era3_litigios i.erd3_litigios, robust
estadd scalar Erre=e(r2)
eststo: reg convenio i.calcu_p_actor i.era3_litigios i.erd3_litigios, robust
estadd scalar Erre=e(r2)
eststo: reg convenio i.calcu_p_actor i.calcu_p_dem i.era3_litigios i.erd3_litigios, robust
estadd scalar Erre=e(r2)


esttab using "$directorio\Results\Results_2\Effect\Num_litigios.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared") replace 
	

***************************************


*Controlling with update in beleifs

eststo clear

eststo: reg convenio update_prob_a, r
estadd scalar Erre=e(r2)
qui su update_prob_a
estadd scalar IndVarMean=r(mean)

eststo: reg convenio update_prob_ra, r
estadd scalar Erre=e(r2)
qui su update_prob_ra
estadd scalar IndVarMean=r(mean)

eststo: reg convenio update_prob_rd, r
estadd scalar Erre=e(r2)
qui su update_prob_rd
estadd scalar IndVarMean=r(mean)

esttab using "$directorio\Results\Results_2\Effect\Update_beleifs_prob.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "IndVarMean IndVarMean") replace 
	
**********

eststo clear

eststo: reg convenio update_pago_a, r
estadd scalar Erre=e(r2)
qui su update_pago_a
estadd scalar IndVarMean=r(mean)

eststo: reg convenio update_pago_ra, r
estadd scalar Erre=e(r2)
qui su update_pago_ra
estadd scalar IndVarMean=r(mean)

eststo: reg convenio update_pago_rd, r
estadd scalar Erre=e(r2)
qui su update_pago_rd
estadd scalar IndVarMean=r(mean)

esttab using "$directorio\Results\Results_2\Effect\Update_beleifs_pago.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "IndVarMean IndVarMean") replace 
	
	

***************************************

*Controlling by conciliator

eststo clear

eststo: reg convenio i.calcu_p_dem ///
	ANA ///
	LUCIA  ///
	JACQUIE   ///
	MARINA  ///
	KARINA  ///
	MARIBEL  ///
	DEYANIRA  ///
	GUSTAVO  ///
	CORRAL  ///
	AGUSTIN  ///
	MARGARITA  ///
	LUPITA  ///
	ISAAC  ///
	HIGUERA  ///
	DOCTOR  ///
	CESAR if dia_tratamiento==1, robust 
estadd scalar Erre=e(r2)	
	
eststo: reg convenio ///
	calcu_p_dem##ANA ///
	calcu_p_dem##LUCIA  ///
	calcu_p_dem##JACQUIE   ///
	calcu_p_dem##MARINA  ///
	calcu_p_dem##KARINA  ///
	calcu_p_dem##MARIBEL  ///
	calcu_p_dem##DEYANIRA  ///
	calcu_p_dem##GUSTAVO  ///
	calcu_p_dem##CORRAL  ///
	calcu_p_dem##AGUSTIN  ///
	calcu_p_dem##MARGARITA  ///
	calcu_p_dem##LUPITA  ///
	calcu_p_dem##ISAAC  ///
	calcu_p_dem##HIGUERA  ///
	calcu_p_dem##DOCTOR  ///
	calcu_p_dem##CESAR if dia_tratamiento==1, robust 	
estadd scalar Erre=e(r2)


eststo: reg convenio i.calcu_p_actor ///
	ANA ///
	LUCIA  ///
	JACQUIE   ///
	MARINA  ///
	KARINA  ///
	MARIBEL  ///
	DEYANIRA  ///
	GUSTAVO  ///
	CORRAL  ///
	AGUSTIN  ///
	MARGARITA  ///
	LUPITA  ///
	ISAAC  ///
	HIGUERA  ///
	DOCTOR  ///
	CESAR if dia_tratamiento==1, robust 
estadd scalar Erre=e(r2)

eststo: reg convenio ///
	calcu_p_actor##ANA ///
	calcu_p_actor##LUCIA  ///
	calcu_p_actor##JACQUIE   ///
	calcu_p_actor##MARINA  ///
	calcu_p_actor##KARINA  ///
	calcu_p_actor##MARIBEL  ///
	calcu_p_actor##DEYANIRA  ///
	calcu_p_actor##GUSTAVO  ///
	calcu_p_actor##CORRAL  ///
	calcu_p_actor##AGUSTIN  ///
	calcu_p_actor##MARGARITA  ///
	calcu_p_actor##LUPITA  ///
	calcu_p_actor##ISAAC  ///
	calcu_p_actor##HIGUERA  ///
	calcu_p_actor##DOCTOR  ///
	calcu_p_actor##CESAR if dia_tratamiento==1, robust 	
estadd scalar Erre=e(r2)



esttab using "$directorio\Results\Results_2\Effect\Conciliator.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" ) replace 
	

***************************************


*Controlling with answers of employee in entrance survey

	*Summary Statistics of controls
log using "$directorio\Results\Results_2\Effect\SS_control_survey.smcl", replace	
su i.ea3_enojo i.ea4_compra i.ea5_estudios i.ea6_trabaja i.ea7_busca_trabajo
log close

eststo clear

eststo: reg convenio i.calcu_p_actora  ///
	i.ea3_enojo i.ea4_compra i.ea5_estudios i.ea6_trabaja i.ea7_busca_trabajo, robust
estadd scalar Erre=e(r2)

eststo: reg convenio  i.calcu_p_dem ///
	i.ea3_enojo i.ea4_compra i.ea5_estudios i.ea6_trabaja i.ea7_busca_trabajo, robust
estadd scalar Erre=e(r2)

eststo: reg convenio i.calcu_p_actora i.calcu_p_dem ///
	i.ea3_enojo i.ea4_compra i.ea5_estudios i.ea6_trabaja i.ea7_busca_trabajo, robust
estadd scalar Erre=e(r2)


esttab using "$directorio\Results\Results_2\Effect\Answers_employee.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" ) replace 
	
	
***************************************

preserve	
*Merge with iniciales DB
keep if num_actores==1 
rename expediente exp
duplicates drop  exp anio junta, force

merge 1:1 exp anio junta using "$directorio\DB\DB2\Iniciales_wod.dta", keep(3)


*Controlling with iniciales

	*Summary Statistics of controls
sutex dummy_gen  c_antiguedad  c_indem dummy_reinst tipo_abogado_ac, nobs minmax replace ///
	file("$directorio\Results\Results_2\Effect\iniciales.tex") ///
	title("Covariates iniciales") 

eststo clear

eststo: reg convenio  i.calcu_p_actora ///
	dummy_gen  c_antiguedad  c_indem dummy_reinst tipo_abogado_ac, robust
estadd scalar Erre=e(r2)

eststo: reg convenio  i.calcu_p_dem ///
	dummy_gen  c_antiguedad  c_indem dummy_reinst tipo_abogado_ac, robust
estadd scalar Erre=e(r2)	

eststo: reg convenio  i.calcu_p_actora i.calcu_p_dem ///
	dummy_gen  c_antiguedad  c_indem dummy_reinst tipo_abogado_ac, robust
estadd scalar Erre=e(r2)	


esttab using "$directorio\Results\Results_2\Effect\Control_iniciales.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" ) replace 
	

*Take up treatment regression
	
eststo clear

eststo: reg calcu_p_actora ///
	dummy_gen  c_antiguedad  c_indem dummy_reinst tipo_abogado_ac ///
	if dia_tratamiento==1 , robust
estadd scalar Erre=e(r2)
qui su calcu_p_actora if dia_tratamiento==1
estadd scalar DepVarMean=r(mean)


eststo: reg calcu_p_dem  ///
	dummy_gen  c_antiguedad  c_indem dummy_reinst tipo_abogado_ac ///
	if dia_tratamiento==1, robust
estadd scalar Erre=e(r2)
qui su calcu_p_dem if dia_tratamiento==1
estadd scalar DepVarMean=r(mean)


eststo: reg dummy_calculadora_partes  ///
	dummy_gen  c_antiguedad  c_indem dummy_reinst tipo_abogado_ac ///
	if dia_tratamiento==1, robust
estadd scalar Erre=e(r2)
qui su dummy_calculadora_partes if dia_tratamiento==1
estadd scalar DepVarMean=r(mean)

esttab using "$directorio\Results\Results_2\Effect\Take_up.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean") replace 
	

restore	

***************************************

