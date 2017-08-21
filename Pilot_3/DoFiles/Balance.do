

use "$directorio\DB\treatment_data.dta", clear

********************************************************************************
*Balance test of treatment assignment 

drop if grupo_tratamiento=="0"
egen treatment=group(grupo_tratamiento)

*Varlist 
local balance_all_vlist mujer prob_ganar na_prob prob_mayor na_prob_mayor ///
	cantidad_ganar na_cant  cant_mayor na_cant_mayor sueldo  salario_diario ///
	retail outsourcing mon_tue 
	
local balance_23_vlist	horas_sem dias_sal_dev ///
	antigedad high_school angry diurno top_sue big_size ///
	reclutamiento dummy_confianza dummy_desc_sem ///
	dummy_prima_dom dummy_desc_ob dummy_sarimssinfo  carta_renuncia dummy_reinst 


orth_out `balance_all_vlist' , ///
				by(treatment)  vce(robust)   bdec(3)  
qui putexcel J5=matrix(r(matrix)) using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
		
local i=5		
foreach var of varlist  `balance_all_vlist' {
	di "`var'"
	mvtest means `var' , by(treatment) 
	local pval=round(`r(p_F)',.001)
	local pval : di %3.2f `pval'
	qui putexcel G`i'=(`pval') using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
	local i=`i'+1
	}

**********************************************	

keep if inrange(treatment,3,4)	

orth_out `balance_23_vlist' , ///
				by(treatment)  vce(robust)   bdec(3)  
qui putexcel L`i'=matrix(r(matrix)) using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
		
	
foreach var of varlist `balance_23_vlist' {
	di "`var'"
	capture noi mvtest means `var' , by(treatment) 
	if _rc==0 {
		local pval=round(`r(p_F)',.001)
		}
	else {
		ttest `var', by(treatment) 
		local pval=round(`r(p)',.001)
		}
	local pval : di %3.2f `pval'
	qui putexcel G`i'=(`pval') using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
	local i=`i'+1
	}

		
	
use "$directorio\DB\treatment_data.dta", clear

drop if grupo_tratamiento=="0"
egen treatment=group(grupo_tratamiento)
*Number of days each treatment occured
by grupo_tratamiento fecha_alta, sort: gen nvals = _n ==1
by grupo_tratamiento: egen num_days=sum(nvals)

*Number of days
qui su num_days if treatment==1 
qui putexcel C`i'=(`r(mean)') using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
qui su num_days if treatment==2		
qui putexcel D`i'=(`r(mean)') using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
qui su num_days if treatment==3	
qui putexcel E`i'=(`r(mean)') using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
qui su num_days if treatment==4	
qui putexcel F`i'=(`r(mean)') using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify

local i=`i'+1
	
*Observations
qui count if treatment==1 
qui putexcel C`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
qui count if treatment==2		
qui putexcel D`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
qui count if treatment==3	
qui putexcel E`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
qui count if treatment==4	
qui putexcel F`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
	
		
********************************************************************************
********************************************************************************
********************************************************************************

use "$directorio\DB\treatment_data.dta", clear
********************************************************************************
*Balance test of treatment assignment from 2017-06-15 
drop if grupo_tratamiento=="0"
egen treatment=group(grupo_tratamiento)
keep if date>=date("2017-06-15" , "YMD")


orth_out `balance_all_vlist' , ///
				by(treatment)  vce(robust)   bdec(3)  
qui putexcel J5=matrix(r(matrix)) using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
		
local i=5		
foreach var of varlist  `balance_all_vlist' {
	di "`var'"
	mvtest means `var' , by(treatment) 
	local pval=round(`r(p_F)',.001)
	local pval : di %3.2f `pval'
	qui putexcel G`i'=(`pval') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
	local i=`i'+1
	}

**********************************************	

keep if inrange(treatment,3,4)	

orth_out `balance_23_vlist' , ///
				by(treatment)  vce(robust)   bdec(3)  
qui putexcel L`i'=matrix(r(matrix)) using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
		
	
foreach var of varlist `balance_23_vlist' {
	di "`var'"
	capture noi mvtest means `var' , by(treatment) 
	if _rc==0 {
		local pval=round(`r(p_F)',.001)
		}
	else {
		ttest `var', by(treatment) 
		local pval=round(`r(p)',.001)
		}
	local pval : di %3.2f `pval'
	qui putexcel G`i'=(`pval') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
	local i=`i'+1
	}

		
	
use "$directorio\DB\treatment_data.dta", clear

drop if grupo_tratamiento=="0"
egen treatment=group(grupo_tratamiento)
keep if date>=date("2017-06-15" , "YMD")
*Number of days each treatment occured
by grupo_tratamiento fecha_alta, sort: gen nvals = _n ==1
by grupo_tratamiento: egen num_days=sum(nvals)

*Number of days
qui su num_days if treatment==1 
qui putexcel C`i'=(`r(mean)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
qui su num_days if treatment==2		
qui putexcel D`i'=(`r(mean)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
qui su num_days if treatment==3	
qui putexcel E`i'=(`r(mean)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
qui su num_days if treatment==4	
qui putexcel F`i'=(`r(mean)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify

local i=`i'+1
	
*Observations
qui count if treatment==1 
qui putexcel C`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
qui count if treatment==2		
qui putexcel D`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
qui count if treatment==3	
qui putexcel E`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
qui count if treatment==4	
qui putexcel F`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
	
	
********************************************************************************
********************************************************************************
********************************************************************************


use "$directorio\DB\treatment_data.dta", clear
********************************************************************************
*Balance test of treatment assignment from July
drop if grupo_tratamiento=="0"
egen treatment=group(grupo_tratamiento)
keep if date>=date("2017-07-01" , "YMD")


orth_out `balance_all_vlist' , ///
				by(treatment)  vce(robust)   bdec(3)  
qui putexcel J5=matrix(r(matrix)) using "$directorio\Tables\Balance.xlsx", sheet("Balance_july") modify
		
local i=5		
foreach var of varlist  `balance_all_vlist' {
	di "`var'"
	mvtest means `var' , by(treatment) 
	local pval=round(`r(p_F)',.001)
	local pval : di %3.2f `pval'
	qui putexcel G`i'=(`pval') using "$directorio\Tables\Balance.xlsx", sheet("Balance_july") modify
	local i=`i'+1
	}

**********************************************	

keep if inrange(treatment,3,4)	

orth_out `balance_23_vlist' , ///
				by(treatment)  vce(robust)   bdec(3)  
qui putexcel L`i'=matrix(r(matrix)) using "$directorio\Tables\Balance.xlsx", sheet("Balance_july") modify
		
	
foreach var of varlist `balance_23_vlist' {
	di "`var'"
	capture noi mvtest means `var' , by(treatment) 
	if _rc==0 {
		local pval=round(`r(p_F)',.001)
		}
	else {
		ttest `var', by(treatment) 
		local pval=round(`r(p)',.001)
		}
	local pval : di %3.2f `pval'
	qui putexcel G`i'=(`pval') using "$directorio\Tables\Balance.xlsx", sheet("Balance_july") modify
	local i=`i'+1
	}

		
	
use "$directorio\DB\treatment_data.dta", clear

drop if grupo_tratamiento=="0"
egen treatment=group(grupo_tratamiento)
keep if date>=date("2017-07-01" , "YMD")
*Number of days each treatment occured
by grupo_tratamiento fecha_alta, sort: gen nvals = _n ==1
by grupo_tratamiento: egen num_days=sum(nvals)

*Number of days
qui su num_days if treatment==1 
capture noi qui putexcel C`i'=(`r(mean)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_july") modify
qui su num_days if treatment==2		
capture noi qui putexcel D`i'=(`r(mean)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_july") modify
qui su num_days if treatment==3	
capture noi qui putexcel E`i'=(`r(mean)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_july") modify
qui su num_days if treatment==4	
capture noi qui putexcel F`i'=(`r(mean)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_july") modify

local i=`i'+1
	
*Observations
qui count if treatment==1 
qui putexcel C`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_july") modify
qui count if treatment==2		
qui putexcel D`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_july") modify
qui count if treatment==3	
qui putexcel E`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_july") modify
qui count if treatment==4	
qui putexcel F`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_july") modify
	
	
