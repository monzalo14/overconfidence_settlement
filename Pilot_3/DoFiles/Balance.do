

use "$directorio\DB\treatment_data.dta", clear

********************************************************************************
*Balance test of treatment assignment 

drop if grupo_tratamiento=="0"
egen treatment=group(grupo_tratamiento)

*Varlist 
local balance_all_vlist mujer prob_ganar cantidad_ganar sueldo  salario_diario ///
	retail outsourcing mon_tue 
	
local balance_23_vlist	high_school angry diurno top_sue big_size ///
	reclutamiento dummy_confianza dummy_desc_sem ///
	dummy_prima_dom dummy_desc_ob dummy_sarimssinfo  carta_renuncia dummy_reinst ///
	asistio_cita  confirmo_cita 


orth_out `balance_all_vlist' , ///
				by(treatment)  vce(robust)   bdec(3)  
qui putexcel C5=matrix(r(matrix)) using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
		
local i=5		
foreach var of varlist  `balance_all_vlist' {
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
qui putexcel E`i'=matrix(r(matrix)) using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
		
	
foreach var of varlist `balance_23_vlist' {
	mvtest means `var' , by(treatment) 
	local pval=round(`r(p_F)',.001)
	local pval : di %3.2f `pval'
	qui putexcel G`i'=(`pval') using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
	local i=`i'+1
	}

		
	
use "$directorio\DB\treatment_data.dta", clear

drop if grupo_tratamiento=="0"
egen treatment=group(grupo_tratamiento)

	
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


********************************************************************************
*Balance test of treatment assignment from 2017-06-15 

keep if date>=date("2017-06-15" , "YMD")

*Varlist 
local balance_all_vlist mujer prob_ganar cantidad_ganar sueldo  salario_diario ///
	retail outsourcing mon_tue 
	
local balance_23_vlist	high_school angry diurno top_sue big_size ///
	reclutamiento dummy_confianza dummy_desc_sem ///
	dummy_prima_dom dummy_desc_ob dummy_sarimssinfo  carta_renuncia dummy_reinst ///
	asistio_cita  confirmo_cita 


orth_out `balance_all_vlist' , ///
				by(treatment)  vce(robust)   bdec(3)  
qui putexcel C5=matrix(r(matrix)) using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
		
local i=5		
foreach var of varlist  `balance_all_vlist' {
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
qui putexcel E`i'=matrix(r(matrix)) using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
		
	
foreach var of varlist `balance_23_vlist' {
	mvtest means `var' , by(treatment) 
	local pval=round(`r(p_F)',.001)
	local pval : di %3.2f `pval'
	qui putexcel G`i'=(`pval') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
	local i=`i'+1
	}

		
	
use "$directorio\DB\treatment_data.dta", clear

drop if grupo_tratamiento=="0"
egen treatment=group(grupo_tratamiento)
keep if date>=date("2017-06-15" , "YMD")

	
*Observations

qui count if treatment==1 
qui putexcel C`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
qui count if treatment==2		
qui putexcel D`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
qui count if treatment==3	
qui putexcel E`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
qui count if treatment==4	
qui putexcel F`i'=(`r(N)') using "$directorio\Tables\Balance.xlsx", sheet("Balance_c") modify
	
	
